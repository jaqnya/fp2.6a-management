CLEAR ALL
CLEAR

SET CENTURY   ON
SET DATE      BRITISH
SET DELETED   ON
SET EXACT     ON
SET EXCLUSIVE OFF

LOCAL lcSerieOt, lnNroOt
lcSerieOt = "A"
lnNroOt = 8675

SELECT;
   a.serie,;
   a.nroot,;
   a.cliente,;
   a.nombreot,;
   b.articulo,;
   c.nombre,;
   b.cantidad,;
   b.precio;
FROM;
   ot a;
   INNER JOIN detamot2 b;
      ON a.serie = b.serie AND a.nroot = b.nrobole;
   INNER JOIN maesprod c;
      ON b.articulo = c.codigo;
WHERE a.serie = lcSerieOt AND a.nroot = lnNroOt