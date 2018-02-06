*
* lib_ncc.prg
*
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Libro de Notas de Creditos de Clientes
*
* Historial de Modificacion:
* Agosto 24, 2008	Jose Avilio Acuna Acosta	Creador del Programa
*

PARAMETERS m.mes, m.anyo

IF PARAMETERS() < 2 THEN
   WAIT "PROGRAMA: LIB_NCC.PRG" + CHR(13) + "NO SE HAN PASADO SUFICIENTES PARAMETROS." WINDOW
   RETURN
ENDIF

IF TYPE("m.mes") <> "N" THEN
   WAIT "PROGRAMA: LIB_NCC.PRG" + CHR(13) + "EL PRIMER PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW
   RETURN
ENDIF

IF TYPE("m.anyo") <> "N" THEN
   WAIT "PROGRAMA: LIB_NCC.PRG" + CHR(13) + "EL SEGUNDO PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW
   RETURN
ENDIF

IF !USED("clientes") THEN
   USE clientes IN 0 AGAIN ORDER 1 SHARED
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

IF !USED("cabenotc") THEN
   USE cabenotc IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detanotc") THEN
   USE detanotc IN 0 AGAIN ORDER 1 SHARED
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
   credito C(1);
)
   
* -- procesa el archivo de notas de debitos y creditos de clientes --------*
WAIT "CONSULTANDO ARCHIVO DE NOTAS DE DEBITOS Y CREDITOS..." WINDOW NOWAIT

SELECT;
   tiponota,;
   nronota,;
   fechanota,;
   fechaanu;
FROM;
   cabenotc;
WHERE;
   (MONTH(fechanota) = m.mes AND;
   YEAR(fechanota) = m.anyo) OR;
   (MONTH(fechaanu) = m.mes AND;
   YEAR(fechaanu) = m.anyo);
ORDER BY;
   2;
INTO CURSOR;
   tm_cabenotc

SELECT tm_cabenotc
SCAN ALL
   WAIT "PROCESANDO ARCHIVO DE NOTAS DE DEBITOS Y CREDITOS: " + ALLTRIM(TRANSFORM(RECNO(), "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT

   STORE 0 TO m.gravada, m.iva_10, m.iva_5, m.exenta, m.total, m.maquina, m.mostrador, m.taller, m.serv_propi, m.serv_terce
   STORE CTOD("  /  /    ") TO m.fecha
   STORE "" TO m.numero, m.cliente, m.ruc, m.credito

   DO CASE
      CASE BETWEEN(tm_cabenotc.nronota, 1000000, 1999999)
         m.numero = "001-001-0" + TRANSFORM(tm_cabenotc.nronota - 1000000, "@L 999999")
      CASE BETWEEN(tm_cabenotc.nronota, 2000000, 2999999)
         m.numero = "001-002-0" + TRANSFORM(tm_cabenotc.nronota - 2000000, "@L 999999")
      CASE BETWEEN(tm_cabenotc.nronota, 3000000, 3999999)
         m.numero = "003-001-0" + TRANSFORM(tm_cabenotc.nronota - 3000000, "@L 999999")
      OTHERWISE
         m.numero = STR(tm_cabevent.nrodocu, 15)
   ENDCASE

*!*	   IF BETWEEN(tm_cabenotc.nronota, 1000000, 1999999) THEN
*!*	      m.numero = "001-001-0" + TRANSFORM(tm_cabenotc.nronota - 1000000, "@L 999999")
*!*	   ELSE
*!*	      m.numero = STR(tm_cabenotc.nronota, 15)
*!*	   ENDIF

   IF EMPTY(tm_cabenotc.fechaanu) THEN
      m.fecha = tm_cabenotc.fechanota

      SELECT cabenotc
      SET ORDER TO 1
      IF SEEK(STR(tm_cabenotc.tiponota, 1) + STR(tm_cabenotc.nronota, 7)) THEN
         IF aplicontra = 2 THEN
            m.credito = "*"
         ENDIF

         SELECT cabevent
         SET ORDER TO 1
         IF SEEK(STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7)) THEN
            SELECT clientes
            SET ORDER TO 1
            IF SEEK(cabevent.cliente) THEN
               m.cliente = nombre
               m.ruc = ruc

               SELECT cabeven2
               SET ORDER TO 1
               IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)) THEN
                  m.cliente = nombre
                  m.ruc = documento
               ENDIF
            ELSE
               WAIT "EL CLIENTE: " + ALLTRIM(STR(cabevent.cliente)) + ", NO EXISTE." WINDOW
            ENDIF
         ELSE
            IF EMPTY(cabenotc.fechaanu) THEN
               WAIT "LA VENTA: " + ALLTRIM(STR(cabenotc.tipodocu)) + "/" + ALLTRIM(STR(cabenotc.nrodocu)) + ", NO EXISTE." WINDOW
            ENDIF
         ENDIF
      ELSE
         WAIT "LA NOTA: " + ALLTRIM(STR(tm_cabenotc.tiponota)) + "/" + ALLTRIM(STR(tm_cabenotc.nronota)) + ", NO EXISTE." WINDOW
      ENDIF
   ELSE
      IF !EMPTY(tm_cabenotc.fechaanu) THEN
         m.fecha = tm_cabenotc.fechaanu
         m.cliente = "A N U L A D O"
      ENDIF
   ENDIF

   IF EMPTY(tm_cabenotc.fechaanu) THEN
      DO ncc_neta WITH tm_cabenotc.tiponota, tm_cabenotc.nronota

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

   INSERT INTO tm_informe (numero, fecha, cliente, ruc, gravada, iva_10, iva_5, exenta, total, maquina, mostrador, taller, serv_propi, serv_terce, credito);
      VALUES (m.numero, m.fecha, m.cliente, m.ruc, m.gravada, m.iva_10, m.iva_5, m.exenta, m.total, m.maquina, m.mostrador, m.taller, m.serv_propi, m.serv_terce, m.credito)
ENDSCAN

WAIT CLEAR

IF estado_archivo("c:\excel.xls") = 0 THEN
   SELECT tm_informe
   EXPORT TO c:\excel TYPE XL5
   WAIT "NOMBRE DEL ARCHIVO: EXCEL.XLS, EN C:\" WINDOW
ELSE
   WAIT "ERROR:" + CHR(13) + "EL ARCHIVO: C:\EXCEL.XLS, ESTA EN USO" + CHR(13) + "NO SE PUEDE EXPORTAR EL INFORME." WINDOW
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