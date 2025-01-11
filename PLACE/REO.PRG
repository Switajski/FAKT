PROCEDURE reo
#include "def.ch"
LOCAL Zerowanie, faktor, StaraStawka, NowaStawka

USE wyroby EXCLUSIVE

PACK
INDEX ON numer_wy TO numer_wy  // numer wyrobu
INDEX ON nazwa    TO nazwa_wy  // nazwa wyrobu
USE

USE Operacje EXCLUSIVE
PACK
INDEX ON numer TO numer
USE

//Zmiana stawek godzinowych przez przemnozenie wspolczynnikiem


faktor := 0

IF faktor > 0
   USE Operacje EXCLUSIVE
   GO TOP
   DO WHILE .NOT. EOF()
      m->stawka := stawka * faktor
      REPLACE stawka WITH m->stawka
      ? STR(m->stawka,10,2)
      SKIP
   ENDDO
   USE
ENDIF

***************************************************************
//Zmiana stawek godzinowych przez podanie stawki

StaraStawka := 4.10
NowaStawka  := 0

IF NowaStawka > 0
   ALERT('Zmiana Stawek')
   USE Operacje EXCLUSIVE
   GO TOP
   DO WHILE .NOT. EOF()
      IF stawka == StaraStawka
         REPLACE stawka WITH NowaStawka
         ? STR(StaraStawka,10,2)+' Nowa Stawka: '+STR(NowaStawka,10,2)
      ENDIF
      SKIP
   ENDDO
   USE
ENDIF

************************************************************

USE Pracowni EXCLUSIVE
PACK
INDEX ON numer TO p_numer
INDEX ON Nazwisko TO Nazwisko
USE

USE lista EXCLUSIVE
PACK
INDEX ON lista TO lista
USE

USE zlecenia EXCLUSIVE
PACK
INDEX ON zlecenie TO z_numer
USE

USE rejestr EXCLUSIVE
PACK
INDEX ON lp TO lp
INDEX ON STR(operacja)+STR(lp) TO OperacLP
INDEX ON lista+STR(p_numer)+DTOC(data)+STR(GodzOd)+STR(GodzDo) TO LPDGM
USE

USE Koszty
PACK
INDEX ON miejsce TO Koszty
USE
RETURN


PROCEDURE Kontrola
USE Operacje
SET FILTER TO stawka <> stawka2 .OR. czas <> czas2

DBEDIT(,,,,{"wyrob_nr","numer","nazwa","czas","czas2","stawka","stawka2"})
USE
RETURN

PROCEDURE Zerowanie

USE Operacje

IF ALERT("Czy wyzerowac wszystkie operacje", {"Nie","Tak"}) == 2

   GO TOP
   DO WHILE .NOT. EOF()
      REPLACE stawka2 WITH stawka
      REPLACE czas2   WITH czas
      SKIP
   ENDDO
   ALERT("Operacje zostaly wyzerowane")

ENDIF
USE
RETURN