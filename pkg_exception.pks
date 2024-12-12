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
       
       chatroom_already_exists EXCEPTION;
       PRAGMA EXCEPTION_INIT(chatroom_already_exists, -20008);
       
       chatroom_not_found EXCEPTION;
       PRAGMA EXCEPTION_INIT(chatroom_not_found, -20009);
       
       wrong_number_format EXCEPTION;
       PRAGMA EXCEPTION_INIT(wrong_number_format,-20010);
       
       race_date_occupied EXCEPTION;
       PRAGMA EXCEPTION_INIT(race_date_occupied, -20011);
       
       race_already_exists EXCEPTION;
       PRAGMA EXCEPTION_INIT(race_already_exists, -20012);
       
       race_not_found EXCEPTION;
       PRAGMA EXCEPTION_INIT(race_not_found, -20013);
       
       track_already_exists EXCEPTION;
       PRAGMA EXCEPTION_INIT(track_already_exists, -20014);
       
       track_not_found EXCEPTION;
       PRAGMA EXCEPTION_INIT(track_not_found, -20015);
end pkg_exception;
/
