*
* UPDMOVOT.PRG - Actualiza los precios de una OT.
*
PARAMETERS cSerieOt, nNroOt, nLstPrecio

*-- Variables para c lculos del programa.
PRIVATE tmpFile01, pcSetExact, pnSelect, pcOrder, pnRecNo, pnGravada1, pnGravada2, pnExenta1, pnExenta2, pnImpuesto, pnImpuest2, pnSubTotal, pnSubTota3, pnTotal1, pnTotal2

*-- Inicializa variables del programa.
STORE SPACE(01)              TO tmpFile01, pcSetExact
STORE SELECT()               TO pnSelect
STORE ORDER()                TO pcOrder 
STORE IIF(EOF(), 0, RECNO()) TO pnRecNo
STORE 0                      TO pnGravada1, pnGravada2, pnExenta1, pnExenta2, pnImpuesto, pnImpuest2, pnSubTotal, pnSubTota2, pnTotal1, pnTotal2

*-- C¢digo de Configuraci¢n.
=Setup()

*-- Procedimiento Principal
SELECT tmpUpdate     &&   Vac¡a la  tabla  temporal  que  contiene  el
ZAP                  &&   detalle de art¡culos del documento.

SELECT detamot 

IF SEEK(STR(2, 1) + cSerieOt + STR(nNroOt, 7))
   SCAN WHILE (STR(2, 1) + cSerieOt + STR(nNroOt, 7)) = (STR(detamot.tipobole, 1) + detamot.serie + STR(detamot.nrobole, 7))
      INSERT INTO tmpUpdate (tipobole, serie, nrobole, articulo, cantidad, precio1, pimpuesto1, impuesto1, mecanico, descr_trab, subtotal1, actualizar) ;
         VALUES (detamot.tipobole, detamot.serie, detamot.nrobole, detamot.articulo, TRANSFORM(detamot.cantidad, "999999.99"), STR(detamot.precio, 13, 4), detamot.pimpuesto, detamot.impuesto, detamot.mecanico, detamot.descr_trab, TRANSFORM(ROUND(detamot.precio * detamot.cantidad, 0), "99,999,999,999"), .T.)
   ENDSCAN
ENDIF

*-- Actualiza los precios.
IF SET("EXACT") = "OFF"
   SET EXACT ON 
   pcSetExact = "OFF"
ELSE
   pcSetExact = "ON"
ENDIF

SELECT tmpUpdate
GO TOP

SCAN ALL
   SELECT maesprod

   IF SEEK(tmpUpdate.articulo)
      SELECT servicio
      SET RELATION OFF INTO maesprod

      IF .NOT. SEEK(tmpUpdate.articulo)
         SELECT tmpUpdate
         DO CASE
            CASE nLstPrecio = 1
               IF maesprod.pventag1 <> 0
                  REPLACE tmpUpdate.precio2 WITH STR(maesprod.pventag1, 13, 4)
               ELSE
                  REPLACE tmpUpdate.precio2 WITH tmpUpdate.precio1
               ENDIF
            CASE nLstPrecio = 2
               IF maesprod.pventag2 <> 0
                  REPLACE tmpUpdate.precio2 WITH STR(maesprod.pventag2, 13, 4)
               ELSE
                  REPLACE tmpUpdate.precio2 WITH tmpUpdate.precio1
               ENDIF
            CASE nLstPrecio = 3
               IF maesprod.pventag3 = 0
                  IF maesprod.pventag2 <> 0
                     REPLACE tmpUpdate.precio2 WITH STR(maesprod.pventag2, 13, 4)
                  ELSE
                     REPLACE tmpUpdate.precio2 WITH tmpUpdate.precio1
                  ENDIF
               ELSE
                  REPLACE tmpUpdate.precio2 WITH STR(maesprod.pventag3, 13, 4)
               ENDIF
            CASE nLstPrecio = 4
               IF maesprod.pventag4 <> 0
                  REPLACE tmpUpdate.precio2 WITH STR(maesprod.pventag4, 13, 4)
               ELSE
                  REPLACE tmpUpdate.precio2 WITH tmpUpdate.precio1
               ENDIF
            CASE nLstPrecio = 5
               IF maesprod.pventag5 <> 0
                  REPLACE tmpUpdate.precio2 WITH STR(maesprod.pventag5, 13, 4)
               ELSE
                  REPLACE tmpUpdate.precio2 WITH tmpUpdate.precio1
               ENDIF
         ENDCASE      

         REPLACE tmpUpdate.impuesto2  WITH maesprod.impuesto
         REPLACE tmpUpdate.pimpuesto2 WITH maesprod.pimpuesto
      ELSE
         SELECT tmpUpdate 
         REPLACE tmpUpdate.precio2 WITH tmpUpdate.precio1
         REPLACE tmpUpdate.impuesto2  WITH tmpUpdate.impuesto1
         REPLACE tmpUpdate.pimpuesto2 WITH tmpUpdate.pimpuesto1
      ENDIF

      SELECT servicio
      SET RELATION TO servicio.articulo INTO maesprod ADDITIVE

      IF pcSetExact = "OFF"
         SET EXACT OFF
      ENDIF
   ELSE
      SELECT tmpUpdate
      REPLACE tmpUpdate.precio2 WITH tmpUpdate.precio1
      REPLACE tmpUpdate.impuesto2  WITH tmpUpdate.impuesto1
      REPLACE tmpUpdate.pimpuesto2 WITH tmpUpdate.pimpuesto1
   ENDIF

   SELECT tmpUpdate
   REPLACE subtotal2 WITH TRANSFORM(ROUND(VAL(precio2) * VAL(cantidad), 0), "99,999,999,999")
