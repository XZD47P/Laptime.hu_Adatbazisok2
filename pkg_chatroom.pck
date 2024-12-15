create or replace package pkg_chatroom is

       PROCEDURE create_chatroom(p_name IN VARCHAR2,
                                 p_motorsport IN VARCHAR2);
                                 
       PROCEDURE delete_chatroom(p_name IN VARCHAR2,
                                 p_motorsport IN VARCHAR2);                          
end pkg_chatroom;
/
create or replace package body pkg_chatroom is
       
       gc_pck_name CONSTANT VARCHAR2(30):= 'pkg_chatroom';

   PROCEDURE create_chatroom(p_name IN VARCHAR2,
                             p_motorsport IN VARCHAR2)
                             IS
      v_m_id NUMBER;
      v_count NUMBER;
      c_prc_name CONSTANT VARCHAR2(30):='create_chatroom';
      BEGIN
        motorsport_exists(p_motorsport_name => p_motorsport);
        
        SELECT motorsport_id
        INTO v_m_id
        FROM motorsport
        WHERE motorsport_name=LOWER(p_motorsport);
        
        SELECT COUNT(*)
        INTO v_count
        FROM chatroom
        WHERE chatroom_name=LOWER(p_name) AND motorsport_category=v_m_id;
        
        IF v_count>0
          THEN
            RAISE pkg_exception.chatroom_already_exists;
        END IF;
        
        INSERT INTO chatroom(chatroom_name,motorsport_category)
        VALUES (LOWER(p_name),v_m_id);
        COMMIT;
        
        dbms_output.put_line('Chatroom successfully created!');
        prc_log(p_log_type => 'I'
           ,p_message => 'Chatroom successfully created!'
           ,p_backtrace => ''
           ,p_parameters => 'p_name=' || p_name || ', p_motorsport=' || p_motorsport
           ,p_api => gc_pck_name || '.' || c_prc_name);
      EXCEPTION
        WHEN pkg_exception.motorsport_not_found THEN
          prc_log(p_log_type => 'E'
           ,p_message => SQLERRM || 'Motorsport not found!'
           ,p_backtrace => dbms_utility.format_error_backtrace
           ,p_parameters => 'p_name=' || p_name || ', p_motorsport=' || p_motorsport
           ,p_api => gc_pck_name || '.' || c_prc_name);
        
           raise_application_error(-20004, 'Motorsport not found!');
        WHEN pkg_exception.chatroom_already_exists THEN
          prc_log(p_log_type => 'E'
           ,p_message => SQLERRM || 'Chatroom already exists with these details!'
           ,p_backtrace => dbms_utility.format_error_backtrace
           ,p_parameters => 'p_name=' || p_name || ', p_motorsport=' || p_motorsport
           ,p_api => gc_pck_name || '.' || c_prc_name);
           
           raise_application_error(-20008, 'Chatroom already exists with these details!');     
   END create_chatroom;
   
   
   PROCEDURE delete_chatroom(p_name IN VARCHAR2,
                             p_motorsport IN VARCHAR2)
                             IS
      v_m_id NUMBER;
      v_count NUMBER;
      c_prc_name CONSTANT VARCHAR2(30):='delete_chatroom';
      BEGIN
        motorsport_exists(p_motorsport_name => p_motorsport);
        
        SELECT motorsport_id
        INTO v_m_id
        FROM motorsport
        WHERE motorsport_name=LOWER(p_motorsport);
        
        SELECT COUNT(*)
        INTO v_count
        FROM chatroom
        WHERE chatroom_name=LOWER(p_name) AND motorsport_category=v_m_id;
        
        IF v_count=0
          THEN
            RAISE pkg_exception.chatroom_not_found;
        END IF;
        
        DELETE FROM chatroom
        WHERE chatroom_name=LOWER(p_name) AND motorsport_category=v_m_id;
        COMMIT;
        
        dbms_output.put_line('Chatroom deleted successfully!');
        prc_log(p_log_type => 'I'
           ,p_message => 'Chatroom deleted successfully!'
           ,p_backtrace => ''
           ,p_parameters => 'p_name=' || p_name || ', p_motorsport=' || p_motorsport
           ,p_api => gc_pck_name || '.' || c_prc_name);
        EXCEPTION
          WHEN pkg_exception.motorsport_not_found THEN
            prc_log(p_log_type => 'E'
           ,p_message => SQLERRM || 'Motorsport not found!'
           ,p_backtrace => dbms_utility.format_error_backtrace
           ,p_parameters => 'p_name=' || p_name || ', p_motorsport=' || p_motorsport
           ,p_api => gc_pck_name || '.' || c_prc_name);
           
              raise_application_error(-20004, 'Motorsport not found!');
          WHEN pkg_exception.chatroom_not_found THEN
            prc_log(p_log_type => 'E'
           ,p_message => SQLERRM || 'Chatroom not found!'
           ,p_backtrace => dbms_utility.format_error_backtrace
           ,p_parameters => 'p_name=' || p_name || ', p_motorsport=' || p_motorsport
           ,p_api => gc_pck_name || '.' || c_prc_name);
           
            raise_application_error(-20009, 'Chatroom not found!');
      END delete_chatroom;                           

end pkg_chatroom;
/
