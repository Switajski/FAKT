PROCEDURE Main
PRIVATE odpow
PUBLIC Nr_Fakt, Faktor, Pfad, filter, path0, path1, path2, path3, path4, path5, path6, path7, Rachunek

SET DATE TO GERMAN
SET DELETED ON
SET CONFIRM ON
SET DELIMITERS OFF
SET EXCLUSIVE ON
SET SCOREBOARD OFF
SET CENTURY ON
SET MARGIN TO 5
SETFUNCTION(9,CHR(27))
filter := ''
rok := 0
USE Ustaw
path0     := ALLTRIM(ustawienia)
path1     := ALLTRIM(artykuly)
path2     := ALLTRIM(dbf)
path3     := ALLTRIM(runtime)
path4     := ALLTRIM(Edytor)
path5     := ALLTRIM(MatNorm)
path6     := ALLTRIM(RobNorm)
path7     := path5+'Towary'
m->faktor := faktor
Rachunek  := Rach_Nr
USE

SET PATH    TO &path3
SET DEFAULT TO &path2

farb1:=  '7/b,  b/3'
farb2:=  'n/bg, bg/w'
farb3:=  'r/w,  r/w'
farb4:=  'gr+/b, gr+/b'
farb5:=  'gr+*/b,gr+*/b'

PUBLIC Yg, Xg, Yd, Xd
Yg := 6
Xg := 2
Yd := 22
Xd := 77

//USE standart

titel := "Wprowadzanie Danych o Pakietach"
titel1:= 'menue'

DO WHILE .T.
   odpow := ' 0'
   Rahmen(.F.,.F.,.F.,.F.,.T.,.F.,"Wybor rodzaju czynnosci")

   SET COLOR TO &farb1
   CLOSE DATABASES

   @  5,3 SAY "WPROWADZANIE DANYCH:"           COLOR farb4

   @  7,5 SAY "dane o wyrobach................(1)"
   @  8,5 SAY "dane o klientach...............(2)"
   @  9,5 SAY "wysylka........................(3)"
   @ 10,5 SAY "zamowienie.....................(4)"


   @ 13,3 SAY "DRUKOWANIE DOKUMENTOW:"           COLOR farb4
   @ 15,5 SAY "sprzedaz INTRASTAT PL..........(5)"
   @ 16,5 SAY "Einkauf INTRASTAT DE...........(6)"
   @ 17,5 SAY "Lieferschein Sortiert..........(7)"
   @ 18,5 SAY "dokumenty polskie (rach, spec).(8)"
   @ 19,5 SAY "rachunek skomasowany niemiecki.(9)"
   @ 20,5 SAY "Preisliste.....................(10)"
//   @ 21,5 SAY "Packliste......................(11)"
//   @ 21,5 SAY "Packliste do wysylki...........(16)"


   @  5,43 SAY "ORGANIZACYJNE:"                  COLOR farb4
   @  7,45 SAY "ustawienia dostepu.........(12)"
   @  8,45 SAY "reorganizacja danych.......(13)"
   @  9,45 SAY "archiwowanie wysylek.......(14)"
   @ 10,45 SAY "archiwowanie zamowien......(15)"
   @ 11,45 SAY "rozliczanie zamowien.......(16)"
   @ 12,45 SAY "plik zamówienia............(17)"
   @ 13,45 SAY "wczytaj zamówienie.........(18)"
   @ 14,45 SAY "usuwanie starych artykulow.(19)"
   @ 19,45 SAY "zakonczyc program...........(0)"
   @ 22,45 SAY "Wybierz opcje............" GET odpow PICTURE '@K'
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
         DO artykuly
      CASE odpow == '2'
         DO klienci
      CASE odpow == '3'
         DO rachunek
      CASE odpow == '4'
         DO zamow

      CASE odpow == '5'
         DO intr_PL
      CASE odpow == '6'
         DO intr_DE
      CASE odpow == '7'
         DO Liefer2
      CASE odpow == '8'
         DO rach_zb
         DO zestaw
         IF UPPER(m->Zalacznik) == 'T'
            DO zalacz_2
         ENDIF
      CASE odpow == '9'
         DO rech_de
      CASE odpow == '10'
         DO preislst
      CASE odpow == '11'
         DO ZestawD
      CASE odpow == '12'
         DO ustaw
      CASE odpow == '13'
         DO reo
      CASE odpow == '14'
         DO ArchZam
      CASE odpow == '15'
         DO archiwum

      CASE odpow == '16'
         DO Zam_NZ
      CASE odpow == '17'
         DO Plik
      CASE odpow == '18'
         DO Wczytaj1
      CASE odpow == '19'
         czystka2(rok)     // procedura w lib.prg
      CASE odpow == '0'
         SET COLOR TO
         EXIT
   OTHERWISE
         ALERT('Nieprzylaczona procedura')
   ENDCASE
ENDDO
SET COLOR TO
CLOSE DATABASES
CLEAR
RETURN