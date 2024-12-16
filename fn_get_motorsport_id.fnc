create or replace function fn_get_motorsport_id(p_motorsport_name VARCHAR2)
                           return number 
                           is
  v_m_id NUMBER;
  v_count NUMBER;
begin
   SELECT COUNT(*)
  INTO v_count
  FROM motorsport
  WHERE motorsport_name=LOWER(p_motorsport_name);
  
  IF v_count=0
    THEN
      RAISE pkg_exception.motorsport_not_found;
    ELSE
      SELECT motorsport_id
      INTO v_m_id
      FROM motorsport
      WHERE motorsport_name=LOWER(p_motorsport_name);
  END IF;
  
  return v_m_id;
end fn_get_motorsport_id;
/
