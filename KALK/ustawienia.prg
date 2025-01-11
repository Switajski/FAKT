PROCEDURE Ustawienia
DO Rahmen
USE KalkUstaw  EXCLUSIVE
place         := pplace
magazyn       := pmagazyn
fakt          := pfakt
path4         := text
Premia        := ppremia
KStale        := pKStale    // procent kosztow stalych naliczany do robocizny   "RobZPremia"
KZmienne      := pKZmienne  // procent kosztow zmiennych naliczany do robocizny "RobZPremia"
KZakup        := pKzakup    // procent kosztu zakupu materialow do produkcj naliczany do kosztu materialow
KSprzedaz     := pKSprzedaz // narzut do sprzedazy brany przez firme PFAU
Kurs          := pKurs

@  6,2 SAY 'Sciezka do programu plac ' GET place
@  8,2 SAY 'Sciezka do prog. magazyn ' GET magazyn
@ 10,2 SAY 'Sciezka do programu fakt ' GET fakt
@ 12,2 SAY 'Sciezka edytora tekstu   ' GET text
@ 14,2 SAY 'Procent premii regulam.  ' GET Premia    PICTURE '999.99'
@ 16,2 SAY 'Procent kosztow stalych  ' GET KStale    PICTURE '999.99'
@ 18,2 SAY 'Procent kosztow zmiennych' GET KZmienne  PICTURE '999.99'
@ 20,2 SAY 'Procent koszow sprzedazy ' GET KSprzedaz PICTURE '999.99'
@ 22,2 SAY 'Aktualny kurs PLN/EUR    ' GET Kurs      PICTURE '99.9999'

READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF

REPLACE pplace     WITH place
REPLACE pmagazyn   WITH magazyn
REPLACE pfakt      WITH fakt
REPLACE text       WITH path4
REPLACE ppremia    WITH Premia
REPLACE pKStale    WITH KStale
REPLACE pKZmienne  WITH KZmienne
REPLACE pKzakup    WITH KZakup
REPLACE pKSprzedaz WITH KSprzedaz
REPLACE pKurs      WITH Kurs
USE
RETURN