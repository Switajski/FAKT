PROCEDURE ArchZam

PRIVATE licznik

licznik := 0

USE zamow2 EXCLUSIVE

//Utworzenie danych rekordów dotycz¹cych zamówienia w zamow2
APPEND FROM zamow FOR wykonanie >= ilosc .AND. fakt_num > 0 // .AND. fakt_num <> 99

USE zamow EXCLUSIVE

GO TOP
DO WHILE .NOT. EOF()
   IF wykonanie >= ilosc .AND. fakt_num > 0
      licznik++
   ENDIF
   SKIP
ENDDO

IF licznik == 0

   ALERT('Brak pozycji zamowien, ktore mozna archiwowac')
   CLOSE DATABASES
   RETURN

ENDIF

IF ALERT(ALLTRIM(STR(licznik,6,0))+ ' pozycje zamowien przeniesc do archiwum ',{'pozostawic','przeniesc'}) == 2

   GO TOP
   DO WHILE .NOT. EOF()
      IF wykonanie >= ilosc .AND. fakt_num > 0
         DELETE
         licznik++
      ENDIF
      SKIP
   ENDDO

   INDEX ON zamowienie TO zam UNIQUE
   INDEX ON zamowienie +STR(zam_poz) TO zam_poz
   PACK
   USE

ENDIF

RETURN