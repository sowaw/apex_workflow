create or replace package masterdata_pkg as

  procedure p_insert_masterdata(pi_description in masterdata.description%type default v('P102_DESCRIPTION'),
                                pi_status      in masterdata.status%type default v('P0_STATUS'));

  procedure p_update_masterdata(pi_id          in masterdata.id%type default v('P102_ID'),
                                pi_description in masterdata.description%type default v('P102_DESCRIPTION'),
                                pi_status      in masterdata.status%type default v('P0_STATUS'));

  procedure p_delete_masterdata(pi_id in masterdata.id%type default v('P102_ID'));

  procedure p_get_masterdata(pi_id in masterdata.id%type default v('P102_ID'));

end masterdata_pkg;
/
create or replace package body masterdata_pkg as

  procedure p_insert_masterdata(pi_description in masterdata.description%type default v('P102_DESCRIPTION'),
                                pi_status      in masterdata.status%type default v('P0_STATUS')) as
  begin
  
    insert into masterdata
      (description,
       status)
    values
      (pi_description,
       pi_status);
  
  exception
    when others then
      logger.log_error;
      raise;
  end p_insert_masterdata;

  procedure p_update_masterdata(pi_id          in masterdata.id%type default v('P102_ID'),
                                pi_description in masterdata.description%type default v('P102_DESCRIPTION'),
                                pi_status      in masterdata.status%type default v('P0_STATUS')) as
  begin
  
    update masterdata m
       set m.description = pi_description,
           m.status      = pi_status
     where m.id = pi_id;
  
  exception
    when others then
      logger.log_error;
      raise;
  end p_update_masterdata;

  procedure p_delete_masterdata(pi_id in masterdata.id%type default v('P102_ID')) as
  begin
  
    delete masterdata m
     where m.id = pi_id;
  
  exception
    when others then
      logger.log_error;
      raise;
  end p_delete_masterdata;

  procedure p_get_masterdata(pi_id in masterdata.id%type default v('P102_ID')) as
    l_row masterdata%rowtype;
  begin
    
  select * into l_row from masterdata m where m.id = pi_id;
  
  apex_util.set_session_state('P102_DESCRIPTION', l_row.description);
  apex_util.set_session_state('P102_STATUS', l_row.status);
  apex_util.set_session_state('P0_STATUS', l_row.status);
  
  exception
    when others then
      logger.log_error;
      raise;
  end p_get_masterdata;

end masterdata_pkg;
/
