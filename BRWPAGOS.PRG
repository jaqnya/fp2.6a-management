*:**************************************************************************
*:
*: Archivo de Procedimiento: BRWPAGOS.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Vista hoja de datos para Pagos.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/04/2004
*:
*:**************************************************************************
*-- MS-DOS Definiciones de ventanas.
IF .NOT. WEXIST("brwPagos")
   DEFINE WINDOW brwPagos ;
      FROM 01,00 ;
      TO   23,79 ;
      TITLE "< PAGOS A PROVEEDORES >" ;
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

*-- Base de datos, ¡ndices, relaciones.
SELECT 0
temp01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp01 (tiporeci   N(01) ,;
                      nroreci    N(07) ,;
                      fechadocu  D(08) ,;
                      tipodocu   N(01) ,;
                      nrodocu    N(09) ,;
                      proveedor  N(05) ,;
                      tipo       N(01) ,;
                      nrocuota   N(03) ,;
                      importe    N(12,2) ,;
                      abonado    N(12,2) ,;
                      monto_ndeb N(12,2) ,;
                      monto_ncre N(12,2) ,;
                      monto      N(12,2))
                      
USE &temp01 ALIAS tmpdetapag EXCLUSIVE

INDEX ON STR(tipodocu, 1) + STR(nrodocu, 9) TAG indice1
INDEX ON DTOS(fechadocu)                    TAG indice2
INDEX ON STR(tiporeci, 1) + STR(nroreci, 7) TAG indice3

SELECT cabepag
SET ORDER TO TAG indice1 OF cabepag.cdx
GO TOP
                
*-- Establece relaciones entre las tablas.
SET RELATION TO cabepag.proveedor INTO proveedo ADDITIVE
SET RELATION TO cabepag.moneda    INTO monedas  ADDITIVE
SET RELATION TO cabepag.id_local  INTO locales  ADDITIVE

*-- MS-DOS Macros de teclado.
ON KEY LABEL "F2" DO pagos.prg WITH "Add"
ON KEY LABEL "F4" DO orden04.spr
ON KEY LABEL "F5" DO _Switch
ON KEY LABEL "F8" DO pagos.prg WITH "Delete"
ON KEY LABEL "CTRL+ENTER" DO pagos1.spr
ON KEY LABEL "CTRL+HOME"  GO TOP
ON KEY LABEL "CTRL+END"   GO BOTTOM
ON KEY LABEL "ENTER" DO pagos.prg WITH "Consult"

BROWSE WINDOW brwPagos FIELDS ;
   calc_f1 = IIF(tiporeci = 1, "R.P.", IIF(tiporeci = 2, "CIP.", "    ")) :R:04:H = "Tipo" ,;
   nroreci    :R:09:H = "Recibo N§" :P = "999999999" ,;
   fechareci  :R:10:H = "Fecha"     :P = "@D" ,;
   calc_f2 = SUBSTR(monedas.simbolo, 1, 4) + "  " :R:06:H = "Moneda" ,;   
   monto_pago :R:14:H = "Importe"   :P = "999,999,999.99" ,;
   calc_f3 = SUBSTR(proveedo.nombre, 1, 40) :R:40:H = "Proveedor" :P = "@!" ,;
   proveedor  :R:06:H = "C¢digo" :P = "999999" ,;
   tipocambio :R:09:H = "T. Cambio" :P = "999999.99" ,;
   calc_f4 = IIF(id_local < 10, "0" + LTRIM(STR(id_local, 2)), LTRIM(STR(id_local, 2))) :R:02:H = "" :P = "@!" ;   
   NOAPPEND NODELETE NOMODIFY
   
SET ORDER TO TAG indice1 OF cabepag.cdx

*-- MS-DOS Restablece macros de teclado.
ON KEY LABEL "F2" 
ON KEY LABEL "F4"
ON KEY LABEL "F5"
ON KEY LABEL "F8" 
ON KEY LABEL "CTRL+ENTER" 
ON KEY LABEL "CTRL+HOME" 
ON KEY LABEL "CTRL+END"  
ON KEY LABEL "ENTER" 

*-- MS-DOS Cierre de Base de datos e ¡ndices.
IF USED("tmpdetapag")
   SELECT tmpdetapag
   USE
ENDIF

DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"

*-- Quiebra las relaciones entre las tablas.
SELECT cabepag
SET RELATION OFF INTO proveedo
SET RELATION OFF INTO monedas  
SET RELATION OFF INTO locales

*-- Elimina ventanas.
IF WEXIST("brwPagos")
   RELEASE WINDOW brwPagos
ENDIF

*!**************************************************************************
*!
*!  Procedimiento: _Switch        
*!
*!    Llamado por: BRWPAGOS.PRG                  
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
         DO pagos.prg WITH "Add"
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
   CASE LOWER(TAG()) = "indice3"
      DO buscar10.spr
ENDCASE

POP KEY