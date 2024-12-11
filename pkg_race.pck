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
      BEGIN
        motorsport_exists(p_motorsport_name => p_motorsport);
        
        SELECT motorsport_id
        INTO v_m_id
        FROM motorsport
        WHERE motorsport_name=LOWER(p_motorsport);
        
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
        
   END add_race;                    

end pkg_race;
/
