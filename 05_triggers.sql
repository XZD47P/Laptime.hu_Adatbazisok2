CREATE OR REPLACE TRIGGER reg_user_trg
  BEFORE INSERT OR UPDATE
  ON reg_user
  FOR EACH ROW

BEGIN
  IF INSERTING THEN
    IF :new.user_id IS NULL
    THEN
      :new.user_id := user_seq.nextval;
    END IF;

    IF :new.user_role IS NULL
      THEN
        :new.user_role:= 'user';
    END IF;
    
    :new.dml_flag:='I';
    :new.version:=1;
    :new.created_by:=sys_context('USERENV', 'OS_USER');
  END IF;
  
  
  IF UPDATING THEN
     
     :new.dml_flag:='U';
     :new.version:=:old.version+1;
     :new.modified_at:= sysdate;
     :new.modified_by:= sys_context('USERENV', 'OS_USER');  
  END IF;
  
END reg_user_trg;
/
create or replace trigger reg_user_h_trg
  after update or delete
  on reg_user 
  for each row

begin
  IF UPDATING THEN
    INSERT INTO reg_user_h(user_id,dml_flag,first_name,last_name,
                            email,password,fav_driver,fav_team,email_subscription,
                            user_role,modified_at,modified_by,version)
     VALUES(:new.user_id
           ,'U'
           ,:new.first_name
           ,:new.last_name
           ,:new.email
           ,:new.password
           ,:new.fav_driver
           ,:new.fav_team
           ,:new.email_subscription
           ,:new.user_role
           ,:new.modified_at
           ,sys_context('USERENV', 'OS_USER')
           ,:new.version
           );
  END IF;
  
  IF DELETING THEN
    INSERT INTO reg_user_h(user_id,dml_flag,first_name,last_name,
                            email,password,fav_driver,fav_team,email_subscription,
                            user_role,modified_at,modified_by,version)
    VALUES(:old.user_id
          ,'D'
          ,:old.first_name
          ,:old.last_name
          ,:old.email
          ,:old.password
          ,:old.fav_driver
          ,:old.fav_team
          ,:old.email_subscription
          ,:old.user_role
          ,:old.modified_at
          ,sys_context('USERENV', 'OS_USER')
          ,:old.version);
  END IF;
end reg_user_h_trg;
/
CREATE OR REPLACE TRIGGER news_trg
  BEFORE INSERT OR UPDATE
  ON news
  FOR EACH ROW

BEGIN
  IF INSERTING THEN
    IF :new.news_id IS NULL
    THEN
      :new.news_id := news_seq.nextval;
    END IF;
    :new.dml_flag:='I';
    :new.version:=1;
    :new.created_by:=sys_context('USERENV', 'OS_USER');
  END IF;
  
  IF UPDATING THEN
     :new.dml_flag:='U';
     :new.version:=:old.version+1;
     :new.modified_at:= sysdate;
     :new.modified_by:= sys_context('USERENV', 'OS_USER');    
  END IF;
END news_trg;

/
CREATE OR REPLACE TRIGGER motorsport_trg
  BEFORE INSERT OR UPDATE
  ON motorsport
  FOR EACH ROW

BEGIN
  IF INSERTING THEN
    IF :new.motorsport_id IS NULL
    THEN
      :new.motorsport_id := motorsport_seq.nextval;
    END IF;
    
    :new.motorsport_name:=LOWER(:new.motorsport_name);
    :new.dml_flag:='I';
    :new.version:=1;
    :new.created_by:=sys_context('USERENV', 'OS_USER');
  END IF;
      
  IF UPDATING THEN
    :new.dml_flag:='U';
    :new.version:=:old.version+1;
    :new.modified_at:= sysdate;
    :new.modified_by:= sys_context('USERENV', 'OS_USER');
  END IF;
END motorsport_trg;

/
CREATE OR REPLACE TRIGGER chatroom_trg
  BEFORE INSERT OR UPDATE
  ON chatroom
  FOR EACH ROW

BEGIN
  IF INSERTING THEN
    IF :new.chatroom_id IS NULL
    THEN
      :new.chatroom_id := chatroom_seq.nextval;
    END IF;
    :new.dml_flag:='I';
    :new.version:=1;
    :new.chatroom_name:=LOWER(:new.chatroom_name);
    :new.created_by:=sys_context('USERENV', 'OS_USER');
  END IF;
  
  IF UPDATING THEN
    :new.dml_flag:='U';
    :new.version:=:old.version+1;
    :new.modified_at:= sysdate;
    :new.modified_by:= sys_context('USERENV', 'OS_USER');
  END IF;
