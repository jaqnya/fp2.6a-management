*
* lib_ven.prg
*
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Libro de Ventas
*
* Historial de Modificacion:
* Agosto 24, 2008	Jose Avilio Acuna Acosta	Creador del Programa
*

PARAMETERS m.mes, m.anyo

IF PARAMETERS() < 2 THEN
   WAIT "PROGRAMA: LIB_VEN.PRG" + CHR(13) + "NO SE HAN PASADO SUFICIENTES PARAMETROS." WINDOW
   RETURN
ENDIF

IF TYPE("m.mes") <> "N" THEN
   WAIT "PROGRAMA: LIB_VEN.PRG" + CHR(13) + "EL PRIMER PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW
   RETURN
ENDIF

IF TYPE("m.anyo") <> "N" THEN
   WAIT "PROGRAMA: LIB_VEN.PRG" + CHR(13) + "EL SEGUNDO PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW
   RETURN
ENDIF

IF !USED("clientes") THEN
   USE clientes IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("monedas") THEN
   USE monedas IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("maesprod") THEN
   USE maesprod IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabevent") THEN
   USE cabevent IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabeven2") THEN
   USE cabeven2 IN 0 AGAIN ORDER 1 SHARED
ENDIF

SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON
SET SAFETY  OFF
SET TALK    OFF

WAIT "INICIALIZANDO..." WINDOW NOWAIT

* variables locales
PRIVATE m.numero, m.fecha, m.cliente, m.ruc, m.gravada, m.iva_10, m.iva_5, m.exenta, m.total, m.maquina, m.mostrador, m.taller, m.serv_propi, m.serv_terce, m.credito

* archivo temporal
CREATE CURSOR tm_informe (;
   numero C(15),;
   fecha D(08),;
   cliente C(50),;
   ruc C(15),;
   gravada N(11),;
   iva_10 N(11),;
   iva_5 N(11),;
   exenta N(11),;
   total N(11),;
   maquina N(11),;
   mostrador N(11),;
   taller N(11),;
   serv_propi N(11),;
   serv_terce N(11),;
   divisa C(10),;
   monto_fact N(12,2),;
   cambio N(9,2),;
   credito C(1);
)
   
SELECT cabevent
REPLACE tipodocu WITH 7 FOR nrodocu > 1999999 AND tipodocu = 8 AND anulado
REPLACE tipocambio WITH 1 FOR moneda = 1 AND tipocambio = 0 AND !anulado

* -- procesa el archivo de notas de debitos y creditos de clientes --------*
WAIT "CONSULTANDO ARCHIVO DE VENTAS..." WINDOW NOWAIT

SELECT;
   tipodocu,;
   nrodocu,;
   fechadocu,;
   fechaanu;
FROM;
   cabevent;
WHERE;
   (YEAR(fechadocu) = m.anyo OR YEAR(fechaanu) = m.anyo) AND;
   INLIST(tipodocu, 7, 8);
ORDER BY;
   1, 2;
INTO CURSOR;
   tm_cabevent

