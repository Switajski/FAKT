
************************* kresli ramy dla funkcji rahmen *********************************
PROCEDURE faktrahm
*#include 'def.ch'
SINGLE = CHR(218) + CHR(196) + CHR(191) + CHR(179) +;
         CHR(217) + CHR(196) + CHR(192) + CHR(179)
@ 5,24,23,60 BOX SINGLE
@ 6,25 clear TO 22,59
SET COLOR TO &farb2
@ 24,0  SAY '          '
@ 24,14 SAY 'F3 naprzod  '
@ 24,28 SAY 'F4 spowrotem'
SET COLOR TO farb1
RETURN

*****************************************************************************

PROCEDURE FAKTS2
*#include "def.ch"
PUBLIC msr,cena
SET CURSOR OFF
STORE UPPER(READVAR()) TO var1
DO CASE


     CASE var1 == 'M->NUMER_WY'
        datnam    := 'wyroby'
        indnam    := 'nazwa_wy'
        suchtext  := 'nazwa'
        text      := 'numer_wy'

    CASE var1 == 'M->NUMER' //.OR. var1 == 'M->NUMER_OP'
        datnam    := 'operacje'
        indnam    := 'numer'
        suchtext  := 'nazwa'
        text      := 'numer'
        filter    := "wyrob_nr $ m->numer_wy"
//        filter    := "wyrob_nr == m->numer_wy"
//        filter := "{|| wyrob_nr $ m->numer_wy }, 'wyrob_nr $ m->numer_wy'"

    CASE var1 == 'M->NUMER_OP'
        datnam    := 'operacje'
        indnam    := 'numer'
        suchtext  := 'nazwa'
        text      := 'numer'
        filter    := "wyrob_nr $ m_wyrob"

   CASE var1  == 'M->P_NUMER'
        datnam    := 'pracowni'
        indnam    := 'nazwisko'
        suchtext  := "LEFT(ALLTRIM(nazwisko)+' '+ALLTRIM(imie)+SPACE(35),35)"
        text      := 'numer'

   CASE var1 == 'M->LISTA'
        datnam  := 'lista'
        indnam  := 'lista'
        suchtext:= 'LEFT(lista+space(35),35)'
        text    := 'lista'

   CASE var1 == 'M->ZLECENIE'
        datnam  := 'zlecenia'
        indnam  := 'z_numer'
        suchtext:= "LEFT('nr '+ALLTRIM(zlecenie)+' -> '+ALLTRIM(STR(ilosc))+' szt '+ ALLTRIM(wyrob)+SPACE(35),35)"
        text    := 'zlecenie'
        filter  := "UPPER(aktywne) == 'T'"

   CASE var1 == 'M->ZLECENIE2'
        datnam  := 'zlecenia'
        indnam  := 'z_numer'
        suchtext:= "LEFT(zlecenie+' '+aktywne+STR(ilosc,6,0)+' szt '+ ALLTRIM(wyrob)+SPACE(35),35)"
        text    := 'zlecenie'


   CASE var1  == 'M->LP'
        datnam  := 'rejestr'
        indnam  := 'lp'
        suchtext:= "LEFT(ALLTRIM(STR(lp))+' '+ALLTRIM(wyrob)+'/'+ALLTRIM(STR(operacja))+'->'+ALLTRIM(STR(ilosc))+' szt.'+DTOC(data)+' pr:'+ALLTRIM(STR(p_numer))+SPACE(35),35)"
        text    := 'lp'

   CASE var1  == 'M->KOSZTY'
        datnam  := 'Koszty'
        indnam  := 'Koszty'
        suchtext:= " '  '+miejsce+'    '+koszty+'  '"
        text    := 'koszty'

   CASE var1 == 'M->DATA_URLOP'
        datnam  := 'Urlopy'
        indnam  := ''
        suchtext:= "'  Wolne dnia: '+DTOC(Data_Urlop)+' Rodzaj: '+Rodzaj+'   '"
        text    := "Data_Urlop"
        filter  := "P_NUMER == M->P_NUMER .AND. LISTA == M->LISTA"


   OTHERWISE
        SET CURSOR ON
        RETURN
ENDCASE
sel =  SELECT()
IF SELECT(datnam) == 0
   USE &datnam NEW
   neubank := .T.
ELSE
   SELECT &datnam
   neubank := .F.
ENDIF
//IF .NOT. EMPTY(filter)
//DbSetFilter( filter )
SET FILTER TO &filter

//ENDIF
SET INDEX TO &indnam
GO TOP

* ------------- Bildschirm sichern --------------------------------

SAVE SCREEN TO scr1
SET COLOR TO &farb4

* ------------- Hilfsrahmen "ffnen --------------------------------

DO faktrahm
SET COLOR TO &farb1
satz := RECNO()
*Laenge := LEN(ALLTRIM(&var1))
//IF .NOT. DBSEEK(UPPER(ALLTRIM(&var1)))
//   GOTO satz
//ENDIF
STORE 1 TO bild

DO WHILE .T.
*-------------- Daten am Bildschirm anzeigen ----------------------
   IF bild = 1
      STORE recno() TO msr
      STORE 0 TO bild
      @ 6,25 CLEAR TO 22,59
      STORE 6 TO cursor
      STORE 6 TO xy

      DO WHILE .T.
         IF EOF() .OR. xy = 23
            STORE xy - 1 TO zeile
            EXIT
         ENDIF
         @ xy,25 SAY &suchtext
         STORE xy + 1 TO xy
         SKIP
      ENDDO
      GO msr
   ENDIF
