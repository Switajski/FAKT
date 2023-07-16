PROCEDURE preislst
#include "def.ch"
PRIVATE prnfile

rahmen(.F.,.F.,.F.,.F.,.T.,.F.,'drukowanie danych o wyrobach')

m->Kli_Numer := 0

@ 12,20 SAY 'PREISLISTE dla klienta nr......' GET m->Kli_Numer PICTURE '99999' VALID egsist(m->Kli_Numer)
READ

IF LASTKEY() == 27
   RETURN
ENDIF

USE artykuly
SET INDEX TO ar_numer
SET PRINTER TO 'temp.txt'
SET DEVICE  TO PRINTER
SET PRINTER ON
SET CONSOLE OFF
SET MARGIN TO 0

? "                     Preisliste vom: "+DTOC(DATE())
?
? "Art.Nr.    Bezeichnung"
??SPACE(85)+"Preis EUR"

GO TOP

DO WHILE .NOT. EOF()
   IF m->Kli_Numer == Kli_Numer
      ?
      ?  Numer+' '
      ?? LEFT(ALLTRIM(Bezeichn1)+' '+ALLTRIM(Bezeichn2)+' '+ALLTRIM(Bezeichn3)+REPLICATE('.',100),97)
      ?? STR(cena_klien,8,2)
   ENDIF
   SKIP
ENDDO



SET PRINTER TO
SET DEVICE TO SCREEN
SET PRINTER OFF
SET CONSOLE ON

CLOSE DATABASES
SET MARGIN TO 0
RunShell( 'temp.txt', path4)

RETURN


FUNCTION egsist(kd)

USE Klienci
LOCATE FOR Kli_Numer == kd
IF FOUND()
   antw := .T.
ELSE
   antw := .F.
   ALERT('Klient nie zostal znaleziony')
ENDIF
USE
RETURN antw