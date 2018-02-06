*
* GETDATE - Obtiene una cadena con el dia de la samana y a la fecha.
*
PRIVATE cToday

DO CASE
   CASE DOW(DATE()) = 1
      cToday = "Domingo"
   CASE DOW(DATE()) = 2
      cToday = "Lunes"
   CASE DOW(DATE()) = 3
      cToday = "Martes"
   CASE DOW(DATE()) = 4
      cToday = "Mi‚rcoles"
   CASE DOW(DATE()) = 5
      cToday = "Jueves"
   CASE DOW(DATE()) = 6
      cToday = "Viernes"
   CASE DOW(DATE()) = 7
      cToday = "S bado"
ENDCASE

@ 00,00 SAY cToday + ", " + DTOC(DATE()) ;
   SIZE 1,21 ;
   COLOR N/BG