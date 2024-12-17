create or replace procedure send_message(p_chatroom_name IN VARCHAR2,
                                         p_email IN VARCHAR2,
                                         p_message IN VARCHAR2) 
                                         IS
v_count NUMBER;
v_u_id NUMBER;
v_c_id NUMBER;
c_proc_name CONSTANT VARCHAR2(30):='prc_send_message';
BEGIN
  v_u_id:= fn_get_user_id(p_email => p_email);
  
  /*SELECT user_id
  INTO v_u_id
  FROM reg_user
  WHERE email=p_email;*/
  
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
  
--Sikeres log
dbms_output.put_line('Message sent!');
prc_log(p_log_type => 'I'
           ,p_message => 'Message sent!'
           ,p_backtrace => ''
           ,p_parameters => 'p_chatroom_name=' || p_chatroom_name || ', p_email=' || p_email || ', p_message=' || p_message
           ,p_api => c_proc_name);
EXCEPTION
  WHEN pkg_exception.user_not_found THEN
    --Sikertelen log
    prc_log(p_log_type => 'E'
           ,p_message => SQLERRM || 'User not found'
           ,p_backtrace => dbms_utility.format_error_backtrace
           ,p_parameters => 'p_chatroom_name=' || p_chatroom_name || ', p_email=' || p_email || ', p_message=' || p_message
           ,p_api => c_proc_name);
      
    raise_application_error(-20005, 'User not found');
  WHEN pkg_exception.chatroom_not_found THEN
    --Sikertelen log
    prc_log(p_log_type => 'E'
           ,p_message => SQLERRM || 'Chatroom does not exist!'
           ,p_backtrace => dbms_utility.format_error_backtrace
           ,p_parameters => 'p_chatroom_name:=' || p_chatroom_name || ', p_email:=' || p_email || ', p_message=' || p_message
           ,p_api => c_proc_name);
           
    raise_application_error(-20009 ,'Chatroom does not exist!');
   WHEN OTHERS THEN
            prc_log(p_log_type => 'E'
                   ,p_message => SQLERRM
                   ,p_backtrace => dbms_utility.format_error_backtrace
                   ,p_parameters => 'p_chatroom_name:=' || p_chatroom_name || ', p_email:=' || p_email || ', p_message=' || p_message
                   ,p_api => c_proc_name);
                   
            raise_application_error(-20000, 'Unexpected error happened!');
    
END send_message;
/
