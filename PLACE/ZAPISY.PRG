PROCEDURE zapisy
#include "def.ch"

CLEAR

USE rejestr
GO BOTTOM
m->data := data
od := 0.4
do := 2
minimum := 30

@ 5,20 SAY 'rozrzut wykonania od 'GET od PICTURE '9.9'
@ 5,45 SAY ' do ' GET do PICTURE '9.9'
@ 7,20 SAY 'czas minimalny minut>' GET minimum PICTURE '99'      
@ 9,20 SAY 'przeglad na dzien:   ' GET m->data 

READ

SET FILTER TO ((norma/czasoper > do) .OR. (norma/czasoper < od)).AND. DATA == m->data .AND. czasoper > minimum 
INDEX ON lp to test2
SET INDEX TO test2

pola := {"lp","data","p_numer","wyrob","operacja","ilosc","czasoper","norma","STR(norma/czasoper*100,3,0)"}
opisy:= {"zapis","data","prac.","wyrob","oper.","sztuk","czas","norma","%"}

DBEDIT(1,1,23,78,pola,,,opisy) 

USE

RETURN