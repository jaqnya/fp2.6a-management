PARAMETER m.nropedido

pcLocal = "A & A IMPORTACIONES S.R.L."

SELECT cabepedc
LOCATE FOR nropedido = m.nropedido
IF FOUND() THEN
   m.id_plazo = plazo
ELSE
   WAIT "EL PEDIDO N§ " + ALLTRIM(STR(m.nropedido)) + " NO EXISTE." WINDOW
   RETURN
ENDIF
   
SELECT plazos
LOCATE FOR codigo = m.id_plazo
IF FOUND() THEN
   m.plazo = nombre
ELSE
   m.plazo = ""
ENDIF


SELECT;
   a.nropedido,;
   a.fecha,;
   a.hora,;
   a.serieot,;
   a.nroot,;
   a.cliente AS id_cliente,;
   c.nombre AS cliente,;
   c.direc1 AS direccion,;
   c.telefono,;
   c.fax,;
   c.ruc,;
   a.vendedor AS id_vend,;
   e.nombre AS vendedor,;
   a.condicion,;
   b.articulo AS id_product,;
   d.codorig AS cod_origen,;
   d.codigo2 AS cod_altern,;
   d.ubicacion,;
   IIF(EMPTY(b.descr_trab), d.nombre, b.descr_trab) AS producto,;
   b.cantidad,;
   b.precio,;
   b.porc_iva,;
   a.porcdesc,;
   a.importdesc,;
   IIF(a.facturado, "FACTURADO", "PENDIENTE DE FACTURACION") AS estado;
FROM;
   cabepedc a,;
   detapedc b,;
   clientes c,;
   maesprod d,;
   vendedor e;
WHERE;
   a.nropedido = b.nropedido AND;
   a.cliente = c.codigo AND;
   b.articulo = d.codigo AND;
   a.vendedor = e.codigo AND;
   a.nropedido = m.nropedido;
INTO TABLE;
   tmp_jose


REPORT FORM rpt_pedi TO PRINTER

CLOSE DATABASES
CLOSE ALL
CLEAR ALL
CLEAR
QUIT