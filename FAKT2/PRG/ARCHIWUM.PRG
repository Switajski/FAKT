PROCEDURE Archiwum
#include  "def.ch"
PUBLIC Razem
PUBLIC fakt_num, Rach_Nr, Fakt_Dat, Dostawa

USE &path0
m->Rach_Nr := Rachunek
USE

rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'Archiwowanie wysylek')

************* wbudowane ******************************************

USE Faktury
GO BOTTOM
m->fakt_num := fakt_num
USE

SET KEY -1 TO fakts2

@  8,20 SAY "Numer Wysylki........." GET m->fakt_num PICTURE '99999' VALID (m->fakt_num > 0)
READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

USE zamow NEW
USE FAKTURY INDEX Fa_Numer   NEW

IF .NOT. DBSEEK(m->fakt_num)
   ALERT('Nieznana Wysylka')
   CLOSE DATABASES
   RETURN
ELSE
   m->Kli_Numer := Kli_Numer
ENDIF


SET INDEX TO
SET FILTER TO m->fakt_num == fakt_num
GO TOP

DO WHILE .NOT. EOF()
   IF rachunek == 0
      IF ALERT('Rachunek polski nie zostal opracowany, mimo to archiwowac ?',{'nie','tak'}) == 1
          CLOSE DATABASES
         RETURN
      ELSE
         EXIT
      ENDIF
   ENDIF
   SKIP
ENDDO

GO TOP

CLEAR

DO WHILE .NOT. EOF()

   m->Zamowienie:= zamowienie
   m->zam_poz   := zam_poz
   m->Ilosc     := ilosc
   m->fakt_dat  := fakt_dat

///////////////////////////////////////

   SELECT zamow

   GO TOP

   DO WHILE .NOT. EOF()


      IF ALLTRIM(m->Zamowienie) == ALLTRIM(zamow->zamowienie) .AND. m->zam_poz == zamow->zam_poz

         ?  '  zamowienie:'+ALLTRIM(zamowienie)
         ?? '  poz. '+STR(zam_poz,3,0)
         ?? '  ArtNr: '+Art_Nr
         ?? '  Ilosc: '+STR(m->Ilosc,3,0)+' na ' +STR(ilosc,3,0)
         REPLACE  wykonanie WITH m->Ilosc+wykonanie
         REPLACE  fakt_num  WITH m->fakt_num
         REPLACE  fakt_dat  WITH m->fakt_dat

      ENDIF

      SKIP

   ENDDO


///////////////////////////////////////

   SELECT Faktury

   SKIP

ENDDO

CLOSE DATABASES
DELETE FILE 'temp3.dbf'
USE archiv
APPEND FROM Faktury FOR m->fakt_num == fakt_num


USE faktury
GO TOP
DO WHILE .NOT. EOF()
   IF fakt_num == m->fakt_num
      DELETE
   ENDIF
   SKIP
ENDDO

CLOSE DATABASES
RETURN