CLEAR ALL
CLEAR

SET DELETED   ON
SET CENTURY   ON
SET DATE      BRITISH
SET EXCLUSIVE OFF

SELECT a.articulo, b.nombre, a.cantidad, round(a.precio*1.1,0) FROM detamot2 a, maesprod b WHERE a.articulo = b.codigo AND nrobole = 8639