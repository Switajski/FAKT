PROCEDURE dr_iczas
//#include "def.ch"
LOCAL SumaPauzy, SumaCzasu, CzasListy, CzasPauz, CzasDnia, Porzadek
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

USE Operacje NEW
USE pracowni INDEX p_numer NEW

COPY FILE archiv.dbf TO archiv2.dbf
USE archiv2 NEW
APPEND FROM rejestr
INDEX ON lista+STR(p_numer)+DTOC(data)+STR(GodzOd)+STR(GodzDo) TO l2
SET INDEX TO l2

DBSEEK(m->lista+STR(m->p_numer))

SELECT pracowni
SET INDEX TO p_numer

IF DBSEEK(p_numer)

//   SETCOLOR(farb4)
   ?  '      '+ALLTRIM(nazwisko)+ ', '
   ?? imie
//   SETCOLOR(farb1)

ELSE
   ?? '         nieodnalezione'
ENDIF
? '      wykaz czasu pracy za miesiac :'+m->miesiac
? ''
//? '      Numer listy                  : '+ALLTRIM(m->lista)
//? '      '+m->notatka
//? '                 godz.   '
? ' L.P. Data       godz pracy  '
?  REPLICATE('_',73)

SELECT archiv2

DO WHILE p_numer == m->p_numer .AND. m->lista == lista .AND. .NOT. EOF()

   ? STR(porzadek,4,0)+'. '
   ?? DTOC(data)+' '
   m->data := data

   DO WHILE m->data == data .AND. m->lista == lista .AND. m->p_numer == p_numer .AND..NOT. EOF()
      CzasDnia := CzasDnia+CzasOper
//      zapis := zapis+ ALLTRIM(STR(lp)+',')
      SKIP
   ENDDO

   ?? ' '+STR(CzasDnia/60,6,2)

//   ?? zapis
   SKIP

   m->data   := data
   CzasListy := CzasDnia+CzasListy
   CzasDnia  := 0
   porzadek++
//   IF porzadek == 20
//      SETCOLOR(farb4)
//      ? '         dalej z dowolnym klawiszem'
//      SETCOLOR(farb4)
//      INKEY(0)
//   ENDIF
ENDDO
SETCOLOR(farb4)
?
? '      Razem:    '
?? STR(CzasListy/60,6,2)+'  '
SETCOLOR(farb1)

SET PRINTER TO
SET PRINTER OFF
SET CONSOLE ON

RunShell( "temp.txt", path4)
CLOSE DATABASES
RETURN