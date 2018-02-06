CLEAR ALL
CLOSE ALL

USE cabecomp IN 0 SHARED
USE detacomp IN 0 SHARED
USE proveedo IN 0 SHARED
USE maesprod IN 0 SHARED


SELECT;
   b.articulo,;
   d.codigo2,;
   d.codorig,;
   d.nombre,;
   b.cantidad,;
   a.fechadocu;
FROM;
   cabecomp a,;
   detacomp b,;
   proveedo c,;
   maesprod d;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.proveedor = c.codigo AND;
   b.articulo = d.codigo AND;
   a.proveedor = 97;
ORDER BY;
   b.articulo, a.fechadocu