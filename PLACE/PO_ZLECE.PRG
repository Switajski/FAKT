PROCEDURE po_zlece
#include "def.ch"

rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'rozliczenie zlecenia')
rodzaj := 'M'

@ 7,9 SAY "Rozliczenie zlecenia - (M)onitor lub (D)rukarka" GET rodzaj VALID UPPER(rodzaj) == 'M'.OR. UPPER(rodzaj) =='D'
READ

IF LASTKEY() == 27
   RETURN
ENDIF

IF rodzaj == 'M'
   DO mo_zlece
ELSE
   DO dr_zlece
ENDIF

RETURN
