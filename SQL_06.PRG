STORE DATE() TO mfecha1, mfecha2
mfecha1 = CTOD("01/05/2005")
mfecha2 = CTOD("25/05/2006")

*-- Los mejores clientes 

SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON

SELECT a.codigo, a.nombre, a.ruc, SUM(line_value(b.monto_fact, b.moneda, b.tipocambio)) AS importe ;
   FROM clientes a, cabevent b ;
   WHERE a.codigo = b.cliente ;
     AND BETWEEN(b.fechadocu, mfecha1, mfecha2) ;
   GROUP BY a.codigo ;
   ORDER BY 4 DESC
   
*--------------------------------------------------------------------------*   
FUNCTION line_value
PARAMETERS mmonto_fact, mdivisa, mcambio
   PRIVATE mreturn
   
   IF mdivisa = 1 THEN
      mreturn = ROUND(mmonto_fact, 0)
   ELSE
      mreturn = ROUND(mmonto_fact * mcambio, 0)
   ENDIF
   
   RETURN (mreturn)
*ENDFUNC