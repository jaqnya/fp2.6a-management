CLEAR ALL
CLEAR


SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON
SET EXACT   ON

USE cabevent IN 0 SHARED
USE detavent IN 0 SHARED
USE clientes IN 0 SHARED
USE cabecomp IN 0 SHARED
USE detacomp IN 0 SHARED
USE proveedo IN 0 SHARED
USE maesprod IN 0 SHARED

SELECT;
   fmtNroDocu(a.nrodocu) AS factura,;
   a.fechadocu AS fecha_factura,;
   c.nombre AS cliente,;
   c.ruc,;
   IIF(EMPTY(b.descr_trab), d.nombre, b.descr_trab) AS producto,;
   b.cantidad;
FROM;
   cabevent a,;
   detavent b,;
   clientes c,;
   maesprod d;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.cliente = c.codigo AND;
   b.articulo = d.codigo AND;
   BETWEEN(a.fechadocu, CTOD("23/06/2011"), CTOD("27/06/2011"));
ORDER BY;
   a.fechadocu, a.nrodocu

SELECT;
   a.nrodocu AS factura,;
   a.fechadocu AS fecha_factura,;
   c.nombre AS proveedor,;
   c.ruc,;
   d.nombre AS producto,;
   b.cantidad;
FROM;
   cabecomp a,;
   detacomp b,;
   proveedo c,;
   maesprod d;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.proveedor = b.proveedor AND;
   a.proveedor = c.codigo AND;
   b.articulo = d.codigo AND;
   BETWEEN(a.fechadocu, CTOD("23/06/2011"), CTOD("27/06/2011"));
ORDER BY;
   a.fechadocu, a.nrodocu


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