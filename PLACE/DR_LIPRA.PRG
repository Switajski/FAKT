PROCEDURE dr_LiPra
#include "def.ch"
LOCAL strona
SET MARGIN TO 0
rahmen(.F.,.T.,.F.,.F.,.F.,.F.,'drukowanie listy indywidualnej')

m->lista   := SPACE(10)
m->p_numer := 0
suma       := 0
strona     := 1

SET KEY -1 TO fakts2

@ 7,9    SAY "Numer listy..................." GET m->lista VALID JestLista(m->lista)
@ 9,9    SAY "Numer ewidencyjny pracownika.." GET m->p_numer VALID JestPracownik(m->p_numer) PICTURE '999'
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

SET PRINTER TO temp.txt
SET PRINTER ON
SET CONSOLE OFF

USE archiv NEW
COPY STRUCTURE TO archiv2
USE
USE archiv2 NEW
APPEND FROM archiv
APPEND FROM rejestr


//COPY FILE archiv.dbf TO archiv2.dbf
USE pracowni INDEX p_numer NEW
USE operacje INDEX numer   NEW

SELECT archiv2


Glowka2(Strona)


SET FILTER TO m->lista == lista .AND. m->p_numer == p_numer
DBGOTOP()

DO WHILE .NOT. EOF()


    ? STR(lp,6,0)+' '
   ??  DTOC(data)
   ?? ' '+ wyrob+' '
   ?? NazwaOperacji(wyrob,operacja)
   ?? STR(ilosc,4,0)
   CenOper := CenaOperacji(wyrob,operacja)
   ?? STR(CenOper,6,2)
   Wartosc := ROUND(CenOper * ilosc,2)
   ?? STR(Wartosc,7,2)
   suma := suma+wartosc
   SKIP

ENDDO
?  REPLICATE('_',78)
? '                                                              Suma: '+STR(suma,9,2)
EJECT
SET PRINTER OFF
SET CONSOLE ON
SET PRINTER TO
CLOSE DATABASES
SET MARGIN TO 0
RunShell( "temp.txt", path4)
RETURN

FUNCTION NazwaOperacji(wyr,num)
PRIVATE odp
AltSElect:=SELECT()
SELECT Operacje
LOCATE FOR (ALLTRIM(wyrob_nr) == ALLTRIM(wyr) .AND. numer == num)
IF FOUND()
   odp := nazwa
ELSE
   odp := 'Nieznana operacja                  '
ENDIF
SELECT(AltSelect)
RETURN odp


FUNCTION CenaOperacji(wyr,num)

AltSelect:= SELECT()

SELECT Operacje
LOCATE FOR (wyrob_nr == wyr .AND. numer == num)
IF FOUND()
   odp := ROUND(stawka * czas/60,2)
ELSE
   odp := 0
ENDIF
SELECT(AltSelect)
RETURN odp

FUNCTION PracSzukany(nr)
AltSelect := SELECT()
SELECT Pracowni
IF DBSEEK(nr)
   odp := ALLTRIM(Imie)+' '+ALLTRIM(Nazwisko)
ELSE
   odp := 'Nieznany'
ENDIF
SELECT(AltSelect)
RETURN odp


FUNCTION NazwaWyrobu(NumerWyrobu)
USE wyroby NEW
LOCATE FOR ALLTRIM(numer_wy) == ALLTRIM(NumerWyrobu)
IF FOUND()
   odp := nazwa
ELSE
   ALERT('Blad w odszukaniu nazwy operacji')
   odp := 'Nieznana operacja               '
ENDIF
USE
RETURN odp

FUNCTION Glowka2(Strona)
? PracSzukany(m->p_numer)+'                   strona:'+STR(strona,2,0)
? 'Lista: '+ALLTRIM(lista)
? '                                                           ilosc  stawka za '
? ' zapis  data    wyrob    nazwa operacji                      szt.   1   ilosc'
? REPLICATE('_',78)
RETURN .T.