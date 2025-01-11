PROCEDURE zmieniaj
LOCAL OdDnia, DoDnia, SumaCzasow, CzasSredni
LOCAL SCalosc, CenaSredniej, MinCzas, Haslo

Haslo := SPACE(10)
//#include "def.ch"
//SET PATH TO path3
rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'reorganizacja norm')

@ 7,9 SAY "Haslo: " GET Haslo
READ

IF haslo <> "georg22   "
   RETURN
ENDIF
rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'aktualizacja stawek')

m->Numer_wy := SPACE(8)
DoDnia := DATE()
OdDnia := BOY(DATE())
MinCzas:= 1000

SET KEY -1 TO fakts2
SETFUNCTION(9,CHR(27))

@ 7,9 SAY 'Czekaj, czytam archiwum...'

USE archiv
COPY STRUCTURE TO archiv2
USE

USE operacje NEW
INDEX ON wyrob_nr+STR(numer,3,0) TO WyrobOp

USE archiv2 NEW
APPEND FROM archiv
APPEND FROM Rejestr.dbf

rok := STR(YEAR(DATE()),4,0)


@  7,9    SAY "Zmiana czasow operacji na bazie srednich wartosci za okres:"
@  9,9    SAY "Okres od dnia......" GET OdDnia
@ 11,9    SAY "Okres do dnia......" GET DoDnia
@ 13,9    SAY "Minimalny uwzgledniany czas operacji minut.." get MinCzas
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

@ 15,9 SAY 'Czakaj, wprowadzam Zmiany'

DO WHILE .NOT. EOF()
//  m->wyrob    := wyrob
//  m->operacja := operacja

  IF operacja <> m->operacja .OR. wyrob <> m->wyrob

     CzasSredni := SumaCzasow/SumaIlosci

     SELECT operacje
     IF DBSEEK(wyrob+STR(operacja,3,0))

        IF SumaCzasow >= MinCzas
           REPLACE czas2 WITH czas
           REPLACE czas  WITH CzasSredni

        ENDIF
//        ?? STR(czas,6,2)                    // czas normatywny
//        ?? '  '+STR(stawka,9,2)             // godzinowa stawka wg normy

//        CenaNormatywna :=  czas/60 * stawka
//        ?? '    '+STR(CenaNormatywna ,6,2)  // stawka za operacje wg normy
//        ?? '    '+STR(Wspolczynnik,8,2) + '%'

//        CenaSredniej := CzasSredni/60 * stawka

     ELSE
        ?? '*****'
     ENDIF
     SELECT archiv2

     m->operacja := operacja
     m->wyrob    := wyrob
     SumaIlosci  := 0
     SumaCzasow  := 0
  ENDIF

  SumaCzasow  := SumaCzasow + CzasOper
  SumaIlosci  := SumaIlosci + Ilosc

  SKIP

ENDDO
CLOSE DATABASES
RETURN