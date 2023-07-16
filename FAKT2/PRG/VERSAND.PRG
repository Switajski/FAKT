PROCEDURE Versand 
#include  "def.ch" 
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wprowadzanie danych o sprzedazy') 
 
USE Klienci INDEX KL_Numer NEW 
USE Faktury NEW
 
GO BOTTOM 

m->fakt_num := fakt_num 
m->fakt_dat := DATE() 
SET KEY -1 TO fakts2 

********************** NAGLOWEK *********************************  

@  8,20 SAY "Numer Wysylki........." GET m->fakt_num PICTURE '9999' 
READ
IF LASTKEY() == 27
   USE
   RETURN 
ENDIF 
 
SET INDEX TO fa_numer 
 
IF .NOT. DBSEEK(m->fakt_num) 
   ALERT('Nieznana Wysylka') 
   CLOSE DATABASES 
   RETURN 
ELSE 
   ALERT('Wysylka Odnaleziona' ) 
 
ENDIF 
 
 
datei    := m->pfad+'\DOKUMENT\LIF'+ALLTRIM(STR(m->fakt_num,4,0))+'.txt'
dbfDatei := m->pfad+'\DOKUMENT\LIF'+ALLTRIM(STR(m->fakt_num,4,0))+'.dbf'  

 



************ wydanie danych w formacie dbf ************************

COPY STRUCTURE      FIELDS 'Art_nr','Ilosc','zamowienie','Zam_Poz','Karton','KW' TO &dbfDatei
CLOSE DATABASES
USE FAKTURY
INDEX ON zamowienie+STR(zam_poz)+Art_Nr TO Ausgabe
SET INDEX TO Ausgabe

APPEND FROM faktury FIELDS 'Art_Nr','Ilosc','zamowienie','Zam_Poz','Karton','KW' FOR m->fakt_num == fakt_num

COPY FIELDS 'zamowienie','Zam_Poz','Art_Nr','Ilosc','Karton','KW' TO &dbfDatei FOR m->fakt_num == fakt_num

USE
USE &dbfDatei


////////////////////////////////
SET PRINTER TO &datei 
SET DEVICE  TO PRINTER 
SET PRINTER ON 
SET CONSOLE OFF 
 
 
?  'Lieferschein zum Versand Nr.: ' 
?? alltrim(str(m->fakt_num,4,0)) 
?? ' vom '+DTOC(fakt_dat)
? 
? 'Pos.  Bestellung   Artikelnummer     Menge   KW  ' 
? '__________________________________________________________________'
 
GO TOP 
 
licznik   := 1

DO WHILE .NOT. EOF()

   m->Zamowienie := zamowienie

   ?  STR(Licznik,4,0)+'.   '
   ?? Zamowienie + '  '
   ?? Art_Nr+ '   '
   ?? STR(Ilosc,8,2)+'   '
   ?? STR(KW,2,0)

   SKIP
   licznik++
   IF zamowienie <> m->zamowienie
      ? '______________________________________________________________'
   ENDIF 

ENDDO 


////////////////////////////////

 
SET PRINTER TO
SET DEVICE TO SCREEN 
SET PRINTER OFF   
CLOSE DATABASES 
SET CONSOLE ON


RETURN