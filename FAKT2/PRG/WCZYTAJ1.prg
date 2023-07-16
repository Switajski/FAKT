PROCEDURE Wczytaj1
LOCAL Pozycja, Ilosc, Artykol, Nazwa

CLEAR SCREEN

aLinia := ReadSysData('C:\fakt2\wczytaj\zamowienie.txt')

FOR i := 1 TO 10
// ? aLinia[ i ]

Pozycja := SubStr(aLinia[ i ],12,4)
? "Pozycja: "+Pozycja

Ilosc := SubStr(aLinia[ i ],17,4)
?? "Ilosc :"+ Ilosc

Artykol := "P"+SubStr(aLinia[ i ],22,5)
?? Artykol

Nazwa := SubStr(aLinia[ i ],27,40)
?? Nazwa
NEXT


INKEY(0)

RETURN

FUNCTION ReadSysData( cSysFilename )
LOCAL cText     := MemoRead( cSysFilename )
LOCAL nMaxLines := MlCount( cText, 120, 4, .F. )
LOCAL aLines[ nMaxLines ], n

ALERT("Zamówienie ma "+STR(nMaxLines,5,0)+ " pozycji")

FOR n:=1 TO nMaxLines
   aLines[ n ] := MemoLine( cText, 120, n )
//   ? aLines[ n ]
//   INKEY(0)
NEXT


RETURN aLines