ENDSCAN

*-- Calcula el Sub-Total, Impuesto, Total.
SELECT tmpUpdate
GO TOP

SCAN ALL
   DO CASE
      CASE impuesto1 .AND. pimpuesto1 > 0 .AND. pimpuesto1 < 10
         pnGravada1 = pnGravada1 + ROUND(VAL(precio1) * VAL(cantidad), 0) * (pimpuesto1 * (control.pimpuesto / 100))
         pnExenta1  = pnExenta1  + ROUND(VAL(precio1) * VAL(cantidad), 0) * (1 - (pimpuesto1 * (control.pimpuesto / 100)))
      CASE impuesto1 .AND. pimpuesto1 = control.pimpuesto
         pnGravada1 = pnGravada1 + ROUND(VAL(precio1) * VAL(cantidad), 0)            
      CASE .NOT. impuesto1 .AND. pimpuesto1 = 0
         pnExenta1  = pnExenta1  + ROUND(VAL(precio1) * VAL(cantidad), 0)
   ENDCASE

   DO CASE
      CASE impuesto2 .AND. pimpuesto2 > 0 .AND. pimpuesto2 < 10
         pnGravada2 = pnGravada2 + ROUND(VAL(precio2) * VAL(cantidad), 0) * (pimpuesto2 * (control.pimpuesto / 100))
         pnExenta2  = pnExenta2  + ROUND(VAL(precio2) * VAL(cantidad), 0) * (1 - (pimpuesto2 * (control.pimpuesto / 100)))
      CASE impuesto2 .AND. pimpuesto2 = control.pimpuesto
         pnGravada2 = pnGravada2 + ROUND(VAL(precio2) * VAL(cantidad), 0)            
      CASE .NOT. impuesto2 .AND. pimpuesto2 = 0
         pnExenta2  = pnExenta2  + ROUND(VAL(precio2) * VAL(cantidad), 0)
   ENDCASE
ENDSCAN

pnSubTotal = pnGravada1 + pnExenta1
pnSubTota2 = pnGravada2 + pnExenta2

pnImpuesto   = ROUND(pnGravada1 * (control.pimpuesto / 100), 0)
pnImpuest2   = ROUND(pnGravada2 * (control.pimpuesto / 100), 0)

pnTotal1 = pnSubTotal + pnImpuesto
pnTotal2 = pnSubTota2 + pnImpuest2

INSERT INTO tmpUpdate (descr_trab, cantidad, subtotal1, subtotal2) ;
   VALUES (REPLICATE("Ä", 37), REPLICATE("Ä", 09), REPLICATE("Ä", 14), REPLICATE("Ä", 14))

