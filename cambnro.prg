PARAMETER m.tipodocu, m.nroactual, m.nronuevo

SET DELETED ON
SET CENTURY ON
SET DATE    BRITISH
SET EXCLUSIVE OFF
CLEAR

IF !USED("cabevent") THEN
   USE cabevent IN 0
ENDIF

IF !USED("detavent") THEN
   USE detavent IN 0
ENDIF

IF !USED("cuotas_v") THEN
   USE cuotas_v IN 0
ENDIF

IF !USED("cabeven2") THEN
   USE cabeven2 IN 0
ENDIF

IF !USED("cabepedc") THEN
   USE cabepedc IN 0
ENDIF

IF !USED("detapedc") THEN
   USE detapedc IN 0
ENDIF

IF !USED("cabeped2") THEN
   USE cabeped2 IN 0
ENDIF

IF !USED("pedifact") THEN
   USE pedifact IN 0
ENDIF

SELECT cabevent
REPLACE nrodocu WITH m.nronuevo FOR tipodocu = m.tipodocu AND nrodocu = m.nroactual

*SET ORDER TO 1
*IF SEEK(STR(m.tipodocu, 1) + STR(m.nroactual, 7)) THEN
*   REPLACE nrodocu WITH m.nronuevo
*ENDIF

SELECT detavent
REPLACE nrodocu WITH m.nronuevo FOR tipodocu = m.tipodocu AND nrodocu = m.nroactual

*SET ORDER TO 1
*IF SEEK(STR(m.tipodocu, 1) + STR(m.nroactual, 7)) THEN
*   SCAN WHILE tipodocu = m.tipodocu AND nrodocu = m.nroactual
*      REPLACE nrodocu WITH m.nronuevo
*   ENDSCAN
*ENDIF

SELECT cuotas_v
REPLACE nrodocu WITH m.nronuevo FOR tipodocu = m.tipodocu AND nrodocu = m.nroactual

*SET ORDER TO 1
*IF SEEK(STR(m.tipodocu, 1) + STR(m.nroactual, 7)) THEN
*   SCAN WHILE tipodocu = m.tipodocu AND nrodocu = m.nroactual
*      REPLACE nrodocu WITH m.nronuevo
*   ENDSCAN
*ENDIF

SELECT pedifact
REPLACE nrodocu WITH m.nronuevo FOR tipodocu = m.tipodocu AND nrodocu = m.nroactual

SELECT cabeven2
REPLACE nrodocu WITH m.nronuevo FOR tipodocu = m.tipodocu AND nrodocu = m.nroactual