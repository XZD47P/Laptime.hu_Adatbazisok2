create or replace package pkg_news is

       PROCEDURE add_news(p_email IN VARCHAR2,
                          p_motorsport IN VARCHAR2,
                          p_title IN VARCHAR2,
                          p_description IN VARCHAR2);
       
       PROCEDURE delete_news(p_title IN VARCHAR2);
       
       PROCEDURE edit_news_param(p_title IN VARCHAR2,
                                 p_email IN VARCHAR2,
                                 p_motorsport IN VARCHAR2);

       PROCEDURE publish_news(p_email IN VARCHAR2,
                              p_motorsport IN VARCHAR2,
                              P_title IN VARCHAR2);
                              

end pkg_news;
/
create or replace package body pkg_news is

       gc_pkg_name CONSTANT VARCHAR2(30):= 'pkg_news';

   PROCEDURE add_news(p_email IN VARCHAR2,
                      p_motorsport IN VARCHAR2,
                      p_title IN VARCHAR2,
                      p_description IN VARCHAR2)
                      IS
       v_u_id NUMBER;
       v_m_id NUMBER;
       c_prc_name CONSTANT VARCHAR2(30):= 'add_news';
       BEGIN
         v_u_id:= fn_get_user_id(p_email => p_email);
         v_m_id:=fn_get_motorsport_id(p_motorsport_name => p_motorsport);
         
         /*SELECT user_id
         INTO v_u_id
         FROM reg_user
         WHERE email=p_email;
         
         SELECT motorsport_id
         INTO v_m_id
         FROM motorsport
         WHERE motorsport_name=LOWER(p_motorsport);*/
         
         INSERT INTO NEWS(U_ID,MOTORSPORT_CATEGORY,TITLE,NEWS_DESCRIPTION)
         VALUES(v_u_id,v_m_id,p_title,to_clob(p_description));
         COMMIT;
         
         dbms_output.put_line('News added successfully! Please publish it, if you want others to see!');
         prc_log(p_log_type => 'I'
                ,p_message => 'News added successfully! Please publish it, if you want others to see!'
                ,p_backtrace => ''
                ,p_parameters => 'p_email=' || p_email || ', p_motorsport=' || p_motorsport || ', p_title=' || p_title
                ,p_api => gc_pkg_name || '.' || c_prc_name);
       EXCEPTION
         WHEN pkg_exception.user_not_found THEN
           prc_log(p_log_type => 'E'
                  ,p_message => SQLERRM || 'User not found!'
                  ,p_backtrace => dbms_utility.format_error_backtrace
                  ,p_parameters => 'p_email=' || p_email || ', p_motorsport=' || p_motorsport || ', p_title=' || p_title
                  ,p_api => gc_pkg_name || '.' || c_prc_name);
                  
              raise_application_error(-20005,'User not found');
         WHEN pkg_exception.motorsport_not_found THEN
           prc_log(p_log_type => 'E'
                  ,p_message => SQLERRM || 'Motorsport not found!'
                  ,p_backtrace => dbms_utility.format_error_backtrace
                  ,p_parameters => 'p_email=' || p_email || ', p_motorsport=' || p_motorsport || ', p_title=' || p_title
                  ,p_api => gc_pkg_name || '.' || c_prc_name);
                  
              raise_application_error(-20004, 'Motorsport not found!');
   END add_news;
   
   
   PROCEDURE delete_news(p_title IN VARCHAR2)
                         IS
       v_n_id NUMBER;
       v_news_count NUMBER;
       c_prc_name CONSTANT VARCHAR2(30):= 'delete_news';
       BEGIN
         
         SELECT COUNT(*)
         INTO v_news_count
         FROM news
         WHERE title=p_title;
         
         IF v_news_count=0
           THEN
             RAISE pkg_exception.news_not_found;
           ELSE
             SELECT news_id
             INTO v_n_id
             FROM news
             WHERE title=p_title;
         END IF;
         
         --Hirhez kapcsolodo hozzaszolasok torlese
         DELETE FROM news_comment
         WHERE news_id=v_n_id;
         
         --Hir torlese
         DELETE FROM news
         WHERE news_id=v_n_id;
         COMMIT;
         
         dbms_output.put_line('News deleted successfully!');
         prc_log(p_log_type => 'I'
                ,p_message => 'News deleted successfully!'
                ,p_backtrace => ''
                ,p_parameters => 'p_title=' || p_title
                ,p_api => gc_pkg_name || '.' || c_prc_name);
       EXCEPTION
         WHEN pkg_exception.news_not_found THEN
           prc_log(p_log_type => 'E'
                  ,p_message => SQLERRM || 'News not found with this title!'
                  ,p_backtrace => dbms_utility.format_error_backtrace
                  ,p_parameters => 'p_title=' || p_title
                  ,p_api => gc_pkg_name || '.' || c_prc_name);
                  
              raise_application_error(-20007,'News not found with these parameters!');  
   END delete_news;
       
       
   PROCEDURE edit_news_param(p_title IN VARCHAR2,
                             p_email IN VARCHAR2,
                             p_motorsport IN VARCHAR2)
                             IS
      v_u_id NUMBER;
      v_m_id NUMBER;
      c_prc_name CONSTANT VARCHAR2(30):= 'edit_news_param';
      BEGIN
        v_u_id:= fn_get_user_id(p_email => p_email);
        v_m_id:= fn_get_motorsport_id(p_motorsport_name => p_motorsport);
        
        UPDATE news
        SET u_id=v_u_id,motorsport_category=v_m_id
        WHERE title=p_title;
        COMMIT;
        
        dbms_output.put_line('News successfully updated!');
        prc_log(p_log_type => 'I'
                ,p_message => 'News deleted successfully!'
                ,p_backtrace => ''
                ,p_parameters => 'p_email=' || p_email || ', p_motorsport=' || p_motorsport || ', p_title=' || p_title
                ,p_api => gc_pkg_name || '.' || c_prc_name);
      EXCEPTION
        WHEN pkg_exception.user_not_found THEN
          prc_log(p_log_type => 'E'
                  ,p_message => SQLERRM || 'User not found!'
                  ,p_backtrace => dbms_utility.format_error_backtrace
                  ,p_parameters => 'p_email=' || p_email || ', p_motorsport=' || p_motorsport || ', p_title=' || p_title
                  ,p_api => gc_pkg_name || '.' || c_prc_name);
                  
              raise_application_error(-20005,'User not found');
        WHEN pkg_exception.motorsport_not_found THEN
          prc_log(p_log_type => 'E'
                  ,p_message => SQLERRM || 'Motorsport not found!'
                  ,p_backtrace => dbms_utility.format_error_backtrace
                  ,p_parameters => 'p_email=' || p_email || ', p_motorsport=' || p_motorsport || ', p_title=' || p_title
                  ,p_api => gc_pkg_name || '.' || c_prc_name);
                  
              raise_application_error(-20004, 'Motorsport not found!');
   
   END edit_news_param;    
   
   
   PROCEDURE publish_news(p_email IN VARCHAR2,
                          p_motorsport IN VARCHAR2,
                          P_title IN VARCHAR2)
                          IS
       v_u_id NUMBER;
       v_m_id NUMBER;
       v_news_count NUMBER;
       c_prc_name CONSTANT VARCHAR2(30):= 'publish_news';      
       BEGIN
        v_u_id:= fn_get_user_id(p_email => p_email);
        v_m_id:=fn_get_motorsport_id(p_motorsport_name => p_motorsport);
         
        /* SELECT user_id
         INTO v_u_id
         FROM reg_user
         WHERE email=p_email;
         
         SELECT motorsport_id
         INTO v_m_id
         FROM motorsport
         WHERE motorsport_name=LOWER(p_motorsport);*/
         
         SELECT COUNT(*)
         INTO v_news_count
         FROM news
         WHERE u_id=v_u_id AND motorsport_category=v_m_id AND title=p_title;
         
         IF v_news_count=0
           THEN
             RAISE pkg_exception.news_not_found;
         END IF;
         
         UPDATE news
         SET published=1
         WHERE u_id=v_u_id AND motorsport_category=v_m_id AND title=p_title;
         COMMIT;
         
         dbms_output.put_line('News published successfully');
         prc_log(p_log_type => 'I'
                ,p_message => 'News published successfully!'
                ,p_backtrace => ''
                ,p_parameters => 'p_email=' || p_email || ', p_motorsport=' || p_motorsport || ', p_title=' || p_title
                ,p_api => gc_pkg_name || '.' || c_prc_name);
       EXCEPTION
         WHEN pkg_exception.user_not_found THEN
           prc_log(p_log_type => 'E'
                  ,p_message => SQLERRM || 'User not found'
                  ,p_backtrace => dbms_utility.format_error_backtrace
                  ,p_parameters => 'p_email=' || p_email || ', p_motorsport=' || p_motorsport || ', p_title=' || p_title
                  ,p_api => gc_pkg_name || '.' || c_prc_name);
                  
              raise_application_error(-20005,'User not found');
         WHEN pkg_exception.motorsport_not_found THEN
           prc_log(p_log_type => 'E'
                  ,p_message => SQLERRM || 'Motorsport not found'
                  ,p_backtrace => dbms_utility.format_error_backtrace
                  ,p_parameters => 'p_email=' || p_email || ', p_motorsport=' || p_motorsport || ', p_title=' || p_title
                  ,p_api => gc_pkg_name || '.' || c_prc_name);
                  
              raise_application_error(-20004, 'Motorsport not found!');
         WHEN pkg_exception.news_not_found THEN
           prc_log(p_log_type => 'E'
                  ,p_message => SQLERRM || 'News not found with these parameters!'
                  ,p_backtrace => dbms_utility.format_error_backtrace
                  ,p_parameters => 'p_email=' || p_email || ', p_motorsport=' || p_motorsport || ', p_title=' || p_title
                  ,p_api => gc_pkg_name || '.' || c_prc_name);
                  
              raise_application_error(-20007,'News not found with these parameters!');  
   END publish_news;
                
end pkg_news;
/
