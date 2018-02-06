CLEAR ALL
CLEAR

SET CENTURY ON
SET DATE BRITISH
SET DELETED ON
SET EXACT ON
SET SAFETY OFF

USE cabevent IN 0 SHARED
USE cabecob  IN 0 SHARED
USE detacob  IN 0 SHARED
USE cabenotc IN 0 SHARED
USE clientes IN 0 SHARED
USE monedas  IN 0 SHARED

SELECT;
   fmtNroDocu(c.nrodocu) AS factura,;
   c.fechadocu AS fecha_factura,;
   d.nombre AS cliente,;
   d.ruc,;
   c.monto_fact AS importe_factura,;
   e.simbolo AS divisa,;
   (a.nroreci - 1000000) AS recibo,;
   a.fechareci AS fecha_recibo,;
   b.monto AS importe_cobro;
FROM;
   cabecob a,;
   detacob b,;
   cabevent c,;
   clientes d,;
   monedas e;
WHERE;
   a.tiporeci = b.tiporeci AND;
   a.nroreci = b.nroreci AND;
   b.tipodocu = c.tipodocu AND;
   b.nrodocu = c.nrodocu AND;
   c.cliente = d.codigo AND;
   c.moneda = e.codigo AND;
   YEAR(c.fechadocu) = 2010;
ORDER BY;
   c.fechadocu,;
   c.nrodocu

EXPORT TO c:\detalle_cobro TYPE XL5


SELECT;
   fmtNroDocu(b.nrodocu) AS factura,;
   b.fechadocu AS fecha_factura,;
   c.nombre AS cliente,;
   c.ruc,;
   b.monto_fact AS importe_factura,;
   d.simbolo AS divisa,;
   fmtNroNota(a.nronota) AS nota_credito,;
   a.fechanota AS fecha_nota,;
   a.monto_nota AS importe_nota;
FROM;
   cabenotc a,;
   cabevent b,;
   clientes c,;
   monedas d;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   b.cliente = c.codigo AND;
   b.moneda = d.codigo AND;
   YEAR(b.fechadocu) = 2010 AND;
   a.aplicontra = 2;
ORDER BY;
   b.fechadocu,;
   b.nrodocu;

EXPORT TO c:\detalle_nota_credito TYPE XL5


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

FUNCTION fmtNroNota
   PARAMETERS tnNroNota

   LOCAL tcNroNota

   DO CASE
      CASE BETWEEN(tnNroNota, 1000000, 1999999)
         tcNroNota = "001-001-0" + TRANSFORM(tnNroNota - 1000000, "@L 999999")
      CASE BETWEEN(tnNroNota, 2000000, 2999999)
         tcNroNota = "001-002-0" + TRANSFORM(tnNroNota - 2000000, "@L 999999")
      CASE BETWEEN(tnNroNota, 3000000, 3999999)
         tcNroNota = "003-001-0" + TRANSFORM(tnNroNota - 3000000, "@L 999999")
      OTHERWISE
         tcNroNota = STR(tnNroNota, 15)
   ENDCASE

   RETURN (tcNroNota)
ENDFUNC