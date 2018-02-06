CLEAR
CLEAR ALL
CLOSE ALL

SET CENTURY ON
SET DATE BRITISH
SET DELETED ON
SET EXACT   ON
SET TALK    OFF

USE cabecomp IN 0 SHARED
USE detacomp IN 0 SHARED
USE proveedo IN 0 SHARED

n_anyo = 2011

SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.proveedor,;
   c.nombre,;
   a.fechadocu,;
   SUM(precio * cantidad) AS importe;
FROM;
   cabecomp a,;
   detacomp b,;
   proveedo c;
GROUP BY;
   a.tipodocu,;
   a.nrodocu,;
   a.proveedor,;
   c.nombre,;
   a.fechadocu;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.proveedor = b.proveedor AND;
   a.proveedor = c.codigo AND;
   YEAR(a.fechadocu) = n_anyo AND;
   a.moneda = 2 AND a.tipocambio = 1;
ORDER BY;
   5