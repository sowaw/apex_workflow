create or replace package APEX_APP_UTILS_PKG as

  c_server_side_condition constant varchar(100) := 'SERVER_SIDE_CONDITION';
  c_next_status           constant varchar(100) := 'NEXT_STATUS';
  c_read_only             constant varchar(100) := 'READ_ONLY';
  
  function apex_error_handling_function(p_error in apex_error.t_error) 
    return apex_error.t_error_result;
    
  procedure p_show_success_message(p_message in varchar2);
  
  procedure p_show_error_message(p_message in varchar2);

end APEX_APP_UTILS_PKG;
/
create or replace package body APEX_APP_UTILS_PKG as 

  function apex_error_handling_function(p_error in apex_error.t_error) 
    return apex_error.t_error_result
  as
    l_result          apex_error.t_error_result;
    l_reference_id    number;
    l_constraint_name varchar2(255);
  begin
    l_result := apex_error.init_error_result(p_error => p_error);
    
    if p_error.is_internal_error then
      if not p_error.is_common_runtime_error then
        l_result.message         := 'An unexpected internam application error has occured.';
        l_result.additional_info := null;
      end if;
    else
      l_result.display_location := case 
                                     when l_result.display_location = apex_error.c_on_error_page then apex_error.c_inline_in_notification
                                     else l_result.display_location
                                   end;
    end if;
    
    -- If an ORA error has been raised, for example a raise_application_error(-20xxx, '...')
    if p_error.ora_sqlcode is not null and l_result.message = p_error.message then
      l_result.message := apex_error.get_first_ora_error_text(p_error => p_error);
    end if;
    
    if p_error.ora_sqlcode is not null then
      l_constraint_name := apex_error.extract_constraint_name(p_error => p_error);
      if l_constraint_name is not null then
        l_result.message := apex_lang.message(l_constraint_name);
      end if;
    end if;
    
    -- If no associated page item/tabular form column has been set
    if l_result.page_item_name is null and l_result.column_alias is null then
      apex_error.auto_set_associated_item(p_error => p_error, 
                                          p_error_result => l_result);
    end if;
    
    return l_result;
  end apex_error_handling_function;
  
  procedure p_show_success_message(p_message in varchar2) as 
  begin
    apex_application.g_print_success_message := p_message;
  end p_show_success_message;

  procedure p_show_error_message(p_message in varchar2) as 
  begin
    apex_error.add_error(p_message => p_message, p_display_location => apex_error.c_inline_in_notification);
  end p_show_error_message;

end APEX_APP_UTILS_PKG;