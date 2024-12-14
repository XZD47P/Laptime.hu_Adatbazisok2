create or replace package pkg_comment is

       PROCEDURE post_comment(p_news_title IN VARCHAR2,
                              p_motorsport IN VARCHAR2,
                              p_email      IN VARCHAR2,
                              p_comment    IN VARCHAR2);

end pkg_comment;
/
create or replace package body pkg_comment is

   PROCEDURE post_comment(p_news_title IN VARCHAR2,
                          p_motorsport IN VARCHAR2,
                          p_email      IN VARCHAR2,
                          p_comment    IN VARCHAR2)
                          IS
      v_news_id NUMBER;
      v_m_id    NUMBER;
      v_u_id    NUMBER;
      v_count   NUMBER;
      BEGIN
        motorsport_exists(p_motorsport_name => p_motorsport);
        user_exists(p_email => p_email);
        
        SELECT motorsport_id
        INTO v_m_id
        FROM motorsport
        WHERE motorsport_name=LOWER(p_motorsport);
        
        SELECT COUNT(*)
        INTO v_count
        FROM news
        WHERE title=p_news_title AND motorsport_category=v_m_id;
        
        IF v_count=0
          THEN
            RAISE pkg_exception.news_not_found;
        END IF;
        
        SELECT user_id
        INTO v_u_id
        FROM reg_user
        WHERE email=p_email;
        
        SELECT news_id
        INTO v_news_id
        FROM news
        WHERE title=p_news_title AND motorsport_category=v_m_id;
        
        INSERT INTO news_comment(u_id,news_id,n_comment)
        VALUES(v_u_id,v_news_id,p_comment);
        COMMIT;
        
        dbms_output.put_line('Comment posted!');
      EXCEPTION
        WHEN pkg_exception.motorsport_not_found THEN
          raise_application_error(-20004, 'Motorsport not found!');
        WHEN pkg_exception.user_not_found THEN
          raise_application_error(-20005, 'User not found!');
        WHEN pkg_exception.news_not_found THEN
          raise_application_error(-20007, 'News not found with these parameters!');
   END post_comment;

end pkg_comment;
/
