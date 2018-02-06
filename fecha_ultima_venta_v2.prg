CLEAR ALL
CLEAR

SET CENTURY ON
SET DATE BRITISH
SET DELETED ON
SET EXACT ON

USE Z:\TURTLE\AYA\INTEGRAD.000\cabevent IN 0 SHARED
USE Z:\TURTLE\AYA\INTEGRAD.000\detavent IN 0 SHARED
USE c:\inventar IN 0 EXCLUSIVE

SELECT inventar
REPLACE fecuventa WITH {},;
        cantidad WITH 0,;
        precio_ven WITH 0 ALL


SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.fechadocu,;
   a.tipocambio,;
   b.articulo,;
   b.cantidad,;
   b.precio;
FROM;
   cabevent a,;
   detavent b;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu;
ORDER BY;
   a.fechadocu DESC;
INTO CURSOR;
   tm_detavent

i = 1

SELECT inventar
SCAN ALL
   WAIT "Procesando... " + ALLTRIM(TRANSFORM(i, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT
   mid_product = id_product
   mfecuventa = {}
   mcantidad = 0
   mprecio_ven = 0

   SELECT tm_detavent
   LOCATE FOR articulo = mid_product
   IF FOUND() THEN
      mfecuventa = fechadocu
      mcantidad = cantidad
      mprecio_ven = ROUND(precio * tipocambio, 0)

      SELECT inventar
      REPLACE fecuventa WITH mfecuventa,;
              cantidad WITH mcantidad,;
              precio_ven WITH mprecio_ven
   ENDIF
   i = i + 1
ENDSCAN