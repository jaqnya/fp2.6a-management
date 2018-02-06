PARAMETERS m.fecha1, m.fecha2

*/
**
*
* CONTABIL.PRG - MS FoxPro 2.6a for DOS
*
* Copyright (c) 1999-2007, Turtle Software Paraguay.
* Todos los derechos reservados.
*
* Descripcion: Crear asientos de cierre de caja.
*
*    Autor: Jose Avilio Acu¤a Acosta
* Creacion: 20/04/2007
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
#DEFINE C_RECAUD_DEP  "1-01-01-01-02-0000"
#DEFINE C_CAJA_MMEE   "1-01-01-01-04-0000"
#DEFINE C_TARJ_CREDI  "1-01-03-01-03-0000"
#DEFINE C_REGIONAL_CC "1-01-01-02-01-0001"
#DEFINE C_C_AHOR_MMEE "1-01-01-02-02-0001"
#DEFINE C_BNF_CTA_CTE "1-01-01-02-01-0002"
#DEFINE C_DIF_PERDIDA "5-15-05-00-00-0000"
#DEFINE C_DIF_GANANCI "4-10-02-00-00-0000"

* Programa Principal
DO seteos

STORE "" TO archi1, archi2, archi3, archi4, archi5, archi6

DO abrir_tablas

DO ventas
DO devoluciones
DO cobros

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
USE cabecob  IN 0 SHARED ORDER 1
USE detacob  IN 0 SHARED ORDER 1
USE form_cob IN 0 SHARED ORDER 0

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
SCAN FOR BETWEEN(fechadocu, m.fecha1, m.fecha2) AND INLIST(tipodocu, 1, 7)
   SELECT detavent
   SET ORDER TO 1
   IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)) THEN
      STORE 0 TO m.merc_10, m.merc_5, m.merc_0, m.servicio
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
                  IF pimpuesto = 2 THEN
                     mvar1 = ROUND(ROUND(precio * cantidad, IIF(cabevent.moneda = 1, 0, 2)) * 0.20, IIF(cabevent.moneda = 1, 0, 2))
                     mvar2 = ROUND(precio * cantidad, IIF(cabevent.moneda = 1, 0, 2)) - ROUND(ROUND(precio * cantidad, IIF(cabevent.moneda = 1, 0, 2)) * 0.20, IIF(cabevent.moneda = 1, 0, 2))
                     m.merc_10 = m.merc_10 + mvar1
                     m.merc_0  = m.merc_0  + mvar2
                  ELSE
                     IF pimpuesto = 0 THEN
                        m.merc_0 = m.merc_0 + ROUND(precio * cantidad, IIF(cabevent.moneda = 1, 0, 2))
                     ELSE
                        WAIT "TIPO DE IMPUESTO DESCONOCIDO {CAJA} !" WINDOW
                        CANCEL
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDSCAN

      SELECT cabevent
      IF moneda = 1 THEN
         m.monto_fact = monto_fact
         m.gravado    = ROUND((monto_fact - m.merc_0) / 1.1, 0)
         m.mercaderia = m.gravado - m.servicio
         m.iva_debito = monto_fact - m.gravado - m.merc_0
      ELSE
         m.monto_fact = ROUND(monto_fact * tipocambio, 0)
         m.gravado    = ROUND((m.monto_fact - ROUND(m.merc_0 * tipocambio, 0)) / 1.1, 0)
         m.mercaderia = m.gravado - ROUND(m.servicio * tipocambio, 0)
         m.iva_debito = m.monto_fact - m.gravado - m.merc_0
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

USE &archi2 ALIAS devolucion
INDEX ON DTOS(fechanota) + STR(tiponota, 1) + STR(nronota, 7) TAG fechanota

WAIT "PROCESO 2/9 - ARCHIVO: NOTAS DE CREDITOS - CLIENTE" WINDOW NOWAIT

SELECT cabenotc
SET ORDER TO 2
SCAN FOR BETWEEN(fechanota, m.fecha1, m.fecha2) AND (INLIST(tipodocu, 1, 7) OR aplicontra = 1)
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
PROCEDURE cobros

* Crear archivo temporal
archi3 = "tm" + RIGHT(SYS(3), 6)

