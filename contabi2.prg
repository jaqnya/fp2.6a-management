PARAMETERS m.fecha1, m.fecha2

*/
**
*
* CONTABI2.PRG - MS FoxPro 2.6a for DOS
*
* Copyright (c) 1999-2007, Turtle Software Paraguay.
* Todos los derechos reservados.
*
* Descripcion: Crear asientos de venta a credito.
*
*    Autor: Jose Avilio Acu¤a Acosta
* Creacion: 22/04/2007
* Revision: 22/04/2007
*
**
*/

* Declaracion e inicializacion de constantes y variables de memoria
#DEFINE C_VENTA_MERC  "4-02-01-00-00-0000"
#DEFINE C_VENTA_SERV  "4-02-02-00-00-0000"
#DEFINE C_IVA_DEBITO  "2-01-10-02-01-0000"
#DEFINE C_DEVOL_MERC  "NCRE - MERCADERIA "
#DEFINE C_DEVOL_SERV  "NCRE - SERVICIO   "
#DEFINE C_IVA_CREDIT  "1-01-03-03-01-0000"

* Programa Principal
DO seteos

STORE "" TO archi1, archi2, archi3, archi4, archi5, archi6

IF MONTH(m.fecha1) = MONTH(m.fecha2) AND YEAR(m.fecha1) = YEAR(m.fecha2) THEN
   m.mes_anyo = "{" + get_month(m.fecha1) + "-" + STR(YEAR(m.fecha1), 4) +"}"
ELSE
   m.mes_anyo = "del {" + DTOC(m.fecha1) + "} al {" + DTOC(m.fecha2) + "}"
ENDIF
       
DO abrir_tablas

DO ventas
DO devoluciones

DO crear_asientos
DO resumir_asientos
DO crear_movim
DO cerrar_tablas

*---------------------------------------------------------------------------*
PROCEDURE seteos

SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON
SET ESCAPE  OFF
SET SAFETY  OFF
SET TALK    OFF

CLOSE ALL

*---------------------------------------------------------------------------*
PROCEDURE abrir_tablas

USE cabevent IN 0 SHARED ORDER 1
USE detavent IN 0 SHARED ORDER 1
USE cabeven2 IN 0 SHARED ORDER 1
USE clientes IN 0 SHARED ORDER 1
USE cabenotc IN 0 SHARED ORDER 1
USE detanotc IN 0 SHARED ORDER 1

*---------------------------------------------------------------------------*
PROCEDURE cerrar_tablas
CLOSE ALL

*---------------------------------------------------------------------------*
PROCEDURE ventas

* Crear archivo temporal
archi1 = "tm" + RIGHT(SYS(3), 6)

SELECT 0
CREATE TABLE &archi1 (;
   tipodocu   N(1),;
   nrodocu    N(7),;
   fechadocu  D(8),;
   cliente    N(5),;
   mercaderia N(9),;
   servicio   N(9),;
   iva_debito N(9),;
   monto_fact N(9),;
   divisa     N(5),;
   cambio     N(9,2),;
   nombre     C(50),;
   cuenta     C(18))

USE &archi1 ALIAS ventas
INDEX ON DTOS(fechadocu) + STR(tipodocu, 1) + STR(nrodocu, 7) TAG fechadocu

WAIT "PROCESO 1/9 - ARCHIVO: VENTAS" WINDOW NOWAIT

