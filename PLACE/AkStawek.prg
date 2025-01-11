PROCEDURE AkStawek
LOCAL opcja, haslo
haslo := SPACE(10)

rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'aktualizacja stawek')

@ 7,9 SAY "Haslo: " GET Haslo
READ

IF haslo <> "georg22   "
   RETURN
ENDIF
rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'aktualizacja stawek')

SET KEY -1 TO fakts2
SETFUNCTION(9,CHR(27))
opcja   := 1
lzmian  := 0


@ 7,9 SAY "Chce zmianic jedna okreslona stawke...............(1)"
@ 9,9 SAY "Chce przemnozyc wszystkie stawki przez wskaznik...(2)"
@11,9 SAY "Wybierz opcje..............................." GET opcja PICTURE '9'
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'aktualizacja stawek')
USE operacje

DO CASE
   CASE opcja == 1
      lzmian := JednaStawka()
   CASE opcja == 2
      lzmian := Mnoznik()
ENDCASE

CLOSE DATABASES
@ 15,9 SAY 'wprowadzilem zmiany stawki dla '+STR(lzmian,5,0)+' operacji'
INKEY(5)
RETURN



FUNCTION JednaStawka()
LOCAL StawkaS, StawkaN, lzmian
StawkaS := 0
StawkaN := 0
lzmian  := 0

   @  7,9    SAY "Zmiana jednej wybranej stawki za operacje"  COLOR farb4
   @  9,9    SAY "dotychczasowa stawka.................." GET StawkaS PICTURE "99.99" VALID StawkaS > 0
   @ 11,9    SAY "nowa stawka..........................." GET StawkaN PICTURE "99.99" VALID StawkaS > 0
   READ

   IF LASTKEY() == 27
      USE
      RETURN NIL
   ENDIF

   LOCATE FOR StawkaS == stawka
   IF .NOT. FOUND()
      ALERT('Stawka nie wystepuje w normach')
      CLOSE DATABASES
      RETURN NIL
   ENDIF

   @ 13,9 SAY 'Czakaj, wprowadzam Zmiany'

   GO TOP
   DO WHILE .NOT. EOF()

      IF Stawka == StawkaS
         REPLACE stawka WITH StawkaN
         lzmian++
      ENDIF
   SKIP
   ENDDO
RETURN lzmian

FUNCTION Mnoznik()
LOCAL StawkaX, lzmian
StawkaX := 1
lzmian  := 0

   @  7,9    SAY "Przemnozenie wszystkich istniejacych stawek przez mnoznik" COLOR farb4
   @ 11,9    SAY "wielkosc mnoznika....................." GET StawkaX PICTURE "99.99"
   READ

   IF LASTKEY() == 27
      USE
      RETURN NIL
   ENDIF

   @ 13,9 SAY 'Czakaj, wprowadzam Zmiany'
   GO TOP
   DO WHILE .NOT. EOF()
      REPLACE stawka WITH StawkaX * stawka
      lzmian++
      SKIP
   ENDDO

RETURN lzmian