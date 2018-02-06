CLEAR
CLEAR ALL

SET CENTURY   ON
SET DATE      BRITISH
SET DELETED   ON
SET EXACT     ON
SET EXCLUSIVE OFF
SET SAFETY    OFF

USE "z:\turtle\aya\integrad.000\maesprod" IN 0 ALIAS maesprod_central SHARED
USE "z:\turtle\aya\integrad.000\marcas1"  IN 0 ALIAS marcas_central SHARED

USE "z:\turtle\aya\integrad.001\maesprod" IN 0 ALIAS maesprod_sucursal SHARED
USE "z:\turtle\aya\integrad.001\marcas1"  IN 0 ALIAS marcas_sucursal SHARED

USE "z:\turtle\allparts\integrad.000\maesprod" IN 0 ALIAS maesprod_allparts SHARED
USE "z:\turtle\allparts\integrad.000\marcas1"  IN 0 ALIAS marcas_allparts SHARED

SELECT;
   a.codigo,;
   a.nombre,;
   a.stock_actu AS stock,;
   a.pcostog AS costo,;
   b.nombre AS marca;
FROM;
   maesprod_central a;
   INNER JOIN marcas_central b;
      ON a.marca = b.codigo;
WHERE;
   a.stock_actu <> 0 AND;
   !INLIST(a.codigo, "10001", "99010", "99011", "99012", "99013", "99014", "99015", "99016", "99020", "99021", "99022");
ORDER BY;
   a.nombre;
INTO CURSOR;
   aya_central

SELECT;
   a.codigo,;
   a.nombre,;
   a.stock_actu AS stock,;
   a.pcostog AS costo,;
   b.nombre AS marca;
FROM;
   maesprod_sucursal a;
   INNER JOIN marcas_sucursal b;
      ON a.marca = b.codigo;
WHERE;
   a.stock_actu <> 0 AND;
   !INLIST(a.codigo, "10001", "99010", "99011", "99012", "99013", "99014", "99015", "99016", "99020", "99021", "99022");
ORDER BY;
   a.nombre;
INTO CURSOR;
   aya_sucursal

SELECT;
   a.codigo,;
   a.nombre,;
   a.stock_actu AS stock,;
   a.pcostog AS costo,;
   b.nombre AS marca;
FROM;
   maesprod_allparts a;
   INNER JOIN marcas_allparts b;
      ON a.marca = b.codigo;
WHERE;
   a.stock_actu <> 0 AND;
   !INLIST(a.codigo, "10001", "99010", "99011", "99012", "99013", "99014", "99015", "99016", "99020", "99021", "99022");
ORDER BY;
   a.nombre;
INTO CURSOR;
   allparts

SELECT aya_central
EXPORT TO c:\aya_central TYPE XL5

SELECT aya_sucursal
EXPORT TO c:\aya_sucursal TYPE XL5

SELECT allparts
EXPORT TO c:\allparts TYPE XL5

CLOSE ALL
WAIT "Proceso concluido exitosamente." WINDOW NOWAIT
