create or replace package pkg_news is

       PROCEDURE add_news(p_email IN VARCHAR2,
                          p_motorsport IN VARCHAR2,
                          p_title IN VARCHAR2,
                          p_description IN VARCHAR2);
       
       PROCEDURE delete_news(p_email IN VARCHAR2,
                             p_motorsport IN VARCHAR2,
                             p_title IN VARCHAR2);
end pkg_news;
/
create or replace package body pkg_news is

   PROCEDURE add_news(p_email IN VARCHAR2,
                      p_motorsport IN VARCHAR2,
                      p_title IN VARCHAR2,
                      p_description IN VARCHAR2)
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
         
         INSERT INTO NEWS(U_ID,MOTORSPORT_CATEGORY,TITLE,NEWS_DESCRIPTION)
         VALUES(v_u_id,v_m_id,p_title,to_clob(p_description));
         COMMIT;
         
       EXCEPTION
         WHEN pkg_exception.user_not_found THEN
              raise_application_error(-20005,'User not found');
         WHEN pkg_exception.motorsport_not_found THEN
              raise_application_error(-20004, 'Motorsport not found!');
   END add_news;
   
   
   PROCEDURE delete_news(p_email IN VARCHAR2,
                         p_motorsport IN VARCHAR2,
                         p_title IN VARCHAR2)
                         IS
       v_u_id NUMBER;
       v_m_id NUMBER;
       v_news_count NUMBER;
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
         INTO v_news_count
         FROM news
         WHERE u_id=v_u_id AND motorsport_category=v_m_id AND title=p_title;
         
         IF v_news_count=0
           THEN
             RAISE pkg_exception.news_not_found;
         END IF;
         
         DELETE FROM news
         WHERE u_id=v_u_id AND motorsport_category=v_m_id AND title=p_title;
         COMMIT;
         
       EXCEPTION
         WHEN pkg_exception.user_not_found THEN
              raise_application_error(-20005,'User not found');
         WHEN pkg_exception.motorsport_not_found THEN
              raise_application_error(-20004, 'Motorsport not found!');
         WHEN pkg_exception.news_not_found THEN
           raise_application_error(-20007,'News not found with these parameters!');  
       END delete_news;

end pkg_news;
/
