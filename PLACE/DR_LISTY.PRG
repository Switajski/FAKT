PROCEDURE listy

@ 5,1 CLEAR TO 22,69
USE lista INDEX lista

SET KEY -1 TO fakts2

rahmen(.T.,.F.,.F.,.T.,.T.,.F.,'zarzadzanie listami plac')

abbruch := .F.

m->lista := SPACE(10)

//DO WHILE .NOT. abbruch

SET KEY -7 TO ListaUsun

@ 7,9    SAY "Lista Plac Nr:............" GET m->lista
READ

IF LASTKEY() == 27
   CLOSE DATABASES
   RETURN      
ENDIF
SET INDEX TO lista

IF .NOT. DBSEEK(m->lista)
   APPEND BLANK
   REPLACE lista WITH m->lista
ELSE
   REPLACE lista WITH m->lista
ENDIF

USE

PROCEDURE ListaUsun
IF .NOT. EOF()
   IF ALERT('Liste '+ ALLTRIM(lista) +' usunac ?',{'tak','nie'}) == 1
      DO WHILE .NOT. RLOCK()
      ENDDO
      DELETE
      UNLOCK
      abbruch := .T.
      CLEAR GETS
      SET INDEX TO lista
      REINDEX
    ENDIF
ENDIF
RETURN
