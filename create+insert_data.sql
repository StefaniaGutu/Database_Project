--crearea tabelului clienti
CREATE TABLE clienti
    (id_client number(5),
    nume varchar2(25) constraint c_nume not null,
    prenume varchar2(25),
    nr_telefon char(10),
    CONSTRAINT client_pk PRIMARY KEY (id_client),
    unique(nr_telefon)
    );

--secventa pentru generarea codurilor clientilor
CREATE SEQUENCE SEQ_CLIENT
INCREMENT by 1
START WITH 1
MINVALUE 1
MAXVALUE 1000
NOCYCLE;

--inserarea datelor in tabelul clienti
INSERT INTO clienti(id_client, nume, prenume, nr_telefon)
    VALUES (SEQ_CLIENT.NEXTVAL, 'Popescu', 'Maria', '0371692722');
INSERT INTO clienti(id_client, nume, prenume, nr_telefon)
    VALUES (SEQ_CLIENT.NEXTVAL, 'Radu',	'Andrei', '0772262672');
INSERT INTO clienti(id_client, nume, prenume, nr_telefon)
    VALUES (SEQ_CLIENT.NEXTVAL, 'Avram', 'Ana-Maria', '0727635283');    
INSERT INTO clienti(id_client, nume, prenume, nr_telefon)
    VALUES (SEQ_CLIENT.NEXTVAL, 'Gavrila', 'Cristina', '0742830745');    
INSERT INTO clienti(id_client, nume, prenume, nr_telefon)
    VALUES (SEQ_CLIENT.NEXTVAL, 'Istrate', 'Bogdan-Ionut', '0739428220');    
INSERT INTO clienti(id_client, nume, prenume, nr_telefon)
    VALUES (SEQ_CLIENT.NEXTVAL, 'Comnoiu', 'Adela-Ioana', '0762863289');    
INSERT INTO clienti(id_client, nume, prenume, nr_telefon)
    VALUES (SEQ_CLIENT.NEXTVAL, 'Marin', 'Liviu', '0758263927');

SELECT * FROM clienti;  

--crearea tabelului tipuri_evenimente    
CREATE TABLE tipuri_evenimente
    (id_tip_eveniment number(5),
    denumire_tip varchar2(20),
    descriere long,
    CONSTRAINT tip_eveniment_pk PRIMARY KEY (id_tip_eveniment)
    );

--inserarea datelor in tabelul tipuri_evenimente
INSERT INTO tipuri_evenimente
    VALUES (121, 'nunta', null);
INSERT INTO tipuri_evenimente
    VALUES (122, 'botez', null);
INSERT INTO tipuri_evenimente
    VALUES (123, 'aniversare', 'inclusiv majorat');    
INSERT INTO tipuri_evenimente
    VALUES (124, 'revedere', 'liceu/facultate');    
INSERT INTO tipuri_evenimente
    VALUES (125, 'cununie',	null);    
    
SELECT * FROM tipuri_evenimente;

--crearea tabelului evenimente
CREATE TABLE evenimente
    (id_eveniment number(5),
    data_eveniment date,
    preferinte long,
    id_tip_eveniment number(5) CONSTRAINT c_tip_eveniment not null,
    CONSTRAINT eveniment_pk PRIMARY KEY (id_eveniment),
    unique(data_eveniment),
    CONSTRAINT eveniment_fk foreign key(id_tip_eveniment) references tipuri_evenimente(id_tip_eveniment)
    );
  
--inserarea datelor in tabelul evenimente
INSERT INTO evenimente
    VALUES (110, to_date('13-07-2021','dd-mm-yyyy'), 'decor albastru', 122);
INSERT INTO evenimente
    VALUES (111, to_date('25-06-2021','dd-mm-yyyy'), null, 125); 
INSERT INTO evenimente
    VALUES (112, to_date('15-09-2020','dd-mm-yyyy'), null, 124); 
INSERT INTO evenimente
    VALUES (113, to_date('03-04-2021','dd-mm-yyyy'), 'flori naturale', 121); 
INSERT INTO evenimente
    VALUES (114, to_date('28-02-2021','dd-mm-yyyy'), 'decor rosu', 123); 
    
SELECT * FROM evenimente;

--crearea tabelului moduri_de_plata
CREATE TABLE moduri_de_plata
    (id_mod_plata number(5),
    denumire varchar2(20),
    observatii long,
    CONSTRAINT mod_plata_pk PRIMARY KEY (id_mod_plata),
    unique(denumire)
    );
  
