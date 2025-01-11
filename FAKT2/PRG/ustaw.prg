PROCEDURE ustaw
USE &path0
m->Ustawienia := Ustawienia
m->Artykuly   := Artykuly
m->DBF        := DBF
m->Runtime    := Runtime
m->Edytor     := Edytor
m->MatNorm    := MatNorm
m->RobNorm    := RobNorm

SETFUNCTION(9,CHR(27))
SETFUNCTION(10,CHR(23))


rahmen(.T.,.F.,.F.,.F.,.T.,.T.,'Ustawienia dostepu')

@  8,2 SAY "plik ustawien......:" GET m->ustawienia
@ 10,2 SAY "plik artykulow.....:" GET m->artykuly
@ 12,2 SAY "pozostale pliki DBF:" GET m->DBF
@ 14,2 SAY "pliki dll..........:" GET m->Runtime
@ 16,2 SAY "edytor textu.......:" GET m->Edytor
@ 18,2 SAY "plik norm materialu:" GET m->MatNorm
@ 20,2 SAY "plik norm robocizny:" GET m->RobNorm

READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF



REPLACE ustawienia  WITH m->ustawienia
REPLACE artykuly    WITH m->artykuly
REPLACE DBF         WITH m->DBF
REPLACE Runtime     WITH m->Runtime
REPLACE Edytor      WITH m->Edytor
REPLACE MatNorm     WITH m->MatNorm
REPLACE RobNorm     WITH m->RobNorm

path0 := ALLTRIM(Ustawienia)
path1 := ALLTRIM(Artykuly)
path2 := ALLTRIM(DBF)
path3 := ALLTRIM(Runtime)
path4 := ALLTRIM(Edytor)



USE

//SETFUNCTION(9,"")
SETFUNCTION(10,"")

RETURN