PROCEDURE zdejmij
LOCAL MatZuzycie,pr,ro
PUBLIC cofac

rahmen(.T.,.F.,.F.,.F.,.T.,.T.,'zdejmowanie stanow magazynu norma materialowa')

SET KEY -1 TO fakts2
SETFUNCTION(9,CHR(27))
//SETFUNCTION(10,CHR(23))

********************** NAGLOWEK *********************************

m->Tow_ArtNr  := SPACE(10)
m->Ilosc      := 0
m->Pozycja    := 0
m->opis       := SPACE(30)
m->Data       := DATE()
//cofac         := .F.

USE Magazyn
GO BOTTOM
m->Zapis := Zapis+1
USE

DO WHILE .T.
   cofac := .F.

   @   5,7 SAY "numer zamowienia........" GET m->Opis
   @   7,7 SAY "pozycja zamowienia......" GET m->Pozycja PICTURE "999" VALID Test(m->Opis, m->Pozycja)
   @   9,7 SAY "Wyrob..................." GET m->Tow_ArtNr VALID JestNorma(m->Tow_ArtNr)
   @  11,7 SAY "Ilosc..................." GET m->Ilosc PICTURE "99999.99"
   @  13,7 SAY "Data...................." GET m->DATA

   READ

   IF LASTKEY()== 27
      RETURN
   ENDIF

   IF .NOT. cofac

      USE Magazyn NEW
      SET INDEX TO ZAPIS
      USE Towary NEW

      SET FILTER TO Tow_ArtNr == m->Tow_ArtNr
      GO TOP

      DO WHILE .NOT. EOF()
         // obliczenie zuzycia jednostkowego
         MatZuzycie   := Towary->Ilosc * m->Ilosc
         m->Mat_ArtNr := Towary->Mat_ArtNr

         SELECT Magazyn
         APPEND BLANK

         REPLACE Zapis     WITH m->Zapis
         REPLACE DATA      WITH m->DATA
         REPLACE OPIS      WITH m->OPIS
         REPLACE Pos       WITH m->Pozycja
         REPLACE ROZCHOD   WITH MatZuzycie
         REPLACE ART_NR    WITH m->Mat_ArtNr
         REPLACE Tow_ArtNr WITH m->Tow_ArtNr
         DBCOMMIT()
         m->zapis++

         SELECT Magazyn
         SUM przychod, rozchod TO pr, ro FOR m->Mat_ArtNr == Art_Nr

         IF pr - ro < 0
            ALERT('Uwaga, stan ujemny dla materialu:'+m->Mat_ArtNr+' = '+ALLTRIM(STR(pr-ro,10,2)))
         ENDIF

         SELECT Towary
         SKIP

      ENDDO
      CLOSE DATABASES
   ENDIF
   zapis++
ENDDO
//SETFUNCTION(9,'')
SETFUNCTION(10,'')
RETURN

FUNCTION Test(Zamowienie,Pozycja)

USE Magazyn
GO TOP
LOCATE FOR Opis == Zamowienie .AND. Pozycja == Pos
IF .NOT. FOUND()
   wynik := .T.
ELSE
   IF ALERT('Zamowienie nr '+ALLTRIM(OPIS)+' , pozycja nr '+STR(POS,3,0)+' zostalo juz wprowadzone.',{'cofnij','usun'}) == 1
      CLEAR GETS
      cofac := .T.
   ELSE
      Usunac(Zamowienie, Pozycja)
   ENDIF
   wynik := .F.
//   CLEAR GETS
ENDIF
CLOSE DATABASES
RETURN wynik

FUNCTION Usunac(Zamowienie, Pozycja)
IF ALERT('Zamowienie nr '+ALLTRIM(Zamowienie)+', pozycja nr '+STR(Pozycja,3,0)+' usunac ?',{'nie usuwac','usunac'}) == 2
   USE Magazyn
   SET INDEX TO ZAPIS
   DELETE FOR Opis == Zamowienie .AND. Pozycja == Pos
   PACK
   CLEAR GETS
   USE
ENDIF
cofac := .T.
RETURN NIL

FUNCTION JestNorma(Towar)
PRIVATE Jest
USE TOWARY
LOCATE FOR Tow_ArtNr == m->Tow_ArtNr
IF .NOT. FOUND()
    ALERT('Brak normy materialowej')
    Jest := .F.
    cofac := .T.
    CLEAR GETS
ELSE
    Jest := .T.
ENDIF
CLOSE DATABASES
RETURN Jest