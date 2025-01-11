PROCEDURE dr_czasy
#include "def.ch"
SET MARGIN TO 0
SETFUNCTION(9,CHR(27))
rahmen(.F.,.T.,.F.,.F.,.F.,.F.,'drukowanie czasow pracy')

wybor := 1

@  8,9    SAY "Czasy indywidualne drukarka.....  (1)"
@ 10,9    SAY "Zbiorcza lista czasow drukarka..  (2)"
@ 12,9    SAY "wybor...........................  " GET wybor PICTURE '9' RANGE 1,4
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

DO CASE

   CASE wybor == 1
      DO czas2
   CASE wybor == 2
      DO czas3
ENDCASE
SETFUNCTION(9,'')
RETURN