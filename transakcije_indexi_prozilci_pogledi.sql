/*==============================================================*/
/* TRANSAKCIJE                                                  */
/*==============================================================*/

--TRANSAKCIJA 1
--Za vsako rezervacijo izpišite podatke o imenu potovanja, 
--na katerega se nanaša in podatke o potnikih 
--(ime, priimek, naslov, datum rojstva, EMŠO in številko osebne izkaznice), 
--znesku plaèila in zaposlenem (ime, priimek in delovno mesto), 
--ki je rezervacijo odobril. 
--Rezervacije naj bodo urejene po znesku plaèila padajoèe in id rezervacije narascajoce.
SELECT r.idRezervacija, p.ime AS "Ime poèitnic", 
(
    SELECT o1.ime
    FROM oseba o1
        INNER JOIN zaposleni z
            ON o1.idOseba = z.idOseba
    WHERE z.idOseba = r.idOseba       
) AS "Ime zaposlenega",
(
    SELECT o1.priimek
    FROM oseba o1
        INNER JOIN zaposleni z
            ON o1.idOseba = z.idOseba
    WHERE z.idOseba = r.idOseba       
) AS "Priimek zaposlenega",
(
    SELECT dm.naziv
    FROM delovnomesto dm
        INNER JOIN zaposleni z
            ON dm.iddelovnomesto = z.iddelovnomesto
    WHERE z.idOseba = r.idOseba
) AS "Delovno mesto zaposlenega",
o.ime, o.priimek, o.kratica, o.postnaStevilka, po.kraj , o.ulica, o.hisnaStevilka, s.emso, s.stosebneizkaznice, r.znesekPLacila
FROM oseba o
    INNER JOIN naslov n
        ON o.kratica = n.kratica AND o.postnaStevilka = n.postnaStevilka
           AND o.ulica = n.ulica AND o.hisnaStevilka = n.hisnaStevilka
    INNER JOIN posta po 
        ON n.kratica = po.kratica AND n.postnaStevilka = po.postnaStevilka
    INNER JOIN stranka s
        ON s.idOseba = o.idOseba
    INNER JOIN pripada_1 p1
        ON p1.idOseba = s.idOseba
    INNER JOIN rezervacija r
        ON p1.idRezervacija = r.idRezervacija
    INNER JOIN pocitnice p
        ON p.idPocitnice = r.idPOcitnice
ORDER BY  r.znesekPLacila DESC, r.idRezervacija ASC;


--TRANSAKCIJA 2
--Izpišite ime potovanja, odhod, prihod, trajanje, število vseh mest 
--in število prostih mest, ki so še na voljo za vsa potovanja,
--ki so v ponudbi (to so tista potovanja, 
--katerih datum odhoda je veèji od trenutnega datuma - 1 teden).
SELECT p.ime AS "Ime poèintnic", p.odhod, p.prihod, (p.prihod - p.odhod) AS "Trajanje", p.steviloProstihMest AS "Število vseh mest",  p.steviloProstihMest - (
    SELECT COUNT(pripada_1.idOseba) AS "Zasedena mesta"
    FROM pripada_1
        INNER JOIN rezervacija
            ON rezervacija.idRezervacija = pripada_1.idRezervacija
        INNER JOIN pocitnice 
            ON rezervacija.idPocitnice = pocitnice.idPocitnice
    WHERE p.idPocitnice = pocitnice.idPocitnice
) AS "Število prostih mest"
FROM pocitnice p
WHERE p.odhod > (CURRENT_DATE + 7);

--TRANSAKCIJA 3
--Izpišite imena, naslove in povpreèno oceno desetih najbolje ocenjenih hotelov.
SELECT * 
FROM (
    SELECT d.naziv AS "Država", h.ime AS "Ime hotela", h.ocenaHotela AS "Ocena hotela"
    FROM hotel h
        INNER JOIN naslov n
            ON h.kratica = n.kratica AND h.postnaStevilka = n.postnaStevilka
               AND h.ulica = n.ulica AND h.hisnaStevilka = n.hisnaStevilka
        INNER JOIN posta p
            ON n.kratica = p.kratica AND n.postnaStevilka = p.postnaStevilka
        INNER JOIN drzava d
            ON p.kratica = d.kratica
    ORDER BY h.ocenaHotela DESC
    )
WHERE ROWNUM <= 10;

--TRANSAKCIJA 4
--Za vsako potovanje v ponudbi (to so tista potovanja, katerih datum odhoda je veèji od trenutnega datuma - 1 teden)
--izpišite ime potovanja in podatke o programu/aktivnostih, ki se bodo izvajale tekom potovanja. Za vsako aktivnost vemo naziv, opis, kraj 
--in datum izvedbe.
SELECT p.ime AS "Ime poèintnic", p.odhod, p.prihod, pr.datumIzvedbe AS "Datum izvedbe aktivnosti", po.kraj "Kraj izvedbe aktivnosti", a.naziv "Aktovnost", a.opis
FROM pocitnice p
    INNER JOIN program pr
        ON pr.idPocitnice = p.idPocitnice
    INNER JOIN aktivnost a
        ON pr.idAktivnost = a.idAktivnost
    INNER JOIN naslov n
        ON a.kratica = n.kratica AND a.postnaStevilka = n.postnaStevilka
           AND a.ulica = n.ulica AND a.hisnaStevilka = n.hisnaStevilka
    INNER JOIN posta po 
        ON n.kratica = po.kratica AND n.postnaStevilka = po.postnaStevilka
