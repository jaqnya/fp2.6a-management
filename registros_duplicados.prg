CLEAR ALL
CLEAR

SET DELETED ON
SET CENTURY ON
SET DATE BRITISH

USE cabevent IN 0 SHARED
USE detavent IN 0 SHARED
USE cabecob IN 0 SHARED
USE detacob IN 0 SHARED

SELECT tipodocu, nrodocu, COUNT(*) AS registros FROM cabevent GROUP BY tipodocu, nrodocu HAVING COUNT(*) > 1
SELECT tipodocu, nrodocu, articulo, COUNT(*) AS registros FROM detavent WHERE !INLIST(articulo, "10001", "99001", "99010", "99011", "99012", "99013", "99014", "99015", "99016")GROUP BY tipodocu, nrodocu, articulo HAVING COUNT(*) > 1
SELECT tiporeci, nroreci, COUNT(*) AS registros FROM cabecob GROUP BY tiporeci, nroreci HAVING COUNT(*) > 1