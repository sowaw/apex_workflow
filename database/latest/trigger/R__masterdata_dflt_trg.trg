create or replace trigger MASTERDATA_DFLT_TRG
  before insert or update
  on masterdata 
  for each row
begin
  if inserting then
    :new.create_user := nvl(v('APP_USER'), user);
  elsif updating then 
     :new.update_user := nvl(v('APP_USER'), user);
     :new.update_date := sysdate;
  end if;
end MASTERDATA_DFLT_TRG;