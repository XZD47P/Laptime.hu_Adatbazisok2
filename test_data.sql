--reg_user
INSERT INTO reg_user(first_name,last_name,email,password,fav_driver,fav_team,email_subscription,user_role)
VALUES('Miklos','Teszt','miklos.teszt@gmail.com',pkg_cipher.encrypt('kisKutya'),'Lewis Hamilton','Mercedes',1,'user');

INSERT INTO reg_user(first_name,last_name,email,password,fav_driver,fav_team,email_subscription,user_role)
VALUES('Peter','Hajdu','peter.hajdu@gmail.com',pkg_cipher.encrypt('Urh@jos12'),'Lando Norris','Mclaren',0,'user');

INSERT INTO reg_user(first_name,last_name,email,password,fav_driver,fav_team,email_subscription,user_role)
VALUES('Zoltan','Kuti','zoltan.kuti@gmail.com',pkg_cipher.encrypt('Forz@Ferrari'),'Charles Lecreck','Ferrari',1,'user');

INSERT INTO reg_user(first_name,last_name,email,password,fav_driver,fav_team,email_subscription,user_role)
VALUES('Laura','Kiss','laura.kiss@gmail.com',pkg_cipher.encrypt('KissLaura2005'),'','',0,'user');
--motorsport
INSERT INTO motorsport(motorsport_name)
VALUES('formula-1');

INSERT INTO motorsport(motorsport_name)
VALUES('wec');

INSERT INTO motorsport(motorsport_name)
VALUES('wrc');
--chatroom
INSERT INTO chatroom(chatroom_name,motorsport_category)
VALUES('Formula-1 igazolasok', (SELECT motorsport_id FROM motorsport WHERE motorsport_name=LOWER('formula-1')));

INSERT INTO chatroom(chatroom_name,motorsport_category)
VALUES('Rally Svedorszag',(SELECT motorsport_id FROM motorsport WHERE motorsport_name=LOWER('wrc')));

INSERT INTO chatroom(chatroom_name,motorsport_category)
VALUES('Rally balesetek',(SELECT motorsport_id FROM motorsport WHERE motorsport_name=LOWER('wrc')));

INSERT INTO chatroom(chatroom_name,motorsport_category)
VALUES('24H of Le-Mans',(SELECT motorsport_id FROM motorsport WHERE motorsport_name=LOWER('wec')));
--Chatroom_messages
BEGIN
send_message(p_chatroom_name => 'Formula-1 igazolasok',
             p_email => 'zoltan.kuti@gmail.com',
             p_message => 'Meglepett Hamilton Ferrarihoz való igazolása, de remélem, hogy sikeres lesz');
             
send_message(p_chatroom_name => 'Formula-1 igazolasok',
             p_email => 'miklos.teszt@gmail.com',
             p_message => 'Engem is, de a Ferrarinak még fejlõdnie kell, Hamilton ebben segíthet');
             
send_message(p_chatroom_name => 'Rally balesetek',
             p_email => 'peter.hajdu@gmail.com',
             p_message => 'Basszus az a pilóta mekkorát esett :O');
             
END;
--Favored_motorsport
BEGIN
  pkg_user.add_fav_motorsport(p_email => 'zoltan.kuti@gmail.com',
                              p_motorsport => 'formula-1');
                              
  pkg_user.add_fav_motorsport(p_email => 'laura.kiss@gmail.com',
                              p_motorsport => 'wec');
                              
  pkg_user.add_fav_motorsport(p_email => 'zoltan.kuti@gmail.com',
                              p_motorsport => 'wrc');
END;
--NEWS
BEGIN
  pkg_news.add_news(p_email => 'zoltan.kuti@gmail.com',
                    p_motorsport => 'formula-1',
                    p_title => 'Hir1',
                    p_description => 'Megelpo hosszu hir is lehetne');
  
  pkg_news.add_news(p_email => 'zoltan.kuti@gmail.com',
                    p_motorsport => 'formula-1',
                    p_title => 'Hir2',
                    p_description => 'Ferrari igazolas');
                    
  pkg_news.add_news(p_email => 'miklos.teszt@gmail.com',
                    p_motorsport => 'wec',
                    p_title => 'Hir3',
                    p_description => 'Porsche nyerte a legutobbi versenyt');             
