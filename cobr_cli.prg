PARAMETERS tnCliente

CLEAR
CLOSE DATABASES
CLOSE TABLES

SET CENTURY   ON
SET DATE      BRITISH
SET DELETED   ON
SET EXACT     ON
SET EXCLUSIVE ON
SET SAFETY    OFF
SET TALK      OFF

USE clientes IN 0 SHARED
USE cabevent IN 0 SHARED
USE cuotas_v IN 0 SHARED
USE cabecob  IN 0 SHARED
USE detacob  IN 0 SHARED

CREATE TABLE tm_cuadro (;
   codigo N(5),;
   cliente C(56),;
   documento C(16),;
   numero N(7),;
   fecha_emi D(8),;
   cuota C(5),;
   importe N(9),;
   fecha_vto D(8),;
   saldo N(9),;
   atraso N(5);
)

SELECT;
   c.codigo AS codigo,;
   c.nombre AS cliente,;
   b.tipodocu AS tipo_fact,;
   b.nrodocu AS factura,;
   b.fechadocu AS fecha_emi,;
   a.nrocuota AS nro_cuota,;
   b.qty_cuotas AS cant_cuota,;
   a.importe AS importe,;
   a.fecha AS fecha_vto;
FROM;
   cuotas_v a,;
   cabevent b,;
   clientes c;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   b.cliente = c.codigo AND;
   b.cliente = tnCliente;
ORDER BY;
   a.fecha;
INTO TABLE;
   tm_venta

SELECT;
   c.codigo AS codigo,;
   c.nombre AS cliente,;
   a.tiporeci AS tipo_recib,;
   a.nroreci AS recibo,;
   b.tipodocu AS tipo_fact,;
   b.nrodocu AS factura,;
   b.nrocuota AS nro_cuota,;
   b.monto AS importe,;
   a.fechareci AS fecha_pago;
FROM;
   cabecob  a,;
   detacob  b,;
   clientes c;
WHERE;
   a.tiporeci = b.tiporeci AND;
   a.nroreci = b.nroreci AND;
   a.cliente = c.codigo AND;
   a.cliente = tnCliente;
ORDER BY;
   a.fechareci;
INTO TABLE;
   tm_cobro

SELECT tm_venta
SCAN ALL
   *-------------------------------------------------------------------------------------*
   lnTipoDocu = tipo_fact
   lnNroDocu  = factura
   lnNroCuota = nro_cuota
   *-------------------------------------------------------------------------------------*
   lnCodigo         = codigo
   lcCliente        = cliente
   lnNumero         = factura
   ldFechaEmision   = fecha_emi
   lcCuota          = IIF(nro_cuota < 10, "0" + ALLTRIM(STR(nro_cuota)), ALLTRIM(STR(nro_cuota))) + "/" + IIF(cant_cuota < 10, "0" + ALLTRIM(STR(cant_cuota)), ALLTRIM(STR(cant_cuota)))
   lnImporteFactura = importe
   ldFechaVto       = fecha_vto

   INSERT INTO tm_cuadro (codigo, cliente, documento, numero, fecha_emi, cuota, importe, fecha_vto);
      VALUES (lnCodigo, lcCliente, "FACTURA", lnNumero, ldFechaEmision, lcCuota, lnImporteFactura, ldFechaVto)

   lnSaldo = lnImporteFactura

   SELECT tm_cobro
   SCAN FOR tipo_fact = lnTipoDocu AND factura = lnNroDocu AND nro_cuota = lnNroCuota
      lnNumero       = recibo
      lnImporteCobro = importe
      ldFechaEmision = fecha_pago
      lnSaldo        = lnSaldo - lnImporteCobro
      lnAtraso       = IIF(ldFechaVto - ldFechaEmision < 0, ldFechaEmision - ldFechaVto, 0)
            
      INSERT INTO tm_cuadro (codigo, cliente, documento, numero, importe, fecha_emi, saldo, atraso);
         VALUES (lnCodigo, lcCliente, "RECIBO DE DINERO", lnNumero, -lnImporteCobro, ldFechaEmision, lnSaldo, lnAtraso)
   ENDSCAN
ENDSCAN

SELECT tm_cuadro
BROWSE