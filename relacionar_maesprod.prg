CLEAR
CLEAR ALL

SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON
SET EXACT   ON

USE vta_allparts IN 0
USE maesprod IN 0 SHARED

SELECT vta_allparts
SCAN ALL
   SELECT maesprod
   SET ORDER TO 1
   IF SEEK(vta_allparts.articulo) THEN
      SELECT vta_allparts
      REPLACE familia WITH maesprod.familia
      REPLACE rubro   WITH maesprod.rubro
      REPLACE subrubro WITH maesprod.subrubro
      REPLACE marca WITH maesprod.marca
      REPLACE unidad WITH maesprod.unidad
      REPLACE procedenci WITH maesprod.procedenci
   ELSE
      WAIT "Producto no encontrado." WINDOW
   ENDIF
ENDSCAN

SELECT vta_allparts
browse