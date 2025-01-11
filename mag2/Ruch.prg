PROCEDURE Ruch
LOCAL sPrzychod, sRozchod, Stan, i, nWartosc, nRazem, data_od, data_do, zuzycie, Art
//#include "def.ch"
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'Analiza zuzycia materialow')
SET KEY -1 TO FAKTS2
********************** NAGLOWEK *********************************
m->grupa    := SPACE(4)
m->data_od  := DATE()
m->data_do  := DATE()
m->Art      := SPACE(4)



@ 10,7 SAY 'Wydruk zuzycia materialow od dnia.........................' GET m->data_od
@ 12,7 SAY 'Wydruk zuzycia materialow do dnia.........................' GET m->data_do
@ 14,7 SAY 'Wydruk zuzycia materialow dla grupy (pusty - wszystkie)(A)' GET m->grupa
@ 16,7 SAY 'Szczegolne numery artykulow..(tylko A lub B mozliwe....(B)' GET m->Art
READ

IF LASTKEY()==27
   RETURN
ENDIF

@ 18,7 SAY 'Prosze czekac, trwa wydruk zuzycia materialow'
i      := 1
nRazem := 0

SET CONSOLE OFF
SET PRINTER TO temp.txt
SET DEVICE  TO PRINTER
SET PRINTER ON

?  'Zuzycie materialow w okresie od dnia: '+ DTOC(m->data_od) + ' do dnia: '+ DTOC(m->data_do)+' dla grupy: '+ m->grupa
?
?  'L.P.   Nr.  Nazwa Materialu'+SPACE(44)+'Zuzycie     Stan j.m.'
?  REPLICATE('_',92)

USE Magazyn   NEW
USE Materialy NEW


L_Art := LEN(ALLTRIM(m->Art))


IF .NOT. EMPTY(m->Grupa)
   SET FILTER TO Grupa == m->Grupa
ENDIF

IF .NOT. EMPTY(m->Art)
   SET FILTER TO LEFT(Art_Nr,L_Art) == ALLTRIM(m->Art)
ENDIF
//BROWSE()

//IF LASTKEY() == 27
//   CLOSE DATABASES
//   RETURN
//ENDIF


SET INDEX TO MatNr

GO TOP

DO WHILE .NOT. EOF()
   SELECT materialy

   m->Nazwa     := Nazwa
   m->Jednostka := Jednostka
   m->Art_Nr    := Art_Nr

   DO WHILE .NOT. EOF()
      SELECT Magazyn

      SUM Przychod, Rozchod TO sPrzychod, sRozchod FOR Art_Nr == m->Art_Nr
      SUM Rozchod TO Zuzycie FOR Art_Nr == m->Art_Nr .AND. DATA >= m->data_od .AND. DATA <= m->data_do
      Stan  := sPrzychod - sRozchod

      ? STR(i,5,0)
      ?? '. '+m->Art_Nr
      ?? ' '+LEFT(m->Nazwa,60)
      ?? STR(Zuzycie,8,2)
      ?? STR(Stan,8,2)
      ?? ' '+m->Jednostka
      SKIP
      i++
   ENDDO
   SELECT Materialy
   SKIP
ENDDO

SET PRINTER TO
SET CONSOLE ON
SET DEVICE TO SCREEN
SET PRINTER OFF
CLOSE DATABASES

// ? RunShell( "temp.txt", path4, .T. )
RETURN