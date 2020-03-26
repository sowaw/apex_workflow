alter table APP_WORKFLOW_STEP
  add constraint APP_WORKFLOW_STEP_FK foreign key (APP_WORKFLOW_ID)
  references APP_WORKFLOW (ID) on delete cascade;