WHERE p.odhod > (CURRENT_DATE + 7)
ORDER BY pr.datumIzvedbe ASC;

--TRANSAKCIJA 5
--Za vsako potovanje izpišite ime potovanja, datume (od kdaj, do kdaj), ime hotela v katerem bodo stranke prespale in njegovo oceno.
SELECT p.ime AS "Ime poèitnic", p.odhod, p.prihod, h.ime AS "Ime hotela", h.ocenaHotela AS "Ocena hotela"
FROM pocitnice p 
    INNER JOIN hotel h
     ON p.idHotel = h.idHotel
WHERE p.odhod > (CURRENT_DATE + 7)     
ORDER BY p.odhod ASC;

--TRANSAKCIJA 6
--Za vsakega zaposlenega izpišite njegovo ime, priimek, delovno mesto in podatke o njegovi uspešnosti. 
--Uspešnost merimo s številom rezervacij, ki jih je odobril, z zaslužkom ki ga je zaslužil s prodajo. 
SELECT o.ime, o.priimek, dm.naziv AS "Delovno mesto", 
(
    SELECT COUNT(r.idRezervacija)
    FROM rezervacija r
    WHERE r.idOseba = o.idOseba
) AS "Število odobrenih rezervacij",
(
    SELECT SUM(r.znesekPlacila)
    FROM rezervacija r
    WHERE r.idOseba = o.idOseba
) AS "Zaslužek od prodaje"
FROM oseba o
    INNER JOIN zaposleni z
        ON o.idOseba = z.idOseba
    INNER JOIN delovnomesto dm
        ON z.idDelovnoMesto = dm.idDelovnoMesto
ORDER BY "Zaslužek od prodaje" DESC, "Število odobrenih rezervacij" DESC;

--TRANSAKCIJA 7
--Izpišite ime, priimek, naslov, datum rojstva in število rezervacij za 10 strank z najveè rezervacijami, saj so le te vkljuèene v nagradno igro.
SELECT *
    FROM (
    SELECT o.ime, o.priimek, o.kratica, o.postnaStevilka, o.ulica, o.hisnaStevilka, o.datumRojstva,
    (
        SELECT COUNT(p1.idOseba)
        FROM pripada_1 p1
        WHERE p1.idOseba = o.idOseba
    ) as "Število rezervacij"
    FROM oseba o
        INNER JOIN stranka s 
            ON o.idOseba = s.idOseba
    ORDER BY "Število rezervacij" DESC
)
WHERE ROWNUM <= 10;

--TRANSAKCIJA 8
--Za vsak hotel izpišite njegovo ime, ime osebe, priimek osebe, oceno osebe in komentar osebe. Urejeno po toèkah padajoèe.
SELECT h.ime AS "Ime hotela", o.ime, o.priimek, oc.tocke, oc.komentar
FROM hotel h
    INNER JOIN ocena oc
        ON h.idHotel = oc.idHotel
    INNER JOIN stranka s
        ON oc.idOseba = s.idOseba
    INNER JOIN oseba o
        ON s.idOseba = o.idOseba
ORDER BY oc.tocke DESC;
        
--TRANSAKCIJA 9
--Za vsako stranko izpišite priimek, ime, naslov, datum rojstva, EMŠO in številko osebne izkaznice. Urejeno po priimku in imenu narašèajoce.
SELECT o.priimek, o.ime, o.kratica, o.postnaStevilka, po.kraj , o.ulica, o.hisnaStevilka, s.emso, s.stosebneizkaznice
FROM oseba o
    INNER JOIN naslov n
        ON o.kratica = n.kratica AND o.postnaStevilka = n.postnaStevilka
           AND o.ulica = n.ulica AND o.hisnaStevilka = n.hisnaStevilka
    INNER JOIN posta po 
        ON n.kratica = po.kratica AND n.postnaStevilka = po.postnaStevilka
    INNER JOIN stranka s
        ON s.idOseba = o.idOseba
ORDER BY o.priimek ASC, o.ime ASC;

