PARAMETERS tnRuta, tlImprimir

IF PARAMETER() < 2 THEN
   WAIT "NO SE HAN PASADO SUFICIENTES PARAMETROS." WINDOW NOWAIT
   RETURN
ENDIF

IF TYPE("tnRuta") <> "N" THEN
   WAIT "EL PRIMER PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW NOWAIT
   RETURN
ENDIF

IF TYPE("tlImprimir") <> "L" THEN
   WAIT "EL SEGUNDO PARAMETRO DEBE SER DE TIPO LOGICO." WINDOW NOWAIT
   RETURN
ENDIF

CLOSE ALL
CLEAR

SET CENTURY   ON
SET DATE      BRITISH
SET DELETED   ON
SET EXCLUSIVE OFF
SET EXACT     ON
SET TALK      OFF

PRIVATE cursor1, cursor2
cursor1 = createmp()
cursor2 = createmp()

CREATE TABLE (cursor1) (;
   id_cliente N(5),;
   cliente C(56),;
   contacto C(30),;
   telefono C(30),;
   direccion C(60),;
   id_ruta N(5),;
   ruta C(50),;
   vencido N(13,2),;
   a_vencer N(13,2),;
   total N(13,2),;
   venc_mes N(13,2),;
   estado L(1),;
   dias N(5),;
   fecuventa D(8);
)
INDEX ON cliente TAG cliente

CREATE TABLE (cursor2) (;
   tipodocu N(01) ,;
   nrodocu N(07) ,;
   fechadocu D(08) ,;
   cliente N(05) ,;
   nombre_a C(56) ,;
   ruc C(15) ,;
   direc1 C(60) ,;
   telefono C(30) ,;
   contacto C(30) ,;
   moneda N(04) ,;
   nombre_b C(30) ,;
   simbolo C(04) ,;
   tipo N(01) ,;
   nrocuota N(03) ,;
   qty_cuotas N(03) ,;
   fecha D(08) ,;
   importe N(12,2) ,;
   abonado N(12,2) ,;
   monto_ndeb N(12,2) ,;
   monto_ncre N(12,2) ,;
   consignaci L(01) ,;
   id_local N(02),;
   ruta N(01);
)

USE clientes IN 0 SHARED
USE ruta IN 0 SHARED
USE cabevent IN 0 SHARED
USE cuotas_v IN 0 SHARED
USE monedas IN 0 SHARED

DO saldo_cliente

SELECT clientes
SCAN FOR ruta = tnRuta
   STORE 0 TO m.id_cliente, m.id_ruta, m.vencido, m.a_vencer, m.total, m.venc_mes, m.dias
   STORE "" TO m.cliente, m.contacto, m.telefono, m.direccion, m.ruta
   STORE .T. TO m.estado
   STORE CTOD("  /  /    ") TO fecuventa

   m.id_cliente = codigo
   m.cliente = nombre
   m.contacto = contacto
   m.telefono = telefono
   m.direccion = direc1
   m.id_ruta = ruta
   m.estado = IIF(estado = "A", .T., .F.)

   SELECT ruta
   LOCATE FOR id_ruta = m.id_ruta
   IF FOUND() THEN
      m.ruta = nombre
   ENDIF

   SELECT (cursor2)
   SUM (importe + monto_ndeb) - (abonado + monto_ncre) FOR fecha - DATE() <= 0 AND cliente = m.id_cliente TO m.vencido
   SUM (importe + monto_ndeb) - (abonado + monto_ncre) FOR fecha - DATE() > 0 AND cliente = m.id_cliente TO m.a_vencer
   SUM (importe + monto_ndeb) - (abonado + monto_ncre) FOR cliente = m.id_cliente TO m.total
   SUM (importe + monto_ndeb) - (abonado + monto_ncre) FOR (YEAR(fecha) <= YEAR(DATE()) AND MONTH(fecha) <= MONTH(DATE())) AND cliente = m.id_cliente TO m.venc_mes
   CALCULATE MIN(fecha - DATE()) FOR cliente = m.id_cliente TO m.dias

   SELECT cabevent
   SET ORDER TO "indice2" DESC
   LOCATE FOR cliente = m.id_cliente
   IF FOUND() THEN
      m.fecuventa = fechadocu
   ENDIF

   INSERT INTO (cursor1) FROM MEMVAR
ENDSCAN

SELECT (cursor1)
DELETE FOR total = 0 AND !estado
GOTO TOP

REPORT FORM lst_cust FOR total > 0 PREVIEW 
*  REPORT FORM lst_cust PREVIEW   && All records

IF tlImprimir THEN
   REPORT FORM lst_cust FOR total > 0 TO PRINTER NOCONSOLE
*  REPORT FORM lst_cust TO PRINTER NOCONSOLE   && All records
ENDIF

SELECT (cursor1)
USE
DELETE FILE cursor1 + ".dbf"
DELETE FILE cursor1 + ".cdx"

SELECT (cursor2)
USE
DELETE FILE cursor2 + ".dbf"
DELETE FILE cursor2 + ".cdx"

*-------------------------------------------------------------------------------------------------------*
PROCEDURE saldo_cliente
   SELECT cuotas_v
   SCAN FOR ((importe + monto_ndeb) - (abonado + monto_ncre)) <> 0
      STORE 0 TO m.tipodocu, m.nrodocu, m.cliente, m.moneda, m.tipo, m.nrocuota, m.qty_cuotas, m.importe, m.abonado, m.monto_ndeb, m.monto_ncre, m.id_local, m.ruta
      STORE CTOD("  /  /    ") TO m.fechadocu, m.fecha
      STORE "" TO m.nombre_a, m.ruc, m.direc1, m.telefono, m.contacto, m.nombre_b, m.simbolo
      STORE .F. TO m.consignaci

      m.tipodocu   = tipodocu
      m.nrodocu    = nrodocu
      m.tipo       = tipo
      m.nrocuota   = nrocuota
      m.fecha      = fecha
      m.importe    = importe
      m.abonado    = abonado
      m.monto_ndeb = monto_ndeb
      m.monto_ncre = monto_ncre
      m.id_local   = id_local

      SELECT cabevent
      LOCATE FOR tipodocu = m.tipodocu AND nrodocu = m.nrodocu
      IF FOUND() THEN
         m.fechadocu  = fechadocu
         m.cliente    = cliente
         m.moneda     = moneda
         m.qty_cuotas = qty_cuotas
         m.consignaci = consignaci
      ENDIF

      SELECT clientes
      LOCATE FOR codigo = m.cliente
      IF FOUND() THEN
         m.nombre_a = nombre
         m.ruc      = ruc
         m.direc1   = direc1
         m.telefono = telefono
         m.contacto = contacto
         m.ruta     = ruta
      ENDIF

      SELECT monedas
      LOCATE FOR codigo = m.moneda
      IF FOUND() THEN
         m.nombre_b = nombre
         m.simbolo  = simbolo
      ENDIF

      INSERT INTO (cursor2) FROM MEMVAR
   ENDSCAN
*ENDPROC