PROCEDURE klienci
@ 5,1 CLEAR TO 22,69
USE Klienci INDEX kl_numer,ort
m->kli_numer := 0
SET KEY -1 TO fakts2
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wprowadzanie danych o klientach')

@ 7,20 SAY "Numer klienta........" GET m->kli_numer PICTURE '9999'
READ
IF LASTKEY() == 27
   USE
   RETURN
ENDIF

GO TOP

LOCATE FOR m->kli_numer == kli_numer

@ 5,20 SAY "Numer klienta........"+ STR(m->kli_numer,5,0)

IF FOUND()
   m->kli_nazwa1 := kli_nazwa1
   m->kli_nazwa2 := kli_nazwa2
   m->kli_ulica  := kli_ulica
   m->kli_PLZ    := kli_PLZ
   m->kli_Ort    := kli_ort
   m->kli_panstw := kli_panstw
   m->kli_NIP    := kli_NIP
   m->kli_ZNR    := kli_ZNR
   nowyklient    := .F.
   pozycja       := RECNO()
ELSE

   m->kli_nazwa1 := SPACE(20)
   m->kli_nazwa2 := SPACE(20)
   m->kli_ulica  := SPACE(20)
   m->kli_PLZ    := SPACE(7)
   m->kli_Ort    := SPACE(20)
   m->kli_Panstw := SPACE(20)
   m->kli_NIP    := SPACE(13)
   m->kli_ZNR    := SPACE(20)
   nowyklient    := .T.
ENDIF

SETFUNCTION(10,CHR(23))
SET KEY -7 TO KliUsun
abbruch := .F.
rahmen(.F.,.F.,.F.,.T.,.T.,.T.,'wprowadzanie danych o klientach')
DO WHILE .NOT. abbruch

   @  7,7  SAY 'Nazwa 1.........' GET m->kli_nazwa1
   @  9,7  SAY 'Nazwa 2.........' GET m->kli_nazwa2
   @ 11,7  SAY 'ulica...........' GET m->kli_ulica
   @ 13,7  SAY 'kod pocztowy....' GET m->kli_PLZ
   @ 15,7  SAY 'miejscowosc.....' GET m->kli_Ort
   @ 15,46 SAY 'Panstwo EU ' GET m->kli_Panstw
   @ 17,7  SAY 'numer podatk.EU ' GET m->kli_ZNR
   @ 19,7  SAY 'NIP.............' GET m->kli_NIP

   READ

   IF LASTKEY() == 23
      EXIT
   ENDIF

   IF LASTKEY() == 27
      USE
      RETURN
   ENDIF


ENDDO

SET INDEX TO kl_numer,ort
IF .NOT. abbruch

   IF nowyklient
      ALERT("nowy klient =", nowyklient)
      APPEND BLANK

   ELSE

      GOTO pozycja
   ENDIF

   REPLACE kli_numer   WITH m->kli_numer
   REPLACE kli_nazwa1  WITH m->kli_nazwa1
   REPLACE kli_nazwa2  WITH m->kli_nazwa2
   REPLACE kli_ulica   WITH m->kli_ulica
   REPLACE kli_PLZ     WITH m->kli_PLZ
   REPLACE kli_Ort     WITH m->kli_Ort
   REPLACE kli_panstw  WITH m->kli_panstw
   REPLACE kli_NIP     WITH m->kli_NIP
   REPLACE kli_ZNR     WITH m->kli_ZNR

ENDIF

CLOSE DATABASES
RETURN

PROCEDURE KliUsun
IF .NOT. EOF()
   IF ALERT('Klient '+ ALLTRIM(kli_nazwa1)+' '+ALLTRIM(kli_nazwa2) +' usunac ?',{'tak','nie'}) == 1
      DO WHILE .NOT. RLOCK()
      ENDDO
      DELETE
      UNLOCK
      abbruch := .T.
      CLEAR GETS
    ENDIF
ENDIF
RETURN