SELECT cabevent
SET ORDER TO 2
SCAN FOR BETWEEN(fechadocu, m.fecha1, m.fecha2) AND INLIST(tipodocu, 2, 8)
   SELECT detavent
   SET ORDER TO 1
   IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)) THEN
      STORE 0 TO m.merc_10, m.merc_5, m.servicio
      SCAN WHILE tipodocu = cabevent.tipodocu AND nrodocu = cabevent.nrodocu
         IF INLIST(articulo, "10001", "99001", "99002", "99003", "99010", "99011", "99012", "99013", "99014", "99020", "99021", "99022") THEN
            m.servicio = m.servicio + ROUND(precio * cantidad, IIF(cabevent.moneda = 1, 0, 2))
         ELSE
            IF pimpuesto = 10 THEN
               m.merc_10 = m.merc_10 + ROUND(precio * cantidad, IIF(cabevent.moneda = 1, 0, 2))
            ELSE
               IF pimpuesto = 5 THEN
                  m.merc_5 = m.merc_5 + ROUND(precio * cantidad, IIF(cabevent.moneda = 1, 0, 2))
               ELSE
                  WAIT "TIPO DE IMPUESTO DESCONOCIDO !" WINDOW
                  CANCEL
               ENDIF
            ENDIF
         ENDIF
      ENDSCAN

      SELECT cabevent
      IF moneda = 1 THEN
         m.monto_fact = monto_fact
         m.gravado    = ROUND(monto_fact / 1.1, 0)
         m.mercaderia = m.gravado - m.servicio
         m.iva_debito = monto_fact - m.gravado
      ELSE
         m.monto_fact = ROUND(monto_fact * tipocambio, 0)
         m.gravado    = ROUND(m.monto_fact / 1.1, 0)
         m.mercaderia = m.gravado - ROUND(m.servicio * tipocambio, 0)
         m.iva_debito = m.monto_fact - m.gravado
      ENDIF

      SELECT clientes
      SET ORDER TO 1

      IF SEEK(cabevent.cliente) THEN
         m.cliente = nombre
      ELSE
         WAIT "CODIGO DE CLIENTE INEXISTENTE !" WINDOW
         CANCEL
      ENDIF
      
      SELECT cabeven2
      SET ORDER TO 1
     
      IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)) THEN
         m.cliente = nombre
      ENDIF
            
      INSERT INTO ventas (tipodocu, nrodocu, fechadocu, cliente, mercaderia, servicio, iva_debito, monto_fact, divisa, cambio, nombre, cuenta) ;
         VALUES (cabevent.tipodocu, cabevent.nrodocu, cabevent.fechadocu, cabevent.cliente, m.mercaderia, m.servicio, m.iva_debito, m.monto_fact, cabevent.moneda, cabevent.tipocambio, m.cliente, clientes.cuenta)
   ENDIF
ENDSCAN

*---------------------------------------------------------------------------*
PROCEDURE devoluciones

* Crear archivo temporal
archi2 = "tm" + RIGHT(SYS(3), 6)

SELECT 0
CREATE TABLE &archi2 (;
   tiponota   N(1),;
   nronota    N(7),;
   fechanota  D(8),;
   tipodocu   N(1),;
   nrodocu    N(7),;
   cliente    N(5),;
   mercaderia N(9),;
   servicio   N(9),;
   iva_debito N(9),;
   monto_nota N(9),;
   divisa     N(5),;
   cambio     N(9,2),;
   nombre     C(50),;
   cuenta     C(18))

USE &archi2 ALIAS devoluciones
INDEX ON DTOS(fechanota) + STR(tiponota, 1) + STR(nronota, 7) TAG fechanota

WAIT "PROCESO 2/9 - ARCHIVO: NOTAS DE CREDITOS - CLIENTE" WINDOW NOWAIT

