CLEAR
CLEAR ALL

SET CENTURY   ON
SET DATE      BRITISH
SET DELETED   ON
SET EXCLUSIVE OFF
SET SAFETY    OFF

USE maesprod IN 0 SHARED
USE cabevent IN 0 SHARED
USE detavent IN 0 SHARED
USE cabenotc IN 0 SHARED
USE detanotc IN 0 SHARED

*!*	*-- Estructura de la consulta original --*
*!*	SELECT;
*!*	   a.tipodocu,;
*!*	   a.nrodocu,;
*!*	   a.fechadocu,;
*!*	   b.articulo,;
*!*	   c.nombre,;
*!*	   b.cantidad,;
*!*	   b.precio;
*!*	FROM;
*!*	   cabevent a;
*!*	      INNER JOIN detavent b;
*!*	         ON a.tipodocu = b.tipodocu AND a.nrodocu = b.nrodocu;
*!*	      INNER JOIN maesprod c;
*!*	         ON b.articulo = c.codigo;
*!*	WHERE;
*!*	   c.subrubro = 2 AND BETWEEN(a.fechadocu, CTOD("13/05/2009"), CTOD("13/05/2010"));
*!*	ORDER BY;
*!*	   a.fechadocu

*----------------------------------------------------------------------------------------*
SELECT;
   b.articulo,;
   c.nombre,;
   SUM(b.cantidad);
FROM;
   cabevent a;
      INNER JOIN detavent b;
         ON a.tipodocu = b.tipodocu AND a.nrodocu = b.nrodocu;
      INNER JOIN maesprod c;
         ON b.articulo = c.codigo;
WHERE;
   c.subrubro = 2 AND BETWEEN(a.fechadocu, CTOD("13/05/2009"), CTOD("13/05/2010"));
GROUP BY;
   b.articulo, c.nombre;
INTO CURSOR;
   motosierras

EXPORT TO c:\motosierras_todas TYPE XL5

*----------------------------------------------------------------------------------------*
SELECT;
   b.articulo,;
   c.nombre,;
   SUM(b.cantidad);
FROM;
   cabevent a;
      INNER JOIN detavent b;
         ON a.tipodocu = b.tipodocu AND a.nrodocu = b.nrodocu;
      INNER JOIN maesprod c;
         ON b.articulo = c.codigo;
WHERE;
   c.subrubro = 134 AND c.marca = 63 AND BETWEEN(a.fechadocu, CTOD("13/05/2009"), CTOD("13/05/2010"));
GROUP BY;
   b.articulo, c.nombre;
INTO CURSOR;
   espadas_itece

EXPORT TO c:\espadas_itece TYPE XL5

*----------------------------------------------------------------------------------------*
SELECT;
   b.articulo,;
   c.nombre,;
   SUM(b.cantidad);
FROM;
   cabevent a;
      INNER JOIN detavent b;
         ON a.tipodocu = b.tipodocu AND a.nrodocu = b.nrodocu;
      INNER JOIN maesprod c;
         ON b.articulo = c.codigo;
WHERE;
   c.subrubro = 134 AND c.marca = 19 AND BETWEEN(a.fechadocu, CTOD("13/05/2009"), CTOD("13/05/2010"));
GROUP BY;
   b.articulo, c.nombre;
INTO CURSOR;
   espadas_oregon

EXPORT TO c:\espadas_oregon TYPE XL5

*----------------------------------------------------------------------------------------*
SELECT;
   b.articulo,;
   c.nombre,;
   SUM(b.cantidad);
FROM;
   cabevent a;
      INNER JOIN detavent b;
         ON a.tipodocu = b.tipodocu AND a.nrodocu = b.nrodocu;
      INNER JOIN maesprod c;
         ON b.articulo = c.codigo;
WHERE;
   c.subrubro = 137 AND BETWEEN(a.fechadocu, CTOD("13/05/2009"), CTOD("13/05/2010"));
GROUP BY;
   b.articulo, c.nombre;
INTO CURSOR;
   limas_todas

EXPORT TO c:\limas_todas TYPE XL5