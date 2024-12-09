create or replace package pkg_user is

       PROCEDURE add_user(p_first_name  IN VARCHAR2,
                         p_last_name    IN VARCHAR2,
                         p_email        IN VARCHAR2,
                         p_password     IN VARCHAR2,
                         p_fav_driver   IN VARCHAR2,
                         p_fav_team     IN VARCHAR2,
                         p_user_role    IN VARCHAR2,
                         p_email_subscription IN  NUMBER);

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
         
         --Password Encription
         v_enc_pass:= pkg_cipher.encrypt(p_plain_password => p_password);
         
         INSERT INTO reg_user(first_name,last_name,email,password,fav_driver,fav_team,user_role,email_subscription)
         VALUES (p_first_name,p_last_name,p_email,v_enc_pass,p_fav_driver,p_fav_team,p_user_role,p_email_subscription);
         COMMIT;
         
       EXCEPTION
         WHEN pkg_exception.user_already_exists THEN
             raise_application_error(-20001, 'User already registered!');    
       
       END add_user;

end pkg_user;
/
