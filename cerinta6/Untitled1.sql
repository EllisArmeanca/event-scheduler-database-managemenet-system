--Formula?i în limbaj natural o problem? pe care s? o rezolva?i folosind un subprogram stocat independent care s? utilizeze toate cele 3 tipuri de colec?ii studiate.
--Apela?i subprogramul.

--Pentru fiecare sponsor calclueaza suma totala investita in evenimente de-a lungul timpului. Dupa aceea, afiseaza fiecare sponsor, suma totala si evenimentele unde a investit (maxim 5).

CREATE OR REPLACE PROCEDURE EX6 IS
    
    --definim colectiile
    TYPE tabel_sponsori IS  TABLE OF VARCHAR2(150); -- nested table
    TYPE sume_sponsori IS TABLE OF NUMBER INDEX BY VARCHAR2(150); -- tabel indexat pe baza string
    TYPE evenimente_sponsorizate IS VARRAY(5) OF VARCHAR2(150); -- vector
    
    sponsori tabel_sponsori := tabel_sponsori();
    sumes sume_sponsori;
    ev evenimente_sponsorizate :=evenimente_sponsorizate();

BEGIN
    SELECT s.nume
    BULK COLLECT INTO sponsori
    FROM SPONSORI s; --SPONSORII
    
    FOR i in 1 .. sponsori.COUNT LOOP
        SELECT SUM(es.suma)
        INTO sumes(sponsori(i))
        FROM EVENIMENTE_SPONSORI es
        JOIN SPONSORI s ON es.id_sponsor = s.id_sponsor
        WHERE s.nume = sponsori(i);
    END LOOP; --sumele
    
    FOR i in 1 .. sponsori.COUNT LOOP
        
        ev :=evenimente_sponsorizate();
        
        SELECT e.nume
        BULK COLLECT INTO ev
        FROM EVENIMENTE e
        JOIN EVENIMENTE_SPONSORI es ON e.id_eveniment = es.id_eveniment
        JOIN SPONSORI s ON es.id_sponsor = s.id_sponsor
        WHERE s.nume = sponsori(i)
        FETCH FIRST 5 ROWS ONLY;
        
        DBMS_OUTPUT.PUT_LINE('Sponsor: ' || sponsori(i));
        DBMS_OUTPUT.PUT_LINE('Suma totala: ' || sumes(sponsori(i)) || '€');
        DBMS_OUTPUT.PUT_LINE('Evenimente la care a contribuit: ');
        
        FOR j IN 1 .. ev.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(' - ' || ev(j));
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('-----------------------------');
    END LOOP;
    
END;
/

        
    
BEGIN
    EX6;
END;
/