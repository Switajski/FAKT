PROCEDURE Koszty
#include "def.ch"
DO OperAkord
DO Rozdzial
RETURN

PROCEDURE OperAkord
PRIVATE OdDnia, DoDnia

@ 5,2 CLEAR TO 22,78

OdDnia := DATE()
DoDnia := DATE()

@ 5,15 SAY 'Koszty za okres od:'GET OdDnia
@ 5,45 SAY 'do' GET DoDnia
READ
IF LASTKEY() == 27
   RETURN
ENDIF

RAHMEN(.F.,.F.,.F.,.F.,.F.,.F.,'koszty '+  DTOC(OdDnia) + ' - '+ DTOC(DoDnia))

//WOPEN(5,2,22,78,.T.)

USE archiv
COPY STRUCTURE TO Temp
USE TEMP
APPEND FROM ARCHIV  FOR data >= OdDnia .AND. data <= DoDnia
APPEND FROM rejestr FOR data >= OdDnia .AND. data <= DoDnia
USE


USE TEMP NEW
USE operacje NEW
GO TOP

DO WHILE .NOT. EOF()

   SELECT operacje

   m->wyrob    := wyrob_nr
   m->operacja := numer
   m->czas     := czas
   m->stawka   := stawka

   ?  wyrob_Nr
   ?? numer

   pozycja := 0

   SELECT TEMP
   SUM m->czas/60 * m->stawka * ilosc TO pozycja FOR m->wyrob == wyrob .AND. m->operacja == operacja
   m->ilosc := ilosc

   ?? m->ilosc

   SELECT operacje

   ?? pozycja

   REPLACE place    WITH pozycja
   REPLACE na_ilosc WITH m->ilosc
   IF EMPTY(koszty)
      REPLACE koszty WITH "AP"
   ENDIF

   SKIP

ENDDO

CLOSE DATABASES
DELETE FILE "temp.dbf"
RETURN

PROCEDURE Rozdzial
USE operacje NEW
USE koszty INDEX Koszty NEW
REINDEX
suma := 0
CLEAR
GO TOP
DO WHILE .NOT. EOF()


   m->koszty    := koszty
   m->miejsce   := miejsce

   ?  '              '+m->miejsce


   pozycja := 0

   SELECT Operacje
   SUM place TO pozycja FOR m->koszty == koszty
   ?? pozycja
   SELECT koszty

   suma := suma+pozycja


   SKIP

ENDDO

CLOSE DATABASES

? '              -------------------------------------------'
? '              Suma:                     '+STR(suma,12,2)
INKEY(0)

RETURN