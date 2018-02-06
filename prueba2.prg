CLEAR
CLEAR ALL
CLOSE ALL

SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON
SET EXACT   ON
SET SAFETY  OFF
SET TALK    OFF

USE cabevent IN 0 SHARED
USE detavent IN 0 SHARED
USE proveedo IN 0 SHARED
USE maesprod IN 0 ALIAS maespcen SHARED
USE z:\turtle\aya\integrad.001\maesprod IN 0 ALIAS maespdep SHARED
USE maespmix IN 0 EXCLUSIVE

SELECT maespmix
ZAP

SELECT maespcen
SCAN ALL
   SCATTER MEMVAR MEMO
   m.stock = m.stock_actu - m.stock_ot
   INSERT INTO maespmix FROM MEMVAR
ENDSCAN

SELECT maespdep
SCAN FOR stock_actu - stock_ot <> 0
   m.codigo = codigo
   m.existencia = stock_actu - stock_ot

   SELECT maespmix
   SET ORDER TO codigo
   IF SEEK(m.codigo) THEN
      REPLACE stock WITH stock + m.existencia
   ELSE
      WAIT "EL PRODUCTO: " + ALLTRIM(m.codigo) + " NO EXISTE." WINDOW
   ENDIF
ENDSCAN

SELECT;
   a.codigo,;
   a.codorig AS cod_origen,;
   a.codigo2 AS cod_altern,;
   a.nombre AS producto,;
   INT(a.stock_min) AS stock_min,;
   INT(a.stock) AS stock_actu,;
   INT(a.stock_min - a.stock) AS diferencia,;
   b.nombre AS proveedor;
FROM;
   maespmix a,;
   proveedo b;
WHERE;
   a.proveedor = b.codigo AND;
   (a.stock_min <> 0 AND a.stock_min > a.stock) AND;
   !INLIST(a.proveedor, 22, 27, 41, 47, 64);
ORDER BY;
   8, 4;
INTO TABLE;
   tmx86

SELECT tmx86
BROWSE FIELDS;
   codigo     :06:H = "C¢digo",;
   cod_altern :12:H = "C¢d. Altern.",;
   cod_origen :12:H = "C¢d. Origen",;
   producto   :25:H = "Descripci¢n",;
   stock_actu :05:H = "Stock",;
   stock_min  :05:H = "M¡nim",;
   c1 = stock_min - stock_actu :05:H = "Difer",;
   proveedor  :30:H = "Proveedor";
NODELETE NOMODIFY

* 22 - RAISMAN LTDA.
* 27 - ITECE LTDA.
* 41 - VEDAMOTORS LTDA.
* 47 - PLATT MANUFACTURING S.A.
* 64 - METALURGICA FRENOBRAS LTDA.   