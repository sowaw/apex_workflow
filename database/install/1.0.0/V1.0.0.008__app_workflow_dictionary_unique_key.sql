alter table APP_WORKFLOW_DICTIONARY
  add constraint APP_WORKFLOW_DICTIONARY_UK unique (DICTIONARY_NAME, ENTRY_TEXT);