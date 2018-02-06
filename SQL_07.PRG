*/ Ventas anuales por vendedor (incluye impuestos) */

SET DELETED ON
SET DATE    BRITISH
SET CENTURY ON

STORE DATE() TO mfecha1, mfecha2

mfecha1 = CTOD("01/01/2000")
mfecha2 = CTOD("31/12/2006")

SELECT v.codigo AS codigo, v.nombre AS nombre, SUM(line_value(c.monto_fact, c.monto_ndeb, c.monto_ncre, c.moneda, c.tipocambio)) AS importe ;
   FROM vendedor v, cabevent c ;
   WHERE c.vendedor = v.codigo ;
     AND BETWEEN(c.fechadocu, mfecha1, mfecha2) ;   
   GROUP BY v.codigo ;
   ORDER BY 3 DESC

*--------------------------------------------------------------------------*   
FUNCTION line_value
PARAMETERS mmonto_fact, mmonto_ndeb, mmonto_ncre, mdivisa, mcambio
   PRIVATE mreturn
   
   IF mdivisa = 1 THEN
      mreturn = ROUND(mmonto_fact + mmonto_ndeb - mmonto_ncre, 0)
   ELSE
      mreturn = ROUND((mmonto_fact + mmonto_ndeb - mmonto_ncre) * mcambio, 0)
   ENDIF
   
   RETURN (mreturn)
*ENDFUNC