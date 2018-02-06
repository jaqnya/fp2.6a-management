                       MODELO DE PROGRAMA ESTRUCTURADO
                       -------------------------------

* +-------------------------------------------------------------+
* |  PRG_NAME.PRG  Release 1.0  __/__/____                      |
* |  Copyright (C) Turtle Software Paraguay, 2000-2004          |
* |  All Rights Reserved.                                       |
* |                                                             |
* |  This Module contains Proprietary Information of            |
* |  Turtle Software Paraguay and should be treated             |
* |  as Condifential.                                           |
* +-------------------------------------------------------------+

* +-------------------------------------------------------------+
* |                                                             |
* |                                                             |
* |                                                             |
* |                                                             |
* |                                                             |
* |  Modificado:                                                |
* |                                                             |
* +-------------------------------------------------------------+
WAIT WINDOW "POR FAVOR, ESPERE MIENTRAS SE CARGA EL MODULO..." NOWAIT

1) Declaraci¢n de variables.
   1.1) Del programa.
   1.2) De la(s) tabla(s).

2) Inicializaci¢n de variables.
   2.1) Del programa.
   2.1) De la(s) tabla(s).


3) C¢digo de configuraci¢n.
   =Setup()

4) Dise¤o de pantalla.
   =ScreenLayout()

5) Programa principal.

6) C¢digo de limpieza.

* +-------------------------------------------------------------+
* |  MS-DOS© Procedimientos y funciones del soporte.            |
* +-------------------------------------------------------------+

PROCEDURE Setup

   3.1) Definici¢n de ventana(s).
   3.2) Creaci¢n de tabla(s) temporal(es).
   3.3) Ordena tabla(s).
   3.4) Establece relacion(es) entre tablas.


PROCEDURE Cleanup

   6.1) Libera la(s) ventana(s) de la memoria.
   6.2) Elimina tabla(s) temporal(es).
   6.3) Quiebra la(s) relacion(es) entre tablas.

PROCEDURE ScreenLayout
   4.1) Limpia la pantalla.
   4.2) Dibuja el fondo.
   4.3) Imprime el encabezado y el pie de la pantalla.
