PROCEDURE Zam_NZ
#include  "def.ch"
PRIVATE opcja

SET KEY -1 TO fakts2

opcja := 1

rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'Kontrola Zamowien')

@ 10,20 SAY "Otwarte Zamowienia      - Ekran....(1)"
@ 11,20 SAY "Otwarte Zamowienia      - Plik.....(2)"

@ 12,20 SAY "Otwarte Zamowienia DE   - Plik.....(3)"
@ 14,20 SAY "Potwierdzenie Zamowienia- Plik.....(4)"
@ 15,20 SAY "Zamowiena wg Art. Nr....- Plik.....(5)"
@ 16,20 SAY "Plan do krojowni wg grup- Plik.....(6)"

@ 18,20 SAY "                             Opcja:" GET opcja PICTURE("9")

READ

DO CASE

   CASE opcja == 1
      DO Zam_Ekran
   CASE opcja == 2
      DO NZ_Print
   CASE opcja == 3
      DO NZDPrint
   CASE opcja == 4
      DO PotwZamow
   CASE opcja == 5
      DO plan
   CASE opcja == 6
      DO grupy

ENDCASE
RETURN





PROCEDURE Zam_Ekran
PRIVATE Spalty, formaty, opisy
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'Kontrola Zamowien')

m->Kli_Numer := 0

@ 12,12 SAY 'Zamowienia od klienta nr (0 dla wszystkich)....' GET m->Kli_Numer PICTURE '99999' VALID egsist(m->Kli_Numer).OR. m->Kli_Numer == 0
READ

IF LASTKEY() == 27
   RETURN
ENDIF

USE Zamow
IF m->Kli_Numer <> 0
   SET FILTER TO wykonanie <> Ilosc .AND. Kli_Numer == m->Kli_Numer
ELSE
   SET FILTER TO wykonanie <> Ilosc
ENDIF

INDEX ON STR(KW,2,0)+zamowienie TO KW
SET INDEX TO KW

spalty :={"Kli_Numer","KW","Zamowienie","Zam_Poz","Art_Nr","Ilosc","Wykonanie"}
formaty:= {"999999","99","AAAAAAAAAAA","99","AAAAAAAAAAA","9999","9999"}
opisy  := {"Klient","Tydzien","zamowienie","poz","Art.Nr","Zamowione","Wykonano"}

DBEDIT(0,0,24,79,spalty,,formaty,opisy)

CLOSE DATABASES
RETURN

//////////////////////////////////////////////////////////////////////////////////////////////////////////


PROCEDURE NZ_Print

//USE Zamow NEW
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'Kontrola Zamowien')

m->Kli_Numer := 0

@ 12,12 SAY 'Zamowienia od klienta nr (0 dla wszystkich)....' GET m->Kli_Numer PICTURE '99999' VALID egsist(m->Kli_Numer).OR. m->Kli_Numer == 0
READ

IF LASTKEY() == 27
   RETURN
ENDIF

USE Zamow NEW

IF m->Kli_Numer <> 0
   SET FILTER TO wykonanie <> Ilosc .AND. Kli_Numer == m->Kli_Numer
ELSE
   SET FILTER TO wykonanie <> Ilosc
ENDIF


INDEX ON STR(KW,2,0)+zamowienie TO KW
SET INDEX TO KW
SET MARGIN TO 0

SET PRINTER TO temp.txt
SET DEVICE  TO printer
SET PRINTER ON
SET CONSOLE OFF

GO TOP
? "Klient  Zamowienie  Poz.              Nazwa Wyrobu                        Art.Nr.       Za.  Otw."
? REPLICATE("-",98)

? SPACE(37)+ STR(zamow->KW,3,0) + " Tydzien Roku                     Art.Nr.       Za.  Otw. "
? REPLICATE("-",98)


DO WHILE .NOT. EOF()
   m->KW := KW
//   ?  STR(KW,2,0)
   ?  STR(Kli_Numer,6,0)
   ?? "  "+Zamowienie
   ?? STR(Zam_Poz,3,0)

   ?? " "+Nazwa1
   ?? " "+Art_Nr
   ?? STR(Ilosc,6,0)
   ?? STR(Ilosc-Wykonanie,6,0)

   IF .NOT. EMPTY(Nazwa2)
      ? SPACE(23)+Nazwa2
   ENDIF

   IF .NOT. EMPTY(Nazwa3)
      ? SPACE(23)+Nazwa3
   ENDIF

   SKIP
   IF KW <> m->KW .AND. KW <> 0
      m->KW := KW
      ?
      ?
      ? SPACE(37)+ STR(KW,3,0) + " Tydzien Roku                     Art.Nr.       Za.  Otw. "
      ? REPLICATE("-",98)
   ELSE
      ?
   ENDIF
ENDDO
USE
SET DEVICE TO SCREEN
SET PRINTER OFF
SET PRINTER TO
SET CONSOLE ON
// RunShell( 'temp.txt', path4)
RETURN

