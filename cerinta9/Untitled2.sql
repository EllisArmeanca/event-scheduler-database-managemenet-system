-- Formula?i în limbaj natural o problem? pe care s? o rezolva?i folosind un subprogram stocat independent de tip procedur? care s? aib? minim 2 parametri
--?i s? utilizeze într-o singur? comand? SQL 5 dintre tabelele create.

--Defini?i minim 2 excep?ii proprii, altele decât cele predefinite la nivel de sistem. 
--Apela?i subprogramul astfel încât s? eviden?ia?i toate cazurile definite ?i tratate.

-- CERIN?A:  Primind ca parametri un id_vorbitor si
--un id_eveniment afisati numarul de discursuri prestate, participantii si locul unde a fost cazat vorbitorul in cadrul evenimentului respectiv.

CREATE OR REPLACE PROCEDURE EX9(
    p_id_vorbitor IN NUMBER,
    p_id_eveniment IN NUMBER
) IS
    v_nume_vorbitor VARCHAR2(100);
    v_prenume_vorbitor VARCHAR2(100);
    v_tip_cazare VARCHAR2(100);
    v_adresa_cazare VARCHAR2(100);
    v_numar_discursuri NUMBER;
    v_numar_participanti NUMBER;

    -- Exceptii proprii
    fara_discursuri EXCEPTION;
    fara_participanti EXCEPTION;
    fara_cazare EXCEPTION;
BEGIN
    -- Interogare pentru a obtine detalii despre vorbitor, cazare, discursuri si numarul de participan?i
    SELECT v.nume, 
           v.prenume, 
           c.tip, 
           c.adresa,
           COUNT(DISTINCT vde.id_discurs) AS numar_discursuri,
           COUNT(DISTINCT p.id_participant) AS numar_participanti
    INTO v_nume_vorbitor, 
         v_prenume_vorbitor, 
         v_tip_cazare, 
         v_adresa_cazare,
         v_numar_discursuri,
         v_numar_participanti
    FROM VORBITORI v
    JOIN VORBITORI_DISCURSURI_EVENIMENTE vde ON v.id_vorbitor = vde.id_vorbitor
    JOIN EVENIMENTE e ON vde.id_eveniment = e.id_eveniment
    LEFT JOIN CAZARI c ON e.id_cazare = c.id_cazare
    LEFT JOIN PARTICIPANTI p ON e.id_eveniment = p.id_eveniment
    WHERE v.id_vorbitor = p_id_vorbitor
      AND vde.id_eveniment = p_id_eveniment
    GROUP BY v.nume, v.prenume, c.tip, c.adresa;
    IF v_numar_discursuri = 0 THEN
        RAISE fara_discursuri;
    END IF;

    IF v_numar_participanti = 0 THEN
        RAISE fara_participanti;
    END IF;

    IF v_tip_cazare IS NULL THEN
        RAISE fara_cazare;
    END IF;

    DBMS_OUTPUT.PUT_LINE('Vorbitor: ' || v_nume_vorbitor || ' ' || v_prenume_vorbitor);
    DBMS_OUTPUT.PUT_LINE('Tip cazare: ' || v_tip_cazare);
    DBMS_OUTPUT.PUT_LINE('Adresa cazare: ' || v_adresa_cazare);
    DBMS_OUTPUT.PUT_LINE('Numar discursuri în evenimentul specificat: ' || v_numar_discursuri);
    DBMS_OUTPUT.PUT_LINE('Numar participanti în evenimentul specificat: ' || v_numar_participanti);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Nu exista date pentru vorbitorul cu ID-ul ' || p_id_vorbitor || ' la evenimentul cu ID-ul ' || p_id_eveniment || '.');

    WHEN fara_participanti THEN
        DBMS_OUTPUT.PUT_LINE('Evenimentul cu ID-ul ' || p_id_eveniment || ' nu are participanti.');
    WHEN fara_cazare THEN
        DBMS_OUTPUT.PUT_LINE('Evenimentul cu ID-ul ' || p_id_eveniment || ' nu are cazare asociata.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('A aparut o eroare neasteptata: ' || SQLERRM);
END EX9;
/


BEGIN
    EX9(1004, 6000);
END;
/

BEGIN
    EX9(1004, 6099);
END;
/

INSERT INTO EVENIMENTE
VALUES (6088, 'TEST', 
        TO_DATE('15-04-2025','dd-mm-yyyy'), 
        TO_DATE('15-04-2025','dd-mm-yyyy'), 4000,  NULL ,3003 );
INSERT INTO VORBITORI_DISCURSURI_EVENIMENTE VALUES(1004, 5000, 6088);

BEGIN
    EX9(1004, 6088);
END;
/

delete from evenimente
where id_eveniment = 6088;


delete from participanti
where id_eveniment = 6088;
delete from VORBITORI_DISCURSURI_EVENIMENTE
where id_eveniment = 6088;

INSERT INTO EVENIMENTE
VALUES (6088, 'TEST',
        TO_DATE('15-04-2025','dd-mm-yyyy'),
        TO_DATE('15-04-2025','dd-mm-yyyy'), 4000,  NULL ,3003 );
INSERT INTO VORBITORI_DISCURSURI_EVENIMENTE VALUES(1004, 5000, 6088);
INSERT INTO PARTICIPANTI
VALUES (9999, 'Armeanca', 'Gabi', 'gab@yahoo.com', 6088);
BEGIN
    EX9(1004, 6088);
END;
/
