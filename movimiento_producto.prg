DO seteo

USE cabecomp IN 0 SHARED
USE detacomp IN 0 SHARED
USE cabenotp IN 0 SHARED
USE detanotp IN 0 SHARED

ldFechaDesde = CTOD("01/01/2011")
ldFechaHasta = CTOD("31/12/2011")
lcArticulo   = "7485"

CREATE CURSOR tm_cuadro (;
   producto C(56),;
   ene_cant N(6),;
   ene_valor N(9),;
   feb_cant N(6),;
   feb_valor N(9),;
   mar_cant N(6),;
   mar_valor N(9),;
   abr_cant N(6),;
   abr_valor N(9),;
   may_cant N(6),;
   may_valor N(9),;
   jun_cant N(6),;
   jun_valor N(9),;
   jul_cant N(6),;
   jul_valor N(9),;
   ago_cant N(6),;
   ago_valor N(9),;
   sep_cant N(6),;
   sep_valor N(9),;
   oct_cant N(6),;
   oct_valor N(9),;
   nov_cant N(6),;
   nov_valor N(9),;
   dic_cant N(6),;
   dic_valor N(9),;
   total_cant N(6),;
   total_valor N(9);
)

APPEND BLANK IN tm_cuadro

* selecciona las facturas de proveedores que cumplan con la condicion
SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.proveedor,;
   a.fechadocu;
FROM;
   cabecomp a,;
   detacomp b;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.proveedor = b.proveedor AND;
   BETWEEN(a.fechadocu, ldFechaDesde, ldFechaHasta) AND;
   b.articulo = lcArticulo;
INTO CURSOR;
   tm_compra

i = 1
SELECT tm_compra
SCAN ALL
   WAIT "Procesando Compras: " + ALLTRIM(STR(i)) + "/" + ALLTRIM(STR(RECCOUNT())) WINDOW NOWAIT

   lnTipoDocu  = tipodocu
   lnNroDocu   = nrodocu
   lnProveedor = proveedor
   ldFechaDocu = fechadocu

   DO obtener_detalle_neto_compra WITH lnTipoDocu, lnNroDocu, lnProveedor

   * inicializacion de variables
   lcProducto = ""
   lnCantidad = 0
   lnValor    = 0

   SELECT tm_detacomp
   SCAN FOR articulo = lcArticulo
      lcProducto = producto
      lnCantidad = lnCantidad + cantidad
      lnValor    = lnValor + ROUND(precio_unit_mmnn * cantidad, 0)
   ENDSCAN

   SELECT tm_cuadro
   REPLACE producto WITH lcProducto

   DO CASE
      CASE MONTH(ldFechaDocu) = 1
         REPLACE ene_cant  WITH ene_cant  + lnCantidad,;
                 ene_valor WITH ene_valor + lnValor
      CASE MONTH(ldFechaDocu) = 2
         REPLACE feb_cant  WITH feb_cant  + lnCantidad,;
                 feb_valor WITH feb_valor + lnValor
      CASE MONTH(ldFechaDocu) = 3
         REPLACE mar_cant  WITH mar_cant  + lnCantidad,;
                 mar_valor WITH mar_valor + lnValor
      CASE MONTH(ldFechaDocu) = 4
         REPLACE abr_cant  WITH abr_cant  + lnCantidad,;
                 abr_valor WITH abr_valor + lnValor
      CASE MONTH(ldFechaDocu) = 5
         REPLACE may_cant  WITH may_cant  + lnCantidad,;
                 may_valor WITH may_valor + lnValor
      CASE MONTH(ldFechaDocu) = 6
         REPLACE jun_cant  WITH jun_cant  + lnCantidad,;
                 jun_valor WITH jun_valor + lnValor
      CASE MONTH(ldFechaDocu) = 7
         REPLACE jul_cant  WITH jul_cant  + lnCantidad,;
                 jul_valor WITH jul_valor + lnValor
      CASE MONTH(ldFechaDocu) = 8
         REPLACE ago_cant  WITH ago_cant  + lnCantidad,;
                 ago_valor WITH ago_valor + lnValor
      CASE MONTH(ldFechaDocu) = 9
         REPLACE sep_cant  WITH sep_cant  + lnCantidad,;
                 sep_valor WITH sep_valor + lnValor
      CASE MONTH(ldFechaDocu) = 10
         REPLACE oct_cant  WITH oct_cant  + lnCantidad,;
                 oct_valor WITH oct_valor + lnValor
      CASE MONTH(ldFechaDocu) = 11
         REPLACE nov_cant  WITH nov_cant  + lnCantidad,;
                 nov_valor WITH nov_valor + lnValor
      CASE MONTH(ldFechaDocu) = 12
         REPLACE dic_cant  WITH dic_cant  + lnCantidad,;
                 dic_valor WITH dic_valor + lnValor
   ENDCASE

   i = i + 1
