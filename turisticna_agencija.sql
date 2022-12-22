/*==============================================================*/
/* DBMS name:      ORACLE Version 10gR2                         */
/* Created on:     21. 12. 2022 12:07:45                        */
/*==============================================================*/


alter table Aktivnost
   drop constraint FK_AKTIVNOS_SE_ODVIJA_NASLOV;

alter table Hotel
   drop constraint FK_HOTEL_SE_NAHAJA_NASLOV;

alter table Naslov
   drop constraint FK_NASLOV_IMA_2_POSTA;

alter table Nudi
   drop constraint FK_NUDI_NUDI_HOTEL;

alter table Nudi
   drop constraint FK_NUDI_NUDI2_HOTELSKA;

alter table Ocena
   drop constraint FK_OCENA_DA_STRANKA;

alter table Ocena
   drop constraint FK_OCENA_PRIPADA_HOTEL;

alter table Oseba
   drop constraint FK_OSEBA_ZIVI_NASLOV;

alter table Pocitnice
   drop constraint FK_POCITNIC_GOSTI_HOTEL;

alter table Pocitnice
   drop constraint FK_POCITNIC_POTEKAJO_DRZAVA;

alter table Posta
   drop constraint FK_POSTA_IMA_1_DRZAVA;

alter table Pripada_1
   drop constraint FK_PRIPADA__PRIPADA_1_REZERVAC;

alter table Pripada_1
   drop constraint FK_PRIPADA__PRIPADA_2_STRANKA;

alter table Program
   drop constraint FK_PROGRAM_IMA_POCITNIC;

alter table Program
   drop constraint FK_PROGRAM_IMA_3_AKTIVNOS;

alter table Rezervacija
   drop constraint FK_REZERVAC_ODOBRI_ZAPOSLEN;

alter table Rezervacija
   drop constraint FK_REZERVAC_SE_NANASA_POCITNIC;

alter table Stranka
   drop constraint FK_STRANKA_DEDOVANJE_OSEBA;

alter table Vsebuje
   drop constraint FK_VSEBUJE_VSEBUJE_HOTELSKA;

alter table Vsebuje
   drop constraint FK_VSEBUJE_VSEBUJE2_REZERVAC;

alter table Zaposleni
   drop constraint FK_ZAPOSLEN_DEDOVANJE_OSEBA;

alter table Zaposleni
   drop constraint FK_ZAPOSLEN_DELA_DELOVNOM;

drop index Se_odvija_FK;

drop table Aktivnost cascade constraints;

drop table DelovnoMesto cascade constraints;

drop table Drzava cascade constraints;

drop index Se_nahaja_FK;

drop table Hotel cascade constraints;

drop table HotelskaStoritev cascade constraints;

drop index Ima_2_FK;

drop table Naslov cascade constraints;

drop index Nudi2_FK;

drop index Nudi_FK;

drop table Nudi cascade constraints;

drop index Pripada_FK;

drop index Da_FK;

drop table Ocena cascade constraints;

drop index Zivi_FK;

drop table Oseba cascade constraints;

drop index Gosti_FK;

drop index Potekajo_FK;

drop table Pocitnice cascade constraints;

drop index Ima_1_FK;

drop table Posta cascade constraints;

drop index Pripada_2_FK;

drop index Pripada_1_FK;

drop table Pripada_1 cascade constraints;

drop index Ima_3_FK;

drop index Ima_FK;

drop table Program cascade constraints;

drop index Odobri_FK;

drop index Se_nanasa_FK;

drop table Rezervacija cascade constraints;

drop table Stranka cascade constraints;

drop index Vsebuje2_FK;

drop index Vsebuje_FK;

drop table Vsebuje cascade constraints;

drop index Dela_FK;

drop table Zaposleni cascade constraints;

/*==============================================================*/
/* Table: Aktivnost                                             */
/*==============================================================*/
create table Aktivnost  (
   IdAktivnost          INTEGER                         not null,
   Kratica              VARCHAR2(3)                     not null,
   PostnaStevilka       NUMBER(5)                       not null,
   Ulica                VARCHAR2(30)                    not null,
   HisnaStevilka        VARCHAR2(5)                     not null,
   Naziv                VARCHAR2(1024)                  not null,
   Opis                 VARCHAR2(1024),
   constraint PK_AKTIVNOST primary key (IdAktivnost)
);

/*==============================================================*/
/* Index: Se_odvija_FK                                          */
/*==============================================================*/
create index Se_odvija_FK on Aktivnost (
   Kratica ASC,
   PostnaStevilka ASC,
   Ulica ASC,
   HisnaStevilka ASC
);

