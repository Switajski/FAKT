PROCEDURE artykuly
PRIVATE lk
@ 5,1 CLEAR TO 22,69

m->numer := SPACE(10)

m->nazwa1     := SPACE(50)
m->nazwa2     := SPACE(50)
m->nazwa3     := SPACE(50)
m->Bezeichn1  := SPACE(50)
m->Bezeichn2  := SPACE(50)
m->Bezeichn3  := SPACE(50)
m->jednostka  := SPACE(4)
m->einheit    := SPACE(4)
m->cena_klien := 0
m->Jed_Celna  := SPACE(4)
m->Objetosc   := 0
m->Numer_Wy   := SPACE(8)
m->Kli_Numer  := 0
m->wykroj     := 0
NowyWyrob     := .T.


SET KEY -1 TO fakts2
abbruch := .F.

DO WHILE .NOT. abbruch

   rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wprowadzanie danych o wyrobach')

   @ 7,20 SAY "Numer wyrobu......" GET m->numer VALID .NOT. EMPTY(m->numer)
   READ

   lk := LASTKEY()
   DO CASE
      CASE lk == 27
         CLOSE DATABASES
         RETURN
      CASE lk == 23
         EXIT
      ENDCASE

   SET KEY -7 TO WyrUsun

   rahmen(.F.,.F.,.F.,.T.,.T.,.T.,'wprowadzanie danych o wyrobach')



 //  @ 5,20 SAY 'Numer wyrobu:      ' + ALLTRIM(m->numer)
   USE Artykuly NEW
   SET INDEX TO Ar_Numer, Ar_Nazwa


   IF DBSEEK(m->numer) //FOUND()


      @ 3,57 SAY 'art: '+ ALLTRIM(m->Numer)+' zmiana' COLOR farb5
      SET KEY -7 TO WyrUsun
      NowyWyrob := .F.
      m->nazwa1     := nazwa1
      m->nazwa2     := nazwa2
      m->nazwa3     := nazwa3
      m->jednostka  := jednostka
      m->Einheit    := Einheit
      m->koszt_prod := koszt_prod
      m->cena_klien := cena_klien
      m->cena_sprze := cena_sprze
      m->Nr_Celny   := Nr_Celny
      m->WagaJed    := WagaJed
      m->Bezeichn1  := Bezeichn1
      m->Bezeichn2  := Bezeichn2
      m->Bezeichn3  := Bezeichn3
      m->objetosc   := objetosc
      m->Numer_Wy   := Numer_Wy  // Numer Wyrobu z programu PLACE
      m->Kli_Numer  := Kli_Numer
      m->wykroj     := wykroj



   ELSE
      @ 3,57 SAY 'nowy wyrob' COLOR farb5
      NowyWyrob := .T.
   ENDIF



   SETFUNCTION(10,CHR(23))
   abbruch := .F.

   DO WHILE .NOT. abbruch


      @  5,2   SAY 'Nazwa wyrobu    ' GET m->nazwa1
      @  6,2   SAY '(Polska)        ' GET m->nazwa2
      @  7,2   SAY '                ' GET m->nazwa3
      @ 11,35  SAY 'Cena wg Zamowien' GET m->cena_klien PICTURE '99999.99 EUR'
      @ 11,2   SAY 'Jednostka miary ' GET m->jednostka
      @ 13,2   SAY 'Wykrojow/warstwe' GET m->wykroj   PICTURE '99 sztuk'
      @ 13,35  SAY 'Kod celny towaru' GET m->Nr_Celny PICTURE '99999999'
      @  15,2  SAY 'Bezeichnung     ' GET m->bezeichn1
      @  16,2  SAY '(Deutsch)       ' GET m->bezeichn2
      @  17,2  SAY '                ' GET m->bezeichn3
      @  19,2  SAY 'Nr. robocizny...' GET m->numer_Wy  VALID(mozliwy(m->Numer_Wy))


      @ 21,2  SAY 'Einheit         ' GET m->einheit
      @ 21,35 SAY 'Numer Klienta   ' GET m->Kli_Numer PICTURE '99999' VALID m->Kli_Numer > 0

   READ

   lk := LASTKEY()
      DO CASE
         CASE lk == 27
            abbruch := .T.
            CLOSE DATABASES
            RETURN
         CASE lk == 23
            EXIT
      ENDCASE

   ENDDO

   IF .NOT. abbruch
      SELECT Artykuly
      IF NowyWyrob
         APPEND BLANK
      ENDIF

      REPLACE numer      WITH m->numer
      REPLACE nazwa1     WITH m->nazwa1
      REPLACE nazwa2     WITH m->nazwa2
      REPLACE nazwa3     WITH m->nazwa3
      REPLACE jednostka  WITH m->jednostka
      REPLACE cena_klien WITH m->cena_klien
      REPLACE Nr_Celny   WITH m->Nr_Celny
      REPLACE Bezeichn1  WITH m->Bezeichn1
      REPLACE Bezeichn2  WITH m->Bezeichn2
      REPLACE Bezeichn3  WITH m->Bezeichn3
      REPLACE Einheit    WITH m->Einheit
      REPLACE Numer_Wy   WITH m->Numer_Wy
      REPLACE Kli_Numer  WITH m->Kli_Numer
      REPLACE Wykroj     WITH m->Wykroj
   ENDIF
   CLOSE DATABASES
   SET KEY -7 TO
ENDDO
SETFUNCTION(10,'')
RETURN

PROCEDURE WyrUsun
PRIVATE pozycja
IF .NOT. EOF()
   IF ALERT('Wyrob '+ ALLTRIM(nazwa1)+' '+ALLTRIM(nazwa2)+' '+ALLTRIM(nazwa3) +' usunac ?',{'tak','nie'}) == 1

      DO WHILE .NOT. RLOCK()
      ENDDO
      DELETE
      UNLOCK
//      USE D:\mag2\DBF\Towary
      USE &path7
      GO TOP

      DO WHILE .NOT. EOF()
         IF m->numer = TOW_ARTNR
            DELETE
         ENDIF
         SKIP
      ENDDO

      abbruch := .T.
      CLEAR GETS
    ENDIF
ENDIF
RETURN

FUNCTION mozliwy(wyrob)
PRIVATE wynik, sciezka
sciezka := path6+'\DBF\Wyroby'
USE &sciezka NEW
//USE D:\PLACE\DBF\Wyroby NEW
LOCATE FOR wyrob == Numer_Wy
IF FOUND()
   wynik := .T.
ELSE
   wynik := .F.
ENDIF
CLOSE
RETURN wynik