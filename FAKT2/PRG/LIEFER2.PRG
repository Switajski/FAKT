PROCEDURE Liefer2
#include  "def.ch"
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'zestawienie niemieckie')


USE Faktury
GO BOTTOM
m->fakt_num := 0
m->fakt_dat := DATE()
USE

SET KEY -1 TO fakts2

@  8,20 SAY "Numer Wysylki........." GET m->fakt_num PICTURE '99999' //VALID (m->fakt_num > 0)
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

USE Artykuly               NEW
USE Klienci INDEX KL_Numer NEW
USE Faktury                NEW
SET INDEX TO Fa_Numer

IF .NOT. DBSEEK(m->fakt_num)
   ALERT('Nieznana Wysylka')
   CLOSE DATABASES
   RETURN
ENDIF

CLOSE DATABASES

DO Matryca3

USE Faktury
PRIVATE SumaPoz, SumaOg
SumaPoz := 0
SumaOg  := 0

USE temp3 NEW
GO TOP

//dbfDatei := m->pfad+'\DOKUMENT\DE\Liefersc\Lief'+ALLTRIM(STR(m->fakt_num,4,0))+'.dbf'

SET CONSOLE OFF
SET MARGIN TO 0
SET DEVICE  TO PRINTER
SET PRINTER TO 'temp.txt'

SET PRINTER ON


?? 'Lieferschein Nr.: '+ALLTRIM(STR(m->Fakt_Num,6,0))
?
? ' LN  Bestel/Pos     Art.Nr.     Bezeichnung                                          Menge   Preis    Wert'
? '__________________________________________________________________________________________________________'
?

Licznik := 1

DO WHILE .NOT. EOF()

   ?  STR(licznik,3,0)+'. '

   ?? LEFT(ALLTRIM(Zamowienie)+'/'+ALLTRIM(STR(Zam_Poz,2,0))+SPACE(50),13)
   ?? '  '+art_nr + '  '
   ?? Bezeichn1

   IF .NOT. EMPTY(Bezeichn2)
      ? SPACE(32)+Bezeichn2
   ENDIF

   IF .NOT.EMPTY(Bezeichn3)
      ? SPACE(32)+Bezeichn3
   ENDIF

   ??  STR(Ilosc,8,2)
   ??  STR(Cena_Klien,8,2)

       SumaPoz := ROUND(Cena_Klien * Ilosc,2)
   ??  STR(SumaPoz,8,2)

       SumaOg  := SumaPoz + SumaOg
       SumaPoz := 0

   SKIP
   licznik++
   ?
ENDDO

?
? SPACE(88)+'__________________'
? '                                              Gesamt Warenpreis Netto EUR:'+SPACE(24)+STR(SumaOg,8,2)

SET PRINTER OFF
SET PRINTER TO
SET DEVICE TO SCREEN
SET CONSOLE ON

CLOSE DATABASES

// RunShell( 'temp.txt', path4)
ZestawD (m->fakt_num)

//USE temp3
//COPY FIELDS zamowienie, zam_poz, art_nr, ilosc to &dbfDatei
//USE
//USE &dbfDatei

RETURN


********* Kopiowanie danych o wysylce do TEMP.dbf *****************************

PROCEDURE Matryca3

USE Faktury

COPY STRUCTURE TO 'temp3.dbf'
INDEX ON Zamowienie+STR(zam_poz,4,0)+Art_nr TO bestell
SET INDEX TO bestell

COPY TO temp3 FOR m->Fakt_Num == Fakt_Num
USE

USE temp3 NEW
GO TOP

// usunac powtarzajace sie numery artykulow w tym samym zamowieniu


m->Zamowienie := Zamowienie
m->Zam_Poz    := Zam_Poz
m->Art_Nr     := Art_Nr

SKIP

DO WHILE .NOT. EOF()

   IF m->Zamowienie == Zamowienie .AND. m->Zam_Poz == Zam_Poz .AND. m->Art_Nr == Art_Nr
      DELETE
   ENDIF

   m->Zamowienie := Zamowienie
   m->Zam_Poz    := Zam_Poz
   m->Art_Nr     := Art_Nr

   SKIP

ENDDO
//PACK

GO TOP

USE FAKTURY NEW


DO WHILE .NOT. EOF()

   SELECT faktury
   SUM ilosc TO art_ilosc FOR temp3->Zamowienie == zamowienie .AND. temp3->art_nr == art_nr .AND. temp3->fakt_num == fakt_num .AND. temp3->zam_poz == zam_poz

   SELECT temp3

   REPLACE ilosc    WITH art_ilosc
   Art_Ilosc := 0

   SKIP

   m->Art_Nr     := Art_Nr
   m->Zamowienie := Zamowienie
   m->Zam_Poz    := Zam_Poz

ENDDO
CLOSE DATABASES
//RunShell( 'temp.txt', path4)
DELETE FILE 'temp3.dbf'
RETURN