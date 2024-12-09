create or replace package pkg_cipher is

       FUNCTION encrypt(p_plain_password VARCHAR2) RETURN RAW;

       FUNCTION decrypt(p_email VARCHAR2) RETURN VARCHAR2;
end pkg_cipher;
/
create or replace package body pkg_cipher is

       v_key   VARCHAR2 (2000) := 'hqx3rq9b96m6hytl';
       v_mod   NUMBER:=
                        DBMS_CRYPTO.ENCRYPT_AES128
                       +DBMS_CRYPTO.CHAIN_CBC
                       +DBMS_CRYPTO.PAD_PKCS5;
       
       
       FUNCTION encrypt(p_plain_password VARCHAR2) RETURN RAW
                        IS
       v_enc RAW(2000);
       BEGIN
        v_enc:= DBMS_CRYPTO.encrypt (UTL_I18N.string_to_raw (p_plain_password, 'AL32UTF8'),
                           v_mod,
                           UTL_I18N.string_to_raw (v_key, 'AL32UTF8'));
         
         RETURN v_enc;
       END encrypt;
       
       
       FUNCTION decrypt(p_email VARCHAR2) RETURN VARCHAR2
                        IS
       v_enc_password RAW(2000);
       v_password RAW(2000);
       BEGIN
         SELECT password
         INTO v_enc_password
         FROM reg_user
         WHERE email=p_email;
         
         v_password:= DBMS_CRYPTO.decrypt (v_enc_password,
                           v_mod,
                           UTL_I18N.STRING_TO_RAW (v_key, 'AL32UTF8'));
         
         RETURN UTL_I18N.raw_to_char(v_password);
       
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
             RAISE NO_DATA_FOUND;                                
       END decrypt;         
end pkg_cipher;
/
