CLEAR ALL
CLEAR

SET CENTURY on
SET DATE BRITISH
SET DELETED ON
SET EXACT ON


USE E:\tmp_costo IN 0
USE e:\maesprod IN 0

i = 0
SELECT tmp_costo
SCAN ALL
   SELECT maesprod
   SET ORDER TO 1
   IF SEEK(TMP_COSTO.articulo) THEN
      i = i + 1
      REPLACE pcostog WITH TMP_COSTO.PRECIO
      REPLACE pcostod WITH ROUND(TMP_COSTO.PRECIO/5000, 3)
   ELSE
      WAIT "No encontrado" window
      ? tmp_costo.articulo
   ENDIF
ENDSCAN

? i