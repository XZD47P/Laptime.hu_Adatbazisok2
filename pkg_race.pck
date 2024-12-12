create or replace package pkg_race is

       PROCEDURE add_race(p_motorsport IN VARCHAR2,
                          p_title      IN VARCHAR2,
                          p_track      IN VARCHAR2,
                          p_layout_pic IN VARCHAR2,
                          p_country    IN VARCHAR2,
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

end pkg_race;
/
create or replace package body pkg_race is

   PROCEDURE add_race(p_motorsport IN VARCHAR2,
                          p_title      IN VARCHAR2,
                          p_track      IN VARCHAR2,
                          p_layout_pic IN VARCHAR2,
                          p_country    IN VARCHAR2,
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
      BEGIN
        motorsport_exists(p_motorsport_name => p_motorsport);
        
        SELECT motorsport_id
        INTO v_m_id
        FROM motorsport
        WHERE motorsport_name=LOWER(p_motorsport);
        
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
        
        
        INSERT INTO race(motorsport_id,
                         title,
                         track,
                         layout_pic,
                         country,
                         race_date_start,
                         race_date_end,
                         record_time,
                         air_temperature,
                         asp_temperature,
                         wind_direction,
                         wind_strength,rain_percentage)
        VALUES(v_m_id,
               UPPER(p_title),
               UPPER(p_track),
               p_layout_pic,
               UPPER(p_country),
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
      EXCEPTION
        WHEN pkg_exception.motorsport_not_found THEN
          raise_application_error(-20004, 'Motorsport not found!');
        WHEN pkg_exception.race_already_exists THEN
          raise_application_error(-20012, 'Race already registered with this title!');
        WHEN pkg_exception.race_date_occupied THEN
          raise_application_error(-20011, 'There is a race already registered to that date for this series!');
   END add_race;
   
   
   PROCEDURE delete_race(p_motorsport IN VARCHAR2,
                         p_title      IN VARCHAR2)
                         IS
      v_count NUMBER;
      v_m_id NUMBER;
      BEGIN
        motorsport_exists(p_motorsport_name => p_motorsport);
        
        SELECT motorsport_id
        INTO v_m_id
        FROM motorsport
        WHERE motorsport_name=LOWER(p_motorsport);
        
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
      EXCEPTION
        WHEN pkg_exception.motorsport_not_found THEN
          raise_application_error(-20004, 'Motorsport not found!');
        WHEN pkg_exception.race_not_found THEN
          raise_application_error(-20013, 'Race not found!');
   END delete_race;                    

end pkg_race;
/