* ------------- aktueller Satz invers Darstellen ------------------
   STORE xy - 1 TO mcursor
   @ cursor,25 SAY &suchtext COLOR (farb2)
* ------------- warten auf Tastendruck ----------------------------
   taste = INKEY(0)
   @ cursor,25 SAY &suchtext
* ------------- letzter Tastendruck -------------------------------
   DO CASE
* ------------- F9 ? ----------------------------------------------
      CASE taste = -8
           EXIT
* ------------ Vorw„rts bl„ttern ---------------------------------
      CASE taste = -2
           IF .NOT. EOF()
              SKIP 17 -(cursor -6)
              STORE 1 TO bild
              IF EOF()
                 SKIP - 1
              ENDIF
           ENDIF
* ------------ Zurück blettern -------------------------------------
      CASE taste = -3
           IF .NOT. BOF()
              STORE recno() TO rec
              SKIP -(17-(cursor-6))
              IF recno() <> rec
                 STORE 1 TO bild
              ENDIF
           ENDIF
* ------------ Cursor auf ------------------------------------------
      CASE taste = 5
           IF .NOT. BOF()
              STORE recno() TO rec
              skip -1
              IF recno() <> rec
                 IF cursor = 6
                    STORE 1 TO bild
                 ELSE
                    STORE cursor -1 TO cursor
                 ENDIF
              ENDIF
           ENDIF
* ------------- Cursor ab -------------------------------------------
      CASE taste = 24
           IF .NOT. EOF()
              SKIP
              IF cursor = 22
                 STORE 1 TO bild
              ELSE
                 IF cursor <> mcursor
                    STORE cursor + 1 TO cursor
                 ELSE
                    SKIP -1
                ENDIF
             ENDIF
          ENDIF
* ------------ F 10 Ende und übernehemen ---------------------------
      CASE (taste = -9) .OR. (taste = 13)
* ------------ Sprung zum ausgew„hlten Satz ------------------------
          go msr
          skip cursor - 6
          &var1  := &text

          DO CASE
             CASE var1 == 'M->KM'
                m->OrtA  := OrtA
                m->OrtB  := OrtB
                hoch     := .T.
                CLEAR GETS

             CASE var1 == 'M->NUMMER'
                m->Kostenstel := Kostenstel
          ENDCASE
          EXIT
      OTHERWISE
          satz := RECNO()
          IF .NOT. DBSEEK(UPPER(CHR(taste)))
             GOTO satz
             ? CHR(7)
          ENDIF
          STORE 1 TO bild
          IF EOF()
             GO TOP
          ENDIF
   ENDCASE
ENDDO
SET CURSOR ON
RESTORE SCREEN FROM scr1
IF neubank
   USE
ENDIF

filter := ''
SELECT(sel)
//IF .NOT. EMPTY(filter)
//SET FILTER TO

//ENDIF

RETURN

PROCEDURE RAHMEN
PARAMETER f2,F3,F4,F8,F9,F10,titel
#include "def.ch"

PRIVATE RText
//WACLOSE()
SET COLOR TO &farb1
CLEAR

STORE DTOC(DATE()) TO mdat
SINGLE = CHR(218) + CHR(196) + CHR(191) + CHR(179) +;
         CHR(217) + CHR(196) + CHR(192) + CHR(179)
@ 2,0,23,79 BOX SINGLE
@ 4,1  SAY REPL(CHR(196),78)
@ 4,0  SAY CHR(195)
@ 4,79 SAY CHR(180)
@ 1,0  SAY SPACE(80)
SET COLOR TO &farb2

RText:=  ' * '+ALLTRIM(firma1)+ ' * '+ ALLTRIM(firma2) + ' * ' + ALLTRIM(firma3) + ' * '+DTOC(DATE())

@ 1,7 SAY RText COLOR(farb1)

@ 3,24 SAY titel COLOR(farb4)

IF F2
   @ 24,0  SAY 'F2 szukaj'
ELSE
   @ 24,0  SAY '         '
ENDIF

IF F3
   @ 24,14 SAY "F3 strona "
ELSE
   @ 24,14 SAY "          "
ENDIF
IF F4
   @ 24,28 SAY "F4 drukuj "
ELSE
   @ 24,28 SAY "          "
ENDIF
IF f8
   @ 24,42 SAY 'F8 usun   '
ELSE
   @ 24,42 SAY "          "
ENDIF
IF f9
   @ 24,56 SAY 'F9 cofnij '
ELSE
   @ 24,56 SAY "          "
ENDIF
IF f10
   @ 24,70 SAY 'F10 zapisz'
ELSE
   @ 24,70 SAY "          "
ENDIF
SET COLOR TO &farb1

RETURN

**************************************************************************


FUNCTION SETFUNCTION( nFKey, cString )

   IF GetEnableEvents()
      DO CASE
         CASE nFKey <= 10
            nFKey := nFKey + xbeK_F1 - 1
         CASE nFKey <= 20
            nFKey := nFKey + xbeK_CTRL_F1 - 11
         CASE nFKey <= 30
            nFKey := nFKey + xbeK_ALT_F1 - 21
         CASE nFKey <= 40
            nFKey := nFKey + xbeK_SH_F1 - 31
      ENDCASE

      IF Len( cString) == 0
         RETURN SetAppEvent( nFKey, NIL)
      ENDIF

      RETURN SetAppEvent( nFKey, {|| _Keyboard( cString ) } )
   ELSE
      nFKey := IIf( nFKey == 1, 28, 1 - nFKey )

      IF Len( cString) == 0
        RETURN SetKey( nFKey, NIL)
      ENDIF
      RETURN SetKey( nFKey,{|| _Keyboard( cString)})
   ENDIF

RETURN NIL