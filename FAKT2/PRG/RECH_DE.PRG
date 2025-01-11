PROCEDURE Rech_de
PRIVATE klient
#include  "def.ch"
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'Rachunek Niemiecki')

USE &path0
m->NumerRach := Rechnung
USE

m->fakt_num := 0
m->fakt_dat := DATE()
odstep := 64
odstep2:= 10

SET KEY -1 TO fakts2

@  8,10 SAY "Numer Wysylki........." GET m->fakt_num PICTURE '99999' VALID (m->fakt_num > 0)
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

USE Faktury INDEX fa_numer NEW

IF .NOT. DBSEEK(m->fakt_num)
   ALERT('Nieznana Wysylka')
   CLOSE DATABASES
   RETURN
ELSE
//   ALERT('Wysylka Odnaleziona, Klient Nr:'+STR(Kli_Numer,2,0))
   m->Kli_Numer := Kli_Numer
ENDIF


m->fakt_dat   := DATE()
m->Dostawa    := DATE()
m->Steuer     := 19
m->Zahlung    := SPACE(76)

klient := KL_Such(m->Kli_Numer)
@ 10,10 SAY "Kunde.................:"+ klient  //ALLTRIM(STR(m->Kli_Numer,5,0))  //" GET m->kli_numer PICTURE '9999'
@ 12,10 SAY "Rechnungsnummer......." GET m->NumerRach
@ 14,10 SAY "Rechnungsdatum........" GET m->fakt_dat
@ 16,10 SAY "Liefertermin.........." GET m->Dostawa
@ 18,10 SAY "Umsatzsteuer %........" GET m->Steuer PICTURE'99.99%'
@ 20,10 SAY "Zahlungsbedinungen...."
@ 21,1  GET m->Zahlung

READ

IF LASTKEY() == 27
   CLOSE DATABASES
   RETURN
ENDIF


//USE Artykuly               NEW
USE Klienci
// INDEX KL_Numer NEW

LOCATE FOR m->kli_numer == kli_numer
IF .NOT. FOUND()
//IF .NOT. DBSEEK(m->kli_numer)
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

DO Matryca2

USE Faktury
USE temp2 NEW
GO TOP

SET CONSOLE OFF
SET PRINTER TO 'temp.txt'
SET DEVICE  TO PRINTER
SET PRINTER ON


?  SPACE(odstep2)+m->Kli_Nazwa1
?  SPACE(odstep2)+m->Kli_Nazwa2
?  SPACE(odstep2)+m->Kli_Ulica
?  SPACE(odstep2)
?  SPACE(odstep2)+ALLTRIM(m->Kli_PLZ)+' '+Kli_Ort
?  SPACE(odstep2)+m->Kli_Panstw

IF m->Steuer == 0
   ? SPACE(odstep2)+'UST-ID Nr.:'+Kli_ZNR
ENDIF



?  SPACE(odstep)+'Rechnung Nummer: '
?? alltrim(str(m->NumerRach,5,0))
?  SPACE(odstep)+'Rechnungsdatum : '+DTOC(m->fakt_dat)
?  SPACE(odstep)+'Lieferdatum    : '+DTOC(m->Dostawa)

?
?
? 'Pos. Art.Nr.     Bezeichnung                                             Menge        Preis  Betrag'
? '                                                                                       EUR    EUR'
? '_____________________________________________________________________________________________________'
?


GO TOP
Licznik := 1
Razem   := 0

DO WHILE .NOT. EOF()

   ?  STR(licznik,3,0)+'. '
   m->art_nr := art_nr
   ?? art_nr
   ?? '  '+Bezeichn1
   IF .NOT. EMPTY(Bezeichn2)
      ? SPACE(17)+Bezeichn2
   ENDIF

   IF .NOT.EMPTY(Bezeichn3)
      ? SPACE(17)+Bezeichn3
   ENDIF


   SELECT Faktury
   SUM ilosc TO C_Ilosc FOR m->art_nr == art_nr .AND. m->fakt_num == fakt_num


   SELECT temp2

   ?? STR(c_ilosc,10,2)
   ?? ' '+temp2->einheit
   ?? STR(cena_klien,10,2)

   WartArt := cena_klien*c_ilosc
   ?? STR(WartArt,10,2)

   Razem := Razem + WartArt

   SKIP
   Licznik++
   ?
