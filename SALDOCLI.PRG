PARAMETER m.fecha, m.print
 
* Seteos
SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON

CLOSE ALL
CLOSE DATABASES

* Databases
SELECT 0
USE clientes SHARED

SELECT 0
USE cabevent SHARED

SELECT 0
USE cabenotc SHARED

SELECT 0
USE cabecob SHARED

DELETE FILE saldocli.dbf

CREATE TABLE saldocli (codigo N(5), nombre C(100), saldo_gs N(12), saldo_usd N(12,2))
USE saldocli EXCLUSIVE

* Main Program

*// Procesa la tabla de ventas
SELECT cabevent
SCAN FOR fechadocu <= m.fecha AND !anulado AND INLIST(tipodocu, 2, 8)
   SELECT saldocli
   LOCATE FOR codigo = cabevent.cliente
   IF !FOUND() THEN
      SELECT clientes
      LOCATE FOR codigo = cabevent.cliente
      IF FOUND() THEN
         SELECT saldocli
         APPEND BLANK
         REPLACE codigo WITH clientes.codigo
         REPLACE nombre WITH clientes.nombre
      ENDIF
   ENDIF
      
   SELECT saldocli
   IF cabevent.moneda = 1 THEN
      REPLACE saldo_gs  WITH saldo_gs  + cabevent.monto_fact
   ELSE
      REPLACE saldo_usd WITH saldo_usd + cabevent.monto_fact
   ENDIF
ENDSCAN

*// Procesa la tabla de notas de credito
SELECT cabenotc
SCAN FOR fechanota <= m.fecha AND !anulado AND INLIST(tipodocu, 2, 8) AND aplicontra = 2
   SELECT saldocli
   LOCATE FOR codigo = cabenotc.cliente
   IF !FOUND() THEN
      SELECT clientes
      LOCATE FOR codigo = cabenotc.cliente
      IF FOUND() THEN
         SELECT saldocli
         APPEND BLANK
         REPLACE codigo WITH clientes.codigo
         REPLACE nombre WITH clientes.nombre
      ENDIF
   ENDIF
      
   SELECT cabevent
   LOCATE FOR tipodocu = cabenotc.tipodocu AND nrodocu = cabenotc.nrodocu
   
   SELECT saldocli
   IF cabevent.moneda = 1 THEN
      REPLACE saldo_gs  WITH saldo_gs  - cabenotc.monto_nota
   ELSE
      REPLACE saldo_usd WITH saldo_usd - cabenotc.monto_nota
   ENDIF
ENDSCAN

*// Procesa la tabla cobros a clientes
SELECT cabecob
SCAN FOR fechareci <= m.fecha AND !anulado AND tiporeci = 1
   SELECT saldocli
   LOCATE FOR codigo = cabecob.cliente
   IF !FOUND() THEN
      SELECT clientes
      LOCATE FOR codigo = cabecob.cliente
      IF FOUND() THEN
         SELECT saldocli
         APPEND BLANK
         REPLACE codigo WITH clientes.codigo
         REPLACE nombre WITH clientes.nombre
      ENDIF
   ENDIF
      
   SELECT saldocli
   IF cabecob.moneda = 1 THEN
      REPLACE saldo_gs  WITH saldo_gs  - cabecob.monto_cobr
   ELSE
      REPLACE saldo_usd WITH saldo_usd - cabecob.monto_cobr
   ENDIF
ENDSCAN

SELECT saldocli
INDEX ON nombre TAG nombre
DELETE FOR saldo_gs = 0 AND saldo_usd = 0
PACK
BROWSE

REPORT FORM saldocli PREVIEW

IF m.print THEN
   REPORT FORM saldocli TO PRINTER NOCONSOLE
ENDIF

EXPORT TO saldocli TYPE XLS