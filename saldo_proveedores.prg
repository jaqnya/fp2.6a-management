CLEAR ALL
CLEAR

SET DELETED ON
SET DATE BRITISH
SET CENTURY ON

USE cabecomp IN 0 SHARED
USE proveedo IN 0 SHARED
USE cuotas_c IN 0 SHARED
USE monedas IN 0 SHARED


SELECT;
   b.nombre AS razon_social,;
   b.ruc AS ruc,;
   a.nrodocu AS factura,;
   (IIF(c.nrocuota < 10, "0" + ALLTRIM(STR(c.nrocuota)), ALLTRIM(STR(c.nrocuota))) + "/" + IIF(a.qty_cuotas < 10, "0" + ALLTRIM(STR(a.qty_cuotas)), ALLTRIM(STR(a.qty_cuotas)))) AS cuota,;
   a.fechadocu AS fecha_emi,;
   c.fecha AS fecha_vto,;
   ROUND(((c.importe + c.monto_ndeb) - (c.abonado + c.monto_ncre)) * a.tipocambio, 0) AS saldo_mn,;
   d.simbolo AS divisa,;
   a.tipocambio AS cambio,;
   ((c.importe + c.monto_ndeb) - (c.abonado + c.monto_ncre)) AS saldo;
FROM;
   cabecomp a,;
   proveedo b,;
   cuotas_c c,;
   monedas d;
WHERE;
   a.proveedor = b.codigo AND;
   a.tipodocu = c.tipodocu AND;
   a.nrodocu = c.nrodocu AND;
   a.proveedor = c.proveedor AND;
   ((c.importe + c.monto_ndeb) - (c.abonado + c.monto_ncre)) <> 0 AND;
   a.moneda = d.codigo;
ORDER BY;
   razon_social,;
   factura



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
   