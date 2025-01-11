PROCEDURE BiezCzas
#include "def.ch"

rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'czasy biezace')

m->Numer_wy := SPACE(8)
do := DATE()
aus:= "M"
SET KEY -1 TO fakts2
USE rejestr NEW
USE wyroby  NEW
SET INDEX TO numer_wy

rok := STR(YEAR(DATE()),4,0)
//od  := CTOD("01.01."+LEFT(rok,2))
od := DATE()

@ 7,9    SAY "Numer wyrobu......" GET m->numer_wy //VALID DBSEEK(m->numer_wy)
@ 9,9    SAY "Czas od dnia......" GET od
@ 9,38   SAY " do dnia......" GET do           
@ 11,9   SAY "Wyjscie (M)onitor/(D)rikarka " GET aus
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

@ 12,9   SAY 'nazwa wyrobu......' + nazwa COLOR farb4

IF UPPER(aus) <> "M"
   SET PRINTER ON
   SET CONSOLE OFF
ELSE
   CLEAR SCREEN
ENDIF

Suma         := 0
SumaSrednich := 0

? "Wykaz Operacji do wyrobu: "+nazwa+' numer: '+m->numer_wy
? 'za czas od: '+DTOC(od)+' do: '+DTOC(do)

USE operacje NEW EXCLUSIVE
SET INDEX TO numer

DBGOTOP()

? '         Czasy Biezace                              -- czas minut--'
? ' numer   nazwa operacji                        norma    sredni     ilosc'
? ' 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴'

DO WHILE .NOT. EOF()

   IF ALLTRIM(m->numer_wy) == ALLTRIM(wyrob_nr)

      ?  STR(numer,5,0)+ '    ' + nazwa + STR(czas,8,2)
      Suma := Suma + czas

      SELECT rejestr

      SUM rejestr->czasoper, rejestr->ilosc TO SumaCzasow, SumaIlosci FOR wyrob == m->numer_wy .AND. operacja == operacje->numer .AND. data >= od .AND. data <= do
      SredniCzasOperacji := SumaCzasow/SumaIlosci

      SELECT operacje
      ?? STR(SredniCzasOperacji,8,2)
      SumaSrednich := SredniCzasOperacji + SumaSrednich

      ?? '  '+STR(SumaIlosci,10,2)
      
   ENDIF

   SKIP

ENDDO
? ' 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴'
? '                                       Suma:'+STR(Suma,8,2)
?? STR(SumaSrednich,8,2)

IF UPPER(aus) <> "M"
   EJECT
ENDIF

IF UPPER(aus) <>"M"
   SET PRINTER OFF
   SET CONSOLE ON
ELSE
   INKEY(0)
//   WACLOSE()
ENDIF

CLOSE DATABASES
SET MARGIN TO 0
RETURN