--inserarea datelor in tabelul moduri_de_plata
INSERT INTO moduri_de_plata
    VALUES (600, 'cash', null);
INSERT INTO moduri_de_plata
    VALUES (610, 'card', null);
INSERT INTO moduri_de_plata
    VALUES (620, 'online', null);
INSERT INTO moduri_de_plata
    VALUES (630, 'in rate', 'numai pentru evenimente');
INSERT INTO moduri_de_plata
    VALUES (640, 'tichet', null);
    
SELECT * FROM moduri_de_plata;

--crearea tabelului comenzi
CREATE TABLE comenzi
    (id_comanda number(5),
    data_comanda date default sysdate,
    id_mod_plata number(5) constraint mod_not_null not null,
    id_client number(5) constraint client_not_null not null,
    id_eveniment number(5),
    CONSTRAINT comenzi_pk PRIMARY KEY (id_comanda),
    CONSTRAINT comanda_mod_plata_fk foreign key(id_mod_plata) references moduri_de_plata(id_mod_plata),
    CONSTRAINT comanda_client_fk foreign key(id_client) references clienti(id_client),
    CONSTRAINT comanda_eveniment_fk foreign key(id_eveniment) references evenimente(id_eveniment)
    );

--secventa pentru generarea codurilor comenzilor
CREATE SEQUENCE SEQ_COMENZI
INCREMENT by 10
START WITH 10
MINVALUE 10
MAXVALUE 10000
NOCYCLE; 

--inserarea datelor in tabelul comenzi
INSERT INTO comenzi
     VALUES(SEQ_COMENZI.NEXTVAL, to_date('09-03-2021','dd-mm-yyyy'), 600, 2, 113);
INSERT INTO comenzi
     VALUES(SEQ_COMENZI.NEXTVAL, to_date('15-10-2020','dd-mm-yyyy'), 610, 5, null);     
INSERT INTO comenzi
     VALUES(SEQ_COMENZI.NEXTVAL, to_date('03-05-2020','dd-mm-yyyy'), 620, 1, null);     
INSERT INTO comenzi
     VALUES(SEQ_COMENZI.NEXTVAL, to_date('05-07-2021','dd-mm-yyyy'), 600, 3, 110);    
INSERT INTO comenzi
     VALUES(SEQ_COMENZI.NEXTVAL, to_date('18-10-2019','dd-mm-yyyy'), 630, 7, null);
INSERT INTO comenzi
     VALUES(SEQ_COMENZI.NEXTVAL, to_date('23-12-2020','dd-mm-yyyy'), 610, 4, null);     
INSERT INTO comenzi
     VALUES(SEQ_COMENZI.NEXTVAL, to_date('16-02-2021','dd-mm-yyyy'), 620, 2, 114);     
INSERT INTO comenzi
     VALUES(SEQ_COMENZI.NEXTVAL, to_date('30-04-2021','dd-mm-yyyy'), 600, 6, 111);     
INSERT INTO comenzi
     VALUES(SEQ_COMENZI.NEXTVAL, to_date('02-08-2020','dd-mm-yyyy'), 630, 1, 112);     
    
SELECT * FROM COMENZI;

--crearea tabelului categorii
CREATE TABLE categorii
    (id_categorie number(5),
    nume_categorie varchar(20) constraint nume_categ_not_null not null,
    CONSTRAINT categorii_pk PRIMARY KEY (id_categorie),
    unique(nume_categorie)
    );

--secventa pentru generarea codurilor categoriilor
CREATE SEQUENCE SEQ_CATEGORII
INCREMENT by 10
START WITH 200
MINVALUE 200
MAXVALUE 10000
NOCYCLE; 

--inserarea datelor in tabelul categorii
INSERT INTO categorii
    VALUES (SEQ_CATEGORII.NEXTVAL, 'paste');
INSERT INTO categorii
    VALUES (SEQ_CATEGORII.NEXTVAL, 'salate');    
INSERT INTO categorii
    VALUES (SEQ_CATEGORII.NEXTVAL, 'pizza');    
INSERT INTO categorii
    VALUES (SEQ_CATEGORII.NEXTVAL, 'desert');    
INSERT INTO categorii
    VALUES (SEQ_CATEGORII.NEXTVAL, 'bauturi');    