END chatroom_trg;

/
CREATE OR REPLACE TRIGGER chatroom_msg_trg
  BEFORE INSERT ON chatroom_messages
  FOR EACH ROW

BEGIN
  IF :new.message_id IS NULL
  THEN
    :new.message_id := chatroom_msg_seq.nextval;
  END IF;
END chatroom_msq_trg;
/
CREATE OR REPLACE TRIGGER race_trg
  BEFORE INSERT OR UPDATE
  ON race
  FOR EACH ROW

BEGIN
  IF INSERTING THEN
    IF :new.race_id IS NULL
    THEN
      :new.race_id := race_seq.nextval;
    END IF;
    :new.title:=UPPER(:new.title);
    :new.dml_flag:='I';
    :new.version:=1;
    :new.created_by:=sys_context('USERENV', 'OS_USER');
  END IF;
  
  
  IF UPDATING THEN
    :new.dml_flag:='U';
    :new.version:=:old.version+1;
    :new.modified_at:=sysdate;
    :new.modified_by:=sys_context('USERENV', 'OS_USER');                 
  END IF;
  
END race_trg;

/
create or replace trigger race_h_trg
  after update or delete
  on race 
  for each row

begin
  IF UPDATING THEN
    INSERT INTO race_h(race_id,
                       dml_flag,
                       motorsport_id,
                       title,
                       track_id,
                       race_date_start,
                       race_date_end,
                       air_temperature,
                       asp_temperature,
                       wind_strength,
                       wind_direction,
                       rain_percentage,
                       record_time,
                       modified_at,
                       modified_by,
                       version)
    VALUES(:new.race_id
          ,'U'
          ,:new.motorsport_id
          ,:new.title
          ,:new.track_id
          ,:new.race_date_start
          ,:new.race_date_end
          ,:new.air_temperature
          ,:new.asp_temperature
          ,:new.wind_strength
          ,:new.wind_direction
          ,:new.rain_percentage
          ,:new.record_time
          ,:new.modified_at
          ,sys_context('USERENV', 'OS_USER')
          ,:new.version);
  END IF;
  
  
  IF DELETING THEN
    INSERT INTO race_h(race_id,
                       dml_flag,
                       motorsport_id,
                       title,
                       track_id,
                       race_date_start,
                       race_date_end,
                       air_temperature,
                       asp_temperature,
                       wind_strength,
                       wind_direction,
                       rain_percentage,
                       record_time,
                       modified_at,
                       modified_by,
                       version)
    VALUES(:old.race_id
          ,'D'
          ,:old.motorsport_id
          ,:old.title
          ,:old.track_id
          ,:old.race_date_start
          ,:old.race_date_end
          ,:old.air_temperature
          ,:old.asp_temperature
          ,:old.wind_strength
          ,:old.wind_direction
          ,:old.rain_percentage
          ,:old.record_time
          ,:old.modified_at
          ,sys_context('USERENV', 'OS_USER'),
          :old.version+1);
  END IF;
end race_h_trg;
/
CREATE OR REPLACE TRIGGER news_comment_trg
  BEFORE INSERT ON news_comment
  FOR EACH ROW

BEGIN
  IF :new.comment_id IS NULL
  THEN
    :new.comment_id := comment_seq.nextval;
  END IF;
END news_comment_trg;
/
CREATE OR REPLACE TRIGGER track_trg
  BEFORE INSERT OR UPDATE
  ON track
  FOR EACH ROW

BEGIN
  IF INSERTING THEN
    IF :new.track_id IS NULL
    THEN
      :new.track_id := track_seq.nextval;
    END IF;
    :new.dml_flag:='I';
    :new.version:=1;
    :new.created_by:=sys_context('USERENV', 'OS_USER');
  END IF;
  
  IF UPDATING THEN
    :new.dml_flag:='U';
    :new.version:=:old.version+1;
    :new.modified_at:=sysdate;
    :new.modified_by:=sys_context('USERENV', 'OS_USER');
  END IF;
END track_trg;

/
CREATE OR REPLACE TRIGGER trg_log
  BEFORE INSERT ON database_log
  FOR EACH ROW

BEGIN
  IF :new.log_id IS NULL
  THEN
    :new.log_id := log_seq.nextval;
  END IF;
  :new.created_by := sys_context('USERENV', 'OS_USER');
END trg_log;
/

