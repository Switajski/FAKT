#include "inkey.ch"
#include "set.ch"

PROCEDURE material
PRIVATE lk,nowy
//,koniec,m->nazwa,m->jednostka,m->dostawca,m->cena,m->cena_eur,m->grupa
//LOCAL GetList:={SPACE(4),SPACE(60),SPACE(3),SPACE(10),0,0,SPACE(4)}
//LOCAL GetList:= {}
m->ART_NR     := SPACE(4)

m->nazwa      := SPACE(60)
m->jednostka  := SPACE(3)
m->dostawca   := SPACE(10)
m->cena       := 0
m->cena_eur   := 0
m->grupa      := SPACE(4)

SET KEY -1 TO fakts2
abbruch := .F.
@ 5,1 CLEAR TO 22,69
DO WHILE .T.

   SETFUNCTION(9,CHR(27))

   rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wprowadzanie danych o materialach')

   @ 7,20 SAY "Numer materialu......" GET m->Art_NR VALID .NOT. EMPTY(m->Art_Nr)
   READ

   lk := LASTKEY()

   DO CASE
      CASE lk == 27
         EXIT
      CASE lk == 23
         EXIT
      ENDCASE

   SET KEY -7 TO MatUsun

   rahmen(.F.,.F.,.F.,.T.,.T.,.T.,'material art.nr.'+ALLTRIM(m->Art_Nr))

   USE materialy
   SET INDEX TO MatNr,nazwa

   IF DBSEEK(m->ART_NR) //FOUND()
      @ 5,55 SAY 'zmiana' COLOR farb5
      SET KEY -7 TO MatUsun

      Nowy          := .F.
      m->nazwa      := nazwa
      m->jednostka  := jednostka
      m->dostawca   := dostawca
      m->cena       := cena
      m->cena_eur   := cena_eur
      m->grupa      := grupa

   ELSE
      @ 5,55 SAY 'nowy material' COLOR farb5
      Nowy := .T.
   ENDIF


   //SetKey( K_F10,{|| _Keyboard( CHR(23) )})

   SETFUNCTION(9,CHR(27))
   SETFUNCTION(10,CHR(23))

   abbruch := .F.
   koniec  := .F.
   DO WHILE .NOT. abbruch .AND. .NOT. koniec


      @  7,2   SAY 'nazwa materialu ' GET m->nazwa
      @  9,2   SAY 'jednostka miary ' GET m->jednostka
      @ 11,2   SAY 'dostawca        ' GET m->dostawca
      @ 13,2   SAY 'cena            ' GET m->cena PICTURE '99999.99 zl'
      @ 15,2   SAY 'cena EUR        ' GET m->cena_eur PICTURE '99999.99 EUR'
      @ 17,2   SAY 'grupa materialow' GET m->grupa

      READ
      lk := LASTKEY()

      IF lk == 27
         abbruch := .T.
         CLOSE DATABASES
         RETURN
      ELSE
         IF lk == 23
            koniec  := .T.
            abbruch := .F.
//            nowy    := .F.
         ENDIF
      ENDIF

   ENDDO

   SET INDEX TO MatNr, Nazwa

   IF .NOT. abbruch

      IF Nowy
         APPEND BLANK
      ELSE
         DBSEEK(m->ART_NR)
      ENDIF

      REPLACE ART_NR     WITH m->ART_NR
      REPLACE nazwa      WITH m->nazwa
      REPLACE jednostka  WITH m->jednostka
      REPLACE dostawca   WITH m->dostawca
      REPLACE cena       WITH m->cena
      REPLACE grupa      WITH m->grupa
      REPLACE cena_eur   WITH m->cena_eur

   ENDIF
   CLOSE DATABASES
   SET KEY -7 TO

ENDDO
DO REO
SETFUNCTION(9,'')
SETFUNCTION(10,'')
SET KEY -1 TO

RETURN

PROCEDURE MatUsun
IF .NOT. EOF()
   IF ALERT('Wyrob '+ ALLTRIM(nazwa)+'  numer artykulu: '+ALLTRIM(ART_NR)+' usunac ?',{'tak','nie'}) == 1
      DO WHILE .NOT. RLOCK()
      ENDDO
      DELETE
      UNLOCK
      abbruch := .T.
      CLEAR GETS
    ENDIF
ENDIF
RETURN