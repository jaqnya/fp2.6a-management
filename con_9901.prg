DO seteo

USE cabecomp IN 0 SHARED
USE detacomp IN 0 SHARED

SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.proveedor,;
   a.fechadocu,;
   b.articulo,;
   b.cantidad,;
   b.precio,;
   round(b.cantidad * b.precio, 0) AS total;
FROM;
   cabecomp a,;
   detacomp b;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.proveedor = b.proveedor AND;
   YEAR(a.fechadocu) = 2010 AND;
   b.articulo LIKE "99015"