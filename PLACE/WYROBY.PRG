PROCEDURE wyroby

@ 5,1 CLEAR TO 22,69
USE koszty NEW
USE wyroby INDEX numer_wy, nazwa_wy NEW
GO BOTTOM

SET KEY -1 TO fakts2

rahmen(.T.,.F.,.F.,.T.,.T.,.F.,'wprowadzanie danych o wyrobach')

abbruch := .F.

m->numer_wy  := SPACE(8)
m->nazwa     := SPACE(35)

SET KEY -7 TO WyrUsun

@ 7,9    SAY "Numer wyrobu............" GET m->numer_wy VALID .NOT. EMPTY(m->numer_wy)
READ

IF LASTKEY() == 27
   CLOSE DATABASES
   RETURN
ENDIF
SET INDEX TO numer_wy

IF .NOT. DBSEEK(m->numer_wy)  // Nowy wyrob zapisac

   @ 9,9   SAY 'nazwa wyrobu..............' GET m->nazwa VALID .NOT. EMPTY(m->Nazwa)
   READ

   IF LASTKEY() == 27
      CLOSE DATABASES
      RETURN
   ENDIF

   APPEND BLANK
   REPLACE numer_wy WITH m->numer_wy
   REPLACE nazwa    WITH m->nazwa

ELSE
   @ 9,9   SAY 'nazwa wyrobu............ '+ wyroby->nazwa
ENDIF

CLOSE wyroby



USE Operacje NEW
SET FILTER TO m->Numer_Wy == Wyrob_Nr
SET INDEX TO Numer
GO BOTTOM

SET KEY -7 TO OperUsun

DO WHILE .NOT. abbruch

   SETFUNCTION( 10, CHR(23))
   SETFUNCTION(  9, CHR(27))
   abbruch := .F.
   m->numer := numer+1

   @ 12,9   SAY 'numer operacji..........' GET m->numer PICTURE '9999' VALID .NOT. EMPTY(m->numer)
   READ

   IF LASTKEY() == 27
      CLOSE DATABASES
      EXIT
   ENDIF

   SET FILTER TO wyrob_nr == m->numer_wy
   SET INDEX TO numer

   IF DBSEEK(m->numer)

      SET CURSOR OFF
      TONE(1000,5)
      SET CURSOR ON
      @ 12,45 SAY nazwa
      SET KEY -7 TO OperUsun

      m->nazwa     := nazwa                // nazwa operacji
      m->czas      := czas                 // czas operacji
      m->stawka    := stawka               // stawka/godz)
      m->Wyrob_Nr  := Wyrob_Nr
      m->NazwaStara:= nazwa
      m->Koszty    := Koszty

      NowaOperacja := .F.

   ELSE

      m->nazwa     := SPACE(35)            // nazwa operacji
      m->czas      := 0                 // czas operacji
      m->stawka    := 0               // stawka/godz)
      m->Wyrob_Nr  := SPACE(8)        // numer wyrobu
     * m->numer     := numer
      m->NazwaStara:= SPACE(35)
      m->Koszty    := 'AP'


      @ 12,45 SAY 'nowa operacja         '
      NowaOperacja := .T.

   ENDIF

   @ 14,9   SAY 'nazwa operacji..........' GET m->nazwa VALID .NOT. EMPTY(m->nazwa)
   @ 15,9   SAY 'czas jednostkowy........' GET m->czas PICTURE '999.99 min'
   @ 16,9   SAY 'stawka zaszeregowania...' GET m->stawka PICTURE '999.99 zl'
   @ 17,9   SAY 'miejsce kosztow.........' GET m->koszty VALID JestKoszt(m->Koszty)
   @ 19,9   SAY ' AP -akord prod.  ZA -zaladunek               KS -nauka'
   @ 20,9   SAY ' WZ -wzory,       RE -naprawy reklamacyjne'

   READ

   IF LASTKEY() == 27
      LOOP
   ENDIF

   IF NowaOperacja
      IF m->NazwaStara == m->Nazwa
         LOOP
      ENDIF
      APPEND BLANK
   ENDIF
*   SET INDEX TO Numer_Wy
   IF czas <> m->czas .OR. stawka <> m->stawka
      REPLACE data      WITH DATE()
      REPLACE stawka2   WITH stawka
      REPLACE czas2     WITH czas
   ENDIF
   REPLACE wyrob_nr  WITH m->numer_wy
   REPLACE nazwa     WITH m->nazwa
   REPLACE numer     WITH m->numer
   REPLACE czas      WITH m->czas
   REPLACE stawka    WITH m->stawka
   REPLACE koszty    WITH m->Koszty

   COMMIT
   SETFUNCTION( 10, '' )
   SETFUNCTION(  9, '' )
ENDDO

// ENDDO
CLOSE DATABASES
SET KEY -7 TO

RETURN

************************************************************************************************


PROCEDURE WyrUsun
PRIVATE znalazl

m->wyrob := Numer_Wy

USE rejestr NEW
LOCATE FOR M->wyrob == Wyrob

IF FOUND()
   znalazl := .T.
ELSE
   znalazl := .F.
ENDIF

CLOSE rejestr

USE archiv NEW
LOCATE FOR M->wyrob == Wyrob
IF FOUND()
   znalazl := .T.
ELSE
   znalazl := .F.
ENDIF

CLOSE archiv
SELECT wyroby

IF Znalazl
   ALERT("Wyrob wystepuje w wykonanych pracach, usuniecie nie jest mozliwe")
   RETURN
ENDIF


IF .NOT. EOF()
   IF ALERT('Wyrob '+ ALLTRIM(nazwa) +' usunac ?',{'tak','nie'}) == 1
      DO WHILE .NOT. RLOCK()
      ENDDO
      DELETE
      UNLOCK
      abbruch := .T.
      CLEAR GETS
      SET INDEX TO numer_wy
      REINDEX
    ENDIF
ENDIF
RETURN


***************************************************************************************************
PROCEDURE OperUsun
PRIVATE znalazl
//ALERT(ReadVar())
IF ReadVar()== 'M->NUMER'
   znalazl := .F.

   USE Rejestr NEW

        LOCATE FOR m->Numer_Wy == Wyrob .AND. m->Numer == Operacja
        IF FOUND()
           znalazl := .T.
        ENDIF

        CLOSE Rejestr

        USE Archiv NEW

        LOCATE FOR m->Numer_Wy == Wyrob .AND. m->Numer == Operacja
        IF FOUND()
           znalazl := .T.
        ENDIF

        CLOSE Archiv

        SELECT operacje

        IF znalazl
                ALERT('Usuniecie nie jest mozliwe, operacje wystepuja w wykonanych pracach')
   RETURN
        ENDIF


        IF .NOT. EOF()
           IF ALERT('Operacje '+ALLTRIM(Nazwa)+ ' usunac ?',{'tak','nie'}) == 1
              DO WHILE .NOT. RLOCK()
              ENDDO
              DELETE
              UNLOCK
              abbruch := .T.
              CLEAR GETS
         PACK
              INDEX ON Numer TO Numer
           ENDIF
        ENDIF
ENDIF
RETURN


FUNCTION JestKoszt(wejscie)
PRIVATE cos
SELECT koszty
LOCATE FOR wejscie == koszty
IF FOUND()
   SELECT operacje
   cos := .T.
ELSE
   ALERT('Niepoprawne miejsce kosztow, prosze wybrac z F2')
   cos := .F.
ENDIF
RETURN cos