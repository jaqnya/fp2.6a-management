*
* ult_mov.prg
*
* Derechos Reservados (c) 2000 - 2009 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Crea una lista con la informacion de la ultima de fecha de venta y
* compra de los productos
*
* Historial de Modificacion:
* Enero 15, 2009	Jose Avilio Acuna Acosta	Creador del Programa
*

PARAMETERS m.exportar

IF PARAMETERS() < 1 THEN
   WAIT "PROGRAMA: ULT_MOV.PRG" + CHR(13) + "NO SE HAN PASADO SUFICIENTES PARAMETROS." WINDOW
   RETURN
ENDIF

IF TYPE("m.exportar") <> "L" THEN
   WAIT "PROGRAMA: ULT_MOV.PRG" + CHR(13) + "EL PRIMER PARAMETRO DEBE SER DE TIPO LOGICO." WINDOW
   RETURN
ENDIF

IF !USED("maesprod") THEN
   USE maesprod IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("marcas1") THEN
   USE marcas1 IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabevent") THEN
   USE cabevent IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detavent") THEN
   USE detavent IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabecomp") THEN
   USE cabecomp IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detacomp") THEN
   USE detacomp IN 0 AGAIN ORDER 1 SHARED
ENDIF

* configuracion del entorno
SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON
SET SAFETY  OFF
SET TALK    OFF

WAIT "INICIALIZANDO..." WINDOW NOWAIT

* variables locales
PRIVATE m.id_product, m.producto, m.existencia, m.id_marca, m.id_product, m.fecuventa, m.fecucompra

* archivo temporal
CREATE CURSOR tm_informe (;
   id_product C(15),;
   producto C(40),;
   existencia N(11,2),;
   fecuventa D(8),;
   fecucompra D(8),;
   id_marca N(5),;
   marca C(30);
);

* -- procesa el archivo de ventas -----------------------------------------*
WAIT "CONSULTANDO ARCHIVO DE VENTAS..." WINDOW NOWAIT

SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.fechadocu,;
   b.articulo;
FROM;
   cabevent a,;
   detavent b;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu;
ORDER BY;
   b.articulo,;
   a.fechadocu DESC;
INTO CURSOR;
   tm_detaven

SELECT;
   articulo,;
   MAX(fechadocu) AS fecuventa;
FROM;
   tm_detaven;
GROUP BY;
   articulo;
INTO CURSOR;
   tm_ventas

* -- procesa el archivo de compras ----------------------------------------*
WAIT "CONSULTANDO ARCHIVO DE COMPRAS..." WINDOW NOWAIT

SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.fechadocu,;
   b.articulo;
FROM;
   cabecomp a,;
   detacomp b;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.proveedor = b.proveedor;
ORDER BY;
   b.articulo,;
   a.fechadocu DESC;
INTO CURSOR;
   tm_detacom

SELECT;
   articulo,;
   MAX(fechadocu) AS fecucompra;
FROM;
   tm_detacom;
GROUP BY;
   articulo;
INTO CURSOR;
   tm_compras

* -- procesa el archivo de productos --------------------------------------*
WAIT "CREANDO LISTA DE PRODUCTOS..." WINDOW NOWAIT

SELECT maesprod
SET ORDER TO 2
SCAN ALL
   IF stock_actu - stock_ot > 0 THEN
      m.id_product = codigo
      m.producto   = nombre
      m.existencia = stock_actu - stock_ot
      m.id_marca   = marca

      SELECT tm_ventas
      LOCATE FOR articulo = m.id_product
      IF FOUND() THEN
         m.fecuventa = fecuventa
      ELSE
         m.fecuventa = CTOD("  /  /    ")
      ENDIF

      SELECT tm_compras
      LOCATE FOR articulo = m.id_product
      IF FOUND() THEN
         m.fecucompra= fecucompra
      ELSE
         m.fecucompra = CTOD("  /  /    ")
      ENDIF

      SELECT marcas1
      SET ORDER TO 1
      IF SEEK(m.id_marca) THEN
         m.marca = nombre
      ELSE
         m.marca = ""
      ENDIF

      INSERT INTO tm_informe FROM MEMVAR
   ENDIF
ENDSCAN

WAIT CLEAR

IF m.exportar THEN
   IF estado_archivo("c:\excel.xls") = 0 THEN
      SELECT tm_informe
      EXPORT TO c:\excel TYPE XLS
      WAIT "NOMBRE DEL ARCHIVO: EXCEL.XLS, EN C:\" WINDOW
   ELSE
      WAIT "ERROR:" + CHR(13) + "EL ARCHIVO: C:\EXCEL.XLS, ESTA EN USO" + CHR(13) + "NO SE PUEDE EXPORTAR EL INFORME." WINDOW
   ENDIF
ENDIF

IF USED("tm_detaven") THEN
   SELECT tm_detaven
   USE
ENDIF

IF USED("tm_ventas") THEN
   SELECT tm_ventas
   USE
ENDIF

IF USED("tm_detacom") THEN
   SELECT tm_detacom
   USE
ENDIF

IF USED("tm_compras") THEN
   SELECT tm_compras
   USE
ENDIF 

*
* estado_archivo
*
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Verifica si el archivo especificado se encuentra en uso
*
* Valores Devueltos:
* 0 = El archivo no esta en uso
* 1 = El archivo esta en uso
* 2 = Error
*
* Historial de Modificacion:
* Agosto 24, 2008	Jose Avilio Acuna Acosta	Creador del Programa
*

FUNCTION estado_archivo
PARAMETER m.archivo

IF PARAMETERS() < 1 THEN
   WAIT "PROGRAMA: ESTADO_ARCHIVO" + CHR(13) + "NO SE HAN PASADO SUFICIENTES PARAMETROS." WINDOW
   RETURN 2
ENDIF

IF TYPE("m.archivo") <> "C" THEN
   WAIT "PROGRAMA: ESTADO_ARCHIVO" + CHR(13) + "EL PARAMETRO DEBE SER DE TIPO CARACTER." WINDOW
   RETURN 2
ENDIF

IF !FILE(m.archivo) THEN
   RETURN 0
ENDIF

PRIVATE m.estado, m.handle
STORE 0 TO m.estado

m.handle = FOPEN(m.archivo, 12)
=FCLOSE(m.handle)
m.estado = IIF(m.handle <> -1, 0, 1)

RETURN (m.estado)