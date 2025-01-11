PROCEDURE rejestr
PUBLIC filter, m_wyrob,lp
USE rejestr NEW
SET INDEX TO LP
GO BOTTOM
m->lp := lp

m->numer_wy := SPACE(6)
m->lista    := SPACE(10)
m->ilosc    := 0
m->numer_op := 0
m->zlecenie := SPACE(10)
m->GodzOd   := 6
m->GodzDo   := 16
m->MinOd    := 0
m->MinDo    := 0
m->p_numer  := 0
m->data     := data
m->wyrob    := wyrob
m->norma    := 0
abbruch     := .F.

USE

SETFUNCTION(9,CHR(27))
SETFUNCTION(10,CHR(23))

DO WHILE .NOT. abbruch

   @ 5,1 CLEAR TO 22,69
   SET KEY -1 TO fakts2

   rahmen(.T.,.F.,.F.,.T.,.T.,.F.,'rejestracja dnia pracy')

   USE rejestr

   m->lp := m->lp+1

   @ 6,7    SAY "Numer porzadkowy            " GET m->lp PICTURE '999999'
   READ

   IF LASTKEY() == 27
      CLOSE DATABASES
      RETURN
   ENDIF

   SET INDEX TO lp

   IF DBSEEK(m->lp)
      @ 6,45 SAY 'poprawa' COLOR(farb4)
      m->numer_wy := numer_wy
      m->lista    := lista
      m->ilosc    := ilosc
      m->numer_op := operacja
      m->zlecenie := zlecenie
      m->GodzOd   := GodzOd
      m->GodzDo   := GodzDo
      m->MinOd    := MinOd
      m->MinDo    := MinDo
      m->p_numer  := p_numer
      m->data     := data
      m_wyrob     := wyrob
      m->norma    := norma

      NowyZapis   := .F.
      SET KEY -7 TO ZapisUsun

   ELSE

      @ 6,45 SAY 'nowy zapis' COLOR(farb4)
      NowyZapis := .T.

   ENDIF
   NumerRekordu := RECNO()
   USE

   @ 7,7   SAY "Data wykonania              " GET m->data
   @ 8,7   SAY "Numer ewidencyjny pracownika" GET m->p_numer PICTURE '999' VALID JestPracownik(m->p_numer)
   @ 10,7  SAY 'numer listy.................' GET m->lista    VALID JestLista(m->lista)
   @ 11,7  SAY 'numer zlecenia..............' GET m->zlecenie VALID JestZlecenie(m->zlecenie)
   @ 14,7  SAY 'numer operacji..............' GET m->numer_op PICTURE '999999' VALID JestOperacja(m_wyrob,m->numer_op)
   @ 15,7  SAY 'ilosc sztuk.................' GET m->ilosc PICTURE '999999.99' VALID m->ilosc > 0
   @ 17,7  SAY 'czas od godz................' GET m->GodzOd PICTURE '99' RANGE 0,23
   @ 17,38 SAY ':' GET m->MinOd                             PICTURE '99' RANGE 0,59
   @ 17,43 SAY 'do godz' GET m->GodzDo                      PICTURE '99' RANGE 0,23
   @ 17,53 SAY ':'GET m->MinDo                              PICTURE '99' RANGE 0,59

// VALID (minuta(m->GodzDo,m->MinDo) - minuta(m->GodzOd,m->MinOd)) >= 1

   READ

   IF LASTKEY() == 27
      CLOSE DATABASES
      RETURN
   ENDIF

//   USE pracowni
//   SET INDEX TO p_numer
//   IF .NOT. DBSEEK(m->p_numer)
//      ALERT('Pracownik nie odnaleziony')
//   ELSE
//      P1 := minuta(od_godz,od_min)   // poczatek pauzy standart w minutach
//      P2 := minuta(do_godz,do_min)   // koniec pauzy standart w minutach
//      P3 := minuta(od_godz1,od_min1)
//      P4 := minuta(do_godz1,do_min1)
//      P5 := minuta(od_godz2,od_min2)
//      P6 := minuta(do_godz2,do_min2)
//   ENDIF
//   USE

// czas zaczecia pracy wyrazony w minutach/dobe

   MinutOd   := minuta(m->GodzOd, m->MinOd)
   MinutDo   := minuta(m->GodzDo, m->MinDo)

   CzasOper := MinutDo-MinutOd

   IF CzasOper <= 0
      ALERT('Niewlasciwa wartosc podanego czasu')
      LOOP
   ENDIF

//   Pauza1 := KorPausy(MinutOd,MinutDo,P1,P2)
//   Pauza2 := KorPausy(MinutOd,MinutDo,P3,P4)
//   Pauza3 := KorPausy(MinutOd,MinutDo,P5,P6)

