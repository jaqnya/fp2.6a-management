*
* saldo_c2.prg
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

PARAMETERS tnClienteID

IF PARAMETERS() < 1 THEN
   WAIT "PROGRAMA: SALDO_C2.PRG" + CHR(13) + "NO SE HAN PASADO SUFICIENTES PARAMETROS." WINDOW
   RETURN
ENDIF

IF TYPE("tnClienteID") <> "N" THEN
   WAIT "PROGRAMA: SALDO_C2.PRG" + CHR(13) + "EL PRIMER PARAMETRO DEBE SER DE TIPO NUMERICO." WINDOW
   RETURN
ENDIF

*--------------------------------------------------------------------------*
IF !USED("cabevent") THEN
   USE cabevent IN 0 ORDER 1 SHARED
ENDIF

IF !USED("cuotas_v") THEN
   USE cuotas_v IN 0 ORDER 1 SHARED
ENDIF

IF !USED("clientes") THEN
   USE clientes IN 0 ORDER 1 SHARED
ENDIF

IF !USED("monedas") THEN
   USE monedas IN 0 ORDER 1 SHARED
ENDIF

CREATE CURSOR tm_saldo_c (;
   cliente_id N(5),;
   cliente C(56),;
   tipodocu N(1),;
   nrodocu N(7),;
   saldo N(12,2),;
   moneda C(4),;
   fecha_vto D(8),;
   fecha_emi D(8);
)

SELECT cabevent
SET ORDER TO "indice3"   && cliente
IF SEEK(tnClienteID) THEN
   SCAN WHILE cliente = tnClienteID
      IF tipodocu = 8 THEN   && credito
         SELECT cuotas_v
         SET ORDER TO "indice1"   && STR(tipodocu, 1) + STR(nrodocu, 7) + STR(nrocuota, 3)
         IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7) + "  1") THEN
            SCAN WHILE cabevent.tipodocu = tipodocu AND cabevent.nrodocu = nrodocu
               IF (importe + monto_ndeb) - (abonado + monto_ncre) > 0 THEN
                  SELECT clientes
                  SET ORDER TO "indice1"
                  SEEK tnClienteID

                  SELECT monedas
                  SET ORDER TO "indice1"
                  SEEK cabevent.moneda

                  INSERT INTO tm_saldo_c VALUES (tnClienteID, clientes.nombre, cabevent.tipodocu, cabevent.nrodocu, (cuotas_v.importe - cuotas_v.monto_ndeb) - (cuotas_v.abonado + cuotas_v.monto_ncre), monedas.simbolo, cuotas_v.fecha, cabevent.fechadocu)
               ENDIF
            ENDSCAN
         ENDIF
      ENDIF
   ENDSCAN
ENDIF

SELECT tm_saldo_c