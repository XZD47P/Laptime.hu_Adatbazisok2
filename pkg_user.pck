create or replace package pkg_user is

       PROCEDURE add_user(p_first_name  IN VARCHAR2,
                         p_last_name    IN VARCHAR2,
                         p_email        IN VARCHAR2,
                         p_password     IN VARCHAR2,
                         p_fav_driver   IN VARCHAR2,
                         p_fav_team     IN VARCHAR2,
                         p_user_role    IN VARCHAR2,
                         p_email_subscription IN  NUMBER);
                         
       PROCEDURE delete_user(p_email IN VARCHAR2);
       
       PROCEDURE update_password(p_email IN VARCHAR2,
                                 p_curr_password IN VARCHAR2,
                                 p_new_password IN VARCHAR2);
       
       PROCEDURE change_role(p_email IN varchar2,
                             p_role  IN varchar2);
      
       PROCEDURE add_fav_motorsport(p_email IN VARCHAR2,
                                    p_motorsport IN VARCHAR2);
                                    
       PROCEDURE delete_fav_motorsport(p_email IN VARCHAR2,
                                       p_motorsport IN VARCHAR2);
                                    
       
end pkg_user;
/
create or replace package body pkg_user is

   PROCEDURE add_user(p_first_name  IN VARCHAR2,
                      p_last_name    IN VARCHAR2,
                      p_email        IN VARCHAR2,
                      p_password     IN VARCHAR2,
                      p_fav_driver   IN VARCHAR2,
                      p_fav_team     IN VARCHAR2,
                      p_user_role    IN VARCHAR2,
                      p_email_subscription IN  NUMBER)
                      IS
       v_count NUMBER;
       v_enc_pass RAW(2000);
       BEGIN
         SELECT COUNT(*)
         INTO v_count
         FROM reg_user
         WHERE email=p_email;
         
         IF v_count>0
           THEN
             RAISE pkg_exception.user_already_exists;
         END IF;
         
         --Jelszó titkosítás
         v_enc_pass:= pkg_cipher.encrypt(p_plain_password => p_password);
         
         INSERT INTO reg_user(first_name,last_name,email,password,fav_driver,fav_team,user_role,email_subscription)
         VALUES (p_first_name,p_last_name,p_email,v_enc_pass,p_fav_driver,p_fav_team,p_user_role,p_email_subscription);
         COMMIT;
         
         dbms_output.put_line('User added successfully!');
       EXCEPTION
         WHEN pkg_exception.user_already_exists THEN
             raise_application_error(-20001, 'User already registered!');    
    END add_user;
       
       
   PROCEDURE delete_user(p_email IN VARCHAR2) 
                         IS
       
       BEGIN
         user_exists(p_email => p_email);
         
         DELETE FROM reg_user
         WHERE email=p_email;
         COMMIT;
       
       dbms_output.put_line('User deleted successfully!');
       EXCEPTION
       WHEN pkg_exception.user_not_found THEN
              raise_application_error(-20005,'User not found');
   END delete_user;
       
       
   PROCEDURE update_password(p_email IN VARCHAR2,
                             p_curr_password IN VARCHAR2,
                             p_new_password IN VARCHAR2)
                             IS
       v_password RAW(2000);
       v_enc_curr_passw RAW(2000);
       v_enc_new_passw  RAW(2000);       
       BEGIN
         user_exists(p_email => p_email);
         
         v_enc_curr_passw:= pkg_cipher.encrypt(p_plain_password => p_curr_password);
         
         --jelenlegi jelszó egyezés ellenõrzése
         SELECT password
         INTO v_password
         FROM reg_user
         WHERE email=p_email;
         
         IF v_enc_curr_passw= v_password
            THEN
              v_enc_new_passw:= pkg_cipher.encrypt(p_plain_password => p_new_password);
              
              UPDATE reg_user
              SET password=v_enc_new_passw
              WHERE email=p_email;
              
              COMMIT;
            ELSE
              RAISE pkg_exception.incorrect_password;
         END IF;
         
         dbms_output.put_line('Password updated successfully!');
       EXCEPTION
         WHEN pkg_exception.user_not_found THEN
              raise_application_error(-20005,'User not found');
         WHEN pkg_exception.incorrect_password THEN
           raise_application_error(-20002, 'Email address or password is not correct!');     
   END update_password;
         

   PROCEDURE change_role(p_email IN varchar2,
                         p_role  IN varchar2)
                         IS
                 
       BEGIN
         user_exists(p_email => p_email);
         
         UPDATE reg_user
         SET user_role=p_role
         WHERE email=p_email;
         COMMIT;
         
         dbms_output.put_line('User role changed successfully!');
       EXCEPTION
         WHEN pkg_exception.user_not_found THEN
              raise_application_error(-20005,'User not found');  
   END change_role;           


   PROCEDURE add_fav_motorsport(p_email IN VARCHAR2,
                                p_motorsport IN VARCHAR2)
                                IS
       v_u_id NUMBER;
       v_m_id NUMBER;
       BEGIN
         user_exists(p_email => p_email);
         motorsport_exists(p_motorsport_name => p_motorsport);

         SELECT user_id
         INTO v_u_id
         FROM reg_user
         WHERE email=p_email;
         
         SELECT motorsport_id
         INTO v_m_id
         FROM motorsport
         WHERE motorsport_name=LOWER(p_motorsport);

         INSERT INTO favored_motorsport(u_id,motorsport_id)
         VALUES (v_u_id,v_m_id);
         COMMIT;
       
       dbms_output.put_line('Favorite motorsport added to user!');
       EXCEPTION
         WHEN pkg_exception.user_not_found THEN
              raise_application_error(-20005,'User not found');
         WHEN pkg_exception.motorsport_not_found THEN
              raise_application_error(-20004, 'Motorsport not found!');  
   END add_fav_motorsport;
       

   PROCEDURE delete_fav_motorsport(p_email IN VARCHAR2,
                                   p_motorsport IN VARCHAR2)
                                   IS
       v_u_id NUMBER;
       v_m_id NUMBER;
       v_fav_count NUMBER;                 
       BEGIN
         user_exists(p_email => p_email);
         motorsport_exists(p_motorsport_name => p_motorsport);
         
         SELECT user_id
         INTO v_u_id
         FROM reg_user
         WHERE email=p_email;
         
         SELECT motorsport_id
         INTO v_m_id
         FROM motorsport
         WHERE motorsport_name=LOWER(p_motorsport);
         
         SELECT COUNT(*)
         INTO v_fav_count
         FROM favored_motorsport
         WHERE u_id=v_u_id AND motorsport_id=v_m_id;
         
         IF v_fav_count=0
           THEN
             RAISE pkg_exception.user_not_favourite_motorsport;
         END IF;
         
         DELETE FROM favored_motorsport
         WHERE u_id=v_u_id AND motorsport_id=v_m_id;
         COMMIT;
       
       dbms_output.put_line('Favorite motorsport deleted from user!');  
       EXCEPTION
         WHEN pkg_exception.user_not_found THEN
              raise_application_error(-20005,'User not found');
         WHEN pkg_exception.motorsport_not_found THEN
              raise_application_error(-20004, 'Motorsport not found!');
         WHEN pkg_exception.user_not_favourite_motorsport THEN
              raise_application_error(-20006, 'User does not have this motorsport as favourite motorsport');
   END delete_fav_motorsport;


  
end pkg_user;
/
