create or replace package app_workflow_pkg as

  procedure p_insert_app_workflow(po_id          out app_workflow.id%type,
                                  pi_description in app_workflow.description%type default v('P10110_DESCRIPTION'));

  procedure p_update_app_workflow(pi_id          in app_workflow.id%type default v('P10120_ID'),
                                  pi_description in app_workflow.description%type default v('P10120_DESCRIPTION'));

  procedure p_delete_app_workflow(pi_id in app_workflow.id%type default v('P10120_ID'));

  procedure p_get_app_workflow(pi_id in app_workflow.id%type default v('P10120_ID'));

  procedure p_process_workflow(pi_request in varchar2 default v('REQUEST'));

  function f_workflow_authorization(pi_page_id        in number default v('APP_PAGE_ID'),
                                    pi_component_name in varchar2 default v('APP_COMPONENT_NAME'),
                                    pi_component_type in varchar2 default v('APP_COMPONENT_TYPE'),
                                    pi_component_id   in varchar2 default v('APP_COMPONENT_ID'),
                                    pi_user_role      in varchar2 default v('P0_ROLE'),
                                    pi_status         in varchar2 default v('P0_STATUS'))
    return boolean;

  procedure p_change_status(pi_table_name in varchar2,
                            pi_id_col     in varchar2,
                            pi_id         in number,
                            pi_status     in varchar2 default v('P0_STATUS'));

end app_workflow_pkg;
/
create or replace package body app_workflow_pkg as

  procedure p_insert_app_workflow(po_id          out app_workflow.id%type,
                                  pi_description in app_workflow.description%type default v('P10110_DESCRIPTION')) as
  begin
  
    insert into app_workflow
      (description)
    values
      (pi_description)
    returning id into po_id;
  
  exception
    when others then
      logger.log_error();
      raise;
  end p_insert_app_workflow;

  procedure p_update_app_workflow(pi_id          in app_workflow.id%type default v('P10120_ID'),
                                  pi_description in app_workflow.description%type default v('P10120_DESCRIPTION')) as
  begin
  
    update app_workflow w
       set w.description = pi_description
     where w.id = pi_id;
  
  exception
    when others then
      logger.log_error();
      raise;
  end p_update_app_workflow;

  procedure p_delete_app_workflow(pi_id in app_workflow.id%type default v('P10120_ID')) as
  begin
  
    delete app_workflow w
     where w.id = pi_id;
  
  exception
    when others then
      logger.log_error();
      raise;
  end p_delete_app_workflow;

  procedure p_get_app_workflow(pi_id in app_workflow.id%type default v('P10120_ID')) as
    l_row app_workflow%rowtype;
  begin
  
    select *
      into l_row
      from app_workflow w
     where w.id = pi_id;
  
    -- NoFormat Start
    apex_util.set_session_state('P10120_DESCRIPTION', l_row.description);
    apex_util.set_session_state('P10120_CREATE_USER', l_row.create_user);
    apex_util.set_session_state('P10120_CREATE_DATE', l_row.create_date);
    apex_util.set_session_state('P10120_UPDATE_USER', l_row.update_user);
    apex_util.set_session_state('P10120_UPDATE_DATE', l_row.update_date);
     -- NoFormat End
  
  exception
    when others then
      logger.log_error();
      raise;
  end p_get_app_workflow;

  procedure p_process_workflow(pi_request in varchar2 default v('REQUEST')) as
    l_row         app_workflow_step%rowtype;
    l_target_url  varchar(500) := null;
    l_query_count number := 0;
  begin
  
    select count(1)
      into l_query_count
      from app_workflow_step s
     where s.request = pi_request;
  
    if l_query_count > 0 then
      select *
        into l_row
        from app_workflow_step s
       where s.request = pi_request;
    
      logger.log(l_row.status);
      logger.log(l_row.next_page);
    
      -- NoFormat Start
      apex_util.set_session_state('P0_STATUS', l_row.status);
      apex_util.set_session_state('P0_NEXT_PAGE', l_row.next_page);
      -- NoFormat End
    else
      apex_util.set_session_state('P0_NEXT_PAGE', '');
    end if;
  
  exception
    when others then
      logger.log_error();
      raise;
  end p_process_workflow;

  function f_workflow_authorization(pi_page_id        in number default v('APP_PAGE_ID'),
                                    pi_component_name in varchar2 default v('APP_COMPONENT_NAME'),
                                    pi_component_type in varchar2 default v('APP_COMPONENT_TYPE'),
                                    pi_component_id   in varchar2 default v('APP_COMPONENT_ID'),
                                    pi_user_role      in varchar2 default v('P0_ROLE'),
                                    pi_status         in varchar2 default v('P0_STATUS'))
    return boolean as
    l_rowcount number := 0;
  begin
    select count(1)
      into l_rowcount
      from app_workflow_step s
     where level = (select min(level)
                      from app_workflow_step s
                     where s.status = pi_status
                     start with s.prev_step_id is null
                    connect by prior s.id = s.prev_step_id) + 1
       and s.prev_step_id = (select min(s.id)
                               from app_workflow_step s
                              where s.status = pi_status)
       and s.role = pi_user_role
       and s.request = pi_component_name   
     start with s.prev_step_id is null
    connect by prior s.id = s.prev_step_id;
  
    if l_rowcount > 0 then
      return true;
    else
      return false;
    end if;
  
  exception
    when others then
      logger.log_error();
      return false;
  end f_workflow_authorization;

  procedure p_change_status(pi_table_name in varchar2,
                            pi_id_col     in varchar2,
                            pi_id         in number,
                            pi_status     in varchar2 default v('P0_STATUS')) as
    l_sql varchar2(4000);
  
  begin
  
    l_sql := 'update ' || pi_table_name || ' set status = ''' || pi_status || ''' where ' ||
             pi_id_col || ' = ' || pi_id;
  
    execute immediate l_sql;
  exception
    when others then
      logger.log_error();
      raise;
  end p_change_status;

end app_workflow_pkg;
/
