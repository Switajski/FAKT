PROCEDURE Liefer 
#include  "def.ch" 
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'Lieferschein') 
 
USE Klienci INDEX KL_Numer NEW 
USE Faktury NEW
 
GO BOTTOM 

m->fakt_num := fakt_num+1 
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
 
********************** DANE DLA NAGLOWKA PRZY NOWEJ WYSYLCE ********* 
IF .NOT. DBSEEK(m->fakt_num) 
   ALERT('Nieznana Wysylka') 
   CLOSE DATABASES 
   RETURN  
ENDIF 
 
 
datei    := m->pfad+'\DOKUMENT\L1'+ALLTRIM(STR(m->fakt_num,4,0))+'.txt'

 
SET PRINTER TO &datei 
SET DEVICE  TO PRINTER 
SET PRINTER ON 
 
 
 
?  'Lieferschein Nr.: ' 
?? alltrim(str(m->fakt_num,4,0)) 
?  'Datum:            '+DTOC(fakt_dat)
? 
? 'Pos. ArtNr.         Menge        Bestellung  Verp.  KW' 
? '__________________________________________________________________'
 
GO TOP 
SET FILTER TO m->fakt_num == fakt_num
SET INDEX TO fakt_poz 


DO WHILE .NOT. EOF()
   m->zamowienie := zamowienie

   ?  STR(poz,3,0)+'. '
   ?? art_nr 
   ?? STR(ilosc,10,3) 
   ?? SPACE(5) 
   ?? LEFT('   '+ALLTRIM(zamowienie)+'/'+ALLTRIM(STR(poz,3,0))+SPACE(20),14) 
   ?? STR(karton,5,0) 
   ?? STR(KW,5,0) 
   SKIP 
   IF zamowienie <> m->zamowienie
      ? '_______________________________________________________________'
   ENDIF

ENDDO 
SET FILTER TO 
SET INDEX TO 


 
SET PRINTER TO
SET DEVICE TO SCREEN 
SET PRINTER OFF   
CLOSE DATABASES 



RETURN