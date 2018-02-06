DO seteo

USE cabevent IN 0 SHARED
USE detavent IN 0 SHARED
USE maesprod IN 0 SHARED

lcDescripcion = "TORNILLO"
lnCantidad = 15

SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.fechadocu,;
   b.cantidad,;
   b.precio,;
   c.nombre;
FROM;
   cabevent a,;
   detavent b,;
   maesprod c;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   b.articulo = c.codigo AND;
   lcDescripcion $ c.nombre AND;
   lnCantidad = b.cantidad