////////////////////////////////////////////////////////////


PROCEDURE NZDPrint

//USE Zamow NEW
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'Kontrola Zamowien')

m->Kli_Numer := 0

@ 12,12 SAY 'Zamowienia od klienta nr (0 dla wszystkich)....' GET m->Kli_Numer PICTURE '99999' VALID egsist(m->Kli_Numer).OR. m->Kli_Numer == 0
READ

IF LASTKEY() == 27
   RETURN
ENDIF

USE Zamow NEW

IF m->Kli_Numer <> 0
   SET FILTER TO wykonanie <> Ilosc .AND. Kli_Numer == m->Kli_Numer
ELSE
   SET FILTER TO wykonanie <> Ilosc
ENDIF


INDEX ON STR(KW,2,0)+zamowienie TO KW
SET INDEX TO KW
SET MARGIN TO 0

SET PRINTER TO 'temp.txt'
SET DEVICE  TO printer
SET PRINTER ON
SET CONSOLE OFF

GO TOP
? "Bestellung  Pos.              Bezeichnung                           Art.Nr. Bestellt Offen"
? REPLICATE("-",90)

? SPACE(29)+ STR(zamow->KW,3,0) + " Kalenderwoche                      Art.Nr. Bestellt Offen"
? REPLICATE("-",90)


DO WHILE .NOT. EOF()
   m->KW := KW
//   ?  STR(KW,2,0)

   ?  Zamowienie
   ?? STR(Zam_Poz,3,0)

   ?? "  "+Bezeichn1
   ?? "  "+Art_Nr
   ?? STR(Ilosc,6,0)
   ?? STR(Ilosc-Wykonanie,6,0)

   IF .NOT. EMPTY(Bezeichn2)
      ? SPACE(16)+Bezeichn2
   ENDIF

   IF .NOT. EMPTY(Nazwa3)
      ? SPACE(16)+Bezeichn3
   ENDIF

   SKIP
   IF KW <> m->KW .AND. KW <> 0
      m->KW := KW
      ?
      ?
      ? SPACE(29)+ STR(KW,3,0) + " Kalenderwoche                      Art.Nr. Bestellt Offen"
      ? REPLICATE("-",90)
   ELSE
      ?
   ENDIF
ENDDO
USE
SET DEVICE TO SCREEN
SET PRINTER OFF
SET PRINTER TO
// RunShell( 'temp.txt', path4)
RETURN



/////////////////////////////////////////////////////////////

PROCEDURE PotwZamow
PRIVATE odstep

SET KEY -1 TO FAKTS2
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'Potwierdzenie Zamowienia')
m->Zamowienie := SPACE(11)
//m->Kli_Numer := 0

@ 10,20 SAY "Numer Zamowienia....." GET m->Zamowienie
//@ 12,20 SAY "Numer Klienta........" GET m->Kli_Numer PICTURE '99999' VALID m->Kli_Numer > 0
READ

IF LASTKEY() == 27

   CLOSE DATABASES
   RETURN

ENDIF

USE zamow
LOCATE FOR m->Zamowienie == Zamowienie
IF FOUND()
   m->Kli_Numer := Kli_Numer
ELSE
   ALERT('Klient nieznany')
   USE
   RETURN
ENDIF


USE klienci
LOCATE FOR Kli_Numer == m->Kli_Numer
IF .NOT. FOUND()
   ALERT('Nieznany Klient')
   CLOSE DATABASES
   RETURN
ELSE
   ALERT('Odnaleziony Klient Nr:'+STR(m->Kli_Numer,5,0))
ENDIF

SET PRINTER TO 'temp.txt'
SET DEVICE  TO PRINTER
SET PRINTER ON
SET CONSOLE OFF

?
?
?
?
?
?

Odstep := 5

? SPACE(Odstep)+Kli_Nazwa1
? SPACE(Odstep)+Kli_Nazwa2
? SPACE(Odstep)+Kli_Ulica
? SPACE(Odstep)+ALLTRIM(Kli_PLZ)+' '+ALLTRIM(Kli_Ort  )

?
?
?

? '           AUFTRAGBESTAETIGUNG Nr.: '+ALLTRIM(m->Zamowienie)
? '           Datum:'+DTOC(DATE())
?
?

USE Zamow
SET FILTER TO Zamowienie == m->Zamowienie
SET INDEX  TO Zam_Poz

?
? 'Pos. Art. Nr.   Artikelbezeichnung                                     Menge  Preis  LW'
? REPLICATE("_",87)

DO WHILE .NOT. EOF()

   ?  str(Zam_poz,3,0)+'. '
   ?? Art_Nr
   ?? ' '+Bezeichn1

   IF .NOT. EMPTY(Bezeichn2)
      ? SPACE(16)+Bezeichn2
   ENDIF

   IF .NOT. EMPTY(Bezeichn3)
      ? SPACE(16)+BEZEICHN3
   ENDIF

   ?? Ilosc
   ?? str(Cena_Klien,7,2)+'  '
   ?? STR(KW,2,0)
   ?
   SKIP