SELECT cabenotc
SET ORDER TO 2
SCAN FOR BETWEEN(fechanota, m.fecha1, m.fecha2) AND INLIST(tipodocu, 2, 8) AND aplicontra = 2
   SELECT detanotc
   SET ORDER TO 1
   IF SEEK(STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7)) THEN

      SELECT cabevent
      SET ORDER TO 1

      IF !SEEK(STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7)) THEN
         WAIT "VENTA: " + ALLTRIM(STR(cabenotc.tipodocu)) + "/" + ALLTRIM(STR(cabenotc.nrodocu)) + " INEXISTENTE !" WINDOW
         CANCEL
      ENDIF
      
      SELECT detanotc
      
      STORE 0 TO m.merc_10, m.merc_5, m.servicio
      SCAN WHILE tiponota = cabenotc.tiponota AND nronota = cabenotc.nronota
         IF INLIST(articulo, "10001", "99001", "99002", "99003", "99010", "99011", "99012", "99013", "99014", "99020", "99021", "99022") THEN
            m.servicio = m.servicio + ROUND(precio * cantidad, IIF(cabevent.moneda = 1, 0, 2))
         ELSE
            IF pimpuesto = 10 THEN
               m.merc_10 = m.merc_10 + ROUND(precio * cantidad, IIF(cabevent.moneda = 1, 0, 2))
            ELSE
               IF pimpuesto = 5 THEN
                  m.merc_5 = m.merc_5 + ROUND(precio * cantidad, IIF(cabevent.moneda = 1, 0, 2))
               ELSE
                  WAIT "TIPO DE IMPUESTO DESCONOCIDO !" WINDOW
                  CANCEL
               ENDIF
            ENDIF
         ENDIF
      ENDSCAN

      SELECT cabenotc
      IF cabevent.moneda = 1 THEN
         m.monto_nota = monto_nota
         m.gravado    = ROUND(monto_nota / 1.1, 0)
         m.mercaderia = m.gravado - m.servicio
         m.iva_debito = monto_nota - m.gravado
      ELSE
         m.monto_nota = ROUND(monto_nota * cabevent.tipocambio, 0)
         m.gravado    = ROUND(m.monto_nota / 1.1, 0)
         m.mercaderia = m.gravado - ROUND(m.servicio * cabevent.tipocambio, 0)
         m.iva_debito = m.monto_nota - m.gravado
      ENDIF

      SELECT clientes
      SET ORDER TO 1

      IF SEEK(cabevent.cliente) THEN
         m.cliente = nombre
      ELSE
         WAIT "CODIGO DE CLIENTE INEXISTENTE !" WINDOW
         CANCEL
      ENDIF
      
      SELECT cabeven2
      SET ORDER TO 1
     
      IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)) THEN
         m.cliente = nombre
      ENDIF
            
      INSERT INTO devolucion (tiponota, nronota, fechanota, tipodocu, nrodocu, cliente, mercaderia, servicio, iva_debito, monto_nota, divisa, cambio, nombre, cuenta) ;
         VALUES (cabenotc.tiponota, cabenotc.nronota, cabenotc.fechanota, cabenotc.tipodocu, cabenotc.nrodocu, cabenotc.cliente, m.mercaderia, m.servicio, m.iva_debito, m.monto_nota, cabevent.moneda, cabevent.tipocambio, m.cliente, clientes.cuenta)
   ENDIF
ENDSCAN

*---------------------------------------------------------------------------*
PROCEDURE crear_asientos

* Crear archivo temporal
archi4 = "tm" + RIGHT(SYS(3), 6)

SELECT 0
CREATE TABLE &archi4 (;
   nroasiento N(5),;
   fecha      D(8),;
   tipomovi   C(1),;
   cuenta     C(18),;
   monto      N(10),;
   concepto   C(60),;
   asnt_tipo  N(1),;
   asnt_nomb  C(30))

USE &archi4 ALIAS asientos
INDEX ON STR(asnt_tipo) + DTOS(fecha) TAG asnt_tipo

m.nroasiento = 1

* Asientos: Ventas

WAIT "PROCESO 4/9 - CREANDO ASIENTOS DE VENTAS" WINDOW NOWAIT

