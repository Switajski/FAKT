PROCEDURE dostawcy
LOCAL nowy

@ 5,1 CLEAR TO 22,69
USE dostawcy INDEX dostawca, firma

m->Dostawca := SPACE(10)

SET KEY -1 TO fakts2

rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wprowadzanie danych o dostawcach')

SETFUNCTION(9,CHR(27))

@ 5,7 SAY "dostawca........." GET m->dostawca
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF
SET INDEX TO dostawca, Firma

LOCATE FOR m->dostawca == dostawca



IF FOUND()

   m->firma   := firma
   m->firma2  := firma2
   m->ulica   := ulica
   m->nr_domu := nr_domu
   m->kod     := kod
   m->miasto  := miasto
   m->telefon := telefon
   m->fax     := fax
   nowy       := .F.

ELSE

   m->firma   := SPACE(30)
   m->firma2  := SPACE(30)
   m->ulica   := SPACE(30)
   m->nr_domu := 0
   m->kod     := SPACE(6)
   m->miasto  := SPACE(30)
   m->telefon := SPACE(10)
   m->fax     := SPACE(10)
   nowy       := .T.

ENDIF

@ 2,7 CLEAR TO 2,79

//SETFUNCTION( 10,CHR(23))
//SETFUNCTION(  9,CHR(27))
//SET KEY -7 TO UsunDostawce

abbruch := .F.
rahmen(.F.,.F.,.F.,.T.,.T.,.T.,'wprowadzanie danych o dostawcach')

SETFUNCTION( 10,CHR(23))
SETFUNCTION(  9,CHR(27))
SET KEY -7 TO UsunDostawce


DO WHILE .NOT. abbruch

   @  5,7 SAY "dostawca........ "+ m->dostawca
   @  7,7  SAY 'firma...........' GET m->firma
   @  9,7  SAY '                ' GET m->firma2
   @ 11,7  SAY 'ulica...........' GET m->ulica
   @ 13,7  SAY 'numer domu......' GET m->nr_domu
   @ 15,7  SAY 'kod pocztowy....' GET m->kod
   @ 15,33 SAY 'miasto' GET m->miasto
   @ 17,7  SAY 'numer telefonu. ' GET m->telefon
   @ 19,7  SAY 'numer faksu.....' GET m->fax

   READ



   IF LASTKEY() == 23
      EXIT
   ENDIF

   IF LASTKEY() == 27
      USE
      RETURN
   ENDIF


ENDDO


IF .NOT. abbruch

   IF nowy
      APPEND BLANK
   ENDIF

   REPLACE dostawca    WITH m->dostawca
   REPLACE firma       WITH m->firma
   REPLACE firma2      WITH m->firma2
   REPLACE ulica       WITH m->ulica
   REPLACE nr_domu     WITH m->nr_domu
   REPLACE kod         WITH m->kod
   REPLACE miasto      WITH m->miasto
   REPLACE telefon     WITH m->telefon
   REPLACE fax         WITH m->fax

ENDIF

SETFUNCTION( 10,'')
SETFUNCTION(  9,'')
SET KEY -7 TO
CLOSE DATABASES
RETURN

PROCEDURE UsunDostawce
IF .NOT. EOF()
   IF ALERT('dostawce '+ ALLTRIM(dostawca)+' usunac ?',{'tak','nie'}) == 1
      DO WHILE .NOT. RLOCK()
      ENDDO
      DELETE
      UNLOCK
      abbruch := .T.
      CLEAR GETS
    ENDIF
ENDIF
RETURN