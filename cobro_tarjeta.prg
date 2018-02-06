CLEAR ALL
CLEAR

SET DELETED ON
SET DATE BRITISH
SET CENTURY ON

USE cabevent IN 0 SHARED
USE form_cob IN 0 SHARED
USE cabecob IN 0 SHARED

* Factura
SELECT;
   fmtNroDocu(a.nrodocu) AS factura,;
   b.fechadocu AS fecha,;
   "Factura Contado" AS documento,;
   ROUND(a.importe, 0) AS importe;
FROM;
   form_cob a,;
   cabevent b;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   YEAR(b.fechadocu) = 2010 AND;
   a.tipodocu = 7 AND;
   a.forma_id = 3

EXPORT TO c:\tarjeta_factura TYPE XLS

SELECT;
   fmtNroDocu(a.nrodocu) AS factura,;
   b.fechadocu AS fecha,;
   "Factura Contado" AS documento,;
   ROUND(a.importe * cambio, 0) AS importe,;
   a.importe AS importe_usd,;
   a.cambio;   
FROM;
   form_cob a,;
   cabevent b;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   YEAR(b.fechadocu) = 2010 AND;
   a.tipodocu = 7 AND;
   a.forma_id = 2

EXPORT TO c:\tarjeta_factura TYPE XLS

* Recibo
SELECT;
   (a.nrodocu - 1000000) AS recibo,;
   b.fechareci AS fecha,;
   "Recibo de Dinero" AS documento,;
   ROUND(a.importe, 0) AS importe;
FROM;
   form_cob a,;
   cabecob b;
WHERE;
   a.tipodocu = b.tiporeci AND;
   a.nrodocu = b.nroreci AND;
   YEAR(b.fechareci) = 2010 AND;
   a.doc_id = 2 AND;
   a.forma_id = 3


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
