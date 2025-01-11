PROCEDURE czas2
LOCAL Pauzy, DniRoboczych,Chorobowe, Urlop, DoPracyDni, DoPracyGodzin
LOCAL PrzepGodziny, Przerwy, SumaPrzerw, NettoGodziny, SaldoNadgodzin
//#include "def.ch"
SET MARGIN TO 0

rahmen(.F.,.T.,.F.,.F.,.F.,.F.,'drukowanie czasow pracy')

m->lista     := SPACE(10)
i := 1
Pauzy := 15
SET KEY -1 TO fakts2

@ 7,5    SAY "Numer listy............................ " GET m->lista VALID JestLista(m->lista)
@ 9,5    SAY "Suma dodatkowych przerw dziennie....... " GET Pauzy PICTURE '999 min.'
READ
IF LASTKEY() == 27
   USE
   RETURN
ENDIF

USE Archiv NEW
COPY STRUCTURE TO Archiv2
CLOSE Archiv

SET PRINTER ON
SET CONSOLE OFF
SET PRINTER TO temp.txt

USE Pracowni NEW
GO TOP

Kopf(Data)

DO WHILE .NOT. EOF()
   m->Numer := Numer

   USE Archiv2 NEW
   ZAP

   APPEND FROM Archiv  FOR p_numer == m->numer .AND. Lista == m->Lista
   APPEND FROM rejestr FOR p_numer == m->numer .AND. Lista == m->Lista
//   IF .NOT. EMPTY(Data)
      //Planowane
      DniRoboczych  := WDOM(DATA)
      Chorobowe     := Urlop(m->lista, pracowni->numer, 'C') //dni chorobowego w miesiacu
      Urlop         := Urlop(m->lista, pracowni->numer, 'U') //dni urlopu w miesiacu
      DoPracyDni    := DniRoboczych - Chorobowe - Urlop      //Planowanych dni pracy w miesiacu
      DoPracyGodzin := DoPracyDni * 8                        //Planowanych godzin pracy w miesiacu

      //Wykonane Dni
      PrzepracowDni := SaldoDniPracy() // Array, przepracowanych [DniRoboczych, Sobot, Niedziel]

      //Wykonane Godziny
      PrzepGodziny  := ZliczGodziny()  // Array, przepracowanych [GodzWDniRobocze,GodzWSoboty,GodzWNiedziele]
      Przerwy       := {PrzepracowDni[1]*Pauzy/60,PrzepracowDni[2]*Pauzy/60,PrzepracowDni[3]*Pauzy/60}   // Aray z Pauzami
      SumaPrzerw    := Przerwy[1]+Przerwy[2]+Przerwy[3]
      NettoGodziny  := {PrzepGodziny[1]-Przerwy[1],PrzepGodziny[2]-Przerwy[2], PrzepGodziny[3]-Przerwy[3]}
      SaldoNadgodzin:= NettoGodziny[1] + NettoGodziny[2] + NettoGodziny[3] - DoPracyGodzin

   IF DniRoboczych > 0
      ?  STR(pracowni->numer,3,0)
      ?? ' '+LEFT(Pracowni->Nazwisko,15)
      ?? LEFT(pracowni->Imie,10)

      // Planowane
      ?? STR(DniRoboczych ,2,0)+'/'           //Ilosc dni roboczych w miesiacu
      ?? STR(Chorobowe,2,0)+'/'               //Ilosc dni chorobowego w miesiacu
      ?? STR(Urlop,2,0)+'            '        //wykorzystane urlopy w obliczeniowym miesiacu
      ?? STR(DoPracyDni,2,0)+'/'              //Obliczeniowa ilosc dni za miesiac
      ?? STR(DoPracyGodzin,3,0)+'     '       //Obliczeniowa ilosc godzin za miesiac
      // Wykonanie dni
      ?? STR(PrzepracowDni[1],2,0)+'/'        //Przepracowane dni Robocze
      ?? STR(PrzepracowDni[2],2,0)+'/'        //Przepracowane soboty
      ?? STR(PrzepracowDni[3],2,0)+'          '//Przepracowane Niedziele
      // Wykonanie Godzin
      ?? STR(NettoGodziny[1],6,2)+'/'           //Przepracowane godziny w dni robocze
      ?? STR(NettoGodziny[2],6,2)+'/'           //Przepracowane godziny w soboty
      ?? STR(NettoGodziny[3],6,2)+'  '          //Przepracowane godziny w niedziele
      ?? STR(SaldoNadgodzin,12,2)
   ENDIF
      CLOSE Archiv2
