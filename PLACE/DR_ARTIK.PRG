PROCEDURE dr_artik
#include "def.ch"

rahmen(.F.,.F.,.F.,.F.,.T.,.F.,'drukowanie danych o wyrobach')

USE artykuly 
SET INDEX TO ar_numer
Seite := 1

SET PRINTER ON
SET CONSOLE OFF

? "        Wydruk danych o wyrobach                     Strona "+ALLTRIM(STR(Seite,4,0))
? REPLICATE('Ä',73)
GO TOP

DO WHILE .NOT. EOF()
   IF PROW() >= 57
      EJECT
      Seite++
      ? '        Wydruk danych o wyrobach                    Strona '+ALLTRIM(STR(Seite,4,0))
      ? REPLICATE('Ä',73)
   ENDIF
   ?
   ?  STR(Numer,4,0)+'.   '
   ?? Nazwa1+'          '+Bezeichn1
   ? '        '+Nazwa2+'          '+Bezeichn2
   ? '        '+Nazwa3+'          '+Bezeichn3 
   ? '        Taryfa Celna:'+nrcelny+'      Zolltarif: '+zollcode
   ? LEFT('        Cena za '+ALLTRIM(jednostka)+' '+ALLTRIM(STR(CENA))+' '+ALLTRIM(Waluta)+SPACE(100),30)
  ?? '        Preis pro '+ALLTRIM(Einheit)+' '+ALLTRIM(STR(CENA))+' '+ALLTRIM(Waehrung)
   SKIP

ENDDO

EJECT

USE
SET PRINTER OFF
SET CONSOLE ON

CLOSE DATABASES
SET MARGIN TO 0
RETURN

