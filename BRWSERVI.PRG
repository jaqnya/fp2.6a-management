*:**************************************************************************
*:
*: Archivo de Procedimiento: BRWSERVI.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Vista hoja de datos para Servicios.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/04/2004
*:
*:**************************************************************************

*-- Variables para c lculos del programa.
PRIVATE pcAppend

*-- MS-DOS Definiciones de ventanas.
IF .NOT. WEXIST("brwServicios")
   DEFINE WINDOW brwServicios ;
      FROM 02,06 ;
      TO   22,73 ;
      TITLE "< COMISION MANO DE OBRA >" ;
      SYSTEM ;
      CLOSE ;
      FLOAT ;
      GROW ;
      MDI ;         
      NOMINIMIZE ;
      SHADOW ;
      ZOOM ;
      COLOR SCHEME 15
ENDIF

*-- Establece relaciones entre las tablas.
SELECT servicio
SET RELATION TO servicio.articulo INTO maesprod ADDITIVE

SELECT servicio
SET ORDER TO TAG indice1 OF servicio.cdx
GO TOP

*-- MS-DOS Macros de teclado.
ON KEY LABEL "F2" DO servicio.prg WITH "Add"
ON KEY LABEL "F3" DO servicio.prg WITH "Edit"
ON KEY LABEL "F5" DO _Search
ON KEY LABEL "F8" DO servicio.prg WITH "Delete"
ON KEY LABEL "CTRL+HOME" GO TOP
ON KEY LABEL "CTRL+END"  GO BOTTOM

DO _PrintHelpBar

BROWSE WINDOW brwServicios FIELDS ;
   articulo                                 :R:15:H = "C¢digo" ,;
   calc_f2 = SUBSTR(maesprod.nombre, 1, 39) :R:39:H = "Nombre" ,;
   pcomision                                :R:08:H = "Comisi¢n" :P = "99999.99" ,; 
   id_local                        :R:02:H = "" ;
   NOAPPEND NODELETE NOMODIFY

SET ORDER TO TAG indice1 OF servicio.cdx

*-- Quiebra las relaciones entre las tablas.
SELECT servicio
SET RELATION OFF INTO maesprod

*-- MS-DOS Restablece macros de teclado.
ON KEY LABEL "F2" 
ON KEY LABEL "F3" 
ON KEY LABEL "F5"
ON KEY LABEL "F8" 
ON KEY LABEL "CTRL+HOME" 
ON KEY LABEL "CTRL+END"  

RELEASE WINDOW brwServicios

*!**************************************************************************
*!
*!  Procedimiento: _Search        
*!
*!    Llamado por: BRWSERVI.PRG                  
*!
*!    Descripci¢n: Despliega la ventana de b£squeda.
*! 
*!**************************************************************************
PROCEDURE _Search

PUSH KEY CLEAR

IF EOF()
   DO WHILE .T.
      WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
      IF UPPER(pcAppend) = "S"
         DO servicio.prg WITH "Add"
         EXIT DO
      ENDIF
      IF UPPER(pcAppend) = "N"
         EXIT DO
      ENDIF
   ENDDO    
   POP KEY
   RETURN
ENDIF

IF LOWER(TAG()) = "indice1"
   DO buscar03.spr
ENDIF

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
@ 24,00 SAY "1       2       3       4       5       6       7       8       9       10" ;
   SIZE 1,74 ;
   COLOR W/N

*-- F1
@ 24,01 SAY "" ;
   SIZE 1,6 ;
   COLOR N/W

@ 24,25 SAY "Ordena" ;
   SIZE 1,6 ;
   COLOR N/W

@ 24,33 SAY "Busca" ;
   SIZE 1,6 ;
   COLOR N/W

*-- F6
@ 24,41 SAY "" ;
   SIZE 1,6 ;
   COLOR N/W

*-- F7
@ 24,49 SAY "" ;
   SIZE 1,6 ;
   COLOR N/W

*-- F9
@ 24,65 SAY "" ;
   SIZE 1,6 ;
   COLOR N/W

*-- F10
@ 24,74 SAY "" ;
   SIZE 1,6 ;
   COLOR N/W

*-- Verifica e imprime la etiqueta de las teclas que est n habilitadas.
IF UserConfig("brwServi.prg", "Add", .F.)
   @ 24,09 SAY "Agrega" ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 24,09 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF

IF UserConfig("brwServi.prg", "Edit", .F.)
   @ 24,17 SAY "Modif." ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 24,17 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF

IF UserConfig("brwServi.prg", "Delete", .F.)
   @ 24,57 SAY "Borra" ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 24,57 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF