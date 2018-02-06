CLEAR
CLEAR ALL

SET EXACT OFF
SET DELETED ON

USE maesprod IN 0 SHARED
USE nombrar IN 0

SELECT nombrar
REPLACE nombre WITH "" ALL

*!*	SELECT nombrar
*!*	SCAN ALL
*!*	   m.articulo = VAL(ALLTRIM(codigo))

*!*	   SELECT maesprod
*!*	   SET ORDER TO indice8
*!*	   IF SEEK(m.articulo) THEN
*!*	      SELECT nombrar
*!*	      REPLACE codigo   WITH maesprod.codigo,;
*!*	              articulo WITH IIF(!EMPTY(maesprod.codigo2), maesprod.codigo2, maesprod.codorig),;
*!*	              nombre   WITH maesprod.nombre,;
*!*	              familia  WITH maesprod.familia,;
*!*	              pventag1 WITH ROUND(maesprod.pventag1 * (1 + maesprod.pimpuesto / 100), 0),;
*!*	              pventag2 WITH ROUND(maesprod.pventag2 * (1 + maesprod.pimpuesto / 100), 0),;
*!*	              pventag3 WITH ROUND(maesprod.pventag3 * (1 + maesprod.pimpuesto / 100), 0),;
*!*	              pventag4 WITH ROUND(maesprod.pventag4 * (1 + maesprod.pimpuesto / 100), 0),;
*!*	              pventag5 WITH ROUND(maesprod.pventag5 * (1 + maesprod.pimpuesto / 100), 0),;
*!*	              pventad1 WITH maesprod.pventad1,;
*!*	              pventad2 WITH maesprod.pventad2,;
*!*	              pventad3 WITH maesprod.pventad3,;
*!*	              pventad4 WITH maesprod.pventad4,;
*!*	              pventad5 WITH maesprod.pventad5
*!*	   ENDIF
*!*	ENDSCAN

SELECT nombrar
SCAN ALL
   m.articulo = ALLTRIM(articulo)

   SELECT maesprod
   SET ORDER TO indice6
   IF SEEK(m.articulo) THEN
      SELECT nombrar
      REPLACE codigo   WITH maesprod.codigo,;
              nombre   WITH maesprod.nombre,;
              familia  WITH maesprod.familia,;
              pventag1 WITH ROUND(maesprod.pventag1 * (1 + maesprod.pimpuesto / 100), 0),;
              pventag2 WITH ROUND(maesprod.pventag2 * (1 + maesprod.pimpuesto / 100), 0),;
              pventag3 WITH ROUND(maesprod.pventag3 * (1 + maesprod.pimpuesto / 100), 0),;
              pventag4 WITH ROUND(maesprod.pventag4 * (1 + maesprod.pimpuesto / 100), 0),;
              pventag5 WITH ROUND(maesprod.pventag5 * (1 + maesprod.pimpuesto / 100), 0),;
              pventad1 WITH ROUND(maesprod.pventad1 * (1 + maesprod.pimpuesto / 100), 2),;
              pventad2 WITH ROUND(maesprod.pventad2 * (1 + maesprod.pimpuesto / 100), 2),;
              pventad3 WITH ROUND(maesprod.pventad3 * (1 + maesprod.pimpuesto / 100), 2),;
              pventad4 WITH maesprod.pventad4,;
              pventad5 WITH ROUND(maesprod.pventad5 * (1 + maesprod.pimpuesto / 100), 2)
   ENDIF
ENDSCAN

SELECT nombrar
SCAN FOR EMPTY(nombre)
   m.articulo = ALLTRIM(articulo)

   SELECT maesprod
   SET ORDER TO indice7
   IF SEEK(m.articulo) THEN
      SELECT nombrar
      REPLACE codigo   WITH maesprod.codigo,;
              nombre   WITH maesprod.nombre,;
              familia  WITH maesprod.familia,;
              pventag1 WITH ROUND(maesprod.pventag1 * (1 + maesprod.pimpuesto / 100), 0),;
              pventag2 WITH ROUND(maesprod.pventag2 * (1 + maesprod.pimpuesto / 100), 0),;
              pventag3 WITH ROUND(maesprod.pventag3 * (1 + maesprod.pimpuesto / 100), 0),;
              pventag4 WITH ROUND(maesprod.pventag4 * (1 + maesprod.pimpuesto / 100), 0),;
              pventag5 WITH ROUND(maesprod.pventag5 * (1 + maesprod.pimpuesto / 100), 0),;
              pventad1 WITH ROUND(maesprod.pventad1 * (1 + maesprod.pimpuesto / 100), 2),;
              pventad2 WITH ROUND(maesprod.pventad2 * (1 + maesprod.pimpuesto / 100), 2),;
              pventad3 WITH ROUND(maesprod.pventad3 * (1 + maesprod.pimpuesto / 100), 2),;
              pventad4 WITH maesprod.pventad4,;
              pventad5 WITH ROUND(maesprod.pventad5 * (1 + maesprod.pimpuesto / 100), 2)
   ENDIF
ENDSCAN