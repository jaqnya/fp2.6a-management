CLEAR ALL
CLEAR

SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON
SET EXACT   ON
SET SAFETY  ON

USE cabepedc IN 0 SHARED
USE cabeped2 IN 0 SHARED
USE detapedc IN 0 SHARED
USE pedifact IN 0 SHARED

SELECT nropedido, fecha FROM cabepedc WHERE !facturado AND fecha < DATE() INTO CURSOR tm_cabepedc

lnCnt = 1
SCAN ALL
   WAIT "Eliminando... " + ALLTRIM(TRANSFORM(lnCnt, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT

   m.nropedido = nropedido

   SELECT cabepedc
   DELETE FOR nropedido = m.nropedido

   SELECT cabeped2
   DELETE FOR nropedido = m.nropedido

   SELECT detapedc
   DELETE FOR nropedido = m.nropedido

   SELECT pedifact
   DELETE FOR nropedido = m.nropedido

   lnCnt = lnCnt + 1
ENDSCAN

*
* Elimina registros huérfanos de la tabla 'detapedc'
*
lnCnt = 1

SELECT detapedc
SET ORDER TO 1
SCAN ALL
   WAIT "Procesando [DETAPEDC]... " + ALLTRIM(TRANSFORM(lnCnt, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT

   SELECT cabepedc
   SET ORDER TO 1
   IF !SEEK(detapedc.nropedido) THEN
      ? "El pedido # " + ALLTRIM(STR(detapedc.nropedido)) + " no existe."
      SELECT detapedc
      DELETE
   ENDIF

   lnCnt = lnCnt + 1
ENDSCAN

*
* Elimina registros huérfanos de la tabla 'cabeped2'
*
lnCnt = 1

SELECT cabeped2
SET ORDER TO 1
SCAN ALL
   WAIT "Procesando [CABEPED2]... " + ALLTRIM(TRANSFORM(lnCnt, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT

   SELECT cabepedc
   SET ORDER TO 1
   IF !SEEK(cabeped2.nropedido) THEN
      ? "El pedido # " + ALLTRIM(STR(cabeped2.nropedido)) + " no existe."
      SELECT cabeped2
      DELETE
   ENDIF

   lnCnt = lnCnt + 1
ENDSCAN

*
* Elimina registros huérfanos de la tabla 'pedifact'
*
lnCnt = 1

SELECT pedifact
SET ORDER TO 1
SCAN ALL
   WAIT "Procesando [PEDIFACT]... " + ALLTRIM(TRANSFORM(lnCnt, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT

   SELECT cabepedc
   SET ORDER TO 1
   IF !SEEK(pedifact.nropedido) THEN
      ? "El pedido # " + ALLTRIM(STR(pedifact.nropedido)) + " no existe."
      SELECT pedifact
      DELETE
   ENDIF

   lnCnt = lnCnt + 1
ENDSCAN