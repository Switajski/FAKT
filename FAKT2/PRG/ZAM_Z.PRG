PROCEDURE Zam_Z
#include  "def.ch"

USE Zamow

SET FILTER TO wykonanie >= Ilosc
INDEX ON STR(KW,2,0)+zamowienie TO KW
SET INDEX TO KW

spalty := {"KW","Kli_Numer","Zamowienie","Zam_Poz","Art_Nr","Ilosc","fakt_Num","fakt_dat"}
formaty:= {"99","99999","AAAAAAAAAAA","99","AAAAAAAAAAA","9999","999"}
opisy  := {"tydzien","nr klienta","zamowienie","poz","Art.Nr","Ilosc","wys.","data"}

DBEDIT(0,0,24,79,spalty,,formaty,opisy)

CLOSE DATABASES
RETURN