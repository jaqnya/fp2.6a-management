CLEAR 
CLEAR ALL

SET CENTURY ON
SET DATE BRITISH
SET DELETED ON
SET EXACT ON

USE vendecfg IN 0 SHARED
USE familias IN 0 SHARED
USE vendedor IN 0 SHARED


SELECT;
   ALLTRIM(STR(a.vendedor)) + " - " + c.nombre AS vendedor,;
   ALLTRIM(STR(a.familia)) + " - " + b.nombre AS familia,;
   a.contado,;
   a.credito,;
   a.cobranza;
FROM;
   vendecfg a,;
   familias b,;
   vendedor c;
WHERE;
   a.familia = b.codigo AND;
   a.vendedor = c.codigo AND;
   a.vendedor = 17;
ORDER BY;
  a.familia;
INTO CURSOR;
   tm_comision


SELECT tm_comision
EXPORT TO Z:\comision_enrique TYPE XL5
