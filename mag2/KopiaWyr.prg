PROCEDURE KopiaWyr
LOCAL Towar
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wprowadzanie zestawien materialowych')

SET KEY -1 TO fakts2
SETFUNCTION(9,CHR(27))

********************** wyrob zrodlowy *********************************

m->Norma := SPACE(10)

//USE Artykuly NEW

//INDEX ON numer TO Ar_Numer

@  8,20 SAY "numer wyrobu zrodlowego......." GET m->Norma VALID .NOT. EMPTY(m->Norma)

READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

USE Towary
SET INDEX TO WYROB

//LOCATE FOR m->Tow_ArtNr == Towary->Tow_ArtNr

//IF .NOT. FOUND()
IF .NOT. DBSEEK(m->Norma)
   ALERT('Wyrob '+ ALLTRIM(m->Norma) +' nie zostal odnaleziony, w normach')
   CLOSE DATABASES
   RETURN
ENDIF

************************* wyrob kopia ************************************
  m->Kop_ArtNr := m->Norma

  @ 10,20 SAY "numer wyrobu do kopiowania...." GET m->Kop_ArtNr VALID (Towar <> m->Kop_ArtNr)

READ

IF LASTKEY() == 27
   CLOSE DATABASES
   RETURN
ENDIF

*************************************************************************

USE TOWARY
//SET INDEX TO wyrob

LOCATE FOR m->Kop_ArtNr == m->Norma

//IF DBSEEK(m->Kop_ArtNr)
IF FOUND()
   ALERT('Wyrob '+ALLTRIM(m->Kop_ArtNr) +' istnieje w normach, dlatego nie mozna go kopiowac')
   CLOSE DATABASES
   RETURN
ENDIF

rahmen(.T.,.F.,.F.,.F.,.T.,.T.,'kopia normy wyrobu: '+ALLTRIM(m->Norma))

//SET FILTER TO m->Tow_ArtNr == TOW_ArtNr
//SET INDEX TO Pozycja
COPY STRUCTURE TO 'temp.dbf'

USE temp.dbf
APPEND FROM TOWARY FOR  TOW_ArtNr == m->Norma
COMMIT

GO TOP
DO WHILE .NOT. EOF()
   REPLACE Tow_ArtNr WITH m->Kop_ArtNr
   SKIP
ENDDO

USE Towary
SET INDEX TO Pozycja, Wyrob
APPEND FROM temp.dbf

SETFUNCTION(10,CHR(23))

SET FILTER TO
SET KEY -7 TO
SETFUNCTION(9,'')
SETFUNCTION(10,'')
CLOSE DATABASES
m->Tow_ArtNr := m->Kop_ArtNr
DO towary
RETURN