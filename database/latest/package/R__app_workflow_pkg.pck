create or replace package app_workflow_pkg as

  procedure p_insert_app_workflow(po_id          out app_workflow.id%type,
                                  pi_description in app_workflow.description%type default v('P10110_DESCRIPTION'));

  procedure p_update_app_workflow(pi_id          in app_workflow.id%type default v('P10120_ID'),
                                  pi_description in app_workflow.description%type default v('P10120_DESCRIPTION'));

  procedure p_delete_app_workflow(pi_id in app_workflow.id%type default v('P10120_ID'));

  procedure p_get_app_workflow(pi_id in app_workflow.id%type default v('P10120_ID'));

  procedure p_process_workflow(pi_request in varchar2 default v('REQUEST'));

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
    
      -- NoFormat Start
      apex_util.set_session_state('P0_STATUS', l_row.status);
      apex_util.set_session_state('P0_NEXT_PAGE', l_row.next_page);
      -- NoFormat End
    
      if l_row.prev_step_id is null then
        l_target_url := apex_util.prepare_url(p_url => 'f?p='|| v('APP_ID') || ':' || l_row.next_page ||
                                                       ':' || v('APP_SESSION') || ':::' || l_row.next_page);
      
--        apex_util.redirect_url(p_url => l_target_url);
      end if;
--    else
--      apex_util.set_session_state('P0_NEXT_PAGE', '');
    end if;
  
  exception
    when others then
      logger.log_error();
      raise;
  end p_process_workflow;

end app_workflow_pkg;