INSERT INTO categorii
    VALUES (SEQ_CATEGORII.NEXTVAL, 'friptura');   

SELECT * FROM categorii;

--crearea tabelului furnizori
CREATE TABLE furnizori
    (id_furnizor number(5),
    denumire varchar2(20) constraint denumiref_not_null not null,
    nr_telefon char(10) constraint nr_telf_not_null not null,
    unique(nr_telefon),
    unique(denumire),
    CONSTRAINT furnizori_pk PRIMARY KEY (id_furnizor)
    );

--secventa pentru generarea codurilor furnizorilor
CREATE SEQUENCE SEQ_FURNIZOR
INCREMENT by 10
START WITH 1000
MINVALUE 1000
MAXVALUE 90000
NOCYCLE; 

--inserarea datelor in tabelul furnizori
INSERT INTO furnizori
    VALUES (SEQ_FURNIZOR.NEXTVAL, 'SC Bucuria Gustului', '0764652224');
INSERT INTO furnizori
    VALUES (SEQ_FURNIZOR.NEXTVAL, 'SC Gustos din Natura', '0775375472');    
INSERT INTO furnizori
    VALUES (SEQ_FURNIZOR.NEXTVAL, 'SC CrisFoods', '0775264221');   
INSERT INTO furnizori
    VALUES (SEQ_FURNIZOR.NEXTVAL, 'SC De Bun Gust', '0787625242');    
INSERT INTO furnizori
    VALUES (SEQ_FURNIZOR.NEXTVAL, 'SC Delicios', '0769727366');    

SELECT * FROM furnizori; 

--crearea tabelului ingrediente
CREATE TABLE ingrediente
    (id_ingredient number(5),
    denumire varchar2(20) constraint denumire_i_not_null not null,
    id_furnizor number(5) constraint furnizor_not_null not null,
    CONSTRAINT ingrediente_pk PRIMARY KEY (id_ingredient),
    CONSTRAINT ingred_furnizor_fk foreign key(id_furnizor) references furnizori(id_furnizor),
    unique(denumire)
    );
    
--secventa pentru generarea codurilor ingredientelor
CREATE SEQUENCE SEQ_INGREDIENT
INCREMENT by 1
START WITH 170
MINVALUE 170
MAXVALUE 90000
NOCYCLE;

--inserarea datelor in tabelul ingrediente
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'spaghete', 1000);
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'sos de rosii', 1000);  
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'carne tocata', 1010);  
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'parmezan', 1020);  
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'salata verde', 1030);  
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'piept de pui', 1020);  
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'rosii', 1000);  
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'castraveti', 1040);  
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'branza', 1040);  
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'faina', 1020);  
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'masline', 1030);  
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'piscoturi', 1000);
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'mascarpone', 1010);    
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'ciocolata', 1010);    
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'apa', 1030); 
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'suc', 1040);
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'vin', 1010);
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'carne porc', 1020);
INSERT INTO ingrediente
    VALUES(SEQ_INGREDIENT.NEXTVAL, 'carne pui', 1020);
    
SELECT * FROM ingrediente;

--crearea tabelului produse
CREATE TABLE produse
    (id_produs number(5),
    denumire varchar2(30) constraint denumire_p_not_null not null,
    pret number(3) constraint pret_not_null not null,
    observatii long,
    id_categorie number(5) constraint categ_not_null not null,
    unique(denumire),
    check(pret>0),
    CONSTRAINT produse_pk PRIMARY KEY (id_produs),
    CONSTRAINT produs_categ_fk foreign key(id_categorie) references categorii(id_categorie)
    );
 
--secventa pentru generarea codurilor produselor
CREATE SEQUENCE SEQ_PRODUS
INCREMENT by 1
START WITH 50
MINVALUE 50
MAXVALUE 90000
NOCYCLE;

--inserarea datelor in tabelul produse
INSERT INTO produse
    VALUES(SEQ_PRODUS.NEXTVAL, 'paste carbonara', 24, '300g', 200);
INSERT INTO produse
    VALUES(SEQ_PRODUS.NEXTVAL, 'paste bologneze', 22, null,	200);
INSERT INTO produse
    VALUES(SEQ_PRODUS.NEXTVAL, 'salata cu pui',	23,	'200g',	210);    
INSERT INTO produse
    VALUES(SEQ_PRODUS.NEXTVAL, 'salata greceasca', 16, '200g', 210);    