/*==============================================================*/
/* Table: DelovnoMesto                                          */
/*==============================================================*/
create table DelovnoMesto  (
   IdDelovnoMesto       INTEGER                         not null,
   Naziv                VARCHAR2(1024)                  not null,
   constraint PK_DELOVNOMESTO primary key (IdDelovnoMesto)
);

/*==============================================================*/
/* Table: Drzava                                                */
/*==============================================================*/
create table Drzava  (
   Kratica              VARCHAR2(3)                     not null,
   Naziv                VARCHAR2(1024)                  not null,
   constraint PK_DRZAVA primary key (Kratica)
);

/*==============================================================*/
/* Table: Hotel                                                 */
/*==============================================================*/
create table Hotel  (
   IdHotel              INTEGER                         not null,
   Kratica              VARCHAR2(3)                     not null,
   PostnaStevilka       NUMBER(5)                       not null,
   Ulica                VARCHAR2(30)                    not null,
   HisnaStevilka        VARCHAR2(5)                     not null,
   Ime                  VARCHAR2(1024)                  not null,
   OcenaHotela          NUMBER(2),
   constraint PK_HOTEL primary key (IdHotel)
);

comment on table Hotel is
'Za vsak hotel je znano ime hotela, število zvezdic, ki jih hotel ima in  naslov na katerem se nahaja';

/*==============================================================*/
/* Index: Se_nahaja_FK                                          */
/*==============================================================*/
create index Se_nahaja_FK on Hotel (
   Kratica ASC,
   PostnaStevilka ASC,
   Ulica ASC,
   HisnaStevilka ASC
);

/*==============================================================*/
/* Table: HotelskaStoritev                                      */
/*==============================================================*/
create table HotelskaStoritev  (
   IdStoritve           INTEGER                         not null,
   NazivStoritve        VARCHAR2(1024)                  not null,
   Opis                 VARCHAR2(1024)                  not null,
   constraint PK_HOTELSKASTORITEV primary key (IdStoritve)
);

/*==============================================================*/
/* Table: Naslov                                                */
/*==============================================================*/
create table Naslov  (
   Kratica              VARCHAR2(3)                     not null,
   PostnaStevilka       NUMBER(5)                       not null,
   Ulica                VARCHAR2(30)                    not null,
   HisnaStevilka        VARCHAR2(5)                     not null,
   constraint PK_NASLOV primary key (Kratica, PostnaStevilka, Ulica, HisnaStevilka)
);

comment on table Naslov is
'Naslov je sestavljen iz ulice, kraja in države. Na enem naslovu se lahko nahaja največ en hotel';

/*==============================================================*/
/* Index: Ima_2_FK                                              */
/*==============================================================*/
create index Ima_2_FK on Naslov (
   Kratica ASC,
   PostnaStevilka ASC
);

/*==============================================================*/
/* Table: Nudi                                                  */
/*==============================================================*/
create table Nudi  (
   IdHotel              INTEGER                         not null,
   IdStoritve           INTEGER                         not null,
   constraint PK_NUDI primary key (IdHotel, IdStoritve)
);

/*==============================================================*/
/* Index: Nudi_FK                                               */
/*==============================================================*/
create index Nudi_FK on Nudi (
   IdHotel ASC
);

/*==============================================================*/
/* Index: Nudi2_FK                                              */
/*==============================================================*/
create index Nudi2_FK on Nudi (
   IdStoritve ASC
);

/*==============================================================*/
/* Table: Ocena                                                 */
/*==============================================================*/
create table Ocena  (
   IdOseba              INTEGER                         not null,
   IdHotel              INTEGER                         not null,
   Datum                DATE                            not null,
   Tocke                NUMBER(2)                       not null,
   Komentar             VARCHAR2(1024),
   constraint PK_OCENA primary key (IdOseba, IdHotel, Datum)
);

/*==============================================================*/
/* Index: Da_FK                                                 */
/*==============================================================*/
create index Da_FK on Ocena (
   IdOseba ASC
);

/*==============================================================*/
/* Index: Pripada_FK                                            */
/*==============================================================*/
create index Pripada_FK on Ocena (
   IdHotel ASC
);

/*==============================================================*/
/* Table: Oseba                                                 */
/*==============================================================*/
create table Oseba  (
   IdOseba              INTEGER                         not null,
   Kratica              VARCHAR2(3)                     not null,
   PostnaStevilka       NUMBER(5)                       not null,
   Ulica                VARCHAR2(30)                    not null,
   HisnaStevilka        VARCHAR2(5)                     not null,
   Ime                  VARCHAR2(1024)                  not null,
   Priimek              VARCHAR2(1024)                  not null,
   DatumRojstva         DATE                            not null,
   constraint PK_OSEBA primary key (IdOseba)
);

/*==============================================================*/
/* Index: Zivi_FK                                               */
/*==============================================================*/
create index Zivi_FK on Oseba (
   Kratica ASC,
   PostnaStevilka ASC,
   Ulica ASC,
   HisnaStevilka ASC
);

