create or replace package app_workflow_step_pkg as

  procedure p_insert_app_workflow_step(pi_action          in app_workflow_step.action%type default v('P10130_ACTION'),
                                       pi_request         in app_workflow_step.request%type default v('P10130_REQUEST'),
                                       pi_status          in app_workflow_step.status%type default v('P10130_STATUS'),
                                       pi_next_page       in app_workflow_step.next_page%type default v('P10130_NEXT_PAGE'),
                                       pi_prev_step_id    in app_workflow_step.prev_step_id%type default v('P10130_PREV_STEP_ID'),
                                       pi_app_workflow_id in app_workflow_step.app_workflow_id%type default v('P10130_APP_WORKFLOW_ID'));

  procedure p_update_app_workflow_step(pi_id              in app_workflow_step.id%type default v('P10130_ID'),
                                       pi_action          in app_workflow_step.action%type default v('P10130_ACTION'),
                                       pi_request         in app_workflow_step.request%type default v('P10130_REQUEST'),
                                       pi_status          in app_workflow_step.status%type default v('P10130_STATUS'),
                                       pi_next_page       in app_workflow_step.next_page%type default v('P10130_NEXT_PAGE'),
                                       pi_prev_step_id    in app_workflow_step.prev_step_id%type default v('P10130_PREV_STEP_ID'),
                                       pi_app_workflow_id in app_workflow_step.app_workflow_id%type default v('P10130_APP_WORKFLOW_ID'));

  procedure p_delete_app_workflow_step(pi_id in app_workflow_step.id%type default v('P10130_ID'));

  procedure p_get_app_workflow_step(pi_id in app_workflow_step.id%type default v('P10130_ID'));

end app_workflow_step_pkg;
/
create or replace package body app_workflow_step_pkg as

  procedure p_insert_app_workflow_step(pi_action          in app_workflow_step.action%type default v('P10130_ACTION'),
                                       pi_request         in app_workflow_step.request%type default v('P10130_REQUEST'),
                                       pi_status          in app_workflow_step.status%type default v('P10130_STATUS'),
                                       pi_next_page       in app_workflow_step.next_page%type default v('P10130_NEXT_PAGE'),
                                       pi_prev_step_id    in app_workflow_step.prev_step_id%type default v('P10130_PREV_STEP_ID'),
                                       pi_app_workflow_id in app_workflow_step.app_workflow_id%type default v('P10130_APP_WORKFLOW_ID')) as
  begin
  
    insert into app_workflow_step
      (action,
       request,
       status,
       next_page,
       prev_step_id,
       app_workflow_id)
    values
      (pi_action,
       pi_request,
       pi_status,
       pi_next_page,
       pi_prev_step_id,
       pi_app_workflow_id);
  
  exception
    when others then
      logger.log_error();
      raise;
  end p_insert_app_workflow_step;

  procedure p_update_app_workflow_step(pi_id              in app_workflow_step.id%type default v('P10130_ID'),
                                       pi_action          in app_workflow_step.action%type default v('P10130_ACTION'),
                                       pi_request         in app_workflow_step.request%type default v('P10130_REQUEST'),
                                       pi_status          in app_workflow_step.status%type default v('P10130_STATUS'),
                                       pi_next_page       in app_workflow_step.next_page%type default v('P10130_NEXT_PAGE'),
                                       pi_prev_step_id    in app_workflow_step.prev_step_id%type default v('P10130_PREV_STEP_ID'),
                                       pi_app_workflow_id in app_workflow_step.app_workflow_id%type default v('P10130_APP_WORKFLOW_ID')) as
  begin
  
    update app_workflow_step s
       set s.action          = pi_action,
           s.request         = pi_request,
           s.status          = pi_status,
           s.next_page       = pi_next_page,
           s.prev_step_id    = pi_prev_step_id,
           s.app_workflow_id = pi_app_workflow_id
     where s.id = pi_id;
  
  exception
    when others then
      logger.log_error();
      raise;
  end p_update_app_workflow_step;

  procedure p_delete_app_workflow_step(pi_id in app_workflow_step.id%type default v('P10130_ID')) as
  begin
  
    delete app_workflow_step s
     where s.id = pi_id;
  
  exception
    when others then
      logger.log_error();
      raise;
  end p_delete_app_workflow_step;

  procedure p_get_app_workflow_step(pi_id in app_workflow_step.id%type default v('P10130_ID')) as
    l_row app_workflow_step%rowtype;
  begin
  
    select *
      into l_row
      from app_workflow_step s
     where s.id = pi_id;
  
    -- NoFormat Start
    apex_util.set_session_state('P10130_ACTION', l_row.action);
    apex_util.set_session_state('P10130_REQUEST', l_row.request);
    apex_util.set_session_state('P10130_STATUS', l_row.status);
    apex_util.set_session_state('P10130_NEXT_PAGE', l_row.next_page);
    apex_util.set_session_state('P10130_PREV_STEP_ID', l_row.prev_step_id);
    apex_util.set_session_state('P10130_APP_WORKFLOW_ID', l_row.app_workflow_id);
    apex_util.set_session_state('P10130_CREATE_USER', l_row.create_user);
    apex_util.set_session_state('P10130_CREATE_DATE', l_row.create_date);
    apex_util.set_session_state('P10130_UPDATE_USER', l_row.update_user);
    apex_util.set_session_state('P10130_UPDATE_DATE', l_row.update_date);
    -- NoFormat End
  
  exception
    when others then
      logger.log_error();
      raise;
  end p_get_app_workflow_step;

end app_workflow_step_pkg;
/
