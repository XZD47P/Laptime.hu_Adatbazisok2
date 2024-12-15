CREATE OR REPLACE PROCEDURE prc_log(p_log_type   IN CHAR
                                   ,p_message    IN VARCHAR2
                                   ,p_parameters IN VARCHAR2
                                   ,p_api        IN VARCHAR2) IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO database_log
    (log_type
    ,message
    ,PARAMETERS
    ,api)
  VALUES
    (p_log_type
    ,p_message
    ,p_parameters
    ,p_api);
    
    COMMIT;
END prc_log;
/