/*==============================================================*/
/* Table: Pocitnice                                             */
/*==============================================================*/
create table Pocitnice  (
   IdPočitnice          INTEGER                         not null,
   IdHotel              INTEGER                         not null,
   Kratica              VARCHAR2(3)                     not null,
   Ime                  VARCHAR2(1024)                  not null,
   Odhod                DATE                            not null,
   Prihod               DATE                            not null,
   SteviloProstihMest   INTEGER                         not null,
   constraint PK_POCITNICE primary key (IdPočitnice)
);

comment on table Pocitnice is
'Za vsake počitnice hranimo sledeče podatke: ime, odhod, prihod, vključene programe potovanja (ogled krajev, hoteli… )';

/*==============================================================*/
/* Index: Potekajo_FK                                           */
/*==============================================================*/
create index Potekajo_FK on Pocitnice (
   Kratica ASC
);

/*==============================================================*/
/* Index: Gosti_FK                                              */
/*==============================================================*/
create index Gosti_FK on Pocitnice (
   IdHotel ASC
);

/*==============================================================*/
/* Table: Posta                                                 */
/*==============================================================*/
create table Posta  (
   Kratica              VARCHAR2(3)                     not null,
   PostnaStevilka       NUMBER(5)                       not null,
   Kraj                 VARCHAR2(1024)                  not null,
   constraint PK_POSTA primary key (Kratica, PostnaStevilka)
);

/*==============================================================*/
/* Index: Ima_1_FK                                              */
/*==============================================================*/
create index Ima_1_FK on Posta (
   Kratica ASC
);

/*==============================================================*/
/* Table: Pripada_1                                             */
/*==============================================================*/
create table Pripada_1  (
   IdRezervacija        INTEGER                         not null,
   IdOseba              INTEGER                         not null,
   constraint PK_PRIPADA_1 primary key (IdRezervacija, IdOseba)
);

/*==============================================================*/
/* Index: Pripada_1_FK                                          */
/*==============================================================*/
create index Pripada_1_FK on Pripada_1 (
   IdRezervacija ASC
);

/*==============================================================*/
/* Index: Pripada_2_FK                                          */
/*==============================================================*/
create index Pripada_2_FK on Pripada_1 (
   IdOseba ASC
);

/*==============================================================*/
/* Table: Program                                               */
/*==============================================================*/
create table Program  (
   IdPočitnice          INTEGER                         not null,
   IdAktivnost          INTEGER                         not null,
   DatumIzvedbe         DATE                            not null,
   Opis                 VARCHAR2(1024),
   constraint PK_PROGRAM primary key (IdPočitnice, IdAktivnost, DatumIzvedbe)
);

/*==============================================================*/
/* Index: Ima_FK                                                */
/*==============================================================*/
create index Ima_FK on Program (
   IdPočitnice ASC
);

/*==============================================================*/
/* Index: Ima_3_FK                                              */
/*==============================================================*/
create index Ima_3_FK on Program (
   IdAktivnost ASC
);

/*==============================================================*/
/* Table: Rezervacija                                           */
/*==============================================================*/
create table Rezervacija  (
   IdRezervacija        INTEGER                         not null,
   IdPočitnice          INTEGER                         not null,
   IdOseba              INTEGER                         not null,
   ZnesekPlacila        NUMBER                          not null,
   constraint PK_REZERVACIJA primary key (IdRezervacija)
);

/*==============================================================*/
/* Index: Se_nanasa_FK                                          */
/*==============================================================*/
create index Se_nanasa_FK on Rezervacija (
   IdPočitnice ASC
);

/*==============================================================*/
/* Index: Odobri_FK                                             */
/*==============================================================*/
create index Odobri_FK on Rezervacija (
   IdOseba ASC
);

/*==============================================================*/
/* Table: Stranka                                               */
/*==============================================================*/
create table Stranka  (
   IdOseba              INTEGER                         not null,
   EMSO                 VARCHAR2(13)                    not null,
   StOsebneIzkaznice    VARCHAR2(11)                    not null,
   constraint PK_STRANKA primary key (IdOseba)
);

comment on table Stranka is
'O stranki hranimo naslednje podatke: ime, priimek, naslov, datum rojstva, EMŠO in številko osebne izkaznice';

/*==============================================================*/
/* Table: Vsebuje                                               */
/*==============================================================*/
create table Vsebuje  (
   IdStoritve           INTEGER                         not null,
   IdRezervacija        INTEGER                         not null,
   constraint PK_VSEBUJE primary key (IdStoritve, IdRezervacija)
);

/*==============================================================*/
/* Index: Vsebuje_FK                                            */
/*==============================================================*/
create index Vsebuje_FK on Vsebuje (
   IdStoritve ASC
);

