CLEAR ALL
CLEAR

SET CENTURY   ON
SET DATE      BRITISH
SET DELETED   ON
SET EXCLUSIVE OFF

SELECT;
   a.serie,;
   a.nroot,;
   a.nombreot AS cliente,;
   ALLTRIM(e.nombre) + " " + ALLTRIM(f.nombre) + " " + ALLTRIM(g.nombre) AS maquina,;
   a.estadoot,;
   b.nombre,;
   c.monto_fact;
FROM;
   ot a;
      INNER JOIN estadoot b;
         ON a.estadoot = b.codigo;
      INNER JOIN cabemot c;
         ON a.serie = c.serie AND a.nroot = c.nrobole;
      INNER JOIN detamot d;
         ON c.serie = d.serie AND c.nrobole = d.nrobole;
      INNER JOIN maquinas e;
         ON a.maquina = e.codigo;
      INNER JOIN marcas2 f;
         ON a.marca = f.codigo;
      INNER JOIN modelos g;
         ON a.modelo = g.codigo;
WHERE;
   a.marca = 3 AND a.modelo = 8 AND;
   BETWEEN(c.fecha, CTOD("22/05/2010"), DATE()) AND;
   c.monto_fact >= 600000
   
   
*!*	FROM;
*!*	   cabevent a;
*!*	      INNER JOIN detavent b;
*!*	         ON a.tipodocu = b.tipodocu AND a.nrodocu = b.nrodocu;
*!*	      INNER JOIN maesprod c;
*!*	         ON b.articulo = c.codigo;   