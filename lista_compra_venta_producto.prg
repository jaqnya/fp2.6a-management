*
* lista_compra_venta_producto.prg
*
* Derechos Reservados (c) 2000 - 2010 José Acuña
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Devuelve un listado de la cantidad de productos vendidos calcula las ventas
* mensuales y el total, además del total comprado; con la posibilidad de 
* excluir a un cliente.
*
* Historial de Modificación:
* Mayo 19, 2011	Jose Avilio Acuña Acosta	Creador del Programa
*

PARAMETERS m.anyo, m.marca, m.cliente

IF PARAMETERS() < 2 THEN
   WAIT "PROGRAMA: LISTA_COMPRA_VENTA_PRODUCTO.PRG" + CHR(13) + "NO SE HAN PASADO SUFICIENTES PARAMETROS." WINDOW
   RETURN
ENDIF

IF TYPE("m.anyo") <> "N" THEN
   WAIT "PROGRAMA: LISTA_COMPRA_VENTA_PRODUCTO.PRG" + CHR(13) + "EL PRIMER PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW
   RETURN
ENDIF

IF TYPE("m.marca") <> "N" THEN
   WAIT "PROGRAMA: LISTA_COMPRA_VENTA_PRODUCTO.PRG" + CHR(13) + "EL SEGUNDO PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW
   RETURN
ENDIF

IF !INLIST(TYPE("m.cliente"), "U", "L") THEN
   IF TYPE("m.cliente") <> "N" THEN
      WAIT "PROGRAMA: LISTA_COMPRA_VENTA_PRODUCTO.PRG" + CHR(13) + "EL TERCER PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW
      RETURN
   ENDIF
ENDIF

IF !USED("maesprod") THEN
   USE maesprod IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabevent") THEN
   USE cabevent IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detavent") THEN
   USE detavent IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabenotc") THEN
   USE cabenotc IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detanotc") THEN
   USE detanotc IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabecomp") THEN
   USE cabecomp IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detacomp") THEN
   USE detacomp IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabenotp") THEN
   USE cabenotp IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detanotp") THEN
   USE detanotp IN 0 AGAIN ORDER 1 SHARED
ENDIF

SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON
SET SAFETY  OFF
SET TALK    OFF

WAIT "INICIALIZANDO..." WINDOW NOWAIT

* archivo temporal
CREATE CURSOR tm_informe (;
   codigo C(15),;
   cod_origen C(15),;
   cod_altern C(15),;
   producto C(40),;
   enero N(6,2),;
   febrero N(6,2),;
   marzo N(6,2),;
   abril N(6,2),;
   mayo N(6,2),;
   junio N(6,2),;
   julio N(6,2),;
   agosto N(6,2),;
   setiembre N(6,2),;
   octubre N(6,2),;
   noviembre N(6,2),;
   diciembre N(6,2),;
   total_vent N(6,2),;
   total_comp N(6,2);
)

* -- procesa el archivo de compras ----------------------------------------*
WAIT "CONSULTANDO ARCHIVO DE VENTAS..." WINDOW NOWAIT

IF TYPE("m.cliente") <> "N" THEN
   SELECT;
      b.articulo AS id_producto,;
      MONTH(a.fechadocu) AS mes,;
      SUM(b.cantidad) AS cantidad;
   FROM;
      cabevent a,;
      detavent b,;
      maesprod c;
   WHERE;
      a.tipodocu = b.tipodocu AND;
      a.nrodocu = b.nrodocu AND;
      b.articulo = c.codigo AND;
      YEAR(a.fechadocu) = m.anyo AND;
      c.marca = m.marca;
   GROUP BY;
      id_producto,;
      mes;
   INTO CURSOR;
      tm_venta
ELSE
   SELECT;
      b.articulo AS id_producto,;
      MONTH(a.fechadocu) AS mes,;
      SUM(b.cantidad) AS cantidad;
   FROM;
      cabevent a,;
      detavent b,;
      maesprod c;
   WHERE;
      a.tipodocu = b.tipodocu AND;
      a.nrodocu = b.nrodocu AND;
      b.articulo = c.codigo AND;
      YEAR(a.fechadocu) = m.anyo AND;
      c.marca = m.marca AND;
      a.cliente <> m.cliente;
   GROUP BY;
      id_producto,;
      mes;
   INTO CURSOR;
      tm_venta
ENDIF

* -- procesa el archivo de notas de debitos y creditos de proveedores -----*
WAIT "CONSULTANDO ARCHIVO DE NOTAS DE DEBITOS DE CLIENTES..." WINDOW NOWAIT

SELECT;
   b.articulo AS id_producto,;
   MONTH(a.fechanota) AS mes,;
   SUM(b.cantidad) AS cantidad;
FROM;
   cabenotc a,;
   detanotc b,;
   maesprod c;
