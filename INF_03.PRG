*
* inf_03.prg
*
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Informe de Liquidacion
*
* Historial de Modificacion:
* Agosto 24, 2008	Jose Avilio Acuna Acosta	Creador del Programa
*

PARAMETERS m.fecha

IF PARAMETERS() < 1 THEN
   WAIT "PROGRAMA: INF_03.PRG" + CHR(13) + "NO SE HAN PASADO SUFICIENTES PARAMETROS." WINDOW
   RETURN
ENDIF

IF TYPE("m.fecha") <> "D" THEN
   WAIT "PROGRAMA: INF_03.PRG" + CHR(13) + "EL PARAMETRO DEBE SER DE TIPO FECHA." WINDOW
   RETURN
ENDIF

IF !USED("clientes") THEN
   USE clientes IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabeven2") THEN
   USE cabeven2 IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("form_cob") THEN
   USE form_cob IN 0 AGAIN ORDER 0 SHARED
ENDIF

WAIT "INICIALIZANDO..." WINDOW NOWAIT

* variables locales
PRIVATE m.cliente, m.documento, m.monto_fact, m.monto_cobr, m.monto_ncre, m.monto_otro

* archivo temporal
CREATE CURSOR tm_informe (;
   documento  C(35),;
   tipodocu   N(1),;
   nrodocu    N(13),;
   fechadocu  D(8),;
   monto      N(11),;
   id_cliente N(5),;
   cliente    C(40);
)

CREATE CURSOR tm_inform2 (;
   descripcio C(30),;
   monto C(14);
)

*-- procesa el archivo de ventas ------------------------------------------*
WAIT "CONSULTANDO ARCHIVO DE VENTAS..." WINDOW NOWAIT

SELECT;
   tipodocu,;
   nrodocu,;
   fechadocu,;
   fechaanu,;
   cliente AS id_cliente;
FROM;
   cabevent;
WHERE;
   (fechadocu = m.fecha  OR;
    fechaanu  = m.fecha) AND;
   INLIST(tipodocu, 7, 8);
ORDER BY;
   2;
INTO CURSOR;
   tm_cabevent