INSERT INTO tmpUpdate (descr_trab, subtotal1, subtotal2) ;
   VALUES (SPACE(10) + "Sub-Totales", TRANSFORM(pnSubTotal, "99,999,999,999"), TRANSFORM(pnSubTota2, "99,999,999,999"))

INSERT INTO tmpUpdate (descr_trab, subtotal1, subtotal2) ;
   VALUES (SPACE(10) + "I.V.A.", TRANSFORM(pnImpuesto, "99,999,999,999"), TRANSFORM(pnImpuest2, "99,999,999,999"))

INSERT INTO tmpUpdate (descr_trab, subtotal1, subtotal2) ;
   VALUES (SPACE(10) + "TOTAL GENERAL", TRANSFORM(pnTotal1, "99,999,999,999"), TRANSFORM(pnTotal2, "99,999,999,999"))

SELECT tmpUpdate 
GO TOP

ON KEY LABEL "A" DO ChangeStatus WITH "actualizar"

BROWSE WINDOW tmpUpdate  FIELDS ;
   calc_f1 = IIF(EMPTY(descr_trab), SUBSTR(maesprod.nombre, 1, 35), SUBSTR(descr_trab, 1, 35)) :R:35:H = "Descripci¢n"  :P = "@!" ,;
   calc_f2 = RIGHT(cantidad, 8) :R:08:H = "Cantidad"     ,;
   subtotal1                                :R:14:H = "Precio Antiguo"  ,;
   subtotal2                                :R:14:H = "Precio Nuevo"    ,;
   calc_f3 = IIF(actualizar, "S", "")       :R:01:H = "" ,;
   mecanico                                 :R:03:H = "Mec"          :P = "999" ,; 
   calc_f4 = SUBSTR(mecanico.nombre, 1, 30) :R:30:H = "Nombre del Mec nico" :P = "@!" :W = .F. ,;
   calc_f5 = IIF(impuesto1, "   S¡", "")    :R:08:H = "Impuesto"     :W = .F. ,;
   pimpuesto1                               :R:06:H = "% Imp."       :P = "999.99" ;
   NOAPPEND NODELETE NOMODIFY

ON KEY LABEL "A"

COUNT TO pnCount FOR actualizar

IF pnCount > 0
   DO WHILE .T.
      WAIT WINDOW "¨ DESEA ACTUALIZAR LOS PRECIOS [S/N] ?" TO pcUpdate
   
      IF INLIST(UPPER(pcUpdate), "S", "N")
         EXIT DO
      ENDIF
   ENDDO

   IF UPPER(pcUpdate) = "S"
      =UpdatePrices()
   ENDIF
ENDIF

*-- C¢digo de Limpieza.
=Cleanup()

*-----------------------------------------------------------------------*
* MS-DOS © Procedimientos y funciones de soporte.                       *
*-----------------------------------------------------------------------*

*
* SETUP - C¢digo de Configuraci¢n.
*
PROCEDURE Setup

PUSH KEY CLEAR

*-- Definiciones de ventanas.
IF .NOT. WEXIST("tmpUpdate")
   DEFINE WINDOW tmpUpdate ;
      FROM 06,00 ;
      TO 19,79 ;
      TITLE "ACTUALIZACION DE PRECIOS DE LA OT N§: " + cSerieOt + "-" + ALLTRIM(STR(nNroOt,7)) ;
      SYSTEM ;
      CLOSE ;
      NOFLOAT ;
      GROW ;
      MDI ;         
      NOMINIMIZE ;
      NOSHADOW ;
      ZOOM ;
      COLOR SCHEME 15
ENDIF

*-- Base de datos, ¡ndices, relaciones.
SELECT 0
tmpFile01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &tmpFile01 (tipobole   N(01) ,;
                         serie      C(01) ,;
                         nrobole    N(07) ,;
                         articulo   C(15) ,;
                         cantidad   C(09) ,;
                         precio1    C(13) ,;
                         pdescuento N(07,4) ,;
                         impuesto1  L(01) ,;
                         pimpuesto1 N(06,2) ,;
                         mecanico   N(03) ,;
                         comision_m N(06,2) ,;
                         descr_trab C(40) ,;
                         precio2    C(13) ,;
                         impuesto2  L(01) ,;
                         pimpuesto2 N(06,2) ,;
                         subtotal1  C(14) ,;
                         subtotal2  C(14) ,;
                         actualizar L(01))
                                                  
