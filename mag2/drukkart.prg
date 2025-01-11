#include "inkey.ch"
#include "set.ch"

PROCEDURE drukKart
PRIVATE sPrzychod, sRozchod

sPrzychod := 0
sRozchod  := 0
sStan     := 0
m->ART_NR     := SPACE(4)
SET KEY -1 TO fakts2

DO WHILE .T.
   SETFUNCTION(9,CHR(27))
   rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wydruk kart magazynowych')

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
      m->nazwa      := nazwa
      m->jednostka  := jednostka
      m->dostawca   := dostawca
      m->cena       := cena
   ELSE
      ALERT('Neznany Material')
      CLOSE DATABASES
      RETURN
   ENDIF
   CLOSE DATABASES

   SET PRINTER TO temp.txt
   SET DEVICE  TO PRINTER
   SET PRINTER ON
   SET CONSOLE OFF

   USE Magazyn
   SET FILTER TO m->Art_Nr == Art_Nr
   SET INDEX TO Zapis

   ?  'Karta Magazynowa Materialu z dnia :'+DTOC(DATE())
   ?
   ?  'Numer Materialu :'+m->Art_Nr
   ?  'Nazwa Materialu :'+m->nazwa
   ?  'Dostawca        :'+m->dostawca
   ?  'Cena Zakupu     :'+STR(cena,8,2)+' za 1 '+Jednostka
   ?
   ?  'Zapis  Data      Opis                            Przychod       Rozchod          Stan'
   ?  REPLICATE('_',89)

   sPrzychod := 0
   sRozchod  := 0
   sStan     := 0

   DO WHILE .NOT. EOF()
      sPrzychod := sPrzychod+Przychod
      sRozchod  := sRozchod+Rozchod
      sStan     := sStan+Przychod-Rozchod

       ? STR(Zapis,5,0)
      ?? '  '+DTOC(Data)
      ?? '  '+opis
      ?? STR(Przychod,10,2)+' '+Jednostka
      ?? STR(Rozchod,10,2) +' '+Jednostka
      ?? STR(sStan,10,2)   +' '+Jednostka
      SKIP
   ENDDO

   ?  REPLICATE('_',89)
   ? '       Suma Przychodu Materialu:'+STR(sPrzychod,10,2)+" "+jednostka
   ? '       Suma Rozchodu  Materialu:'+STR(sRozchod,10,2) +" "+jednostka
   ? '       Stan Magazynowy         :'+STR(sPrzychod-sRozchod,10,2)+' '+Jednostka
   SET PRINTER TO
   SET CONSOLE ON
   SET DEVICE TO SCREEN
   SET PRINTER OFF
   // RunShell( "temp.txt", path4)   //"C:\programme\Windows NT\zubeh�r\WORDPAD.EXE", .T. )
ENDDO
CLOSE DATABASES
SETFUNCTION(9,'')
RETURN