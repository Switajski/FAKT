#include "getexit.ch"
// #include "appevent.ch"
#include "setcurs.ch"
#include "common.ch"
#include "lib.prg"
//#include "AppEdit.ch"
//#include "AppBrow.ch"

****************
PROCEDURE Main()

LOCAL GetList:={}, wybor, size
PUBLIC farb1,farb2,farb3,farb4,farb5,filter
PUBLIC Yg, Xg, Yd, Xd, var1, path1, path2, path3, path4, Art

**** ustawienia sciezek dostepu

USE ustaw
path1 := ALLTRIM(artykuly)
path2 := ALLTRIM(DBF)
path3 := ALLTRIM(Runtime)
path4 := ALLTRIM(Edytor)
Art   := path1+'\Artykuly'
USE

//DO KopiaArt

// SetMouse(.T.)
SetCursor( SC_NORMAL )
SET PATH TO (path2+";"+ path3)
SET DELETED ON
SET DATE TO GERMAN
// SET KEY 9 TO Chr(27)
SET CONFIRM ON
SET DELIMITERS OFF
SET EXCLUSIVE ON
SET SCOREBOARD OFF
SET CENTURY OFF
SET EPOCH TO 2000
// SET CHARSET TO ANSI
filter := ''

SET SCOREBOARD OFF


farb1:=  '7/b,  b/3'
farb2:=  'n/bg, bg/w'
farb3:=  'r/w,  r/w'
farb4:=  'gr+/b, gr+/b'
farb5:=  'gr+*/b,gr+*/b'



Yg := 6
Xg := 2
Yd := 22
Xd := 77

wybor := 7

DO WHILE wybor <> 0

   Rahmen(.F.,.F.,.F.,.F.,.T.,.F.,"Menu Glowne")
   SETFUNCTION(9,CHR(27))

   @  5,4 SAY " 1. definiowanie materialow.................."
   @  6,4 SAY " 2. definiowanie dostawcow..................."
   @  7,4 SAY " 3. definiowanie norm materialowych.........."
   @  8,4 SAY " 4. definiowanie grup materialowych.........."
   @  9,4 SAY " 5. kopiowanie norm materialowych............"
   @ 10,4 SAY " 6. przychod i rozchod stanu magazynu........"
   @ 11,4 SAY " 7. rozchod stanu magazynowego w/g normy mat."
   @ 12,4 SAY " 8. usuniecie pozycji zamowienia............."

   @ 14,4 SAY "    WYDRUK                              ORGANIZACYJNE" COLOR farb4
   @ 16,4 SAY " 9. wydruk norm materialowych.."
   @ 17,4 SAY "10. wydruk stanow magazynowych."
   @ 18,4 SAY "11. wydruk kart magazynowych..."
   @ 19,4 SAY "12. wydruk ruchu materialow...."

   @ 16,40 SAY "13. reorganizacja plikow"
   @ 17,40 SAY "14. ustawienia dostepu.."
   @ 18,40 SAY "15. zamkniecie roku....."
   @ 19,40 SAY " 0. zakonczenie pracy .."

   @ 21,40 SAY "    wybor opcji......" GET wybor PICTURE "99"

   READ

   IF LASTKEY() == 27
   CLOSE DATABASES
   RETURN
   ENDIF

   DO CASE
      CASE wybor == 0
         CLOSE ALL
         RETURN
      CASE wybor == 1
         DO material
      CASE wybor == 2
         DO dostawcy
      CASE wybor == 3
         m->Tow_ArtNr := SPACE(10)
         DO towary
      CASE wybor == 4
         DO grupy
      CASE wybor == 5
         DO KopiaWyr
      CASE wybor == 6
         DO eingabe
      CASE wybor == 7
         DO zdejmij
      CASE wybor == 8
         DO usuniecie

      CASE wybor == 9
         DO DrukNorm
      CASE wybor == 10
         DO DrukStan
      CASE wybor == 11
         DO drukkart
      CASE wybor == 12
         DO Ruch

      CASE wybor == 13
         DO reo
      CASE wybor == 14
         DO ustaw
      CASE wybor == 15
         DO miesiac

   OTHERWISE

      ALERT('Niezdefiniowana Procedura')
   ENDCASE
SETFUNCTION(9,'')

ENDDO


RETURN


*****************************************************************

PROCEDURE Kopia
   m->zapis    := zapis
   m->Art_Nr   := Art_Nr
   m->Cena     := Cena
   m->Kolor    := Kolor
   m->Przychod := Przychod
   m->Rozchod  := Rozchod
   m->Data     := Data
   m->Opis     := Opis
RETURN



*****************************************


FUNCTION KolTest(Kol)
PRIVATE Wynik

USE Kolory NEW
SET INDEX TO Kolor

IF DBSEEK(Kol)
    @ 10,20 SAY Opis
    Wynik := .T.
ELSE
    @ 10,20 SAY 'Nieznany               '
    wynik := .F.
ENDIF
CLOSE Kolory

RETURN Wynik

***************************************

FUNCTION MatTest(Mat)
PRIVATE Wynik

USE Materialy NEW
SET INDEX TO MatNr

IF DBSEEK(Mat)
    @ 8,20 SAY Nazwa
    Wynik := .T.
ELSE
    @ 8,20 SAY 'Nieznany               '
    wynik := .F.
ENDIF
CLOSE Materialy

RETURN Wynik