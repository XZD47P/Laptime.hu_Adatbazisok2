create or replace procedure motorsport_exists(p_motorsport_name IN VARCHAR2) is
v_count NUMBER;
begin
  SELECT COUNT(*)
  INTO v_count
  FROM motorsport
  WHERE motorsport_name=LOWER(p_motorsport_name);
  
  IF v_count=0
    THEN
      RAISE pkg_exception.motorsport_not_found;
  END IF;
  
end motorsport_exists;
/
