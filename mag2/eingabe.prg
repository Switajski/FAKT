PROCEDURE Eingabe
LOCAL GetList:={},decyzja
SET KEY -1 TO FAKTS2
SETFUNCTION(9,CHR(27))
SETFUNCTION(10,CHR(23))

USE magazyn INDEX ZAPIS NEW EXCLUSIVE

DO WHILE .T.

   Rahmen(.F.,.F.,.F.,.F.,.T.,.T.,"Wprowadzwnie Stanow")

   IF LASTKEY() <> 27
      GO TOP //BOTTOM
   ENDIF

***************************************************************************
   m->zapis    := zapis+1
   m->Art_Nr   := SPACE(4)
   m->Opis     := SPACE(30)
   m->Przychod := 0
   m->Rozchod  := 0
   m->Data     := DATE()
***************************************************************************

   @  5, 5 SAY "zapis nr:"    GET  m->Zapis PICTURE '99999999' // VALID ZapTest(m->Zapis)
   READ

   IF LASTKEY() == 27
      CLOSE ALL
      RETURN
   ENDIF
   SET INDEX TO Zapis

   IF DBSEEK(m->zapis)
      decyzja := ALERT('zapis istnieje - czy nalezy go skorygowac ?' , {'nie','tak','usunac'})

      DO CASE
         CASE decyzja == 1
            LOOP
         CASE decyzja == 2
            Kopia()
         CASE decyzja == 3
            DELETE
            LOOP
      ENDCASE

   ELSE
      APPEND BLANK
   ENDIF

   @  8, 5 SAY "Material:"    GET  m->Art_Nr VALID MatTest(m->Art_Nr)
   @  12,5 SAY "Opis    :"    GET  m->Opis
   @  14,5 SAY "Przychod:"    GET  m->Przychod  PICTURE"9999999.99"
   @  16,5 SAY "Rozchod :"    GET  m->Rozchod   PICTURE"9999999.99"
   @  18,5 SAY "Data    :"    GET  m->Data
   READ

   IF LASTKEY() == 27
      LOOP
   ENDIF

   SELECT Magazyn
   Zapisz()

ENDDO
CLOSE DATABASES
SET KEY -1 TO
SETFUNCTION(10,'')
SETFUNCTION(9,'')

RETURN

*****************************************

PROCEDURE Zapisz
   REPLACE zapis    WITH m->zapis
   REPLACE Art_Nr   WITH m->Art_Nr
//   REPLACE Cena     WITH m->Cena
   REPLACE Przychod WITH m->Przychod
   REPLACE Rozchod  WITH m->Rozchod
   REPLACE Data     WITH m->Data
   REPLACE Opis     WITH m->Opis
RETURN