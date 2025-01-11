PROCEDURE dr_Place
#include "def.ch"
LOCAL placa, SumaOperacji, porzadek, Ogolem
SET MARGIN TO 0
rahmen(.F.,.T.,.F.,.F.,.F.,.F.,'drukowanie listy plac')

m->lista     := SPACE(10)
placa        := 0
SumaOperacji := 0
porzadek     := 1
Ogolem       := 0

SET KEY -1 TO fakts2

@ 7,9    SAY "Numer listy..................." GET m->lista VALID JestLista(m->lista)
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

USE Lista NEW
SET INDEX TO lista

DBSEEK(m->lista)
m->miesiac := miesiac
m->notatka := notatka
USE

SET PRINTER TO temp.txt
SET PRINTER ON
SET CONSOLE OFF
SET MARGIN TO 5

USE Operacje NEW
USE pracowni INDEX p_numer NEW

USE archiv alias Arch NEW
COPY STRUCTURE TO archiv2
CLOSE Arch

//COPY FILE archiv.dbf TO archiv2.dbf
USE Archiv2 NEW
APPEND FROM Archiv
APPEND FROM Rejestr

? 'Lista Plac za miesiac :'+m->miesiac
? 'Numer listy           : '+ALLTRIM(m->lista)
? m->notatka
? '                                                    Akord '
? ' L.P.  Nr  Nazwisko            Imie                 Brutto'
? REPLICATE('_',74)

SELECT pracowni
GO TOP

DO WHILE .NOT. EOF()

   SELECT archiv2

   SUM CenaOperacji(wyrob,operacja)*ilosc TO SumaOperacji FOR p_numer == pracowni->numer.AND.Lista == m->Lista

   IF SumaOperacji > 0
       ? STR(porzadek,3,0)+'. '+STR(pracowni->numer,3,0)+'   '
      ?? pracowni->nazwisko + pracowni->imie
      ?? STR(SumaOperacji,7,2)
      porzadek++
      Ogolem := Ogolem + SumaOperacji
   ENDIF

   SELECT pracowni
   SKIP

ENDDO
? REPLICATE('_',79)
? '           Suma Ogolem                           '+STR(Ogolem,9,2)
SET PRINTER OFF
SET CONSOLE ON
SET PRINTER TO
SET MARGIN TO 0
CLOSE DATABASES
RunShell('temp.txt',path4)
RETURN