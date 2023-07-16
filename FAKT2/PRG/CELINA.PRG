PROCEDURE celina
#include "def.ch"

rahmen(.F.,.F.,.F.,.F.,.T.,.F.,'Eksport do systemu CELINA')

m->Fakt_Num := 0
SET KEY -1 TO fakts2
USE klienci  INDEX kl_numer NEW
USE artykuly INDEX ar_numer NEW
USE faktury  INDEX fa_numer NEW

@ 10,20 SAY 'Numer Faktury.......' GET m->Fakt_Num PICTURE '99999' VALID DBSEEK(m->FAKT_NUM)
READ

IF LASTKEY() == 27
   RETURN
ENDIF


LOCATE FOR m->Fakt_num == Fakt_Num
IF .NOT. FOUND()
   ALERT('Faktura nie zostala odnaleziona')
   USE
   RETURN
ENDIF

SELECT Klienci
SET INDEX TO kl_numer

IF .NOT. DBSEEK(faktury->kli_numer)
   ALERT('blad w odszukiwaniu klienta')
   CLOSE DATABASES
   RETURN
ENDIF

SELECT faktury

IF FILE("SAD_BW.XML")
   ERASE SAD_BW.XML
ENDIF
*******************************************************************************
*                  Datens„tze erstellen                                       *
*******************************************************************************
SET PRINTER ON
SET CONSOLE OFF
SET DEVICE TO PRINTER
SET PRINTER TO SAD_BW.XML
SET MARGIN TO 0

?? '<?xml version="1.0" encoding="WINDOWS-1250"?>'
?  '<!-- Georg Switajski -->'
?  '<SAD_PL Wersja="1.14" IdJedn="190500">'
?  '<Dekl TypDoc="ET" WPGPUC="N">'
?  '<Nag>'

?  '<P1a Symbol="EU"/>'

?  '<P1b Kod="1"/>'

?  '<P1c SymTran="TR"/>'

?  '<P2 PozId="1"'
?? ' RodzKon="V"'
?? ' Nazwa="Baby_s World spolka z o.o."'
?? ' Ulica="Borowno"'
?? ' Miejsc="Chelmno"'
?? ' Kod="86-200"'
?? ' Kraj="PL"'
?? ' Regon="870314621"'
?? ' Nip="875-10-03-090"'
?? ' BNazwa="Kredyt Bank Chelmno"'
?? ' BKonto="1217-5002-9304"/>'

?  '<P5 Pozycje="'+ STR(pozycji(),1,0) + '"/>'

?  '<P6 LiczbaOpak="'+ ALLTRIM(STR(opakowan,6,0))+'"/>'

?  '<P7 Nrakt="BW'+ALLTRIM(STR(m->Fakt_Num,5,0))+'"/>'

?  '<P8 PozId="1"'
?? ' RodzKon="C"'
?? ' Nazwa="Georg Switajski"'
?? ' Miejsc="Kulmbach"'
?? ' Kod="D-95326"'
?? ' Kraj="DE">'
?  '</P8>'

?  '<P9 Agencja="N"'
??   ' NazwiskoImie="Kazimierz Switajski"'
??   ' Tel="056 6920391"/>'


?  '<P11 KodKrajuHandlu="DE"/>'

?  '<P14 ImpExp="Eksporter"'
?? ' NazwiskoImie="'+ALLTRIM(podpis1)+'"'
?? ' NrDowOs="'+ALLTRIM(podpis2)+'"'
?? ' NrWpisu=" "'
?? ' DataWpisu=" "'
?? ' RodzKon=" "'
?? ' Nazwa=" "'
?? ' Ulica=" "'
?? ' Nrdom=" "'
?? ' Miejsc=" "'
?? ' Kod=" "'
?? ' Regon=" "/>'

?  '<P15a KodKrajuWys="PL"/>'

?  '<P17a KodKrajuPrzezn="DE"/>'

?  '<P18 PozId="1"'
?? ' NazwaST="Samochod"'
?? ' ZnakiST="'+ALLTRIM(Samochod)+'"'
//?? ' KrajRejST="'+samoch(Nat_Auto)+'"'
?? ' ZnakiCPST=" "'
?? ' KrajRejCPST=" "'
?? ' NrKonc="brak"/>'

?  '<P19 Kontener="0"/>'

?  '<P20 KodDost="EXW"'
?? ' MiejsceDost="Borowno-Chelmno"'
?? ' KodKrajuDost=" "/>'

?  '<P22 SymbolWal="EUR"'
?? ' Wartosc="'+ALLTRIM(STR(s_wartosc()))+'"/>'

