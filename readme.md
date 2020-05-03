# APEX Workflow 1.0.0

## About
This project is dedicated for APEX applications that need to be flexible in terms of workflow that meets the business needs. Based on prepared set of application pages, it is possible to follow the idea of **Citizen Development**. Using simple configuration pages, business analyst or other stakeholder can adjust behavior of the application easily. 

> Project assumes workflow configuration based on changing status of business object, where particular action causes page redirect from one to another. In addition, status can be changed only by user having necessary role. APEX Workflow uses configuration tables of available statuses, actions and allowed user roles.


---

## Prerequisites
* do not use **Administration** page group for pages of your application - it is reserved for app administration pages, including **Workflow Configuration** module
* your application is allowed to implement one workflow (it refers to version 1.0.0)
* your workflow pages must have unique button names (not labels) in the whole set 
* PL/SQL packages use Logger functionalities. Make sure that your target schema has grants to Logger objects and synonyms were created. LOGGER schema name is expected
* implemented engine-like workflow assumes existing following APEX items of **Hidden** type residing on **Page 0**:
   
   1. P0_STATUS
   2. P0_NEXT_PAGE
   3. P0_ROLE - set this item using your role management mechanism

---

## Project Structure
### Tables
* APP_WORKFLOW
* APP_WORKFLOW_STEP
* APP_WORKFLOW_DICTIONARY


### Packages
* APP_WORKFLOW_PKG
* APP_WORKFLOW_STEP_PKG

---

## How To Use 

1. Import application file into your APEX workspace, including Supporting Objects.

2. Create APEX pages that will be used for workflow in you application. Every of them must have process and branch dedicated strictly for workflow: 

    * Page Process (the lowest sequcence number of it on the page level is mandatory!)
      * Name: **Workflow Process**  
      * Type: **PL/SQL Code**
      * Code: **app_workflow_pkg.p_process_workflow;**
      * If particular page is responsible for additional processes, and still you want to perform non-workflow operations, you can change the status of business object using dedicated procedure 
      ```sql
        if :REQUEST not in ('BTN_SAVE', 'BTN_APPLY') then
            app_workflow_pkg.p_change_status(pi_table_name => 'masterdata',
                                             pi_id_col     => 'id',
                                             pi_id         => :P102_ID);
        end if;                                 
      ```
      Code listed above means that if any of application workflow buttons were clicked, then do the change of the status of business objects - in the example, called _Masterdata_, where column responsible for primary key is called _ID_ with value of :P102_ID item..

    * Page Branch 
      * Name: **Workflow Branch**  
      * Type: **Page Identified by Item (Show only)**
      * Item: **P0_NEXT_PAGE**
      * Server-side Condition: **Item is NOT NULL** - **P0_NEXT_PAGE**

    > Non-workflow branches should include Server-side Condition **Item is NULL** - **P0_NEXT_PAGE**

    > Your data fetch processes executed on page load should set the **P0_STATUS** to the current status of your business object

    > Your CRUD processes should get **P0_STATUS** item value for SQL Inserts and Updates 


 3. Configure workflow of your application. 
    
    * Go to **Administation** section, then select **Workflow Configuration** card.
    * Create a new workflow by giving it a name as you want. 
    * In **Dictionaries Setup** provide names of actions, statuses and allowed user roles. 
    * Add workflow step and fill all field related to the particular one. 
    [![1.png](https://i.postimg.cc/wBkXbDLZ/1.png)](https://postimg.cc/Ny52K9Nk)

4. In Shared Components section create a new Authorization Scheme

    * Name: **Workflow Authorization**
    * Scheme Type: **PL/SQL Function Returning Boolean**
    * PL/SQL Function Body:
        ``` sql
        return app_workflow_pkg.f_workflow_authorization(pi_page_id        => :APP_PAGE_ID,
                                                         pi_component_name => :APP_COMPONENT_NAME,
                                                         pi_component_type => :APP_COMPONENT_TYPE,
                                                         pi_component_id   => :APP_COMPONENT_ID,
                                                         pi_user_role      => :P0_ROLE);
        ```
    * Error message: **Workflow Authorization Error**
    * Validate authorization scheme: **Always (No Caching) or Once per component**
    
    > Every button included in workflow process should have this authorization scheme set. 

5. _Edit Page_ property be used in workflows which assumes editing the business object on others page depending on its status or other requirements. In order to use this feature on your report and redirect user to the right page you can follow example listed below: 

    ```sql
    select '<a href="' || apex_util.prepare_url('f?p=&APP_ID.:' ||
                                                app_workflow_step_pkg.f_get_edit_page(pi_status => m.status) ||
                                                ':&APP_SESSION.::::P' ||app_workflow_step_pkg.f_get_edit_page (pi_status => m.status) || '_ID:' || m.id) ||
           '"><img src="#IMAGE_PREFIX#app_ui/img/icons/apex-edit-page.png" class="apex-edit-page report-link-button"  title="Edit" alt="Edit">
           </a>' as link,
           m.id,
           m.description,
           m.status,
           m.create_user,
           m.create_date,
           m.update_user,
           m.update_date
      from masterdata m;
    ```

    > To keep the previous step - next step relation, use _Preivous Step_ property to select which action is happening before step being currently configured. 