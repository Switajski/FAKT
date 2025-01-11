PROCEDURE dr_stati
LOCAL OdDnia, DoDnia,LP, Robocizna, SumaJednostkowa, SumaOgolem
//#include "def.ch"

rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'wydruk norm')
lp := 1
OdDnia := BOY(DATE())
DoDnia := DATE()
SET KEY -1 TO fakts2
SETFUNCTION(9,CHR(27))

//COPY FILE archiv.dbf TO archiv2.dbf
USE archiv
COPY STRUCTURE TO archiv2
USE

USE archiv2 NEW
APPEND FROM rejestr
APPEND FROM archiv
USE wyroby NEW EXCLUSIVE
SET INDEX TO numer_wy
GO TOP

@ 11,9   SAY "Czas od dnia......" GET OdDnia
@ 13,9   SAY "     do dnia......" GET DoDnia
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

@ 18,9  SAY "Prosze czekac, trwa wydruk statystyki"

SET PRINTER TO temp.txt
SET PRINTER ON
SET CONSOLE OFF
SET CURSOR OFF
SET MARGIN TO 0
SumaOgolem := 0

CLEAR

? " Statystyka Produkcji "
?? 'za czas od: '+DTOC(OdDnia)+' do: '+DTOC(DoDnia)


? ' L.P. numer   nazwa wyrobu                                ilosc    cena    wartosc'
? REPLICATE('_',82)

DO WHILE .NOT. EOF()
   SELECT wyroby
   SELECT archiv2

   SUM archiv2->ilosc TO SumaIlosci FOR wyrob == wyroby->numer_wy .AND. operacja == 1 .AND. data >= OdDnia .AND. data <= DoDnia
   IF SumaIlosci > 0
      ?   STR(LP,4,0)+'. '
      SELECT wyroby
      ??  wyroby->numer_wy+ '  ' + wyroby->nazwa
      ?? '  '+STR(SumaIlosci,10,2)

      Robocizna := ROUND(RobBrutto(wyroby->numer_wy),2)
      ?? '  '+STR(Robocizna,6,2)

      SumaJednostkowa := ROUND(SumaIlosci * Robocizna,2)
      ?? '  '+STR(SumaJednostkowa,9,2)

      LP++
      SumaOgolem := SumaOgolem + SumaJednostkowa
   ENDIF
   SELECT wyroby
   SKIP
ENDDO
? REPLICATE('_',82)
? '                  Suma Ogolem  :  '+ STR(SumaOgolem,10,2)

SET PRINTER OFF
SET CONSOLE ON
SET CURSOR ON
SET PRINTER TO
CLOSE DATABASES
SET MARGIN TO 0
SETFUNCTION(9,CHR(27))
SET KEY -1 TO
RunShell( "temp.txt", path4)
RETURN

FUNCTION RobBrutto(NrZPlac)
PRIVATE wynik
USE operacje ALIAS Oper NEW
SUM czas * stawka/60 TO wynik FOR wyrob_nr == NrZPlac
CLOSE Oper
RETURN wynik

FUNCTION BOY()
PRIVATE dat
dat := CTOD('01.01.'+RIGHT(DTOC(DATE()),4))
RETURN dat
