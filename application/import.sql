whenever sqlerror exit sql.sqlcode rollback
whenever oserror exit failure


declare
  l_workspace_id number;
begin
  l_workspace_id := apex_util.find_security_group_id(p_workspace => 'WORKFLOW');
  apex_util.set_security_group_id(p_security_group_id => l_workspace_id);
  apex_application_install.set_schema('WORKFLOW');
  apex_util.pause(2);
end;
/

@f100.sql

exit
