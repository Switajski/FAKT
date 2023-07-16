PROCEDURE rachunek
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wprowadzanie danych o sprzedazy')

USE zamow   NEW
USE Faktury NEW
GO BOTTOM
m->fakt_num  := faktury->fakt_num+1
m->fakt_dat  := DATE()
SET KEY -1 TO fakts2

********************** NAGLOWEK *********************************

@  8,20 SAY "Numer Wysylki................" GET m->fakt_num PICTURE '99999' VALID (m->fakt_num > 0)
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

USE Artykuly               NEW

SELECT Faktury
SET INDEX TO fa_numer

********************** DANE DLA NAGLOWKA PRZY NOWEJ WYSYLCE *********

IF .NOT. DBSEEK(m->fakt_num)
   m->fakt_dat   := DATE()

   @ 10,20 SAY "Nowa Wysylka Nr.............:"+STR(m->fakt_num,5,0)
   @ 12,20 SAY "Data przewidywanej wysylki..." GET m->fakt_dat
   READ

   IF LASTKEY() == 27
      CLOSE DATABASES
      RETURN
   ENDIF

   nowafaktura := .T.

ELSE
   nowafaktura := .F.
ENDIF

rahmen(.T.,.F.,.F.,.F.,.T.,.T.,'Dane do wysylki EU '+ALLTRIM(STR(m->fakt_num,0)))
@ 3,2 SAY 'Data:'+DTOC(m->fakt_dat)

SET INDEX TO
SET FILTER TO m->fakt_num == fakt_num
m->poz := 1
m->zamowienie := SPACE(11)
m->zamowpoz := SPACE(11)+'/'+SPACE(3)
m->GLSNumer    := SPACE(11)
SETFUNCTION(10,CHR(23))

SELECT Faktury
abbruch := .F.
m->numer := SPACE(10)


DO WHILE .NOT. abbruch
   m->ilosc   := 0
   m->karton  := 0
   m->GLS     := GLSNumer
   m->zam_poz := 0
   korekta    := .F.
   GO TOP
   m->poz     := poz
   podglad(0)
   @ 5,2  SAY 'L.P. zamowienie/poz ilosc op. Art.Nr                              nr.wysylki' COLOR farb4
   @ 6,2  GET m->poz PICTURE '999'
   READ

   IF LASTKEY() == 27 .OR. LASTKEY() == 23
      CLOSE DATABASES
      RETURN
   ENDIF

   LOCATE FOR (m->fakt_num==fakt_num .AND. m->poz==poz)

   IF FOUND()

      wynik:= ALERT('Zapis w poz. istnieje',{'korekta','cofnij','zakoncz','usun'})

      korekta := .F.

      DO CASE


      CASE wynik == 1

         m->Art_nr     := Art_nr
         m->ilosc      := Ilosc
         m->karton     := karton
         m->GLSNumer   := GLSNumer
         m->zamowienie := zamowienie
         m->zam_poz    := zam_poz
         m->KW         := KW
         m->Kli_Numer  := Kli_Numer
         m->ZamowPoz   := zamowienie+'/'+STR(poz,3,0)
         m->GLSNumer   := GLSNumer
         korekta := .T.

      CASE wynik == 2

         LOOP
         korekta := .F.


      CASE wynik == 3

         CLOSE DATABASES
         RETURN

      CASE wynik == 4

         DELETE
         PACK
         SET INDEX TO fa_numer, fakt_poz, art_nr
         REINDEX
         SET INDEX TO
         LOOP

      OTHERWISE
         CLOSE DATABASES
         RETURN

      ENDCASE

   ENDIF

   @ 6,06 GET m->Zamowienie VALID spr_zam(m->Zamowienie)
   @ 6,18 GET m->zam_poz PICTURE '999'
   @ 6,22 GET m->ilosc PICTURE '999.9' VALID spr_ilosc(m->zamowienie,m->ZAM_POZ,m->ilosc)
   @ 6,28 GET m->karton PICTURE '999'
   @ 6,68 GET m->GLSNumer PICTURE 'XXXXXXXXXXX'
   READ

   lk := LASTKEY()

   DO CASE
      CASE lk == 23
         abbruch := .T.
         CLOSE DATABASES
         RETURN
      CASE lk == 27
         LOOP
   ENDCASE


   NumerPoz := RECNO()

   SELECT zamow

   LOCATE FOR m->zamowienie == zamowienie .AND. m->zam_poz == zam_poz

   IF FOUND()
      m->Art_Nr     := Art_Nr
      m->Kli_Numer  := Kli_Numer
      m->KW         := KW
      m->zam_poz    := zam_poz
   ELSE
      ALERT('Pozycja zamowienia nie zostala odnaleziona')
      LOOP
   ENDIF


   SELECT Artykuly

   LOCATE FOR ALLTRIM(m->Art_Nr) == ALLTRIM(numer)

   IF .NOT. FOUND()
      ALERT('Artykul nie zostal odnaleziony')
      CLOSE DATABASES
      RETURN
   ENDIF

   SELECT Faktury

   SET INDEX TO fa_numer, fakt_poz, art_num
   GO  NumerPoz
   IF .NOT. korekta
      APPEND BLANK
   ENDIF

   REPLACE fakt_num   WITH m->fakt_num
   REPLACE fakt_dat   WITH m->fakt_dat
   REPLACE Kli_Numer  WITH m->Kli_Numer
   REPLACE poz        WITH m->poz
   REPLACE art_nr     WITH m->Art_Nr
   REPLACE ilosc      WITH m->ilosc
   REPLACE karton     WITH m->karton
   REPLACE GLSNumer   WITH m->GLSNumer
   REPLACE zamowienie WITH m->zamowienie
   REPLACE zam_poz    WITH m->zam_poz
   REPLACE KW         WITH m->KW

   REPLACE Nazwa1     WITH Artykuly->Nazwa1
   REPLACE Nazwa2     WITH Artykuly->Nazwa2
   REPLACE Nazwa3     WITH Artykuly->Nazwa3
   REPLACE Bezeichn1  WITH Artykuly->Bezeichn1
   REPLACE Bezeichn2  WITH Artykuly->Bezeichn2
   REPLACE Bezeichn3  WITH Artykuly->Bezeichn3
   REPLACE Jednostka  WITH Artykuly->Jednostka
   REPLACE Einheit    WITH Artykuly->Einheit
