PROCEDURE czas3
#include "def.ch"
LOCAL Pauzy, DniPracy, Urlop, Chorobowe
LOCAL DzienPracy, DzienWolny, GodzDniUW, GodzDniRo

GodzDniUW    := 0
GodzDniRo    := 0
DzienPracy   := 0
DzienWolny   := 0
Pauzy        := 0.25

SET MARGIN TO 3

rahmen(.F.,.T.,.F.,.F.,.F.,.F.,'drukowanie czasow pracy')

m->lista     := SPACE(10)
i := 0
SET KEY -1 TO fakts2

@ 7,5    SAY "Numer listy............................ " GET m->lista VALID JestLista(m->lista)
@ 9,5    SAY "Suma dodatkowych przerw dziennie....... " GET Pauzy PICTURE '9.99 godz.'
READ
IF LASTKEY() == 27
   USE
   RETURN
ENDIF

COPY FILE archiv.dbf TO archiv2.dbf
USE archiv2 NEW
APPEND FROM rejestr

INDEX ON Lista + STR(p_numer) + DTOS(data) TO przeglad
SET INDEX TO przeglad
GO TOP


SET PRINTER TO temp.txt
SET PRINTER ON
SET CONSOLE OFF

? 'wykaz nadgodzin do listy :'+m->lista
DO Nagl2

LOCATE FOR m->Lista = Lista

DniPracy   := WDOM(data)
m->data    := data
m->p_numer := p_numer

USE pracowni INDEX p_numer NEW
SELECT Archiv2

DO WHILE lista == m->lista

   IF m->p_numer == p_numer

      IF DzienWolny(data)  // zliczanie czasu w soboty i niedziele
         GodzDniUW := GodzDniUW + Jednostka(godzdo, godzod, mindo, minod) //CzasOper
      ELSE                 // zliczanie czasu w dni robocze
         GodzDniRo := GodzDniRo + Jednostka(godzdo, godzod, mindo, minod) //CzasOper
      ENDIF

      IF data <> m->data     // zliczanie ilosci dni w pracy
         IF DzienWolny(data)
            DzienWolny++     // przepracowanych sob¢t lub niedziel w miesiacu
         ELSE
            DzienPracy++     // przepracowanych dni roboczych w miesiacu
         ENDIF
         m->data := data
      ENDIF

      SKIP

   ELSE  // nowy pracownik, wydrukuj wiersz

      urlop        := Urlop(m->lista, m->p_numer, "U")
      Chorobowe    := Urlop(m->lista, m->p_numer, "C")
      Wiersz(m->p_numer,GodzDniUW,GodzDniRo, DniPracy, Urlop, Chorobowe, Pauzy, DzienPracy, DzienWolny)
      m->p_numer   := p_numer
      GodzDniUW    := 0
      GodzDniRo    := 0
      DzienPracy   := 0
      DzienWolny   := 0

   ENDIF

ENDDO
EJECT
SET PRINTER OFF
SET CONSOLE ON
SET PRINTER TO
SET MARGIN TO 0
CLOSE DATABASES
RunShell( "temp.txt", path4) 
RETURN

FUNCTION Wiersz(pracownik, GodzDniUW, GodzDniRo, DniPracy, Urlopy, Chorobowe, Pauzy, DzienPracy, DzienWolny)
PRIVATE  NadgDniRo, PlanGodzin

// Odliczenie przerw

GodzDniUW := GodzDniUW - Pauzy * DzienWolny
GodzDniRo := GodzDniRo - Pauzy * DzienPracy
PlanGodzin:= (DniPracy-Urlopy-Chorobowe) * 8    // Godzin miesiecznie do przepracowania
NadgDniRo := GodzDniRo - PlanGodzin            // Nadgodziny 50%

?  DanePracownika(pracownik)

?? STR(PlanGodzin,7,2)                       // 1.godzin do przepracowania
?? "  "+STR(GodzDniUW+GodzDniRo,7,2)         // 2.godziny przepracowane
?? "  "+STR(GodzDniUW,7,2)                   // 3.przepracowane godziny w soboty lub niedziele
?? "  "+STR(NadgDniRo,7,2)                   // 4.nadgodziny w dni robocze
?? "  "+STR(GodzDniUW+NadgDniRo,7,2)         // 5.nadgodziny 100%
                                             // 6.dni przepracowane / do przepracowania

?? "  "+STR(DzienPracy,2,0)+"+"+STR(DzienWolny,1,0)+"/"+STR(DniPracy - Urlopy - Chorobowe,2,0)
RETURN NIL

PROCEDURE Nagl2
? ""
? "Nazwisko, Imie           plan     praca      100%      50%     suma    dni"
? REPLICATE (CHR(196),76)
RETURN

FUNCTION Jednostka(godz_do,godz_od,min_do,min_od)
RETURN(godz_do-godz_od+(min_do-min_od)/60)