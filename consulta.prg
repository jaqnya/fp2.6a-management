CLEAR ALL
CLEAR

SET DELETED ON
SET CENTURY ON
SET DATE BRITISH
SET EXACT ON

USE maesprod IN 0 SHARED

SELECT;
   codigo,;
   codigo2,;
   nombre,;
   pcostog,;
   pcostod,;
   pventag1,;
   pventag2,;
   pventag3,;
   pventag4,;
   pventag5,;
   rubro;
FROM;
   maesprod;
WHERE;
   proveedor = 22 AND;
   ROUND(pcostog * 2, 0) < pventag3 AND;
   fecucompra = CTOD("02/11/2011") AND;
   rubro <> 8;
ORDER BY;
   nombre
   
*!*	    (ROUND(pcostog * 1.80, 0) < pventag1 OR;
*!*	    ROUND(pcostog * 1.60, 0) < pventag2 OR;
*!*	    ROUND(pcostog * 1.40, 0) < pventag3 OR;
*!*	    ROUND(pcostog * 1.35, 0) < pventag4) AND;
