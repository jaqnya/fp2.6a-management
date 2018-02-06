*
* cob_neto.prg
* 
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
* 
* Descripcion:
* Calcula el cobro neto
*
* Historial de Modificacion:
* Agosto 26, 2008	Jose Avilio Acuna Acosta	Creador del Programa
*

PARAMETERS m.tiporeci, m.nroreci

IF PARAMETERS() < 2 THEN
   WAIT "PROGRAMA: COB_NETO.PRG" + CHR(13) + "NO SE HAN PASADO SUFICIENTES PARAMETROS." WINDOW
   RETURN
ENDIF

IF TYPE("m.tiporeci") <> "N" THEN
   WAIT "PROGRAMA: COB_NETO.PRG" + CHR(13) + "EL PRIMER PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW
   RETURN
ENDIF

IF TYPE("m.nroreci") <> "N" THEN
   WAIT "PROGRAMA: COB_NETO.PRG" + CHR(13) + "EL SEGUNDO PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW
   RETURN
ENDIF

IF !USED("cabevent") THEN
   USE cabevent IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabecob") THEN
   USE cabecob IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detacob") THEN
   USE detacob IN 0 AGAIN ORDER 1 SHARED
ENDIF

CREATE CURSOR tm_totales (;
   monto1 N(12,2),;
   monto2 N(11),;
   monto3 N(11);
);

* Decripcion de campos de la tabla 'tm_totales'
* ---------------------------------------------------
*
* monto1 = importe de la cobranza en moneda original.
* monto2 = importe de la cobranza en moneda nacional.
* monto3 = importe de las facturas cobradas, cotizada
*          al cambio de la fecha de venta.
*
* Para obtener la diferecia de cambio se debe restar:
*                   monto3 - monto2
* Si es positivo, diferencia de cambio positiva.
* Si es negativo, diferencia de cambio negativa.

PRIVATE m.monto1, m.monto3
STORE 0 TO m.monto1, m.monto3

SELECT cabecob
SET ORDER TO 1
IF SEEK(STR(m.tiporeci, 1) + STR(m.nroreci, 7)) THEN
   SELECT detacob
   SET ORDER TO 1
   IF SEEK(STR(m.tiporeci, 1) + STR(m.nroreci, 7)) THEN
      SCAN WHILE tiporeci = m.tiporeci AND nroreci = m.nroreci
         SELECT cabevent
         SET ORDER TO 1
         IF SEEK(STR(detacob.tipodocu, 1) + STR(detacob.nrodocu, 7)) THEN
            m.monto1 = m.monto1 + detacob.monto
            m.monto3 = m.monto3 + ROUND(detacob.monto * cabevent.tipocambio, 0)
         ELSE
            WAIT "LA VENTA: " + ALLTRIM(STR(detacob.tipodocu)) + "/" + ALLTRIM(STR(detacob.nrodocu)) + ", NO EXISTE." WINDOW
         ENDIF
      ENDSCAN
   ELSE
      WAIT "EL COBRO: " + ALLTRIM(STR(m.tiporeci)) + "/" + ALLTRIM(STR(m.nroreci)) + ", NO TIENE DETALLE." WINDOW
   ENDIF
ELSE
   WAIT "EL COBRO: " + ALLTRIM(STR(m.tiporeci)) + "/" + ALLTRIM(STR(m.nroreci)) + ", NO EXISTE." WINDOW
ENDIF

INSERT INTO tm_totales VALUES (m.monto1, ROUND(m.monto1 * cabecob.tipocambio, 0), m.monto3)