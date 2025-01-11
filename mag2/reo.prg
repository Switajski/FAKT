PROCEDURE REO
PRIVATE Art2 , nowa_cena
Rahmen(.F.,.F.,.F.,.F.,.T.,.F.,"Reorganizacja Plikow")

USE Magazyn Exclusive
//GO TOP
//DO WHILE .NOT. EOF()
//   IF Art_NR == 'DPUC'
//      REPLACE Art_Nr WITH 'DP01'
//   ENDIF
//   SKIP
//ENDDO

GO TOP
m->zapis := 1

DO WHILE .NOT. EOF()
//  IF zapis == 0
//     DELETE
//  ENDIF
  REPLACE zapis WITH m->zapis
  SKIP
  m->zapis ++
ENDDO

//append from magazyn2

PACK
INDEX ON zapis TO zapis DESCENDING
USE

USE ustaw
m->kurs := kurs
USE

USE Materialy EXCLUSIVE
GO TOP
DO WHILE .NOT. EOF()
IF cena_eur > 0
   nowa_cena := cena_eur * m->kurs
   REPLACE cena WITH nowa_cena
ENDIF
SKIP
ENDDO

pack
INDEX ON Nazwa  TO Nazwa
INDEX ON Art_Nr TO MatNr
USE

USE Dostawcy EXCLUSIVE
pack
INDEX ON Dostawca TO Dostawca
INDEX ON Firma    TO Firma
USE

USE Towary EXCLUSIVE

// Zmiana numeru materialu
//GO TOP
//DO WHILE .NOT. EOF()
//   IF Mat_ArtNR == 'DPUC'
//      REPLACE Mat_ArtNr WITH 'DP01'
//   ENDIF
//   SKIP
//ENDDO

pack
INDEX ON pos       TO Pozycja
INDEX ON Tow_ArtNr TO wyrob UNIQUE
USE

@ 10,10 SAY "prosze czekac, trwa aktualizacja wyrobow"

RETURN

//USE &Art
//IF Used()
//   COPY STRUCTURE TO temp.dbf
//   USE
//   IF .NOT. FExists("temp.dbf")
//      ALERT("Generowanie pliku artykulow nie powiodlo sie;Prosze sprawdzic polaczenie do internetu i sciezke aktualizacji artykulow")
//      CLOSE DATABASES
//      RETURN
//   ENDIF

//   USE temp.dbf
//   APPEND FROM &path1
//   COMMIT
//   USE
//   Art2 := ALLTRIM(path2)+"\artykuly.dbf"
//   COPY FILE temp.dbf TO &Art2
//   DELETE FILE temp.dbf
//   @ 12,10 SAY "Reorganizacja plikow przeprowadzona"
//ELSE

//   ALERT('Aktualizacja Artykulow nie powiodla sie',{'O.K.'})

//ENDIF

//RETURN