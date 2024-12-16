create or replace function fn_user_exists(p_email IN  VARCHAR2) 
                           return number is
  v_count NUMBER;
  v_u_id number;
begin
  SELECT COUNT(*)
  INTO v_count
  FROM reg_user
  WHERE email=p_email;
  
  IF v_count=0
    THEN
      RAISE pkg_exception.user_not_found;
    ELSE
      SELECT user_id
      INTO v_u_id
      FROM reg_user
      WHERE email=p_email;
  END IF;  
  
  return v_u_id;
end fn_user_exists;
/
