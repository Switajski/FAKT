PROCEDURE grupy
USE grupy

SETFUNCTION(9,CHR(27))
SETFUNCTION(10,CHR(23))

DO WHILE .T.
   SET KEY -1 TO fakts2
   m->grupa      := SPACE(4)
   m->okreslenie := SPACE(40)

   rahmen(.T.,.F.,.F.,.F.,.T.,.T.,'definiowanie grup materialu')

   @ 10,08 SAY "symbol grupy.......:" GET m->grupa
   READ

   IF LASTKEY() == 27
      USE
      RETURN
   ENDIF
   SET KEY -1 TO
   
   LOCATE FOR m->Grupa == grupa
   IF FOUND()
      IF ALERT('Istniejaca Grupa materialow',{'koryguj','usun'}) == 1
          m->okreslenie := okreslenie
      ELSE
          DbDelete()
          USE
          RETURN
      ENDIF
   ELSE
      APPEND BLANK
   ENDIF

   @ 12,08 SAY "okreslenie grupy...:" GET m->okreslenie
   READ
   REPLACE grupa      WITH m->grupa
   REPLACE okreslenie WITH m->okreslenie

ENDDO

CLOSE DATABASES
SETFUNCTION(9,"")
SETFUNCTION(10,"")

RETURN