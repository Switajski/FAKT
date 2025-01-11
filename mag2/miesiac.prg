Procedure miesiac
LOCAL rok,przychod,rozchod

Rahmen(.F.,.F.,.F.,.F.,.T.,.F.,"ZAMKNIECIE ROKU")

rok        := 2000
m->przychod:= 0
m->rozchod := 0

@ 10,25  SAY "Zamykam archiwum dla:" COLOR farb4
@ 14,25  SAY "roku......" GET rok PICTURE "9999" VALID rok > 2000
READ

IF LASTKEY() == 27
   RETURN
ENDIF
opcja := ALERT( "UWAGA;;Zamkniecie Roku; spowoduje redukcje informacji o ruchu materialu; za ten rok;;", {"przerwij","kontynuuj"} )
IF opcja == 1
   RETURN
ENDIF

USE archiv
APPEND FROM magazyn for YEAR(data) == rok
USE

USE mem     NEW
ZAP
USE magazyn NEW

SET FILTER TO YEAR(data) == rok
INDEX ON Art_Nr TO MatNr
GO TOP
m->Art_Nr := Art_Nr

DO WHILE .NOT. EOF()


// Jesli Art_Num zgodny, dodaj przychod i rozchod

   IF m->Art_Nr == Art_Nr
      m->rozchod  := m->rozchod  + magazyn->rozchod
      m->przychod := m->przychod + magazyn->przychod
   ELSE

// Jesli nie (nowy Art_Nr), przepisz stany do archiwum i pobierz do pamieci nowy Art_Nr
      SELECT mem

      APPEND BLANK
      REPLACE mem->przychod WITH m->przychod
      REPLACE mem->rozchod  WITH m->rozchod
      REPLACE mem->data     WITH magazyn->data
      REPLACE mem->opis     WITH 'stan za rok '+STR(rok,4,0)+SPACE(15)
      REPLACE mem->Art_Nr   WITH m->Art_Nr

      SELECT magazyn

      m->Art_Nr    := magazyn->Art_Nr
      m->rozchod   := magazyn->rozchod
      m->przychod  := magazyn->przychod
   ENDIF

   SKIP
ENDDO

DBCOMMIT()
SET INDEX TO
SET FILTER TO
CLOSE DATABASES

USE mem
APPEND FROM Magazyn for YEAR(data) <> rok
USE

magpath := path2+'\magazyn.dbf'
USE &magpath
ZAP

USE mem
INDEX ON data TO data

COPY ALL TO &magpath
USE &magpath

GO TOP
m->zapis = 1
DO WHILE .NOT. EOF()
  REPLACE zapis WITH m->zapis
  SKIP
  m->zapis ++
ENDDO
USE
RETURN