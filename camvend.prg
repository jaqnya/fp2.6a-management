PARAMETERS m.vendedor, m.tipodocu, m.nrodocu

SET DELETED ON
SET CENTURY ON
SET DATE    BRITISH
SET TALK    OFF

CLOSE ALL
CLEAR

USE cabevent IN 0 SHARED
USE vendedor IN 0 SHARED

SELECT vendedor
SET ORDER TO 1

SEEK m.vendedor

IF FOUND() THEN
   m.nombre    = nombre
   m.comision1 = comision1
   m.comision2 = comision2
   m.comision3 = comision3
ELSE
   ? "The seller does not exist."
   RETURN .F.
ENDIF   

SELECT cabevent
SET ORDER TO 1

SEEK STR(m.tipodocu, 1) + STR(m.nrodocu, 7)

IF FOUND() THEN
   m.old_seller = vendedor
   REPLACE vendedor   WITH m.vendedor
   REPLACE comision_1 WITH m.comision1
   REPLACE comision_2 WITH m.comision2
   REPLACE comision_3 WITH m.comision3
ELSE
   ? "Invoice does no exist."
   RETURN .F.
ENDIF

* Report section.

SELECT vendedor
SET ORDER TO 1

SEEK m.old_seller

? "Process Summary"
? "-------------------------------------------"
? ""
? "Invoice: " + ALLTRIM(STR(m.tipodocu)) + "/" + ALLTRIM(STR(m.nrodocu))
? "Old Seller: " + ALLTRIM(nombre) + " (" + ALLTRIM(STR(codigo)) + ")"
? "New Seller: " + ALLTRIM(m.nombre) + " (" + ALLTRIM(STR(m.vendedor)) + ")"
? ""
? "-------------------------------------------"
? "Change made successfully."

CLOSE ALL