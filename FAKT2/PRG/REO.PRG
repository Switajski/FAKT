// PROCEDURE reo
#include "def.ch"
PRIVATE korekta, rek

USE Faktury EXCLUSIVE
PACK
INDEX ON fakt_num TO fa_numer UNIQUE
INDEX ON fakt_num + poz TO fakt_poz
INDEX ON art_nr  TO art_num
USE


//przenosi rachunek z archiwum do Faktur


Korekta := 0

IF korekta > 0

   USE FAKTURY
   APPEND FROM ARCHIV FOR Fakt_Num == korekta
   USE

   USE Archiv EXCLUSIVE
   GO TOP

   DO WHILE .NOT. EOF()
      IF Fakt_Num == korekta
         DELETE
      ENDIF
   SKIP
   ENDDO
   PACK
   USE

ENDIF


// wygaszanie rekordow z archiwum

rek := 0

IF rek > 0
   USE archiv EXCLUSIVE
   DO WHILE .NOT. EOF()
      IF RECNO() <= rek
         DELETE
      ENDIF
      SKIP
   ENDDO
   PACK
   USE
ENDIF
USE Klienci EXCLUSIVE
PACK
INDEX ON kli_Ort   to Ort
INDEX ON kli_numer TO kl_numer
USE

USE Artykuly EXCLUSIVE
PACK
INDEX ON numer TO Ar_numer
INDEX ON Nazwa1 TO Ar_nazwa
USE


USE zamow EXCLUSIVE
INDEX ON zamowienie TO zam UNIQUE
INDEX ON zamowienie +STR(zam_poz) TO zam_poz
PACK
USE


USE magazyn EXCLUSIVE
INDEX ON Art_Nr TO Art_Nr
INDEX ON Nazwa  TO Mag_Nazw
PACK
USE

//wybdata := DATE() - 365
//wybor(wybdata)
//klient := 2
//NowaCena(klient)

RETURN

FUNCTION wybor(wybdata)
PRIVATE traf
USE ARCHIV NEW
USE artykuly NEW
GO TOP

ALERT("wybData:"+ DTOC(wybdata))
DO WHILE .NOT. EOF()
   m->numer := numer
   SELECT ARCHIV
   LOCATE FOR FAKT_DAT > wybdata .AND. m->numer == art_nr
   IF FOUND()
      traf := .T.
   ELSE
      traf := .F.
   ENDIF
   SELECT artykuly
   REPLACE activ WITH traf
   SKIP
ENDDO
CLOSE ALL
RETURN NIL

FUNCTION NowaCena(klient)
USE artykuly EXCLUSIVE
GO TOP
DO WHILE .NOT. EOF()
IF klient ==  kli_numer .AND. cena_2 > 0 .AND. activ
   REPLACE cena_klien WITH cena_2
ENDIF
SKIP
ENDDO
CLOSE ALL
RETURN NIL