ENDDO

? SPACE(odstep)+'_____________________________________'

? SPACE(odstep)+'Gesamtbetrag Netto  EUR :  '+STR(Razem,10,2)

IF m->Steuer > 0
   ? SPACE(odstep)+'Umsatzsteuer '+ STR(m->Steuer,5,2)+'% EUR :  '+STR((m->Steuer* Razem /100),10,2)
   ? ''
   ? SPACE(odstep)+'Gesamtbetrag Brutto EUR :  '+ STR(Razem * (Steuer/100+1),10,2)
ELSE
   ?
   ?   SPACE(odstep)
   ?? 'In Deutschland umsatzsteuerfrei'
   ?   SPACE(odstep)
   ?? 'Par. 4 Nr. 1b i.V.m. Par. 6a UStG)'

ENDIF

IF .NOT. EMPTY(m->Zahlung)
?
?? m->Zahlung
ENDIF

SET PRINTER TO
SET DEVICE TO SCREEN
SET PRINTER OFF
CLOSE DATABASES
SET CONSOLE ON

DELETE FILE "temp2.dbf"
RunShell( 'temp.txt', path4)

RETURN


********* Kopiowanie danych o wysylce do TEMP.dbf *****************************

PROCEDURE Matryca2

USE Faktury

COPY STRUCTURE TO 'temp2.dbf'
INDEX ON Art_Nr TO Art_Nr
SET INDEX TO Art_Nr

COPY TO temp2 FOR m->Fakt_Num == Fakt_Num
USE

USE temp2 NEW
GO TOP

m->Art_Nr := Art_Nr
SKIP

// usunac powtarzajace sie numery artykulow

DO WHILE .NOT. EOF()
   IF m->Art_Nr == Art_Nr
      DELETE
   ENDIF
   m->Art_Nr := Art_Nr
   SKIP
ENDDO

USE FAKTURY NEW

DO WHILE .NOT. EOF()

   SELECT faktury
   SUM ilosc                TO art_ilosc    FOR faktury->art_nr == temp2->art_nr .AND. m->fakt_num == fakt_num
   SUM ilosc * Cena_Klien   TO poz_wartosc  FOR faktury->art_nr == temp2->art_nr .AND. m->fakt_num == fakt_num
   SUM waga                 TO poz_waga     FOR faktury->art_nr == temp2->art_nr .AND. m->fakt_num == fakt_num
   SUM objetosc             TO poz_objetosc FOR faktury->art_nr == temp2->art_nr .AND. m->fakt_num == fakt_num


   SELECT temp2

   REPLACE ilosc    WITH art_ilosc
   REPLACE wartosc  WITH poz_wartosc
   REPLACE waga     WITH poz_waga
   REPLACE objetosc WITH poz_objetosc
   SKIP

ENDDO
CLOSE DATABASES

USE &path0   //Standart
REPLACE Rechnung WITH m->NumerRach

USE Faktury
DO WHILE .NOT. EOF()
   IF fakt_num == m->fakt_num
      REPLACE Rechnung WITH m->NumerRach
   ENDIF
   SKIP
ENDDO
USE
RETURN

FUNCTION Kl_Such(klient)
PRIVATE AltSelect, odp
AltSelect := SELECT()
USE Klienci INDEX Kl_Numer NEW
IF DBSEEK(klient)
   odp := ALLTRIM(Kli_Nazwa1)+' '+ALLTRIM(Kli_Nazwa2)
ELSE
   odp := 'Nieznany'
ENDIF
CLOSE Klienci
SELECT(AltSelect)
RETURN odp