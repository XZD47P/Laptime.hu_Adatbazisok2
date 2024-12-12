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

   PROCEDURE add_track(p_track_name VARCHAR2,
                       p_country    VARCHAR2,
                       p_layout     VARCHAR2)
                           IS
      v_count NUMBER;
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
      EXCEPTION
        WHEN pkg_exception.track_already_exists THEN
          raise_application_error(-20014, 'Race track already in database!');
   END add_track;
   
   
   PROCEDURE delete_track(p_track_name VARCHAR2)
                          IS
      v_count NUMBER;
      BEGIN
        SELECT COUNT(*)
        INTO v_count
        FROM track
        WHERE track_name=LOWER(p_track_name);
        
        IF v_count=0
          THEN
            RAISE pkg_exception.track_not_found;
        END IF;
        
        DELETE FROM track
        WHERE track_name=LOWER(p_track_name);
        COMMIT;
        
        dbms_output.put_line('Track deleted successfully!');
      EXCEPTION
        WHEN pkg_exception.track_not_found THEN
          raise_application_error(-20015, 'Race track not found!');
   END delete_track;
   
   
   PROCEDURE edit_track(p_track_name VARCHAR2,
                            p_country    VARCHAR2,
                            p_layout     VARCHAR2)
                            IS
      v_count NUMBER;
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
           track_name=LOWER(p_track_name),
           LAYOUT_PIC=p_layout
       WHERE track_name=LOWER(p_track_name);
       COMMIT;
       
       dbms_output.put_line('Track details updated successfully!');
       EXCEPTION
         WHEN pkg_exception.track_not_found THEN
           raise_application_error(-20015, 'Race track not found!');
   END edit_track;

end pkg_track;
/
