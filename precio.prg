CLEAR ALL
SET CENTURY ON
SET DATE BRITISH
SET DELETED ON
SET EXACT ON


USE z:\turtle\aya\integrad.000\maesprod SHARED IN 0 ALIAS server
USE c:\turtle\maesprod EXCLUSIVE IN 0 ALIAS slave

n = 0
SELECT slave
SCAN all
   SELECT server
   SET ORDER TO 1
   IF SEEK(slave.codigo) then
      replace pventag3 WITH slave.pventag3
      replace pventad3 WITH slave.pventad3
      ? slave.codigo
   ELSE
      ? "No encontrado"
   ENDIF
   n = n + 1
endscan



? "total " + STR(n)