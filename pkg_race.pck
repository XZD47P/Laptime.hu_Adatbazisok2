create or replace package pkg_race is

       PROCEDURE add_race(p_motorsport IN VARCHAR2,
                          p_title      IN VARCHAR2,
                          p_track      IN VARCHAR2,
                          p_start_date IN DATE,
                          p_end_date   IN DATE,
                          p_record_time IN VARCHAR2,
                          p_air_temp   IN NUMBER,
                          p_asp_temp   IN NUMBER,
                          p_wind_dir   IN CHAR,
                          p_wind_strenght IN NUMBER,
                          p_rain_percent IN NUMBER);
                          
       PROCEDURE delete_race(p_motorsport IN VARCHAR2,
                             p_title      IN VARCHAR2);
                             
       PROCEDURE edit_race_date(p_title      IN VARCHAR2,
                                p_new_start_date   IN DATE,
                                p_new_end_date     IN DATE);
                                
       PROCEDURE edit_motorsport_category(p_title      IN VARCHAR2,
                                          p_motorsport IN VARCHAR2);
                                          
       PROCEDURE edit_race_track(p_title IN VARCHAR2,
                                 p_track IN VARCHAR2);

end pkg_race;
/
create or replace package body pkg_race is

       gc_pkg_name CONSTANT VARCHAR2(30):= 'pkg_race';

   PROCEDURE add_race(p_motorsport IN VARCHAR2,
                      p_title      IN VARCHAR2,
                      p_track      IN VARCHAR2,
                      p_start_date IN DATE,
                      p_end_date   IN DATE,
                      p_record_time IN VARCHAR2,
                      p_air_temp   IN NUMBER,
                      p_asp_temp   IN NUMBER,
                      p_wind_dir   IN CHAR,
                      p_wind_strenght IN NUMBER,
                      p_rain_percent IN NUMBER)
                      IS
                      
      v_m_id NUMBER;
      v_count NUMBER;                    --dátumellenõrzés
      v_race_count NUMBER;               --névellenõrzés
      v_track_id NUMBER;
      c_prc_name CONSTANT VARCHAR2(30):= 'add_race';
      BEGIN
        v_m_id:=fn_get_motorsport_id(p_motorsport_name => p_motorsport);
        
       /* SELECT motorsport_id
        INTO v_m_id
        FROM motorsport
        WHERE motorsport_name=LOWER(p_motorsport);*/
        
        SELECT COUNT(*)
        INTO v_race_count
        FROM race r
        WHERE r.motorsport_id=v_m_id AND r.title=UPPER(p_title);
        
        IF v_race_count>0
          THEN
            RAISE pkg_exception.race_already_exists;
        END IF;
        
        SELECT COUNT(*)
        INTO v_count
        FROM race r
        WHERE r.motorsport_id=v_m_id AND 
              r.race_date_start=p_start_date AND r.race_date_end=p_end_date;
              
        IF v_count>0
          THEN
            RAISE pkg_exception.race_date_occupied;
        END IF;
        
        SELECT track_id
        INTO v_track_id
        FROM track
        WHERE track_name LIKE '%' ||LOWER(p_track) || '%';
        
        
        INSERT INTO race(motorsport_id,
                         title,
                         track_id,
                         race_date_start,
                         race_date_end,
                         record_time,
                         air_temperature,
                         asp_temperature,
                         wind_direction,
                         wind_strength,rain_percentage)
        VALUES(v_m_id,
               UPPER(p_title),
               v_track_id,
               p_start_date,
               p_end_date,
               time_to_milliseconds(p_time => p_record_time),
               p_air_temp,
               p_asp_temp,
               p_wind_dir,
               p_wind_strenght,
               p_rain_percent);
        COMMIT;
        
        dbms_output.put_line('Race added successfully!');
        prc_log(p_log_type => 'I'
               ,p_message => 'Race added successfully!'
               ,p_backtrace => ''
               ,p_parameters => 'p_motorsport='|| p_motorsport || ', p_title=' || p_title || ', p_track=' || p_track
                                || ', p_start_date=' || p_start_date || ', p_end_date=' || p_end_date || ', p_record_time=' || p_record_time
                                || ', p_air_temp=' || p_air_temp || ', p_asp_temp=' || p_asp_temp || ', p_wind_strength=' || p_wind_strenght
                                || ', p_rain_percentage=' || p_rain_percent
               ,p_api => gc_pkg_name || '.' || c_prc_name);
      EXCEPTION
        WHEN pkg_exception.motorsport_not_found THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Motorsport not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_motorsport='|| p_motorsport || ', p_title=' || p_title || ', p_track=' || p_track
                                || ', p_start_date=' || p_start_date || ', p_end_date=' || p_end_date || ', p_record_time=' || p_record_time
                                || ', p_air_temp=' || p_air_temp || ', p_asp_temp=' || p_asp_temp || ', p_wind_strength=' || p_wind_strenght
                                || ', p_rain_percentage=' || p_rain_percent
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20004, 'Motorsport not found!');
        WHEN pkg_exception.race_already_exists THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Race already registered with this title!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_motorsport='|| p_motorsport || ', p_title=' || p_title || ', p_track=' || p_track
                                || ', p_start_date=' || p_start_date || ', p_end_date=' || p_end_date || ', p_record_time=' || p_record_time
                                || ', p_air_temp=' || p_air_temp || ', p_asp_temp=' || p_asp_temp || ', p_wind_strength=' || p_wind_strenght
                                || ', p_rain_percentage=' || p_rain_percent
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20012, 'Race already registered with this title!');
        WHEN pkg_exception.race_date_occupied THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Race date occupied!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_motorsport='|| p_motorsport || ', p_title=' || p_title || ', p_track=' || p_track
                                || ', p_start_date=' || p_start_date || ', p_end_date=' || p_end_date || ', p_record_time=' || p_record_time
                                || ', p_air_temp=' || p_air_temp || ', p_asp_temp=' || p_asp_temp || ', p_wind_strength=' || p_wind_strenght
                                || ', p_rain_percentage=' || p_rain_percent
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20011, 'There is a race already registered to that date for this series!');
        WHEN NO_DATA_FOUND THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Track not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_motorsport='|| p_motorsport || ', p_title=' || p_title || ', p_track=' || p_track
                                || ', p_start_date=' || p_start_date || ', p_end_date=' || p_end_date || ', p_record_time=' || p_record_time
                                || ', p_air_temp=' || p_air_temp || ', p_asp_temp=' || p_asp_temp || ', p_wind_strength=' || p_wind_strenght
                                || ', p_rain_percentage=' || p_rain_percent
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20015, 'Race track not found! Please create it before adding an event!');
        WHEN OTHERS THEN
            prc_log(p_log_type => 'E'
                   ,p_message => SQLERRM
                   ,p_backtrace => dbms_utility.format_error_backtrace
                   ,p_parameters => 'p_motorsport='|| p_motorsport || ', p_title=' || p_title || ', p_track=' || p_track
                                || ', p_start_date=' || p_start_date || ', p_end_date=' || p_end_date || ', p_record_time=' || p_record_time
                                || ', p_air_temp=' || p_air_temp || ', p_asp_temp=' || p_asp_temp || ', p_wind_strength=' || p_wind_strenght
                                || ', p_rain_percentage=' || p_rain_percent
                   ,p_api => gc_pkg_name || '.' || c_prc_name);
                   
            raise_application_error(-20000, 'Unexpected error happened!');
   END add_race;
   
   
   PROCEDURE delete_race(p_motorsport IN VARCHAR2,
                         p_title      IN VARCHAR2)
                         IS
      v_count NUMBER;
      v_m_id NUMBER;
      c_prc_name CONSTANT VARCHAR2(30):= 'delete_race';
      BEGIN
        v_m_id:=fn_get_motorsport_id(p_motorsport_name => p_motorsport);
        
        /*SELECT motorsport_id
        INTO v_m_id
        FROM motorsport
        WHERE motorsport_name=LOWER(p_motorsport);*/
        
        SELECT COUNT(*)
        INTO v_count
        FROM race r
        WHERE r.motorsport_id=v_m_id AND r.title=UPPER(p_title);
        
        IF v_count=0
          THEN
            RAISE pkg_exception.race_not_found;
        END IF;
        
        DELETE FROM RACE
        WHERE motorsport_id=v_m_id AND title=UPPER(p_title);
        COMMIT;
        
        dbms_output.put_line('Race deleted successfully!');
        prc_log(p_log_type => 'I'
               ,p_message => 'Race deleted successfully!'
               ,p_backtrace => ''
               ,p_parameters => 'p_motorsport='|| p_motorsport || ', p_title=' || p_title
               ,p_api => gc_pkg_name || '.' || c_prc_name);
      EXCEPTION
        WHEN pkg_exception.motorsport_not_found THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Motorsport not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_motorsport='|| p_motorsport || ', p_title=' || p_title
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20004, 'Motorsport not found!');
        WHEN pkg_exception.race_not_found THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Race not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_motorsport='|| p_motorsport || ', p_title=' || p_title
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20013, 'Race not found!');
        WHEN OTHERS THEN
            prc_log(p_log_type => 'E'
                   ,p_message => SQLERRM
                   ,p_backtrace => dbms_utility.format_error_backtrace
                   ,p_parameters => 'p_motorsport='|| p_motorsport || ', p_title=' || p_title
                   ,p_api => gc_pkg_name || '.' || c_prc_name);
                   
            raise_application_error(-20000, 'Unexpected error happened!');
   END delete_race;
   
   
   PROCEDURE edit_race_date(p_title      IN VARCHAR2,
                            p_new_start_date   IN DATE,
                            p_new_end_date     IN DATE)
                            IS
      v_count NUMBER;
      c_prc_name CONSTANT VARCHAR2(30):= 'edit_race_date';
      BEGIN
       
        
        SELECT COUNT(*)
        INTO v_count
        FROM race r
        WHERE r.title=UPPER(p_title);
        
        IF v_count=0
          THEN
            RAISE pkg_exception.race_not_found;
        END IF;
        
        UPDATE race
        SET race_date_start=p_new_start_date,
            race_date_end=p_new_end_date;
        COMMIT;
        
        dbms_output.put_line('Successfully updated the date of the race!');
        prc_log(p_log_type => 'I'
               ,p_message => 'Race added successfully!'
               ,p_backtrace => ''
               ,p_parameters => 'p_title=' || p_title || ', p_new_start_date=' || p_new_start_date || ', p_new_end_date=' || p_new_end_date 
               ,p_api => gc_pkg_name || '.' || c_prc_name);
      EXCEPTION
        WHEN pkg_exception.race_not_found THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Motorsport not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_title=' || p_title || ', p_new_start_date=' || p_new_start_date || ', p_new_end_date=' || p_new_end_date
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20004, 'Motorsport not found!');
        WHEN OTHERS THEN
            prc_log(p_log_type => 'E'
                   ,p_message => SQLERRM
                   ,p_backtrace => dbms_utility.format_error_backtrace
                   ,p_parameters => 'p_title=' || p_title || ', p_new_start_date=' || p_new_start_date || ', p_new_end_date=' || p_new_end_date
                   ,p_api => gc_pkg_name || '.' || c_prc_name);
                   
            raise_application_error(-20000, 'Unexpected error happened!');
   END edit_race_date;
   
   
   PROCEDURE edit_motorsport_category(p_title      IN VARCHAR2,
                                      p_motorsport IN VARCHAR2)
                                      IS
      v_m_id NUMBER;
      v_r_id NUMBER;
      v_count NUMBER;
      c_prc_name CONSTANT VARCHAR2(30):= 'edit_motorsport_category';
      BEGIN
        v_m_id:= fn_get_motorsport_id(p_motorsport_name => p_motorsport);
        
        SELECT COUNT(*)
        INTO v_count
        FROM race
        WHERE title=UPPER(p_title);
        
        IF v_count=0
          THEN
            RAISE pkg_exception.race_not_found;
          ELSE
            SELECT race_id
            INTO v_r_id
            FROM race
            WHERE title=UPPER(p_title);
        END IF;
        
        UPDATE race
        SET motorsport_id=v_m_id
        WHERE title=UPPER(p_title);
      
      dbms_output.put_line('Race motorsport type successfully modified!');
      prc_log(p_log_type => 'I'
               ,p_message => 'Motorsport type successfully modified!'
               ,p_backtrace => ''
               ,p_parameters => 'p_title=' || p_title || ', p_motorsport=' || p_motorsport
               ,p_api => gc_pkg_name || '.' || c_prc_name);
               
      EXCEPTION
        WHEN pkg_exception.motorsport_not_found THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Motorsport not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_motorsport='|| p_motorsport || ', p_title=' || p_title
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20004, 'Motorsport not found!');
        WHEN pkg_exception.race_not_found THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Race not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_title=' || p_title || ', p_motorsport=' || p_motorsport
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20013, 'Race not found!');
        WHEN OTHERS THEN
            prc_log(p_log_type => 'E'
                   ,p_message => SQLERRM
                   ,p_backtrace => dbms_utility.format_error_backtrace
                   ,p_parameters => 'p_title=' || p_title || ', p_motorsport=' || p_motorsport
                   ,p_api => gc_pkg_name || '.' || c_prc_name);
                   
            raise_application_error(-20000, 'Unexpected error happened!');
   END edit_motorsport_category;
   
   
   PROCEDURE edit_race_track(p_title IN VARCHAR2,
                             p_track IN VARCHAR2)
                             IS
      v_r_id NUMBER;
      v_t_id NUMBER;
      v_count_r NUMBER;
      v_count_t NUMBER;
      c_prc_name CONSTANT VARCHAR2(30):= 'edit_race_track';
      BEGIN
        SELECT COUNT(*)
        INTO v_count_r
        FROM race
        where title=UPPER(p_title);
        
        IF v_count_r=0
          THEN
            RAISE pkg_exception.race_not_found;
          ELSE
            SELECT race_id
            INTO v_r_id
            FROM race
            WHERE title=UPPER(p_title);
        END IF;
        
        SELECT COUNT(*)
        INTO v_count_t
        FROM track
        WHERE track_name=p_track;
        
        IF v_count_t=0
          THEN
            RAISE pkg_exception.track_not_found;
          ELSE
            SELECT track_id
            INTO v_t_id
            FROM track
            WHERE track_name=p_track;
        END IF;
        
        UPDATE race
        SET track_id=v_t_id
        WHERE title=UPPER(p_title);
        COMMIT;
        
        dbms_output.put_line('Track successfully added to race event.');
        prc_log(p_log_type => 'I'
               ,p_message => 'Track added to race successfully!'
               ,p_backtrace => ''
               ,p_parameters => 'p_title=' || p_title || ', p_track=' || p_track
               ,p_api => gc_pkg_name || '.' || c_prc_name);
      EXCEPTION
        WHEN pkg_exception.race_not_found THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Race not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_title=' || p_title || ', p_track=' || p_track
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20013, 'Race not found!');
        WHEN pkg_exception.track_not_found THEN
           prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Track not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_title=' || p_title || ', p_track=' || p_track
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20015, 'Track not found!');
        WHEN OTHERS THEN
            prc_log(p_log_type => 'E'
                   ,p_message => SQLERRM
                   ,p_backtrace => dbms_utility.format_error_backtrace
                   ,p_parameters => 'p_title=' || p_title || ', p_track=' || p_track
                   ,p_api => gc_pkg_name || '.' || c_prc_name);
                   
            raise_application_error(-20000, 'Unexpected error happened!');
   END edit_race_track;

end pkg_race;
/
