CLEAR
CLEAR ALL

SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON
SET EXACT   ON
SET SAFETY  OFF

SET DEFAULT TO z:\turtle\aya\integrad.000\

USE cabevent IN 0 SHARED
USE detavent IN 0 SHARED
USE cuotas_v IN 0 SHARED
USE clientes IN 0 SHARED

USE maesprod IN 0 SHARED
USE rubros1  IN 0 SHARED
USE rubros2  IN 0 SHARED
USE marcas1  IN 0 SHARED
USE proceden IN 0 SHARED
USE proveedo IN 0 SHARED

CREATE CURSOR lst_prod (codigo C(15), nombre C(40), cantidad N(9,2), precio N(13))
INDEX ON nombre TAG nombre
*------------------------------------------------------------------*
SELECT * FROM cabevent WHERE nrodocu > 9000000 ORDER BY nrodocu INTO TABLE ventas_c
SELECT * FROM detavent WHERE nrodocu > 9000000 ORDER BY nrodocu INTO TABLE ventas_d
SELECT * FROM cuotas_v WHERE nrodocu > 9000000 ORDER BY nrodocu INTO TABLE ventas_x

*!*	SELECT cabevent
*!*	USE

*!*	SELECT detavent
*!*	USE

*!*	SELECT cuotas_v
*!*	USE

*!*	SELECT ventas_d
*!*	SCAN ALL
*!*	   new_code  = articulo
*!*	   new_qty   = cantidad
*!*	   new_price = ROUND(precio * (1 + pimpuesto / 100), 0)

*!*	   SELECT lst_prod
*!*	   LOCATE FOR codigo = new_code
*!*	   IF FOUND() THEN
*!*	      old_qty = cantidad
*!*	      old_total = precio * cantidad
*!*	      new_total = new_price * new_qty

*!*	      updated_qty   = new_qty + old_qty
*!*	      updated_price = ROUND((new_total + old_total) / (new_qty + old_qty), 0)

*!*	      REPLACE cantidad WITH updated_qty
*!*	      REPLACE precio   WITH updated_price
*!*	   ELSE
*!*	      INSERT INTO lst_prod VALUES (new_code, "", new_qty, new_price)
*!*	   ENDIF
*!*	ENDSCAN

*!*	i = 1
*!*	SELECT lst_prod
*!*	SET ORDER TO 0
*!*	SCAN ALL
*!*	i = i + 1
*!*	   SELECT maesprod
*!*	   SET ORDER TO 1
*!*	   SEEK lst_prod.codigo
*!*	   IF FOUND() THEN
*!*	      SELECT lst_prod
*!*	      REPLACE nombre WITH maesprod.nombre
*!*	   ELSE
*!*	      WAIT "El artículo: '" + ALLTRIM(lst_prod.codigo) + "' no existe." WINDOW
*!*	   ENDIF
*!*	ENDSCAN

*!*	SET ORDER TO NOMBRE   && NOMBRE

*!*	BROWSE
*!*	? i

*!*	SUM (PRECIO*CANTIDAD) TO X
*!*	? X

