PROCEDURE Rach_Zb
#include "def.ch"
PUBLIC Razem, Zalacznik
PUBLIC fakt_num, Rach_Nr, Fakt_Dat, Dostawa, Kli_Numer

USE &path0   //standart

//m->Rach_Nr := Rachunek
USE

rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'Rachunek Polski')

************* wbudowane ******************************************

USE Faktury
GO BOTTOM
m->fakt_num := fakt_num
m->fakt_dat := DATE()
USE


SET KEY -1 TO fakts2

@  8,20 SAY "Numer Wysylki........." GET m->fakt_num PICTURE '99999' VALID (m->fakt_num > 0)
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

USE FAKTURY INDEX Fa_Numer NEW

IF .NOT. DBSEEK(m->fakt_num)
   ALERT('Nieznana Wysylka')
   CLOSE DATABASES
   RETURN
ELSE
   ALERT('Numer klienta  :'+STR(Kli_Numer,5,0))
   m->Kli_Numer:= Kli_Numer
ENDIF

m->kli_numer  := Kli_Numer
m->Rach_Nr    := m->fakt_num
m->fakt_dat   := DATE()
m->dostawa    := DATE()
m->przelicznik:= 0
Zalacznik  := "N"
m->nowy       := "T"

@ 10,20 SAY "Numer klienta........." GET m->kli_numer PICTURE '9999'
@ 12,20 SAY "Numer Rachunku........" GET m->Rach_Nr
@ 14,20 SAY "Data Rachunku........." GET m->fakt_dat
@ 16,20 SAY "Data Dostawy.........." GET m->dostawa
@ 18,20 SAY "Przelicznik PLN/EUR..." GET m->Przelicznik PICTURE'99.9999'
@ 20,20 SAY "Faktor kalkulacyjny..." GET m->Faktor PICTURE '9.99'
@ 22,20 SAY "Drukuj Zalacznik (T/N)" GET Zalacznik

READ

IF LASTKEY() == 27
   CLOSE DATABASES
   RETURN
ENDIF

USE Klienci

LOCATE FOR m->kli_numer == kli_numer
IF .NOT. FOUND()
   ALERT('Klient nie zostal odnaleziony')
   CLOSE DATABASES
   RETURN
ELSE

m->Kli_Numer := Kli_Numer
m->Kli_Nazwa1:= Kli_Nazwa1
m->Kli_Nazwa2:= Kli_Nazwa2
m->Kli_Ulica := Kli_Ulica
m->Kli_Plz   := Kli_PLZ
m->Kli_Ort   := Kli_Ort
m->Kli_ZNR   := Kli_ZNR
m->Kli_Panstw:= Kli_Panstw


ENDIF

CLOSE DATABASES

DO Matryca

USE Faktury
USE temp NEW
GO TOP

SET CONSOLE OFF
SET PRINTER TO tempz.txt
SET DEVICE  TO PRINTER
SET PRINTER ON

?  'Rachunek Numer: '
?? alltrim(str(m->Rach_Nr,5,0))
?  'Data rachunku : '+DTOC(m->fakt_dat)
//?
//?  'Numer wysylki : '+ALLTRIM(STR(m->fakt_num,5,0))
?  'Data wysylki  : '+DTOC(m->dostawa)
?  ''

?  'Sprzedajacy   : '
?  firma1+'  '+  firma2+'- '+firma3
?  'NIP:   '+NIP
?? '   REGON: '+REGON
//?  konto1+konto2
?  'IBAN: '+iban+'  BIC(SWIFT): '+BIC
?
?  'Kupujacy      : '
?   ALLTRIM(m->Kli_Nazwa1)+' '
??  ALLTRIM(m->Kli_Nazwa2)
?   ALLTRIM(m->Kli_Ulica) + ', '
??  ALLTRIM(m->Kli_PLZ)+' '+ALLTRIM(Kli_Ort)+', '+ ALLTRIM(m->Kli_Panstw)
?  'Numer Identyfikacyjny EU :'+m->Kli_ZNR
?
?  zaplata
?  transport
?
? 'Poz. Art.Nr.   Nazwa Artykulu                                        Ilosc       Cena   Wartosc'
? '_______________________________________________________________________________________________'
?


