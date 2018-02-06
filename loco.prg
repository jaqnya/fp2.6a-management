CLEAR ALL

SET CENTURY on
SET DATE british
SET DELETED ON
SET EXCLUSIVE OFF

USE maesprod IN 0
USE detapedc IN 0

SELECT detapedc
SCAN FOR NROPEDIDO = 1030000613
   m.codigo = articulo
   SELECT maesprod 
   SET ORDER TO 1
   IF SEEK(m.codigo) THEN
      SELECT DETAPEDC
      REPLACE precio WITH ROUND(maesprod.pventag3 * 1.1, 0)
      replace lista WITH 3
   ELSE
      MESSAGEBOX("no encontre"
   ENDIF
ENDscan