WHERE;
   a.tiponota = b.tiponota AND;
   a.nronota = b.nronota AND;
   b.articulo = c.codigo AND;
   a.tiponota = 1 AND;
   b.tipo = "S" AND;
   YEAR(a.fechanota) = m.anyo AND;
   c.marca = m.marca;
GROUP BY;
   id_producto,;
   mes;
INTO CURSOR;
   tm_nota_debito_cliente

WAIT "CONSULTANDO ARCHIVO DE NOTAS DE CREDITOS DE CLIENTES..." WINDOW NOWAIT

SELECT;
   b.articulo AS id_producto,;
   MONTH(a.fechanota) AS mes,;
   SUM(b.cantidad) AS cantidad;
FROM;
   cabenotc a,;
   detanotc b,;
   maesprod c;
WHERE;
   a.tiponota = b.tiponota AND;
   a.nronota = b.nronota AND;
   b.articulo = c.codigo AND;
   a.tiponota = 2 AND;
   b.tipo = "S" AND;
   YEAR(a.fechanota) = m.anyo AND;
   c.marca = m.marca;
GROUP BY;
   id_producto,;
   mes;
INTO CURSOR;
   tm_nota_credito_cliente

* -- procesa el archivo de compras ----------------------------------------*
WAIT "CONSULTANDO ARCHIVO DE COMPRAS..." WINDOW NOWAIT

SELECT;
   b.articulo AS id_producto,;
   SUM(b.cantidad) AS cantidad;
FROM;
   cabecomp a,;
   detacomp b,;
   maesprod c;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.proveedor = b.proveedor AND;
   b.articulo = c.codigo AND;
   YEAR(a.fechadocu) = m.anyo AND;
   c.marca = m.marca;
GROUP BY;
   b.articulo;
INTO CURSOR;
   tm_compra

* -- procesa el archivo de notas de debitos y creditos de proveedores -----*
WAIT "CONSULTANDO ARCHIVO DE NOTAS DE DEBITOS DE PROVEEDORES..." WINDOW NOWAIT

SELECT;
   b.articulo AS id_producto,;
   SUM(b.cantidad) AS cantidad;
FROM;
   cabenotp a,;
   detanotp b,;
   maesprod c;
WHERE;
   a.tiponota = b.tiponota AND;
   a.nronota = b.nronota AND;
   a.proveedor = b.proveedor AND;
   b.articulo = c.codigo AND;
   a.tiponota = 1 AND;
   b.tipo = "S" AND;
   YEAR(a.fechanota) = m.anyo AND;
   c.marca = m.marca;
GROUP BY;
   b.articulo;
INTO CURSOR;
   tm_nota_debito_proveedor

WAIT "CONSULTANDO ARCHIVO DE NOTAS DE CREDITOS DE PROVEEDORES..." WINDOW NOWAIT

SELECT;
   b.articulo AS id_producto,;
   SUM(b.cantidad) AS cantidad;
FROM;
   cabenotp a,;
   detanotp b,;
   maesprod c;
WHERE;
   a.tiponota = b.tiponota AND;
   a.nronota = b.nronota AND;
   a.proveedor = b.proveedor AND;
   b.articulo = c.codigo AND;
   a.tiponota = 2 AND;
   b.tipo = "S" AND;
   YEAR(a.fechanota) = m.anyo AND;
   c.marca = m.marca;
GROUP BY;
   b.articulo;
INTO CURSOR;
   tm_nota_credito_proveedor

*-- crea informe ----------------------------------------------------------*
WAIT "CREANDO INFORME..." WINDOW NOWAIT

SELECT tm_venta
SCAN ALL
   SCATTER MEMVAR
   SELECT tm_informe
   LOCATE FOR codigo = m.id_producto
   IF !FOUND() THEN
      APPEND BLANK
      REPLACE codigo WITH m.id_producto
   ENDIF

   DO CASE
      CASE m.mes = 1
         REPLACE enero WITH enero + m.cantidad
      CASE m.mes = 2
         REPLACE febrero WITH febrero + m.cantidad
      CASE m.mes = 3
         REPLACE marzo WITH marzo + m.cantidad
      CASE m.mes = 4
         REPLACE abril WITH abril + m.cantidad
      CASE m.mes = 5
         REPLACE mayo WITH mayo + m.cantidad
      CASE m.mes = 6
         REPLACE junio WITH junio + m.cantidad
      CASE m.mes = 7
         REPLACE julio WITH julio + m.cantidad
      CASE m.mes = 8
         REPLACE agosto WITH agosto + m.cantidad
      CASE m.mes = 9
         REPLACE setiembre WITH setiembre + m.cantidad
      CASE m.mes = 10
         REPLACE octubre WITH octubre + m.cantidad
      CASE m.mes = 11
         REPLACE noviembre WITH noviembre + m.cantidad
      CASE m.mes = 12
         REPLACE diciembre WITH diciembre + m.cantidad
   ENDCASE
