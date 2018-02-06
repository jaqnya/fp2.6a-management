*
* inf_06.prg
*
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Informe de pedidos pendientes de facturacion
*
* Historial de Modificacion:
* Setiembre 01, 2008       Jose Avilio Acuna Acosta        Creador del Programa
*

PARAMETERS m.criterio

IF PARAMETERS() < 1 THEN
   WAIT "PROGRAMA: INF_06.PRG" + CHR(13) + "NO SE HAN PASADO SUFICIENTES PARAMETROS." WINDOW
   RETURN
ENDIF

IF TYPE("m.criterio") <> "C" THEN
   WAIT "PROGRAMA: INF_06.PRG" + CHR(13) + "EL PARAMETRO DEBE SER DE TIPO CARACTER." WINDOW
   RETURN
ENDIF

IF !USED("clientes") THEN
   USE clientes IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("maesprod") THEN
   USE maesprod IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("monedas") THEN
   USE monedas IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabevent") THEN
   USE cabevent IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detavent") THEN
   USE detavent IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabepedc") THEN
   USE cabepedc IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detapedc") THEN
   USE detapedc IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabeped2") THEN
   USE cabeped2 IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("artdep") THEN
   USE SYS(5) + "\turtle\aya\integrad.001\maesprod" IN 0 AGAIN ALIAS "ArtDep" ORDER 1 SHARED
ENDIF

IF !USED("artall") THEN
   USE SYS(5) + "\turtle\allparts\integrad.000\maesprod" IN 0 AGAIN ALIAS "ArtAll" ORDER 1 SHARED
ENDIF

WAIT "INICIALIZANDO..." WINDOW NOWAIT

* archivo temporal
CREATE CURSOR tm_detalle (;
   nropedido N(10),;
   articulo  C(15),;
   producto  C(40),;
   cantidad  N(9,2),;
   precio    N(12,2), ;
   stock_cen N(9,2), ;
   stock_dep N(9,2), ;
   stock_all N(9,2) ;
);

*-- procesa el archivo de ventas ------------------------------------------*
WAIT "CONSULTANDO ARCHIVO DE PEDIDO DE CLIENTES..." WINDOW NOWAIT

IF m.criterio = "H" THEN   && Hoy
   SELECT ;
      a.nropedido, ;
      a.fecha, ;
      a.hora, ;
      a.total, ;
      "Gs." AS moneda, ;
      b.nombre AS cliente, ;
      a.cliente AS cod_cli, ;
      c.nombre AS vendedor, ;
      a.vendedor AS cod_vend ;
   FROM ;
      cabepedc a, ;
      clientes b, ;
      vendedor c ;
   WHERE ;
      a.cliente = b.codigo AND ;
      a.vendedor = c.codigo AND ;
      !a.facturado AND ;
      a.fecha = DATE() ;
   ORDER BY ;
      2 DESC ;
   INTO CURSOR ;
      tm_cabepedc
ENDIF

IF m.criterio = "M" THEN   && Mes
   SELECT ;
      a.nropedido, ;
      a.fecha, ;
      a.hora, ;
      a.total, ;
      "Gs." AS moneda, ;
      b.nombre AS cliente, ;
      a.cliente AS cod_cli, ;
      c.nombre AS vendedor, ;
      a.vendedor AS cod_vend ;
   FROM ;
      cabepedc a, ;
      clientes b, ;
      vendedor c ;
   WHERE ;
      a.cliente = b.codigo AND ;
      a.vendedor = c.codigo AND ;
      !a.facturado AND ;
      a.fecha >= DATE() - 30 ;
   ORDER BY ;
      2 DESC ;
   INTO CURSOR ;
      tm_cabepedc
ENDIF

IF m.criterio = "T" THEN   && Todos
   SELECT ;
      a.nropedido, ;
      a.fecha, ;
      a.hora, ;
      a.total, ;
      "Gs." AS moneda, ;
      b.nombre AS cliente, ;
      a.cliente AS cod_cli, ;
      c.nombre AS vendedor, ;
      a.vendedor AS cod_vend ;
   FROM ;
      cabepedc a, ;
      clientes b, ;
      vendedor c ;
   WHERE ;
      a.cliente = b.codigo AND ;
      a.vendedor = c.codigo AND ;
      !a.facturado ;
   ORDER BY ;
      2 DESC ;
   INTO CURSOR ;
      tm_cabepedc
ENDIF

