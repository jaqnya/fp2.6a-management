PARAMETER m.fecha, m.print
 
* Seteos
SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON

CLOSE ALL
CLOSE DATABASES

* Databases
SELECT 0
USE proveedo SHARED

SELECT 0
USE cabecomp SHARED

SELECT 0
USE cabenotp SHARED

SELECT 0
USE cabepag SHARED

DELETE FILE saldopro.dbf

CREATE TABLE saldopro (codigo N(5), nombre C(100), saldo_gs N(12), saldo_usd N(12,2))
USE saldopro EXCLUSIVE

* Main Program

*// Procesa la tabla de ventas
SELECT cabecomp
SCAN FOR fechadocu <= m.fecha AND INLIST(tipodocu, 2, 8)
   SELECT saldopro
   LOCATE FOR codigo = cabecomp.proveedor
   IF !FOUND() THEN
      SELECT proveedo
      LOCATE FOR codigo = cabecomp.proveedor
      IF FOUND() THEN
         SELECT saldopro
         APPEND BLANK
         REPLACE codigo WITH proveedo.codigo
         REPLACE nombre WITH proveedo.nombre
      ENDIF
   ENDIF
      
   SELECT saldopro
   IF cabecomp.moneda = 1 THEN
      REPLACE saldo_gs  WITH saldo_gs  + cabecomp.monto_fact
   ELSE
      REPLACE saldo_usd WITH saldo_usd + cabecomp.monto_fact
   ENDIF
ENDSCAN

*// Procesa la tabla de notas de credito
SELECT cabenotp
SCAN FOR fechanota <= m.fecha AND INLIST(tipodocu, 2, 8) AND aplicontra = 2
   SELECT saldopro
   LOCATE FOR codigo = cabenotp.proveedor
   IF !FOUND() THEN
      SELECT proveedo
      LOCATE FOR codigo = cabenotp.proveedor
      IF FOUND() THEN
         SELECT saldopro
         APPEND BLANK
         REPLACE codigo WITH proveedo.codigo
         REPLACE nombre WITH proveedo.nombre
      ENDIF
   ENDIF
      
   SELECT cabecomp
   LOCATE FOR tipodocu = cabenotp.tipodocu AND nrodocu = cabenotp.nrodocu AND proveedor = cabenotp.proveedor
   
   SELECT saldopro
   IF cabecomp.moneda = 1 THEN
      REPLACE saldo_gs  WITH saldo_gs  - cabenotp.monto_nota
   ELSE
      REPLACE saldo_usd WITH saldo_usd - cabenotp.monto_nota
   ENDIF
ENDSCAN

*// Procesa la tabla cobros a proveedo
SELECT cabepag
SCAN FOR fechareci <= m.fecha AND tiporeci = 1
   SELECT saldopro
   LOCATE FOR codigo = cabepag.proveedor
   IF !FOUND() THEN
      SELECT proveedo
      LOCATE FOR codigo = cabepag.proveedor
      IF FOUND() THEN
         SELECT saldopro
         APPEND BLANK
         REPLACE codigo WITH proveedo.codigo
         REPLACE nombre WITH proveedo.nombre
      ENDIF
   ENDIF
      
   SELECT saldopro
   IF cabepag.moneda = 1 THEN
      REPLACE saldo_gs  WITH saldo_gs  - cabepag.monto_pago
   ELSE
      REPLACE saldo_usd WITH saldo_usd - cabepag.monto_pago
   ENDIF
ENDSCAN

SELECT saldopro
INDEX ON nombre TAG nombre
DELETE FOR saldo_gs = 0 AND saldo_usd = 0
PACK
BROWSE

REPORT FORM saldopro PREVIEW

IF m.print THEN
   REPORT FORM saldopro TO PRINTER NOCONSOLE
ENDIF

EXPORT TO saldopro TYPE XLS
