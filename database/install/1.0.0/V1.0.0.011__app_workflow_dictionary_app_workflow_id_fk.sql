alter table APP_WORKFLOW_DICTIONARY
  add constraint APP_WORKFLOW_DICTIONARY_FK foreign key (APP_WORKFLOW_ID)
  references app_workflow (ID) on delete cascade;