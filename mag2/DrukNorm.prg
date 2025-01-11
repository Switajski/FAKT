PROCEDURE DrukNorm
LOCAL Norma, nCena, nWartosc, nRazem
//#include "def.ch"
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wydruk zestawien materialowych')

SET KEY -1 TO fakts2
SETFUNCTION(9,CHR(27))

********************** NAGLOWEK *********************************

m->Norma := SPACE(10)
nRazem   := 0

@  8,20 SAY "Numer Wyrobu................" GET m->Norma

READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

SET CONSOLE OFF

USE Towary NEW
SET FILTER TO TOW_ArtNr == m->Norma
SET INDEX TO Pozycja
GO TOP
SET PRINTER TO temp.txt
SET DEVICE  TO PRINTER
SET PRINTER ON

?  'Zestawienie Materialowe z dnia: '+ DTOC(DATE())
?  'Numer Wyrobu: '+ALLTRIM(m->Norma)//+' : Zestawienie Materialowe z dnia : '+DTOC(DATE())
?  'Nazwa Wyrobu: '+TowNazwa(m->Norma)
?
?  'L.P. Nr. Nazwa Materialu                                Ilosc j.m.     Cena  Wartosc'
?  REPLICATE('_',84)

DO WHILE .NOT. EOF()
   nCena := MatCena(Mat_ArtNr)
   nWartosc := ROUND(nCena * Towary->Ilosc,2)

   ? Pos
   ?? '. '+Mat_ArtNr
   ?? ' '+LEFT(MatNazwa(Mat_ArtNr),43)
   ?? ' '+STR(Towary->Ilosc,8,2)
   ?? ' '+MatJedn(Mat_ArtNr)
   ?? ' '+STR(nCena,8,2)
   ?? ' '+STR(nWartosc,8,2)
   nRazem := nRazem + nWartosc
   SKIP
ENDDO

?  SPACE(57)+'___________________________'
? '     Razem Wartosc materialow = '+SPACE(42)+STR(nRazem,10,2)

SET PRINTER TO
SET CONSOLE ON
SET DEVICE TO SCREEN
SET PRINTER OFF
CLOSE DATABASES

// ? RunShell( "temp.txt", path4, .T. )

RETURN

FUNCTION MatNazwa(ArtNr)
PRIVATE wyjscie, AltSelect
AltSelect := SELECT()
USE Materialy NEW
LOCATE FOR ArtNR == Materialy->Art_Nr
IF FOUND()
   wyjscie := Materialy->Nazwa
ELSE
   wyjscie := 'Brak Okreslenia'
ENDIF
CLOSE Materialy
SELECT(AltSelect)
RETURN wyjscie
//********** Dostarcza ceny materialu z pliku MATERIALY ***********

FUNCTION MatCena(ArtNr)
PRIVATE wyjscie, AltSelect
AltSelect:= SELECT()
USE Materialy NEW
LOCATE FOR ArtNR == Materialy->Art_Nr
IF FOUND()
   wyjscie := Materialy->Cena
ELSE
   wyjscie := 0
ENDIF
CLOSE Materialy
SELECT(AltSelect)
RETURN wyjscie

//************ Dostarcza jednostke miary z pliku MATERIALY ********

FUNCTION MatJedn(ArtNr)
PRIVATE wyjscie, AltSelect
AltSelect:= SELECT()
USE Materialy NEW
LOCATE FOR ArtNR == Materialy->Art_Nr
IF FOUND()
   wyjscie := Materialy->jednostka
ELSE
   wyjscie := 'bez'
ENDIF
CLOSE Materialy
SELECT(AltSelect)
RETURN wyjscie

//************ Dostarcza jednostke miary z pliku MATERIALY ********

FUNCTION TowNazwa(ArtNr)
PRIVATE wyjscie, AltSelect, Art
AltSelect:= SELECT()
Art := path1+'\Artykuly'
USE &Art Alias Artyk NEW

LOCATE FOR numer == ArtNr
IF FOUND()
   wyjscie := LEFT(ALLTRIM(Artyk->Nazwa1)+' '+ALLTRIM(Artyk->Nazwa2),70)
ELSE
   wyjscie := 'Brak Nazwy'
ENDIF
CLOSE Artyk
SELECT(AltSelect)
RETURN wyjscie