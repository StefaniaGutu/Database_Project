--Ex 11: Cereri SQL
--1. Sa se listeze toti furnizorii (id-ul si denumirea) care au furnizat ingrediente ce au fost continute de produsele din comanda
--clientilor cu numele "Popescu" si sunt comenzi date pentru evenimente. Rezultatul se va ordona in functie de id-ul furnizorului.

SELECT DISTINCT f.id_furnizor, f.denumire
FROM furnizori f JOIN ingrediente i ON (f.id_furnizor=i.id_furnizor)
                JOIN contine c ON (i.id_ingredient=c.id_ingredient)
                JOIN produse p ON (p.id_produs=c.id_produs)
                JOIN gateste_serveste g ON (p.id_produs=g.id_produs)
                JOIN comenzi co ON (g.id_comanda=co.id_comanda)
                JOIN clienti cli ON (cli.id_client=co.id_client)
WHERE UPPER(cli.nume)='POPESCU' AND co.id_eveniment IS NOT NULL
ORDER BY f.id_furnizor;


--2.Pentru fiecare comanda care are ziua plasarii mai mare sau egala cu 15 sa se afiseze numarul de bucatari si numarul de ospatari 
--care au gatit/servit produsele comandate. Rezultatul se va ordona in functie de id-ul comenzii.

SELECT c.id_comanda, (SELECT COUNT( DISTINCT g.id_angajat)
                    FROM angajati a JOIN gateste_serveste g ON (a.id_angajat=g.id_angajat) 
                    WHERE tip_angajat='bucatar' and c.id_comanda=g.id_comanda
                   ) Nr_bucatari,
                   (SELECT COUNT( DISTINCT g.id_angajat)
                    FROM angajati a JOIN gateste_serveste g ON (a.id_angajat=g.id_angajat) 
                    WHERE tip_angajat='ospatar' and c.id_comanda=g.id_comanda
                   ) Nr_ospatari
FROM comenzi c
WHERE TO_NUMBER(SUBSTR(TO_CHAR(c.data_comanda), 1, 2)) >=15
ORDER BY c.id_comanda;


--3. Sa se afiseze cate produse din fiecare categorie au fost comandate pentru evenimente de tip nunta care au avut loc in anul 2021.
--Rezultatul va fi de forma "Din categoria *nume_categorie* au fost comandate *nr* produse."

SELECT 'Din categoria ' || nume_categorie || ' au fost comandate ' || TO_CHAR(SUM(cantitate)) || ' produse.'
FROM categorii c JOIN produse p ON (p.id_categorie=c.id_categorie)
                 JOIN gateste_serveste g ON (g.id_produs=p.id_produs)
                 JOIN angajati a ON (g.id_angajat=a.id_angajat)
WHERE a.tip_angajat='ospatar' AND id_comanda IN (SELECT id_comanda
                                                FROM comenzi co JOIN evenimente e ON (e.id_eveniment=co.id_eveniment)
                                                                JOIN tipuri_evenimente t ON (e.id_tip_eveniment=t.id_tip_eveniment)
                                                WHERE t.denumire_tip='nunta' AND SUBSTR(TO_CHAR(data_eveniment),8,9)='21'
                                                )
GROUP BY nume_categorie;


--4. Pentru fiecare an din perioada 2019-2021 sa se afiseze totalul incasarilor restaurantului.
--varianta1, folosind having
WITH incasari2019 AS (SELECT TO_CHAR(data_comanda,'YYYY'), SUM(cantitate*pret) Suma
                      FROM gateste_serveste g JOIN comenzi c ON (g.id_comanda=c.id_comanda)
                                              JOIN produse p ON (p.id_produs=g.id_produs)
                                              JOIN angajati a ON (g.id_angajat=a.id_angajat)
                     WHERE tip_angajat='ospatar'
                     GROUP BY TO_CHAR(data_comanda,'YYYY')
                     HAVING TO_CHAR(data_comanda,'YYYY')=2019
                     ),
                     
incasari2020 AS (SELECT TO_CHAR(data_comanda,'YYYY'), SUM(cantitate*pret) Suma
                 FROM gateste_serveste g JOIN comenzi c ON (g.id_comanda=c.id_comanda)
                                         JOIN produse p ON (p.id_produs=g.id_produs)
                                         JOIN angajati a ON (g.id_angajat=a.id_angajat)
                 WHERE tip_angajat='ospatar'
                 GROUP BY TO_CHAR(data_comanda,'YYYY')
                 HAVING TO_CHAR(data_comanda,'YYYY')=2020
                 ),
                 
