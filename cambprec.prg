*
* Este programa cambia el precio de una lista 'x' teniendo en cuenta
* los datos de la tabla 'libro1.dbf'
*

CLEAR
CLEAR ALL
CLOSE ALL

SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON
SET EXACT   ON
SET TALK    OFF

PRIVATE lcArticulo, lnPrecio, lnCnt

USE maesprod IN 0 SHARED
USE libro1   IN 0 EXCLUSIVE

lnCnt = 0

SELECT libro1
SCAN ALL
   lcArticulo = articulo
   lnPrecio   = precio

   SELECT maesprod
   SET ORDER TO 1
   IF SEEK(lcArticulo) THEN
      REPLACE pventag3 WITH lnPrecio
   ELSE
      ? "ARTICULO: " + ALLTRIM(lcArticulo) + ", NO EXISTE."
   ENDIF
   
   lnCnt = lnCnt + 1
ENDSCAN

? "TOTAL DE REGISTROS ESCANEADOS: " + ALLTRIM(STR(lnCnt))