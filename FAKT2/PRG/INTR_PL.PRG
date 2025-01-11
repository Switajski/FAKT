// PROCEDURE intr_PL
@ 5,1 CLEAR TO 22,69

m->miesiac := MONTH(DATE())-1


SET KEY -1 TO fakts2


rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'drukowanie statystiki sprzedazy')

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
SET CONSOLE OFF
SET PRINTER ON

GO TOP

USE Archiv NEW
USE taric  NEW

SELECT Temp4

//WOPEN(5,5,22,70)
//CLEAR
//WBOX()

? '    Zestawienie Sprzedazy dla INTRASTAT PL za miesiac '+STR(m->miesiac,2,0)
?
? 'Poz. Nr Celny       Sprzedaz          Waga '
? ' _____________________________________________________'


i := 1

DO WHILE .NOT. EOF()


   m->Nr_Celny := Nr_Celny

   SELECT Taric
   LOCATE FOR Numer == m->Nr_Celny

   ? STR(i,3,0)+'. '

   IF FOUND()
      ?? ALLTRIM(Nazwa1)
   ELSE
      ?? 'brak opisu !'
   ENDIF

   SELECT Archiv

   SUM ilosc * cena_sprze * Kurs, Waga TO SprzNrCelny, WagaNrCelny FOR m->Nr_Celny == Nr_Celny .AND. m->miesiac == MONTH(fakt_dat)
   ?  '     '+m->Nr_Celny + STR(SprzNrCelny,12,0)+ ' zl'
   ?? STR(WagaNrCelny,12,0)+ ' kg'
   ? ''
   SELECT Temp4
   SKIP
   i++

ENDDO

SELECT Archiv

SUM ilosc * cena_sprze * Kurs, Waga TO Sprzedaz, WagaCalk FOR m->miesiac == MONTH(fakt_dat)
?
SET COLOR TO &farb4

? '       Suma:          '+STR(Sprzedaz, 12,0)+ ' zl '+ STR(WagaCalk,11,0)+' kg'

SET COLOR TO &farb1

INDEX ON Nr_Celny TO clo
SET FILTER TO m->miesiac == MONTH(fakt_dat)
SET INDEX TO clo

//COPY STRUCTURE TO test.dbf
//COPY TO Test
//USE Test
//DBEDIT()
SET PRINTER OFF
SET PRINTER TO
SET CONSOLE ON
SET DEVICE TO SCREEN

CLOSE DATABASES
DELETE FILE "temp4.dbf"
// RunShell( 'temp.txt', path4)


RETURN
