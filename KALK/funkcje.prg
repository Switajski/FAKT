PROCEDURE Kopf
? 'Lista Kalkulacyjna Wyrobow z dnia '+DTOC(DATE())
? ' '
? '                                                                                koszty   koszty    koszt   koszt      cena    cena     aktualne'
? 'Art.Nr. Nazwa Wyrobu                                         Robocizna Material stale    zmienne   wlasny  sprzedazy  kalkul. klienta  pokrycie'
? REPLICATE('_',148)
RETURN


FUNCTION Wiersz(Wyrob, strata)
//LOCAL Tablica, RobBrut, SumPremia, RobZPremia,
Tablica       := TransPlac(Wyrob)
RobBrut       := RobBrutto(Tablica[1])  //NrZPlac)
SumPremia     := RobBrut * Premia/100
RobZPremia    := RobBrut + SumPremia
NarzutKStale  := KStale * RobZPremia/100
NarzutKZmienne:= KZmienne * RobZPremia/100

CenaMaterialu := Material(Wyrob)
KZMat         := KZakup/100 * CenaMaterialu
SumaMaterial  := KZMat+CenaMaterialu

KosztWlasny   := RobZPremia + NarzutKStale + NarzutKZmienne + SumaMaterial
KosztWlasnyEUR:= KosztWlasny/Kurs
NarzutSprzed  := RobZPremia * KSprzedaz / 100
NarzutSprzEUR := NarzutSprzed/Kurs
CenaKalk      := KosztWlasny + NarzutSprzed
CenaKalkEUR   := CenaKalk/Kurs
Pokrycie      := CenaKlient - KosztWlasnyEUR
procent       := Pokrycie/NarzutSprzEUR * 100

IF strata == 'T'.AND. procent >= 100
   RETURN NIL
ENDIF
?  Wyrob
?? ' '+Tablica[2]
IF .NOT. EMPTY(Tablica[3])
   ? '           '+Tablica[3]
ENDIF

IF .NOT. EMPTY(Tablica[4])
   ? '           '+Tablica[4]
ENDIF

?? STR(RobZPremia,6,2)+' zl'
?? STR(SumaMaterial,6,2)+' zl'
?? STR(NarzutKStale,6,2)+' zl'
?? STR(NarzutKZmienne,6,2)+' zl'
?? STR(KosztWlasny,7,2)+' zl'
?? STR(NarzutSprzEUR,7,2)+' €'
?? STR(CenaKalkEUR,6,2)+' €'
?? STR(CenaKlient,7,2)+' €'
?? STR(Pokrycie,7,2)+ ' €'
?? STR(Procent,4,0)+' %'

RETURN NIL

PROCEDURE ocena

RETURN

// wyszukiwanie numeru wyrobu, i 3 czesci nazwy z programu PLACE, wynik jako array
FUNCTION TransPlac(ArtNum)
PRIVATE wynik
SET PATH TO &fakt
USE artykuly ALIAS Art NEW
LOCATE FOR ALLTRIM(ArtNum) == ALLTRIM(Numer)
IF FOUND()
   wynik := {Numer_Wy, Nazwa1, Nazwa2, Nazwa3}
   CenaKlient := Cena_Klien
ELSE
   wynik := {'Brak    ', SPACE(50), SPACE(50), SPACE(50)}
ENDIF
CLOSE Art
RETURN wynik

// obliczanie robocizny z programu PLACE

FUNCTION RobBrutto(NrZPlac)
PRIVATE wynik
SET PATH TO &place
USE operacje ALIAS Oper NEW
SUM czas * stawka/60 TO wynik FOR wyrob_nr == NrZPlac
CLOSE Oper
RETURN wynik


//Obliczanie kosztow materialow z programu magazyn

FUNCTION Material(ArtNr)
PRIVATE SumaMaterial

SET PATH TO &magazyn
USE Materialy ALIAS Mat NEW
USE Towary    ALIAS Tow NEW
SET FILTER TO ALLTRIM(Tow_ArtNr)== ALLTRIM(ArtNr)
GO TOP
SumaMaterial := 0

DO WHILE .NOT. EOF()

   SumaMaterial:= Ilosc * CenaMat(Mat_ArtNr) + SumaMaterial
   SKIP

ENDDO
CLOSE Mat
CLOSE Tow
IF SumaMaterial == 0 .AND. bledy1
   ALERT('brak normy materialowej dla wyrobu: '+ALLTRIM(ArtNr))
ENDIF
RETURN SumaMaterial


//Wyszukuje cene materialu w pliku MATERIALY programu MAGAZYN

FUNCTION CenaMat(MatNr)
PRIVATE CenaMat
SELECT Mat   //Materialy
//DBEDIT()
LOCATE FOR ALLTRIM(MatNr) == ALLTRIM(Art_Nr)
IF .NOT. FOUND() .AND. bledy2
   ALERT('Cena Materialu '+MatNr+' dla wyrobu: '+ALLTRIM(Tow->Tow_ArtNr)+' nie zostala odnaleziona')
ENDIF
CenaMat := CENA
SELECT Tow //Towary
RETURN CenaMat

FUNCTION zamiana(wskaznik)
PRIVATE wynik
IF UPPER(wskaznik) == 'T'
   wynik := .T.
ELSE
   wynik := .F.
ENDIF
RETURN wynik