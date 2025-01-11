PROCEDURE usuniecie
LOCAL odp
@ 5,1 CLEAR TO 22,69
USE magazyn
INDEX ON DTOS(Data)+opis TO zam UNIQUE DESCENDING
GO TOP
SETFUNCTION(  9,'CHR(27)')

m->zam := SPACE(30)

SET KEY -1 TO fakts2

rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'usuwanie zamowienia')

SETFUNCTION(9,CHR(27))

@ 7,3 SAY "zamowienie/pozycja zamowienia (F2 szukaj)" GET m->zam
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

odp := ALERT('Do usuniecia :'+ALLTRIM(m->zam), {'pozostawic','usunac'})

IF odp == 2
   SET INDEX TO
   DO WHILE .NOT. EOF()
      IF opis == m->zam
         DELETE
      ENDIF
      SKIP
   ENDDO
   ALERT('Usunieto: '+ALLTRIM(m->zam))
ENDIF

//SETFUNCTION( 10,'')
//SETFUNCTION(  9,'')
//SET KEY -7 TO
CLOSE DATABASES
RETURN