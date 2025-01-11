PROCEDURE dr_wyrob
#include "def.ch"

rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'wydruk norm')
lp := 1
Strona := 1
USE wyroby NEW
SET INDEX TO nazwa_wy


SET PRINTER ON
SET CONSOLE OFF
SET PRINTER TO temp.txt
Suma := 0

USE operacje NEW
SET INDEX TO numer
Suma:= 0
Wydruk := 5
strona := 1
SELECT wyroby

DBGOTOP()
naglowek(strona)

DO WHILE .NOT. EOF()

   SELECT operacje
   SUM czas, czas * stawka/60  TO SumaCzasu, SumaStawek FOR ALLTRIM(wyroby->numer_wy) == ALLTRIM(operacje->wyrob_nr)

   IF SumaCzasu > 0
      ?  STR(lp,3,0)+ '.  '
      ?? wyroby->nazwa + '  '
      ?? wyroby->numer_wy+'   '
      ?? STR(SumaCzasu,7,2)+'   '
      ?? STR(SumaStawek,7,2)
      lp++
      wydruk++
   ENDIF

   SELECT wyroby
   SKIP
   IF wydruk >= 62
      EJECT
      wydruk := 5
      strona++
      naglowek(strona)
    ENDIF
ENDDO
?  REPLICATE('_',75)
? '                                                                 Koniec'
EJECT

SET PRINTER TO
SET PRINTER OFF
SET CONSOLE ON
CLOSE DATABASES
SET MARGIN TO 0
RunShell( "temp.txt", path4)
RETURN

FUNCTION naglowek
PARAMETER strona
? "Baby's World Spolka z o.o., Borowno, 86-200 Chelmno            "+DTOC(DATE())
? 'Zestawienie Robocizny wyrobow, strona: '+STR(strona,2,0)
? ''
? 'L.P.  nazwa wyrobu                         numer       czas(min) stawka'
? REPLICATE('_',75)
RETURN NIL