END;
--news_comment
BEGIN
  pkg_comment.post_comment(p_news_title => 'Hir1',
                           p_motorsport => 'formula-1',
                           p_email => 'laura.kiss@gmail.com',
                           p_comment => 'Ez a hir nagyon meglepett');
  
  pkg_comment.post_comment(p_news_title => 'Hir1',
                           p_motorsport => 'formula-1',
                           p_email => 'miklos.teszt@gmail.com',
                           p_comment => 'Micsoda nem vart fordulatok');
                           
  pkg_comment.post_comment(p_news_title => 'Hir3',
                           p_motorsport => 'wec',
                           p_email => 'peter.hajdu@gmail.com',
                           p_comment => 'A Porsche mindig is a toppon volt.');
END;
--track
BEGIN
  pkg_track.add_track(p_track_name => 'Bahrain International Circuit',
                      p_country => 'Bahrain',
                      p_layout => '/Picture/bah.png');
                      
  pkg_track.add_track(p_track_name => 'Jeddah Corniche Circuit',
                      p_country => 'Saudi Arabia',
                      p_layout => '/Picture/jed.png');
                     
  pkg_track.add_track(p_track_name => 'Albert Park Grand Prix Circuit',
                      p_country => 'Austria',
                      p_layout => '/Picture/alb_park.png');
                      
  pkg_track.add_track(p_track_name => 'Track of Le Mans',
                      p_country => 'France',
                      p_layout => '/Picture/le_mans.png');
END;
--race
BEGIN
  pkg_race.add_race(p_motorsport => 'formula-1',
                    p_title => 'FORMULA 1 GULF AIR BAHRAIN GRAND PRIX 2024',
                    p_track => 'Bahrain International Circuit',
                    p_start_date => TO_DATE('2024.02.29.', 'YYYY.MM.DD.'),
                    p_end_date => TO_DATE('2024.03.02.', 'YYYY.MM.DD.'),
                    p_record_time => '1:31.447',
                    p_air_temp => 25,
                    p_asp_temp => 28,
                    p_wind_dir => 'DK',
                    p_wind_strenght => 10,
                    p_rain_percent => 20);
                    
  pkg_race.add_race(p_motorsport => 'formula-1',
                    p_title => 'FORMULA 1 STC SAUDI ARABIAN GRAND PRIX 2024',
                    p_track => 'Jeddah Corniche Circuit',
                    p_start_date => TO_DATE('2024.03.07', 'YYYY.MM.DD.'),
                    p_end_date => TO_DATE('2024.03.09', 'YYYY.MM.DD.'),
                    p_record_time => '1:30.734',
                    p_air_temp => 23,
                    p_asp_temp => 25,
                    p_wind_dir => 'EK',
                    p_wind_strenght => 20,
                    p_rain_percent => 40);
                    
  pkg_race.add_race(p_motorsport => 'formula-1',
                    p_title => 'FORMULA 1 ROLEX AUSTRALIAN GRAND PRIX 2024',
                    p_track => 'Albert Park Grand Prix Circuit',
                    p_start_date => TO_DATE('2024.03.22', 'YYYY.MM.DD.'),
                    p_end_date => TO_DATE('2024.03.24', 'YYYY.MM.DD.'),
                    p_record_time => '1:19.813',
                    p_air_temp => 24,
                    p_asp_temp => 30,
                    p_wind_dir => '',
                    p_wind_strenght => '',
                    p_rain_percent => 5);
                    
  pkg_race.add_race(p_motorsport => 'wec',
                    p_title => '24 hours of le mans',
                    p_track => 'track of le mans',
                    p_start_date => TO_DATE('2025.06.11', 'YYYY.MM.DD.'),
                    p_end_date => TO_DATE('2024.06.14', 'YYYY.MM.DD.'),
                    p_record_time => '3:17.297',
                    p_air_temp => '',
                    p_asp_temp => '',
                    p_wind_dir => '',
                    p_wind_strenght => '',
                    p_rain_percent => '');
END;

COMMIT;
