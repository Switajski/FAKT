PROCEDURE NoweWyroby

// 5 stk / 45 min => 9  min
// 5 stk / 5 min  => 1  min
// 5 stk / 5 min  => 1  min
// =========================
//                => 11 min
SrednieCzasy = ObliczSrednieCzasy({{5, 45},{5, 5},{5, 5}})
PrintInLine(SrednieCzasy)
? 'Sredni Czas: ' + STR(Sumuj(SrednieCzasy))
?
// 5 stk / 45 min => 9  min
// 5 stk / 5 min  => 1  min
// 5 stk / 5 min  => 1  min
// 6 stk / 36 min => 6  min
// =========================
//                => 17 min
SrednieCzasy = ObliczSrednieCzasy({{5, 45},{5, 5},{5, 5}, {6, 36}})
PrintInLine(SrednieCzasy)
? 'Sredni Czas: ' + STR(Sumuj(SrednieCzasy))
?
// zero
Suma = Sumuj(ObliczSrednieCzasy({}))
? Suma


FUNCTION ObliczSrednieCzasy(a)
   SrednieCzasy = {}
   FOR i=1 TO LEN(a)
      AADD(SrednieCzasy, (a[i][2] / a[i][1]))
   NEXT
RETURN SrednieCzasy

FUNCTION Sumuj(a)
   Suma = 0
   FOR i=1 TO LEN(a)
      Suma = Suma + a[i]
   NEXT
RETURN Suma

FUNCTION Print2Dim(a)
   FOR i=1 TO LEN(a)
      PrintInLine(a[i])
   NEXT
RETURN

FUNCTION PrintInLine(a)
   Line = ''
   FOR i=1 TO LEN(a)
      Line = Line + STR(a[i]) + ', '
   NEXT
   ? Line
RETURN

// EXPRERIMENTAL
USE archiv2 NEW
   AVERAGE Ilosc TO tIlosc FOR wyrob = "P2x-szal"
   AVERAGE CzasOper TO tCzasOper FOR wyrob = "P2x-szal"