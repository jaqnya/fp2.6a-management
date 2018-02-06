*
* vta_neta.prg
* 
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
* 
* Descripcion:
* Calcula el precio neto del detalle de venta
*
* Historial de Modificacion:
* Agosto 24, 2008	Jose Avilio Acuna Acosta	Creador del Programa
*

PARAMETERS m.tipodocu, m.nrodocu

IF PARAMETERS() < 2 THEN
   WAIT "PROGRAMA: VTA_NETA.PRG" + CHR(13) + "NO SE HAN PASADO SUFICIENTES PARAMETROS." WINDOW
   RETURN
ENDIF

IF TYPE("m.tipodocu") <> "N" THEN
   WAIT "PROGRAMA: VTA_NETA.PRG" + CHR(13) + "EL PRIMER PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW
   RETURN
ENDIF

IF TYPE("m.nrodocu") <> "N" THEN
   WAIT "PROGRAMA: VTA_NETA.PRG" + CHR(13) + "EL SEGUNDO PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW
   RETURN
ENDIF

IF !USED("cabevent") THEN
   USE cabevent IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detavent") THEN
   USE detavent IN 0 AGAIN ORDER 1 SHARED
ENDIF

CREATE CURSOR tm_detalle (;
   codigo     C(15),;
   cantidad   N(9,2),;
   precio     N(13,4),;
   porc_iva   N(6,2),;
   total1     N(12,2),;
   dto_lineal N(12,2),;
   total2     N(12,2),;
   porc_part  N(8,6),;
   importdesc N(12,2),;
   total3     N(12,2),;
   prec_neto  N(12,2),;
   total4     N(11),;
   exenta     N(11),;
   grav_5     N(11),;
   grav_10    N(11),;
   iva_5      N(11),;
   iva_10     N(11);
);

CREATE CURSOR tm_totales (;
   exenta  N(11),;
   grav_5  N(11),;
   grav_10 N(11),;
   iva_5   N(11),;
   iva_10  N(11);
);

PRIVATE m.decimales, m.precio, m.total1, m.dto_lineal, m.total2, m.subtotal, m.importdesc, m.total3, m.total4, m.exenta, m.grav_2, m.grav_5, m.grav_10, m.auxiliar, m.iva_2, m.iva_5, m.iva_10
STORE 0 TO m.decimales, m.precio, m.total1, m.dto_lineal, m.total2, m.subtotal, m.importdesc, m.total3, m.total4, m.exenta, m.grav_2, m.grav_5, m.grav_10, m.auxiliar, m.iva_2, m.iva_5, m.iva_10

SELECT cabevent
SET ORDER TO 1
IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7)) THEN
   SELECT detavent
   SET ORDER TO 1
   IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7)) THEN
      SCAN WHILE tipodocu = m.tipodocu AND nrodocu = m.nrodocu
         m.decimales  = IIF(cabevent.moneda = 1, 0, 2)
         m.precio     = ROUND(precio * (1 + pimpuesto / 100), 3)
         m.total1     = ROUND(m.precio * cantidad, m.decimales)
         m.dto_lineal = ROUND(m.total1 * pdescuento / 100, m.decimales)
         m.total2     = m.total1 - m.dto_lineal
         m.subtotal   = m.subtotal + m.total2
         INSERT INTO tm_detalle (codigo, cantidad, precio, porc_iva, total1, dto_lineal, total2);
            VALUES (detavent.articulo, detavent.cantidad, m.precio, detavent.pimpuesto, m.total1, m.dto_lineal, m.total2)
      ENDSCAN
   ELSE
      IF !cabevent.anulado THEN
         WAIT "LA VENTA: " + ALLTRIM(STR(m.tipodocu)) + "/" + ALLTRIM(STR(m.nrodocu)) + ", NO TIENE DETALLE." WINDOW
      ENDIF
   ENDIF
ELSE
   WAIT "LA VENTA: " + ALLTRIM(STR(m.tipodocu)) + "/" + ALLTRIM(STR(m.nrodocu)) + ", NO EXISTE." WINDOW
ENDIF

SELECT tm_detalle
REPLACE porc_part  WITH ROUND(total2 / m.subtotal, 6),;
        importdesc WITH ROUND(cabevent.importdesc * porc_part, m.decimales) ALL

SUM importdesc TO m.importdesc

