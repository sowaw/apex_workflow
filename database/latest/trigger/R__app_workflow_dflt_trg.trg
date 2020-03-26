create or replace trigger APP_WORKFLOW_DFLT_TRG
  before insert or update
  on app_workflow 
  for each row
begin
  if inserting then
    :new.create_user := nvl(v('APP_USER'), user);
  elsif updating then 
     :new.update_user := nvl(v('APP_USER'), user);
     :new.update_date := sysdate;
  end if;
end APP_WORKFLOW_DFLT_TRG;