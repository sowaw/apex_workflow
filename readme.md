# APEX Workflow 1.0.0

## About
This project is dedicated for APEX applications that need to be flexible in terms of workflow that meets the business needs. Based on prepared set of application pages, it is possible to follow the idea of **Citizen Development**. Using simple configuration pages, business analyst or other stakeholder can adjust behavior of the application easily. 

> Project assumes workflow configuration based on changing status of business object, where particular action causes page redirect from one to another. In addition, status can be changed only by user having necessary role. APEX Workflow uses configuration tables of available statuses, actions and allowed user roles.


---

## Prerequisites
* do not use **Administration** page group for pages of your application - it is reserved for app administration pages, including **Workflow Configuration** module
* your application is allowed to implement one workflow (it refers to version 1.0.0)
* your workflow pages must have unique button names in the whole set 
* implemented engine-like workflow assumes existing following APEX items of **Hidden** type residing on **Page 0**:
   
   1. P0_STATUS
   2. P0_NEXT_PAGE
   3. P0_ROLE

---

## Project Structure
### Tables
*

### Packages
*

---

## How To Use 

1. Import application file into your APEX workspace, including Supporting Objects.

2. Create APEX pages that will be used for workflow in you application. Every of them must have process and branch dedicated strictly for workflow: 

    * Page Process 
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
      Code listed above means that if any of application workflow buttons were clicked, then do the change of the status of business objects - in the example, called _Masterdata_, where column responsible for primary key is called _ID_.

    * Page Branch 
      * Name: **Workflow Branch**  
      * Type: **Page Identified by Item (Show only)**
      * Item: **P0_NEXT_PAGE**
      * Server-side Condition: **Item is NOT NULL** - **P0_NEXT_PAGE**

    > Non-workflow branches should include Server-side Condition **Item is NULL** - **P0_NEXT_PAGE**

    > Your data fetch processes executed on page load should set the **P0_STATUS** to the current status of your business object. 

 3. Configure workflow of your application. 
    
    * Go to **Administation** section, then select **Workflow Configuration** card.
    * Create a new workflow by giving it a name as you want. 
