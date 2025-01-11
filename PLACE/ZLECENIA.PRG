PROCEDURE zlecenia

@ 5,1 CLEAR TO 22,69
USE zlecenia INDEX z_numer

SET KEY -1 TO fakts2

rahmen(.T.,.F.,.F.,.T.,.T.,.F.,'zarzadzanie zleceniami')

abbruch := .F.

m->data     := DATE()
m->zlecenie2:= SPACE(10)
m->numer_wy := SPACE(8)
m->ilosc    := 0
m->mnoznik  := 1
m->aktywne  := "T"

//DO WHILE .NOT. abbruch

SET KEY -7 TO ZlecUsun

@ 7,15    SAY "Zlecenie Nr.:..........." GET m->zlecenie2 VALID .NOT. EMPTY(m->zlecenie2)
READ

//rahmen(.F.,.F.,.F.,.F.,.T.,.F.,'istniejace zlecenie')

IF LASTKEY() == 27
   USE
   Abbruch := .T.
   RETURN
ENDIF

IF abbruch
   CLOSE DATABASES
   RETURN
ENDIF

SET INDEX TO z_numer

IF .NOT. DBSEEK(m->zlecenie2)

   @  11,51   SAY "Nowe Zlecenie      " COLOR(farb4)
   NoweZlecenie := .T.

ELSE

   m->numer_wy  := wyrob
   m->ilosc     := ilosc
   m->data      := data
   m->mnoznik   := mnoznik
   m->aktywne   := aktywne
   NoweZlecenie := .F.

   IF m->mnoznik== 0
      m->mnoznik := 1
   ENDIF

   @  7,51   SAY "Zlecenie istniejace" COLOR(farb4)

ENDIF

@ 12,15   SAY "Numer wyrobu............" GET m->numer_wy
@ 13,15   SAY "Ilosc sztuk............." GET m->ilosc PICTURE '99999999'
@ 14,15   SAY "Data Otwarcia..........." GET m->data
@ 15,15   SAY "Mnoznik................." GET m->mnoznik PICTURE '9,99' VALID m->mnoznik > 0
@ 16,15   SAY "Zlecenie aktywne T/N...." GET m->aktywne  VALID UPPER(m->aktywne) == 'T' .OR. UPPER(m->aktywne) == 'N'

READ
IF LASTKEY() == 27
   USE
   RETURN
ENDIF

////SET INDEX TO z_numer

IF NoweZlecenie
   APPEND BLANK
ENDIF

IF .NOT. abbruch
   REPLACE zlecenie WITH m->zlecenie2
   REPLACE wyrob    WITH m->numer_wy
   REPLACE ilosc    WITH m->ilosc
   REPLACE data     WITH m->data
   REPLACE mnoznik  WITH m->mnoznik
   REPLACE aktywne  WITH UPPER(m->aktywne)
ENDIF

USE
RETURN

PROCEDURE ZlecUsun
IF .NOT. EOF()
   IF ALERT('Zlecenie '+ ALLTRIM(zlecenie) +' usunac ?',{'tak','nie'}) == 1
      DO WHILE .NOT. RLOCK()
      ENDDO
      DELETE
      UNLOCK
      abbruch := .T.
      CLEAR GETS
      SET INDEX TO z_numer
      REINDEX
    ENDIF
ENDIF
RETURN