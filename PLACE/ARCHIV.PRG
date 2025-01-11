PROCEDURE archiv
//PUBLIC od, DO ,zlecenie

@ 5,1 CLEAR TO 22,69
USE Archiv   NEW

USE zlecenia NEW //INDEX z_numer NEW
GO TOP

SET KEY -1 TO fakts2

rahmen(.T.,.F.,.F.,.T.,.T.,.F.,'archiwowanie')

decyzja := "N"
@ 10,15 SAY "Uwaga ! - wszystkie nieaktywne zlecenia beda usuniete"
@ 12,15 SAY "czy na pewno przeprowadzic archiwizacje ?  T/N " GET decyzja
READ

IF LASTKEY() == 27 .OR. UPPER(decyzja) <> "T"
   CLOSE DATABASES
   RETURN
ENDIF

GO TOP

@ 5,5 SAY 'prosze czekac, trwa archiwowanie' COLOR farb4
CLEAR

DO WHILE .NOT. EOF()

IF ALLTRIM(zlecenia->aktywne) == "N"
      m->zlecenie := zlecenie
      m->data := data
      m->ilosc:= ilosc
      m->wyrob:= wyrob

      ?  m->data
      ?? '   '
      ?? m->zlecenie
      ?? '   '
      ?? m->ilosc
      ?? ' szt. '
      ?? m->wyrob
      REPLACE L_Marke WITH .T.

      SELECT archiv
      APPEND FROM rejestr FOR m->zlecenie == zlecenie
   ELSE
      REPLACE L_Marke WITH .F.
   ENDIF

   SELECT zlecenia
   SKIP
ENDDO

CLOSE DATABASES
DO gaszenie
DO reo
DO czysto
DO reo
RETURN


PROCEDURE gaszenie

@ 5,1 CLEAR TO 22,69

USE rejestr  NEW //INDEX LP, OperacLP,LPDGM NEW
USE zlecenia NEW //INDEX z_numer NEW
GO TOP

SET KEY -1 TO fakts2

rahmen(.T.,.F.,.F.,.T.,.T.,.F.,'gaszenie')


GO TOP

@ 5,5 SAY 'prosze czekac, trwa gaszenie zarchiwowanych danych' COLOR farb4

DO WHILE .NOT. EOF()

   IF L_Marke == .T.
      m->zlecenie := zlecenie
      m->data := data
      m->ilosc:= ilosc
      m->wyrob:= wyrob

      ?  m->data
      ?? '   '
      ?? m->zlecenie
      ?? '   '
      ?? m->ilosc
      ?? ' szt. '
      ?? m->wyrob
      DELETE
      SELECT rejestr
      DELETE ALL FOR ALLTRIM(m->zlecenie) == ALLTRIM(zlecenie)

   ENDIF
   SELECT zlecenia
   SKIP
ENDDO

CLOSE DATABASES
RETURN

PROCEDURE czysto

@ 5,1 CLEAR TO 22,69

USE rejestr  NEW //INDEX LP, OperacLP,LPDGM NEW
USE zlecenia INDEX z_numer NEW
GO TOP

SET KEY -1 TO fakts2

rahmen(.T.,.F.,.F.,.T.,.T.,.F.,'gaszenie')

GO TOP

@ 5,5 SAY 'prosze czekac, trwa czysczenie zapisow bez zlecen' COLOR farb4

DO WHILE .NOT. EOF()
   SELECT zlecenia
   IF .NOT. DBSEEK(rejestr->zlecenie)
      SELECT rejestr
      m->zlecenie := zlecenie
      m->data := data
      m->ilosc:= ilosc
      m->wyrob:= wyrob

      ?  m->data
      ?? '   '
      ?? m->zlecenie
      ?? '   '
      ?? m->ilosc
      ?? ' szt. '
      ?? m->wyrob
      DELETE
   ENDIF
   SELECT rejestr
   SKIP
ENDDO
CLOSE DATABASES
RETURN
