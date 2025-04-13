-- Definiti un trigger de tip LDD. Declansati trigger-ul.

CREATE TABLE audit_events (
    nume_bd VARCHAR2(50),
    user_logat VARCHAR2(30),
    eveniment VARCHAR2(20),
    tip_obiect_referit VARCHAR2(30),
    nume_obiect_referit VARCHAR2(30),
    data TIMESTAMP(3)
);


CREATE OR REPLACE TRIGGER audit_modificari
AFTER CREATE OR DROP OR ALTER ON SCHEMA
BEGIN
    INSERT INTO audit_events
    VALUES (
        SYS.DATABASE_NAME,              -- Numele bazei de date
        SYS.LOGIN_USER,                 -- Utilizatorul conectat
        SYS.SYSEVENT,                   -- Evenimentul (CREATE, DROP, ALTER)
        SYS.DICTIONARY_OBJ_TYPE,        -- Tipul obiectului (TABLE, INDEX etc.)
        SYS.DICTIONARY_OBJ_NAME,        -- Numele obiectului
        SYSTIMESTAMP(3)                 -- Momentul exact al evenimentului
    );
END;
/

CREATE TABLE exemplu (coloana1 NUMBER);

ALTER TABLE exemplu ADD (coloana2 VARCHAR2(50));

DROP TABLE exemplu;

SELECT * FROM audit_events;


DROP TRIGGER audit_modificari;
/
