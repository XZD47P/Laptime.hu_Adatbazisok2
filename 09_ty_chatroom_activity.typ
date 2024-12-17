create or replace type ty_chatroom_activity as object
(
       chatroom_name   VARCHAR2(255),
       users_used      NUMBER,
       
       CONSTRUCTOR FUNCTION ty_chatroom_activity(p_chatroom_name VARCHAR2,
                                                 p_users_used    NUMBER)
                                                 RETURN SELF AS RESULT
)
/
create or replace type body ty_chatroom_activity is
  
       CONSTRUCTOR FUNCTION ty_chatroom_activity(p_chatroom_name VARCHAR2,
                                                 p_users_used    NUMBER)
                                                 RETURN SELF AS RESULT
                                                 IS
                   BEGIN
                     self.chatroom_name:=p_chatroom_name;
                     self.users_used:=p_users_used;
                     RETURN;
                   END;
  
end;
/
