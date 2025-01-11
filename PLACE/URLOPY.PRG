PROCEDURE urlopy

USE URLOPY NEW
GO BOTTOM

m->p_numer     := 0
m->data_urlop  := DATE()
m->lista       := lista
m->rodzaj      := "U"
SETFUNCTION(9,CHR(27))
SETFUNCTION(10,CHR(23))

DO WHILE .T.

   @ 5,1 CLEAR TO 22,69
   SET KEY -1 TO fakts2

   rahmen(.T.,.F.,.F.,.T.,.T.,.F.,'rejestracja urlopow')


   @  6,5    SAY "Numer listy        " GET m->lista
   @  8,5    SAY "Numer pracownika   " GET m->p_numer PICTURE "999"
   @ 10,5    SAY "Data dnia wolnego  " GET m->data_urlop
   @ 12,5    SAY "(U)rlop,(C)horoba  " GET m->rodzaj
   READ

   IF LASTKEY() == 27
      EXIT
   ENDIF

   LOCATE FOR m->lista == lista .AND. m->p_numer == p_numer .AND. m->data_urlop == data_urlop
   IF FOUND()
      IF ALERT("Zapis ju¾ istnieje", {"wr¢†","usuä"}) == 2
         DELETE
         PACK
      ENDIF
      LOOP
   ELSE
      APPEND BLANK
   ENDIF

   REPLACE lista       WITH m->lista
   REPLACE p_numer     WITH m->p_numer
   REPLACE data_urlop  WITH m->data_urlop
   REPLACE Rodzaj      WITH m->rodzaj

ENDDO
SETFUNCTION(9,'')
SETFUNCTION(10,'')
CLOSE DATABASES
RETURN