-- Create table
create table APP_WORKFLOW
(
  id          number generated by default on null as identity,
  description varchar2(100) not null,
  create_user varchar2(100) not null,
  create_date date default sysdate not null,
  update_user varchar2(100),
  update_date date
)
;