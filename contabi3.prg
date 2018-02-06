PARAMETERS m.fecha1, m.fecha2

*/
**
*
* CONTABI3.PRG - MS FoxPro 2.6a for DOS
*
* Copyright (c) 1999-2007, Turtle Software Paraguay.
* Todos los derechos reservados.
*
* Descripcion: Crear asientos de deposito.
*
*    Autor: Jose Avilio Acu¤a Acosta
* Creacion: 26/04/2007
* Revision: 26/04/2007
*
**
*/

* Declaracion e inicializacion de constantes y variables de memoria
#DEFINE C_REGIONAL_CC "1-01-01-02-01-0001"
#DEFINE C_C_AHOR_MMEE "1-01-01-02-02-0001"
#DEFINE C_BNF_CTA_CTE "1-01-01-02-01-0002"
#DEFINE C_RECAUD_DEP  "1-01-01-01-02-0000"
#DEFINE C_REG_CC_MMEE "1-01-01-02-01-0003"
#DEFINE C_RECAUD_USD  "1-01-01-01-04-0000"

* Programa Principal
DO seteos
DO abrir_tablas
DO depositos
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

USE deposito IN 0 SHARED
USE contado  IN 0 SHARED

*---------------------------------------------------------------------------*
PROCEDURE cerrar_tablas
CLOSE ALL

*---------------------------------------------------------------------------*
PROCEDURE depositos

SELECT 0
CREATE TABLE depo (;
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

WAIT "PROCESO 1/1 - ARCHIVO: DEPOSITOS" WINDOW NOWAIT

SELECT contado
CALCULATE MAX(nroasiento) TO m.nroasiento
m.nroasiento = m.nroasiento + 1

SELECT;
   fecha,;
   nro_cuenta,;
   SUM(efectivo + cheque + cheque2) AS importe;
FROM;
   deposito;
WHERE;
   BETWEEN(fecha, m.fecha1, m.fecha2);
GROUP BY;
   fecha, nro_cuenta;
INTO CURSOR;
   tm_deposit

SELECT tm_deposit
SCAN FOR BETWEEN(fecha, m.fecha1, m.fecha2)
   m.fecha = fecha
   m.nro_cuenta = nro_cuenta
   m.concepto = "Deposito N§ "

   SELECT;
      deposito,;
      (efectivo + cheque + cheque2) AS importe;
   FROM;
      deposito;
   WHERE;
      fecha = m.fecha AND;
      nro_cuenta = m.nro_cuenta;
   ORDER BY;
      1;
   INTO CURSOR;
      tm_depo

   SELECT tm_depo
   SCAN ALL
      m.concepto = m.concepto + ALLTRIM(STR(deposito)) + ", "
   ENDSCAN

   m.concepto = LEFT(ALLTRIM(m.concepto), LEN(ALLTRIM(m.concepto)) - 1)
     
   INSERT INTO depo (nroasiento, fecha, tipomovi, cuenta, monto, concepto, cerrado, marca_cash, empresa, libro_iva, nro_op_iva, ccosto);
      VALUES (m.nroasiento, tm_deposit.fecha, "D", IIF(tm_deposit.nro_cuenta = 1, C_REGIONAL_CC, IIF(tm_deposit.nro_cuenta = 2, C_BNF_CTA_CTE, IIF(tm_deposit.nro_cuenta = 3, C_C_AHOR_MMEE, IIF(tm_deposit.nro_cuenta = 4, C_REG_CC_MMEE, "")))), tm_deposit.importe, m.concepto, .F., "", 0, "", 0, 0)

   INSERT INTO depo (nroasiento, fecha, tipomovi, cuenta, monto, concepto, cerrado, marca_cash, empresa, libro_iva, nro_op_iva, ccosto);
      VALUES (m.nroasiento, tm_deposit.fecha, "C", IIF(INLIST(tm_deposit.nro_cuenta, 1, 2), C_RECAUD_DEP, IIF(INLIST(tm_deposit.nro_cuenta, 3, 4), C_RECAUD_USD, "")), tm_deposit.importe, m.concepto, .F., "", 0, "", 0, 0)

   m.nroasiento = m.nroasiento + 1
ENDSCAN