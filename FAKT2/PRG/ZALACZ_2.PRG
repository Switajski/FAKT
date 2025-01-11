// PROCEDURE zalacz_2
#include  "def.ch"
rahmen(.T.,.F.,.F.,.F.,.T.,.F.,'wprowadzanie danych o sprzedazy')

USE Klienci INDEX KL_Numer NEW
USE Faktury NEW

GO BOTTOM


SET INDEX TO fa_numer

********************** DANE DLA NAGLOWKA PRZY NOWEJ WYSYLCE *********
IF .NOT. DBSEEK(m->fakt_num)
   ALERT('Nieznana Wysylka')
   CLOSE DATABASES
   RETURN

ELSE
//   m->kli_numer := kli_numer
   SELECT Klienci
   IF .NOT. DBSEEK(m->kli_numer)
      ALERT('Klient nie zostal odnaleziony')
   ENDIF

ENDIF

SET PRINTER TO 'temp_z.txt'
SET DEVICE  TO PRINTER
SET PRINTER ON
SET CONSOLE OFF


?  'Zalacznik nr 2 do wysylki nr '
?? alltrim(str(m->fakt_num,5,0))

?  'Data Wysylki: '+DTOC(m->dostawa)

?
?  'Numer rachunku: '+ALLTRIM(STR(Rach_Nr,5,0))
?  'z dnia : '+DTOC(m->fakt_dat)
?
?
?  '1. Dostawca Towaru :'
?  "   Baby's World Spolka z o.o. Kokocko 43, 86-200 Unislaw"
?  '   NIP PL 8751003090'
?
?  '2. Odbiorca :'
//?  '   Georg Switajski, Gasfabrikgaesschen 10, 95326 Kulmbach'
? '   '+klienci->kli_nazwa1
? '   '+klienci->kli_nazwa2
? '   '+klienci->kli_ulica
? '   '+klienci->kli_PLZ + ' '+klienci->kli_ort
? '   Id. Nr. '+klienci->kli_ZNR
//?  '   Id. Nr. DE 159676260'
?
?  '3. Towar zgodnie ze specyfikacja do faktury nr '+ALLTRIM(STR(Rach_Nr,5,0))
?  '   z dnia '+DTOC(m->fakt_dat)+' odebralem dnia '+DTOC(m->dostawa)
?
?
?
?
?
?  '   Georg Switajski'
?  '   Gassfabrikgaesschen 10'
?  '   D-95326 Kulmbach'
?
?
?  '4. Srodek transportu wywozonego towaru:'
?  '   odbior wlasny samochodem dostawczym o numerze'
?  '   rejestracyjnym:'
?  '                       KU-GS66'
?
?
?  '5. Towar wywoze pod adres wymieniony w punkcie 2'
?
?
?
?
?  '   Georg Switajski'

SET PRINTER TO
SET DEVICE TO SCREEN
SET PRINTER OFF
CLOSE DATABASES
SET CONSOLE OFF
// RunShell( 'temp_z.txt', path4)

RETURN