SELECT 0
CREATE TABLE &archi3 (;
   tiporeci   N(1),;
   nroreci    N(7),;
   fechareci  D(8),;
   cliente    N(5),;
   monto_cobr N(9),;
   monto_fact N(9),;
   divisa     N(5),;
   cambio     N(9,2),;
   nombre     C(50),;
   cuenta     C(18))

USE &archi3 ALIAS cobros
INDEX ON DTOS(fechareci) + STR(tiporeci, 1) + STR(nroreci, 7) TAG fechareci

WAIT "PROCESO 3/9 - ARCHIVO: COBROS A CLIENTES" WINDOW NOWAIT

SELECT cabecob
SET ORDER TO 2
SCAN FOR BETWEEN(fechareci, m.fecha1, m.fecha2) AND tiporeci = 1
   SELECT detacob
   SET ORDER TO 1
   IF SEEK(STR(cabecob.tiporeci, 1) + STR(cabecob.nroreci, 7)) THEN
      STORE 0 TO m.monto_fact
      SCAN WHILE tiporeci = cabecob.tiporeci AND nroreci = cabecob.nroreci
         SELECT cabevent
         SET ORDER TO 1

         IF !SEEK(STR(detacob.tipodocu, 1) + STR(detacob.nrodocu, 7)) THEN
            WAIT "VENTA: " + ALLTRIM(STR(cabenotc.tipodocu)) + "/" + ALLTRIM(STR(cabenotc.nrodocu)) + " INEXISTENTE !" WINDOW
            CANCEL
         ENDIF

         SELECT detacob
         IF cabevent.moneda = 1 THEN
            m.monto_fact = m.monto_fact + monto
         ELSE
            m.monto_fact = m.monto_fact + ROUND(monto * cabevent.tipocambio, 0)
         ENDIF
      ENDSCAN

      SELECT clientes
      SET ORDER TO 1

      IF SEEK(cabecob.cliente) THEN
         m.cliente = nombre
      ELSE
         WAIT "CODIGO DE CLIENTE INEXISTENTE !" WINDOW
         CANCEL
      ENDIF
      
      SELECT detacob
      SET ORDER TO 1
  
      IF SEEK(STR(cabecob.tiporeci, 1) + STR(cabecob.nroreci, 7)) THEN
         SELECT cabeven2
         SET ORDER TO 1
     
         IF SEEK(STR(detacob.tipodocu, 1) + STR(detacob.nrodocu, 7)) THEN
            m.cliente = nombre
         ENDIF
      ENDIF
            
      INSERT INTO cobros (tiporeci, nroreci, fechareci, cliente, monto_cobr, monto_fact, divisa, cambio, nombre, cuenta) ;
         VALUES (cabecob.tiporeci, cabecob.nroreci, cabecob.fechareci, cabecob.cliente, 0, m.monto_fact, cabecob.moneda, cabecob.tipocambio, m.cliente, clientes.cuenta)
   ENDIF
ENDSCAN

* Calcular el monto cobrado
SELECT cobros
SCAN ALL
   m.monto_cobr = 0

   SELECT form_cob
   SCAN FOR tipodocu = cobros.tiporeci AND nrodocu = cobros.nroreci AND doc_id = 2
      m.monto_cobr = m.monto_cobr + ROUND(importe * cambio, 0)
   ENDSCAN
   
   SELECT cobros
   REPLACE monto_cobr WITH IIF(m.monto_cobr = 0, monto_fact, m.monto_cobr)
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
INDEX ON DTOS(fecha) TAG fecha

m.nroasiento = 1

* Asientos: Ventas

WAIT "PROCESO 4/9 - CREANDO ASIENTOS DE VENTAS" WINDOW NOWAIT

