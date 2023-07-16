PROCEDURE intr_DE

PRIVATE datei

@ 5,1 CLEAR TO 22,69


m->miesiac := MONTH(DATE())-1


SET KEY -1 TO fakts2


rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'generowanie statystiki sprzedazy')

@ 7,20 SAY "Statystyka sprzedazy za miesiac : " GET m->miesiac PICTURE '99' VALID m->miesiac <= 12 .AND. m->miesiac > 0
READ

IF LASTKEY() == 27
   RETURN
ENDIF


USE Archiv

COPY STRUCTURE TO Temp4.dbf

USE Temp4

APPEND FROM Archiv FOR m->miesiac == MONTH(fakt_dat)
INDEX ON Nr_Celny TO taryfa
SET INDEX TO Taryfa

GO TOP


DO WHILE .NOT. EOF()

   m->Nr_Celny := Nr_Celny
   SKIP
   IF m->Nr_Celny == Nr_Celny
      DELETE
   ELSE
      m->Nr_Celny := Nr_Celny
   ENDIF

ENDDO
PACK

SET PRINTER TO 'temp.txt'
SET DEVICE TO PRINTER
SET PRINTER ON
SET CONSOLE OFF

GO TOP

USE Archiv NEW
USE taric  NEW

SELECT Temp4

? ' Zusammenstellung fr EG-Einkauf fr INTRASTAT DE fr Monat '+STR(m->miesiac,2,0)
?
? ' Pos. Zoll-Nr      EG-Einkauf          Gewicht '
? ' _____________________________________________________'


i := 1

DO WHILE .NOT. EOF()


   m->Nr_Celny := Nr_Celny

   SELECT Taric
   LOCATE FOR Numer == m->Nr_Celny

   ? STR(i,3,0)+'. '

   IF FOUND()
      ?? ALLTRIM(Bezeichn1)
   ELSE
      ?? 'Ohne Zoll-Nr.!'
   ENDIF

   SELECT Archiv

   SUM ilosc * cena_sprze , Waga TO SprzNrCelny, WagaNrCelny FOR m->Nr_Celny == Nr_Celny .AND. m->miesiac == MONTH(fakt_dat)
   ?  '     '+m->Nr_Celny + STR(SprzNrCelny,12,0)+ ' EUR'
   ?? STR(WagaNrCelny,12,0)+ ' kg'
   ? ''
   SELECT Temp4
   SKIP
   i++

ENDDO

SELECT Archiv

SUM ilosc * cena_sprze, Waga TO Sprzedaz, WagaCalk FOR m->miesiac == MONTH(fakt_dat)
?
SET COLOR TO &farb4

? ' Summe:          '+STR(Sprzedaz, 12,0)+ ' EUR '+ STR(WagaCalk,11,0)+' kg'

SET COLOR TO &farb1

SET PRINTER OFF
SET PRINTER TO
SET DEVICE TO SCREEN
SET CONSOLE ON

CLOSE DATABASES
DELETE FILE "Temp4.dbf"
RunShell( 'temp.txt', path4)

RETURN
