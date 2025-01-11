PROCEDURE pracowni

@ 5,1 CLEAR TO 22,69
USE pracowni INDEX p_numer,Nazwisko
GO BOTTOM

m->p_numer := numer+1

//m->od_godz  := 0
//m->do_godz  := 0
//m->od_min   := 0
//m->do_min   := 0

//m->od_godz1 := 0
//m->do_godz1 := 0
//m->od_min1  := 0
//m->do_min1  := 0

//m->od_godz2 := 0
//m->do_godz2 := 0
//m->od_min2  := 0
//m->do_min2  := 0

SET KEY -1 TO fakts2

rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wprowadzanie danych o pracownikach')

abbruch := .F.

SETFUNCTION( 9, CHR(27))

DO WHILE .T.
   GO BOTTOM
   m->p_numer := numer+1
   @ 7,20 SAY "Numer ewidencyjny......" GET m->p_numer PICTURE '999'
   READ
   IF LASTKEY() == 27
      USE
      abbruch := .T.
      EXIT
   ENDIF

   IF .NOT. abbruch

      SET KEY -7 TO PrUsun
      SET INDEX TO p_numer,nazwisko

      IF DBSEEK(m->p_numer) //FOUND()

         SET KEY -7 TO PrUsun

         m->p_numer   := numer
         m->nazwisko  := nazwisko
         m->imie      := imie
         m->data      := data
//         m->urlop     := urlop
         NowyPrac     := .F.

//         m->od_godz  := od_godz
//         m->do_godz  := do_godz
//         m->od_min   := od_min
//         m->do_min   := do_min

//         m->od_godz1 := od_godz1
//         m->do_godz1 := do_godz1
//         m->od_min1  := od_min1
//         m->do_min1  := do_min1

//         m->od_godz2 := od_godz2
//         m->do_godz2 := do_godz2
//         m->od_min2  := od_min2
//         m->do_min2  := do_min2

         @ 7,50 SAY 'zmiana'

      ELSE

         m->nazwisko  := SPACE(20)
         m->imie      := SPACE(20)
         m->data      := date()
//         m->urlop     := 0

//         m->od_godz  := 0
//         m->do_godz  := 0
//         m->od_min   := 0
//         m->do_min   := 0

//         m->od_godz1 := 0
//         m->do_godz1 := 0
//         m->od_min1  := 0
//         m->do_min1  := 0

//         m->od_godz2 := 0
//         m->do_godz2 := 0
//         m->od_min2  := 0
//         m->do_min2  := 0

         NowyPrac     := .T.
         @ 7,50 SAY 'nowy  '

      ENDIF

      SETFUNCTION( 10 ,CHR(23))

      @  9,20   SAY 'Nazwisko...............' GET m->nazwisko VALID .NOT. EMPTY(m->nazwisko)
      @ 10,20   SAY 'Imie...................' GET m->imie
      @ 12,20   SAY 'Data Zatrudnienia......' GET m->data
//      @ 13,20   SAY 'Przyslugujacy Urlop....' GET m->Urlop
//      @ 13,49   SAY 'dni'

//      @ 15,20   SAY 'Przerwa regulaminowa...' GET m->od_godz PICTURE '99 h' RANGE 0,23
//      @ 15,49   GET m->od_min PICTURE '99 min' RANGE 0,59
//      @ 15,56   SAY 'do' GET m->do_godz PICTURE '99 h'RANGE 0,23
//      @ 15,64   GET m->do_min PICTURE '99 min' RANGE 0,59

//      @ 16,20   SAY 'Przerwa dodatkowa 1....' GET m->od_godz1 PICTURE '99 h'
//      @ 16,49   GET m->od_min1 PICTURE '99 min'
//      @ 16,56   SAY 'do' GET m->do_godz1 PICTURE '99 h'
//      @ 16,64   GET m->do_min1 PICTURE '99 min'

//      @ 17,20   SAY 'Przerwa dodatkowa 2....' GET m->od_godz2 PICTURE '99 h'
//      @ 17,49   GET m->od_min2 PICTURE '99 min'
//      @ 17,56   SAY 'do' GET m->do_godz2 PICTURE '99 h'
//      @ 17,64   GET m->do_min2 PICTURE '99 min'

      READ

      lk := LASTKEY()
      DO CASE
         CASE lk == 27
            CLOSE DATABASES
            RETURN
         CASE lk == 23
            EXIT
      ENDCASE

      IF NowyPrac
         APPEND BLANK
      ENDIF

      REPLACE numer      WITH m->p_numer
      REPLACE nazwisko   WITH m->nazwisko
      REPLACE imie       WITH m->imie
      REPLACE data       WITH m->data

//      REPLACE od_godz    WITH m->od_godz
//      REPLACE do_godz    WITH m->do_godz
//      REPLACE od_min     WITH m->od_min
//      REPLACE do_min     WITH m->do_min

//      REPLACE od_godz1    WITH m->od_godz1
//      REPLACE do_godz1    WITH m->do_godz1
//      REPLACE od_min1     WITH m->od_min1
//      REPLACE do_min1     WITH m->do_min1

//      REPLACE od_godz2    WITH m->od_godz2
//      REPLACE do_godz2    WITH m->do_godz2
//      REPLACE od_min2     WITH m->od_min2
//      REPLACE do_min2     WITH m->do_min2

      SETFUNCTION( 10, '')


   ENDIF

ENDDO

SETFUNCTION(  9, '')
CLOSE DATABASES
SET KEY -7 TO
RETURN

PROCEDURE PrUsun
IF .NOT. EOF()
   IF ALERT(ALLTRIM(nazwisko)+' '+ALLTRIM(imie)+ ' usunac ?',{'tak','nie'}) == 1
      DO WHILE .NOT. RLOCK()
      ENDDO
      DELETE
      UNLOCK
      abbruch := .T.
      CLEAR GETS
    ENDIF
ENDIF
RETURN