SELECT ventas
SCAN ALL
   * Cuentas deudoras
   SELECT form_cob
   LOCATE FOR tipodocu = ventas.tipodocu AND nrodocu = ventas.nrodocu AND doc_id = 1
   
   IF FOUND() THEN
      SCAN FOR tipodocu = ventas.tipodocu AND nrodocu = ventas.nrodocu AND doc_id = 1
         DO CASE
            CASE forma_id = 1   && 1. Caja Moneda Local
               INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb);
                  VALUES (m.nroasiento, ventas.fechadocu, "D", C_RECAUD_DEP, ROUND(form_cob.importe * form_cob.cambio, 0), "s/Factura Contado No. " + ALLTRIM(STR(ventas.nrodocu)) + " - " + ALLTRIM(ventas.nombre), 1, "VENTA CONTADO")
            CASE forma_id = 2   && 2. Caja Moneda Extranjera US$
               INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
                  VALUES (m.nroasiento, ventas.fechadocu, "D", C_CAJA_MMEE, ROUND(form_cob.importe * form_cob.cambio, 0), "s/Factura Contado No. " + ALLTRIM(STR(ventas.nrodocu)) + " - " + ALLTRIM(ventas.nombre), 1, "VENTA CONTADO")
            CASE forma_id = 3   && 3. Tarjeta de Credito
               INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
                  VALUES (m.nroasiento, ventas.fechadocu, "D", C_TARJ_CREDI, ROUND(form_cob.importe * form_cob.cambio, 0), "s/Factura Contado No. " + ALLTRIM(STR(ventas.nrodocu)) + " - " + ALLTRIM(ventas.nombre), 1, "VENTA CONTADO")
            CASE forma_id = 4   && 4. Banco Regional S.A. Cta. Cte.
               INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
                  VALUES (m.nroasiento, ventas.fechadocu, "D", C_REGIONAL_CC, ROUND(form_cob.importe * form_cob.cambio, 0), "s/Factura Contado No. " + ALLTRIM(STR(ventas.nrodocu)) + " - " + ALLTRIM(ventas.nombre), 1, "VENTA CONTADO")
            CASE forma_id = 5   && 5. Banco Nacional de Fomento Cta. Cte.
               INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
                  VALUES (m.nroasiento, ventas.fechadocu, "D", C_BNF_CTA_CTE, ROUND(form_cob.importe * form_cob.cambio, 0), "s/Factura Contado No. " + ALLTRIM(STR(ventas.nrodocu)) + " - " + ALLTRIM(ventas.nombre), 1, "VENTA CONTADO")
            CASE forma_id = 6   && 6. Banco Regional S.A. Caja Ahorro US$
               INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
                  VALUES (m.nroasiento, ventas.fechadocu, "D", C_C_AHOR_MMEE, ROUND(form_cob.importe * form_cob.cambio, 0), "s/Factura Contado No. " + ALLTRIM(STR(ventas.nrodocu)) + " - " + ALLTRIM(ventas.nombre), 1, "VENTA CONTADO")
         ENDCASE
      ENDSCAN
   ELSE
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb);
         VALUES (m.nroasiento, ventas.fechadocu, "D", C_RECAUD_DEP, ventas.monto_fact, "s/Factura Contado No. " + ALLTRIM(STR(ventas.nrodocu)) + " - " + ALLTRIM(ventas.nombre), 1, "VENTA CONTADO")
   ENDIF

   * Cuentas acreedoras
   SELECT ventas
   IF mercaderia <> 0 THEN
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
         VALUES (m.nroasiento, ventas.fechadocu, "C", C_VENTA_MERC, ventas.mercaderia, "s/Factura Contado No. " + ALLTRIM(STR(ventas.nrodocu)) + " - " + ALLTRIM(ventas.nombre), 1, "VENTA CONTADO")
   ENDIF

   IF servicio <> 0 THEN
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
         VALUES (m.nroasiento, ventas.fechadocu, "C", C_VENTA_SERV, ventas.servicio, "s/Factura Contado No. " + ALLTRIM(STR(ventas.nrodocu)) + " - " + ALLTRIM(ventas.nombre), 1, "VENTA CONTADO")
   ENDIF

   IF iva_debito <> 0 THEN
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
         VALUES (m.nroasiento, ventas.fechadocu, "C", C_IVA_DEBITO, ventas.iva_debito, "s/Factura Contado No. " + ALLTRIM(STR(ventas.nrodocu)) + " - " + ALLTRIM(ventas.nombre), 1, "VENTA CONTADO")
   ENDIF

   m.nroasiento = m.nroasiento + 1
ENDSCAN

* Asientos: Devoluciones

WAIT "PROCESO 5/9 - CREANDO ASIENTOS DE DEVOLUCIONES" WINDOW NOWAIT

