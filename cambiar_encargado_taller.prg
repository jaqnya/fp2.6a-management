SET DELETED ON
SET CENTURY ON
SET DATE    BRITISH
SET TALK    OFF

CLEAR ALL
CLEAR

USE ot IN 0 SHARED
USE cabemot IN 0 SHARED
USE vendedor IN 0 SHARED

m.vendedor = 20

SELECT vendedor
SET ORDER TO 1
SEEK m.vendedor
m.comision1 = comision1
m.comision2 = comision2
m.comision3 = comision3


SELECT * FROM ot, cabemot WHERE ot.serie = cabemot.serie AND ot.nroot = cabemot.nrobole AND ot.estadoot = 5 AND cabemot.vendedor <> m.vendedor INTO TABLE x11

m.cantidad = 0
m.valor = 0

SELECT x11

SCAN ALL
   SELECT cabemot 
   SET ORDER TO 1
   IF SEEK("2"+x11.serie_a+STR(x11.nroot,7)) THEN
      m.cantidad = m.cantidad + 1
      m.valor = m.valor + monto_fact
      ? x11.nroot
*!*	      REPLACE vendedor WITH m.vendedor
*!*	      REPLACE comision_1 WITH m.comision1
*!*	      REPLACE comision_2 WITH m.comision2
*!*	      REPLACE comision_3 WITH m.comision3
   ENDIF
ENDSCAN

? m.cantidad
? m.valor