ENDSCAN

SELECT tm_nota_debito_cliente
SCAN ALL
   SCATTER MEMVAR
   SELECT tm_informe
   LOCATE FOR codigo = m.id_producto
   IF !FOUND() THEN
      APPEND BLANK
      REPLACE codigo WITH m.id_producto
   ENDIF

   DO CASE
      CASE m.mes = 1
         REPLACE enero WITH enero + m.cantidad
      CASE m.mes = 2
         REPLACE febrero WITH febrero + m.cantidad
      CASE m.mes = 3
         REPLACE marzo WITH marzo + m.cantidad
      CASE m.mes = 4
         REPLACE abril WITH abril + m.cantidad
      CASE m.mes = 5
         REPLACE mayo WITH mayo + m.cantidad
      CASE m.mes = 6
         REPLACE junio WITH junio + m.cantidad
      CASE m.mes = 7
         REPLACE julio WITH julio + m.cantidad
      CASE m.mes = 8
         REPLACE agosto WITH agosto + m.cantidad
      CASE m.mes = 9
         REPLACE setiembre WITH setiembre + m.cantidad
      CASE m.mes = 10
         REPLACE octubre WITH octubre + m.cantidad
      CASE m.mes = 11
         REPLACE noviembre WITH noviembre + m.cantidad
      CASE m.mes = 12
         REPLACE diciembre WITH diciembre + m.cantidad
   ENDCASE
ENDSCAN

SELECT tm_nota_credito_cliente
SCAN ALL
   SCATTER MEMVAR
   SELECT tm_informe
   LOCATE FOR codigo = m.id_producto
   IF !FOUND() THEN
      APPEND BLANK
      REPLACE codigo WITH m.id_producto
   ENDIF

   DO CASE
      CASE m.mes = 1
         REPLACE enero WITH enero - m.cantidad
      CASE m.mes = 2
         REPLACE febrero WITH febrero - m.cantidad
      CASE m.mes = 3
         REPLACE marzo WITH marzo - m.cantidad
      CASE m.mes = 4
         REPLACE abril WITH abril - m.cantidad
      CASE m.mes = 5
         REPLACE mayo WITH mayo - m.cantidad
      CASE m.mes = 6
         REPLACE junio WITH junio - m.cantidad
      CASE m.mes = 7
         REPLACE julio WITH julio - m.cantidad
      CASE m.mes = 8
         REPLACE agosto WITH agosto - m.cantidad
      CASE m.mes = 9
         REPLACE setiembre WITH setiembre - m.cantidad
      CASE m.mes = 10
         REPLACE octubre WITH octubre - m.cantidad
      CASE m.mes = 11
         REPLACE noviembre WITH noviembre - m.cantidad
      CASE m.mes = 12
         REPLACE diciembre WITH diciembre - m.cantidad
   ENDCASE
ENDSCAN

SELECT tm_compra
SCAN ALL
   SCATTER MEMVAR
   SELECT tm_informe
   LOCATE FOR codigo = m.id_producto
   IF !FOUND() THEN
      APPEND BLANK
      REPLACE codigo WITH m.id_producto
   ENDIF
   REPLACE total_comp WITH total_comp + m.cantidad
ENDSCAN

SELECT tm_nota_debito_proveedor
SCAN ALL
   SCATTER MEMVAR
   SELECT tm_informe
   LOCATE FOR codigo = m.id_producto
   IF !FOUND() THEN
      APPEND BLANK
      REPLACE codigo WITH m.id_producto
   ENDIF
   REPLACE total_comp WITH total_comp + m.cantidad
ENDSCAN

SELECT tm_nota_credito_proveedor
SCAN ALL
   SCATTER MEMVAR
   SELECT tm_informe
   LOCATE FOR codigo = m.id_producto
   IF !FOUND() THEN
      APPEND BLANK
      REPLACE codigo WITH m.id_producto
   ENDIF
   REPLACE total_comp WITH total_comp - m.cantidad
ENDSCAN

SELECT maesprod
SCAN ALL
   m.id_producto = codigo
   m.cod_origen = codorig
   m.cod_altern = codigo2
   m.producto = nombre

   SELECT tm_informe
   LOCATE FOR codigo = m.id_producto
   IF FOUND() THEN
      REPLACE cod_origen WITH m.cod_origen,;
              cod_altern WITH m.cod_altern,;
              producto   WITH m.producto
   ENDIF
ENDSCAN

SELECT tm_informe
REPLACE total_vent WITH enero + febrero + marzo + abril + mayo + junio + julio + agosto + setiembre + octubre + noviembre + diciembre ALL
BROWSE