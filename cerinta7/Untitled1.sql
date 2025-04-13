--7. Formula?i în limbaj natural o problem? pe care s? o rezolva?i folosind un subprogram stocat independent care s? utilizeze 2 tipuri diferite de cursoare studiate, 
--unul dintre acestea fiind cursor parametrizat, dependent de cel?lalt cursor. Apela?i subprogramul.

--afisati toti participantii care au fost prezenti, pentru fiecare eveniment

CREATE OR REPLACE PROCEDURE EX7 IS
    
    
    --cursor clasic
    CURSOR c_evenimente IS
        SELECT id_eveniment, nume
        FROM EVENIMENTE;
    
    --cursor parametrizat
    CURSOR c_participanti(ev NUMBER) IS
        SELECT nume, prenume, email
        FROM PARTICIPANTI p
        WHERE ev = p.id_eveniment;
    
    v_id_eveniment EVENIMENTE.id_eveniment%TYPE;
    v_nume_ev EVENIMENTE.nume%TYPE;
    
    v_nume PARTICIPANTI.nume%TYPE;
    v_prenume PARTICIPANTI.prenume%TYPE;
    v_email PARTICIPANTI.email%TYPE;
    
BEGIN
    OPEN c_evenimente;
    LOOP
        FETCH c_evenimente INTO v_id_eveniment, v_nume_ev;
        EXIT WHEN c_evenimente%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('Eveniment: ' || v_nume_ev || ' id: ' || v_id_eveniment);
        DBMS_OUTPUT.PUT_LINE('Participanti: ');
        
        OPEN c_participanti(v_id_eveniment);
        LOOP
            FETCH c_participanti INTO v_nume, v_prenume, v_email;
            EXIT when c_participanti %NOTFOUND;
            
            DBMS_OUTPUT.PUT_LINE(' - ' || v_nume || ' ' || v_prenume || ' (' || v_email || ')');
        END LOOP;
        CLOSE c_participanti;
        
        DBMS_OUTPUT.PUT_LINE('------------------------');
        
    END LOOP;
    CLOSE c_evenimente;

END;
/

BEGIN
    EX7;
END;
/