SELECT devolucion
SCAN ALL
   * Cuentas deudoras
   SELECT devolucion
   IF mercaderia <> 0 THEN
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
         VALUES (m.nroasiento, devolucion.fechanota, "D", C_DEVOL_MERC, devolucion.mercaderia, "s/Nota de Credito No. " + ALLTRIM(STR(devolucion.nronota)) + " - " + ALLTRIM(devolucion.nombre), 3, "DEVOLUCION CONTADO - CLIENTE")
   ENDIF

   IF servicio <> 0 THEN
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
         VALUES (m.nroasiento, devolucion.fechanota, "D", C_DEVOL_SERV, devolucion.servicio, "s/Nota de Credito No. " + ALLTRIM(STR(devolucion.nronota)) + " - " + ALLTRIM(devolucion.nombre), 3, "DEVOLUCION CONTADO - CLIENTE")
   ENDIF

   IF iva_debito <> 0 THEN
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
         VALUES (m.nroasiento, devolucion.fechanota, "D", C_IVA_CREDIT, devolucion.iva_debito, "s/Nota de Credito No. " + ALLTRIM(STR(devolucion.nronota)) + " - " + ALLTRIM(devolucion.nombre), 3, "DEVOLUCION CONTADO - CLIENTE")
   ENDIF

   * Cuenta acreedora
   INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb);
      VALUES (m.nroasiento, devolucion.fechanota, "C", C_RECAUD_DEP, devolucion.monto_nota, "s/Nota de Credito No. " + ALLTRIM(STR(devolucion.nronota)) + " - " + ALLTRIM(devolucion.nombre), 3, "DEVOLUCION CONTADO - CLIENTE")

   m.nroasiento = m.nroasiento + 1
ENDSCAN

* Asientos: Cobros

WAIT "PROCESO 6/9 - CREANDO ASIENTOS DE COBROS" WINDOW NOWAIT

SELECT cobros
SCAN ALL
   * Cuentas deudoras
   SELECT form_cob
   LOCATE FOR tipodocu = cobros.tiporeci AND nrodocu = cobros.nroreci AND doc_id = 2
   
   IF FOUND() THEN
      SCAN FOR tipodocu = cobros.tiporeci AND nrodocu = cobros.nroreci AND doc_id = 2
         DO CASE
            CASE forma_id = 1   && 1. Caja Moneda Local
               INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb);
                  VALUES (m.nroasiento, cobros.fechareci, "D", C_RECAUD_DEP, ROUND(form_cob.importe * form_cob.cambio, 0), "s/Recibo de Cobro No. " + ALLTRIM(STR(cobros.nroreci)) + " - " + ALLTRIM(cobros.nombre), 2, "COBRO A CLIENTE")
            CASE forma_id = 2   && 2. Caja Moneda Extranjera US$
               INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
                  VALUES (m.nroasiento, cobros.fechareci, "D", C_CAJA_MMEE, ROUND(form_cob.importe * form_cob.cambio, 0), "s/Recibo de Cobro No. " + ALLTRIM(STR(cobros.nroreci)) + " - " + ALLTRIM(cobros.nombre), 2, "COBRO A CLIENTE")
            CASE forma_id = 3   && 3. Tarjeta de Credito
               INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
                  VALUES (m.nroasiento, cobros.fechareci, "D", C_TARJ_CREDI, ROUND(form_cob.importe * form_cob.cambio, 0), "s/Recibo de Cobro No. " + ALLTRIM(STR(cobros.nroreci)) + " - " + ALLTRIM(cobros.nombre), 2, "COBRO A CLIENTE")
            CASE forma_id = 4   && 4. Banco Regional S.A. Cta. Cte.
               INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
                  VALUES (m.nroasiento, cobros.fechareci, "D", C_REGIONAL_CC, ROUND(form_cob.importe * form_cob.cambio, 0), "s/Recibo de Cobro No. " + ALLTRIM(STR(cobros.nroreci)) + " - " + ALLTRIM(cobros.nombre), 2, "COBRO A CLIENTE")
            CASE forma_id = 5   && 5. Banco Nacional de Fomento Cta. Cte.
               INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
                  VALUES (m.nroasiento, cobros.fechareci, "D", C_BNF_CTA_CTE, ROUND(form_cob.importe * form_cob.cambio, 0), "s/Recibo de Cobro No. " + ALLTRIM(STR(cobros.nroreci)) + " - " + ALLTRIM(cobros.nombre), 2, "COBRO A CLIENTE")
            CASE forma_id = 6   && 6. Banco Regional S.A. Caja Ahorro US$
               INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
                  VALUES (m.nroasiento, cobros.fechareci, "D", C_C_AHOR_MMEE, ROUND(form_cob.importe * form_cob.cambio, 0), "s/Recibo de Cobro No. " + ALLTRIM(STR(cobros.nroreci)) + " - " + ALLTRIM(cobros.nombre), 2, "COBRO A CLIENTE")
         ENDCASE
      ENDSCAN
   ELSE
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb);
         VALUES (m.nroasiento, cobros.fechareci, "D", C_RECAUD_DEP, cobros.monto_cobr, "s/Recibo de Cobro No. " + ALLTRIM(STR(cobros.nroreci)) + " - " + ALLTRIM(cobros.nombre), 2, "COBRO A CLIENTE")
   ENDIF
   
   * Asienta la diferencia de cambio negativa
   SELECT cobros
   IF monto_fact > monto_cobr THEN
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb);
         VALUES (m.nroasiento, cobros.fechareci, "D", C_DIF_PERDIDA, cobros.monto_fact - cobros.monto_cobr, "s/Recibo de Cobro No. " + ALLTRIM(STR(cobros.nroreci)) + " - " + ALLTRIM(cobros.nombre), 2, "COBRO A CLIENTE")
   ENDIF

   * Cuenta acreedora
   SELECT cobros
   INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb) ;
      VALUES (m.nroasiento, cobros.fechareci, "C", cobros.cuenta, cobros.monto_fact, "s/Recibo de Cobro No. " + ALLTRIM(STR(cobros.nroreci)) + " - " + ALLTRIM(cobros.nombre), 2, "COBRO A CLIENTE")

   * Asienta la diferencia de cambio positiva
   SELECT cobros
   IF monto_cobr > monto_fact THEN
      INSERT INTO asientos (nroasiento, fecha, tipomovi, cuenta, monto, concepto, asnt_tipo, asnt_nomb);
         VALUES (m.nroasiento, cobros.fechareci, "C", C_DIF_GANANCI, cobros.monto_cobr - cobros.monto_fact, "s/Recibo de Cobro No. " + ALLTRIM(STR(cobros.nroreci)) + " - " + ALLTRIM(cobros.nombre), 2, "COBRO A CLIENTE")
   ENDIF

   m.nroasiento = m.nroasiento + 1