ENDDO
SET DEVICE TO SCREEN
SET PRINTER OFF
SET PRINTER TO
SET CONSOLE ON
USE
SET KEY -1 TO
// RunShell( 'temp.txt', path4)
RETURN


/////////////////////////////////////////////////////////////////////////////////////////////////


PROCEDURE PLAN

USE Zamow
SET FILTER TO wykonanie < ilosc
INDEX ON STR(KW,2,0)+Art_Nr+zamowienie TO KWA
SET INDEX TO KWA
SET MARGIN TO 0

SET PRINTER TO 'temp.txt'
SET DEVICE  TO printer
SET PRINTER ON
SET CONSOLE OFF

GO TOP

? "Art. Nr.  Zamowione Wykonane      Nazwa                                   Klient  Zamow/Poz."
? REPLICATE("-",90)


?
? SPACE(37)+STR(KW,3,0)+" Tydzien Roku "

DO WHILE .NOT. EOF()
   m->KW := KW
//   ?  STR(KW,2,0)

   ?  Art_Nr
   ?? STR(Ilosc,8,2)
   ?? STR(Wykonanie,8,2)
   ?? "  "+Nazwa1
   ?? STR(kli_numer,2,0)
   ?? " "+ALLTRIM(Zamowienie)
   ?? "/"+STR(Zam_Poz,2,0)


   SKIP
   IF KW <> m->KW .AND. KW <> 0
      m->KW := KW
      ?
      ?
      ? SPACE(37)+ STR(KW,3,0) + " Tydzien Roku "
      ? REPLICATE("-",90)
   ELSE
      ?
   ENDIF
ENDDO
USE
SET DEVICE TO SCREEN
SET PRINTER OFF
SET PRINTER TO
// RunShell( 'temp.txt', path4)
RETURN



PROCEDURE grupy
PRIVATE dlugosc,z_suma,w_suma, wierszy

rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wydruk grup wyrobow')

SET KEY -1 TO fakts2

m->Art_NR := SPACE(11)
wierszy   := 3
odstep    := 'T'

@  8,5 SAY 'Otwarte zamowienia dla krojowni (pierwsze znaki Art.Nr.)...' GET m->Art_Nr
@ 10,5 SAY 'Ilosc wierszy opisu 1,2 lub 3 .............................' GET wierszy PICTURE "9" valid wierszy > 0 .AND. wierszy < 4
@ 12,5 SAY 'Odstep pomiedzy pozycjami (T)ak (Nie)......................' GET odstep  PICTURE 'A'
READ

IF LASTKEY() == 27
   CLOSE DATABASES
   RETURN
ENDIF

dlugosc := LEN(ALLTRIM(m->Art_Nr))


USE Zamow
SET FILTER TO wykonanie < ilosc
INDEX ON Art_Nr+STR(KW,2,0)+zamowienie TO KWB
SET INDEX TO KWB
SET MARGIN TO 0

SET PRINTER TO 'temp.txt'
SET DEVICE  TO printer
SET PRINTER ON
SET CONSOLE OFF

GO TOP

w_suma := 0
z_suma := 0

? "Otwarte zamowienia dla grupy wyrobow :"+m->Art_Nr
? "Stan na dzien:"
?? DATE()
?
? "Art. Nr.  Zamowione Wykonane Tydz.     Nazwa                                   Klient  Zamow/Poz."
? REPLICATE("-",96)


DO WHILE .NOT. EOF()

   IF ALLTRIM(LEFT(Art_Nr,dlugosc))==ALLTRIM(m->Art_Nr)
      IF UPPER(odstep) == 'T'
         ?
      ENDIF

      ?  Art_Nr
      ?? STR(Ilosc,8,2)
      ?? STR(Wykonanie,8,2)
      ?? '    '+STR(KW,2,0)
      ?? "  "+Nazwa1
      ?? STR(kli_numer,2,0)
      ?? " "+ALLTRIM(Zamowienie)
      ?? "/"+STR(Zam_Poz,2,0)

      IF wierszy > 1 .AND. .NOT. EMPTY(Nazwa2)
         ? SPACE(34)+Nazwa2
      ENDIF

      IF wierszy > 2 .AND. .NOT. EMPTY(Nazwa3)
         ? SPACE(34)+Nazwa3
      ENDIF

      w_suma := w_suma+wykonanie
      z_suma := z_suma+ilosc
   ENDIF

   SKIP
ENDDO

?  REPLICATE("-",96)
? 'Razem zamowione       :'+STR(z_suma,8,0)
? 'Razem wykonanych      :'+STR(w_suma,8,0)
? 'Pozostaje do wykonania:'+STR(z_suma-w_suma,8,0)

USE
SET DEVICE TO SCREEN
SET PRINTER OFF
SET PRINTER TO
SET CONSOLE ON
// RunShell( 'temp.txt', path4)
RETURN


