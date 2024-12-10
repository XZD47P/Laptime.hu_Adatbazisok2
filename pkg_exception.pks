create or replace package pkg_exception is

       user_already_exists EXCEPTION;
       PRAGMA EXCEPTION_INIT(user_already_exists, -20001);
       
       incorrect_password EXCEPTION;
       PRAGMA EXCEPTION_INIT (incorrect_password, -20002);
       
       motorsport_already_exists EXCEPTION;
       PRAGMA EXCEPTION_INIT(motorsport_already_exists, -20003);
       
       motorsport_not_found EXCEPTION;
       PRAGMA EXCEPTION_INIT(motorsport_not_found, -20004);
       
       user_not_found EXCEPTION;
       PRAGMA EXCEPTION_INIT(user_not_found, -20005);
       
       user_not_favourite_motorsport EXCEPTION;
       PRAGMA EXCEPTION_INIT(user_not_favourite_motorsport, -20006);
       
       news_not_found EXCEPTION;
       PRAGMA EXCEPTION_INIT(news_not_found, -20007);
end pkg_exception;
/
