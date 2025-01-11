PROCEDURE zmiana
LOCAL odp 

@ 5,1 CLEAR TO 22,69
USE wyroby INDEX numer_wy, nazwa_wy NEW
GO BOTTOM

SET KEY -1 TO fakts2


DO WHILE .T.

   rahmen(.T.,.F.,.F.,.T.,.T.,.F.,'zmiana numeru wyrobu')

   m->numer_wy  := SPACE(8)
   m->nowy      := SPACE(8)
   odp := 'N'

   @ 7,9    SAY "Aktualny numer wyrobu............" GET m->numer_wy
   @ 9,9    SAY "Nowy numer wyrobu................" GET m->nowy VALID .NOT. EMPTY(m->nowy)
   READ

   IF LASTKEY() == 27
      CLOSE DATABASES
      RETURN      
   ENDIF
   SET INDEX TO numer_wy, nazwa_wy

   IF .NOT. DBSEEK(m->numer_wy)  
      ALERT('aktualny numer wyrobu nie zostal odnaleziony')
      LOOP
   ENDIF

   @ 11,9 SAY "Wyrob o numerze "+m->numer_wy +" zostanie przepisany na "+m->nowy
   @ 14,9 SAY "wykonac (T/N)..................." GET odp 
   READ

   CLOSE DATABASES

   IF UPPER(odp) == "T" 

      @ 15,9 SAY CHR(219)

      // zmiana w pliku wyroby

      USE wyroby
      GO TOP
      DO WHILE .NOT. EOF()
         IF numer_wy == m->numer_wy
            REPLACE numer_wy WITH m->nowy
         ENDIF
         SKIP
      ENDDO
      USE
      @ 15,11 SAY CHR(219)

// zmiana w pliku operacje

      USE Operacje 
      GO TOP
      DO WHILE .NOT. EOF()
         IF Wyrob_Nr == m->numer_wy
            REPLACE Wyrob_Nr WITH m->nowy
         ENDIF
         SKIP
      ENDDO
      USE
      @ 15,13 SAY CHR(219)

// zmiana w pliku Rejestr

      USE rejestr
      GO TOP
      DO WHILE .NOT. EOF()
         IF Wyrob == m->numer_wy
            REPLACE Wyrob WITH m->nowy
         ENDIF
         SKIP
      ENDDO
      USE
      @ 15,15 SAY CHR(219)

// zmiana w pliku zlecenia

      USE zlecenia
      GO TOP
      DO WHILE .NOT. EOF()
         IF Wyrob == m->numer_wy
            REPLACE Wyrob WITH m->nowy
         ENDIF
         SKIP
      ENDDO
      USE
      @ 15,17 SAY CHR(219)

// zmiana w archiwum

      USE Archiv
      GO TOP
      DO WHILE .NOT. EOF()
         IF Wyrob == m->numer_wy
            REPLACE Wyrob WITH m->nowy
         ENDIF
         SKIP
      ENDDO
      USE
      @ 17,17 SAY CHR(219)
      

   ENDIF


ENDDO

DO REO

SET KEY -1 TO

RETURN
