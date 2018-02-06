CLEAR
CLEAR ALL

SET CENTURY   ON
SET DATE      BRITISH
SET DELETED   ON
SET EXCLUSIVE ON
SET TALK      OFF

USE cabevent IN 0 SHARED
USE clientes IN 0 SHARED
USE cuotas_v IN 0 SHARED
USE monedas  IN 0 SHARED


SELECT;
   "CRE" AS tipodocu,;
   c.nrodocu,;
   ALLTRIM(TRANSFORM(c.nrocuota, "@L 99")) + "/" + ALLTRIM(TRANSFORM(a.qty_cuotas, "@L 99")) AS cuota,;
   a.fechadocu AS fecha_emi,;
   c.fecha AS fecha_vto,;
   (c.importe + c.monto_ndeb) - (c.abonado + c.monto_ncre) AS saldo,;
   c.fecha - DATE() AS dias,;
   "00" AS sucu,;
   a.moneda AS id_moneda,;
   d.nombre AS moneda,;
   d.simbolo,;
   a.cliente AS id_cliente,;
   b.ruc,;
   b.nombre AS cliente,;
   b.direc1 AS direccion,;
   b.telefono,;
   (SELECT SUM((f.importe + f.monto_ndeb) - (f.abonado + f.monto_ncre)) AS vencidos FROM cabevent e, cuotas_v f WHERE e.tipodocu = f.tipodocu AND e.nrodocu = f.nrodocu AND e.moneda = a.moneda AND f.fecha - DATE() <= 0 AND e.cliente = a.cliente),;
   (SELECT SUM((f.importe + f.monto_ndeb) - (f.abonado + f.monto_ncre)) AS a_vencer FROM cabevent e, cuotas_v f WHERE e.tipodocu = f.tipodocu AND e.nrodocu = f.nrodocu AND e.moneda = a.moneda AND f.fecha - DATE() > 0 AND e.cliente = a.cliente),;
   (SELECT SUM((f.importe + f.monto_ndeb) - (f.abonado + f.monto_ncre)) AS total FROM cabevent e, cuotas_v f WHERE e.tipodocu = f.tipodocu AND e.nrodocu = f.nrodocu AND e.moneda = a.moneda AND e.cliente = a.cliente),;
   (SELECT SUM((f.importe + f.monto_ndeb) - (f.abonado + f.monto_ncre)) AS venc_mes FROM cabevent e, cuotas_v f WHERE e.tipodocu = f.tipodocu AND e.nrodocu = f.nrodocu AND e.moneda = a.moneda AND MONTH(f.fecha) <= MONTH(DATE()) AND YEAR(f.fecha) <= YEAR(DATE()) AND e.cliente = a.cliente),;
   (SELECT COUNT(*) AS registros FROM cabevent e, cuotas_v f WHERE e.tipodocu = f.tipodocu AND e.nrodocu = f.nrodocu AND e.moneda = a.moneda AND (f.importe + f.monto_ndeb) - (f.abonado + f.monto_ncre) <> 0 AND e.cliente = a.cliente);
FROM;
   cabevent a,;
   clientes b,;
   cuotas_v c,;
   monedas d;
WHERE;
   a.cliente = b.codigo AND;
   a.tipodocu = c.tipodocu AND;
   a.nrodocu = c.nrodocu AND;
   a.moneda = d.codigo AND;
   (c.importe + c.monto_ndeb) - (c.abonado + c.monto_ncre) <> 0 AND;
   INLIST(a.cliente, 604, 611, 8);
ORDER BY;
   21, a.cliente, c.fecha, c.nrodocu