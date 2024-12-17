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
