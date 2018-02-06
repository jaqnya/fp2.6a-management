*
* movimiento_articulo.prg
* 
* Derechos Reservados (c) 2000-2009 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
* 
* Descripcion:
* Verifica la integridad referencial del estado de las ordenes de
* trabajo
*
* Historial de Modificacion:
* Julio 16, 2009   Jose Avilio Acuna Acosta   Creador del Programa
*
PARAMETER tcArticulo
tcArticulo = LEFT(ALLTRIM(tcArticulo) + SPACE(15), 15)

CLEAR
CLOSE DATABASES

SET CENTURY   ON
SET DATE      BRITISH
SET DELETED   ON
SET ESCAPE    OFF
SET EXCLUSIVE OFF
SET SAFETY    OFF
SET TALK      OFF
*-----------------------------------------------------------------------------*
WAIT "Consultando [ENTRADAS]" WINDOW NOWAIT
SELECT;
   a.tipobole,;
   a.nrobole,;
   a.fecha,;
   b.cantidad;
FROM;
   cabemovi a;
   INNER JOIN detamovi b;
      ON a.tipobole = b.tipobole AND;
         a.nrobole = b.nrobole;
WHERE;
   INLIST(a.tipobole, 1, 3) AND;
   b.articulo = tcArticulo;
INTO CURSOR;
   tm_entrada

WAIT "Consultando [SALIDAS]" WINDOW NOWAIT
SELECT;
   a.tipobole,;
   a.nrobole,;
   a.fecha,;
   b.cantidad;
FROM;
   cabemovi a;
   INNER JOIN detamovi b;
      ON a.tipobole = b.tipobole AND;
         a.nrobole = b.nrobole;
WHERE;
   INLIST(a.tipobole, 2, 4) AND;
   b.articulo = tcArticulo;
INTO CURSOR;
   tm_salida

WAIT "Consultando [COMPRAS]" WINDOW NOWAIT
SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.fechadocu,;
   b.cantidad,;
   b.precio;
FROM;
   cabecomp a;
   INNER JOIN detacomp b;
      ON a.tipodocu = b.tipodocu AND;
         a.nrodocu = b.nrodocu AND;
         a.proveedor = b.proveedor;
WHERE;
   b.articulo = tcArticulo;
INTO CURSOR;
   tm_compra

WAIT "Consultando [NOTAS DE DEB./CRED. DE CLIENTES]" WINDOW NOWAIT
SELECT;
   a.tiponota,;
   a.nronota,;
   a.fechanota,;
   b.cantidad;
FROM;
   cabenotc a;
   INNER JOIN detanotc b;
      ON a.tiponota = b.tiponota AND;
         a.nronota = b.nronota;
WHERE;
   b.tipo = "S" AND;
   b.articulo = tcArticulo;
INTO CURSOR;
   tm_ncreclie

WAIT "Consultando [VENTAS]" WINDOW NOWAIT
SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.fechadocu,;
   b.cantidad;
FROM;
   cabevent a;
   INNER JOIN detavent b;
      ON a.tipodocu = b.tipodocu AND;
         a.nrodocu = b.nrodocu;
WHERE;
   b.articulo = tcArticulo;
INTO CURSOR;
   tm_venta

WAIT "Consultando [NOTAS DE DEB./CRED. DE PROVEEDORES]" WINDOW NOWAIT
SELECT;
   a.tiponota,;
   a.nronota,;
   a.fechanota,;
   b.cantidad;
FROM;
   cabenotp a;
   INNER JOIN detanotp b;
      ON a.tiponota = b.tiponota AND;
         a.nronota = b.nronota AND;
         a.proveedor = b.proveedor;
WHERE;
   b.tipo = "S" AND;
   b.articulo = tcArticulo;
INTO CURSOR;
   tm_ncreprov

WAIT "Consultando [ORDENES DE TRABAJO]" WINDOW NOWAIT
SELECT;
   a.serie,;
   a.nroot,;
   b.fecha,;
   c.cantidad;
FROM;
   ot a;
   INNER JOIN cabemot b;
      ON a.serie = b.serie AND;
         a.nroot = b.nrobole;
   INNER JOIN detamot c;
      ON b.tipobole = c.tipobole AND;
         b.serie = c.serie AND;
         b.nrobole = c.nrobole;
WHERE;
   a.estadoot <> 6 AND;
   c.articulo = tcArticulo;
INTO CURSOR;
   tm_ot

WAIT "Consultando [ENTRADAS]" WINDOW NOWAIT
SELECT;
   a.id_pedido,;
   a.fecha,;
   a.cantidad;
FROM;
   entr_dep a;
WHERE;
   a.articulo = tcArticulo;
INTO CURSOR;
   tm_entr_dep

