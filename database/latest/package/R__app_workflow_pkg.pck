create or replace package app_workflow_pkg as

  procedure p_insert_app_workflow(po_id          out app_workflow.id%type,
                                  pi_description in app_workflow.description%type default v('P10110_DESCRIPTION'));

  procedure p_update_app_workflow(pi_id          in app_workflow.id%type default v('P10110_ID'),
                                  pi_description in app_workflow.description%type default v('P10110_DESCRIPTION'));

  procedure p_delete_app_workflow(pi_id in app_workflow.id%type default v('P10110_ID'));

end app_workflow_pkg;
/
create or replace package body app_workflow_pkg as

  procedure p_insert_app_workflow(po_id          out app_workflow.id%type,
                                  pi_description in app_workflow.description%type default v('P10110_DESCRIPTION')) as
  begin
    null;
  exception
    when others then
      logger.log_error();
      raise;
  end p_insert_app_workflow;

  procedure p_update_app_workflow(pi_id          in app_workflow.id%type default v('P10110_ID'),
                                  pi_description in app_workflow.description%type default v('P10110_DESCRIPTION')) as
  begin
    null;
  exception
    when others then
      logger.log_error();
      raise;
  end p_update_app_workflow;

  procedure p_delete_app_workflow(pi_id in app_workflow.id%type default v('P10110_ID')) as
  begin
    null;
  exception
    when others then
      logger.log_error();
      raise;
  end p_delete_app_workflow;

end app_workflow_pkg;
/