ENDSCAN

* selecciona las notas de creditos de proveedores que cumplan con la condicion
SELECT;
   a.tiponota,;
   a.nronota,;
   a.fechanota,;
   a.tipodocu,;
   a.nrodocu,;
   a.proveedor,;
   IIF(b.tipocambio = 0, 000001.00, b.tipocambio) AS tipocambio,;
   c.tipo,;
   c.articulo,;
   c.precio,;
   c.cantidad,;
   ROUND(c.precio * c.cantidad, 4) AS subtotal,;
   ROUND(ROUND(c.precio * c.cantidad, 4) * c.pdescuento / 100, 4) AS descuento,;
   ROUND((ROUND(c.precio * c.cantidad, 4) - ROUND(ROUND(c.precio * c.cantidad, 4) * c.pdescuento / 100, 4)) * IIF(b.tipocambio = 0, 000001.00, b.tipocambio), 0) AS total;
FROM;
   cabenotp a,;
   cabecomp b,;
   detanotp c;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.proveedor = b.proveedor AND;
   a.tiponota = c.tiponota AND;
   a.nronota = c.nronota AND;
   a.proveedor = c.proveedor AND;
   BETWEEN(a.fechanota, ldFechaDesde, ldFechaHasta) AND;
   c.articulo = lcArticulo;
INTO CURSOR;
   tm_devolucion
   
i = 1
SELECT tm_devolucion
SCAN ALL
   WAIT "Procesando Devoluciones: " + ALLTRIM(STR(i)) + "/" + ALLTRIM(STR(RECCOUNT())) WINDOW NOWAIT

   ldFechaDocu = fechanota
   lcTipo      = tipo
   lnCantidad  = -cantidad
   lnValor     = -total

   SELECT tm_cuadro
   DO CASE
      CASE MONTH(ldFechaDocu) = 1
         REPLACE ene_cant  WITH ene_cant  + lnCantidad,;
                 ene_valor WITH ene_valor + lnValor
      CASE MONTH(ldFechaDocu) = 2
         REPLACE feb_cant  WITH feb_cant  + lnCantidad,;
                 feb_valor WITH feb_valor + lnValor
      CASE MONTH(ldFechaDocu) = 3
         REPLACE mar_cant  WITH mar_cant  + lnCantidad,;
                 mar_valor WITH mar_valor + lnValor
      CASE MONTH(ldFechaDocu) = 4
         REPLACE abr_cant  WITH abr_cant  + lnCantidad,;
                 abr_valor WITH abr_valor + lnValor
      CASE MONTH(ldFechaDocu) = 5
         REPLACE may_cant  WITH may_cant  + lnCantidad,;
                 may_valor WITH may_valor + lnValor
      CASE MONTH(ldFechaDocu) = 6
         REPLACE jun_cant  WITH jun_cant  + lnCantidad,;
                 jun_valor WITH jun_valor + lnValor
      CASE MONTH(ldFechaDocu) = 7
         REPLACE jul_cant  WITH jul_cant  + lnCantidad,;
                 jul_valor WITH jul_valor + lnValor
      CASE MONTH(ldFechaDocu) = 8
         REPLACE ago_cant  WITH ago_cant  + lnCantidad,;
                 ago_valor WITH ago_valor + lnValor
      CASE MONTH(ldFechaDocu) = 9
         REPLACE sep_cant  WITH sep_cant  + lnCantidad,;
                 sep_valor WITH sep_valor + lnValor
      CASE MONTH(ldFechaDocu) = 10
         REPLACE oct_cant  WITH oct_cant  + lnCantidad,;
                 oct_valor WITH oct_valor + lnValor
      CASE MONTH(ldFechaDocu) = 11
         REPLACE nov_cant  WITH nov_cant  + lnCantidad,;
                 nov_valor WITH nov_valor + lnValor
      CASE MONTH(ldFechaDocu) = 12
         REPLACE dic_cant  WITH dic_cant  + lnCantidad,;
                 dic_valor WITH dic_valor + lnValor
   ENDCASE

   i = i + 1
ENDSCAN

WAIT CLEAR

SELECT tm_cuadro
REPLACE total_cant  WITH ene_cant + feb_cant + mar_cant + abr_cant + may_cant + jun_cant +;
                         jul_cant + ago_cant + sep_cant + oct_cant + nov_cant + dic_cant,;
        total_valor WITH ene_valor + feb_valor + mar_valor + abr_valor + may_valor + jun_valor +;
                         jul_valor + ago_valor + sep_valor + oct_valor + nov_valor + dic_valor

BROWSE