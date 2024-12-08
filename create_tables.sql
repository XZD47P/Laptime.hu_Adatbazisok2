CREATE TABLE reg_user(
       user_id         NUMBER NOT NULL
      ,first_name      varchar2(30) NOT NULL
      ,last_name       varchar2(30) NOT NULL
      ,fav_driver      varchar2(50)
      ,fav_team        varchar2(50)
      ,email_subscription NUMBER(1)
      ,user_role       varchar2(10) DEFAULT 'user' NOT NULL 
      ,modified_at     DATE         DEFAULT SYSDATE NOT NULL 
      ,modified_by     varchar2(50)
      ,created_at      DATE         DEFAULT SYSDATE NOT NULL  
      ,created_by      varchar2(50)
) TABLESPACE users;

ALTER TABLE reg_user
      ADD CONSTRAINT reg_user_pk PRIMARY KEY (user_id);
     
COMMENT ON TABLE webpage_admin.reg_user 
        IS 'Registered users of the webpage';
        

CREATE TABLE motorsport(
       motorsport_id   NUMBER   NOT NULL
      ,motorport_name  varchar2(20) NOT NULL
      ,modified_at     DATE         DEFAULT SYSDATE NOT NULL 
      ,modified_by     varchar2(50)
      ,created_at      DATE         DEFAULT SYSDATE NOT NULL  
      ,created_by      varchar2(50)
) TABLESPACE users;

ALTER TABLE motorsport
      ADD CONSTRAINT motorsport_pk PRIMARY KEY (motorsport_id);
      
COMMENT ON TABLE webpage_admin.motorsport 
        IS 'Motorsports which are available';
        
     
CREATE TABLE favored_motorsport(
       u_id             NUMBER    NOT NULL
      ,motorsport_id    NUMBER    NOT NULL
      ,modified_at      DATE         DEFAULT SYSDATE NOT NULL 
      ,modified_by      varchar2(50)
      ,created_at       DATE         DEFAULT SYSDATE NOT NULL  
      ,created_by       varchar2(50)
) TABLESPACE users;

ALTER TABLE favored_motorsport
      ADD CONSTRAINT favored_motorsport_pk PRIMARY KEY (u_id,motorsport_id);

COMMENT ON TABLE webpage_admin.favored_motorsport 
        IS 'User favorite motorsports';
        
        
CREATE TABLE news(
       news_id                NUMBER       NOT NULL
      ,u_id                   NUMBER       NOT NULL 
      ,title                  varchar2(50) NOT NULL
      ,news_description       NCLOB        NOT NULL
      ,motorsport_category    NUMBER       NOT NULL
      ,published              NUMBER(1)    DEFAULT 0 NOT NULL
      ,modified_at            DATE         DEFAULT SYSDATE NOT NULL 
      ,modified_by            varchar2(50)
      ,created_at             DATE         DEFAULT SYSDATE NOT NULL  
      ,created_by             varchar2(50)
) TABLESPACE users;

ALTER TABLE news
      ADD CONSTRAINT news_pk PRIMARY KEY (news_id);
      
COMMENT ON TABLE webpage_admin.news 
      IS 'News of the page';
      
      
CREATE TABLE news_comment(
       comment_id     NUMBER         NOT NULL
      ,u_id           NUMBER         NOT NULL
      ,news_id        NUMBER         NOT NULL
      ,n_comment      VARCHAR2(255)  NOT NULL
      ,modified_at    DATE         DEFAULT SYSDATE NOT NULL 
      ,modified_by    varchar2(50)
      ,created_at     DATE         DEFAULT SYSDATE NOT NULL  
      ,created_by     varchar2(50)
) TABLESPACE users;

ALTER TABLE news_comment
      ADD CONSTRAINT news_comment_pk PRIMARY KEY (comment_id);
      
COMMENT ON TABLE webpage_admin.news_comment 
      IS 'Comments sent by users to news';
      
      
CREATE TABLE chatroom(
       chatroom_id      NUMBER          NOT NULL
      ,chatroom_name    VARCHAR2(50)    NOT NULL
      ,motorsport_category NUMBER       NOT NULL
      ,modified_at      DATE            DEFAULT SYSDATE NOT NULL 
      ,modified_by      varchar2(50)
      ,created_at       DATE            DEFAULT SYSDATE NOT NULL  
      ,created_by       varchar2(50)    
) TABLESPACE users;

ALTER TABLE chatroom
      ADD CONSTRAINT chatroom_pk PRIMARY KEY (chatroom_id);
      
COMMENT ON TABLE webpage_admin.chatroom 
      IS 'Created chatrooms';
      
      
CREATE TABLE user_credential(
       u_id       NUMBER         NOT NULL
      ,email      VARCHAR2(100)  NOT NULL
      ,password   RAW(2000)      NOT NULL
      ,modified_at      DATE            DEFAULT SYSDATE NOT NULL 
      ,modified_by      varchar2(50)
      ,created_at       DATE            DEFAULT SYSDATE NOT NULL  
      ,created_by       varchar2(50)
) TABLESPACE users;

ALTER TABLE user_credential
      ADD CONSTRAINT user_credential_pk PRIMARY KEY (u_id);
      
COMMENT ON TABLE webpage_admin.user_credential 
      IS 'Login credentials for users';


CREATE TABLE race(
       race_id              NUMBER          NOT NULL
      ,motorsport_id        NUMBER          NOT NULL
      ,title                VARCHAR2(255)   NOT NULL
      ,layout_pic           VARCHAR2(255)   NOT NULL
      ,country              VARCHAR2(50)    NOT NULL
      ,race_date_start      DATE            NOT NULL
      ,race_date_end        DATE            NOT NULL
      ,air_temperature      NUMBER
      ,asp_temperature      NUMBER
      ,wind_strength        NUMBER(5,2)
      ,wind_direction       CHAR(2)
      ,rain_percentage      NUMBER
      ,record_time          NUMBER
      ,modified_at          DATE            DEFAULT SYSDATE NOT NULL 
      ,modified_by          varchar2(50)
      ,created_at           DATE            DEFAULT SYSDATE NOT NULL  
      ,created_by           varchar2(50)
)TABLESPACE users;

ALTER TABLE race
      ADD CONSTRAINT race_pk PRIMARY KEY (race_id);
      
COMMENT ON TABLE webpage_admin.race
      IS 'Race details for motorsport seasons';
      
      
CREATE TABLE database_log(
       log_id          NUMBER         NOT NULL
      ,log_type        NUMBER         NOT NULL
      ,message         VARCHAR2(255)  
      ,api             VARCHAR2(50)
      ,created_at      DATE            DEFAULT SYSDATE NOT NULL  
      ,created_by      varchar2(50)
)TABLESPACE users;                      

ALTER TABLE database_log
      ADD CONSTRAINT adatabase_log_pk PRIMARY KEY (log_id);
      
COMMENT ON TABLE webpage_admin.race
      IS 'History and changes in the database';
      
      
CREATE TABLE chatroom_messages(
       message_id     NUMBER          NOT NULL
      ,chatroom_id    NUMBER          NOT NULL
      ,user_id        NUMBER          NOT NULL
      ,message        VARCHAR2(2000)  NOT NULL
      ,created_at     DATE            DEFAULT SYSDATE NOT NULL
)TABLESPACE users;

ALTER TABLE chatroom_messages
      ADD CONSTRAINT chatroom_messages_pk PRIMARY KEY (message_id);
      
COMMENT ON TABLE webpage_admin.chatroom_messages
        IS 'Messages sent by users in chatrooms'; 