SELECT tm_cabevent
SCAN ALL
   WAIT "PROCESANDO ARCHIVO DE VENTAS: " + ALLTRIM(TRANSFORM(RECNO(), "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT

   STORE 0 TO m.gravada, m.iva_10, m.iva_5, m.exenta, m.total, m.maquina, m.mostrador, m.taller, m.serv_propi, m.serv_terce, m.monto_fact, m.cambio
   STORE CTOD("  /  /    ") TO m.fecha
   STORE "" TO m.numero, m.cliente, m.ruc, m.divisa, m.credito

   DO CASE
      CASE BETWEEN(tm_cabevent.nrodocu, 1000000, 1999999)
         m.numero = "001-001-0" + TRANSFORM(tm_cabevent.nrodocu - 1000000, "@L 999999")
      CASE BETWEEN(tm_cabevent.nrodocu, 2000000, 2999999)
         m.numero = "001-002-0" + TRANSFORM(tm_cabevent.nrodocu - 2000000, "@L 999999")
      CASE BETWEEN(tm_cabevent.nrodocu, 3000000, 3999999)
         m.numero = "003-001-0" + TRANSFORM(tm_cabevent.nrodocu - 3000000, "@L 999999")
      OTHERWISE
         m.numero = STR(tm_cabevent.nrodocu, 15)
   ENDCASE

*!*	   IF BETWEEN(tm_cabevent.nrodocu, 2000000, 2999999) THEN
*!*	      m.numero = "001-002-0" + TRANSFORM(tm_cabevent.nrodocu - 2000000, "@L 999999")
*!*	   ELSE
*!*	      m.numero = STR(tm_cabevent.nrodocu, 15)
*!*	   ENDIF

   IF EMPTY(tm_cabevent.fechaanu) THEN
      m.fecha = tm_cabevent.fechadocu

      SELECT cabevent
      SET ORDER TO 1
      IF SEEK(STR(tm_cabevent.tipodocu, 1) + STR(tm_cabevent.nrodocu, 7)) THEN
         m.monto_fact = cabevent.monto_fact
         m.cambio = cabevent.tipocambio

         IF tipodocu = 8 THEN
            m.credito = "*"
         ENDIF

         SELECT monedas
         SET ORDER TO 1
         IF SEEK(cabevent.moneda) THEN
            m.divisa = monedas.simbolo
         ELSE
            WAIT "LA MONEDA: " + ALLTRIM(STR(cabevent.moneda)) + ", NO EXISTE." WINDOW
         ENDIF

         SELECT clientes
         SET ORDER TO 1
         IF SEEK(cabevent.cliente) THEN
            SELECT cabeven2
            SET ORDER TO 1
            IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)) THEN
               m.cliente = nombre
               m.ruc = documento
            ENDIF

            m.cliente = IIF(EMPTY(m.cliente), clientes.nombre, m.cliente)
            m.cliente = STRTRAN(m.cliente, "¥", "Ñ")
            m.ruc = IIF(EMPTY(m.ruc), clientes.ruc, m.ruc)
         ELSE
            WAIT "EL CLIENTE: " + ALLTRIM(STR(cabevent.cliente)) + ", NO EXISTE." WINDOW
         ENDIF
      ELSE
         IF EMPTY(tm_cabevent.fechaanu) THEN
            WAIT "LA VENTA: " + ALLTRIM(STR(tm_cabevent.tipodocu)) + "/" + ALLTRIM(STR(tm_cabevent.nrodocu)) + ", NO EXISTE." WINDOW
         ENDIF
      ENDIF
   ELSE
      IF !EMPTY(tm_cabevent.fechaanu) THEN
         m.fecha = tm_cabevent.fechaanu
         m.cliente = "A N U L A D O"
      ENDIF
   ENDIF

   IF EMPTY(tm_cabevent.fechaanu) THEN
      DO vta_neta WITH tm_cabevent.tipodocu, tm_cabevent.nrodocu

      m.gravada = tm_totales.grav_5 + tm_totales.grav_10
      m.iva_10  = tm_totales.iva_10
      m.iva_5   = tm_totales.iva_5
      m.exenta  = tm_totales.exenta
      m.total   = tm_totales.exenta + tm_totales.grav_5 + tm_totales.grav_10 + tm_totales.iva_5 + tm_totales.iva_10

      SELECT tm_detalle
      SCAN ALL
         SELECT maesprod
         SET ORDER TO 1
         IF !SEEK(tm_detalle.codigo) THEN
            WAIT "EL ARTICULO: " + ALLTRIM(tm_detalle.codigo) + ", NO EXISTE." WINDOW
         ENDIF

         DO CASE
            CASE INLIST(tm_detalle.codigo, "99010", "99011", "99012", "99013", "99014", "99020", "99021", "99022")
               m.serv_propi = m.serv_propi + (tm_detalle.exenta + tm_detalle.grav_5 + tm_detalle.grav_10)
            CASE INLIST(tm_detalle.codigo, "10001", "99001", "99002", "99003")
               m.serv_terce = m.serv_terce + (tm_detalle.exenta + tm_detalle.grav_5 + tm_detalle.grav_10)
            OTHERWISE
               IF maesprod.rubro <> 2 THEN
                  m.mostrador = m.mostrador + (tm_detalle.exenta + tm_detalle.grav_5 + tm_detalle.grav_10)
               ELSE
                  m.maquina = m.maquina + (tm_detalle.exenta + tm_detalle.grav_5 + tm_detalle.grav_10)
               ENDIF
         ENDCASE
      ENDSCAN

      IF !EMPTY(cabevent.serie) AND !EMPTY(cabevent.nroot) THEN
         m.taller = m.mostrador
         m.mostrador = 0
      ENDIF
   ENDIF

   INSERT INTO tm_informe (numero, fecha, cliente, ruc, gravada, iva_10, iva_5, exenta, total, maquina, mostrador, taller, serv_propi, serv_terce, divisa, monto_fact, cambio, credito);
      VALUES (m.numero, m.fecha, m.cliente, m.ruc, m.gravada, m.iva_10, m.iva_5, m.exenta, m.total, m.maquina, m.mostrador, m.taller, m.serv_propi, m.serv_terce, m.divisa, m.monto_fact, m.cambio, m.credito)
