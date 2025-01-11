PROCEDURE dr_ceny
//#include "def.ch"
PRIVATE suma, czas, stawka

rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'wydruk cen')

m->Numer_wy := SPACE(8)
aus:= "M"
SET KEY -1 TO fakts2

USE wyroby NEW
SET INDEX TO numer_wy

SET PRINTER ON
SET CONSOLE OFF
SET PRINTER TO temp.txt

Suma         := 0
SumaSrednich := 0

USE operacje NEW
INDEX ON wyrob_nr TO wyrob_nr
SET INDEX TO wyrob_nr

SET MARGIN TO 5

DBGOTOP()

? '                                                           cena robocizny'
? SPACE(10)+' numer         nazwa wyrobu                      zl / 1 sztuke'
? SPACE(10)+REPLICATE('_',64)

DO WHILE .NOT. EOF()

   IF ALLTRIM(m->numer_wy) == ALLTRIM(wyrob_nr)
      Suma := Suma + czas * stawka/60
      SKIP
   ELSE
      SELECT wyroby
      LOCATE FOR m->numer_wy == numer_wy

      IF .NOT. FOUND()
        m->Nazwa := '*****  Brak opisu wyrobu  *****    '
      ELSE
        m->Nazwa := wyroby->Nazwa
      ENDIF

      SELECT operacje

      IF .NOT. EMPTY(m->numer_wy)

         ? SPACE(11)+m->numer_wy

         ?? "      "+m->Nazwa
         ?? STR(suma,8,2)
      ENDIF

      m->numer_wy := wyrob_nr
      Suma := 0

   ENDIF


ENDDO



SET PRINTER OFF
SET CONSOLE ON
SET PRINTER TO
SET MARGIN TO
CLOSE DATABASES
SET MARGIN TO 0
RunShell( "temp.txt", path4)
RETURN