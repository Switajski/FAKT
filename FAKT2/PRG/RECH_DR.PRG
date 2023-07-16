PROCEDURE rech_dr
#include "def.ch"
CLOSE DATABASES

rahmen(.F.,.F.,.F.,.F.,.T.,.F.,'wydruk faktury')

m->fakt_num := 0

SET KEY -1 TO fakts2

@  8,20 SAY 'Numer rachunku ?....' GET m->fakt_num PICTURE '99999'
READ

SET KEY -1 TO

IF LASTKEY() == 27 .OR. m->fakt_num == 0
   CLOSE DATABASES
   RETURN
ENDIF
USE klienci INDEX kl_numer NEW
USE artykuly NEW
USE faktury  NEW

LOCATE FOR fakt_num == m->fakt_num

SELECT klienci
SET INDEX TO kl_numer

IF .NOT. DBSEEK(faktury->kli_numer)
   ALERT('blad w wyszukiwaniu klienta')
   CLOSE DATABASES
   RETURN
ENDIF

SELECT Faktury


@ 12,20 SAY 'Trwa wydruk rachunku'
SET PRINTER ON
SET CONSOLE OFF
SET MARGIN TO m->lewy_marg
FOR i := 1 TO m->gora
 ? ' '
NEXT

IF m->Kopf
   ZF := ALLTRIM(firma1) +"  "+ALLTRIM(firma2)+"   " +ALLTRIM(firma3)
   ? '     '+ZF
   ? '     컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴'
ENDIF

? '     FAKTURA EKSPORTOWA'   + '   Numer :'+ ALLTRIM(STR(fakt_num,5,0))
? '     Miejsce i data wystawienia:'+ firma3 + '  '+ DTOC(fakt_dat)
? '     컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴'

SELECT faktury

?  '     Sprzedawca: '+LEFT(firma1+SPACE(40),28)
?? 'Nabywca: '         +klienci->kli_nazwa1

?  '                 '+LEFT(firma2+SPACE(50),37)
?? klienci->kli_nazwa2

?  LEFT('                 '+firma3+SPACE(40),40)
?? '              '+klienci->kli_ulica

?  '                                                      '+klienci->kli_PLZ+' '+klienci->kli_ort
? ' '
? '     NIP     : '+ NIP

? '     '+ konto1
? '     '+ konto2
? ' '
? '     Sposob zaplaty   :'+ zaplata
? '     Srodek transportu:'+ transport

? KZ_1
? KZ_2
? KZ_3
? KZ_4
? KZ_5

licz := 0
DO WHILE licz < 10
   IF E_wartosc(licz) > 0
      ?  ' '+STR(licz+1,2,0)+'.'
      RZeile(licz,i,7)                        // drukowanie nazwy artykulu
      ?? STR(ilosc(licz),9,2)
      ?? ' '+jednostka(licz)
      ?? STR(cena(licz),7,2)
      ?? ' '+waluta
      ?? STR(E_wartosc(licz),9,2)
      ?? ' '+waluta
      ?? ' '+STR(WagaNetto(licz,5,0))
      ?? '   '+STR(WagaBrutto(licz,5,0))

      IF POZYCJI() < 8
         ? ' '
      ENDIF
     

   ENDIF
   licz++
ENDDO

? '     컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�'
? '     WARTOSC LACZNIE                             '
?? STR(s_wartosc(),9,2 )+' '+waluta  // wartosc pozycji
?? ' '+STR(CalkNetto(),5,0)+'kg'+STR(CalkBrutto(),5,0)+'kg'
// ?? STR(s_kwotVAT(), 10,2)                   // wartosc 10 pozycji
// ?? STR(s_warzVAT(),9,2)+' '+waluta         // wartosc z VAT 10 pozycji
? ' '
? '     '+ przelicznik1+STR(kurs,8,4)
? LEFT('     '+przelicznik2+SPACE(60),48) +STR(s_wartosc()*kurs,10,2)+' zl'

? ' '
? '     '+klauzula1
? '     '+klauzula2
? '     '+klauzula3
? ' '
? ' '
? ' '
? '     '+ faktury->rpodpis
? ' '
? ' '
? SPACE(50)+'컴컴컴컴컴컴컴컴컴컴컴컴�'
? LEFT('     '+faktury->rfunkcja+SPACE(50),50)+ 'podpis osoby upowaznionej'
? SPACE(50)+'do odbioru dokumentu'

CLOSE DATABASES

EJECT
SET PRINTER OFF
SET CONSOLE ON
RETURN
