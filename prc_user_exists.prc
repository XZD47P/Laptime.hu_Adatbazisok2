CREATE OR REPLACE Procedure user_exists(p_email IN VARCHAR2) is
  v_count number;
begin
  SELECT COUNT(*)
  INTO v_count
  FROM reg_user
  WHERE email=p_email;
  
  IF v_count=0
    THEN
      RAISE pkg_exception.user_not_found;
  END IF;  

end user_exists;
/
