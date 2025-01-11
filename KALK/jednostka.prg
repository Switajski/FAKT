PROCEDURE Jednostka
LOCAL Suma, SumaCzasu, WartoscSuma, text, RobZPremia, CenaKlienta, NarzKStale
LOCAL NarzKZmienne, JedKoszt, JedKosztEUR, NarzutSprz, CenaKalk, Pokrycie, PokrycieProc
DO rahmen
m->Numer_wy := SPACE(8)
SET KEY -1 TO fakts2
SET PATH TO &fakt

m->numer := SPACE(10)
@ 7,9    SAY "Numer wyrobu......" GET m->numer //VALID DBSEEK(m->numer_wy)
READ

IF LASTKEY() == 27
   CLOSE DATABASES
   RETURN
ENDIF

USE artykuly ALIAS art NEW
LOCATE FOR m->numer == numer

IF .NOT. FOUND()
   ALERT('wyrob nie zostal wprowadzony do systemu')
   CLOSE DATABASES
   RETURN
ENDIF

@  9,9   SAY 'numer wyrobu......' + numer
@ 11,9   SAY 'nazwa wyrobu......' + nazwa1
@ 12,9   SAY '                  ' + nazwa2
@ 13,9   SAY '                  ' + nazwa3
IF .NOT. EMPTY(numer_wy)
   @ 15,9   SAY 'numer robocizny   ' + numer_wy
ELSE
   @ 15,9   SAY 'dla wyrobu '+ALLTRIM(m->numer)+ ' nie zostal wprowadzony numer kalkulacyjny'
   @ 16,9   SAY 'w programie FAKT. Prosze nadac numer i ponownie wrocic do programu'
   INKEY(0)
   CLOSE DATABASES
   RETURN
ENDIF
CenaKlienta := Cena_Klien

SET PRINTER TO temp.txt
SET PRINTER ON
SET CONSOLE OFF
m->numer_wy := numer_wy

Suma      := 0
SumaCzasu := 0

??  "Kalkulacja dla wyrobu: "+ALLTRIM(nazwa1)+' '+ALLTRIM(nazwa2)+' '+ALLTRIM(nazwa3)
?  "numer wyrobu: "+ALLTRIM(numer)+' * Robocizna:'+ALLTRIM(m->numer_wy)
?? " * Data: "+DTOC(DATE())+' * Kurs PLN/EUR: '+STR(kurs,7,4)
?  ''

SET PATH TO &place
USE operacje ALIAS plac NEW

DBGOTOP()

? '                                                      czas    - s t a w k a -'
? 'numer nazwa operacji                                  (min)    godz. operacja'
? REPLICATE('_',79)

DO WHILE .NOT. EOF()
   StawkaOperacji := czas * stawka / 60

   IF ALLTRIM(m->numer_wy) == ALLTRIM(wyrob_nr)
      StawkaOperacji := ROUND(czas * stawka / 60,2)
      ?  STR(numer,3,0)+ '.  ' + nazwa + '           '+STR(czas,6,2)+'     '+STR(stawka,6,2)+' '+STR(StawkaOperacji,6,2)+' zl'
      Suma      := Suma + StawkaOperacji
      SumaCzasu := SumaCzasu + Czas
   ENDIF

   SKIP

ENDDO
?  REPLICATE('_',79)
? '                                                   '+STR(SumaCzasu,7,2)+' min       '+STR(Suma,7,2)+' zl'

RobZPremia := Suma + Suma * Premia/100
RobZPremia := ROUND(RobZPremia,2)
? '   A. Robocizna z premia '+STR(Premia,2,0)+ ' % .......................................' + STR(RobZPremia,7,2)+' zl'
CLOSE Art
SET PATH TO &magazyn
WartoscSuma := 0

