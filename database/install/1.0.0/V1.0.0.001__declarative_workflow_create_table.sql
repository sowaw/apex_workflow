-- Create table
create table DECLARATIVE_WORKFLOW
(
  step_id          number(*,0) not null,
  action           varchar2(100) not null,
  request          varchar2(100) not null,
  status           varchar2(100) not null,
  next_page        number(*,0),
  previous_step_id number(*,0)
)
;
