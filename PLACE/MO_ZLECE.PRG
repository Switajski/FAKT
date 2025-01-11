PROCEDURE mo_zlece
#include "def.ch"

rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'rozliczenie zlecenia')

m->zlecenie := SPACE(10)
SET KEY -1 TO fakts2

USE zlecenia
SET INDEX TO z_numer


@ 7,9    SAY "zlecenie Nr:........" GET m->zlecenie VALID DBSEEK(m->zlecenie)
READ


IF LASTKEY() == 27
   USE
   RETURN
ENDIF

USE zlecenia
SET INDEX TO z_numer
IF DBSEEK(m->zlecenie)
   m->ilosc := ilosc
ELSE
   ALERT('Wyrob nieodnaleziony')
ENDIF
m->ilosc    := ilosc
m->operacja := 0
m->wyrob    := wyrob
m->suma     := 0
DrukujSume  := .F.
USE


USE Wyroby NEW
SET INDEX TO numer_wy

USE Operacje NEW

USE pracowni NEW
SET INDEX TO p_numer

USE rejestr NEW
SET INDEX TO OperacLP

SET PRINTER ON
SET CONSOLE OFF
SET PRINTER TO temp.txt

@ 0,0 CLEAR TO 24,79

? "  rozliczenie zlecenia Nr: "+ALLTRIM(m->zlecenie)

SELECT wyroby

IF DBSEEK(m->wyrob)
    ? "  Nazwa wyrobu: "+nazwa+"Ilosc sztuk: "+ALLTRIM(STR(m->ilosc))
ELSE
    ? "  Nazwa wyrobu nie zostala odnaleziona"
ENDIF

SELECT rejestr

DBGOTOP()

? REPLICATE('_',75)

DO WHILE .NOT. EOF()

   IF m->zlecenie == zlecenie

      IF operacja <> m->operacja
         m->operacja := operacja
         DrukujSume := .T.
         ?  '  '+ALLTRIM(STR(operacja,6,0))+'. '+NazwaOperacji(m->wyrob,m->operacja)
      ENDIF

      ?  '      - zapis: '+STR(lp,6,0)+'. '
      ?? DTOC(data)
      ?? STR(ilosc,6)+' szt. '
      ?? PracSzukany(p_numer)
      Suma := Suma+ilosc

   ENDIF
   SKIP

   IF m->operacja <> Operacja .AND. DrukujSume

      ? '     Suma wykonanych operacji :'+STR(m->Suma,6,0)+' szt. na ' +ALLTRIM(STR(m->ilosc))+' zleconych'
      IF m->Suma > m->ilosc
         ? '???!!!'
      ENDIF

      ? ''
      m->Suma := 0
      IF m->zlecenie <> zlecenie
         DrukujSume := .F.
      ENDIF
    ENDIF

ENDDO

? '     ***************    KONIEC  **************** '

// EJECT
SET PRINTER OFF
SET CONSOLE ON
SET PRINTER TO
RunShell( "temp.txt", path4)
CLOSE DATABASES
SET MARGIN TO 0
RETURN