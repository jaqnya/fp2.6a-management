*:**************************************************************************
*:
*: Archivo de Procedimiento: BRWFAMIL.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Vista hoja de datos para Familias.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/04/2004
*:
*:**************************************************************************

*-- Variables para c lculos del programa.
PRIVATE pcAppend

*-- Definiciones de ventanas.
IF .NOT. WEXIST("brwOts")
   DEFINE WINDOW brwOts ;
      FROM 01,00 ;
      TO   23,79 ;
      TITLE "< ORDENES DE TRABAJO >" ;
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

SELECT ot
SET ORDER TO TAG indice1 OF ot.cdx 
GO TOP

*-- Establece relaciones entre las tablas.
SELECT ot
SET RELATION TO ot.marca    INTO marcas2  ADDITIVE
SET RELATION TO ot.modelo   INTO modelos  ADDITIVE
SET RELATION TO ot.estadoot INTO estadoot ADDITIVE


*-- MS-DOS Macros de teclado.
ON KEY LABEL "F2" DO ot.prg WITH "Add"
ON KEY LABEL "F3" DO ot.prg WITH "Edit"
ON KEY LABEL "F4" DO orden05.spr
ON KEY LABEL "F5" DO _Switch
ON KEY LABEL "F8" DO ot.prg WITH "Delete"
ON KEY LABEL "D"  DO ot.prg WITH "Detail"
ON KEY LABEL "CTRL+ENTER" DO ot.prg WITH "Consult"
ON KEY LABEL "CTRL+HOME" GO TOP
ON KEY LABEL "CTRL+END"  GO BOTTOM

BROWSE WINDOW brwOTs FIELDS ;
   calc_f1 = serie + STR(nroot, 8)                :R:09:H = " OT N§ " ,;
   frecepcion                                     :R:11:H = "F.Recepci¢n" ,;
   fentrega                                       :R:10:H = "F.Entrega" ,;
   calc_f2 = SUBSTR(marcas2.nombre, 1, 10)        :R:10:H = "Marca" ,;
   calc_f3 = SUBSTR(modelos.nombre, 1, 06)        :R:06:H = "Modelo" ,;
   calc_f4 = LOWER(SUBSTR(estadoot.nombre, 1, 9)) :R:09:H = "Estado" ,;
   calc_f5 = SUBSTR(nombreot, 1, 30)              :R:30:H = "Cliente" ,;
   accesorio                                      :R:56:H = "Accesorio(s)" ,;
   chapa                                          :R:25:H = "Chapa" ,;
   motor                                          :R:25:H = "Motor" ,;
   chasis                                         :R:25:H = "Caja #" ;
   NOMODIFY NOAPPEND NODELETE 

SET ORDER TO TAG indice1 OF ot.cdx    

*-- Quiebra las relaciones entre las tablas.
SET RELATION OFF INTO marcas2 
SET RELATION OFF INTO modelos 
SET RELATION OFF INTO estadoot

*-- MS-DOS Restablece macros de teclado.
ON KEY LABEL "F2" 
ON KEY LABEL "F3"
ON KEY LABEL "F4"
ON KEY LABEL "F5"
ON KEY LABEL "F8" 
ON KEY LABEL "D"  
ON KEY LABEL "CTRL+ENTER"
ON KEY LABEL "CTRL+HOME" 
ON KEY LABEL "CTRL+END"  

RELEASE WINDOW brwOTs

*!**************************************************************************
*!
*!  Procedimiento: _Switch        
*!
*!    Llamado por: BRWOT.PRG                  
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
         DO ot.prg WITH "Add"
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
   CASE LOWER(TAG()) == "indice1"
      DO buscar11.spr
   CASE LOWER(TAG()) == "indice2"
      DO buscar12.spr
   CASE LOWER(TAG()) == "indice3"
      DO buscar13.spr
   CASE LOWER(TAG()) == "indice4"
      DO buscar14.spr
   CASE LOWER(TAG()) == "indice5"
      DO buscar15.spr
   CASE LOWER(TAG()) == "indice6"
      DO buscar16.spr
   CASE LOWER(TAG()) == "indice7"
      DO buscar17.spr
   CASE LOWER(TAG()) == "indice8"
      DO buscar18.spr
   CASE LOWER(TAG()) == "indice9"
      DO buscar19.spr
   CASE LOWER(TAG()) == "indice10"
      DO buscar20.spr
   CASE LOWER(TAG()) == "indice11"
      DO buscar21.spr
ENDCASE

POP KEY