INSERT INTO produse
    VALUES(SEQ_PRODUS.NEXTVAL, 'pizza margherita', 17, 'medie',	220);    
INSERT INTO produse
    VALUES(SEQ_PRODUS.NEXTVAL, 'pizza capriciosa', 19, 'medie', 220);    
INSERT INTO produse
    VALUES(SEQ_PRODUS.NEXTVAL, 'tiramisu', 15, null, 230);    
INSERT INTO produse
    VALUES(SEQ_PRODUS.NEXTVAL, 'clatite', 14, null, 230);    
INSERT INTO produse
    VALUES(SEQ_PRODUS.NEXTVAL, 'apa', 5, '500ml', 240);    
INSERT INTO produse
    VALUES(SEQ_PRODUS.NEXTVAL, 'suc', 7, 'diverse sortimente', 240);    
INSERT INTO produse
    VALUES(SEQ_PRODUS.NEXTVAL, 'vin', 10, 'la sticla', 240);
INSERT INTO produse
    VALUES(SEQ_PRODUS.NEXTVAL, 'friptura pui', 25, '230g', 250);    
INSERT INTO produse
    VALUES(SEQ_PRODUS.NEXTVAL, 'friptura porc',	28,	'200g',	250);
    
SELECT * FROM produse;

--crearea tabelului contine
CREATE TABLE contine
    (id_produs number(5) constraint produs_not_null not null,
    id_ingredient number(5) constraint ingred_not_null not null,
    CONSTRAINT contine_ingred_fk foreign key(id_ingredient) references ingrediente(id_ingredient),
    CONSTRAINT contine_produs_fk foreign key(id_produs) references produse(id_produs),
    CONSTRAINT pk_contine primary key(id_produs, id_ingredient)
    );
    
--inserarea datelor in tabelul contine
INSERT INTO contine
    VALUES(50,170);
INSERT INTO contine
    VALUES(50,173);
INSERT INTO contine
    VALUES(51,170);    
INSERT INTO contine
    VALUES(51,171);    
INSERT INTO contine
    VALUES(51,172);    
INSERT INTO contine
    VALUES(52,174);    
INSERT INTO contine
    VALUES(52,175);    
INSERT INTO contine
    VALUES(53,174);    
INSERT INTO contine
    VALUES(53,176);    
INSERT INTO contine
    VALUES(53,177);    
INSERT INTO contine
    VALUES(53,178);    
INSERT INTO contine
    VALUES(54,179);    
INSERT INTO contine
    VALUES(54,171);
INSERT INTO contine
    VALUES(54,173);    
INSERT INTO contine
    VALUES(55,179);    
INSERT INTO contine
    VALUES(55,180);    
INSERT INTO contine
    VALUES(55,171);   
INSERT INTO contine
    VALUES(55,173);    
INSERT INTO contine
    VALUES(56,181);    
INSERT INTO contine
    VALUES(56,182);   
INSERT INTO contine
    VALUES(57,179);    
INSERT INTO contine
    VALUES(57,183);    
INSERT INTO contine
    VALUES(58,184);
INSERT INTO contine
    VALUES(59,185);    
INSERT INTO contine
    VALUES(60,186);    
 
SELECT * FROM contine; 

--crearea tabelului angajati
CREATE TABLE angajati
    (id_angajat number(5),
    nume varchar(25) constraint nume_ang_not_null not null,
    prenume varchar(25),
    email varchar(50),
    nr_telefon char(10) constraint nr_ang_not_null not null,
    data_angajare date default sysdate,
    tip_angajat varchar2(10) constraint tip_not_null not null,
    specializare varchar2(50),
    experienta number(2),
    CONSTRAINT angajati_pk PRIMARY KEY (id_angajat),
    unique(email),
    unique(nr_telefon)
    );

--inserarea datelor in tabelul angajati
INSERT INTO angajati
    VALUES(200,	'Avram', 'Alina', 'alina@angajat.ro', '0765242562',	to_date('03-03-2018','dd-mm-yyyy'), 'bucatar', 'Franta', null);
INSERT INTO angajati
    VALUES(201,	'Dumitrache', 'Bianca-Maria', 'bianca@angajat.ro', '0775252425', to_date('15-10-2019','dd-mm-yyyy'), 'ospatar', null,	2);
