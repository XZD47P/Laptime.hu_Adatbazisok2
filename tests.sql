---------------------------
--        TESTING        --
---------------------------

--time_to_millisecond
DECLARE
  v_result  NUMBER;
BEGIN
  v_result:= time_to_milliseconds(p_time => '1:21.046');
  dbms_output.put_line('A kozvetlen bevitel erteke: ' || v_result || 'ms');
  
END;
/


--fn_get_user_id
DECLARE
  v_result NUMBER;
BEGIN
  v_result:= fn_get_user_id(p_email => 'peter.hajdu@gmail.com');
  dbms_output.put_line('A kert user ID-ja: '|| v_result);
END;
/

--fn_get_motorsport_id
DECLARE
  v_result NUMBER;
BEGIN
  v_result:= fn_get_motorsport_id(p_motorsport_name => LOWER('foRMulA-1'));
  dbms_output.put_line('A kert motorsport ID-ja: '|| v_result);
END;
/