SELECT tm_cabepedc
SCAN ALL
   WAIT "PROCESANDO ARCHIVO DE VENTAS: " + ALLTRIM(TRANSFORM(RECNO(), "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT

   SELECT detapedc
   SET ORDER TO 1
   IF SEEK(tm_cabepedc.nropedido) THEN
      SCAN WHILE nropedido = tm_cabepedc.nropedido
         m.stock_dep = 0
         m.stock_all = 0

         SELECT ArtDep
         SET ORDER TO 1
         IF SEEK(detapedc.articulo) THEN
            m.stock_dep = stock_actu - stock_ot
         ENDIF

         SELECT ArtAll
         SET ORDER TO 1
         IF SEEK(detapedc.articulo) THEN
            m.stock_all = stock_actu - stock_ot
         ENDIF

         SELECT maesprod
         SET ORDER TO 1
         IF SEEK(detapedc.articulo) THEN
            INSERT INTO tm_detalle VALUES (tm_cabepedc.nropedido, detapedc.articulo, maesprod.nombre, detapedc.cantidad, detapedc.precio, maesprod.stock_actu - maesprod.stock_ot, m.stock_dep, m.stock_all)
         ELSE
            WAIT "EL PEDIDO DE CLIENTE: " + ALLTRIM(STR(tm_cabepedc.nropedido)) + ", NO EXISTE." WINDOW
         ENDIF
      ENDSCAN
   ENDIF
ENDSCAN

WAIT CLEAR

*--------------------------------------------------------------------------*
DEFINE WINDOW brwl_21;
   FROM 01,00;
   TO   23,79;
   TITLE "< PEDIDOS PENDIENTES DE FACTURACION " + CHR(174) + IIF(m.criterio = "H", "HOY", IIF(m.criterio = "M", "MES", IIF(m.criterio = "T", "TODOS", "ERROR"))) + CHR(175) + " >";
   SYSTEM;
   CLOSE;
   FLOAT;
   GROW;
   MDI;
   NOMINIMIZE;
   SHADOW;
   ZOOM;
   COLOR SCHEME 15

DO helpbar.spr
@ 00,00 SAY " Presione la letra 'D' para ver el detalle" SIZE 1,80 COLOR N/W

ON KEY LABEL "D" DO ver_detalle
      
SELECT tm_cabepedc
GOTO TOP

BROWSE WINDOW brwl_21 FIELDS;
   nropedido :R:10:P = "9999999999" :H = "Pedido N§",;
   fecha :R:10:P = "@D" :H = "  Fecha",;
   hora :R:8:P = "99:99:99" :H = "  Hora",;
   total :R:11:P = "999,999,999" :H = "  Importe",;
   cliente  :R:32:P = "@!" :H = "Cliente",;
   cod_cli  :R:7:P = "9999999" :H = "C¢d.Cli",;
   vendedor :R:32:P = "@!" :H = "Vendedor",;
   cod_vend  :R:7:P = "9999999" :H = "C¢d.Ven" ;
   NOAPPEND NODELETE NOMODIFY

ON KEY LABEL "D"

RELEASE WINDOW
RELEASE WINDOW brwl_21

*--------------------------------------------------------------------------*
PROCEDURE ver_detalle
PUSH KEY CLEAR

PRIVATE m.condicion, m.producto
STORE "" TO m.condicion, m.producto

m.condicion = "nropedido = tm_cabepedc.nropedido"
m.producto  = ALLTRIM(STR(tm_cabepedc.nropedido)) + " " + CHR(179) + " " + ALLTRIM(LEFT(tm_cabepedc.cliente, 30))

DEFINE WINDOW brwl_21a;
   FROM 01,00;
   TO   23,79;
   TITLE "< DETALLE DEL PEDIDO N§ " + m.producto + " >";
   SYSTEM;
   CLOSE;
   FLOAT;
   GROW;
   MDI;
   NOMINIMIZE;
   SHADOW;
   ZOOM;
   COLOR SCHEME 15

SELECT tm_detalle
IF !EMPTY(m.condicion) THEN
   @ 00,00 SAY " ESC=Salir" SIZE 1,80 COLOR N/W

   BROWSE WINDOW brwl_21a FIELDS;
      articulo :R:10:H = "C¢digo", ;
      producto :R:20:H = "Producto", ;
      cantidad :R:11:H = "Cantidad" :P = "99999999.99",;
      precio :R:14:H = "Precio Unit." :P = "999,999,999.99", ;
      b1 = EstadoStock(cantidad, stock_cen + stock_dep, stock_all) :R:30:H = "Estado Stock" ;
      NOAPPEND NODELETE NOMODIFY FOR &condicion

   @ 00,00 SAY " Presione la letra 'D' para ver el detalle" SIZE 1,80 COLOR N/W
ENDIF

RELEASE WINDOW brwl_21a
POP KEY


FUNCTION EstadoStock
   PARAMETERS m.cantidad, m.stock_aya, stock_all

   m.retorno = ''

   IF m.stock_all >= m.cantidad THEN
      m.retorno = 'Traer de All Parts S.R.L.'
   ELSE
      IF m.stock_aya < m.cantidad THEN
         IF m.stock_aya + m.stock_all >= m.cantidad THEN
            m.retorno = 'Traer ' + ALLTRIM(STR(m.cantidad - m.stock_aya)) + ' und. de All Parts S.R.L.'
         ELSE
            m.retorno = ALLTRIM(STR(m.stock_aya - m.cantidad))
         ENDIF
      ENDIF
   ENDIF

   RETURN m.retorno
 *ENDFUNC