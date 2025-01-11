PROCEDURE dr_iczdr
#include "def.ch"
SET MARGIN TO 0
rahmen(.F.,.T.,.F.,.F.,.F.,.F.,'drukowanie czasow pracy')

m->lista     := SPACE(10)
m->p_numer   := 0
SumaCzasu    := 0
porzadek     := 1
SumaPauzy    := 0
CzasListy    := 0
CzasPauz     := 0
Zapis        := '    '

SET KEY -1 TO fakts2

@ 7,9    SAY "Numer listy..................." GET m->lista VALID JestLista(m->lista)
@ 9,9    SAY "Numer pracownika.............." GET m->p_numer PICTURE '999' VALID JestPracownik(m->p_numer)
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
CzasDnia   := 0
USE

SET PRINTER TO temp.txt
SET PRINTER ON
SET CONSOLE OFF
SET MARGIN TO 5

USE Archiv2 NEW
USE Operacje NEW
USE pracowni INDEX p_numer NEW
//USE rejestr  INDEX LPDGM   NEW

@ 0,0 CLEAR TO 24,79

DBSEEK(m->lista+STR(m->p_numer))

SELECT pracowni
SET INDEX TO p_numer

IF DBSEEK(p_numer)
   ?  ALLTRIM(nazwisko)+ ', '
   ?? imie
ELSE
   ?? nieodnalezione
ENDIF
? 'wykaz czasu pracy za miesiac :'+m->miesiac
? 'Numer listy                  : '+ALLTRIM(m->lista)
? m->notatka
? '                   godz.   pauzy   razem'
? ' L.P. Data         pracy   platne  czas    zapis nr'
? REPLICATE('_',73)

SELECT archiv2

DO WHILE p_numer == m->p_numer .AND. m->lista == lista .AND. .NOT. EOF()

   ? STR(porzadek,4,0)+'. '
   ?? DTOC(data)+'   '
   m->data := data

   DO WHILE m->data == data .AND. m->lista == lista .AND. m->p_numer == p_numer .AND..NOT. EOF()
      CzasDnia := CzasDnia+CzasOper
      zapis := zapis+ ALLTRIM(STR(lp)+',')
      SKIP
   ENDDO

   ?? ' '+STR(CzasDnia/60,6,2)

   IF CzasDnia > 345
      PlatnaPauza := 0.25
   ELSE
      PlatnaPauza  := 0
   ENDIF

   ?? '   '+STR(PlatnaPauza,4,2)
   ?? '   '+STR(CzasDnia/60+PlatnaPauza,5,2)
   ?? zapis
   SKIP

   m->data   := data
   CzasListy := CzasDnia+CzasListy
   CzasPauz  := CzasPauz+PlatnaPauza
   CzasDnia  := 0
   porzadek++

ENDDO

?
? '   Razem:           '
?? STR(CzasListy/60,6,2)+'  '
?? STR(CzasPauz,5,2)+'  '
?? STR(CzasListy/60+CzasPauz,6,2)

EJECT
SET CONSOLE ON
SET PRINTER OFF
SET PRINTER TO
CLOSE DATABASES
RunShell( "temp.txt", path4)
RETURN