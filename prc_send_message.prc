create or replace procedure send_message(p_chatroom_name IN VARCHAR2,
                                         p_email IN VARCHAR2,
                                         p_message IN VARCHAR2) 
                                         IS
v_count NUMBER;
v_u_id NUMBER;
v_c_id NUMBER;
BEGIN
  user_exists(p_email => p_email);
  
  SELECT user_id
  INTO v_u_id
  FROM reg_user
  WHERE email=p_email;
  
  SELECT COUNT(*)
  INTO v_count
  FROM chatroom
  WHERE chatroom_name=LOWER(p_chatroom_name);
  
  IF v_count=0
    THEN
      RAISE pkg_exception.chatroom_not_found;
  END IF;
  
  SELECT chatroom_id
  INTO v_c_id
  FROM chatroom
  WHERE chatroom_name=LOWER(p_chatroom_name);
  
  INSERT INTO chatroom_messages(chatroom_id,user_id,message)
  VALUES(v_c_id,v_u_id,p_message);
  COMMIT;
  
dbms_output.put_line('Message sent!');
EXCEPTION
  WHEN pkg_exception.user_not_found THEN
    raise_application_error(-20005, 'User not found');
  WHEN pkg_exception.chatroom_not_found THEN
    raise_application_error(-20009 ,'Chatroom does not exist!');
END send_message;
/