incasari2021 AS (SELECT TO_CHAR(data_comanda,'YYYY'), SUM(cantitate*pret) Suma
                 FROM gateste_serveste g JOIN comenzi c ON (g.id_comanda=c.id_comanda)
                                         JOIN produse p ON (p.id_produs=g.id_produs)
                                         JOIN angajati a ON (g.id_angajat=a.id_angajat)
                 WHERE tip_angajat='ospatar'
                 GROUP BY TO_CHAR(data_comanda,'YYYY')
                 HAVING TO_CHAR(data_comanda,'YYYY')=2021
                 )
                 -- s-au calculat incasarile pentru fiecare an cerut, daca se facea o grupare (fara having - varianta2)
                 -- exista posibilitatea ca intr-un an cerut sa nu fi existat incasari
SELECT DISTINCT TO_CHAR(data_comanda,'YYYY') An, DECODE(TO_CHAR(data_comanda,'YYYY'), 2019, (SELECT Suma
                                                                                             FROM incasari2019
                                                                                             ),
                                                                                      2020, (SELECT Suma
                                                                                             FROM incasari2020
                                                                                             ),
                                                                                      2021, (SELECT Suma
                                                                                             FROM incasari2021
                                                                                             ),
                                                                                      0
                                                        ) Suma_incasari
FROM comenzi
ORDER BY An;

--varianta2, fara having
SELECT TO_CHAR(data_comanda,'YYYY') An, SUM(cantitate*pret) Suma
FROM gateste_serveste g JOIN comenzi c ON (g.id_comanda=c.id_comanda)
                        JOIN produse p ON (p.id_produs=g.id_produs)
                        JOIN angajati a ON (g.id_angajat=a.id_angajat)
WHERE tip_angajat='ospatar'
GROUP BY TO_CHAR(data_comanda,'YYYY')
ORDER BY An;


--5. Pentru fiecare comanda se se afiseze daca este o comanda data pentru eveniment, iar in caz contrar sa se afiseze "Fara eveniment", 
--numarul de produse comandate si tipul din care face parte: Comanda mica- pana in 10 produse comandate
                                                                       --Comanda medie - intre 10 si 30 de produse comandate
                                                                       --Comanda mare - peste 30 de produse

WITH cantitati_comanda AS (SELECT c.id_comanda, SUM(cantitate) Cant   --se calculeaza cantitatea pentru fiecare comanda
                           FROM gateste_serveste g JOIN angajati a ON (g.id_angajat=a.id_angajat)
                                                   JOIN comenzi c ON (c.id_comanda=g.id_comanda)
                           WHERE tip_angajat='ospatar'
                           GROUP BY c.id_comanda
                           )

SELECT id_comanda, NVL(TO_CHAR(id_eveniment),'Fara eveniment') Eveniment, (SELECT Cant
                                                                            FROM cantitati_comanda cc
                                                                            WHERE cc.id_comanda=c.id_comanda
                                                                            ) AS cantitate,
                                                CASE --pentru a vedea ce tip de comanda este (mica/medie/mare)
                                                    WHEN (SELECT Cant
                                                          FROM cantitati_comanda cc
                                                          WHERE cc.id_comanda=c.id_comanda
                                                          )<10 THEN 'Comanda mica'
                                                    WHEN (SELECT Cant
                                                          FROM cantitati_comanda cc
                                                          WHERE cc.id_comanda=c.id_comanda
                                                          )<=30 THEN 'Comanda medie'
                                                ELSE 'Comanda mare'
                                                END AS Tip_Comanda
                                                                            
FROM comenzi c
ORDER BY id_comanda;


--Ex 12: 3 operatii de actualizare sau suprimare a datelor utilizând subcereri
--1. Sa se mareasca cu 5 lei pretul tuturor produselor din categoria paste.
UPDATE produse
SET pret=pret+5
WHERE id_produs IN (SELECT id_produs
                    FROM produse p JOIN categorii c ON (p.id_categorie=c.id_categorie)
                    WHERE lower(nume_categorie)='paste'
                   );

SELECT * FROM produse;
ROLLBACK;

