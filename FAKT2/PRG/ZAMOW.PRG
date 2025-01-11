// PROCEDURE zamow
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wprowadzanie danych o sprzedazy')

USE zamow NEW
GO BOTTOM

IF RECNO() > 0
   m->zamowienie := zamowienie
ELSE
   m->zamowienie := SPACE(11)
ENDIF

m->Kli_Numer  := 0

SET KEY -1 TO fakts2

********************** NAGLOWEK *********************************

@  8,20 SAY "Numer Zamowienia............." GET m->zamowienie VALID .NOT. EMPTY(m->zamowienie)

READ

IF LASTKEY() == 27
   CLOSE DATABASES
   RETURN
ENDIF



LOCATE FOR m->zamowienie == zamowienie

IF FOUND()
   m->Kli_Numer := Kli_Numer

//   ALERT('Klient Nr.:'+STR(m->Kli_Numer)+'  Record Nr.:'+STR(RECNO()) )

   @ 10,20 SAY "Istniejace zamowienie klienta"

   ISTKD(zamow->Kli_Numer,12,20)

   INKEY(0)

ELSE

   @ 10,20 SAY "Numer Klienta................" GET m->Kli_Numer PICTURE "99999" VALID ISTKD(m->Kli_Numer,10,56)
READ

ENDIF

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

USE Artykuly               NEW

SELECT zamow


rahmen(.T.,.F.,.F.,.F.,.T.,.T.,'Dane do zamowienia '+m->zamowienie)



SET INDEX TO
SET FILTER TO m->zamowienie == zamowienie
SETFUNCTION(10,CHR(23))

SET INDEX TO zam_poz, zam

abbruch := .F.
m->poz       := 1
m->zam_poz   := 1
m->KW        := 1
m->Art_Nr    := SPACE(10)



DO WHILE .NOT. abbruch
   m->ilosc   := 0
   m->zam_poz := zam_poz+1
   korekta    := .F.
   GO TOP
   m->poz     := poz

   IF LASTKEY() <> 27
      podglad2(0)
   ENDIF

   @ 5,2  SAY 'poz. Artyk.Nr. Tydz. ilosc ' COLOR farb4
   @ 6,2  GET m->zam_poz PICTURE '999'
   READ

   IF LASTKEY() == 27 .OR. LASTKEY() == 23
      EXIT
      CLOSE DATABASES
      RETURN
   ENDIF

   LOCATE FOR (m->zamowienie==zamowienie .AND. m->zam_poz == zam_poz)

   IF FOUND()

      wynik:= ALERT('Zapis w poz. istnieje',{'korekta','cofnij','zakoncz','usun'})

      korekta := .F.

      DO CASE


      CASE wynik == 1

         m->KW         := KW
         m->Art_Nr     := Art_Nr
         m->ilosc      := Ilosc
//         m->Kli_Numer  := Kli_Numer
         NumerPoz      := RECNO()
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
         SET INDEX TO zam_poz
         REINDEX
         SET INDEX TO
         LOOP

      OTHERWISE
         CLOSE DATABASES
         RETURN

      ENDCASE

   ENDIF


   @ 6,06 GET m->Art_Nr VALID IST(m->Art_Nr,6,31)
   @ 6,17 GET m->KW PICTURE '99'
   @ 6,20 GET m->ilosc   PICTURE '99999.999'
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


   SELECT Artykuly
   LOCATE FOR m->Art_Nr == numer
   IF .NOT. FOUND()
      ALERT('Artykul nie zostal odnaleziony')
      CLOSE DATABASES
      RETURN
   ENDIF

   SELECT Zamow

   SET INDEX TO zam_poz,zam

   IF .NOT. korekta
      APPEND BLANK
   ELSE
       GO NumerPoz
   ENDIF


   REPLACE art_nr     WITH m->art_nr
   REPLACE ilosc      WITH m->ilosc
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
   REPLACE Cena_Klien WITH Artykuly->Cena_Klien
   REPLACE Wartosc    WITH Artykuly->Cena_Klien * m->Faktor * m->ilosc
   REPLACE KLI_Numer  WITH m->Kli_Numer
   m->zam_poz := m->zam_poz+1

ENDDO

SET FILTER TO
SETFUNCTION(3,'')
SET KEY -7 TO
SETFUNCTION(10,'')
CLOSE DATABASES
RETURN


FUNCTION podglad2 (Cofniecie)


SET FILTER TO zamowienie = m->zamowienie
SET INDEX TO zam_poz
GO BOTTOM
SKIP Cofniecie

m->poz    := poz+1
wiersz    := 8
C_Waga    := 0
C_Objetosc:= 0


@ 8,2 CLEAR TO 22,78

DO WHILE wiersz < 23 .AND. .NOT. BOF()
   @ wiersz,01 SAY zam_poz
   @ wiersz,17 SAY STR(KW,2,0)
   @ wiersz,06 SAY Art_Nr
   @ wiersz,19 SAY STR(Ilosc,10,3)
   @ wiersz,31 SAY LEFT(IMG(Art_Nr),48) COLOR farb4    //LEFT(Artykuly->Nazwa1,48)
   SKIP-1
   wiersz++
ENDDO
SET FILTER TO
SET INDEX TO

RETURN NIL

FUNCTION IMG(art)
AltSelect := SELECT()
SELECT Artykuly
LOCATE FOR art == numer
m->Nazwa1 := Nazwa1
SELECT(AltSelect)
RETURN m->Nazwa1



FUNCTION IST(art,y,x)
AltSelect:= SELECT()
SELECT Artykuly
LOCATE FOR art == numer
IF FOUND()
   m->Nazwa1 := Nazwa1
   wynik := .T.
ELSE
   m->Nazwa1 := 'Artykul nie zostal odnaleziony'
   wynik := .F.
ENDIF
@ y,x SAY LEFT(Nazwa1,48)
SELECT(AltSelect)

RETURN wynik

FUNCTION ISTKD(KD,y,x)
PRIVATE Nazwa
AltSelect:= SELECT()

USE KLIENCI NEW
LOCATE FOR KD == Kli_numer
IF FOUND()
   Nazwa := LEFT(ALLTRIM(Kli_Nazwa1)+' '+ALLTRIM(Kli_Nazwa2),12)
   wynik := .T.
ELSE
   Nazwa := 'Klient nie odnaleziony'
   wynik := .F.
ENDIF

@ y,x SAY Nazwa

CLOSE KLIENCI

SELECT(AltSelect)
RETURN wynik