/*==============================================================*/
/* Index: Vsebuje2_FK                                           */
/*==============================================================*/
create index Vsebuje2_FK on Vsebuje (
   IdRezervacija ASC
);

/*==============================================================*/
/* Table: Zaposleni                                             */
/*==============================================================*/
create table Zaposleni  (
   IdOseba              INTEGER                         not null,
   IdDelovnoMesto       INTEGER                         not null,
   DatumZaposlitve      DATE                            not null,
   constraint PK_ZAPOSLENI primary key (IdOseba)
);

/*==============================================================*/
/* Index: Dela_FK                                               */
/*==============================================================*/
create index Dela_FK on Zaposleni (
   IdDelovnoMesto ASC
);

alter table Aktivnost
   add constraint FK_AKTIVNOS_SE_ODVIJA_NASLOV foreign key (Kratica, PostnaStevilka, Ulica, HisnaStevilka)
      references Naslov (Kratica, PostnaStevilka, Ulica, HisnaStevilka);

alter table Hotel
   add constraint FK_HOTEL_SE_NAHAJA_NASLOV foreign key (Kratica, PostnaStevilka, Ulica, HisnaStevilka)
      references Naslov (Kratica, PostnaStevilka, Ulica, HisnaStevilka);

alter table Naslov
   add constraint FK_NASLOV_IMA_2_POSTA foreign key (Kratica, PostnaStevilka)
      references Posta (Kratica, PostnaStevilka);

alter table Nudi
   add constraint FK_NUDI_NUDI_HOTEL foreign key (IdHotel)
      references Hotel (IdHotel);

alter table Nudi
   add constraint FK_NUDI_NUDI2_HOTELSKA foreign key (IdStoritve)
      references HotelskaStoritev (IdStoritve);

alter table Ocena
   add constraint FK_OCENA_DA_STRANKA foreign key (IdOseba)
      references Stranka (IdOseba);

alter table Ocena
   add constraint FK_OCENA_PRIPADA_HOTEL foreign key (IdHotel)
      references Hotel (IdHotel);

alter table Oseba
   add constraint FK_OSEBA_ZIVI_NASLOV foreign key (Kratica, PostnaStevilka, Ulica, HisnaStevilka)
      references Naslov (Kratica, PostnaStevilka, Ulica, HisnaStevilka);

alter table Pocitnice
   add constraint FK_POCITNIC_GOSTI_HOTEL foreign key (IdHotel)
      references Hotel (IdHotel);

alter table Pocitnice
   add constraint FK_POCITNIC_POTEKAJO_DRZAVA foreign key (Kratica)
      references Drzava (Kratica);

alter table Posta
   add constraint FK_POSTA_IMA_1_DRZAVA foreign key (Kratica)
      references Drzava (Kratica);

alter table Pripada_1
   add constraint FK_PRIPADA__PRIPADA_1_REZERVAC foreign key (IdRezervacija)
      references Rezervacija (IdRezervacija);

alter table Pripada_1
   add constraint FK_PRIPADA__PRIPADA_2_STRANKA foreign key (IdOseba)
      references Stranka (IdOseba);

alter table Program
   add constraint FK_PROGRAM_IMA_POCITNIC foreign key (IdPočitnice)
      references Pocitnice (IdPočitnice);

alter table Program
   add constraint FK_PROGRAM_IMA_3_AKTIVNOS foreign key (IdAktivnost)
      references Aktivnost (IdAktivnost);

alter table Rezervacija
   add constraint FK_REZERVAC_ODOBRI_ZAPOSLEN foreign key (IdOseba)
      references Zaposleni (IdOseba);

alter table Rezervacija
   add constraint FK_REZERVAC_SE_NANASA_POCITNIC foreign key (IdPočitnice)
      references Pocitnice (IdPočitnice);

alter table Stranka
   add constraint FK_STRANKA_DEDOVANJE_OSEBA foreign key (IdOseba)
      references Oseba (IdOseba);

alter table Vsebuje
   add constraint FK_VSEBUJE_VSEBUJE_HOTELSKA foreign key (IdStoritve)
      references HotelskaStoritev (IdStoritve);

alter table Vsebuje
   add constraint FK_VSEBUJE_VSEBUJE2_REZERVAC foreign key (IdRezervacija)
      references Rezervacija (IdRezervacija);

alter table Zaposleni
   add constraint FK_ZAPOSLEN_DEDOVANJE_OSEBA foreign key (IdOseba)
      references Oseba (IdOseba);

alter table Zaposleni
   add constraint FK_ZAPOSLEN_DELA_DELOVNOM foreign key (IdDelovnoMesto)
      references DelovnoMesto (IdDelovnoMesto);