//   CzasOper := CzasOper - (Pauza1+Pauza2+Pauza3)

   IF .NOT. abbruch
      USE rejestr
      SET INDEX TO lp, OperacLP, LPDGM
      GO NumerRekordu

      IF NowyZapis
         APPEND BLANK
      ENDIF

      REPLACE wyrob     WITH m_wyrob
      REPLACE operacja  WITH m->numer_op
      REPLACE ilosc     WITH m->ilosc
      REPLACE lista     WITH m->lista
      REPLACE data      WITH m->data
      REPLACE zlecenie  WITH m->zlecenie
      REPLACE p_numer   WITH m->p_numer
      REPLACE GodzOd    WITH m->GodzOd
      REPLACE GodzDo    WITH m->GodzDo
      REPLACE MinOd     WITH m->MinOd
      REPLACE MinDo     WITH m->MinDo
      REPLACE CzasOper  WITH m->CzasOper
      REPLACE lp        WITH m->lp
      REPLACE Norma     WITH m->Norma * ilosc
      COMMIT
      USE
   ENDIF
   CLOSE DATABASES
ENDDO

CLOSE DATABASES
SET KEY -7 TO
SETFUNCTION( 9,CHR(27))
SETFUNCTION(10,CHR(23))
RETURN

PROCEDURE ZapisUsun
USE Rejestr
SET INDEX TO LP, OperacLP
IF DBSEEK(m->LP)
   IF ALERT('Zapis '+ALLTRIM(STR(m->lp))+ ' usunac ?',{'tak','nie'}) == 1
      DO WHILE .NOT. RLOCK()
      ENDDO
      DELETE
      UNLOCK
      abbruch := .T.
      CLEAR GETS
      REINDEX
   ENDIF
   abbruch := .T.
ELSE
   ALERT('nie znalezione')
ENDIF
RETURN

FUNCTION JestPracownik(num)
PRIVATE cos
USE Pracowni NEW
SET INDEX TO p_numer
IF .NOT. DBSEEK(num)
   ALERT("pracownik nie znaleziony w ewidencji")
   CLOSE Pracowni
   cos := .F.
ELSE
   @ 8,47 SAY LEFT(ALLTRIM(nazwisko)+' '+ALLTRIM(imie),29) COLOR(farb4)
   CLOSE Pracowni
   cos := .T.
ENDIF
RETURN cos

FUNCTION JestLista(num)
PRIVATE cos
USE Lista INDEX Lista NEW
IF .NOT. DBSEEK(num)
   ALERT("Lista nie zostala odnaleziona")
   CLOSE Lista
   cos := .F.
ELSE
   CLOSE Lista
   cos := .T.
ENDIF
RETURN cos

FUNCTION JestZlecenie(num)
m->zlecenie := zlecenie
USE zlecenia NEW
SET INDEX TO z_numer
IF .NOT. DBSEEK(num)
   ALERT("Zlecenie nie zostalo odnalezione")
   CLOSE zlecenia
   cos := .F.
ELSE
   m_wyrob := wyrob
   m->ilosc := ilosc
   CLOSE zlecenia
   USE wyroby NEW
   SET INDEX TO numer_wy
   IF DBSEEK(m_wyrob)
      @ 11,47 SAY LEFT(ALLTRIM(STR(m->ilosc))+' X '+ALLTRIM(nazwa),32) COLOR(farb4)
   ELSE
      ALERT('Wyrob nie zostal odnaleziony w plikach')
   ENDIF
   CLOSE wyroby
   cos := .T.
ENDIF
RETURN cos


FUNCTION JestOperacja(wyr,num)
PRIVATE cos
USE Operacje NEW
LOCATE FOR (wyr == wyrob_nr .AND. num == numer)
IF .NOT. FOUND()
   ALERT("Nieznana Operacja")
   CLOSE Operacje
   cos := .F.
ELSE
   @ 14,44 SAY Nazwa COLOR(farb4)
   m->norma := czas
   CLOSE Operacje
   cos := .T.
ENDIF

RETURN cos

FUNCTION JestWyrob(num)
USE Wyroby NEW
SET INDEX TO Numer_Wy
IF .NOT. DBSEEK(num)
   ALERT("Nieznany Wyrob")
   CLOSE Wyroby
   cos := .F.
ELSE
   @ 10,50 SAY LEFT(Nazwa,29) COLOR(farb4)
   CLOSE Wyroby
   cos := .T.
ENDIF
RETURN cos

FUNCTION minuta(godz,min)
RETURN godz*60+min

//FUNCTION KorPausy(o1,o2,p1,p2)
//DO CASE
//   CASE o1 <= p1 .AND. p2 <= o2
//      pause := p2 - p1

//   CASE p1 <=  o1 .AND. p2 <= o1
//      pause := 0

//   CASE o1 <= p1 .AND. o2 <= p1
//      pause := 0

//   CASE o1 <= p1 .AND. o2 <= p2
//      pause := o2 - p1

//   CASE p1 <= o1 .AND. p2 <= o2
//      pause := p2 - o1

//OTHERWISE

//   ALERT('blad w obliczaniu czasu')
//      pause := p2-p1

//ENDCASE
//RETURN pause