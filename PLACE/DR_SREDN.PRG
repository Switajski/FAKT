PROCEDURE dr_sredn
LOCAL OdDnia, DoDnia, ar, ar2
//#include "def.ch"
//SET PATH TO path3
rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'wydruk norm')

m->Numer_wy := SPACE(8)
DoDnia := DATE()
OdDnia := BOY(DATE())

SET KEY -1 TO fakts2
SETFUNCTION(9,CHR(27))

USE archiv
COPY STRUCTURE TO archiv2
USE
USE archiv2 NEW
APPEND FROM archiv
APPEND FROM Rejestr.dbf

USE wyroby  NEW

SET INDEX TO numer_wy

rok := STR(YEAR(DATE()),4,0)

@ 7,9    SAY "Numer wyrobu......" GET m->numer_wy //VALID DBSEEK(m->numer_wy)
@ 9,9    SAY "Czas od dnia......" GET OdDnia
@ 9,38   SAY " do dnia......" GET DoDnia
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

LOCATE FOR m->Numer_Wy == Numer_Wy
IF .NOT. FOUND()
    ALERT('Zestaw operacji dla wyrobu nr: '+ALLTRIM(m->Numer_Wy)+' nie zostal odnaleziony')
    CLOSE DATABASES
    RETURN
ENDIF

@ 12,9   SAY 'nazwa wyrobu......' + nazwa COLOR farb4

SET PRINTER ON
SET CONSOLE OFF
SET PRINTER TO temp.txt

Suma         := 0
SumaSrednich := 0

? "Wykaz Operacji do wyrobu: "+nazwa+' numer: '+m->numer_wy
? 'za czas od: '+DTOC(OdDnia)+' do: '+DTOC(DoDnia)

USE operacje NEW EXCLUSIVE
SET INDEX TO numer

DBGOTOP()

? '                                              -- czas minut--'
? ' numer   nazwa operacji                        norma    sredni     ilosc'
? REPLICATE('_',75)

DO WHILE .NOT. EOF()

   IF ALLTRIM(m->numer_wy) == ALLTRIM(wyrob_nr)

      ?  STR(numer,5,0)+ '    ' + nazwa + STR(czas,8,2)
      Suma := Suma + czas

      SELECT archiv2

      SUM archiv2->czasoper, archiv2->ilosc TO SumaCzasow, SumaIlosci FOR wyrob == m->numer_wy .AND. operacja == operacje->numer .AND. data >= OdDnia .AND. data <= DoDnia
      SredniCzasOperacji := SumaCzasow/SumaIlosci

      SELECT operacje
      ?? STR(SredniCzasOperacji,8,2)
      SumaSrednich := SredniCzasOperacji + SumaSrednich

      ?? '  '+STR(SumaIlosci,10,2)
//      REPLACE CzasSred  WITH SredniCzasOperacji
//      REPLACE Na_Ilosc  WITH SumaIlosci

   ENDIF

   SKIP

ENDDO
? REPLICATE('_',75)
? '                                       Suma:'+STR(Suma,8,2)
?? STR(SumaSrednich,8,2)

SET PRINTER OFF
SET CONSOLE ON
SET PRINTER TO
CLOSE DATABASES
SET MARGIN TO 0
RunShell( "temp.txt", path4)
RETURN