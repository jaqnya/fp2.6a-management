SET TALK OFF
SET CENTURY ON
SET DATE BRITISH


CLEAR

DO CASE
   CASE MONTH(DATE()) = 1
      pcTitle = "ENERO " + STR(YEAR(DATE()), 4)
   CASE MONTH(DATE()) = 2
      pcTitle = "FEBRERO " + STR(YEAR(DATE()), 4)
   CASE MONTH(DATE()) = 3
      pcTitle = "MARZO " + STR(YEAR(DATE()), 4)
   CASE MONTH(DATE()) = 4
      pcTitle = "ABRIL " + STR(YEAR(DATE()), 4)
   CASE MONTH(DATE()) = 5
      pcTitle = "MAYO " + STR(YEAR(DATE()), 4)
   CASE MONTH(DATE()) = 6
      pcTitle = "JUNIO " + STR(YEAR(DATE()), 4)
   CASE MONTH(DATE()) = 7
      pcTitle = "JULIO " + STR(YEAR(DATE()), 4)
   CASE MONTH(DATE()) = 8
      pcTitle = "AGOSTO " + STR(YEAR(DATE()), 4)
   CASE MONTH(DATE()) = 9
      pcTitle = "SEPTIEMBRE " + STR(YEAR(DATE()), 4)
   CASE MONTH(DATE()) = 10
      pcTitle = "OCTUBRE " + STR(YEAR(DATE()), 4)
   CASE MONTH(DATE()) = 11
      pcTitle = "NOVIEMBRE " + STR(YEAR(DATE()), 4)
   CASE MONTH(DATE()) = 12
      pcTitle = "DICIEMBRE " + STR(YEAR(DATE()), 4)
ENDCASE

@ 1, ROUND((33 - LEN(pcTitle)) / 2, 0) SAY pcTitle ;
   SIZE 1,33 ;
   PICTURE "@!" ;
   COLOR W/N

@ 02,04 SAY "DOM LUN MAR MIE JUE VIE SAB"
@ 03,03 SAY "здддбдддбдддбдддбдддбдддбддд©"
@ 04,03 SAY "Ё   Ё   Ё   Ё   Ё   Ё   Ё   Ё"
@ 05,03 SAY "цдддедддедддедддедддедддеддд╢"
@ 06,03 SAY "Ё   Ё   Ё   Ё   Ё   Ё   Ё   Ё"
@ 07,03 SAY "цдддедддедддедддедддедддеддд╢"
@ 08,03 SAY "Ё   Ё   Ё   Ё   Ё   Ё   Ё   Ё"
@ 09,03 SAY "цдддедддедддедддедддедддеддд╢"
@ 10,03 SAY "Ё   Ё   Ё   Ё   Ё   Ё   Ё   Ё"
@ 11,03 SAY "цдддедддедддедддедддедддеддд╢"
@ 12,03 SAY "Ё   Ё   Ё   Ё   Ё   Ё   Ё   Ё"
@ 13,03 SAY "цдддедддедддедддедддедддеддд╢"
@ 14,03 SAY "Ё   Ё   Ё   Ё   Ё   Ё   Ё   Ё"
@ 15,03 SAY "юдддадддадддадддадддадддаддды"

num_col = DOW({01/10/2004}) * 4
num_fil = 4
dias_mes = 31

FOR dia = 1 TO dias_mes
   @ num_fil, num_col SAY dia ;
      SIZE 1,3 ;
      PICTURE "999" ;
      COLOR W/N
   
   IF num_col < 28
      num_col = num_col + 4
   ELSE
      num_col = 4
      num_fil = num_fil + 2
   ENDIF
ENDFOR

SET TALK ON