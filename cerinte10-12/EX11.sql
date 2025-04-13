-- Defini?i un trigger de tip LMD la nivel de linie. Declan?a?i trigger-ul.
-- voi crea un trigger care se va declansa atunci cand vreau sa modific adaug o linie in tabela EVENIMENT 
--a carei data de inceput sa fie 24, 25 decembrie, 1 ianuarie sau 1 mai


CREATE OR REPLACE TRIGGER EX11
BEFORE INSERT OR UPDATE ON EVENIMENTE
FOR EACH ROW
DECLARE
BEGIN
    IF TO_CHAR(:NEW.data_inceput, 'DD-MM') IN ('24-12', '25-12', '01-01', '01-05') THEN
        RAISE_APPLICATION_ERROR(
            -20001,
            'Data de inceput a evenimentului nu poate fi în zilele: 24 decembrie, 25 decembrie, 1 ianuarie, sau 1 mai.'
        );
    END IF;
END;
/




INSERT INTO EVENIMENTE
VALUES (6070, 'TEST', 
        TO_DATE('01-01-2025','dd-mm-yyyy'), 
        TO_DATE('05-01-2025','dd-mm-yyyy'), 4000, 2000, 3003 );
        
DROP TRIGGER EX11;