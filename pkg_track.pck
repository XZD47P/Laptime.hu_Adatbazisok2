create or replace package pkg_track is

       PROCEDURE add_track(p_track_name VARCHAR2,
                           p_country    VARCHAR2,
                           p_layout     VARCHAR2);
       
       PROCEDURE delete_track(p_track_name VARCHAR2);
       
       PROCEDURE edit_track(p_track_name VARCHAR2,
                            p_country    VARCHAR2,
                            p_layout     VARCHAR2);

end pkg_track;
/
create or replace package body pkg_track is

       gc_pkg_name CONSTANT VARCHAR2(30):= 'pkg_track';

   PROCEDURE add_track(p_track_name VARCHAR2,
                       p_country    VARCHAR2,
                       p_layout     VARCHAR2)
                       IS
      v_count NUMBER;
      c_prc_name CONSTANT VARCHAR2(30):= 'add_track';
      BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM track
        WHERE track_name=LOWER(p_track_name);
        
        IF v_count>0
          THEN
            RAISE pkg_exception.track_already_exists;
        END IF;
        
        INSERT INTO track(track_name,country,layout_pic)
        VALUES(LOWER(p_track_name),p_country,p_layout);
        COMMIT;
        
        dbms_output.put_line('Race track successfully added!');
        prc_log(p_log_type => 'I'
               ,p_message => 'Race track successfully added!'
               ,p_backtrace => ''
               ,p_parameters => 'p_track_name=' || p_track_name || ', p_country=' || p_country || ', p_layout=' || p_layout
               ,p_api => gc_pkg_name || '.' || c_prc_name);
      EXCEPTION
        WHEN pkg_exception.track_already_exists THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Race track already in database!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_track_name=' || p_track_name || ', p_country=' || p_country || ', p_layout=' || p_layout
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20014, 'Race track already in database!');
        WHEN OTHERS THEN
            prc_log(p_log_type => 'E'
                   ,p_message => SQLERRM
                   ,p_backtrace => dbms_utility.format_error_backtrace
                   ,p_parameters => 'p_track_name=' || p_track_name || ', p_country=' || p_country || ', p_layout=' || p_layout
                   ,p_api => gc_pkg_name || '.' || c_prc_name);
                   
            raise_application_error(-20000, 'Unexpected error happened!');
   END add_track;
   
   
   PROCEDURE delete_track(p_track_name VARCHAR2)
                          IS
      v_count NUMBER;
      v_t_id NUMBER;
      c_prc_name CONSTANT VARCHAR2(30):= 'delete_track';
      BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM track
        WHERE track_name=LOWER(p_track_name);
        
        IF v_count=0
          THEN
            RAISE pkg_exception.track_not_found;
          ELSE
            SELECT track_id
            INTO v_t_id
            FROM track
            WHERE track_name=LOWER(p_track_name);
        END IF;
        
        --Palya levalasztasa a versenyrol
        UPDATE RACE
        SET track_id=NULL
        WHERE track_id=v_t_id;
        
        --Palya torlese
        DELETE FROM track
        WHERE track_id=v_t_id;
        COMMIT;
        
        dbms_output.put_line('Track deleted successfully!');
        prc_log(p_log_type => 'I'
               ,p_message => 'Track deleted successfully!'
               ,p_backtrace => ''
               ,p_parameters => 'p_track_name=' || p_track_name
               ,p_api => gc_pkg_name || '.' || c_prc_name);
      EXCEPTION
        WHEN pkg_exception.track_not_found THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Race track not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_track_name=' || p_track_name
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20015, 'Race track not found!');
        WHEN OTHERS THEN
            prc_log(p_log_type => 'E'
                   ,p_message => SQLERRM
                   ,p_backtrace => dbms_utility.format_error_backtrace
                   ,p_parameters => 'p_track_name=' || p_track_name
                   ,p_api => gc_pkg_name || '.' || c_prc_name);
                   
            raise_application_error(-20000, 'Unexpected error happened!');
   END delete_track;
   
   
   PROCEDURE edit_track(p_track_name VARCHAR2,
                        p_country    VARCHAR2,
                        p_layout     VARCHAR2)
                        IS
      v_count NUMBER;
      c_prc_name CONSTANT VARCHAR2(30):= 'edit_track';
      BEGIN
       SELECT COUNT(*)
       INTO v_count
       FROM track
       WHERE track_name=LOWER(p_track_name);
       
       IF v_count=0
         THEN
           RAISE pkg_exception.track_not_found;
       END IF;
       
       UPDATE track
       SET country=p_country,
           LAYOUT_PIC=p_layout
       WHERE track_name=LOWER(p_track_name);
       COMMIT;
       
       dbms_output.put_line('Track details updated successfully!');
       prc_log(p_log_type => 'I'
              ,p_message => 'Track details updated successfully!'
              ,p_backtrace => ''
              ,p_parameters => 'p_track_name=' || p_track_name || ', p_country=' || p_country || ', p_layout=' || p_layout
              ,p_api => gc_pkg_name || '.' || c_prc_name);
       EXCEPTION
         WHEN pkg_exception.track_not_found THEN
           prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Race track not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_track_name=' || p_track_name || ', p_country=' || p_country || ', p_layout=' || p_layout
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
           raise_application_error(-20015, 'Race track not found!');
         WHEN OTHERS THEN
            prc_log(p_log_type => 'E'
                   ,p_message => SQLERRM
                   ,p_backtrace => dbms_utility.format_error_backtrace
                   ,p_parameters => 'p_track_name=' || p_track_name || ', p_country=' || p_country || ', p_layout=' || p_layout
                   ,p_api => gc_pkg_name || '.' || c_prc_name);
                   
            raise_application_error(-20000, 'Unexpected error happened!');
   END edit_track;

end pkg_track;
/
