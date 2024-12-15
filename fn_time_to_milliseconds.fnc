create or replace function time_to_milliseconds(p_time VARCHAR2) return number is

v_millisec NUMBER;
v_minutes NUMBER;
v_seconds NUMBER;
c_func_name CONSTANT VARCHAR2(30):='time_to_miliseconds';
begin
  
  v_minutes:=TO_NUMBER(SUBSTR(STR1 => p_time,POS => 1,LEN => INSTR(STR1 => p_time,STR2 => ':')-1));
  v_seconds:=TO_NUMBER(SUBSTR(STR1 => p_time,POS => INSTR(STR1 => p_time,STR2 => ':')+1));
  
  v_millisec:=(v_minutes*60*1000)+(v_seconds*1000);

  RETURN v_millisec;

EXCEPTION
  WHEN OTHERS THEN
    prc_log(p_log_type => 'E'
           ,p_message => 'ORA-20010: Invalid time format! Expected format: MM:SS.FFF'
           ,p_parameters => 'p_time:=' || p_time
           ,p_api => c_func_name);
                  
    raise_application_error(-20010,'Invalid time format! Expected format: MM:SS.FFF ');
end time_to_milliseconds;
/