USE &tmpFile01 ALIAS tmpUpdate EXCLUSIVE
INDEX ON STR(tipobole, 1) + serie + STR(nrobole, 7) TAG indice1
INDEX ON articulo                                   TAG indice2

*-- Establece relaciones entre las tablas.
SET RELATION TO tmpUpdate.articulo INTO maesprod ,;        
                tmpUpdate.mecanico INTO mecanico ADDITIVE

*-- Ordena las tablas.
SELECT maesprod
SET ORDER TO TAG indice1 OF maesprod.cdx

SELECT servicio
SET ORDER TO TAG indice1 OF servicio.cdx

SELECT detamot
SET ORDER TO TAG indice1 OF detamot.cdx

SELECT tmpUpdate
SET ORDER TO 0

*
* UPDATE - Proceso de actualizaci¢n.
*
PROCEDURE UpdatePrices

*-- Borra el detalle del movimiento de OT.
SELECT detamot

IF SEEK(STR(2, 1) + cSerieOt + STR(nNroOt, 7))
   SCAN WHILE (STR(2, 1) + cSerieOt + STR(nNroOt, 7)) = (STR(detamot.tipobole, 1) + detamot.serie + STR(detamot.nrobole, 7))
      DELETE
   ENDSCAN
ENDIF

*-- Guarda el detalle del movimiento de OT actualizado.

SELECT tmpUpdate
GO TOP

SCAN ALL
   IF tmpUpdate.actualizar
      IF .NOT. EMPTY(articulo)     
         INSERT INTO detamot (tipobole, serie, nrobole, articulo, cantidad, precio, impuesto, pimpuesto, mecanico, descr_trab) ;
            VALUES (2, cSerieOt, nNroOt, tmpUpdate.articulo, VAL(tmpUpdate.cantidad), VAL(tmpUpdate.precio2), tmpUpdate.impuesto2, tmpUpdate.pimpuesto2, tmpUpdate.mecanico, tmpUpdate.descr_trab)
      ENDIF
   ELSE
      IF .NOT. EMPTY(articulo)
         INSERT INTO detamot (tipobole, serie, nrobole, articulo, cantidad, precio, impuesto, pimpuesto, mecanico, descr_trab) ;
            VALUES (2, cSerieOt, nNroOt, tmpUpdate.articulo, VAL(tmpUpdate.cantidad), VAL(tmpUpdate.precio1), tmpUpdate.impuesto1, tmpUpdate.pimpuesto1, tmpUpdate.mecanico, tmpUpdate.descr_trab)
      ENDIF
   ENDIF
ENDSCAN

SELECT cabemot
REPLACE cabemot.monto_fact WITH pnTotal2

*
* CLEANUP - C¢digo de Limpieza.
*
PROCEDURE Cleanup

*-- Elimina ventanas.
IF WEXIST("tmpUpdate")
   RELEASE WINDOW tmpUpdate
ENDIF

*-- Cierre de Bases de Datos.
IF USED("tmpUpdate")
   SELECT tmpUpdate 
   USE
ENDIF

DELETE FILE &tmpFile01
DELETE FILE SUBSTR(tmpFile01, 1, ATC(".", tmpFile01)) + "CDX"

IF .NOT. EMPTY(ALIAS(pnSelect))
   SELECT (pnSelect)
   SET ORDER TO TAG (pcOrder) 
   IF pnRecNo <> 0
      GOTO RECORD pnRecNo
   ENDIF
ENDIF

POP KEY

*
* CHANGESTATUS - Cambio el estado del marcado.
*

PROCEDURE ChangeStatus
PARAMETER pcField

IF .NOT. EMPTY(articulo)
   IF &pcField
      REPLACE &pcField WITH .F.
   ELSE
      REPLACE &pcField WITH .T.
   ENDIF
ENDIF