ENDSCAN

*---------------------------------------------------------------------------*
PROCEDURE resumir_asientos

WAIT "PROCESO 7/9 - RESUMIENDO ASIENTOS POR FECHA" WINDOW NOWAIT

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
   ccosto     N(3))

USE &archi5 ALIAS asientos2
INDEX ON nroasiento TAG nroasiento

archi6 = "tm" + RIGHT(SYS(3), 6)

SELECT 0
CREATE TABLE &archi6 (fecha D(8))

USE &archi6 ALIAS fechas

* Obtiene una lista de las fechas que tienen movimientos
SELECT asientos
SET ORDER TO 1
SCAN ALL
   SELECT fechas
   LOCATE FOR fecha = asientos.fecha
   IF !FOUND() THEN
      INSERT INTO fechas (fecha) VALUES (asientos.fecha)
   ENDIF
ENDSCAN

* Resume los asientos por fecha
m.nroasiento = 1

SELECT fechas
SCAN ALL
   SELECT asientos
   SET ORDER TO 1

   SCAN FOR fecha = fechas.fecha
      SELECT asientos2
      LOCATE FOR cuenta = asientos.cuenta AND fecha = fechas.fecha
      IF FOUND() THEN
         IF asientos.tipomovi = asientos2.tipomovi THEN
            REPLACE monto WITH monto + asientos.monto
         ELSE
            REPLACE monto with monto - asientos.monto
         ENDIF
      ELSE
         INSERT INTO asientos2 (nroasiento, fecha, tipomovi, cuenta, monto, concepto, cerrado, marca_cash, empresa, libro_iva, nro_op_iva, ccosto);
            VALUES (m.nroasiento, asientos.fecha, asientos.tipomovi, asientos.cuenta, asientos.monto, "Resumen de Ingresos {" + DTOC(asientos.fecha) + "}", .F., "", 0, "", 0, 0)
      ENDIF
   ENDSCAN

   m.nroasiento = m.nroasiento + 1