SELECT ventas
SCAN ALL
   * Cuenta deudora
   INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb);
      VALUES (m.nroasiento, ventas.fechadocu, "D", ventas.cuenta, ventas.monto_fact, "s/Factura Credito No. " + ALLTRIM(STR(ventas.nrodocu)) + " - " + ALLTRIM(ventas.nombre), 1, "VENTA CREDITO")

   * Cuentas acreedoras
   SELECT ventas
   IF mercaderia <> 0 THEN
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
         VALUES (m.nroasiento, ventas.fechadocu, "C", C_VENTA_MERC, ventas.mercaderia, "s/Factura Credito No. " + ALLTRIM(STR(ventas.nrodocu)) + " - " + ALLTRIM(ventas.nombre), 1, "VENTA CREDITO")
   ENDIF

   IF servicio <> 0 THEN
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
         VALUES (m.nroasiento, ventas.fechadocu, "C", C_VENTA_SERV, ventas.servicio, "s/Factura Credito No. " + ALLTRIM(STR(ventas.nrodocu)) + " - " + ALLTRIM(ventas.nombre), 1, "VENTA CREDITO")
   ENDIF

   IF iva_debito <> 0 THEN
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
         VALUES (m.nroasiento, ventas.fechadocu, "C", C_IVA_DEBITO, ventas.iva_debito, "s/Factura Credito No. " + ALLTRIM(STR(ventas.nrodocu)) + " - " + ALLTRIM(ventas.nombre), 1, "VENTA CREDITO")
   ENDIF

   m.nroasiento = m.nroasiento + 1
ENDSCAN

* Asientos: Devoluciones

WAIT "PROCESO 5/9 - CREANDO ASIENTOS DE DEVOLUCIONES" WINDOW NOWAIT

SELECT devoluciones
SCAN ALL
   * Cuentas deudoras
   SELECT devoluciones
   IF mercaderia <> 0 THEN
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
         VALUES (m.nroasiento, devolucion.fechanota, "D", C_DEVOL_MERC, devolucion.mercaderia, "s/Nota de Credito No. " + ALLTRIM(STR(devolucion.nronota)) + " - " + ALLTRIM(devolucion.nombre), 3, "DEVOLUCION CREDITO - CLIENTE")
   ENDIF

   IF servicio <> 0 THEN
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
         VALUES (m.nroasiento, devolucion.fechanota, "D", C_DEVOL_SERV, devolucion.servicio, "s/Nota de Credito No. " + ALLTRIM(STR(devolucion.nronota)) + " - " + ALLTRIM(devolucion.nombre), 3, "DEVOLUCION CREDITO - CLIENTE")
   ENDIF

   IF iva_debito <> 0 THEN
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
         VALUES (m.nroasiento, devolucion.fechanota, "D", C_IVA_CREDIT, devolucion.iva_debito, "s/Nota de Credito No. " + ALLTRIM(STR(devolucion.nronota)) + " - " + ALLTRIM(devolucion.nombre), 3, "DEVOLUCION CREDITO - CLIENTE")
   ENDIF

   * Cuenta acreedora
   INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb);
      VALUES (m.nroasiento, devolucion.fechanota, "C", devolucion.cuenta, devolucion.monto_nota, "s/Nota de Credito No. " + ALLTRIM(STR(devolucion.nronota)) + " - " + ALLTRIM(devolucion.nombre), 3, "DEVOLUCION CREDITO - CLIENTE")

   m.nroasiento = m.nroasiento + 1
ENDSCAN

*---------------------------------------------------------------------------*
PROCEDURE resumir_asientos

WAIT "PROCESO 7/9 - RESUMIENDO ASIENTOS POR TIPO DE ASIENTO" WINDOW NOWAIT

* Crear archivo temporal
archi5 = "tm" + RIGHT(SYS(3), 6)

SELECT 0
CREATE TABLE &archi5 (;
   nroasiento N(5),;
   fecha      D(8),;
   tipomovi   C(1),;
   cuenta     C(18),;
   monto      N(10),;
   concepto   C(40),;
   cerrado    L(1),;
   marca_cash C(1),;
   empresa    N(8),;
   libro_iva  C(1),;
   nro_op_iva N(7),;
   ccosto     N(3),;
   asnt_tipo  N(1))

USE &archi5 ALIAS asientos2
INDEX ON nroasiento TAG nroasiento

archi6 = "tm" + RIGHT(SYS(3), 6)

SELECT 0
CREATE TABLE &archi6 (asnt_tipo N(1))

USE &archi6 ALIAS asnt_tipo

