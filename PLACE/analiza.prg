PROCEDURE Analiza
LOCAL OdDnia, DoDnia, SumaCzasow, CzasSredni, Wspolczynnik, Calosc, CenaNormatywna
LOCAL SCalosc, CenaSredniej, SumaWyrobu

//#include "def.ch"
//SET PATH TO path3
rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'reorganizacja norm')
USE archiv
GO TOP

m->Numer_wy := SPACE(8)
DoDnia     := DATE()
OdDnia     := DATA
Calosc     := 0
SCalosc    := 0
//SumaWyrobu := 0


SET KEY -1 TO fakts2
SETFUNCTION(9,CHR(27))

@ 7,9 SAY 'Czekaj, czytam archiwum...'

//USE archiv
COPY STRUCTURE TO archiv2
USE

USE operacje NEW
INDEX ON wyrob_nr+STR(numer,3,0) TO WyrobOp

USE archiv2 NEW
APPEND FROM archiv
APPEND FROM Rejestr.dbf

rok := STR(YEAR(DATE()),4,0)


@  7,9    SAY "Wykaz srednich czasow operacji za:"
@  9,9    SAY "Okres od dnia......" GET OdDnia
@ 11,9    SAY "Okres do dnia......" GET DoDnia
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

SET FILTER TO data >= OdDnia .AND. data <= DoDnia
INDEX ON wyrob + STR(operacja,3,0) TO WyrOper
DBGOTOP()

SET PRINTER ON
SET CONSOLE OFF
SET PRINTER TO temp.txt

SumaCzasow  := 0
SumaIlosci  := 0
m->wyrob    := wyrob
m->operacja := operacja

?? '     Wykaz Srednich Czasow Operacji za okres od: '+DTOC(OdDnia)+' do: '+DTOC(DoDnia)

? ''
? '                      --  czas minut   --   --- stawka zl za ---'
? 'Wyrob operacja ilosc  suma   sredni norma   godzine    operacje   wyk.normy'
? REPLICATE('_',75)

DO WHILE .NOT. EOF()

  IF operacja <> m->operacja .OR. wyrob <> m->wyrob



      ? m->wyrob
     ?? STR(m->operacja,3,0)
     ?? STR(SumaIlosci,7,0)
     ?? STR(SumaCzasow,9,0)

        CzasSredni := SumaCzasow/SumaIlosci
     ?? STR(CzasSredni,7,2) // Sredni czas wykonania

     SELECT operacje

     IF DBSEEK(m->wyrob+STR(m->operacja,3,0))
        ?? STR(czas,6,2)                    // czas normatywny
        ?? '  '+STR(stawka,9,2)             // godzinowa stawka wg normy

        CenaNormatywna :=  czas/60 * stawka
        ?? '    '+STR(CenaNormatywna ,6,2)  // stawka za operacje wg normy

        Wspolczynnik := (czas - CzasSredni) / czas * 100

        ?? '    '+STR(Wspolczynnik,8,2) + '%'
        calosc := calosc + CenaNormatywna*SumaIlosci

        CenaSredniej := CzasSredni/60 * stawka
        SCalosc:= SCalosc + CenaSredniej * SumaIlosci
     ELSE
        ?? '*****'
     ENDIF
     SELECT archiv2

     IF wyrob <> m->wyrob
        ? REPLICATE('-',74)
     ENDIF

     m->operacja := operacja
     m->wyrob    := wyrob
     SumaIlosci  := 0
     SumaCzasow  := 0


  ENDIF

  SumaCzasow  := SumaCzasow + CzasOper
  SumaIlosci  := SumaIlosci + Ilosc

  SKIP

ENDDO
? ''
? 'Calosc plac wg stawek normatywnych wynosi       '+STR(calosc,10,2)
? 'Calosc plac wg srednich czasow wykonania wynosi '+STR(SCalosc,10,2)

SET PRINTER OFF
SET CONSOLE ON
SET PRINTER TO
CLOSE DATABASES
SET MARGIN TO 0
RunShell( "temp.txt", path4)
RETURN