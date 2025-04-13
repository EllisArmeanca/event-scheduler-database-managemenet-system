-- Formula?i în limbaj natural o problem? pe care s? o rezolva?i folosind un subprogram stocat independent de tip func?ie care 
-- sa utilizeze într-o singur? comand? SQL 3 dintre tabelele create. Trata?i toate excep?iile care pot ap?rea, incluzând excep?iile predefinite NO_DATA_FOUND ?i TOO_MANY_ROWS.
-- Apela?i subprogramul astfel încât s? eviden?ia?i toate cazurile tratate.

 -- calculati suma totala a facturilora asociate evenimentelor organizate de un anumit grup , transmis prin nume
 
CREATE OR REPLACE FUNCTION EX8(
    nume_grup IN VARCHAR2
) RETURN NUMBER IS
    v_test NUMBER; -- pt existenta grupului
    suma_facturi NUMBER;
    
    no_facturi_exception EXCEPTION; -- exceptie proprie
    
    TYPE facturi_evenimente IS VARRAY(20) OF NUMBER;
    fe facturi_evenimente := facturi_evenimente();
    
    TYPE evenimente IS VARRAY(6) OF NUMBER;
    ev evenimente:= evenimente();
BEGIN
    
    --verificam existenta grupului
    SELECT g.id_grup
    INTO v_test
    FROM GRUPURI g
    WHERE g.nume = nume_grup;
    
    SELECT id_eveniment
    BULK COLLECT INTO ev
    from EVENIMENTE;
    
    --retin facturile pt fiecare event intr o colectie si sa le afisez.
--    
--    FOR i in 1..ev.COUNT LOOP
--        SELECT suma
--        BULK COLLECT into fe
--        from FACTURI
--        where id_eveniment = ev(i);
--        
--        
--        DBMS_OUTPUT.PUT_LINE('Facturile pt evenimentul ' || ev(i));
--        FOR i in 1..fe.COUNT LOOP
--            DBMS_OUTPUT.PUT_LINE(fe(i));
--        END LOOP;
--        fe := facturi_evenimente();
--        DBMS_OUTPUT.NEW_LINE;
--    END LOOP;
    
    SELECT SUM(f.suma)
    INTO suma_facturi
    FROM FACTURI f
    JOIN EVENIMENTE e ON f.id_eveniment = e.id_eveniment
    JOIN GRUPURI g ON e.id_grup = g.id_grup
    WHERE g.nume = nume_grup;
    
    IF suma_facturi IS NULL THEN
        RAISE no_facturi_exception;
    END IF;
    
    RETURN suma_facturi;

EXCEPTION

    -- nu exista grupul
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Grupul cu numele ' || nume_grup || ' nu exista ');
        RETURN -1;
    
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Exista mai multe grupuri cu numele '|| nume_grup);
        RETURN -2;
        
    WHEN no_facturi_exception THEN
        DBMS_OUTPUT.PUT_LINE('Grupul ' || nume_grup || ' nu are facturi asociate.');
        RETURN 0;
    
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('A aparut o eroare neasteptata: ' || SQLERRM);
        RETURN -3;
END EX8;
/

DECLARE
    v_total_facturi NUMBER;
BEGIN
    v_total_facturi := EX8('Bucuresti Tech Talks');
    DBMS_OUTPUT.PUT_LINE('Total facturi: ' || v_total_facturi);
END;
/

--no data found
DECLARE
    v_total_facturi NUMBER;
BEGIN
    v_total_facturi := EX8('Grup');
    DBMS_OUTPUT.PUT_LINE('Total facturi: ' || v_total_facturi);
END;
/

INSERT INTO GRUPURI
VALUES (4099, 'Bucuresti Tech Talks', 'X'  );
    --too many rows
DECLARE
    v_total_facturi NUMBER;
BEGIN
    v_total_facturi := EX8('Bucuresti Tech Talks');
    DBMS_OUTPUT.PUT_LINE('Total facturi: ' || v_total_facturi);
END;
/

delete from grupuri
where id_grup = 4099;
--no facturi exception
INSERT INTO GRUPURI
VALUES (4099, 'Bucuresti Tech Talks2', 'X'  );
    
DECLARE
    v_total_facturi NUMBER;
BEGIN
    v_total_facturi := EX8('Bucuresti Tech Talks2');
    DBMS_OUTPUT.PUT_LINE('Total facturi: ' || v_total_facturi);
END;
/