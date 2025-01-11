PROCEDURE grupy_op

@ 5,1 CLEAR TO 22,69
USE grupy INDEX grupy_nr
GO BOTTOM

m->numer := numer+1

SET KEY -1 TO fakts2

rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wprowadzanie danych o grupach')

@ 7,20 SAY "Numer grupy......" GET m->grupa_nr PICTURE '0'
READ
IF LASTKEY() == 27
   USE
   RETURN
ENDIF
SET KEY -7 TO GrUsun

rahmen(.F.,.F.,.F.,.T.,.T.,.T.,'wprowadzanie danych o wyrobach')

@ 7,20 SAY 'Numer wyrobu:      ' + ALLTRIM(STR(m->numer,5,0) )

IF DBSEEK(m->numer) //FOUND()

   SET KEY -7 TO WyrUsun
   m->numer_wy  := numer_wy
   m->nazwa_wy  := wyrob
   m->oper_nr   := oper_nr
   m->oper_cza  := oper_cza
   m->oper_gru  := oper_gru
   NowyWyrob    := .F.

ELSE

   m->numer_wy  := SPACE(4)
   m->nazwa_wy  := SPACE(40)
   m->oper_nr   := SPACE(3)
   m->oper_cza  := 0
   m->oper_gru  := oper_gru
   NowyWyrob    := .T.

ENDIF

SET FUNCTION 10 TO CHR(23)
abbruch := .F.

DO WHILE .NOT. abbruch

   @  9,2   SAY 'numer wyrobu    ' GET m->numer_wy
   @ 10,2   SAY 'nazwa wyrobu    ' GET m->nazwa_wy
   @ 11,2   SAY 'numer operacji  ' GET m->oper_nr
   @ 10,2   SAY 'nazwa operacji  ' GET m->nazwa_wy
   @ 13,2   SAY 'czas jednostkowy' GET m->oper_cza PICTURE '99999.99'
   @ 14,2   SAY 'grupa operacji  ' GET m->oper_gru PICTURE '1'

READ

lk := LASTKEY()
   DO CASE
      CASE lk == 27
	 CLOSE DATABASES
	 RETURN
      CASE lk == 23
	 EXIT
   ENDCASE

ENDDO

IF .NOT. abbruch

   IF NowyWyrob
      APPEND BLANK
   ENDIF

   REPLACE numer_wy   WITH m->numer_wy
   REPLACE nazwa_wy   WITH m->nazwa_wy
   REPLACE oper_nr    WITH m->oper_nr
   REPLACE oper_cza   WITH m->oper_cza
   REPLACE oper_gr    WITH m->oper_gr
ENDIF

CLOSE DATABASES
SET KEY -7 TO
RETURN

PROCEDURE GrUsun
IF .NOT. EOF()
   IF ALERT('Grupe '+ ALLTRIM(nazwa1)+' '+ALLTRIM(nazwa2)+' '+ALLTRIM(nazwa3) +' usunac ?',{'tak','nie'}) == 1
      DO WHILE .NOT. RLOCK()
      ENDDO
      DELETE
      UNLOCK
      abbruch := .T.
      CLEAR GETS
    ENDIF
ENDIF
RETURN