WAIT "Creando tabla informe." WINDOW NOWAIT
CREATE CURSOR tm_informe (;
   nombre VARCHAR(40),;
   fecha DATE(8),;
   precio NUMERIC(9,2),;
   entrada NUMERIC(9,2),;
   salida NUMERIC(9,2),;
   saldo NUMERIC(9,2),;
   prioridad N(2);
)
INDEX ON DTOS(fecha) + STR(prioridad, 2) TAG indice1

SELECT tm_entrada
SCAN ALL
   m.nombre    = IIF(tipobole = 1, "ENTRADA: ", "AJUSTE ENTRADA: ") + ALLTRIM(STR(tipobole)) + "/" + ALLTRIM(STR(nrobole))
   m.fecha     = fecha
   m.precio    = 0
   m.entrada   = cantidad
   m.salida    = 0
   m.saldo     = 0
   m.prioridad = IIF(tipobole = 1, 4, 5)
   INSERT INTO tm_informe FROM MEMVAR
ENDSCAN

SELECT tm_salida
SCAN ALL
   m.nombre    = IIF(tipobole = 2, "SALIDA: ", "AJUSTE SALIDA: ") + ALLTRIM(STR(tipobole)) + "/" + ALLTRIM(STR(nrobole))
   m.fecha     = fecha
   m.precio    = 0
   m.entrada   = 0
   m.salida    = cantidad
   m.saldo     = 0
   m.prioridad = IIF(tipobole = 3, 9, 10)
   INSERT INTO tm_informe FROM MEMVAR
ENDSCAN

SELECT tm_compra
SCAN ALL
   m.nombre    = "COMPRA: " + ALLTRIM(STR(tipodocu)) + "/" + ALLTRIM(STR(nrodocu))
   m.fecha     = fechadocu
   m.precio    = precio
   m.entrada   = cantidad
   m.salida    = 0
   m.saldo     = 0
   m.prioridad = 1
   INSERT INTO tm_informe FROM MEMVAR
ENDSCAN

SELECT tm_ncreclie
SCAN ALL
   m.nombre    = IIF(tiponota = 1, "NOTA DE DEBITO - CLIENTE: ", "NOTA DE CREDITO - CLIENTE: ") + ALLTRIM(STR(tiponota)) + "/" + ALLTRIM(STR(nronota))
   m.fecha     = fechanota
   m.precio    = 0
   m.entrada   = IIF(tiponota = 2, cantidad, 0)
   m.salida    = IIF(tiponota = 1, cantidad, 0)
   m.saldo     = 0
   m.prioridad = IIF(tiponota = 1, 8, 2)
   INSERT INTO tm_informe FROM MEMVAR
ENDSCAN

SELECT tm_venta
SCAN ALL
   m.nombre    = "VENTA: " + ALLTRIM(STR(tipodocu)) + "/" + ALLTRIM(STR(nrodocu))
   m.fecha     = fechadocu
   m.precio    = 0
   m.entrada   = 0
   m.salida    = cantidad
   m.saldo     = 0
   m.prioridad = 6
   INSERT INTO tm_informe FROM MEMVAR
ENDSCAN

SELECT tm_ncreprov
SCAN ALL
   m.nombre    = IIF(tiponota = 1, "NOTA DE DEBITO - PROVEEDOR: ", "NOTA DE CREDITO - PROVEEDOR: ") + ALLTRIM(STR(tiponota)) + "/" + ALLTRIM(STR(nronota))
   m.fecha     = fechanota
   m.precio    = 0
   m.entrada   = IIF(tiponota = 1, cantidad, 0)
   m.salida    = IIF(tiponota = 2, cantidad, 0)
   m.saldo     = 0
   m.prioridad = IIF(tiponota = 1, 3, 7)
   INSERT INTO tm_informe FROM MEMVAR
ENDSCAN

SELECT tm_ot
SCAN ALL
   m.nombre    = "ORDEN DE TRABAJO: " + serie + "-" + ALLTRIM(STR(nroot))
   m.fecha     = fecha
   m.precio    = 0
   m.entrada   = 0
   m.salida    = cantidad
   m.saldo     = 0
   m.prioridad = 6
   INSERT INTO tm_informe FROM MEMVAR
ENDSCAN

SELECT tm_entr_dep
SCAN ALL
   m.nombre    = "PEDIDO: " + ALLTRIM(STR(id_pedido))
   m.fecha     = fecha
   m.precio    = 0
   m.entrada   = cantidad
   m.salida    = 0
   m.saldo     = 0
   m.prioridad = 4
   INSERT INTO tm_informe FROM MEMVAR
ENDSCAN

m.saldo = 0
SELECT tm_informe
SCAN ALL
   m.saldo = m.saldo + entrada - salida
   REPLACE saldo WITH m.saldo
ENDSCAN

BROWSE