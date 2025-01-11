#include "Getexit.ch"
#include "AppEvent.ch"
#include "SetCurs.ch"
#include "Common.ch"

PROCEDURE main()
LOCAL odpow
PUBLIC path4,path3,filter
//, farb1, farb2, farb3, farb4

SETFUNCTION(9,CHR(27))
SET DATE TO GERMAN
SET DELETED ON
SET CONFIRM ON
SET DELIMITERS OFF
SET EXCLUSIVE ON
SET SCOREBOARD OFF
SET MARGIN TO 5
SET CENTURY OFF
SET EPOCH TO 1999
filter := ''

farb1:=  '7/b,  b/3'
farb2:=  'n/bg, bg/w'
farb3:=  'r/w,  r/w'
farb4:=  'gr+/b, gr+/b'
farb5:=  'gr+*/b, gr+*/b'

//CGA80()

USE Ustaw
path4 := ALLTRIM(edytor)
path3 := ALLTRIM(DBF)
USE

SET PATH TO DBF

titel := "System obliczania plac"
titel1:= 'menue'

DO WHILE .T.

   SETFUNCTION(9,CHR(27))
   odpow := ' 3'
   Rahmen(.F.,.F.,.F.,.F.,.T.,.F.,"Wybor rodzaju czynnosci")

   SET COLOR TO &farb1
   CLOSE DATABASES

   @  5,3 SAY "WPROWADZANIE DANYCH:"           COLOR farb4

   @  7,5 SAY "wyroby, operacje, czasy...(1)"
   @  8,5 SAY "pracownicy................(2)"
   @  9,5 SAY "rejestracja dnia pracy....(3)"
   @ 10,5 SAY "listy.....................(4)"
   @ 11,5 SAY "zlecenia..................(5)"
   @ 12,5 SAY "urlopy i chorobowe........(6)"


   @ 15,3 SAY "DRUKOWANIE DOKUMENTOW:"           COLOR farb4
   @ 17,5 SAY "wykaz operacji...........(10)"
   @ 18,5 SAY "lista plac pracownika....(11)"
   @ 19,5 SAY "rozliczenie zlecenia.....(12)"
   @ 20,5 SAY "okresowa lista plac......(13)"
   @ 21,5 SAY "rozliczenie czasu pracy..(14)"
   @ 22,5 SAY "Lista robocizny na wyroby(15)"


   @  5,38 SAY "ORGANIZACYJNE:"                  COLOR farb4
   @  7,40 SAY "reorganizacja danych.....(20)"
   @  8,40 SAY "archiwowanie danych......(21)"
   @  9,40 SAY "zmiana numeru wyrobu.....(22)"
   @ 10,40 SAY "ustawienia dostepu.......(23)"

   @ 13,38 SAY "STATYSTYKA:"                     COLOR farb4
   @ 15,40 SAY "srednie czasy wykonania...(30)"
   @ 16,40 SAY "statystyka produkcji......(31)"
//   @ 19,40 SAY "robocizna do kalkulacji...(32)"
   @ 17,40 SAY "rozklad kosztow...........(32)"
   @ 18,40 SAY "reorganizacja norm........(33)"
   @ 22,40 SAY "Wybierz opcje............" GET odpow PICTURE '@K'
   READ

   IF LASTKEY() == 27
      CLOSE DATABASES
      SET COLOR TO
      CLEAR ALL
      CLEAR
      RETURN
   ENDIF
   odpow := ALLTRIM(odpow)

   DO CASE

      CASE odpow == '1'
         DO wyroby
      CASE odpow == '2'
         DO pracowni
      CASE odpow == '3'
         DO rejestr
      CASE odpow == '4'
         DO listy
      CASE odpow == '5'
         DO zlecenia
      CASE odpow == '6'
         DO urlopy

      CASE odpow == '10'
         DO dr_kbkn
      CASE odpow == '11'
         DO Dr_LiPra
      CASE odpow == '12'
         DO mo_zlece
      CASE odpow == '13'
         DO Dr_Place
      CASE odpow == '14'
         DO Czas2
      CASE odpow == '15'
         DO Dr_Ceny

      CASE odpow == '20'
         DO reo
      CASE odpow == '21'
         DO archiv
      CASE odpow == '22'
         DO zmiana
      CASE odpow == '23'
         DO ustaw

      CASE odpow == '30'
         DO dr_sredn
      CASE odpow == '31'
         DO dr_stati
      CASE odpow == '32'
         DO koszty
      CASE odpow == '33'
         DO analiza

   OTHERWISE
      ALERT('Niedolaczona Procedura')

   ENDCASE
   SETFUNCTION(9,'')

ENDDO
SET COLOR TO
CLEAR ALL
CLEAR
RETURN