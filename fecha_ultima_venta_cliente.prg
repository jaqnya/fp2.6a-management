DO seteo

USE cabevent IN 0 SHARED
USE clientes IN 0 SHARED
USE ruta IN 0 SHARED

CREATE CURSOR tm_listado (;
   estado C(8),;
   id_cliente N(5),;
   cliente C(56),;
   contacto C(30),;
   telefono C(30),;
   id_ruta N(5),;
   ruta C(50),;
   fecuventa D(8),;
   importe N(9),;
   factura C(15);
)

SELECT;
   IIF(a.estado = "A", "ACTIVO", "INACTIVO") AS estado,;
   a.codigo AS id_cliente,;
   a.nombre AS cliente,;
   a.contacto AS contacto,;
   a.telefono AS telefono,;
   a.ruta AS id_ruta,;
   b.nombre AS ruta;
FROM;
   clientes a;
   LEFT JOIN ruta b;
      ON a.ruta = b.id_ruta;
INTO CURSOR;
   tm_cliente

SELECT;
   cliente,;
   fechadocu,;
   tipodocu,;
   nrodocu,;
   monto_fact;
FROM;
   cabevent;
ORDER BY;
   cliente,;
   fechadocu DESC,;
   nrodocu DESC;
INTO CURSOR;
   tm_venta

SELECT tm_cliente
SCAN ALL
   lcEstado = estado
   lnIdCliente = id_cliente
   lcCliente = cliente
   lcContacto = contacto
   lcTelefono = telefono
   lnIdRuta = id_ruta
   lcRuta = IIF(ISNULL(ruta), "", ruta)

   INSERT INTO tm_listado (estado, id_cliente, cliente, contacto, telefono, id_ruta, ruta);
      VALUES (lcEstado, lnIdCliente, lcCliente, lcContacto, lcTelefono, lnIdRuta, lcRuta)
ENDSCAN

SELECT tm_listado
SCAN ALL
   lnIdCliente = id_cliente
   ldFecUVenta = CTOD("  /  /    ")
   lnImporte = 0
   lcFactura = ""

   SELECT tm_venta
   LOCATE FOR cliente  = lnIdCliente
   IF FOUND() THEN
      ldFecUVenta = fechadocu
      lnImporte = monto_fact
      lcFactura = ALLTRIM(STR(tipodocu)) + "/" + ALLTRIM(STR(nrodocu))
   ENDIF

   SELECT tm_listado
   REPLACE fecuventa WITH ldFecUVenta,;
           importe WITH lnImporte,;
           factura WITH lcFactura
ENDSCAN