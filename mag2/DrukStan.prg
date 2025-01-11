PROCEDURE DrukStan
LOCAL sPrzychod, sRozchod, Stan, i, nWartosc, nRazem, data_do, Jezyk
//#include "def.ch"
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wydruk stanow Magazynowych')
SET KEY -1 TO FAKTS2
********************** NAGLOWEK *********************************
m->grupa := SPACE(4)
m->data_do    := DATE()
Jezyk := 'P'

@ 10,7 SAY 'Wydruk stanow dla grupy (pusty - wydruk wszystkich grup)....' GET m->grupa
@ 12,7 SAY 'Wydruk stanow do dnia.......................................' GET m->data_do
@ 14,7 SAY 'Jezyk wydruku (P)L/(D)E.....................................' GET Jezyk VALID Jezyk == 'P' .OR. Jezyk == 'D'
READ

IF LASTKEY()==27
   RETURN
ENDIF

@ 16,7 SAY 'Prosze czekac, trwa wydruk stanow magazynowych'
i      := 1
nRazem := 0

SET CONSOLE OFF
SET PRINTER TO temp.txt
SET DEVICE  TO PRINTER
SET PRINTER ON

IF Jezyk == 'P'

   ?  'Stany Magazynowe na dzien: '
   ?? DTOC(m->data_do)
   ?? '  dla grupy: '+ m->grupa
ELSE
   ?  'Lagerbest�nde zum '
   ?? DTOC(m->data_do)
   ?? 'fuer die Gruppe: '+m->grupa
ENDIF

   ?
IF Jezyk == 'P'
   ?  'L.P.   Nr.  Nazwa Materialu'+SPACE(49)+'Przychod   Rozchod     Stan j.m.    Cena    Wartosc'
ELSE

   ?  'Pos.   Nr.  Bezeichnung    '+SPACE(49)+'Eingang    Verbrauch   Bestand      Preis PLN  Wert'
ENDIF

?  REPLICATE('_',127)

USE Magazyn   NEW
USE Materialy NEW
IF .NOT. EMPTY(m->Grupa)
   SET FILTER TO Grupa == m->Grupa
ENDIF
SET INDEX TO MatNr



GO TOP

DO WHILE .NOT. EOF()
   SELECT materialy
   m->Cena      := Cena
   IF Jezyk == 'P'
      m->Nazwa     := Nazwa
      m->Jednostka := Jednostka
   ELSE
      m->Nazwa     := Bezeichn
      m->Jednostka := Einheit
   ENDIF
   m->Art_Nr    := Art_Nr

   DO WHILE .NOT. EOF()
      SELECT Magazyn
      SUM Przychod, Rozchod TO sPrzychod, sRozchod FOR Art_Nr == m->Art_Nr .AND. DATA <= m->data_do
      Stan  := sPrzychod - sRozchod
      nWartosc := ROUND(m->Cena * Stan,2)

      ? STR(i,5,0)
      ?? '. '+m->Art_Nr
      ?? ' '+LEFT(m->Nazwa,60)
//      ?? ' '+LEFT(m->Bezeichn,60)
      ?? ' '+STR(sPrzychod,10,2)
      ?? STR(sRozchod,10,2)
      ?? STR(Stan,10,2)
      ?? ' '+m->Jednostka
      ?? ' '+STR(m->Cena,8,2)
      ?? ' '+STR(nWartosc,10,2)
      nRazem := nRazem + nWartosc
      SKIP
      i++
   ENDDO
   SELECT Materialy
   SKIP
ENDDO
IF Jezyk == 'P'
   ?  SPACE(100)+'___________________________'
   ? '       Razem Wartosc materialow = '+SPACE(83)+STR(nRazem,10,2)
ENDIF

SET PRINTER TO
SET CONSOLE ON
SET DEVICE TO SCREEN
SET PRINTER OFF
CLOSE DATABASES

// ? RunShell( "temp.txt", path4, .T. )

RETURN