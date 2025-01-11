#include "set.ch"
#include "inkey.ch"
// #include "Appevent.ch"



******************* pokazuje okreslenie artykulu na monitorze ******************************************


FUNCTION Anzeige()
PARAMETER y,c

SELECT artykuly
art := READVAR()

IF DBSEEK(&art)
   @ y,9  SAY LEFT(ALLTRIM(nazwa1)+' '+ALLTRIM(nazwa2)+' '+ALLTRIM(nazwa3),45)
   SELECT faktury
   ausgang := .T.

ELSE
   IF .NOT. EMPTY(&art)
      ALERT('Artykul nie zostal odnaleziony w danych')
   ELSE
      ALERT('prosze cofnac')
   ENDIF
   SELECT faktury
   ausgang := .F.
ENDIF

RETURN ausgang


************************* kresli ramy dla funkcji rahmen *********************************
PROCEDURE faktrahm
*#include 'def.ch'
SINGLE = CHR(218) + CHR(196) + CHR(191) + CHR(179) +;
         CHR(217) + CHR(196) + CHR(192) + CHR(179)
@ Yg-1,Xg-1,Yd+1,Xd+1 BOX SINGLE
@ Yg,Xg clear TO Yd,Xd
SET COLOR TO &farb2
@ 24,0  SAY '          '
@ 24,14 SAY 'F3 naprzod  '
@ 24,28 SAY 'F4 spowrotem'
SET COLOR TO farb1
RETURN

*****************************************************************************

PROCEDURE FAKTS2
*#include "def.ch"
LOCAL path1a, path1i
SET CURSOR OFF
var1 := UPPER(READVAR())

DO CASE


   CASE var1 == 'M->ZAPIS'
      datnam    := 'magazyn'
      indnam    := 'zapis'
      suchtext  := "LEFT(STR(zapis,8,0)+'  '+DToc(Data)+'  Art:'+Art_Nr+'  '+Opis+'  '+ Tow_ArtNr + SPACE(80),76)"
      text      := 'zapis'

   CASE var1 == 'M->ART_NR'.OR. var1 == 'M->MAT_ARTNR'
      datnam    := 'materialy'
      indnam    := 'nazwa'
      suchtext  := "Nazwa+' dost:'+Dostawca"
      text      := 'Art_Nr'

   CASE var1 == 'M->DOSTAWCA'
      datnam    := 'dostawcy'
      indnam    := 'dostawca'
      suchtext  := "LEFT(ALLTRIM(dostawca)+'  '+ALLTRIM(firma)+' '+ALLTRIM(firma2)+' '+ kod +'-'+ALLTRIM(miasto)+SPACE(40),76)"
      text      := 'dostawca'


   CASE var1 == 'M->TOW_ARTNR' .OR. var1 == 'M->KOP_ARTNR' .OR. var1 == 'M->NORMA' .OR. var1 == 'TOWAR'
      datnam    := '&path1'+'\artykuly'
      indnam    := '&path1'+'\ar_nazwa'
      suchtext  := 'LEFT(ALLTRIM(nazwa1)+ALLTRIM(nazwa2)+SPACE(80),64)+SPACE(2)+numer'
      text      := 'numer'


   CASE var1 == 'M->ZAM'
      datnam    := 'Magazyn'
      indnam    := 'Zam'
      suchtext  := 'SPACE(2)+Opis+"   "+DTOC(data)+"   Art.nr "+Tow_ArtNr+ SPACE(13)'
      text      := 'Opis'

   CASE var1 == 'M->POS'
      datnam    := 'Towary'
      indnam    := 'Pozycja'
      suchtext  :=  "STR(Pos,3,0) +'  material: '+ Mat_ArtNr+' Ilosc:'+STR(ilosc,10,2)+SPACE(40)"
      text      := 'pos'
      filter    := 'Tow_ArtNr == m->Tow_ArtNr'

   CASE var1 == 'M->GRUPA'
      datnam    := 'grupy'
      indnam    := ''
      suchtext  := "' Grupa: '+Grupa+'  Nazwa:  '+ Okreslenie+SPACE(13)"
      text      := 'grupa'


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

var1 := UPPER(ALLTRIM(var1))
IF .NOT. DBSEEK(&var1)
   GOTO satz
ENDIF
bild:=1

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
* ------------ Vorw�rts bl�ttern ---------------------------------
      CASE taste = -2
           IF .NOT. EOF()
              SKIP 17 -(cursor -6)
              STORE 1 TO bild
              IF EOF()
                 SKIP - 1
              ENDIF
           ENDIF
* ------------ Zur�ck blettern -------------------------------------
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
* ------------ F 10 Ende und �bernehemen ---------------------------
      CASE (taste = -9) .OR. (taste = 13)
* ------------ Sprung zum ausgew�hlten Satz ------------------------
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
IF .NOT. EMPTY(filter)
   set filter TO
ENDIF
SELECT(sel)
RETURN


******************************** reorganizacja danych **************************************************

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

RText:= wersja+ ' * '+ALLTRIM(firma1)+ ', '+ ALLTRIM(firma2) + ', ' + ALLTRIM(firma3) + ', '+DTOC(DATE())

@ 1,2 SAY RText COLOR(farb1)

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

      // IF GetEnableEvents()
      //    DO CASE
      //       CASE nFKey <= 10
      //          nFKey := nFKey + xbeK_F1 - 1
      //       CASE nFKey <= 20
      //          nFKey := nFKey + xbeK_CTRL_F1 - 11
      //       CASE nFKey <= 30
      //          nFKey := nFKey + xbeK_ALT_F1 - 21
      //       CASE nFKey <= 40
      //          nFKey := nFKey + xbeK_SH_F1 - 31
      //    ENDCASE

      //    IF Len( cString) == 0
      //       RETURN SetAppEvent( nFKey, NIL)
      //    ENDIF

      //    RETURN SetAppEvent( nFKey, {|| _Keyboard( cString ) } )
      // ELSE
      //    nFKey := IIf( nFKey == 1, 28, 1 - nFKey )

      //    IF Len( cString) == 0
      //      RETURN SetKey( nFKey, NIL)
      //    ENDIF
      //    RETURN SetKey( nFKey,{|| _Keyboard( cString)})
      // ENDIF

   RETURN NIL