--2. Sa se actualizeze data evenimentului organizat de Popescu Maria din 15-09-2020 in 22-09-2020.
UPDATE evenimente
SET data_eveniment=TO_DATE('22-09-2020', 'dd-mm-yyyy')
WHERE id_eveniment=(SELECT e.id_eveniment
                    FROM evenimente e JOIN comenzi co ON (e.id_eveniment=co.id_eveniment)
                                      JOIN clienti c ON (co.id_client=c.id_client)
                    WHERE initcap(nume)='Popescu' AND prenume='Maria' AND data_eveniment=TO_DATE('15-09-2020', 'dd-mm-yyyy')
                   );
                   
SELECT * FROM evenimente;               
ROLLBACK;                  

--3. Sa se stearga comenzile date de clientul cu numele Istrate dupa data de 1 septembrie 2020.
DELETE FROM gateste_serveste --intai se sterg liniile din tabelul gateste_serveste deoarece acesta contine fk id_comanda
WHERE id_comanda IN (SELECT id_comanda
                    FROM comenzi co JOIN clienti c ON (co.id_client=c.id_client)
                    WHERE initcap(nume)='Istrate' and data_comanda > TO_DATE('01-09-2020','dd-mm-yyyy')
                    );
                    
DELETE FROM comenzi --apoi se sterg comenzile ce indeplinesc conditiile mentionate 
WHERE id_comanda IN (SELECT id_comanda
                    FROM comenzi co JOIN clienti c ON (co.id_client=c.id_client)
                    WHERE initcap(nume)='Istrate' and data_comanda > TO_DATE('01-09-2020','dd-mm-yyyy')
                    );
                    
SELECT * FROM gateste_serveste;
SELECT * FROM comenzi;
ROLLBACK;

--Ex 16: OUTER JOIN
--Pentru fiecare comanda data dupa data de 1-ianuarie-2020 sa se afiseze numele clientului, data comenzii si tipul de eveniment pentru care a fost data, 
--daca comanda nu este data pentru un eveniment se va afisa "Fara eveniment".
SELECT nume, data_comanda, NVL(denumire_tip, 'Fara eveniment') Tip_eveniment
FROM clienti c FULL OUTER JOIN comenzi co ON (c.id_client=co.id_client)
               FULL OUTER JOIN evenimente e ON (co.id_eveniment=e.id_eveniment)
               FULL OUTER JOIN tipuri_evenimente t ON (e.id_tip_eveniment=t.id_tip_eveniment)
WHERE data_comanda>=TO_DATE('01-01-2020', 'dd-mm-yyyy');

--DIVISION
--1. Sa se listeze toti ospatarii care au servit numai produse din categoria bauturi.
WITH id_uri_bauturi AS (SELECT id_produs
                        FROM produse p JOIN categorii c ON (p.id_categorie=c.id_categorie)
                        WHERE lower(nume_categorie)='bauturi'
                        )
SELECT DISTINCT a.id_angajat, nume, prenume   --lista cu toti ospatarii care servesc bauturi
FROM angajati a JOIN gateste_serveste g ON (a.id_angajat=g.id_angajat)
WHERE tip_angajat='ospatar' AND id_produs IN (SELECT id_produs
                                              FROM id_uri_bauturi
                                              )
MINUS

SELECT DISTINCT a.id_angajat, nume, prenume   --lista cu toti ospatarii care servesc alte categorii de produse inafara de bauturi
FROM angajati a JOIN gateste_serveste g ON (a.id_angajat=g.id_angajat)
WHERE tip_angajat='ospatar' AND id_produs NOT IN (SELECT id_produs
                                                  FROM id_uri_bauturi
                                                  );
                                                  
-- => nu exista ospatari care sa fi servit numai bauturi


--2. Sa se obtina toti bucatarii care au gatit pentru cel putin doua evenimente.
SELECT a.id_angajat, nume
FROM angajati a JOIN gateste_serveste g ON (a.id_angajat=g.id_angajat)
WHERE tip_angajat='bucatar' AND g.id_comanda IN
                                (SELECT id_comanda
                                FROM comenzi
                                WHERE id_eveniment IS NOT NULL
                                )  --sunt selectati toti bucatarii care au gatit pentru evenimente
GROUP BY a.id_angajat, nume
HAVING 2<= (SELECT COUNT(*)  --este pusa conditia sa fi gatit la cel putin doua evenimente
            FROM gateste_serveste gs
            WHERE gs.id_angajat=a.id_angajat AND gs.id_comanda IN
                                (SELECT id_comanda
                                 FROM comenzi
                                 WHERE id_eveniment IS NOT NULL
                                 )  
            GROUP BY gs.id_angajat
            );
