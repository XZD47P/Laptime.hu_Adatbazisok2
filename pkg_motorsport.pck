create or replace package pkg_motorsport is

       PROCEDURE add_motorsport(p_name VARCHAR2);
       
       PROCEDURE delete_motorsport(p_name VARCHAR2);
       
end pkg_motorsport;
/
create or replace package body pkg_motorsport is

       PROCEDURE add_motorsport(p_name VARCHAR2)
                 IS
       v_count NUMBER;
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
       EXCEPTION
         WHEN pkg_exception.motorsport_already_exists THEN
           raise_application_error(-20003, 'Motorsport is already on the list!');  
       END add_motorsport;
       
       
       PROCEDURE delete_motorsport(p_name VARCHAR2)
                 IS
       v_count NUMBER;
       BEGIN
         SELECT COUNT(*)
         INTO v_count
         FROM motorsport m
         WHERE motorsport_name=LOWER(p_name);
         
         IF v_count=0
          THEN
            RAISE pkg_exception.motorsport_not_found;
         END IF;
         
         DELETE FROM motorsport
         WHERE motorsport_name=LOWER(p_name);
         COMMIT;
         
         dbms_output.put_line('Motorsport deleted successfully!');
       EXCEPTION
         WHEN pkg_exception.motorsport_not_found THEN
           raise_application_error(-20004, 'Motorsport not found!');  
       END delete_motorsport;
end pkg_motorsport;
/
