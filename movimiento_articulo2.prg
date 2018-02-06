SET CENTURY ON
SET DATE BRITISH
SET DELETED ON

DO movimiento_articulo WITH "3323"
*!*	DELETE FOR LEFT(nombre, 7) = "ENTRADA" OR LEFT(nombre, 6) = "SALIDA"
*!*	DELETE FOR (LEFT(nombre, 7) = "ENTRADA" OR LEFT(nombre, 6) = "SALIDA") AND fecha >= CTOD("14/06/2010")
SUM entrada, salida TO m.entrada, m.salida
? "Entrada: " + STR(m.entrada, 9, 2)
? "Salida: " + STR(m.salida, 9, 2)
? "Existencia: " + STR(m.entrada - m.salida, 9, 2)