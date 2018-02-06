CLEAR ALL
CLEAR

SET CENTURY ON
SET DATE BRITISH
SET DELETED ON

USE maesprod IN 0 SHARED
USE clientes IN 0 SHARED
USE cabevent IN 0 SHARED
USE detavent IN 0 SHARED
USE monedas IN 0 SHARED

lcEmail = "dey_py@hotmail.com"
lnCliente = 938

SELECT;
   fmtNroDocu(a.nrodocu) AS factura,;
   IIF(a.tipodocu = 7, "CONTADO", "CREDITO") AS condicion_venta,;
   a.fechadocu AS fecha,;
   c.nombre AS razon_social,;
   c.ruc,;
   b.articulo AS cod_producto,;
   d.nombre AS descripcion,;
   b.cantidad,;
   ROUND(b.precio * (1 + b.pimpuesto / 100), 0) AS precio_unit,;
   ROUND(ROUND(b.precio * (1 + b.pimpuesto / 100), 0) * b.cantidad, 0) AS total,;
   e.simbolo AS moneda;
FROM;
   cabevent a,;
   detavent b,;
   clientes c,;
   maesprod d,;
   monedas e;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.cliente = c.codigo AND;
   a.moneda = e.codigo AND;
   b.articulo = d.codigo AND;
   a.cliente = 938


FUNCTION fmtNroDocu
   PARAMETERS tnNroDocu

   LOCAL tcNroDocu

   DO CASE
      CASE BETWEEN(tnNroDocu, 1000000, 1999999)
         tcNroDocu = "001-001-0" + TRANSFORM(tnNroDocu - 1000000, "@L 999999")
      CASE BETWEEN(tnNroDocu, 2000000, 2999999)
         tcNroDocu = "001-002-0" + TRANSFORM(tnNroDocu - 2000000, "@L 999999")
      CASE BETWEEN(tnNroDocu, 3000000, 3999999)
         tcNroDocu = "003-001-0" + TRANSFORM(tnNroDocu - 3000000, "@L 999999")
      OTHERWISE
         tcNroDocu = STR(tnNroDocu, 15)
   ENDCASE

   RETURN (tcNroDocu)
ENDFUNC 