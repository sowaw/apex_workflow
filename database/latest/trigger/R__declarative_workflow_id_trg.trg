create or replace trigger DECLARATIVE_WORKFLOW_ID_TRG
  before insert
  on declarative_workflow 
  for each row
  when (new.step_id is null)
begin
  if inserting then
    :new.step_id := DECLARATIVE_WORKFLOW_SEQ.nextval;
  end if;
end DECLARATIVE_WORKFLOW_ID_TRG;