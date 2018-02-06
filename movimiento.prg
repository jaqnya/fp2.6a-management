CLEAR
SET DEFAULT TO z:\turtle\aya\integrad.000
DO movimiento_articulo WITH "80501"
DELETE FOR LEFT(nombre, 7) = "SALIDA:"
DELETE FOR LEFT(nombre, 8) = "ENTRADA:"
SUM entrada, salida TO m.entrada, m.salida
? "ENTRADA: " + ALLTRIM(STR(m.entrada)) FONT "Courier New", 9
? "SALIDA.: " + ALLTRIM(STR(m.salida)) FONT "Courier New", 9
? "SALDO..: " + ALLTRIM(STR(m.entrada-m.salida)) FONT "Courier New", 9
