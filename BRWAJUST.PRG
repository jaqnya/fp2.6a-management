*:**************************************************************************
*:
*: Archivo de Procedimiento: BRWAJUST.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Vista hoja de datos  para  Notas  de  Env¡o  y     
*:                           Ajustes de Inventario.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 01/05/2004
*:
*:**************************************************************************

*-- Variables para c lculos del programa.
PRIVATE pcAppend

*-- MS-DOS Definiciones de ventanas.
IF .NOT. WEXIST("brwAjustes")
   DEFINE WINDOW brwAjustes  ;
      FROM 01,00 ;
      TO   23,79 ;
      TITLE "< NOTAS DE ENVIO Y AJUSTES DE INVENTARIO >" ;
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

IF .NOT. WEXIST("dtlAjustes")
   DEFINE WINDOW dtlAjustes  ;
      FROM 07,00 ;
      TO   23,79 ;
      TITLE "DETALLE" ;
      SYSTEM ;
      CLOSE ;
      FLOAT ;
      GROW ;
      MDI ;         
      NOMINIMIZE ;
      SHADOW ;
      NOZOOM ;
      COLOR SCHEME 15
ENDIF

*-- MS-DOS Base de datos, ¡ndices, relaciones.
SELECT 0
temp01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp01 (tipobole N(01) ,;
                      nrobole  N(07) ,;
                      articulo C(15) ,;
                      cantidad N(11,2))
                      
USE &temp01 ALIAS tmpdetmovi EXCLUSIVE
INDEX ON STR(tipobole, 1) + STR(nrobole, 7) TAG indice1
SET RELATION TO tmpdetmovi.articulo INTO maesprod ADDITIVE

SELECT cabemovi
SET ORDER TO indice1 OF cabemovi.cdx
GO TOP

*-- Establece relaciones entre las tablas.
SET RELATION TO cabemovi.local INTO locales ADDITIVE
                
DO _PrintHelpBar

*-- MS-DOS Macros de teclado.
ON KEY LABEL "F2" DO ajustes.prg WITH "Add"
ON KEY LABEL "F3" DO ajustes.prg WITH "Edit"
ON KEY LABEL "F4" DO orden03.spr
ON KEY LABEL "F5" DO _Switch
ON KEY LABEL "F8" DO ajustes.prg WITH "Delete"
ON KEY LABEL "CTRL+HOME" GO TOP
ON KEY LABEL "CTRL+END"  GO BOTTOM
ON KEY LABEL "ENTER" DO ajustes.prg WITH "Consult"

BROWSE WINDOW brwAjustes FIELDS ;
   calc_f1 = IIF(tipobole = 1, "ENTRADA", IIF(tipobole = 2, "SALIDA", IIF(tipobole = 3, "AJUSTE - ENTRADA", IIF(tipobole = 4, "AJUSTE - SALIDA", "")))) :R:16:H = "Tipo Documento" ,;
   nrobole :R:07:H = "Doc. N§":P = "9999999" ,;
   fecha   :R:10:H = "Fecha"  :P = "@D" ,;
   calc_f2  = SUBSTR(locales.nombre, 1, 24) :R:24:H = "Remitente o Destinatario" ;
   NOAPPEND NODELETE NOMODIFY

SET ORDER TO indice1 OF cabemovi.cdx

*-- MS-DOS Restablece macros de teclado.
ON KEY LABEL "F2" 
ON KEY LABEL "F3" 
ON KEY LABEL "F4"
ON KEY LABEL "F5"
ON KEY LABEL "F8" 
ON KEY LABEL "CTRL+HOME" 
ON KEY LABEL "CTRL+END"  
ON KEY LABEL "ENTER" 

*-- MS-DOS Cierre de Base de datos e ¡ndices.
IF USED("tmpdetmovi")
   SELECT tmpdetmovi
   USE
ENDIF

DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"

*-- Quiebra las relaciones entre las tablas.
SELECT cabemovi
SET RELATION OFF INTO locales 

RELEASE WINDOW brwAjustes
RELEASE WINDOW dtlAjustes

*!**************************************************************************
*!
*!  Procedimiento: _Switch        
*!
*!    Llamado por: BRWAJUST.PRG                  
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
         DO ajustes.prg WITH "Add"
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
      DO buscar08.spr
   CASE LOWER(TAG()) = "indice2"
      DO buscar09.spr
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
IF UserConfig("brwAjust.prg", "Add", .F.)
   @ 24,09 SAY "Agrega" ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 24,09 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF

IF UserConfig("brwAjust.prg", "Edit", .F.)
   @ 24,17 SAY "Modif." ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 24,17 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF

IF UserConfig("brwAjust.prg", "Delete", .F.)
   @ 24,57 SAY "Borra" ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 24,57 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF