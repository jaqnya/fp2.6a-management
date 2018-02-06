PARAMETERS tnNroPedido

CLEAR
CLOSE TABLES
CLOSE DATABASES

SET DELETED ON
SET CENTURY ON
SET DATE BRITISH
SET EXACT ON

USE maesprod IN 0 SHARED
USE cabepedc IN 0 SHARED
USE detapedc IN 0 SHARED

lnMarca = 478    && CIRCUIT
lnVendedor = 4   && CESAR TOPACIO

SELECT cabepedc
SET ORDER TO INDICE1   && NROPEDIDO
IF SEEK(tnNroPedido) THEN
   IF vendedor <> lnVendedor THEN
      ? "El vendedor no es CESAR TOPACIO"
      RETURN
   ENDIF

   SELECT detapedc
   SET ORDER TO INDICE1   && NROPEDIDO
   IF SEEK(tnNroPedido) THEN
      SCAN WHILE nropedido = tnNroPedido
         SELECT maesprod
         SET ORDER TO INDICE1   && CODIGO
         IF SEEK(detapedc.articulo) THEN
            IF maesprod.marca = lnMarca AND cabepedc.vendedor = lnVendedor THEN
               ? ALLTRIM(detapedc.articulo) + " - " + ALLTRIM(maesprod.nombre) + " - OLD: " + ALLTRIM(STR(detapedc.precio))
               SELECT detapedc
               REPLACE precio WITH ROUND(precio * 0.95, 0)
               ?? " - NEW: " + ALLTRIM(STR(detapedc.precio))
            ENDIF
         ELSE
            ? "El producto: " + ALLTRIM(detapedc.articulo) + " no existe."
         ENDIF
      ENDSCAN
   ELSE
      ? "El Detalle del Pedido Nº " + ALLTRIM(STR(tnNroPedido)) + " no existe."
   ENDIF
ELSE
   ? "El Pedido Nº " + ALLTRIM(STR(tnNroPedido)) + " no existe."
ENDIF