USE Materialy ALIAS Mat NEW
USE Towary    ALIAS Tow NEW
?
? 'wykaz materialow na wyrob'
? ''
? 'L.P. numer nazwa materialu                           ilosc       cena   wartosc'
? REPLICATE('_',79)
DO WHILE .NOT. EOF()
   IF TOW_ArtNr == m->numer
      Cena := CenaMat(Mat_ArtNr)
      Wartosc := ROUND(Cena*Ilosc,2)
      WartoscSuma := Wartosc + WartoscSuma
      text := TransMat(Mat_ArtNr)
      ?  STR(Pos,3,0)+'.  '
      ?? Mat_ArtNr+' '
      ?? LEFT(text[1],40)
      ?? STR(Ilosc,7,2)
      ?? ' '+text[2]
      ?? STR(Cena,7,2)
      ?? STR(Wartosc,7,2)+ ' zl'
   ENDIF
   SKIP
ENDDO
? REPLICATE('_',79)

MatZNarzutem := ROUND(WartoscSuma*KZakup/100 + WartoscSuma,2)
//MatZNarzutem := ROUND(MatZNarzutem,2)

NarzKStale   := ROUND(KStale*RobZPremia/100,2)
NarzKZmienne := ROUND(KZmienne*RobZPremia/100,2)
JedKoszt     := RobZPremia + MatZNarzutem + NarzKStale + NarzKZmienne
JedKosztEUR  := ROUND(JedKoszt/Kurs,2)
NarzutSprz   := ROUND(KSprzedaz/100*RobZPremia/Kurs,2)
CenaKalk     := JedKosztEUR+NarzutSprz
Pokrycie     := CenaKlienta -  JedKosztEUR
PokrycieProc := Pokrycie / NarzutSprz * 100


? SPACE(6)+'Koszty Materialowe.............................................'+STR(WartoscSuma,7,2)+ ' zl'
? SPACE(3)+'B. Koszty materialowe z narzutem '+STR(KZakup,5,2)+' % .........................'+STR(MatZNarzutem,7,2)+' zl'
? ''
? SPACE(3)+'C. Narzut Kosztow Stalych      '+STR(KStale,7,2)+  ' % .........................'+STR(NarzKStale,7,2) + ' zl'
? SPACE(3)+'D. Narzut Kosztow Zmiennych    '+STR(KZmienne,7,2)+' % .........................'+STR(NarzKZmienne,7,2)+' zl'
? REPLICATE('_',79)
? SPACE(3)+"E1.Jednostkowy Koszt Produkcji Wyrobu A+B+C+D....................."+STR(JedKoszt,7,2)+   ' zl'
? SPACE(3)+"E2.Jednostkowy Koszt Produkcji Wyrobu A+B+C+D w EURO.............."+STR(JedKosztEUR,7,2)+ ' €'
? SPACE(3)+"F. Narzut Kosztow Sprzedazy W EURO................................"+STR(NarzutSprz,7,2)+  ' €'
? SPACE(3)+"G. Cena Kalkulowana w EURO........................................"+STR(CenaKalk,7,2)+    ' €'
? REPLICATE('_',79)
? SPACE(3)+"   Aktualna Cena Klienta w EURO..................................."+STR(CenaKlienta,7,2)+ ' €'
? SPACE(3)+"   Aktualne Pokrycie Sprzedazy w EURO (Suma)......................"+STR(Pokrycie,7,2)+    ' €'
? SPACE(3)+"   Aktualne Pokrycie Sprzedazy w %................................"+STR(PokrycieProc,7,2)+' %'

SET PRINTER OFF
SET CONSOLE ON
CLOSE DATABASES
SET PRINTER TO
RunShell( "temp.txt", path4)
SET MARGIN TO 0
RETURN

// wyszukuje nazwe materialu w pliku MATERIALY programu Magazyn
FUNCTION TransMat(MatNr)
PRIVATE nazwa
SELECT Mat
nazwa := {nazwa, jednostka}
SELECT Tow
RETURN nazwa