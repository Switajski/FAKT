PROCEDURE Towary

//#include "def.ch"
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wprowadzanie zestawien materialowych')

SET KEY -1 TO fakts2
SETFUNCTION(9,CHR(27))

********************** NAGLOWEK *********************************
//m->Tow_ArtNr := SPACE(10)




//INDEX ON numer TO Ar_Numer

@  8,20 SAY "Numer Wyrobu................" GET m->Tow_ArtNr VALID .NOT. EMPTY(m->Tow_ArtNr)

READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

USE &Art Alias Artyk NEW

********************** DANE DLA NAGLOWKA PRZY NOWYM TOWARZE *********
LOCATE FOR m->Tow_ArtNr == Numer

IF .NOT. FOUND()
   ALERT('Wyrob '+m->Tow_ArtNr +' nie zostal odnaleziony, lub brak dostepu do pliku wyrobow')
   CLOSE DATABASES
   RETURN
ENDIF

CLOSE Artyk

rahmen(.T.,.F.,.F.,.F.,.T.,.T.,'norma materialowa dla wyrobu: '+ALLTRIM(m->Tow_ArtNr))

USE Towary NEW

SET FILTER TO m->Tow_ArtNr == Tow_ArtNr
SET INDEX TO Pozycja, Wyrob

m->pos      := 1
m->Mat_ArtNr:= SPACE(4)
m->Ilosc    := 0

SETFUNCTION(10,CHR(23))

abbruch := .F.
m->numer := SPACE(10)


DO WHILE .NOT. abbruch
//   SET INDEX TO Pozycja, Wyrob
   m->ilosc      := 0
   m->Mat_ArtNr  := SPACE(4)
   m->pos        := 1
   korekta       := .F.

   GO TOP

   m->pos     := pos
   podglad(0)

   @ 5,2  SAY 'poz. mat.   ilosc   nazwa materialu   ' COLOR farb4
   @ 7,2  SAY REPLICATE(CHR(196),76)
   @ 6,2  GET m->pos PICTURE '999'

   READ

   IF LASTKEY() == 27 .OR. LASTKEY() == 23
      CLOSE DATABASES
      RETURN
   ENDIF

   LOCATE FOR (m->Tow_ArtNr == Tow_ArtNr .AND. Pos == m->pos)

   IF FOUND()

      wynik:= ALERT('Zapis w poz. istnieje',{'korekta','cofnij','zakoncz','usun'})
      korekta := .F.

      DO CASE

         CASE wynik == 1
            m->Mat_ArtNr  := Mat_ArtNr
            m->ilosc      := Ilosc
            m->Pos        := Pos
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
            LOOP

         OTHERWISE
            CLOSE DATABASES
         RETURN

      ENDCASE

   ENDIF

   @ 6,07 GET m->Mat_ArtNr
   @ 6,12 GET m->ilosc PICTURE '99999.99' VALID(m->Ilosc > 0)
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


//   NumerPoz := RECNO()

//   SELECT Towary

//   GO  NumerPoz

   IF .NOT. korekta
      APPEND BLANK
   ENDIF

//   SET INDEX TO pozycja

   REPLACE Tow_ArtNr  WITH m->Tow_ArtNr
   REPLACE Mat_ArtNr  WITH m->Mat_ArtNr
   REPLACE ilosc      WITH m->ilosc
   REPLACE Pos        WITH m->Pos

ENDDO

SET FILTER TO
SET KEY -7 TO
SETFUNCTION(9,'')
SETFUNCTION(10,'')
CLOSE DATABASES
RETURN

**********************************************************
FUNCTION podglad (Cofniecie)  // Otwarte "TOWARY"
PRIVATE Datensatz

Datensatz := RECNO()

//SET FILTER TO Tow_ArtNr == m->Tow_ArtNr
//SET INDEX TO Pozycja

GO BOTTOM

SKIP Cofniecie

m->pos    := pos+1
wiersz    := 8


@ 8,2 CLEAR TO 22,78

DO WHILE wiersz < 23 .AND. .NOT. BOF()

   @ wiersz,2  SAY STR(pos,3,0)
   @ wiersz,07 SAY Mat_ArtNr
   @ wiersz,11 SAY STR(ilosc,9,2)
   @ wiersz,22 SAY ALLTRIM(Nazwa(Mat_ArtNr))

   SKIP-1
   wiersz++

ENDDO
//SET FILTER TO
//SET INDEX TO
GO Datensatz

RETURN NIL

***************************************************
FUNCTION Nazwa(material)
PRIVATE odp
USE Materialy NEW

LOCATE FOR Art_Nr == material
IF FOUND()
   odp := nazwa
ELSE
   odp := 'brak nazwy'
ENDIF

CLOSE Materialy
SELECT Towary

RETURN odp