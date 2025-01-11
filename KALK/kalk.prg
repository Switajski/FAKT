PROCEDURE main
PUBLIC place, magazyn, path4, fakt, CenaKlient, Premia, KStale, KZmienne, KZakup, KSprzedaz, Kurs, bledy1, bledy2, filter
PUBLIC Yg, Xg, Yd, Xd, farb1, farb2, farb3, farb4, farb5

//StandartColor := "N/BG,W+/R,,,W+/B"

farb1:=  '7/b,  b/3'
farb2:=  'n/bg, bg/w'
farb3:=  'r/w,  r/w'
farb4:=  'gr+/b, gr+/b'
farb5:=  'gr+*/b,gr+*/b'

SetColor(farb1) //BG

Yg := 6
Xg := 2
Yd := 22
Xd := 77

USE KalkUstaw
place         := ALLTRIM(pplace)
magazyn       := ALLTRIM(pmagazyn)
fakt          := ALLTRIM(pfakt)
path4         := ALLTRIM(text)
Premia        := ppremia
KStale        := pKStale    // procent kosztow stalych naliczany do robocizny   "RobZPremia"
KZmienne      := pKZmienne  // procent kosztow zmiennych naliczany do robocizny "RobZPremia"
KZakup        := pKzakup    // procent kosztu zakupu materialow do produkcj naliczany do kosztu materialow
KSprzedaz     := pKSprzedaz // narzut do sprzedazy brany przez firme PFAU
Kurs          := pKurs

USE
filter := ''

DO WHILE .T.
   DO RAHMEN
   opcja := 1
   @  7,10 SAY 'Zestawienie kosztow i cen dla wszystkich wyrobow..1'
   @  9,10 SAY 'Kalkulacja dla okreslonego wyrobu.................2'
   @ 11,10 SAY 'Ustawienie parametrow programu....................3'
   @ 13,10 SAY 'Zakoncz program...................................0'

   @ 17,10 SAY 'Wybor Opcji.....................................' GET opcja PICTURE '99'
   READ

   IF LASTKEY() == 27
      EXIT
   ENDIF

   DO CASE
      CASE opcja == 0
         RETURN
      CASE opcja == 1
         DO zestawienie
      CASE opcja == 2
         DO Jednostka
      CASE opcja == 3
         DO ustawienia
   OTHERWISE
      ALERT('Nieprzylaczona Procedura')
   ENDCASE
ENDDO
RETURN