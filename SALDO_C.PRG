*
* saldo_c.prg
* 
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
* 
* Descripcion:
* Devuelve la tabla tm_saldo_c con las cuentas pendientes de cobro
* de los clientes
*
* Historial de Modificacion:
* Enero 13, 2009	Jose Avilio Acuna Acosta	Creador del Programa
*

PARAMETERS m.id_cliente

IF PARAMETERS() < 1 THEN
   WAIT "PROGRAMA: SALDO_C.PRG" + CHR(13) + "NO SE HAN PASADO SUFICIENTES PARAMETROS." WINDOW
   RETURN
ENDIF

IF TYPE("m.id_cliente") <> "N" THEN
   WAIT "PROGRAMA: SALDO_C.PRG" + CHR(13) + "EL PRIMER PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW
   RETURN
ENDIF

*--------------------------------------------------------------------------*
SELECT;
   b.cliente AS id_cliente,;
   d.nombre AS cliente,;
   a.tipodocu,;
   a.nrodocu,;
   (a.importe + a.monto_ndeb) - (a.abonado + a.monto_ncre) AS saldo,;
   c.simbolo,;
   a.fecha AS fecha_vto,;
   b.fechadocu AS fecha_emi;
FROM;
   cuotas_v a,;
   cabevent b,;
   monedas c,;
   clientes d;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   b.moneda = c.codigo AND;
   b.cliente = d.codigo AND;
   b.cliente = m.id_cliente AND;
   (a.importe + a.monto_ndeb) - (a.abonado + a.monto_ncre) > 0;
INTO CURSOR;
   tm_saldo_c