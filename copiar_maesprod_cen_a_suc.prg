CLEAR
CLEAR ALL

SET DATE    BRITISH
SET DELETED ON
SET CENTURY ON
SET SAFETY  OFF

USE z:\turtle\aya\integrad.000\maesprod IN 0 ALIAS maespcen EXCLUSIVE
USE z:\turtle\aya\integrad.001\maesprod IN 0 ALIAS maespdep EXCLUSIVE

SELECT maespdep
ZAP
APPEND FROM z:\turtle\aya\integrad.000\maesprod.dbf
REPLACE stock_actu WITH 0, stock_ot WITH 0, ubicacion WITH "" ALL

SELECT maespcen
USE
SELECT maespdep
USE