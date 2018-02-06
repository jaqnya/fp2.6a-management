*:**************************************************************************
*:
*: Archivo de Procedimiento: BRWPAGOS.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Vista hoja de datos para Cobros.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/04/2004
*:
*:**************************************************************************
*-- MS-DOS Definiciones de ventanas.
IF .NOT. WEXIST("brwCobros")
   DEFINE WINDOW brwCobros ;
      FROM 01,00 ;
      TO   23,79 ;
      TITLE "< COBROS A CLIENTES >" ;
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
                      tipodocu   N(01) ,;
                      nrodocu    N(07) ,;
                      tipo       N(01) ,;
                      nrocuota   N(03) ,;
                      fechadocu  D(08) ,;
                      importe    N(12,2) ,;
                      abonado    N(12,2) ,;
                      monto_ndeb N(12,2) ,;
                      monto_ncre N(12,2) ,;
                      monto      N(12,2))

USE &temp01 ALIAS tmpdetacob EXCLUSIVE
INDEX ON STR(tiporeci, 1) + STR(nroreci, 7) TAG indice1
INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) TAG indice2

SELECT cabecob
SET ORDER TO TAG indice1 OF cabecob.cdx
GO TOP
                
*-- Establece relaciones entre las tablas.
SET RELATION TO cabecob.cliente  INTO clientes ADDITIVE
SET RELATION TO cabecob.moneda   INTO monedas  ADDITIVE
SET RELATION TO cabecob.id_local INTO locales  ADDITIVE

*-- MS-DOS Macros de teclado.
ON KEY LABEL "F2" DO cobros.prg WITH "Add"
ON KEY LABEL "F3" DO cobros.prg WITH "Edit"
ON KEY LABEL "F4" DO orden04.spr
ON KEY LABEL "F5" DO _Switch
ON KEY LABEL "F8" DO cobros.prg WITH "Delete"
ON KEY LABEL "CTRL+ENTER" DO cual
ON KEY LABEL "CTRL+HOME"  GO TOP
ON KEY LABEL "CTRL+END"   GO BOTTOM
ON KEY LABEL "ENTER" DO cobros.prg WITH "Consult"

BROWSE WINDOW brwCobros FIELDS ;
   calc_f1 = IIF(tiporeci = 1, "R.P.", IIF(tiporeci = 2, "CIP.", "    ")) :R:04:H = "Tipo" ,;
   nroreci    :R:09:H = "Recibo N§" :P = "999999999" ,;
   factura    :R:01:H = "" ,;
   fechareci  :R:10:H = "Fecha"     :P = "@D" ,;
   calc_f2 = SUBSTR(monedas.simbolo, 1, 4) + "  " :R:06:H = "Moneda" ,;   
   monto_cobr :R:14:H = "Importe"   :P = "999,999,999.99" ,;
   calc_f3 = IIF(anulado, "A N U L A D O", SUBSTR(clientes.nombre, 1, 40)) :R:40:H = "Cliente" :P = "@!" ,;
   cliente    :R:06:H = "C¢digo" :P = "999999" ,;
   tipocambio :R:09:H = "T. Cambio" :P = "999999.99" ,;
   calc_f4 = SUBSTR(locales.nombre, 1, 15) :R:15:H = "Local" :P = "@!" ;   
   NOAPPEND NODELETE NOMODIFY

SET ORDER TO TAG indice1 OF cabecob.cdx
  
*-- MS-DOS Restablece macros de teclado.
ON KEY LABEL "F2" 
ON KEY LABEL "F3"
ON KEY LABEL "F4"
ON KEY LABEL "F5"
ON KEY LABEL "F8" 
ON KEY LABEL "CTRL+ENTER" 
ON KEY LABEL "CTRL+HOME" 
ON KEY LABEL "CTRL+END"  
ON KEY LABEL "ENTER" 

*-- MS-DOS Cierre de Base de datos e ¡ndices.
IF USED("tmpdetacob")
   SELECT tmpdetacob
   USE
ENDIF

DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"

*-- Quiebra las relaciones entre las tablas.
SELECT cabecob
SET RELATION OFF INTO clientes
SET RELATION OFF INTO monedas  
SET RELATION OFF INTO locales

*-- Elimina ventanas.
IF WEXIST("brwCobros")
   RELEASE WINDOW brwCobros
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
         DO cobros.prg WITH "Add"
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
      DO buscar14.spr
ENDCASE

POP KEY

*---------------------------------------------------------------------*
PROCEDURE cual

IF gnUser = 1 THEN
   DO cobros2.spr
ELSE
   DO cobros3.spr
ENDIF