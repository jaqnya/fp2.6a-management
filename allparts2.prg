CLEAR ALL
CLEAR

SET DELETED ON
SET CENTURY ON
SET DATE BRITISH
SET EXACT ON

USE vta_allparts IN 0
USE tmp_prod IN 0
USE maesprod IN 0 SHARED

SELECT vta_allparts
SCAN ALL
   SELECT maesprod
   SET ORDER TO 1
   IF SEEK(vta_allparts.articulo) THEN
      SCATTER MEMVAR memo
      INSERT INTO tmp_prod FROM MEMVAR
   ELSE
      WAIT "Articulo no encontrado." window
   ENDIF
ENDSCAN


SELECT TMP_prod
browse