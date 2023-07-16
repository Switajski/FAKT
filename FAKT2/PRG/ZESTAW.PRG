PROCEDURE zestaw
#include  "def.ch"
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wprowadzanie danych o sprzedazy')

//dbfDatei := m->pfad+'\DOKUMENT\PL\Specyfik\W'+ALLTRIM(STR(m->fakt_num,4,0))+'.dbf'

SET PRINTER TO 'temp.txt'
SET DEVICE  TO PRINTER
SET PRINTER ON
SET CONSOLE OFF

?  'Zestawienie do wysylki nr '
?? alltrim(str(m->fakt_num,5,0))

?  'Data Wysylki: '+DTOC(m->dostawa)

?
?  'Numer rachunku: '+ALLTRIM(STR(m->Rach_Nr,5,0))
?  'z dnia : '+DTOC(m->fakt_dat)
?
? 'poz. art.nr.   nazwa                                                      ilosc  zam/poz  opak.  KW'
? '___________________________________________________________________________________________________'

USE Faktury
SET FILTER TO m->fakt_num == fakt_num
//SET INDEX TO fakt_poz
INDEX ON karton TO karton
GO TOP

DO WHILE .NOT. EOF()

   m->karton := karton

   ?  STR(poz,3,0)+'. '
   ?? art_nr
   ?? LEFT(ALLTRIM(nazwa1)+' '+ALLTRIM(nazwa2)+' '+ALLTRIM(nazwa3)+SPACE(70),58)
   ?? STR(ilosc,6,2)
//   ?? SPACE(5)
   ?? LEFT('  '+ALLTRIM(zamowienie)+'/'+ALLTRIM(STR(poz,3,0))+SPACE(20),10)
   ?? STR(karton,5,0)
   ?? STR(KW,5,0)
   SKIP

   IF m->karton <> karton
      ? '___________________________________________________________________________________________________'
   ENDIF

ENDDO
SET FILTER TO
SET INDEX TO

SET PRINTER TO
SET DEVICE TO SCREEN
SET PRINTER OFF
CLOSE DATABASES
SET CONSOLE OFF
RunShell( 'temp.txt', path4)

RETURN