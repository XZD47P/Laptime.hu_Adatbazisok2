create or replace package pkg_motorsport is

       PROCEDURE add_motorsport(p_name VARCHAR2);
       
       PROCEDURE delete_motorsport(p_name VARCHAR2);
       
end pkg_motorsport;
/
create or replace package body pkg_motorsport is

       gc_pkg_name CONSTANT VARCHAR2(30):= 'pkg_motorsport';

       PROCEDURE add_motorsport(p_name VARCHAR2)
                 IS
       v_count NUMBER;
       c_prc_name CONSTANT VARCHAR2(30):= 'add_motorsport';
       BEGIN
         SELECT COUNT(*)
         INTO v_count
         FROM motorsport m
         WHERE motorsport_name=LOWER(p_name);
         
         IF v_count>0
           THEN
             RAISE pkg_exception.motorsport_already_exists;
         END IF;
       
         INSERT INTO motorsport(motorsport_name)
         VALUES (LOWER(p_name));
         COMMIT;
         
         dbms_output.put_line('Motorsport added successfully!');
         prc_log(p_log_type => 'I'
                ,p_message => 'Motorsport added successfully!'
                ,p_backtrace => ''
                ,p_parameters => 'p_name=' || p_name
                ,p_api => gc_pkg_name || '.' || c_prc_name);
       EXCEPTION
         WHEN pkg_exception.motorsport_already_exists THEN
           prc_log(p_log_type => 'E'
                  ,p_message => SQLERRM || 'Motorsport is already on the list!'
                  ,p_backtrace => dbms_utility.format_error_backtrace
                  ,p_parameters => 'p_name=' || p_name
                  ,p_api => gc_pkg_name || '.' || c_prc_name);
           raise_application_error(-20003, 'Motorsport is already on the list!');  
       END add_motorsport;
       
       
       PROCEDURE delete_motorsport(p_name VARCHAR2)
                 IS
       v_m_id NUMBER;
       c_prc_name CONSTANT VARCHAR2(30):= 'delete.motorsport';
       BEGIN
         v_m_id:=fn_get_motorsport_id(p_motorsport_name => p_name);
         
         DELETE FROM motorsport
         WHERE motorsport_id=v_m_id;
         COMMIT;
         
         dbms_output.put_line('Motorsport deleted successfully!');
         prc_log(p_log_type => 'I'
                ,p_message => 'Motorsport deleted successfully!'
                ,p_backtrace => ''
                ,p_parameters => 'p_name=' || p_name
                ,p_api => gc_pkg_name || '.' || c_prc_name);
       EXCEPTION
         WHEN pkg_exception.motorsport_not_found THEN
           prc_log(p_log_type => 'E'
                  ,p_message => SQLERRM || 'Motorsport not found!'
                  ,p_backtrace => dbms_utility.format_error_backtrace
                  ,p_parameters => 'p_name=' || p_name
                  ,p_api => gc_pkg_name || '.' || c_prc_name);
           raise_application_error(-20004, 'Motorsport not found!');  
       END delete_motorsport;
end pkg_motorsport;
/
