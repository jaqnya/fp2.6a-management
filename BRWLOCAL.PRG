*:**************************************************************************
*:
*: Archivo de Procedimiento: BRWLOCAL.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Vista hoja de datos para Locales de la Empresa.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/04/2004
*:
*:**************************************************************************

*-- Variables para c lculos del programa.
PRIVATE pcAppend

*-- MS-DOS Definiciones de ventanas.
IF .NOT. WEXIST("brwLocales")
   DEFINE WINDOW brwLocales ;
      FROM 02,16 ;
      TO   22,64 ;
      TITLE "< LOCALES DE LA EMPRESA >" ;
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

SELECT locales
SET ORDER TO TAG indice1 OF locales.cdx
GO TOP
                
*-- MS-DOS Macros de teclado.
ON KEY LABEL "F2" DO locales.prg WITH "Add"
ON KEY LABEL "F3" DO locales.prg WITH "Edit"
ON KEY LABEL "F4" DO orden01.spr
ON KEY LABEL "F5" DO _Switch
ON KEY LABEL "F8" DO locales.prg WITH "Delete"
ON KEY LABEL "CTRL+HOME" GO TOP
ON KEY LABEL "CTRL+END"  GO BOTTOM

DO _PrintHelpBar

BROWSE WINDOW brwLocales FIELDS ;
   codigo                                :R:06:H = "C¢digo"  :P = "999999" ,;
   calc_f2 = SUBSTR(nombre, 1, 30)       :R:30:H = "Nombre" ,;
   calc_f3 = IIF(vigente, "S¡     ", "") :R:07:H = "Vigente" :P = "@I" ;
   NOAPPEND NODELETE NOMODIFY
  
SET ORDER TO TAG indice1 OF locales.cdx

*-- MS-DOS Restablece macros de teclado.
ON KEY LABEL "F2" 
ON KEY LABEL "F3" 
ON KEY LABEL "F4"
ON KEY LABEL "F5"
ON KEY LABEL "F8" 
ON KEY LABEL "CTRL+HOME" 
ON KEY LABEL "CTRL+END"  

RELEASE WINDOW brwLocales

*!**************************************************************************
*!
*!  Procedimiento: _Switch        
*!
*!    Llamado por: BRWLOCAL.PRG                  
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
         DO locales.prg WITH "Add"
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
      DO buscar01.spr
   CASE LOWER(TAG()) = "indice2"
      DO buscar02.spr
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
IF UserConfig("brwLocal.prg", "Add", .F.)
   @ 24,09 SAY "Agrega" ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 24,09 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF

IF UserConfig("brwLocal.prg", "Edit", .F.)
   @ 24,17 SAY "Modif." ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 24,17 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF

IF UserConfig("brwLocal.prg", "Delete", .F.)
   @ 24,57 SAY "Borra" ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 24,57 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF