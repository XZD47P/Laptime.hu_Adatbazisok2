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

EXCEPTION
  WHEN pkg_exception.user_not_found THEN
    raise_application_error(-20005,'User not found');
end user_exists;
/
