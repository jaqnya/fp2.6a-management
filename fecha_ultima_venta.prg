CLEAR ALL
CLEAR

SET CENTURY ON
SET DATE BRITISH
SET DELETED ON
SET EXACT ON

USE cabevent IN 0 EXCLUSIVE
USE detavent IN 0 EXCLUSIVE
USE c:\inventar IN 0 EXCLUSIVE

SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.fechadocu,;
   b.articulo;
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

SELECT inventar
SCAN ALL
   mid_product = id_product
   mfecuventa = {}

   SELECT tm_detavent
   LOCATE FOR articulo = mid_product
   IF FOUND() THEN
      mfecuventa = fechadocu
      
      SELECT inventar
      REPLACE fecuventa WITH mfecuventa
   ENDIF
ENDSCAN