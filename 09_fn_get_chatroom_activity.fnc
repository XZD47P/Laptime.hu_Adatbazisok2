create or replace function fn_get_chatroom_activity return ty_chatroom_activity_l is
  v_result ty_chatroom_activity_l;
begin
  
  SELECT ty_chatroom_activity(chatroom_name => c.chatroom_name,
                              users_used => COUNT(cm.user_id))
  BULK COLLECT
  INTO v_result
  FROM chatroom c INNER JOIN chatroom_messages cm ON c.chatroom_id=cm.chatroom_id
  GROUP BY c.chatroom_name;  
  
  return v_result;
end fn_get_chatroom_activity;
/