* Obtiene una lista de los tipos de asientos
SELECT asientos
SET ORDER TO 1
SCAN ALL
   SELECT asnt_tipo
   LOCATE FOR asnt_tipo = asientos.asnt_tipo
   IF !FOUND() THEN
      INSERT INTO asnt_tipo (asnt_tipo) VALUES (asientos.asnt_tipo)
   ENDIF
ENDSCAN

* Resume los asientos por tipos de asientos
USE depo IN 0

SELECT depo
CALCULATE MAX(nroasiento) TO m.nroasiento
m.nroasiento = m.nroasiento + 1

IF m.nroasiento = 1 THEN
   USE contado IN 0
   
   SELECT contado
   CALCULATE MAX(nroasiento) TO m.nroasiento
   m.nroasiento = m.nroasiento + 1
ENDIF

SELECT asnt_tipo
SCAN ALL
   SELECT asientos
   SET ORDER TO 1

   SCAN FOR asnt_tipo = asnt_tipo.asnt_tipo
      SELECT asientos2
      LOCATE FOR cuenta = asientos.cuenta AND asnt_tipo = asnt_tipo.asnt_tipo
      IF FOUND() THEN
         IF asientos.tipomovi = asientos2.tipomovi THEN
            REPLACE monto WITH monto + asientos.monto
         ELSE
            REPLACE monto with monto - asientos.monto
         ENDIF
      ELSE
         INSERT INTO asientos2 (nroasiento, fecha, tipomovi, cuenta, monto, concepto, cerrado, marca_cash, empresa, libro_iva, nro_op_iva, ccosto, asnt_tipo);
            VALUES (m.nroasiento, asientos.fecha, asientos.tipomovi, asientos.cuenta, asientos.monto, IIF(asientos.asnt_tipo = 1, "Venta a Credito ", "Devolucion de Clientes ") + m.mes_anyo, .F., "", 0, "", 0, 0, asientos.asnt_tipo)
      ENDIF
   ENDSCAN

   m.nroasiento = m.nroasiento + 1
ENDSCAN

* Formatea los asientos

WAIT "PROCESO 8/9 - FORMATEANDO ASIENTOS" WINDOW NOWAIT

* Cuentas deudoras
SELECT * FROM asientos2 WHERE tipomovi = "D" AND cuenta = C_DEVOL_MERC INTO TABLE debi_01
SELECT * FROM asientos2 WHERE tipomovi = "D" AND cuenta = C_DEVOL_SERV INTO TABLE debi_02
SELECT * FROM asientos2 WHERE tipomovi = "D" AND cuenta = C_IVA_CREDIT INTO TABLE debi_03
*SELECT * FROM asientos2 WHERE tipomovi = "D" AND !INLIST(cuenta, C_DEVOL_MERC, C_DEVOL_SERV, C_IVA_CREDIT) ORDER BY cuenta INTO TABLE debi_04
SELECT * FROM asientos2 a, cuentas b WHERE a.cuenta = b.codigo AND a.tipomovi = "D" AND !INLIST(a.cuenta, C_DEVOL_MERC, C_DEVOL_SERV, C_IVA_CREDIT) ORDER BY nombre INTO TABLE debi_04

* Cuentas acreedoras
SELECT * FROM asientos2 WHERE tipomovi = "C" AND cuenta = C_VENTA_MERC INTO TABLE cred_01
SELECT * FROM asientos2 WHERE tipomovi = "C" AND cuenta = C_VENTA_SERV INTO TABLE cred_02
SELECT * FROM asientos2 WHERE tipomovi = "C" AND cuenta = C_IVA_DEBITO INTO TABLE cred_03
*SELECT * FROM asientos2 WHERE tipomovi = "C" AND !INLIST(cuenta, C_VENTA_MERC, C_VENTA_SERV, C_IVA_DEBITO) INTO TABLE cred_04
SELECT * FROM asientos2 a, cuentas b WHERE a.cuenta = b.codigo AND a.tipomovi = "C" AND !INLIST(a.cuenta, C_VENTA_MERC, C_VENTA_SERV, C_IVA_DEBITO) ORDER BY nombre INTO TABLE cred_04

