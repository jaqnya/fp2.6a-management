CLEAR ALL
CLEAR

SET DELETED ON
SET DATE    BRITISH
SET CENTURY ON
SET SAFETY  OFF

USE deposito SHARED

m.fecha1 = CTOD("01/04/2012")
m.fecha2 = CTOD("30/04/2012")

*!*	m.fecha1 = CTOD("01/01/2010")
*!*	m.fecha2 = CTOD("15/01/2010")   && Banco Regional S.A.


SELECT nro_cuenta, IIF(nro_cuenta = 1, "Banco Regional S.A. Cta. Cte.", IIF(nro_cuenta = 2, "Banco Nacional de Fomento Cta. Cte.", IIF(nro_cuenta = 3, "Banco Regional S.A. Caja Ahorro M/E", IIF(nro_cuenta = 4, "Banco Regional S.A. Cta. Cte. M/E", "")))) descripcion, SUM(efectivo + cheque + cheque2) suma_deposito FROM deposito WHERE BETWEEN(fecha, m.fecha1, m.fecha2) GROUP BY nro_cuenta
SELECT nro_cuenta, IIF(nro_cuenta = 1, "Banco Regional S.A. Cta. Cte.", IIF(nro_cuenta = 2, "Banco Nacional de Fomento Cta. Cte.", IIF(nro_cuenta = 3, "Banco Regional S.A. Caja Ahorro M/E", IIF(nro_cuenta = 4, "Banco Regional S.A. Cta. Cte. M/E", "")))) descripcion, (efectivo + cheque + cheque2) suma_deposito, deposito, fecha FROM deposito WHERE BETWEEN(fecha, m.fecha1, m.fecha2) AND nro_cuenta = 1 ORDER BY 5,4
EXPORT TO c:\regional TYPE xl5
SELECT nro_cuenta, IIF(nro_cuenta = 1, "Banco Regional S.A. Cta. Cte.", IIF(nro_cuenta = 2, "Banco Nacional de Fomento Cta. Cte.", IIF(nro_cuenta = 3, "Banco Regional S.A. Caja Ahorro M/E", IIF(nro_cuenta = 4, "Banco Regional S.A. Cta. Cte. M/E", "")))) descripcion, (efectivo + cheque + cheque2) suma_deposito, deposito, fecha FROM deposito WHERE BETWEEN(fecha, m.fecha1, m.fecha2) AND nro_cuenta = 4 ORDER BY 5,4
SELECT nro_cuenta, IIF(nro_cuenta = 1, "Banco Regional S.A. Cta. Cte.", IIF(nro_cuenta = 2, "Banco Nacional de Fomento Cta. Cte.", IIF(nro_cuenta = 3, "Banco Regional S.A. Caja Ahorro M/E", IIF(nro_cuenta = 4, "Banco Regional S.A. Cta. Cte. M/E", "")))) descripcion, (efectivo + cheque + cheque2) suma_deposito, deposito, fecha FROM deposito WHERE BETWEEN(fecha, m.fecha1, m.fecha2) AND nro_cuenta = 2 ORDER BY 5,4
EXPORT TO c:\bnf TYPE xl5
SELECT nro_cuenta, IIF(nro_cuenta = 1, "Banco Regional S.A. Cta. Cte.", IIF(nro_cuenta = 2, "Banco Nacional de Fomento Cta. Cte.", IIF(nro_cuenta = 3, "Banco Regional S.A. Caja Ahorro M/E", IIF(nro_cuenta = 4, "Banco Regional S.A. Cta. Cte. M/E", "")))) descripcion, (efectivo + cheque + cheque2) suma_deposito, deposito, fecha FROM deposito WHERE BETWEEN(fecha, m.fecha1, m.fecha2) AND nro_cuenta = 3 ORDER BY 5,4
EXPORT TO c:\vision TYPE xl5