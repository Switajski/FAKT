PROCEDURE dr_zlece
//#include "def.ch"


rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'rozliczenie zlecenia')

m->zlecenie := SPACE(10)
SET KEY -1 TO fakts2
SETFUNCTION(9,CHR(27))

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
m->ilosc      := ilosc
m->operacja   := 0
m->wyrob      := wyrob
m->suma       := 0
DrukujSume    := .F.
DlugoscStrony := 60
Strona        := 1
lp            := lp
USE


USE Wyroby NEW
SET INDEX TO numer_wy

USE Operacje NEW

USE pracowni NEW
SET INDEX TO p_numer

USE rejestr NEW
SET INDEX TO OperacLP

SET PRINTER TO temp.txt
SET PRINTER ON
SET CONSOLE OFF

glowka(Strona)

SELECT rejestr
DBGOTOP()

DO WHILE .NOT. EOF()

   IF m->zlecenie == zlecenie

      IF operacja <> m->operacja
         m->operacja := operacja
         DrukujSume := .T.

         IF PROW() > DlugoscStrony
            Strona++
            Glowka(Strona)
         ENDIF

         ?  '  '+ALLTRIM(STR(operacja,6,0))+'. '+NazwaOperacji(m->wyrob,m->operacja)
      ENDIF


      IF PROW() > DlugoscStrony
         Strona++
         Glowka(Strona)
      ENDIF

      ?  '      - zapis: '+STR(rejestr->lp,6,0)+'. '
      ?? DTOC(data)
      ?? STR(rejestr->ilosc,6)+' szt. '
      ?? PracSzukany(rejestr->p_numer)
      Suma := Suma+ilosc

   ENDIF
   SKIP

   IF m->operacja <> Operacja .AND. DrukujSume

      IF m->Suma > m->ilosc
         SETCOLOR(farb5)
      ELSE
         SETCOLOR(farb4)
      ENDIF

      IF PROW() > DlugoscStrony
         Strona++
         Glowka(Strona)
      ENDIF

      ? '     Suma wykonanych operacji :'+STR(m->Suma,6,0)+' szt. na ' +ALLTRIM(STR(m->ilosc))+' zleconych'
      IF m->Suma > m->ilosc
         ?? '   !!!!!!!!!!'
      ENDIF

      ? ''
      SETCOLOR(farb1)
      m->Suma := 0
      IF m->zlecenie <> zlecenie
         DrukujSume := .F.
      ENDIF
    ENDIF

ENDDO


EJECT
SET PRINTER TO
SET PRINTER OFF
SET CONSOLE ON
CLOSE DATABASES
SET MARGIN TO 0
SETFUNCTION(9,CHR(27))
RunShell( "temp.txt", path4)
RETURN

FUNCTION Glowka(Strona)
? "  rozliczenie zlecenia Nr: "+ALLTRIM(m->zlecenie)
?? '                        Strona: '+ALLTRIM(STR(Strona))
SELECT wyroby

IF DBSEEK(m->wyrob)
    ? "  Nazwa wyrobu: "+nazwa+"Ilosc sztuk: "+ALLTRIM(STR(m->ilosc))
    ? "  Numer wyrobu: "+numer_wy
ELSE
    ? "  Nazwa wyrobu nie zostala odnaleziona"
ENDIF
?  '  '+REPLICATE('_',72)
RETURN NIL