// REPLACE Koszt_Prod WITH Artykuly->Koszt_Prod
   REPLACE Cena_Klien WITH Artykuly->Cena_Klien

   m->Cena_Sprze := Artykuly->Cena_Klien * m->Faktor
   REPLACE Cena_Sprze WITH m->Cena_Sprze

   REPLACE Nr_Celny   WITH Artykuly->Nr_Celny
//   REPLACE Waga       WITH Artykuly->WagaJed * m->Ilosc
   REPLACE Jedn_Celna WITH Artykuly->Jedn_Celna
//   REPLACE Objetosc   WITH Artykuly->Objetosc * m->Ilosc
   REPLACE Wartosc    WITH Artykuly->Cena_Klien * m->Faktor * m->ilosc
   SET INDEX TO

ENDDO

SET FILTER TO
SETFUNCTION(3,'')
SET KEY -7 TO
SETFUNCTION(10,'')
CLOSE DATABASES
RETURN


FUNCTION podglad (Cofniecie)

SET FILTER TO fakt_num = m->fakt_num
SET INDEX TO fakt_poz
GO BOTTOM
SKIP Cofniecie

m->poz    := poz+1
wiersz    := 8
//C_Waga    := 0
//C_Objetosc:= 0


@ 8,2 CLEAR TO 22,78

DO WHILE wiersz < 23 .AND. .NOT. BOF()

   @ wiersz,1  SAY STR(poz,3,0)
   @ wiersz,06 SAY zamowienie+'/'+STR(zam_poz,3,0)
   @ wiersz,22 SAY STR(ilosc,5,1)
   @ wiersz,27 SAY STR(karton,3,0)
   @ wiersz,32 SAY art_nr COLOR farb4
   @ wiersz,68 SAY GLSNumer
   @ wiersz,43 SAY LEFT(ALLTRIM(nazwa1)+' '+ALLTRIM(nazwa2)+' '+ALLTRIM(nazwa3),23)


//   @ wiersz,65 SAY STR(Waga,5,1)
//     C_Waga := Waga+C_Waga
//   @ 6,64 SAY STR(C_Waga,4,0) COLOR farb4
//   @ wiersz,72 SAY STR(Objetosc,5,3)
//     C_Objetosc := Objetosc + C_Objetosc
//   @ 6,69 SAY STR(C_Objetosc,6,1) COLOR farb4
   SKIP-1
   wiersz++
ENDDO
SET FILTER TO
SET INDEX TO

RETURN NIL

FUNCTION spr_ilosc(m_zamowienie,m_zam_poz,m_ilosc)
PRIVATE odpow

SELECT zamow
LOCATE FOR m_zamowienie == zamowienie .AND. m_zam_poz == zam_poz

IF m_ilosc > ilosc+wykonanie
  odpow := ALERT('Ilosc podana do wysylki jest wieksza niz otwarta = '+ALLTRIM(STR(ilosc-wykonanie,8,0)),{'akcaptacja','korekta'})
ELSE
  odpow := 1
ENDIF

@ 6,32 SAY ALLTRIM(Art_Nr)+' otwarte '+ALLTRIM(STR(ilosc-wykonanie,4,0))

SELECT faktury

IF odpow == 1
   RETURN .T.
ELSE
   RETURN .F.
ENDIF

RETURN NIL


FUNCTION spr_zam(m_zamowienie)
PRIVATE odpow

SELECT zamow

LOCATE FOR m_zamowienie == zamowienie

IF FOUND()
   odpow := .T.
ELSE
   ALERT('Nieznane Zamowienie')
   odpow := .F.
ENDIF

SELECT Faktury

RETURN odpow