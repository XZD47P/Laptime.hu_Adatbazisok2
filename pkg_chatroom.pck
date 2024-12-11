create or replace package pkg_chatroom is

       PROCEDURE create_chatroom(p_name IN VARCHAR2,
                                 p_motorsport IN VARCHAR2);
                                 
       PROCEDURE delete_chatroom(p_name IN VARCHAR2,
                                 p_motorsport IN VARCHAR2);                          
end pkg_chatroom;
/
create or replace package body pkg_chatroom is

   PROCEDURE create_chatroom(p_name IN VARCHAR2,
                             p_motorsport IN VARCHAR2)
                             IS
      v_m_id NUMBER;
      v_count NUMBER;
      BEGIN
        motorsport_exists(p_motorsport_name => p_motorsport);
        
        SELECT motorsport_id
        INTO v_m_id
        FROM motorsport
        WHERE motorsport_name=p_motorsport;
        
        SELECT COUNT(*)
        INTO v_count
        FROM chatroom
        WHERE chatroom_name=p_name AND motorsport_category=v_m_id;
        
        IF v_count>0
          THEN
            RAISE pkg_exception.chatroom_already_exists;
        END IF;
        
        INSERT INTO chatroom(chatroom_name,motorsport_category)
        VALUES (p_name,v_m_id);
        COMMIT;
        
        dbms_output.put_line('Chatroom successfully created!');
      EXCEPTION
        WHEN pkg_exception.motorsport_not_found THEN
              raise_application_error(-20004, 'Motorsport not found!');
        WHEN pkg_exception.chatroom_already_exists THEN
              raise_application_error(-20008, 'Chatroom already exists with these details!');     
   END create_chatroom;
   
   
   PROCEDURE delete_chatroom(p_name IN VARCHAR2,
                             p_motorsport IN VARCHAR2)
                             IS
      v_m_id NUMBER;
      v_count NUMBER;
      BEGIN
        motorsport_exists(p_motorsport_name => p_motorsport);
        
        SELECT motorsport_id
        INTO v_m_id
        FROM motorsport
        WHERE motorsport_name=p_motorsport;
        
        SELECT COUNT(*)
        INTO v_count
        FROM chatroom
        WHERE chatroom_name=p_name AND motorsport_category=v_m_id;
        
        IF v_count=0
          THEN
            RAISE pkg_exception.chatroom_not_found;
        END IF;
        
        DELETE FROM chatroom
        WHERE chatroom_name=p_name AND motorsport_category=v_m_id;
        COMMIT;
        
        dbms_output.put_line('Chatroom deleted successfully!');
        EXCEPTION
          WHEN pkg_exception.motorsport_not_found THEN
              raise_application_error(-20004, 'Motorsport not found!');
          WHEN pkg_exception.chatroom_not_found THEN
            raise_application_error(-20009, 'Chatroom not found!');
      END delete_chatroom;                           

end pkg_chatroom;
/
