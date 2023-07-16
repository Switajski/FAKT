PROCEDURE NoweWyroby


LOCAL OdDnia, DoDnia, ar, ar2, tso
// rahmen(.F.,.T.,.F.,.F.,.T.,.F.,'reorganizacja nowych norm wyrobow')

NumerWyrobu := SPACE(8)

// SET KEY -1 TO fakts2
// SETFUNCTION(9,CHR(27))

//struktura()    // budowanie archiv2.dbf, kod w dr_sredn
//
//USE operacje NEW
USE archiv2  NEW
//USE wyroby   NEW
NumerWyrobu := 'P2x-szal'
// @  7,9    SAY "                                                        "
// @  9,9    SAY "Numer wyrobu......" GET NumerWyrobu //VALID DBSEEK(m->numer_wy)
// READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF
Wynik := SredCzas(NumerWyrobu)
? "Czas Sredni: "+ STR(wynik,15,2)

// moze https://harbour.github.io/doc/clc53.html#dbeval ?
USE archiv2 NEW
   AVERAGE Ilosc TO tIlosc FOR wyrob = "P2x-szal"
   AVERAGE CzasOper TO tCzasOper FOR wyrob = "P2x-szal"
   tIlosc/tCzasOper TO sredni FOR wyrob = "P2x-szal"

? ''
? 'total czas: '+ STR(tCzasOper)
? 'total ilosc: '+ STR(tIlosc)
? 'total czas / ilosc: '+ STR(tIlosc/tCzasOper)

RETURN

FUNCTION SredCzas( NumerWyrobu )
//SELECT operacje
SumaJednjOeracji   := 0
BiezaceOperacje    := 0
CzasSredniOperacji := 0
BiezacaIlosc       := 0
SredniCzasWyrobu   := 0

//SELECT archiv2
INDEX ON Wyrob+STR(operacja,3,0) TO Nowe
//DBGOTOP()


IF DBSEEK(NumerWyrobu)
//   BROWSE()
NumerOperacji := Archiv2->Operacja
BiezacaIlosc  := 0  //Ilosc


   DO WHILE .T.

      Operacja := Array()

      IF ALLTRIM(archiv2->Wyrob) <>  ALLTRIM(NumerWyrobu)
         EXIT
      ENDIF

      IF archiv2->Operacja <> NumerOperacji      //Nowa Operacja
         
         CzasSredniOperacji := 0 //BiezaceOperacje/BiezacaIlosc
         BiezacaIlosc       := 0 //archiv2->Ilosc
         BiezaceOperacje    := 0 //archiv2->CzasOper
         // ? 'nowa opearcja '+STR(archiv2->Operacja)+STR()

      ENDIF


      BiezaceOperacje    := BiezaceOperacje + archiv2->CzasOper
      BiezacaIlosc       := BiezacaIlosc    + archiv2->Ilosc
//      CzasSredniOperacji := BiezaceOperacje/BiezacaIlosc
//Ostatniego rekordu nie czyta do sredniego czasu wyrobu, bo wyrzuci z petli

      NumerOperacji     := archiv2->Operacja
      NumerWyrobu       := archiv2->wyrob
      IloscNaRecord     := archiv2->Ilosc
      NumerOperacji     := archiv2->Operacja
      SKIP

      CzasSredniOperacji := BiezaceOperacje/BiezacaIlosc
      SredniCzasWyrobu   := SredniCzasWyrobu + CzasSredniOperacji  
      ? NumerWyrobu+ STR(NumerOperacji,4,0)+ ' Ilosc: '+STR(BiezacaIlosc,6,0)+'  BiezaceOperacje '+STR(BiezaceOperacje,10,2)+' Sr.CzasWyrobu:'+STR(SredniCzasWyrobu,9,2)
   ENDDO
ELSE
   Alert( "Robocizma nie znaleziona" , ;
                           {"Overwrite","Cancel"} )
ENDIF

USE

//IF SumaIlosci > 0
//   REPLACE CzasWy  WITH CzasWyrobu
//   REPLACE Ilosc  WITH SumaIlosci
//ELSE
//   REPLACE CzasSred  WITH 0
//   REPLACE Na_Ilosc  WITH 0
//ENDIF

RETURN (SredniCzasWyrobu)

// 5 stk / 45 min => 9  min
// 5 stk / 5 min  => 1  min
// 5 stk / 5 min  => 1  min
// =========================
//                => 11 min