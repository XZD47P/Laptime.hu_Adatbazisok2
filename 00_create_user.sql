declare
  cursor cur is
    select 'alter system kill session ''' || sid || ',' || serial# || '''' as command
      from v$session
     where username = 'webpage_admin';
begin
  for c in cur loop
    EXECUTE IMMEDIATE c.command;
  end loop;
end;
/

DECLARE
  v_count NUMBER;
BEGIN
  SELECT COUNT(*) INTO v_count FROM dba_users t WHERE t.username='WEBPAGE_ADMIN';
  IF v_count = 1 THEN 
    EXECUTE IMMEDIATE 'DROP USER webpage_admin CASCADE';
  END IF;
END;
/
CREATE USER webpage_admin 
  IDENTIFIED BY "12345678" 
  DEFAULT TABLESPACE users
  QUOTA UNLIMITED ON users
;

grant CREATE TRIGGER to webpage_admin;
GRANT CREATE SESSION TO webpage_admin;
GRANT CREATE TABLE TO webpage_admin;
GRANT CREATE VIEW TO webpage_admin;
GRANT CREATE SEQUENCE TO webpage_admin;
GRANT CREATE PROCEDURE TO webpage_admin;
GRANT CREATE TYPE to webpage_admin;
GRANT EXECUTE ON SYS.DBMS_CRYPTO TO webpage_admin;


ALTER SESSION SET CURRENT_SCHEMA=webpage_admin;
