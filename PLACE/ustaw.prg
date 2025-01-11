PROCEDURE ustaw
USE ustaw
m->Artykuly := Artykuly
m->DBF      := DBF
m->Runtime  := Runtime
m->Edytor   := Edytor

SETFUNCTION(9,CHR(27))
SETFUNCTION(10,CHR(23))


rahmen(.T.,.F.,.F.,.F.,.T.,.T.,'Ustawienia dostepu')

@ 10,2 SAY "plik artykulow.....:" GET m->artykuly
@ 12,2 SAY "pozostale pliki DBF:" GET m->DBF
@ 14,2 SAY "pliki dll..........:" GET m->Runtime
@ 16,2 SAY "edytor textu.......:" GET m->Edytor

READ

IF LASTKEY() == 27
   USE
   RETURN
ENDIF



REPLACE artykuly    WITH m->artykuly
REPLACE DBF         WITH m->DBF
REPLACE Runtime     WITH m->Runtime
REPLACE Edytor      WITH m->Edytor

path1 := ALLTRIM(Artykuly)
path2 := ALLTRIM(DBF)
path3 := ALLTRIM(Runtime)
path4 := ALLTRIM(Edytor)

USE

SETFUNCTION(9,"")
SETFUNCTION(10,"")

RETURN