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

--fn_get_chatroom_activity
DECLARE
v_list ty_chatroom_activity_l;
BEGIN
  v_list:=fn_get_chatroom_activity();
  
  for i IN 1..v_list.count
    LOOP
      dbms_output.put_line('chatroom_name= '|| v_list(i).chatroom_name
                        || ', users_used= ' || v_list(i).users_used);
    END LOOP;
END;
/

--send_message procedure
BEGIN
  send_message(p_chatroom_name => 'formula-1 igazolasol',
               p_email => 'zoltan.kuti@gmail.com',
               p_message => 'Meglepo igazolas!');
END;
/

--pkg_user.add_user
BEGIN
  pkg_race.add_race(p_motorsport => 'formula-1',
                    p_title => 'FORMULA 1 GULF AIR BAHRAIN GRAND PRIX 2025',
                    p_track => 'Bahrain International Circuit',
                    p_start_date => TO_DATE('2025.02.29.', 'YYYY.MM.DD.'),
                    p_end_date => TO_DATE('2025.03.02.', 'YYYY.MM.DD.'),
                    p_record_time => '1:31.447',
                    p_air_temp => 24,
                    p_asp_temp => 27,
                    p_wind_dir => 'EK',
                    p_wind_strenght => 15,
                    p_rain_percent => 40);
END;
/
--There are other procedures inside the packages!
