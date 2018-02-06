CLEAR ALL
CLEAR

SET CENTURY ON
SET DATE BRITISH
SET DELETED ON
SET EXACT ON
SET SAFETY OFF

USE cabecomp IN 0 SHARED
USE cabepag  IN 0 SHARED
USE detapag  IN 0 SHARED
USE cabenotp IN 0 SHARED
USE proveedo IN 0 SHARED
USE monedas  IN 0 SHARED

SELECT;
   c.nrodocu AS factura,;
   c.fechadocu AS fecha_factura,;
   d.nombre AS proveedor,;
   d.ruc,;
   c.monto_fact AS importe_factura,;
   e.simbolo AS divisa,;
   a.nroreci AS recibo,;
   a.fechareci AS fecha_recibo,;
   b.monto AS importe_cobro;
FROM;
   cabepag a,;
   detapag b,;
   cabecomp c,;
   proveedo d,;
   monedas e;
WHERE;
   a.tiporeci = b.tiporeci AND;
   a.nroreci = b.nroreci AND;
   a.proveedor = b.proveedor AND;
   b.tipodocu = c.tipodocu AND;
   b.nrodocu = c.nrodocu AND;
   b.proveedor = c.proveedor AND;
   c.proveedor = d.codigo AND;
   c.moneda = e.codigo AND;
   YEAR(c.fechadocu) = 2010;
ORDER BY;
   d.nombre,;
   c.nrodocu,;
   c.fechadocu

EXPORT TO c:\detalle_pago TYPE XL5


SELECT;
   b.nrodocu AS factura,;
   b.fechadocu AS fecha_factura,;
   c.nombre AS proveedor,;
   c.ruc,;
   b.monto_fact AS importe_factura,;
   d.simbolo AS divisa,;
   a.nronota AS nota_credito,;
   a.fechanota AS fecha_nota,;
   a.monto_nota AS importe_nota;
FROM;
   cabenotp a,;
   cabecomp b,;
   proveedo c,;
   monedas d;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.proveedor = b.proveedor AND;
   b.proveedor = c.codigo AND;
   b.moneda = d.codigo AND;
   YEAR(b.fechadocu) = 2010 AND;
   a.aplicontra = 2;
ORDER BY;
   c.nombre,;
   b.nrodocu,;
   b.fechadocu


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