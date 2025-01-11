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

*****************************************************************************

PROCEDURE FAKTS2
//include "def.ch"
PUBLIC msr,cena
SET CURSOR OFF
//SET DEFAULT TO &path2
STORE UPPER(READVAR()) TO var1
DO CASE



     CASE var1 == 'M->NUMER'
        datnam    := fakt+'\Artykuly'
//ALERT(datnam)         
        indnam    := fakt+'\Ar_numer'
        suchtext  := 'numer+SPACE(1)+nazwa1+LEFT(nazwa2,8)+SPACE(1)+STR(cena_klien,5,2)'
        text      := 'numer'



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
IF .NOT. EMPTY(filter)
   SET FILTER TO &filter
ENDIF

IF .NOT. EMPTY(indnam)
   SET INDEX TO &indnam
ENDIF
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
      @ Yg,Xg CLEAR TO Yd,Xd
      STORE Yg TO cursor
      STORE Yg TO xy

      DO WHILE .T.
         IF EOF() .OR. xy = 23
            STORE xy - 1 TO zeile
            EXIT
         ENDIF
         @ xy,Xg SAY &suchtext
         STORE xy + 1 TO xy
         SKIP
      ENDDO
      GO msr
   ENDIF
* ------------- aktueller Satz invers Darstellen ------------------
   STORE xy - 1 TO mcursor
   @ cursor,Xg SAY &suchtext COLOR (farb2)
* ------------- warten auf Tastendruck ----------------------------
   taste = INKEY(0)
   @ cursor,Xg SAY &suchtext
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
//set filter TO
SELECT(sel)
RETURN


******************************** reorganizacja danych **************************************************

PROCEDURE RAHMEN
//include "def.ch"

PRIVATE RText,Titel
SET DATE TO GERMAN
CLEAR

SINGLE = CHR(218) + CHR(196) + CHR(191) + CHR(179) +;
         CHR(217) + CHR(196) + CHR(192) + CHR(179)
@ 2,0,24,79 BOX SINGLE
@ 4,1  SAY REPL(CHR(196),78)
@ 4,0  SAY CHR(195)
@ 4,79 SAY CHR(180)
@ 1,0  SAY SPACE(80)

RText:= "Baby's World, Kokocko 43, 86260 Unislaw"+'           '+DTOC(DATE())
Titel := "System Kalkulacyjny"

@ 1,2 SAY RText //COLOR(U/B+)

@ 3,24 SAY titel //COLOR(farb4)

RETURN

************************* kresli ramy dla funkcji rahmen *********************************
PROCEDURE faktrahm
#include 'def.ch'
SINGLE = CHR(218) + CHR(196) + CHR(191) + CHR(179) +;
         CHR(217) + CHR(196) + CHR(192) + CHR(179)
@ Yg-1,Xg-1,Yd+1,Xd+1 BOX SINGLE
@ Yg,Xg clear to Yd,Xd
SET COLOR TO &farb2
@ 24,0  SAY '          '
@ 24,14 SAY 'F3 naprzod  '
@ 24,28 SAY 'F4 spowrotem'
SET COLOR TO farb1
RETURN


**************************************************************************