--TRANSAKCIJA 10
--Za vsakega zaposlenega izpišite priimek, ime, naslov, datum rojstva, datum zaposlitve in delovno mesto. Urejeno po priimku in imenu narašèajoèe.
SELECT o.priimek, o.ime, o.kratica, o.postnaStevilka, po.kraj , o.ulica, o.hisnaStevilka, z.datumZaposlitve, dm.naziv
FROM oseba o
    INNER JOIN naslov n
        ON o.kratica = n.kratica AND o.postnaStevilka = n.postnaStevilka
           AND o.ulica = n.ulica AND o.hisnaStevilka = n.hisnaStevilka
    INNER JOIN posta po 
        ON n.kratica = po.kratica AND n.postnaStevilka = po.postnaStevilka
    INNER JOIN zaposleni z
        ON z.idOseba = o.idOseba
    INNER JOIN delovnomesto dm
        ON z.iddelovnomesto = dm.iddelovnomesto
ORDER BY o.priimek ASC, o.ime ASC;


/*==============================================================*/
/* SEKUNDARNI INDEXI                                            */
/*==============================================================*/

create index Odhod on Pocitnice (
   odhod DESC
);

create index Ocena on Hotel (
   OcenaHotela DESC
);

create index PriimekIme on Oseba (
    priimek ASC,
    ime ASC
);

create index ZnesekPlacilaIdRezervacija on Rezervacija(
    znesekPlacila DESC,
    idRezervacija ASC
);

create index Tocke on Ocena(
    tocke DESC
);


/*==============================================================*/
/* BAZNI PROŽILCI                                               */
/*==============================================================*/

/*
CREATE OR REPLACE TRIGGER PreveriDrzavPocitnic
BEFORE INSERT or UPDATE ON Pocitnice
FOR EACH ROW
DECLARE
    kratica_1 varchar2(3);
BEGIN
    SELECT kratica INTO kratica_1 FROM hotel WHERE idHotel = :new.IdHotel;
    IF kratica_1 = :new.kratica THEN
        INSERT INTO Pocitnice(IdPocitnice,IdHotel,Kratica,Ime,odhod,Prihod,SteviloProstihMest) 
        VALUES (:new.IdPocitnice, :new.IdHotel, :new.Kratica, :new.Ime, TO_DATE(:new.odhod, 'dd/mm/YYYY'),TO_DATE(:new.Prihod, 'dd/mm/YYYY'), :new.SteviloProstihMest);
    ELSE 
        RAISE_APPLICATION_ERROR(-20001, 'DRZAVA POCITNNIC MORA BITI ENAKA DRZAVI HOTELA V KATEREM SE POCITNICE ODVIJAJO');
    END IF;
END;
/   
*/


/* 
-- NE DELA
CREATE OR REPLACE TRIGGER PreveriHotelskeStoritve
BEFORE INSERT or UPDATE ON Vsebuje
FOR EACH ROW
DECLARE    
    storitev_obstaja int;
BEGIN

    SELECT count(nu.idStoritve) INTO storitev_obstaja
            FROM nudi nu
        WHERE nu.idHotel = 
        (
                SELECT p.idHotel
                FROM rezervacija r
                    INNER JOIN pocitnice p
                        ON  r.idPocitnice = p.idPocitnice
                WHERE r.idRezervacija = :new.IdRezervacija
        ) AND nu.idStoritve = :new.IdStoritve;
    
    dbms_output.put_line('' + storitev_obstaja);
    IF storitev_obstaja = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'IZBRANI HOTEL NE IZVAJA IZBRANE STORITVE');   
    ELSE
        INSERT INTO Vsebuje(IdStoritve,IdRezervacija)
        VALUES (:new.IdStoritve, :new.IdRezervacija);
    END IF;    
END;
/
*/ 

CREATE OR REPLACE TRIGGER PovprecnaOcenaHotela
AFTER INSERT or UPDATE or DELETE ON Ocena
FOR EACH ROW
DECLARE
    povprecnaOcena int;
BEGIN
    SELECT round((Hotel.OcenaHotela + :new.tocke) / 2, 0) INTO povprecnaOcena FROM Hotel WHERE Hotel.idhotel = :new.idHotel;
    UPDATE Hotel SET ocenahotela = povprecnaOcena WHERE idhotel = :new.idHotel;
END;
/

/*==============================================================*/
/* POGLEDI                                                      */
/*==============================================================*/

CREATE OR REPLACE VIEW AVG_ZASLUZEK_ZAPOSLENEGA_NA_REZERVACIJO AS
      SELECT o.ime, o.priimek, dm.naziv AS "Delovno mesto",
        round((
            SELECT SUM(r.znesekPlacila)
            FROM rezervacija r
            WHERE r.idOseba = o.idOseba
        ) /     
        (
            SELECT COUNT(r.idRezervacija)
            FROM rezervacija r
            WHERE r.idOseba = o.idOseba
        ), 2)  AS "Povpreèen zaslužek na rezervacijo"
        FROM oseba o
            INNER JOIN zaposleni z
                ON o.idOseba = z.idOseba
            INNER JOIN delovnomesto dm
                ON z.idDelovnoMesto = dm.idDelovnoMesto
        ORDER BY "Povpreèen zaslužek na rezervacijo" DESC;
 
 

