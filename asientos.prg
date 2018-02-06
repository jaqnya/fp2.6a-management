PARAMETERS m.fecha1, m.fecha2
*/
**
*
* ASIENTOS.PRG - MS FoxPro 2.6a for DOS
*
* Copyright (c) 1999-2007, TurtleCorp.
* Todos los derechos reservados.
*
* Descripcion: Crear asientos de cierre de caja y operaciones de credito
*
*    Autor: Jose Avilio Acu¤a Acosta
* Creacion: 22/04/2007
* Revision: 22/04/2007
*
**
*/

* Programa Principal
DO seteos

m.fecha1 = CTOD(m.fecha1)
m.fecha2 = CTOD(m.fecha2)
                    
DO contabil WITH m.fecha1, m.fecha2
DO contabi3 WITH m.fecha1, m.fecha2
DO contabi2 WITH m.fecha1, m.fecha2
DO fusion
CLOSE ALL

*---------------------------------------------------------------------------*
PROCEDURE seteos

SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON
SET ESCAPE  OFF
SET SAFETY  OFF
SET TALK    OFF

CLEAR
*CLEAR ALL
CLOSE ALL

*---------------------------------------------------------------------------*
PROCEDURE fusion

USE contado IN 0 
USE credito IN 0
USE depo    IN 0

SELECT 0
CREATE TABLE movim (;
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

USE movim ALIAS movim

APPEND FROM contado
APPEND FROM depo
APPEND FROM credito


* Browse para ver el diario
WAIT "{CONSOLIDADO}" WINDOW NOWAIT

USE cuentas IN 0 SHARED ORDER 1

SELECT movim
SET RELATION TO cuenta INTO cuentas

BROWSE FIELDS ;
   b1 = nroasiento :H = "Asiento",;
   b2 = fecha :H = "Fecha",;
   b3 = cuentas.nombre :30:H = "Descripci¢n",;
   b4 = IIF(tipomovi = "D", TRANSFORM(monto, "999,999,999"), SPACE(11)) :H = "Debe",;
   b5 = IIF(tipomovi = "C", TRANSFORM(monto, "999,999,999"), SPACE(11)) :H = "Haber",;
   b6 = concepto :H = "Concepto",;
   b7 = cuenta :H = "Cuenta" ;
   NOAPPEND NOMODIFY NODELETE


*-- Proceso de borrado de archivos temporales --*
CLOSE ALL

DELETE FILE debi_01.dbf
DELETE FILE debi_02.dbf
DELETE FILE debi_03.dbf
DELETE FILE debi_04.dbf
DELETE FILE debi_05.dbf
DELETE FILE debi_06.dbf
DELETE FILE debi_07.dbf
DELETE FILE debi_08.dbf
DELETE FILE debi_09.dbf
DELETE FILE debi_10.dbf

DELETE FILE cred_01.dbf
DELETE FILE cred_02.dbf
DELETE FILE cred_03.dbf
DELETE FILE cred_04.dbf

DELETE FILE contado.dbf
DELETE FILE credito.dbf
DELETE FILE depo.dbf