INSERT INTO angajati
    VALUES(202,	'Vilcu', 'Elena', 'ella@angajat.ro', '0738726252',	to_date('19-07-2019','dd-mm-yyyy'), 'bucatar', 'Romania',	null);
INSERT INTO angajati
    VALUES(203,	'Nistor', 'Izabela', 'iza@angajat.ro', '0758625279', to_date('07-02-2021','dd-mm-yyyy'), 'ospatar', null,	3);
INSERT INTO angajati
    VALUES(204,	'Dinu',	'Marian', 'marian@angajat.ro', '0787534299', to_date('21-05-2015','dd-mm-yyyy'), 'bucatar', 'Spania',	null);
INSERT INTO angajati
    VALUES(205,	'Ionsecu', 'Ion', 'ion@angajat.ro',	'0749293633', to_date('18-04-2020','dd-mm-yyyy'),	'ospatar', null, null);
INSERT INTO angajati
    VALUES(206,	'Brezan', 'Sabin-Alexandru', 'sabin@angajat.ro', '0758622885', to_date('11-09-2020','dd-mm-yyyy'), 'bucatar', 'Franta', null);    
INSERT INTO angajati
    VALUES(207,	'Albu',	'Georgiana', 'geo@angajat.ro',	'0769628434', to_date('13-01-2021','dd-mm-yyyy'),	'ospatar',	null, 6);    

SELECT * FROM angajati;

--crearea tabelului gateste_serveste
CREATE TABLE gateste_serveste
    (id_angajat number(5) constraint ang_g_not_null not null,
    id_comanda number(5) constraint comanda_g_not_null not null,
    id_produs number(5) constraint produs_g_not_null not null,
    cantitate number(2) constraint c_cantitate not null,
    CONSTRAINT gateste_angajat_fk foreign key(id_angajat) references angajati(id_angajat),
    CONSTRAINT gateste_produs_fk foreign key(id_produs) references produse(id_produs),
    CONSTRAINT gateste_comanda_fk foreign key(id_comanda) references comenzi(id_comanda),
    CONSTRAINT pk_gateste primary key(id_angajat, id_comanda,id_produs),
    check(cantitate>0)
    );

--inserararea datelor in tabelul gateste_serveste
INSERT INTO gateste_serveste
    VALUES(204,10,62,20);
INSERT INTO gateste_serveste
    VALUES(206,10,56,15);    
INSERT INTO gateste_serveste
    VALUES(207,10,59,20);    
INSERT INTO gateste_serveste
    VALUES(200,20,55,2);    
INSERT INTO gateste_serveste
    VALUES(202,30,57,4);    
INSERT INTO gateste_serveste
    VALUES(205,30,59,4);    
INSERT INTO gateste_serveste
    VALUES(204,40,61,10);    
INSERT INTO gateste_serveste
    VALUES(203,40,60,8);    
INSERT INTO gateste_serveste
    VALUES(200,50,51,3);    
INSERT INTO gateste_serveste
    VALUES(206,60,53,6);    
INSERT INTO gateste_serveste
    VALUES(204,70,55,16);
INSERT INTO gateste_serveste
    VALUES(207,70,59,16);
INSERT INTO gateste_serveste
    VALUES(206,80,62,22);    
INSERT INTO gateste_serveste
    VALUES(201,80,60,22);    
INSERT INTO gateste_serveste
    VALUES(202,90,50,5);    
INSERT INTO gateste_serveste
    VALUES(201,90,58,7);    
INSERT INTO gateste_serveste
    VALUES(207,10,62,20);    
INSERT INTO gateste_serveste
    VALUES(207,10,56,15);    
INSERT INTO gateste_serveste
    VALUES(201,20,55,2);    
INSERT INTO gateste_serveste
    VALUES(205,30,57,4);    
INSERT INTO gateste_serveste
    VALUES(203,40,61,10);    
INSERT INTO gateste_serveste
    VALUES(201,50,51,3);
INSERT INTO gateste_serveste
    VALUES(205,60,53,6);
INSERT INTO gateste_serveste
    VALUES(207,70,55,16);    
INSERT INTO gateste_serveste
    VALUES(203,80,62,22);    
INSERT INTO gateste_serveste
    VALUES(205,90,50,5);         
INSERT INTO gateste_serveste
    VALUES(203,10,58,3);
    
SELECT * FROM gateste_serveste;
COMMIT;