GO TOP
Licznik := 1
Razem   := 0

DO WHILE .NOT. EOF()

   ?  STR(licznik,3,0)+'. '
   m->art_nr := art_nr
   ?? art_nr
   ?? Nazwa1
   IF .NOT. EMPTY(Nazwa2)
      ? SPACE(15)+Nazwa2
   ENDIF

   IF .NOT.EMPTY(Nazwa3)
      ? SPACE(15)+Nazwa3
   ENDIF


   SELECT Faktury
   SUM ilosc TO C_Ilosc FOR m->art_nr == art_nr .AND. m->fakt_num == fakt_num


   SELECT TEMP

   m->cena_sprze := ROUND(cena_klien * m->faktor,2)
   ?? STR(c_ilosc,10,2)
   ?? STR(m->cena_sprze,10,2)

   WartArt := m->cena_sprze * c_ilosc
   ?? STR(WartArt,10,2)

   Razem := Razem + WartArt

   SKIP
   Licznik++
   ?
ENDDO

? '_______________________________________________________________________________________________'
?
? '                                                          Razem Wartosc Rachunku EUR:'+STR(Razem,10,2)
? ' '
? 'Kurs PLN/EUR                                                                             '+ STR(m->przelicznik,6,4)
? 'Wartosc Rachunku w PLN                                                               '+ STR(m->przelicznik*Razem,10,2)
?
?  'W Polsce faktura bez podatku VAT (sprzedaz wewnatrzwspolnotowa).'
?  'Odbiorca towaru o numerze identyfikacyjnym '+ALLTRIM(m->Kli_ZNR)+' jest zobowiazany'
?  'do rozliczenia VAT-u w kraju w ktorym ma siedzibe.'

SET PRINTER TO
SET DEVICE TO SCREEN
SET PRINTER OFF
CLOSE DATABASES

IF m->nowy == "T"
   USE &path0
   GO TOP
   REPLACE Rachunek WITH Rach_Nr
   USE
ENDIF

USE Faktury

GO TOP

DO WHILE .NOT. EOF()
   IF fakt_num == m->fakt_num
      REPLACE Kurs       WITH m->Przelicznik
      REPLACE fakt_dat   WITH m->fakt_dat
      REPLACE dostawa    WITH m->dostawa
      REPLACE rachunek   WITH m->rach_nr
      REPLACE cena_sprze WITH ROUND(cena_klien * m->faktor,2)
   ENDIF
   SKIP
ENDDO

SET CONSOLE ON

DELETE FILE "Temp.dbf"
RunShell( 'tempz.txt', path4)

RETURN


********* Kopiowanie danych o wysylce do TEMP.dbf *****************************

PROCEDURE Matryca

USE Faktury

COPY STRUCTURE TO 'temp.dbf'
INDEX ON art_Nr TO Art_Nr
SET INDEX TO art_Nr

COPY TO temp FOR m->Fakt_Num == Fakt_Num
USE

USE temp NEW

GO TOP

m->art_nr := art_nr

SKIP

DO WHILE .NOT. EOF()
   IF m->art_Nr == art_Nr
      DELETE
   ENDIF
   m->art_Nr := art_Nr
   SKIP
ENDDO

GO TOP


USE FAKTURY NEW

DO WHILE .NOT. EOF()

   SELECT faktury
   SUM ilosc                TO art_ilosc    FOR faktury->art_nr == temp->art_nr .AND. m->fakt_num == fakt_num
   SUM ilosc * Cena_Klien   TO poz_wartosc  FOR faktury->art_nr == temp->art_nr .AND. m->fakt_num == fakt_num
   SUM waga                 TO poz_waga     FOR faktury->art_nr == temp->art_nr .AND. m->fakt_num == fakt_num
   SUM objetosc             TO poz_objetosc FOR faktury->art_nr == temp->art_nr .AND. m->fakt_num == fakt_num


   SELECT temp

   REPLACE ilosc    WITH art_ilosc
   REPLACE wartosc  WITH (poz_wartosc * m->faktor)
   REPLACE waga     WITH poz_waga
   REPLACE objetosc WITH poz_objetosc
   SKIP

ENDDO
CLOSE DATABASES
//DELETE FILE "temp.dbf"

RETURN