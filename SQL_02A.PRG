*-- Proposito: Obtener los articulos mas vendidos
SET DELETED   ON
SET EXCLUSIVE OFF
SET CENTURY   ON
SET DATE      BRITISH

*
* Procesa la tabla de ventas
*
WAIT "PROCESANDO LA TABLA DE VENTAS..." WINDOW NOWAIT
&&SUM(line_value(d.cantidad, d.precio, d.pdescuento, c.porcdesc, c.importdesc, c.descuento, c.moneda, c.tipocambio)) AS importe ;
SELECT d.articulo, SUM(d.cantidad) AS cantidad; 
   FROM maesprod m, cabevent c, detavent d ;
   WHERE c.tipodocu = d.tipodocu ;
     AND c.nrodocu  = d.nrodocu ;
     AND BETWEEN(c.fechadocu, CTOD("01/05/2006"), CTOD("23/05/2006")) ;
   GROUP BY d.articulo ;
   ORDER BY 2 DESC

WAIT CLEAR
      
*--------------------------------------------------------------------------*
FUNCTION line_value
PARAMETERS mcantidad, mprecio, mpdescuento, mporcdesc, mimportdesc, mdescuento, mdivisa, mtipocambio
   PRIVATE mreturn, mmonto
   STORE 0 TO mreturn, mmonto

   IF mporcdesc = 0 .AND. mdescuento = 0 THEN
      mreturn = (mprecio * mcantidad) - (mprecio * mcantidad * mpdescuento / 100)
   ELSE
      IF mporcdesc > 0 THEN
         mmonto  = (mprecio * mcantidad) - (mprecio * mcantidad * mpdescuento / 100)
         mreturn = (mmonto - (mmonto * mporcdesc / 100))
      ELSE
         IF mdescuento > 0 THEN
            mmonto  = (mprecio * mcantidad) - (mprecio * mcantidad * mpdescuento / 100)
            mreturn = (mmonto - (mmonto * mdescuento / 100))
         ELSE
            IF mimportdesc > 0 THEN
               WAIT "UN ERROR DE CALCULO HA OCURRIDO !" WINDOW
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   
   IF mdivisa = 1 THEN
      mreturn = ROUND(mreturn, 0)
   ELSE
      mreturn = ROUND(mreturn * mtipocambio, 0)
   ENDIF

   RETURN (mreturn)
*ENDFUNC