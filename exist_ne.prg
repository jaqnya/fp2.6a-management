CLEAR
CLEAR ALL

SET CENTURY   ON
SET DATE      BRITISH
SET DELETED   ON
SET EXCLUSIVE OFF
SET EXACT     ON

SELECT;
   codigo,;
   nombre,;
   stock_actu - stock_ot AS existencia;
FROM;
   maesprod;
WHERE;
   stock_actu - stock_ot < 0