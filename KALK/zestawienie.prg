PROCEDURE zestawienie

LOCAL Tablica, RobBrut, SumPremia, RobPremia, NarzutKStale, NarzutKZmienne, CenaMaterialu, KZMat, SumaMaterial, opcja
LOCAL KosztWlasny, KosztWlasnyEUR, NarzutSprzed, NarzutSprzEUR, CenaKalk, CenaKalkEUR, Pokrycie, Procent, Wyrob, RobZPremia, NrZPlac
//PUBLIC place, magazyn, path4, fakt, CenaKlient, Premia, bledy1, bledy2
SET MARGIN TO 0

DO Rahmen

b1 := 'N'
b2 := 'N'
b3 := 'T'

@ 10,12 SAY 'Kontrola bledow w normach materialowych T/N...' GET b1  VALID UPPER(b1) == 'T'.OR. UPPER(b1) == 'N'
@ 12,12 SAY 'Kontrola bledow w materialach...........T/N...' GET b2  VALID UPPER(b1) == 'T'.OR. UPPER(b1) == 'N'
@ 14,12 SAY 'Drukowac tylko zanizony zysk............T/N...' GET b3  VALID UPPER(b1) == 'T'.OR. UPPER(b1) == 'N'
READ

IF LASTKEY() == 27
   RETURN
ENDIF

bledy1 := zamiana(b1)
bledy2 := zamiana(b2)

DO RAHMEN
SET CURSOR OFF
@10,15 SAY 'Prosze czekac, trwa przetwarzanie danych'
@11,15 SAY 'czynnosc trwa od kilku do kilkunastu minut'

SET PRINTER ON
SET CONSOLE OFF
SET PRINTER TO temp.txt
DO Kopf
dat1 :=  fakt+'\artykuly'
dat2 :=  fakt+'\Ar_Numer'
//USE D:\FAKT2\BAZA\Artykuly  Alias Artyk NEW
//SET INDEX TO D:\FAKT2\BAZA\Ar_Numer
USE &dat1 ALIAS Artyk NEW
SET INDEX TO &dat2

GO TOP

DO WHILE.NOT. EOF()
   IF .NOT. EMPTY(Numer_Wy)
      Wiersz(Numer,b3)
   ENDIF
   SELECT Artyk
   SKIP
ENDDO


SET PRINTER OFF
SET CONSOLE ON
SET PRINTER TO
SET MARGIN TO
SET CURSOR ON
CLOSE DATABASES
SET MARGIN TO 0
RunShell( "temp.txt", path4)
RETURN