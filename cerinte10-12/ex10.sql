-- Defini?i un trigger de tip LMD la nivel de comand?. Declan?a?i trigger-ul.
-- voi crea un trigger care se va declansa atunci cand vreau sa modific tabela VORBITORI in intervalul orar 15:00 - 24:00


CREATE OR REPLACE TRIGGER EX10
BEFORE INSERT OR DELETE OR UPDATE ON VORBITORI
BEGIN
    IF TO_CHAR(SYSDATE, 'HH24') BETWEEN 15 AND 24 THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Tabela VORBITORI nu se poate modifica in intervalul orar 15:00-24:00!'
        );
    END IF;
END;
/

INSERT INTO VORBITORI
VALUES(vorbitori_seq.nextval, 'Man', 'Dennis', 'dennis98@gmail.com', '+40734889777');

DROP TRIGGER EX10;