ENDSCAN

* Formatea los asientos

WAIT "PROCESO 8/9 - FORMATEANDO ASIENTOS" WINDOW NOWAIT

* Cuentas deudoras
SELECT * FROM asientos2 WHERE tipomovi = "D" AND cuenta = C_RECAUD_DEP  INTO TABLE debi_01
SELECT * FROM asientos2 WHERE tipomovi = "D" AND cuenta = C_CAJA_MMEE   INTO TABLE debi_02
SELECT * FROM asientos2 WHERE tipomovi = "D" AND cuenta = C_C_AHOR_MMEE INTO TABLE debi_03
SELECT * FROM asientos2 WHERE tipomovi = "D" AND cuenta = C_REGIONAL_CC INTO TABLE debi_04
SELECT * FROM asientos2 WHERE tipomovi = "D" AND cuenta = C_BNF_CTA_CTE INTO TABLE debi_05
SELECT * FROM asientos2 WHERE tipomovi = "D" AND cuenta = C_TARJ_CREDI  INTO TABLE debi_06
SELECT * FROM asientos2 WHERE tipomovi = "D" AND cuenta = C_DEVOL_MERC  INTO TABLE debi_07
SELECT * FROM asientos2 WHERE tipomovi = "D" AND cuenta = C_DEVOL_SERV  INTO TABLE debi_08
SELECT * FROM asientos2 WHERE tipomovi = "D" AND cuenta = C_IVA_CREDIT  INTO TABLE debi_09
SELECT * FROM asientos2 WHERE tipomovi = "D" AND !INLIST(cuenta, C_RECAUD_DEP, C_CAJA_MMEE, C_C_AHOR_MMEE, C_REGIONAL_CC, C_BNF_CTA_CTE, C_TARJ_CREDI, C_DEVOL_MERC, C_DEVOL_SERV, C_IVA_CREDIT) INTO TABLE debi_10

* Cuentas acreedoras
SELECT * FROM asientos2 WHERE tipomovi = "C" AND cuenta = C_VENTA_MERC INTO TABLE cred_01
SELECT * FROM asientos2 WHERE tipomovi = "C" AND cuenta = C_VENTA_SERV INTO TABLE cred_02
SELECT * FROM asientos2 WHERE tipomovi = "C" AND cuenta = C_IVA_DEBITO INTO TABLE cred_03
SELECT * FROM asientos2 WHERE tipomovi = "C" AND !INLIST(cuenta, C_VENTA_MERC, C_VENTA_SERV, C_IVA_DEBITO) INTO TABLE cred_04

SELECT asientos2 
ZAP

APPEND FROM debi_01
APPEND FROM debi_02
APPEND FROM debi_03
APPEND FROM debi_04
APPEND FROM debi_05
APPEND FROM debi_06
APPEND FROM debi_07
APPEND FROM debi_08
APPEND FROM debi_09
APPEND FROM debi_10

APPEND FROM cred_01
APPEND FROM cred_02
APPEND FROM cred_03
APPEND FROM cred_04

REPLACE cuenta WITH C_VENTA_MERC FOR cuenta = C_DEVOL_MERC
REPLACE cuenta WITH C_VENTA_SERV FOR cuenta = C_DEVOL_SERV

*---------------------------------------------------------------------------*
PROCEDURE crear_movim

WAIT "PROCESO 9/9 - FINALIZANDO PROCESO" WINDOW NOWAIT

SELECT 0
CREATE TABLE contado (;
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

USE contado ALIAS contado	

SELECT asientos2
SET ORDER TO 1
SCAN ALL
   INSERT INTO contado (nroasiento, fecha, tipomovi, cuenta, monto, concepto, cerrado, marca_cash, empresa, libro_iva, nro_op_iva, ccosto);
      VALUES (asientos2.nroasiento, asientos2.fecha, asientos2.tipomovi, asientos2.cuenta, asientos2.monto, asientos2.concepto, asientos2.cerrado, asientos2.marca_cash, asientos2.empresa, asientos2.libro_iva, asientos2.nro_op_iva, asientos2.ccosto)
ENDSCAN

WAIT CLEAR

* Browse para ver el diario

RETURN

WAIT "{CONTADO.DBF}" WINDOW NOWAIT

USE cuentas IN 0 SHARED ORDER 1

SELECT contado
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