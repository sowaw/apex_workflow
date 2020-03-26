create or replace trigger app_workflow_dict_dflt_trg
  before insert or update
  on app_workflow_dictionary 
  for each row
begin
  if inserting then
    :new.create_user := nvl(v('APP_USER'), user);
  elsif updating then 
     :new.update_user := nvl(v('APP_USER'), user);
     :new.update_date := sysdate;
  end if;
end app_workflow_dict_dflt_trg;