//   ENDIF
   SELECT Pracowni
   SKIP
ENDDO
SET PRINTER OFF
SET PRINTER TO
CLOSE DATABASES
RunShell( "temp.txt", path4)
SET CONSOLE ON

RETURN

FUNCTION ZliczGodziny  //Przepracowane godziny bez wliczenia pauz
PRIVATE SumaRob,SumaSob,SumaNiedz,SumaDni

AltSelect := SELECT()
SELECT Archiv2

GO TOP
SumaRob   := 0
SumaSob   := 0
SumaNiedz := 0

DO WHILE .NOT. EOF()
   DO CASE
      CASE DOW(Data) == 1
         SumaNiedz := SumaNiedz + ZliczRekord()
      CASE DOW(Data) == 7
         SumaSob   := SumaSob + ZliczRekord()
      OTHERWISE
         SumaRob   := SumaRob + ZliczRekord()
   ENDCASE
   SKIP
ENDDO
SELECT(AltSelect)
SumaDni := {SumaRob, SumaSob,SumaNiedz}
RETURN SumaDni

FUNCTION ZliczRekord()
PRIVATE Suma, Czas1, Czas2
Czas1 := GodzDo*60 + MinDo
Czas2 := GodzOd*60 + MinOd
Suma  := Czas1 - Czas2
RETURN Suma/60

FUNCTION FDOM(Data)  // Dostarcza pierwszy dzien miesiaca w faormacie daty
PRIVATE resztka, dData
resztka := RIGHT(DTOC(Data),6)
resztka := "01"+resztka
dData   := CTOD(resztka)
RETURN dData

FUNCTION WDOM(dData)     // ilosc dni roboczych w miesiacu
PRIVATE FirstDay, NextDay, WorksDay
FirstDay := FDOM(dData)
NextDay  := FirstDay
WorksDay := 0

DO WHILE MONTH(FirstDay) == MONTH(NextDay)
   TheDay := DOW(NextDay)
   IF TheDay > 1 .AND. TheDay < 7
      WorksDay++
   ENDIF
   NextDay++
ENDDO
RETURN WorksDay

FUNCTION DzienWolny(DataDnia)
PRIVATE Datka
Datka := DOW(DataDnia)
IF Datka == 1 .OR. Datka == 7
   cos := .T.
ELSE
   cos := .F.
ENDIF
RETURN cos


FUNCTION Urlop(lista2,Pracownik,rodzaj2)
PRIVATE IloscDni
USE Urlopy NEW
GO TOP
IloscDni := 0

DO WHILE .NOT. EOF()
   IF lista == lista2 .AND. Pracownik == p_numer .AND. UPPER(rodzaj) == UPPER(rodzaj2)
      IloscDni++
   ENDIF
   SKIP
ENDDO

CLOSE Urlopy
RETURN IloscDni

FUNCTION DanePracownika(numer)
PRIVAT tekst
SELECT Pracowni
IF DBSEEK(numer)
   tekst := LEFT(ALLTRIM(Nazwisko) + ', '+ALLTRIM(Imie)+SPACE(50),24)
ELSE
   tekst := 'Pracownik nie odnaleziony      '
ENDIF
SELECT archiv2
RETURN tekst

FUNCTION SaldoDniPracy()
PRIVATE dnipracy
SELECT Archiv2

INDEX ON DTOS(DATA) TO Dni UNIQUE
//PRIVATE DniRob, Sobot, Niedziel, datka, wynik
SET INDEX TO Dni
GO TOP

DniRob  := 0
Sobot   := 0
Niedziel:= 0

DO WHILE .NOT. EOF()
   SKIP
   datka := DOW(Data)

   DO CASE
      CASE datka == 1
         Niedziel ++
      CASE datka == 7
         Sobot ++
      OTHERWISE
         DniRob ++
   ENDCASE

ENDDO
Wynik := {DniRob,Sobot,Niedziel}
SET INDEX TO
RETURN Wynik

FUNCTION Kopf(dzien)
? 'Zestawienie Czasu Pracy za '+cMonth(dzien)
? '                             dni Robocze         plan        dni przepracowane godz przepracowane        saldo    '
? 'Nr. Nazwisko   Imie          miesiac/urlop/chor  dni/godzin  rob/sob/niedz     robocze/soboty/niedz      nadgodzin'
? REPLICATE('_',119)
RETURN NIL
