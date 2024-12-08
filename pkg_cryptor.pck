create or replace package pkg_cryptor is

       FUNCTION encrypt(p_plain_password VARCHAR2) RETURN RAW;
end pkg_cryptor;
/
create or replace package body pkg_cryptor is

       v_key   VARCHAR2 (2000) := 'hqx3rq9b96m6hytl';
       v_mod   NUMBER:=
                        DBMS_CRYPTO.ENCRYPT_AES128
                       +DBMS_CRYPTO.CHAIN_CBC
                       +DBMS_CRYPTO.PAD_PKCS5;
       
       
       FUNCTION encrypt(p_plain_password VARCHAR2) RETURN RAW
                        IS
       p_enc RAW(2000);
       BEGIN
        p_enc:= DBMS_CRYPTO.encrypt (UTL_I18N.string_to_raw (p_plain_password, 'AL32UTF8'),
                           v_mod,
                           UTL_I18N.string_to_raw (v_key, 'AL32UTF8'));
         
         RETURN p_enc;
       END encrypt;
end pkg_cryptor;
/
