// Function zestawD
#include  "def.ch"
PARAMETER wysylka
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wprowadzanie danych o sprzedazy')

//dbfDatei := m->pfad+'\DOKUMENT\PL\Specyfik\W'+ALLTRIM(STR(m->fakt_num,4,0))+'.dbf'

SET PRINTER TO 'temp.txt'
SET DEVICE  TO PRINTER
SET PRINTER ON
SET CONSOLE OFF


?? 'Packliste Nr.: '
?? wysylka

? 'Pos.  Art. Nr.       Menge      Bestel./Pos.  Verpackung Nr Versand'
? '___________________________________________________________________'

USE Faktury
SET FILTER TO wysylka == fakt_num
SET INDEX TO fakt_poz
GO TOP

DO WHILE .NOT. EOF()

   m->karton := karton

   ?  STR(poz,3,0)+'. '
   ?? art_nr
   ?? STR(ilosc,10,3)
   ?? SPACE(5)
   ?? LEFT('   '+ALLTRIM(zamowienie)+'/'+ALLTRIM(STR(poz,3,0))+SPACE(20),14)
   ?? STR(karton,5,0)
   ?? '       '+GLSNumer
   SKIP

   IF m->karton <> karton
      ? '___________________________________________________________________'
   ENDIF

ENDDO
SET FILTER TO
SET INDEX TO

SET PRINTER TO
SET DEVICE TO SCREEN
SET PRINTER OFF
CLOSE DATABASES
SET CONSOLE OFF
// RunShell( 'temp.txt', path4)

RETURN NIL