IF m.importdesc <> cabevent.importdesc THEN
   GOTO TOP
   REPLACE importdesc WITH importdesc + (cabevent.importdesc - m.importdesc)
ENDIF

REPLACE total3    WITH (total2 - importdesc),;
        prec_neto WITH ROUND(total3 / cantidad, m.decimales),;
        total4    WITH ROUND(total3 * cabevent.tipocambio, 0) ALL

SUM total3, total4 TO m.total3, m.total4

IF ROUND(m.total3 * cabevent.tipocambio, 0) <> m.total4 THEN
   GOTO TOP
   REPLACE total4 WITH total4 + ROUND(m.total3 * cabevent.tipocambio, 0) - m.total4
ENDIF

*--------------------------------------------------------------------------*
SUM total4 TO m.exenta  FOR porc_iva = 0
SUM total4 TO m.grav_2  FOR porc_iva = 2
SUM total4 TO m.grav_5  FOR porc_iva = 5
SUM total4 TO m.grav_10 FOR porc_iva = 10

m.auxiliar = ROUND(m.grav_2 / 1.02, 0)
m.iva_2    = m.grav_2 - m.auxiliar
m.grav_2   = ROUND(m.auxiliar * 0.2, 0)
m.exenta   = m.exenta + m.auxiliar - m.grav_2

m.auxiliar = ROUND(m.grav_5 / 1.05, 0)
m.iva_5    = m.grav_5 - m.auxiliar
m.grav_5   = m.auxiliar

m.auxiliar = ROUND(m.grav_10 / 1.1, 0)
m.iva_10   = m.grav_10 - m.auxiliar
m.grav_10  = m.auxiliar

INSERT INTO tm_totales (exenta, grav_5, grav_10, iva_5, iva_10);
   VALUES (m.exenta, m.grav_5, m.grav_2 + m.grav_10, m.iva_5, m.iva_2 + m.iva_10)

*--------------------------------------------------------------------------*
SCAN ALL
   DO CASE
      CASE porc_iva = 0
         REPLACE exenta WITH total4
      CASE porc_iva = 2
         REPLACE exenta  WITH ROUND(total4 / 1.02, 0) - ROUND(ROUND(total4 / 1.02, 0) * 0.2, 0),;
                 grav_10 WITH ROUND(ROUND(total4 / 1.02, 0) * 0.2, 0),;
                 iva_10  WITH total4 - grav_10 - exenta
      CASE porc_iva = 5
         REPLACE grav_5 WITH ROUND(total4 / 1.05, 0),;
                 iva_5  WITH total4 - grav_5
      CASE porc_iva = 10
         REPLACE grav_10 WITH ROUND(total4 / 1.1, 0),;
                 iva_10  WITH total4 - grav_10
      OTHERWISE
         WAIT "ERROR:" + CHR(13) + "PORCENTAJE DE  I.V.A. DESCONOCIDO." + CHR(13) + "CONTACTE AL PROVEEDOR DEL SISTEMA." WINDOW
   ENDCASE
ENDSCAN

SUM exenta TO m.exenta

IF m.exenta <> tm_totales.exenta THEN
   LOCATE FOR porc_iva = 0
   REPLACE exenta WITH exenta + (tm_totales.exenta - m.exenta)
ENDIF

SUM grav_5 TO m.grav_5

IF m.grav_5 <> tm_totales.grav_5 THEN
   LOCATE FOR porc_iva = 5
   REPLACE grav_5 WITH grav_5 + (tm_totales.gravada_5 - m.grav_5)
ENDIF

SUM grav_10 TO m.grav_10

IF m.grav_10 <> tm_totales.grav_10 THEN
   LOCATE FOR porc_iva = 10
   REPLACE grav_10 WITH grav_10 + (tm_totales.grav_10 - m.grav_10)
ENDIF

SUM iva_5 TO m.iva_5

IF m.iva_5 <> tm_totales.iva_5 THEN
   LOCATE FOR porc_iva = 5
   REPLACE iva_5 WITH iva_5 + (tm_totales.iva_5 - m.iva_5)
ENDIF

SUM iva_10 TO m.iva_10

IF m.iva_10 <> tm_totales.iva_10 THEN
   LOCATE FOR porc_iva = 10
   REPLACE iva_10 WITH iva_10 + (tm_totales.iva_10 - m.iva_10)
ENDIF