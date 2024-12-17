INSERT INTO reg_user(first_name,last_name,email,password,fav_driver,fav_team,email_subscription,user_role)
VALUES('Miklós','Teszt','miklos.teszt@gmail.com',pkg_cipher.encrypt('kisKutya'),'Lewis Hamilton','Mercedes',1,'user');

INSERT INTO reg_user(first_name,last_name,email,password,fav_driver,fav_team,email_subscription,user_role)
VALUES('Péter','Hajdu','peter.hajdu@gmail.com',pkg_cipher.encrypt('Urh@jos12'),'Lando Norris','Mclaren',0,'user');

INSERT INTO reg_user(first_name,last_name,email,password,fav_driver,fav_team,email_subscription,user_role)
VALUES('Zoltán','Kuti','zoltan.kuti@gmail.com',pkg_cipher.encrypt('Forz@Ferrari'),'Charles Lecreck','Ferrari',1,'user');

INSERT INTO reg_user(first_name,last_name,email,password,fav_driver,fav_team,email_subscription,user_role)
VALUES('Laura','Kiss','laura.kiss@gmail.com',pkg_cipher.encrypt('KissLaura2005'),'','',0,'user');