ENDSCAN

WAIT CLEAR

IF estado_archivo("c:\excel.xls") = 0 THEN
   SELECT tm_informe
   EXPORT TO c:\excel TYPE XL5
   WAIT "NOMBRE DEL ARCHIVO: EXCEL.XLS, EN C:\" WINDOW
ELSE
   WAIT "ERROR:" + CHR(13) + "EL ARCHIVO: C:\EXCEL.XLS, ESTA EN USO" + CHR(13) + "NO SE PUEDE EXPORTAR EL INFORME." WINDOW
ENDIF

*-- crea resumen de ventas por dia ----------------------------------------*
*!*	SELECT;
*!*	   MIN(numero) AS desde,;
*!*	   MAX(numero) AS hasta,;
*!*	   fecha,;
*!*	   SUM(gravada) AS gravada,;
*!*	   SUM(iva_10) AS iva_10,;
*!*	   SUM(iva_5) AS iva_5,;
*!*	   SUM(exenta) AS exenta,;
*!*	   SUM(total) AS total,;
*!*	   SUM(maquina) AS maquina,;
*!*	   SUM(mostrador) AS mostrador,;
*!*	   SUM(taller) AS taller,;
*!*	   SUM(serv_propi) AS serv_propi,;
*!*	   SUM(serv_terce) AS serv_terce;
*!*	FROM;
*!*	   tm_informe;
*!*	WHERE;
*!*	   EMPTY(credito);
*!*	GROUP BY;
*!*	   fecha;
*!*	INTO CURSOR;
*!*	   tm_resumen

SELECT;
   MIN(numero) AS desde,;
   MAX(numero) AS hasta,;
   fecha,;
   "CASA CENTRAL " AS sucursal,;
   SUM(gravada) AS gravada,;
   SUM(iva_10) AS iva_10,;
   SUM(iva_5) AS iva_5,;
   SUM(exenta) AS exenta,;
   SUM(total) AS total,;
   SUM(maquina) AS maquina,;
   SUM(mostrador) AS mostrador,;
   SUM(taller) AS taller,;
   SUM(serv_propi) AS serv_propi,;
   SUM(serv_terce) AS serv_terce;
FROM;
   tm_informe;
WHERE;
   EMPTY(credito) AND;
   LEFT(numero, 7) = "001-001";
GROUP BY;
   fecha;
UNION ALL;
SELECT;
   MIN(numero) AS desde,;
   MAX(numero) AS hasta,;
   fecha,;
   "CASA CENTRAL " AS sucursal,;
   SUM(gravada) AS gravada,;
   SUM(iva_10) AS iva_10,;
   SUM(iva_5) AS iva_5,;
   SUM(exenta) AS exenta,;
   SUM(total) AS total,;
   SUM(maquina) AS maquina,;
   SUM(mostrador) AS mostrador,;
   SUM(taller) AS taller,;
   SUM(serv_propi) AS serv_propi,;
   SUM(serv_terce) AS serv_terce;
FROM;
   tm_informe;
WHERE;
   EMPTY(credito) AND;
   LEFT(numero, 7) = "001-002";
GROUP BY;
   fecha;
UNION ALL;
SELECT;
   MIN(numero) AS desde,;
   MAX(numero) AS hasta,;
   fecha,;
   "SUCURSAL Nº 1" AS sucursal,;
   SUM(gravada) AS gravada,;
   SUM(iva_10) AS iva_10,;
   SUM(iva_5) AS iva_5,;
   SUM(exenta) AS exenta,;
   SUM(total) AS total,;
   SUM(maquina) AS maquina,;
   SUM(mostrador) AS mostrador,;
   SUM(taller) AS taller,;
   SUM(serv_propi) AS serv_propi,;
   SUM(serv_terce) AS serv_terce;
FROM;
   tm_informe;
WHERE;
   EMPTY(credito) AND;
   LEFT(numero, 7) = "003-001";
GROUP BY;
   fecha;
ORDER BY;
   fecha;
INTO CURSOR;
   tm_resumen

IF estado_archivo("c:\excel2.xls") = 0 THEN
   SELECT tm_resumen
   EXPORT TO c:\excel2 TYPE XL5
   WAIT "NOMBRE DEL ARCHIVO: EXCEL2.XLS, EN C:\" WINDOW
ELSE
   WAIT "ERROR:" + CHR(13) + "EL ARCHIVO: C:\EXCEL2.XLS, ESTA EN USO" + CHR(13) + "NO SE PUEDE EXPORTAR EL INFORME." WINDOW
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