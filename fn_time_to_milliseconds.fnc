create or replace function time_to_milliseconds(p_time VARCHAR2) return number is
v_millisec NUMBER;
v_minutes NUMBER;
v_seconds NUMBER;
begin
  
  v_minutes:=TO_NUMBER(SUBSTR(STR1 => p_time,POS => 1,LEN => INSTR(STR1 => p_time,STR2 => ':')-1));
  v_seconds:=TO_NUMBER(SUBSTR(STR1 => p_time,POS => INSTR(STR1 => p_time,STR2 => ':')+1));
  
  v_millisec:=(v_minutes*60*1000)+(v_seconds*1000);

  RETURN v_millisec;

EXCEPTION
  WHEN OTHERS THEN
    raise_application_error(-20010,'Invalid time format! Expected format: MM:SS.FFF ');
end time_to_milliseconds;
/
