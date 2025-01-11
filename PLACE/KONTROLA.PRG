PROCEDURE kontrola
//#include "def.ch"

CLEAR

USE Operacje

SET FILTER TO czas == 0 .OR. stawka == 0
INDEX ON wyrob_nr to test
SET INDEX TO test

pola := {"wyrob_nr","numer","nazwa","czas","stawka"}
opisy:= {"wyrob","operacja","opis operacji","czas","stawka/godz"}

DBEDIT(1,1,23,78,pola,,,opisy)

USE

RETURN