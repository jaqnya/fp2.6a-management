CLEAR ALL
CLEAR

SET DELETED ON
SET CENTURY ON
SET DATE    BRITISH

ldDesde = CTOD("01/01/2010")
ldHasta = CTOD("31/12/2010")

USE cabecob IN 0 SHARED
USE clientes IN 0 SHARED
USE monedas IN 0 SHARED

SELECT;
   (a.nroreci - 1000000) AS numero,;
   a.fechareci AS fecha,;
   b.nombre AS cliente,;
   b.ruc,;
   ROUND(a.monto_cobr * tipocambio, 0) AS monto_mn,;
   c.simbolo AS divisa,;
   a.monto_cobr AS monto,;
   a.tipocambio AS cambio;
FROM;
   cabecob a,;
   clientes b,;
   monedas c;
WHERE;
   a.cliente = b.codigo AND;
   a.moneda = c.codigo AND;
   a.tiporeci = 1 AND;
   BETWEEN(IIF(EMPTY(a.fechareci), a.fechaanu, a.fechareci), ldDesde, ldHasta);
ORDER BY;
   a.fechareci
   