?  '<P23 KursWal="'+ALLTRIM(STR(kurs,9,4))+'"/>'

?  '<P24 RodzTransak="11"/>'

?  '<P25 RodzTransp="30"/>'

?  '<P29 IdJedn="'+przejnr+'"/>'

?  '<P35 SADMasaBrutto="'+ALLTRIM(STR(CalkBrutto(),0))+'"/>'

?  '</Nag>'

?  '<Spec>'


FOR i:=0 TO pozycji()-1
   Modul2(i)
NEXT i


?  '</Spec>'

?  '<Stop>'

?  '<P50>'

?  '<GlZobow RodzKon="V"'
?? ' Nazwa="Baby_s World spolka z o.o."'
?? ' Ulica="Borowno"'
?? ' Miejsc="Chelmno"'
?? ' Kod="86-200"'
?? ' Kraj="PL"/>'

?  '<SklPodp NazwiskoImie="Georg Swtajski" Stanowisko="z-ca Prezesa Zarzadu Spolki"/>'
?  '</P50>'

?  '<P53 PozId="1"'
?? ' UCprzezn="'+przejscie+'"'
?? ' KodKraju="PL"/>'

?  '</Stop>'

?  '</Dekl>'

?  '</SAD_PL>'



SET DEVICE TO SCREEN
SET PRINTER TO
SET MARGIN TO
SET PRINTER OFF
SET CONSOLE ON

CLOSE DATABASES

DO Sichern

RETURN

FUNCTION modul2
PARAMETER pozycja

?  '<Towar PozId="'+ALLTRIM(STR(pozycja+1,2,0))+'">'

?  '<P31>'

?  '<SpecTow PozId="1"'
nc := nrcelny(pozycja)
??    ' Opis="'+ALLTRIM(artykuly->nazwa1)
??          ' '+ALLTRIM(artykuly->nazwa2)
??          ' '+ALLTRIM(artykuly->nazwa3)
??          ' '+ALLTRIM(STR(ilosc(pozycja),8,2))
??          ' '+jednostka(pozycja)+'"'
//??   ' RodzajOpak=" "'
??   ' Pref="N">'
?  '</SpecTow>'

?  '</P31>'

?  '<P32 Nrpoz="'+ALLTRIM(STR(pozycja+1,2,0))+'"/>'

?  '<P33 KodTC="'+LEFT(nrcelny(pozycja),8)+SUBSTR(nrcelny(pozycja),11,1)+'"/>'

?  '<P34 KodKrajuPoch="PL"/>'

?  '<P36 Prefer=" "/>'

?  '<P37 SADProcedura="1000"/>'

?  '<P38 MasaNetto="'+ALLTRIM(STR(WagaNetto(pozycja),8,0))+'"/>'

IF .NOT. EMPTY(Artykuly->JEDN_CELNA)
   IloscCelna := 0
   WOPEN(1,15,15,55)
      SET DEVICE TO SCREEN
      SET COLOR TO &farb2
      WBOX()
      @  2,2  SAY 'Pozycja : '+STR(Pozycja+1,2,0)
      @  4,2  SAY 'Celna Ilosc Towaru dla:'
      @  6,2  SAY artykuly->nazwa1
      @  7,2  SAY artykuly->nazwa2
      @  8,2  SAY artykuly->nazwa3
      @  9,2  SAY ALLTRIM(STR(ilosc(pozycja),8,2))+' '+artykuly->jednostka
      @ 10,13 SAY ALLTRIM(Artykuly->JEDN_CELNA) 
      @ 10,2  GET m->IloscCelna PICTURE "@ 999999.99"
      READ
      SET DEVICE TO PRINTER
   WCLOSE()
      ?  '<P41 IloscTow="'+ALLTRIM(STR(m->IloscCelna,8,2))+' " Jm="'+ALLTRIM(Artykuly->JEDN_CELNA)+'"/>'
ENDIF

?  '<P42 Wartosc="'+ALLTRIM(STR(E_wartosc(pozycja),8,2))+'"/>'

?  '<P44>'
?  '<DokInny PozId="1" OpisRodzDok="Faktura" Nr="'+ALLTRIM(STR(m->Fakt_Num,5,0))+'" DataD="'+DTOC(Fakt_Dat)+'"/>'
?  '<DokInny PozId="2" OpisRodzDok=" " Nr=" " Uwagi=" "/>'
?  '</P44>'

?  '<P45 Korekta="00.0"/>'

?  '<P46 WartStat="'+ALLTRIM(STR(ROUND(E_wartosc(pozycja)*kurs,0)))+'"/>'

?  '</Towar>'

RETURN


