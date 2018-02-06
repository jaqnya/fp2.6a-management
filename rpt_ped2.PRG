PARAMETER m.nropedido

pcLocal = "A & A IMPORTACIONES S.R.L."

SELECT cabepedc
LOCATE FOR nropedido = m.nropedido
IF FOUND() THEN
   m.nropedido  = nropedido
   m.fecha      = fecha
   m.hora       = hora
   m.serieot    = serieot
   m.nroot      = nroot
   m.id_cliente = cliente
   m.id_vend    = vendedor
   m.condicion  = condicion
   m.porcdesc   = porcdesc
   m.importdesc = importdesc
   m.estado     = IIF(facturado, "FACTURADO", "PENDIENTE DE FACTURACION")
   m.id_plazo   = plazo
ELSE
   WAIT "EL PEDIDO N§ " + ALLTRIM(STR(m.nropedido)) + " NO EXISTE." WINDOW
   RETURN
ENDIF

dbf_file = "tmp" + RIGHT(SYS(2015), 5)

CREATE TABLE (dbf_file) (;
   nropedido N(10),;
   fecha D(8),;
   hora C(8),;
   serieot C(1),;
   nroot N(10),;
   id_cliente N(5),;
   cliente C(56),;
   direccion C(60),;
   telefono C(30),;
   fax C(30),;
   ruc C(15),;
   id_vend N(5),;
   vendedor C(30),;
   condicion N(1),;
   id_product C(15),;
   cod_origen C(15),;
   cod_altern C(15),;
   ubicacion C(10),;
   producto C(50),;
   cantidad N(9,2),;
   precio N(9),;
   porc_iva N(6,2),;
   porcdesc N(8,4),;
   importdesc N(9),;
   estado C(24);
)

SELECT clientes
LOCATE FOR codigo = m.id_cliente
IF FOUND() THEN
   m.cliente   = nombre
   m.direccion = direc1
   m.telefono  = telefono
   m.fax       = fax
   m.ruc       = ruc
ELSE
   m.cliente   = ""
   m.direccion = ""
   m.telefono  = ""
   m.fax       = ""
   m.ruc       = ""
ENDIF

SELECT plazos
LOCATE FOR codigo = m.id_plazo
IF FOUND() THEN
   m.plazo = nombre
ELSE
   m.plazo = ""
ENDIF

SELECT vendedor
LOCATE FOR codigo = m.id_vend
IF FOUND() THEN
   m.vendedor = nombre
ELSE
   m.vendedor = ""
ENDIF

SELECT detapedc
SET ORDER TO 1
IF SEEK(m.nropedido) THEN
   SCAN WHILE nropedido = m.nropedido
      m.id_product = articulo
      m.descr_trab = descr_trab
      m.cantidad   = cantidad
      m.precio     = precio
      m.porc_iva   = porc_iva

      SELECT maesprod
      SET ORDER TO 1
      IF SEEK(m.id_product) THEN
         m.producto   = IIF(EMPTY(m.descr_trab), nombre, m.descr_trab)
         m.cod_altern = codigo2
         m.cod_origen = codorig
         m.ubicacion  = ubicacion
      ELSE
         m.producto   = m.descr_trab
         m.cod_altern = ""
         m.cod_origen = ""
         m.ubicacion  = ""
      ENDIF

      INSERT INTO (dbf_file) FROM MEMVAR
   ENDSCAN
ENDIF

SELECT (dbf_file)
REPORT FORM rpt_pedi TO PRINTER NOCONSOLE
USE
DELETE FILE (dbf_file + ".dbf")