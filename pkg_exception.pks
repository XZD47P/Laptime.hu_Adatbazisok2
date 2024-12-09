create or replace package pkg_exception is

       user_already_exists EXCEPTION;
       PRAGMA EXCEPTION_INIT(user_already_exists, -20001);
       
       incorrect_password EXCEPTION;
       PRAGMA EXCEPTION_INIT (incorrect_password, -20002);

end pkg_exception;
/
