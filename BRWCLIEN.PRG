*:**************************************************************************
*:
*: Archivo de Procedimiento: BRWVLIEN.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Vista hoja de datos para Clientes.       
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/04/2004
*:
*:**************************************************************************

*-- Variables para c lculos del programa.
PRIVATE pcAppend

*-- MS-DOS Definiciones de ventanas.
IF .NOT. WEXIST("brwClientes")
   DEFINE WINDOW brwClientes ;
      FROM 01,00 ;
      TO   23,79 ;
      TITLE "< CLIENTES >" ;
      SYSTEM ;
      CLOSE ;
      NOFLOAT ;
      GROW ;
      MDI ;         
      NOMINIMIZE ;
      SHADOW ;
      ZOOM ;
      COLOR SCHEME 15
ENDIF

SELECT clientes
SET ORDER TO TAG indice2 OF clientes.cdx
GO TOP

*-- Establece relaciones entre las tablas.                
SET RELATION TO clientes.departamen INTO depar    ADDITIVE
SET RELATION TO clientes.ciudad     INTO ciudades ADDITIVE
SET RELATION TO clientes.barrio     INTO barrios  ADDITIVE 
SET RELATION TO clientes.motivoclie INTO motivocl ADDITIVE

*-- MS-DOS Macros de teclado.
ON KEY LABEL "F2" DO clientes.prg WITH "Add"
ON KEY LABEL "F3" DO clientes.prg WITH "Edit"
ON KEY LABEL "F4" DO orden06.spr
ON KEY LABEL "F5" DO _Switch
ON KEY LABEL "F8" DO clientes.prg WITH "Delete"
ON KEY LABEL "CTRL+ENTER" DO clientes.prg WITH "Consult"
ON KEY LABEL "CTRL+HOME"  GO TOP
ON KEY LABEL "CTRL+END"   GO BOTTOM

DO HelpBar.spr
DO _PrintHelpBar

BROWSE WINDOW brwClientes FIELDS ;
   codigo                         :R:06:H = "C¢digo"             :P = "999999" ,;
   calc_f1 = LEFT(nombre, 45)     :R:45:H = "Nombre"             :P = "@!" ,;
   saldo_actu                     :R:11:H = " Saldo Gs. "        :P = "999,999,999" ,;
   saldo_usd                      :R:11:H = " Saldo US$ "        :P = "9999,999.99" ,;
   calc_f2 = LEFT(ruc, 12)        :R:12:H = "R.U.C." ,;
   calc_f3 = LEFT(telefono, 30)   :R:30:H = "Tel‚fono" ,;
   calc_f4 = LEFT(documento, 15)  :R:15:H = "Documento Clie" ,;
   calc_f5 = LEFT(nombre_c, 50)   :R:50:H = "Nombre del C¢nyuge" :P = "@!" ,;
   calc_f6 = LEFT(docconyuge, 15) :R:15:H = "Documento Cony" ,;
   calc_f7 = LEFT(nombre_g, 50)   :R:50:H = "Nombre del Garante" :P = "@!" ,;
   calc_f8 = LEFT(docgarante, 15) :R:15:H = "Documento Garan" ;
   NOAPPEND NODELETE NOMODIFY

*   saldo_actu                     :R:11:H = " Saldo Gs. "        :P = "999,999,999" ,;
*   saldo_usd                      :R:11:H = " Saldo US$ "        :P = "9999,999.99" ,;


SET ORDER TO TAG indice1 OF clientes.cdx

*-- Quiebra las relaciones entre las tablas.                
SET RELATION OFF INTO depar   
SET RELATION OFF INTO ciudades
SET RELATION OFF INTO barrios  
SET RELATION OFF INTO motivocl 

*-- MS-DOS Restablece macros de teclado.
ON KEY LABEL "F2" 
ON KEY LABEL "F3" 
ON KEY LABEL "F4"
ON KEY LABEL "F5"
ON KEY LABEL "F8" 
ON KEY LABEL "CTRL+ENTER" 
ON KEY LABEL "CTRL+HOME" 
ON KEY LABEL "CTRL+END"  

RELEASE WINDOW 
IF WEXIST("brwClientes")
   RELEASE WINDOW brwClientes
ENDIF

*!**************************************************************************
*!
*!  Procedimiento: _Switch        
*!
*!    Llamado por: BRWCLIEN.PRG                  
*!
*!    Descripci¢n: Selecciona cual de las ventanas de b£squeda va a presen-
*!                 tarle al usuario.
*! 
*!**************************************************************************
PROCEDURE _Switch

PUSH KEY CLEAR

IF EOF()
   DO WHILE .T.
      WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
      IF UPPER(pcAppend) = "S"
         DO proveedo.prg WITH "Add"
         EXIT DO
      ENDIF
      IF UPPER(pcAppend) = "N"
         EXIT DO
      ENDIF
   ENDDO    
   POP KEY
   RETURN
ENDIF

DO CASE
   CASE LOWER(TAG()) = "indice1"
      DO clibusc1.spr
   CASE LOWER(TAG()) = "indice2"
      DO clibusc2.spr
   CASE LOWER(TAG()) = "indice3"
      DO clibusc3.spr
   CASE LOWER(TAG()) = "indice4"
      DO clibusc4.spr
   CASE LOWER(TAG()) = "indice5"
      DO clibusc5.spr
   CASE LOWER(TAG()) = "indice6"
      DO clibusc6.spr
   CASE LOWER(TAG()) = "indice7"
      DO clibusc7.spr
ENDCASE

POP KEY

*!**************************************************************************
*!
*!      FUNCION: _PrintHelpBar
*!
*!  DESCRIPCION: Imprime la barra de ayuda.
*!
*!**************************************************************************
FUNCTION _PrintHelpBar

*-- Impresiones predeterminadas.
@ 00,00 SAY "1       2       3       4       5       6       7       8       9       10" ;
   SIZE 1,74 ;
   COLOR W/N

*-- F1
@ 00,01 SAY "" ;
   SIZE 1,6 ;
   COLOR N/W

@ 00,25 SAY "Ordena" ;
   SIZE 1,6 ;
   COLOR N/W

@ 00,33 SAY "Busca" ;
   SIZE 1,6 ;
   COLOR N/W

*-- F6
@ 00,41 SAY "" ;
   SIZE 1,6 ;
   COLOR N/W

*-- F7
@ 00,49 SAY "" ;
   SIZE 1,6 ;
   COLOR N/W

*-- F9
@ 00,65 SAY "" ;
   SIZE 1,6 ;
   COLOR N/W

*-- F10
@ 00,74 SAY "" ;
   SIZE 1,6 ;
   COLOR N/W

*-- Verifica e imprime la etiqueta de las teclas que est n habilitadas.
IF UserConfig("brwClien.prg", "Add", .F.)
   @ 00,09 SAY "Agrega" ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 00,09 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF

IF UserConfig("brwClien.prg", "Edit", .F.)
   @ 00,17 SAY "Modif." ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 00,17 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF

IF UserConfig("brwClien.prg", "Delete", .F.)
   @ 00,57 SAY "Borra" ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 00,57 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF