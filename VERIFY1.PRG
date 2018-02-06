*
* Verifica que cada detalle de venta posea solo un encabezado.
*

*-- Procesa la tabla de ventas.
pnCounter = 1
pnQuantity = 0
SELECT detavent
GO TOP

SCAN ALL
   WAIT WINDOW "6/7 - PROCESANDO LA TABLA DE ORDENES DE TRABAJO: " + ALLTRIM(TRANSFORM(pnCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT

   SELECT cabevent
   
   IF SEEK(STR(detavent.tipodocu, 1) + STR(detavent.nrodocu, 7))
      SCAN WHILE STR(detavent.tipodocu, 1) + STR(detavent.nrodocu, 7) = STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)
         pnQuantity = pnQuantity + 1
      ENDSCAN
      
      IF pnQuantity > 1
         WAIT WINDOW STR(detavent.tipodocu, 1) + STR(detavent.nrodocu, 7)
      ENDIF
   ELSE
         WAIT WINDOW "NO SE HA ECONTRADO EL ENCABEZADO: " + STR(detavent.tipodocu, 1) + STR(detavent.nrodocu, 7)   + ["] + detavent.articulo + ["] 
   ENDIF

   SELECT detavent
   pnCounter = pnCounter + 1
   pnQuantity = 0
ENDSCAN
