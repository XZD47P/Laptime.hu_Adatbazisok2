create or replace package pkg_comment is

       PROCEDURE post_comment(p_news_title IN VARCHAR2,
                              p_motorsport IN VARCHAR2,
                              p_email      IN VARCHAR2,
                              p_comment    IN VARCHAR2);
                              
       PROCEDURE delete_comment(p_news_title IN VARCHAR2,
                                p_motorsport IN VARCHAR2,
                                p_email      IN VARCHAR2,
                                p_comment    IN VARCHAR2);

end pkg_comment;
/
create or replace package body pkg_comment is

       gc_pkg_name CONSTANT VARCHAR2(30):= 'pkg_comment';

   PROCEDURE post_comment(p_news_title IN VARCHAR2,
                          p_motorsport IN VARCHAR2,
                          p_email      IN VARCHAR2,
                          p_comment    IN VARCHAR2)
                          IS
      v_news_id NUMBER;
      v_m_id    NUMBER;
      v_u_id    NUMBER;
      v_count   NUMBER;
      c_prc_name CONSTANT VARCHAR2(30):='post_comment';
      BEGIN
       v_m_id:=fn_get_motorsport_id(p_motorsport_name => p_motorsport);
       v_u_id:= fn_get_user_id(p_email => p_email);
        
        /*SELECT motorsport_id
        INTO v_m_id
        FROM motorsport
        WHERE motorsport_name=LOWER(p_motorsport);*/
        
        SELECT COUNT(*)
        INTO v_count
        FROM news
        WHERE title=p_news_title AND motorsport_category=v_m_id;
        
        IF v_count=0
          THEN
            RAISE pkg_exception.news_not_found;
        END IF;
        
      /*  SELECT user_id
        INTO v_u_id
        FROM reg_user
        WHERE email=p_email;*/
        
        SELECT news_id
        INTO v_news_id
        FROM news
        WHERE title=p_news_title AND motorsport_category=v_m_id;
        
        INSERT INTO news_comment(u_id,news_id,n_comment)
        VALUES(v_u_id,v_news_id,p_comment);
        COMMIT;
        
        dbms_output.put_line('Comment posted!');
        prc_log(p_log_type => 'I'
               ,p_message => 'Comment posted!'
               ,p_backtrace => ''
               ,p_parameters => 'p_news_title=' || p_news_title || ', p_motorsport=' || p_motorsport || ', p_email=' || p_email || ', p_comment=' || p_comment
               ,p_api => gc_pkg_name || '.' || c_prc_name);
      EXCEPTION
        WHEN pkg_exception.motorsport_not_found THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Motorsport not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_news_title=' || p_news_title || ', p_motorsport=' || p_motorsport || ', p_email=' || p_email || ', p_comment=' || p_comment
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20004, 'Motorsport not found!');
        WHEN pkg_exception.user_not_found THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'User not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_news_title=' || p_news_title || ', p_motorsport=' || p_motorsport || ', p_email=' || p_email || ', p_comment=' || p_comment
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20005, 'User not found!');
        WHEN pkg_exception.news_not_found THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'News not found with these parameters!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_news_title=' || p_news_title || ', p_motorsport=' || p_motorsport || ', p_email=' || p_email || ', p_comment=' || p_comment
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20007, 'News not found with these parameters!');
        WHEN OTHERS THEN
            prc_log(p_log_type => 'E'
                   ,p_message => SQLERRM
                   ,p_backtrace => dbms_utility.format_error_backtrace
                   ,p_parameters => 'p_news_title=' || p_news_title || ', p_motorsport=' || p_motorsport || ', p_email=' || p_email || ', p_comment=' || p_comment
                   ,p_api => gc_pkg_name || '.' || c_prc_name);
                   
            raise_application_error(-20000, 'Unexpected error happened!');
   END post_comment;
   
   
   PROCEDURE delete_comment(p_news_title IN VARCHAR2,
                            p_motorsport IN VARCHAR2,
                            p_email      IN VARCHAR2,
                            p_comment    IN VARCHAR2)
                            IS
      v_news_id NUMBER;
      v_m_id       NUMBER;
      v_u_id       NUMBER;
      v_count      NUMBER;
      v_comment_id NUMBER;
      c_prc_name CONSTANT VARCHAR2(30):='delete_motorsport';
      BEGIN
       v_m_id:=fn_get_motorsport_id(p_motorsport_name => p_motorsport);
       v_u_id:= fn_get_user_id(p_email => p_email);
        
        /*SELECT motorsport_id
        INTO v_m_id
        FROM motorsport
        WHERE motorsport_name=LOWER(p_motorsport);*/
        
        SELECT COUNT(*)
        INTO v_count
        FROM news
        WHERE title=p_news_title AND motorsport_category=v_m_id;
        
        IF v_count=0
          THEN
            RAISE pkg_exception.news_not_found;
        END IF;
        
       /* SELECT user_id
        INTO v_u_id
        FROM reg_user
        WHERE email=p_email;*/
        
        SELECT news_id
        INTO v_news_id
        FROM news
        WHERE title=p_news_title AND motorsport_category=v_m_id;
        
        SELECT comment_id
        INTO v_comment_id
        FROM news_comment 
        WHERE u_id=v_u_id AND news_id=v_news_id AND n_comment LIKE '%' || p_comment || '%';
        
        DELETE FROM news_comment
        WHERE comment_id=v_comment_id;
        COMMIT;
        
        dbms_output.put_line('Comment deleted successfully!');
        prc_log(p_log_type => 'I'
               ,p_message => 'Comment deleted successfully!'
               ,p_backtrace => ''
               ,p_parameters => 'p_news_title=' || p_news_title || ', p_motorsport=' || p_motorsport || ', p_email=' || p_email || ', p_comment=' || p_comment
               ,p_api => gc_pkg_name || '.' || c_prc_name);
      EXCEPTION
        WHEN pkg_exception.motorsport_not_found THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Motorsport not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_news_title=' || p_news_title || ', p_motorsport=' || p_motorsport || ', p_email=' || p_email || ', p_comment=' || p_comment
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
          
          raise_application_error(-20004, 'Motorsport not found!');
        WHEN pkg_exception.user_not_found THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'User not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_news_title=' || p_news_title || ', p_motorsport=' || p_motorsport || ', p_email=' || p_email || ', p_comment=' || p_comment
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20005, 'User not found!');
        WHEN pkg_exception.news_not_found THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'News not found with these parameters!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_news_title=' || p_news_title || ', p_motorsport=' || p_motorsport || ', p_email=' || p_email || ', p_comment=' || p_comment
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20007, 'News not found with these parameters!');
        WHEN NO_DATA_FOUND THEN
          prc_log(p_log_type => 'E'
                 ,p_message => SQLERRM || 'Comment not found!'
                 ,p_backtrace => dbms_utility.format_error_backtrace
                 ,p_parameters => 'p_news_title=' || p_news_title || ', p_motorsport=' || p_motorsport || ', p_email=' || p_email || ', p_comment=' || p_comment
                 ,p_api => gc_pkg_name || '.' || c_prc_name);
                 
          raise_application_error(-20016,'Comment not found!');
        WHEN OTHERS THEN
            prc_log(p_log_type => 'E'
                   ,p_message => SQLERRM
                   ,p_backtrace => dbms_utility.format_error_backtrace
                   ,p_parameters => 'p_news_title=' || p_news_title || ', p_motorsport=' || p_motorsport || ', p_email=' || p_email || ', p_comment=' || p_comment
                   ,p_api => gc_pkg_name || '.' || c_prc_name);
                   
            raise_application_error(-20000, 'Unexpected error happened!');
   END delete_comment;

end pkg_comment;
/
