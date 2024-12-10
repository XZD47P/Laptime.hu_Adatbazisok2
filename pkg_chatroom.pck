create or replace package pkg_chatroom is

       PROCEDURE create_chatroom(p_name IN VARCHAR2,
                                 p_motorsport IN VARCHAR2);
end pkg_chatroom;
/
create or replace package body pkg_chatroom is

   PROCEDURE create_chatroom(p_name IN VARCHAR2,
                             p_motorsport IN VARCHAR2)
                             IS
      v_m_id NUMBER;
      BEGIN
        motorsport_exists(p_motorsport_name => p_motorsport);
        
        SELECT motorsport_id
        INTO v_m_id
        FROM motorsport
        WHERE motorsport_name=p_motorsport;
        
        INSERT INTO chatroom(chatroom_name,motorsport_category)
        VALUES (p_name,v_m_id);
        COMMIT;
        
        dbms_output.put_line('Chatroom successfully created!');
      EXCEPTION
        WHEN pkg_exception.motorsport_not_found THEN
              raise_application_error(-20004, 'Motorsport not found!');     
   END create_chatroom;    

end pkg_chatroom;
/
