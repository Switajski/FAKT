// PROCEDURE plik
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wprowadzanie danych o sprzedazy')

USE zamow NEW
GO BOTTOM

IF RECNO() > 0
   m->zamowienie := zamowienie
ELSE
   m->zamowienie := SPACE(11)
ENDIF

SET KEY -1 TO fakts2

********************** NAGLOWEK *********************************

@  8,20 SAY "Numer Zamowienia............." GET m->zamowienie VALID .NOT. EMPTY(m->zamowienie)
READ

IF LASTKEY() == 27
   CLOSE DATABASES
   RETURN
ENDIF

LOCATE FOR m->Zamowienie == Zamowienie

IF .NOT. FOUND()
   CLOSE DATABASES
   RETURN
   ALERT('Zamowienia Nr: '+ ALLTRIM(m->zamowienie)+' brak w bazie')
ELSE

   @ 10,20 SAY "Generowanie pliku zam�wienia Nr. "+ALLTRIM(m->zamowienie)
   INKEY(2)

ENDIF

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

USE plik     NEW
ZAP
SELECT zamow
SET FILTER TO Zamow->zamowienie == m->zamowienie
INDEX ON Art_Nr TO Zam_Plik
i := 1
Suma_Art := 0
DO WHILE .NOT. EOF()
  SELECT Zamow
  SELECT Plik
  APPEND BLANK
  REPLACE Plik->POZ     WITH i
  REPLACE Plik->ZAM_POZ WITH zamow->ZAM_POZ
  REPLACE Plik->ART_NR  WITH zamow->ART_NR
  REPLACE Plik->Nazwa   WITH ALLTRIM(zamow->Nazwa1)+' '+ALLTRIM(zamow->Nazwa2)+' '+ALLTRIM(zamow->Nazwa3)
  REPLACE Plik->Ilosc   WITH Zamow->Ilosc
  REPLACE Plik->ZAM_POZ WITH zamow->ZAM_POZ
  SELECT zamow

  i++
  Suma_Art := Suma_Art + ILOSC
  Model := LEFT(Art_Nr,3)
  SKIP
  IF Model <> LEFT(ART_Nr,3)
     Old_Model := Model
     Model := LEFT(ART_Nr,3)
     SELECT Plik
     APPEND BLANK
     REPLACE Plik->Art_Nr WITH Old_Model
     REPLACE Nazwa WITH "Suma dla wyrobu"
     REPLACE SUMA WITH Suma_Art
     Suma_Art := 0
     SELECT Zamow
  ENDIF

//  ALERT(STR(ZAM_POZ,3,0))

ENDDO

CLOSE DATABASES
RETURN