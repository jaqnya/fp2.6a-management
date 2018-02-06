*
* STOCK_OT.PRG - Procesa el stock de movimientos de OT.
*

WAIT "POR FAVOR, ESPERE..." WINDOW NOWAIT

IF SET("EXACT") = "OFF"
   SET EXACT ON 
   pcSetExact = "OFF"
ELSE
   pcSetExact = "ON"
ENDIF

* 1. Inicializa el campo stock de Movimientos de OT.
SELECT maesprod
REPLACE maesprod.stock_ot WITH 0 ALL

* 2. Actualiza el stock desde Mov. de Ordenes de Trabajo.
SELECT ot
SCAN ALL
   IF estadoot <> 6
      SELECT cabemot
      IF SEEK(STR(2,1) + ot.serie + STR(ot.nroot, 7))
         SELECT detamot
         IF SEEK(STR(cabemot.tipobole, 1) + cabemot.serie + STR(cabemot.nrobole, 7))
            SCAN WHILE STR(cabemot.tipobole, 1) + cabemot.serie + STR(cabemot.nrobole, 7) = STR(detamot.tipobole, 1) + detamot.serie + STR(detamot.nrobole, 7)
               SELECT maesprod
               IF SEEK(detamot.articulo)
                  REPLACE maesprod.stock_ot WITH (maesprod.stock_ot + detamot.cantidad)
               ELSE
                  WAIT "No se encontr¢ el art¡culo: " + ALLTRIM(detamot.articulo) + " desde el Movimiento de OT N§: " + detamot.serie + "-" + LTRIM(STR(detamot.nrobole, 7)) WINDOW
               ENDIF
               SELECT detamot
            ENDSCAN
         ELSE
            WAIT "No se encontr¢ el detalle del Movimiento de OT N§: " + cabemot.serie + "-" + LTRIM(STR(cabemot.nrobole, 7)) WINDOW
         ENDIF
      ENDIF
   ENDIF
ENDSCAN

IF pcSetExact = "OFF"
   SET EXACT OFF
ENDIF

WAIT CLEAR