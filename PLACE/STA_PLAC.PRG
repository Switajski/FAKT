PROCEDURE dr_stati
#include "def.ch"

rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'wydruk norm')
lp := 1
od := DATE()
do := DATE()
SET KEY -1 TO fakts2
COPY FILE archiv.dbf TO archiv2.dbf
USE archiv2 NEW
APPEND FROM Rejestr
USE wyroby NEW EXCLUSIVE
SET INDEX TO numer_wy
GO TOP

@ 11,9   SAY "Czas od dnia......" GET od
@ 13,9   SAY "     do dnia......" GET do           
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

@ 18,9  SAY "Prosze czekac, trwa wydruk statystyki" 

//SET PRINTER ON
//SET CONSOLE OFF
SET CURSOR OFF

? " Statystyka Produkcji "
?? 'za czas od: '+DTOC(od)+' do: '+DTOC(do)


? ' L.P. numer   nazwa wyrobu                                 ilosc'
? ' 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴'

DO WHILE .NOT. EOF()
   ?   STR(lp,4,0)+'. '
   ??  wyroby->numer_wy+ '    ' + wyroby->nazwa

   SELECT archiv2

   SUM archiv2->ilosc, CenaOperacji(archiv2->wyrob,archiv2->operacja) TO SumaIlosci, SumaPlac FOR wyrob == wyroby->numer_wy .AND. operacja == 1 .AND. data >= od .AND. data <= do

   SELECT wyroby

   ?? '  '+STR(SumaIlosci,10,2)
   ?? '  '+STR(SumaPlac,10,2)
   REPLACE ilosc WITH SumaIlosci
      
   SKIP
   lp++
   IF PROW() >= 60
      EJECT
   ENDIF
ENDDO
INKEY(0)
EJECT
//SET PRINTER OFF
//SET CONSOLE ON
SET CURSOR ON
CLOSE DATABASES
SET MARGIN TO 0
RETURN
