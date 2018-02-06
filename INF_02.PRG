*
* inf_02.prg
*
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Cuadro Anual de Ventas por Vendedor
*
* Historial de Modificacion:
* Agosto 24, 2008	Jose Avilio Acuna Acosta	Creador del Programa
*

PARAMETERS m.anyo, m.opcion

IF PARAMETERS() < 2 THEN
   WAIT "PROGRAMA: INF_02.PRG" + CHR(13) + "NO SE HAN PASADO SUFICIENTES PARAMETROS." WINDOW
   RETURN
ENDIF

IF TYPE("m.anyo") <> "N" THEN
   WAIT "PROGRAMA: INF_02.PRG" + CHR(13) + "EL PRIMER PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW
   RETURN
ENDIF

IF TYPE("m.opcion") <> "C" THEN
   WAIT "PROGRAMA: INF_02.PRG" + CHR(13) + "EL SEGUNDO PARAMETRO DEBE SER DE TIPO CARACTER." WINDOW
   RETURN
ENDIF

IF !INLIST(m.opcion, "S", "N") THEN
   WAIT "PROGRAMA: INF_02.PRG" + CHR(13) + [EL VALOR DEL SEGUNDO PARAMETRO DEBE SER: "S" O "N".] WINDOW
   RETURN
ENDIF

WAIT "INICIALIZANDO..." WINDOW NOWAIT

* variables locales
PRIVATE m.mes, m.suma

* archivo temporal
CREATE CURSOR tm_informe (;
   id_vendedo N(5),;
   vendedor C(30),;
   m_1  N(11),;
   m_2  N(11),;
   m_3  N(11),;
   m_4  N(11),;
   m_5  N(11),;
   m_6  N(11),;
   m_7  N(11),;
   m_8  N(11),;
   m_9  N(11),;
   m_10 N(11),;
   m_11 N(11),;
   m_12 N(11),;
   total_anyo N(11),;
   porcentaje N(6,2);
)

INDEX ON porcentaje TAG porcentaje DESCENDING

*-- procesa el archivo de ventas ------------------------------------------*
WAIT "CONSULTANDO ARCHIVO DE VENTAS..." WINDOW NOWAIT

SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.fechadocu,;
   a.vendedor AS id_vendedo,;
   b.nombre AS vendedor;
FROM;
   cabevent a,;
   vendedor b;
WHERE;
   a.vendedor = b.codigo AND;
   YEAR(a.fechadocu) = m.anyo;
ORDER BY;
   4, 3;
INTO CURSOR;
   tm_cabevent

SELECT tm_cabevent
SCAN ALL
   WAIT "PROCESANDO ARCHIVO DE VENTAS: " + ALLTRIM(TRANSFORM(RECNO(), "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT

   DO vta_neta WITH tipodocu, nrodocu

   m.mes = "m_" + ALLTRIM(STR(MONTH(tm_cabevent.fechadocu)))

   SELECT tm_informe
   LOCATE FOR id_vendedo = tm_cabevent.id_vendedo
   IF !FOUND() THEN
      INSERT INTO tm_informe (id_vendedo, vendedor) VALUES (tm_cabevent.id_vendedo, tm_cabevent.vendedor)
   ENDIF

   IF m.opcion = "S" THEN
      REPLACE (m.mes) WITH &mes + (tm_totales.exenta + tm_totales.grav_5 + tm_totales.grav_10 + tm_totales.iva_5 + tm_totales.iva_10)
   ELSE
      REPLACE (m.mes) WITH &mes + (tm_totales.exenta + tm_totales.grav_5 + tm_totales.grav_10)
   ENDIF
ENDSCAN

* -- procesa el archivo de notas de debitos y creditos de clientes --------*
WAIT "CONSULTANDO ARCHIVO DE NOTAS DE DEBITOS Y CREDITOS..." WINDOW NOWAIT

SELECT;
   a.tiponota,;
   a.nronota,;
   a.fechanota,;
   b.vendedor AS id_vendedo,;
   c.nombre AS vendedor;
FROM;
   cabenotc a,;
   cabevent b,;
   vendedor c;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu  = b.nrodocu  AND;
   b.vendedor = c.codigo   AND;
   YEAR(a.fechanota) = m.anyo;
ORDER BY;
   4, 3;
INTO CURSOR;
   tm_cabenotc

SELECT tm_cabenotc
SCAN ALL
   WAIT "PROCESANDO ARCHIVO DE NOTAS DE DEBITOS Y CREDITOS: " + ALLTRIM(TRANSFORM(RECNO(), "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT

   DO ncc_neta WITH tiponota, nronota

   m.mes = "m_" + ALLTRIM(STR(MONTH(tm_cabenotc.fechanota)))

   SELECT tm_informe
   LOCATE FOR id_vendedo = tm_cabenotc.id_vendedo
   IF !FOUND() THEN
      INSERT INTO tm_informe (id_vendedo, vendedor) VALUES (tm_cabevent.id_vendedo, tm_cabevent.vendedor)
   ENDIF

   IF m.opcion = "S" THEN
      REPLACE (m.mes) WITH &mes - (tm_totales.exenta + tm_totales.grav_5 + tm_totales.grav_10 + tm_totales.iva_5 + tm_totales.iva_10)
   ELSE
      REPLACE (m.mes) WITH &mes - (tm_totales.exenta + tm_totales.grav_5 + tm_totales.grav_10)
   ENDIF
ENDSCAN

WAIT CLEAR

SELECT tm_informe
SUM (m_1 + m_2 + m_3 + m_4 + m_5 + m_6 + m_7 + m_8 + m_9 + m_10 + m_11 + m_12) TO m.suma
REPLACE total_anyo WITH (m_1 + m_2 + m_3 + m_4 + m_5 + m_6 + m_7 + m_8 + m_9 + m_10 + m_11 + m_12),;
        porcentaje WITH IIF(m.suma > 0, ROUND(total_anyo * 100 / m.suma, 2), 0) ALL