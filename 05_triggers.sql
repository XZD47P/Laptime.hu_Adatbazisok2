CREATE OR REPLACE TRIGGER reg_user_trg
  BEFORE INSERT ON reg_user
  FOR EACH ROW

BEGIN
  IF :new.user_id IS NULL
  THEN
    :new.user_id := user_seq.nextval;
  END IF;
  
  IF :new.user_role IS NULL
    THEN
      :new.user_role:= 'user';
  END IF;
END reg_user_trg;
/
CREATE OR REPLACE TRIGGER news_trg
  BEFORE INSERT ON news
  FOR EACH ROW

BEGIN
  IF :new.news_id IS NULL
  THEN
    :new.news_id := news_seq.nextval;
  END IF;
END news_trg;
/
CREATE OR REPLACE TRIGGER motorsport_trg
  BEFORE INSERT ON motorsport
  FOR EACH ROW

BEGIN
  IF :new.motorsport_id IS NULL
  THEN
    :new.motorsport_id := motorsport_seq.nextval;
  END IF;
END motorsport_trg;
/
CREATE OR REPLACE TRIGGER chatroom_trg
  BEFORE INSERT ON chatroom
  FOR EACH ROW

BEGIN
  IF :new.chatroom_id IS NULL
  THEN
    :new.chatroom_id := chatroom_seq.nextval;
  END IF;
END chatroom_trg;
/
CREATE OR REPLACE TRIGGER chatroom_msq_trg
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
  BEFORE INSERT ON race
  FOR EACH ROW

BEGIN
  IF :new.race_id IS NULL
  THEN
    :new.race_id := race_seq.nextval;
  END IF;
END race_trg;
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
  BEFORE INSERT ON track
  FOR EACH ROW

BEGIN
  IF :new.track_id IS NULL
  THEN
    :new.track_id := track_seq.nextval;
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
END trg_log;


