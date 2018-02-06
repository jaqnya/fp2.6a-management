*:**************************************************************************
*:
*: Archivo de Procedimiento: BRWPROVE.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Vista hoja de datos para Proveedores.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/04/2004
*:
*:**************************************************************************

*-- Variables para c lculos del programa.
PRIVATE pcAppend

*-- MS-DOS Definiciones de ventanas.
IF .NOT. WEXIST("brwProveedores")
   DEFINE WINDOW brwProveedores ;
      FROM 01,00 ;
      TO   23,79 ;
      TITLE "< PROVEEDORES >" ;
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

SELECT proveedo
SET ORDER TO TAG indice2 OF proveedo.cdx
GO TOP
                
*-- MS-DOS Macros de teclado.
ON KEY LABEL "F2" DO proveedo.prg WITH "Add"
ON KEY LABEL "F3" DO proveedo.prg WITH "Edit"
ON KEY LABEL "F4" DO orden01.spr
ON KEY LABEL "F5" DO _Switch
ON KEY LABEL "F8" DO proveedo.prg WITH "Delete"
ON KEY LABEL "CTRL+ENTER" DO proveedo.prg WITH "Consult"
ON KEY LABEL "CTRL+HOME" GO TOP
ON KEY LABEL "CTRL+END"  GO BOTTOM

BROWSE WINDOW brwProveedores FIELDS ;
   codigo                         :R:06:H = "C¢digo"             :P = "999999" ,;
   calc_f1 = LEFT(nombre, 31)     :R:31:H = "Nombre"             :P = "@!" ,;
   saldo_actu                     :R:11:H = " Saldo Gs. "        :P = "999,999,999" ,;
   saldo_usd                      :R:11:H = " Saldo US$ "        :P = "9999,999.99" ,;
   calc_f2 = LEFT(ruc, 13)        :R:13:H = "R.U.C." ;
   NOAPPEND NODELETE NOMODIFY



SET ORDER TO TAG indice1 OF proveedo.cdx

*-- MS-DOS Restablece macros de teclado.
ON KEY LABEL "F2" 
ON KEY LABEL "F3" 
ON KEY LABEL "F4"
ON KEY LABEL "F5"
ON KEY LABEL "F8" 
ON KEY LABEL "CTRL+ENTER"
ON KEY LABEL "CTRL+HOME" 
ON KEY LABEL "CTRL+END"  

RELEASE WINDOW brwProveedores

*!**************************************************************************
*!
*!  Procedimiento: _Switch        
*!
*!    Llamado por: BRWPROVE.PRG                  
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
      DO buscar01.spr
   CASE LOWER(TAG()) = "indice2"
      DO buscar02.spr
ENDCASE

POP KEY