SELECT tm_cabevent
SCAN ALL
   WAIT "PROCESANDO ARCHIVO DE VENTAS: " + ALLTRIM(TRANSFORM(RECNO(), "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT
   DO vta_neta WITH tipodocu, nrodocu

   SELECT clientes
   SET ORDER TO 1
   IF SEEK(tm_cabevent.id_cliente) THEN
      m.cliente = nombre
   ELSE
      m.cliente = "A N U L A D O"
   ENDIF

   INSERT INTO tm_informe VALUES (IIF(tm_cabevent.tipodocu = 7, "FACTURA CONTADO", "FACTURA CREDITO"), tm_cabevent.tipodocu, tm_cabevent.nrodocu, tm_cabevent.fechadocu, (tm_totales.exenta + tm_totales.grav_5 + tm_totales.grav_10 + tm_totales.iva_5 + tm_totales.iva_10), tm_cabevent.id_cliente, m.cliente)

   SELECT cabeven2
   SET ORDER TO 1
   IF SEEK(STR(tm_cabevent.tipodocu, 1) + STR(tm_cabevent.nrodocu, 7)) THEN
      SELECT tm_informe
      REPLACE cliente WITH cabeven2.nombre
   ENDIF
ENDSCAN

* -- procesa el archivo de notas de debitos y creditos de clientes --------*
WAIT "CONSULTANDO ARCHIVO DE NOTAS DE DEBITOS Y CREDITOS..." WINDOW NOWAIT

SELECT;
   a.tiponota,;
   a.nronota,;
   a.fechanota,;
   a.tipodocu,;
   a.nrodocu,;
   a.cliente AS id_cliente,;
   b.nombre AS cliente;
FROM;
   cabenotc a,;
   clientes b;
WHERE;
   a.cliente = b.codigo AND;
   a.fechanota = m.fecha AND;
   a.tiponota = 2 AND;
   a.aplicontra = 1;
ORDER BY;
   1, 2;
INTO CURSOR;
   tm_cabenotc

SELECT tm_cabenotc
SCAN ALL
   WAIT "PROCESANDO ARCHIVO DE NOTAS DE DEBITOS Y CREDITOS: " + ALLTRIM(TRANSFORM(RECNO(), "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT
   DO ncc_neta WITH tiponota, nronota
   INSERT INTO tm_informe VALUES ("NOTA DE CREDITO", tm_cabenotc.tiponota, tm_cabenotc.nronota, tm_cabenotc.fechanota, (tm_totales.exenta + tm_totales.grav_5 + tm_totales.grav_10 + tm_totales.iva_5 + tm_totales.iva_10), tm_cabenotc.id_cliente, tm_cabenotc.cliente)

   SELECT cabeven2
   SET ORDER TO 1
   IF SEEK(STR(tm_cabenotc.tipodocu, 1) + STR(tm_cabenotc.nrodocu, 7)) THEN
      SELECT tm_informe
      REPLACE cliente WITH cabeven2.nombre
   ENDIF
ENDSCAN

* -- procesa el archivo de cobros a clientes ------------------------------*
WAIT "CONSULTANDO ARCHIVO DE COBROS..." WINDOW NOWAIT

SELECT;
   a.tiporeci,;
   a.nroreci,;
   a.fechareci,;
   a.cliente AS id_cliente,;
   b.nombre AS cliente;
FROM;
   cabecob a,;
   clientes b;
WHERE;
   a.cliente = b.codigo AND;
   a.fechareci = m.fecha AND;
   a.tiporeci = 1;
ORDER BY;
   1, 2;
INTO CURSOR;
   tm_cabecob

SELECT tm_cabecob
SCAN ALL
   WAIT "PROCESANDO ARCHIVO DE COBRO: " + ALLTRIM(TRANSFORM(RECNO(), "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT
   DO cob_neto WITH tiporeci, nroreci
   INSERT INTO tm_informe VALUES ("RECIBO DE DINERO", tm_cabecob.tiporeci, tm_cabecob.nroreci, tm_cabecob.fechareci, tm_totales.monto2, tm_cabecob.id_cliente, tm_cabecob.cliente)

   SELECT detacob
   SET ORDER TO 1
   IF SEEK(STR(tm_cabecob.tiporeci, 1) + STR(tm_cabecob.nroreci, 7)) THEN
      SELECT cabevent
      SET ORDER TO 1
      IF SEEK(STR(detacob.tipodocu, 1) + STR(detacob.nrodocu, 7)) THEN
         SELECT cabeven2
         SET ORDER TO 1
         IF SEEK(STR(detacob.tipodocu, 1) + STR(detacob.nrodocu, 7)) THEN
            SELECT tm_informe
            REPLACE cliente WITH cabeven2.nombre
         ENDIF
      ENDIF
   ENDIF
ENDSCAN

* -- procesa el archivo de forma de cobro ---------------------------------*
SELECT tm_cabevent
SCAN ALL
   WAIT "PROCESANDO ARCHIVO DE FORM DE VENTA: " + ALLTRIM(TRANSFORM(RECNO(), "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT

   SELECT form_cob
   LOCATE FOR tipodocu = tm_cabevent.tipodocu AND nrodocu = tm_cabevent.nrodocu
   IF FOUND() THEN
      DO CASE
         CASE forma_id = 2
            m.documento = "CAJA MONEDA EXTRANJERA US$"
         CASE forma_id = 3
            m.documento = "TARJETA DE CREDITO"
         CASE forma_id = 4
            m.documento = "BANCO REGIONAL S.A. CTA. CTE."
         CASE forma_id = 5
            m.documento = "BANCO NACIONAL DE FOMENTO CTA. CTE"
         CASE forma_id = 6
            m.documento = "BANCO REGIONAL S.A. CAJA AHORRO US$"
      ENDCASE

      SELECT clientes
      SET ORDER TO 1
      IF SEEK(tm_cabevent.id_cliente) THEN
         m.cliente = nombre
      ELSE
         m.cliente = ""
      ENDIF

      INSERT INTO tm_informe VALUES (m.documento, tm_cabevent.tipodocu, tm_cabevent.nrodocu, tm_cabevent.fechadocu, ROUND(form_cob.importe * form_cob.cambio, 0), tm_cabevent.id_cliente, m.cliente)
   ENDIF
ENDSCAN

SELECT tm_cabecob
SCAN ALL
   WAIT "PROCESANDO ARCHIVO DE FORM DE VENTA: " + ALLTRIM(TRANSFORM(RECNO(), "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT

   SELECT form_cob
   LOCATE FOR tipodocu = tm_cabecob.tiporeci AND nrodocu = tm_cabecob.nroreci
   IF FOUND() THEN
      DO CASE
         CASE forma_id = 2
            m.documento = "CAJA MONEDA EXTRANJERA US$"
         CASE forma_id = 3
            m.documento = "TARJETA DE CREDITO"
         CASE forma_id = 4
            m.documento = "BANCO REGIONAL S.A. CTA. CTE."
         CASE forma_id = 5
            m.documento = "BANCO NACIONAL DE FOMENTO CTA. CTE"
         CASE forma_id = 6
            m.documento = "BANCO REGIONAL S.A. CAJA AHORRO US$"
      ENDCASE

      SELECT clientes
      SET ORDER TO 1
      IF SEEK(tm_cabecob.id_cliente) THEN
         m.cliente = nombre
      ELSE
         m.cliente = ""
      ENDIF

      INSERT INTO tm_informe VALUES (m.documento, tm_cabecob.tiporeci, tm_cabecob.nroreci, tm_cabecob.fechareci, ROUND(form_cob.importe * form_cob.cambio, 0), tm_cabereci.id_cliente, m.cliente)
   ENDIF
ENDSCAN

WAIT CLEAR

SELECT tm_informe
SUM monto TO m.monto_fact FOR documento = "FACTURA CONTADO"
SUM monto TO m.monto_cobr FOR documento = "RECIBO DE DINERO"
SUM monto TO m.monto_ncre FOR documento = "NOTA DE CREDITO"
SUM monto TO m.monto_otro FOR !INLIST(documento, "FACTURA CONTADO", "FACTURA CREDITO", "NOTA DE CREDITO", "RECIBO DE DINERO")

INSERT INTO tm_inform2 VALUES ("INGRESOS", "")
INSERT INTO tm_inform2 VALUES (REPLICATE("-", 30), REPLICATE("-", 14))
INSERT INTO tm_inform2 VALUES ("   Venta", TRANSFORM(m.monto_fact, "99,999,999,999"))
INSERT INTO tm_inform2 VALUES ("   Cobranza", TRANSFORM(m.monto_cobr, "99,999,999,999"))
INSERT INTO tm_inform2 VALUES ("", "")
INSERT INTO tm_inform2 VALUES ("EGRESOS", "")
INSERT INTO tm_inform2 VALUES (REPLICATE("-", 30), REPLICATE("-", 14))
INSERT INTO tm_inform2 VALUES ("   Nota de Cr‚dito", TRANSFORM(m.monto_ncre, "99,999,999,999"))
INSERT INTO tm_inform2 VALUES ("   Otras Deducciones", TRANSFORM(m.monto_otro, "99,999,999,999"))
INSERT INTO tm_inform2 VALUES ("", "")
INSERT INTO tm_inform2 VALUES (REPLICATE("-", 30), REPLICATE("-", 14))
INSERT INTO tm_inform2 VALUES ("RECAUDACION NETA", TRANSFORM((m.monto_fact + m.monto_cobr) - (m.monto_ncre + m.monto_otro), "99,999,999,999"))