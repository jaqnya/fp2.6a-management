CLEAR ALL
CLEAR

SET DELETED ON
SET EXACT ON
SET CENTURY ON
SET DATE BRITISH


USE z:\turtle\aya\integrad.000\maesprod IN 0 SHARED
USE c:\data IN 0 ALIAS datos EXCLUSIVE

lnCnt = 0

SELECT datos
SCAN ALL
   m.codigo = code
   m.ubicacion = location

   SELECT maesprod
   SET ORDER TO 1
   IF SEEK(m.codigo) THEN
*!*	      REPLACE ubicacion WITH ALLTRIM(ubicacion) + IIF(!EMPTY(ubicacion), "/", "") + m.ubicacion
      IF !EMPTY(ubicacion) THEN
         ? m.codigo + "   producto.ubicacion: " + ALLTRIM(maesprod.ubicacion) + "  nuevo.ubicacion: " + ALLTRIM(m.ubicacion)
*!*	         ? ALLTRIM(ubicacion) + IIF(!EMPTY(ubicacion), "/", "") + m.ubicacion
      ENDIF
   ELSE
      WAIT WINDOW m.codigo + " no existe."
   ENDIF
   lnCnt = lnCnt + 1
ENDSCAN

? "Registros Procesados: " + ALLTRIM(STR(lnCnt))