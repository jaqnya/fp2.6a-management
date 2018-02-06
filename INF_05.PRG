*
* inf_05.prg
*
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Informe de articulos vendidos a un cliente
*
* Historial de Modificacion:
* Setiembre 01, 2008       Jose Avilio Acuna Acosta        Creador del Programa
*

PARAMETERS m.id_cliente

IF PARAMETERS() < 1 THEN
   WAIT "PROGRAMA: INF_05.PRG" + CHR(13) + "NO SE HAN PASADO SUFICIENTES PARAMETROS." WINDOW
   RETURN
ENDIF

IF TYPE("m.id_cliente") <> "N" THEN
   WAIT "PROGRAMA: INF_05.PRG" + CHR(13) + "EL PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW
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

WAIT "INICIALIZANDO..." WINDOW NOWAIT

* archivo temporal
CREATE CURSOR tm_detaven (;
   tipodocu   N(1),;
   nrodocu    N(13),;
   fechadocu  D(8),;
   id_product C(15),;
   producto   C(40),;
   cantidad   N(9,2),;
   precio     N(12,2),;
   moneda     C(15);
);

*-- procesa el archivo de ventas ------------------------------------------*
WAIT "CONSULTANDO ARCHIVO DE VENTAS..." WINDOW NOWAIT

SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.fechadocu,;
   b.simbolo AS moneda;
FROM;
   cabevent a,;
   monedas b;
WHERE;
   a.moneda = b.codigo AND;
   cliente = m.id_cliente;
ORDER BY;
   3 DESC, 1, 2;
INTO CURSOR;
   tm_cabevent

SELECT tm_cabevent
SCAN ALL
   WAIT "PROCESANDO ARCHIVO DE VENTAS: " + ALLTRIM(TRANSFORM(RECNO(), "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT

   DO vta_neta WITH tipodocu, nrodocu

   SELECT tm_detalle
   SCAN ALL
      SELECT maesprod
      SET ORDER TO 1
      IF SEEK(tm_detalle.codigo) THEN
         INSERT INTO tm_detaven (tipodocu, nrodocu, fechadocu, id_product, producto, cantidad, precio, moneda);
            VALUES (tm_cabevent.tipodocu, tm_cabevent.nrodocu, tm_cabevent.fechadocu, tm_detalle.codigo, maesprod.nombre, tm_detalle.cantidad, tm_detalle.prec_neto, tm_cabevent.moneda)
      ELSE
         WAIT "LA VENTA: " + ALLTRIM(STR(tm_cabevent.tipodocu)) + "/" + ALLTRIM(STR(tm_cabevent.nrodocu)) + ", NO EXISTE." WINDOW
      ENDIF
   ENDSCAN
ENDSCAN

*--------------------------------------------------------------------------*
WAIT "CREANDO LISTA DE ARTICULOS..." WINDOW NOWAIT

SELECT DISTINCT;
   id_product,;
   producto;
FROM;
   tm_detaven;
ORDER BY;
   2;
INTO CURSOR;
tm_lista

WAIT CLEAR

*--------------------------------------------------------------------------*
SELECT clientes
SET ORDER TO 1
IF SEEK(m.id_cliente) THEN
   m.cliente = ALLTRIM(nombre)
ELSE
   WAIT "EL CLIENTE: " + ALLTRIM(STR(m.id_cliente)) + ", NO EXISTE." WINDOW
ENDIF

DEFINE WINDOW brwl_21;
   FROM 01,00;
   TO   23,79;
   TITLE "< ARTICULOS VENDIDOS A: " + ALLTRIM(clientes.nombre) + " >";
   SYSTEM;
   CLOSE;
   FLOAT;
   GROW;
   MDI;
   NOMINIMIZE;
   SHADOW;
   ZOOM;
   COLOR SCHEME 15

SELECT tm_lista
GOTO TOP

DO helpbar.spr
@ 00,00 SAY " Presione la letra 'D' para ver el detalle" SIZE 1,80 COLOR N/W

ON KEY LABEL "D" DO ver_detalle
      
BROWSE WINDOW brwl_21 FIELDS;
   id_product :R:15:H = "C¢digo",;
   producto :R:40:H = "Nombre";
   NOAPPEND NODELETE NOMODIFY

ON KEY LABEL "D"

RELEASE WINDOW
RELEASE WINDOW brwl_21

*--------------------------------------------------------------------------*
PROCEDURE ver_detalle
PUSH KEY CLEAR

PRIVATE m.condicion, m.producto
STORE "" TO m.condicion, m.producto

m.condicion = "id_product = tm_lista.id_product"
m.producto  = ALLTRIM(tm_lista.producto)

DEFINE WINDOW brwl_21a;
   FROM 01,00;
   TO   23,79;
   TITLE "< " + m.producto + " >";
   SYSTEM;
   CLOSE;
   FLOAT;
   GROW;
   MDI;
   NOMINIMIZE;
   SHADOW;
   ZOOM;
   COLOR SCHEME 15

SELECT tm_detaven
IF !EMPTY(m.condicion) THEN
   @ 00,00 SAY " ESC=Salir" SIZE 1,80 COLOR N/W

   BROWSE WINDOW brwl_21a FIELDS;
      b1 = IIF(tipodocu = 7, "FACTURA CONTADO", IIF(tipodocu = 8, "FACTURA CREDITO", "TIPO: " + ALLTRIM(STR(tipodocu)))) :R:15:H = "Documento",;
      nrodocu :R:07:H = " N£mero" :P = "9999999",;
      fechadocu :R:10:H = "  Fecha" :P = "@D",;
      cantidad :R:11:H = "Cantidad" :P = "99999999.99",;
      precio :R:14:H = "Precio Unit." :P = "999,999,999.99",;
      moneda :R:14:H = "Moneda";
      NOAPPEND NODELETE NOMODIFY FOR &condicion

   @ 00,00 SAY " Presione la letra 'D' para ver el detalle" SIZE 1,80 COLOR N/W
ENDIF

RELEASE WINDOW brwl_21a
POP KEY
