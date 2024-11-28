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
      ,passoword  VARCHAR2(255)  NOT NULL
      ,modified_at      DATE            DEFAULT SYSDATE NOT NULL 
      ,modified_by      varchar2(50)
      ,created_at       DATE            DEFAULT SYSDATE NOT NULL  
      ,created_by       varchar2(50)
) TABLESPACE users;

ALTER TABLE user_credential
      ADD CONSTRAINT user_credential_pk PRIMARY KEY (u_id);
      
COMMENT ON TABLE webpage_admin.user_credential 
      IS 'Login credentials for users';

                      
