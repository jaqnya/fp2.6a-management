SET DELETED ON
SET CENTURY ON
SET DATE BRITISH

CLEAR ALL
USE clientes IN 0 SHARED
USE cabevent IN 0 SHARED

m.fecha_desde = CTOD("01/12/2007")
m.fecha_hasta = CTOD("31/12/2100")

SELECT clientes.codigo, cabevent.nrodocu, clientes.nombre, clientes.ruc FROM clientes, cabevent WHERE cabevent.cliente = clientes.codigo AND  BETWEEN(cabevent.fechadocu, m.fecha_desde, m.fecha_hasta) AND tipodocu = 8 AND EMPTY(clientes.cuenta) INTO CURSOR nocustom
SELECT DISTINCT codigo, nombre, ruc FROM nocustom order by 1