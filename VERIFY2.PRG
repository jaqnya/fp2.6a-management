*
* Verifica que cada detalle de venta posea solo un encabezado.
*

*-- Procesa la tabla de ventas.
pnCounter = 1
pnQuantity = 0
SELECT cabevent
GO TOP

SCAN ALL
   WAIT WINDOW "6/7 - PROCESANDO LA TABLA DE ORDENES DE TRABAJO: " + ALLTRIM(TRANSFORM(pnCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT

   SELECT detavent
   
   IF .NOT. cabevent.anulado
      IF .not. SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
         WAIT WINDOW STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7) 
      ENDIF
   ENDIF

   SELECT cabevent
   pnCounter = pnCounter + 1
   pnQuantity = 0
ENDSCAN