SELECT asientos2 
ZAP

APPEND FROM debi_01
APPEND FROM debi_02
APPEND FROM debi_03
APPEND FROM debi_04

APPEND FROM cred_01
APPEND FROM cred_02
APPEND FROM cred_03
APPEND FROM cred_04

REPLACE cuenta WITH C_VENTA_MERC FOR cuenta = C_DEVOL_MERC
REPLACE cuenta WITH C_VENTA_SERV FOR cuenta = C_DEVOL_SERV
REPLACE fecha  WITH m.fecha2 ALL

*---------------------------------------------------------------------------*
PROCEDURE crear_movim

WAIT "PROCESO 9/9 - FINALIZANDO PROCESO" WINDOW NOWAIT

SELECT 0
CREATE TABLE credito (;
   nroasiento N(5),;
   fecha      D(8),;
   tipomovi   C(1),;
   cuenta     C(18),;
   monto      N(10),;
   concepto   C(40),;
   cerrado    L(1),;
   marca_cash C(1),;
   empresa    N(8),;
   libro_iva  C(1),;
   nro_op_iva N(7),;
   ccosto     N(3))

USE credito ALIAS credito	

SELECT asientos2
SET ORDER TO 1
SCAN ALL
   INSERT INTO credito (nroasiento, fecha, tipomovi, cuenta, monto, concepto, cerrado, marca_cash, empresa, libro_iva, nro_op_iva, ccosto);
      VALUES (asientos2.nroasiento, asientos2.fecha, asientos2.tipomovi, asientos2.cuenta, asientos2.monto, asientos2.concepto, asientos2.cerrado, asientos2.marca_cash, asientos2.empresa, asientos2.libro_iva, asientos2.nro_op_iva, asientos2.ccosto)
ENDSCAN

WAIT CLEAR

* Browse para ver el diario

RETURN

WAIT "{CREDITO.DBF}" WINDOW NOWAIT

SELECT cuentas
SET ORDER TO 1

*USE cuentas IN 0 SHARED ORDER 1

SELECT credito
SET RELATION TO cuenta INTO cuentas

BROWSE FIELDS ;
   b1 = nroasiento :H = "Asiento",;
   b2 = fecha :H = "Fecha",;
   b3 = cuentas.nombre :H = "Descripci¢n",;
   b4 = IIF(tipomovi = "D", TRANSFORM(monto, "999,999,999"), SPACE(11)) :H = "Debe",;
   b5 = IIF(tipomovi = "C", TRANSFORM(monto, "999,999,999"), SPACE(11)) :H = "Haber",;
   b6 = concepto :H = "Concepto",;
   b7 = cuenta :H = "Cuenta" ;
   NOAPPEND NOMODIFY NODELETE
   
*---------------------------------------------------------------------------*
PROCEDURE get_month
PARAMETER mfecha

DO CASE
   CASE MONTH(mfecha) = 1
      mretorno = "ENERO"
   CASE MONTH(mfecha) = 2
      mretorno = "FEBRERO"
   CASE MONTH(mfecha) = 3
      mretorno = "MARZO"
   CASE MONTH(mfecha) = 4
      mretorno = "ABRIL"
   CASE MONTH(mfecha) = 5
      mretorno = "MAYO"
   CASE MONTH(mfecha) = 6
      mretorno = "JUNIO"
   CASE MONTH(mfecha) = 7
      mretorno = "JULIO"
   CASE MONTH(mfecha) = 8
      mretorno = "AGOSTO"
   CASE MONTH(mfecha) = 9
      mretorno = "SEPTIEMBRE"
   CASE MONTH(mfecha) = 10
      mretorno = "OCTUBRE"
   CASE MONTH(mfecha) = 11
      mretorno = "NOVIEMBRE"
   CASE MONTH(mfecha) = 12
      mretorno = "DICIEMBRE"
ENDCASE

RETURN (mretorno)