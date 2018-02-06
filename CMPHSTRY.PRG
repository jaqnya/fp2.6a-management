PARAMETERS pcItem

PRIVATE pnSelect, pcOrder, pnRecNo, pnCounter

*-- Inicializa variables de memoria
pnSelect  = SELECT()
pcOrder   = ORDER()
pnRecNo   = IIF(EOF(), 0, RECNO())
pnCounter = 1

*-- C¢digo de configuraci¢n.
=Setup()

*-- Proceso principal.
SELECT cabecomp

SCAN ALL
   WAIT WINDOW "PROCESANDO LA TABLA DE COMPRAS: " + ALLTRIM(TRANSFORM(pnCounter, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) NOWAIT

   SELECT detacomp

   IF SEEK(STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9) + STR(cabecomp.proveedor, 5))
      SCAN WHILE STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9)  + STR(cabecomp.proveedor, 5) = STR(detacomp.tipodocu, 1) + STR(detacomp.nrodocu, 9) + STR(detacomp.proveedor, 5)
         IF detacomp.articulo = pcItem
            *-- Calcula el importe neto de la compra.
            IF cabecomp.porcdesc >= 0
               IF cabecomp.porcdesc = 0 .AND. cabecomp.importdesc = 0
                  IF cabecomp.moneda <> 1     && Guaran¡es.
                     pnImporte = ROUND((ROUND(detacomp.precio, 2) - ROUND(ROUND(detacomp.precio, 2) * detacomp.pdescuento / 100, 2)) * cabecomp.tipocambio, 0)
                  ELSE
                     pnImporte = ROUND(ROUND(detacomp.precio, 0) - ROUND(ROUND(detacomp.precio, 0) * detacomp.pdescuento / 100, 0), 0)
                  ENDIF
               ELSE
                  IF cabecomp.porcdesc > 0  
                     IF cabecomp.moneda <> 1     && Guaran¡es.
                        _importe  = ROUND(ROUND(detacomp.precio, 2) - ROUND(ROUND(detacomp.precio, 2) * detacomp.pdescuento / 100, 2), 2)
                        pnImporte = ROUND((_importe - ROUND(ROUND(_importe, 2) * cabecomp.porcdesc / 100, 2)) * cabecomp.tipocambio, 0)
                     ELSE
                        _importe  = ROUND(ROUND(detacomp.precio, 0) - ROUND(ROUND(detacomp.precio, 0) * detacomp.pdescuento / 100, 0), 0)
                        pnImporte = ROUND(_importe - ROUND(ROUND(_importe, 0) * cabecomp.porcdesc / 100, 0), 0)
                     ENDIF
                  ELSE
                     IF cabecomp.importdesc > 0
                        IF cabecomp.moneda <> 1     && Guaran¡es.
                           _importe  = ROUND(ROUND(detacomp.precio, 2) - ROUND(ROUND(detacomp.precio, 2) * detacomp.pdescuento / 100, 2), 2)
                           pnImporte = ROUND((_importe - ROUND(ROUND(_importe, 2) * cabecomp.descuento / 100, 2)) * cabecomp.tipocambio, 0)
                        ELSE
                           _importe  = ROUND(ROUND(detacomp.precio, 0) - ROUND(ROUND(detacomp.precio, 0) * detacomp.pdescuento / 100, 0), 0)
                           pnImporte = ROUND(_importe - ROUND(ROUND(_importe, 0) * cabecomp.descuento / 100, 0), 0)
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
            
            INSERT INTO tmpcompras (tipodocu, nrodocu, fechadocu, proveedor, precio, cantidad) ;
               VALUES (cabecomp.tipodocu, cabecomp.nrodocu, cabecomp.fechadocu, cabecomp.proveedor, pnImporte, detacomp.cantidad)
         ENDIF
      ENDSCAN
   ENDIF

   SELECT cabecomp   
   pnCounter = pnCounter + 1   
ENDSCAN

WAIT CLEAR

SELECT tmpcompras 
SET ORDER TO TAG indice2 DESCENDING
GO TOP

BROWSE WINDOW preview FIELDS ;
   calc_f1 = IIF(tipodocu = 1,"CCON ", IIF(tipodocu = 2,"CCRE ", IIF(tipodocu = 3, "CII  ", IIF(tipodocu = 4, "CTU  ", IIF(tipodocu = 5, "CICCO", IIF(tipodocu = 6, "CICCR", "     ")))))) :R:05:H = "" ,;
   nrodocu    :R:09:P = "999999999" :H = "N§ Doc." ,;
   fechadocu  :R:10:H = "Fecha Doc." ,;
   precio     :R:12:P = "9999,999,999" :H = "Precio Unit." ,;
   cantidad   :R:08:P = "99999.99" :H = "Cantidad" ,;
   calc_f4 = SUBSTR(proveedo.nombre, 1, 51) :R:51:P = "@!" :H = "Proveedor" ,;
   proveedor  :R:07:P = "9999999" :H = "C¢d.Pro" ;
   NOAPPEND NODELETE NOMODIFY

*-- C¢digo de Limpieza
=Cleanup()

IF .NOT. EMPTY(ALIAS(pnSelect))
   SELECT (pnSelect)
   SET ORDER TO TAG (pcOrder) 
   IF pnRecNo <> 0
      GOTO RECORD pnRecNo
   ENDIF
ENDIF

*-----------------------------------------------------------------------*
* MS-DOS © Procedimientos y funciones de soporte.                       *
*-----------------------------------------------------------------------*

*
* SETUP - C¢digo de configuraci¢n.
*
PROCEDURE Setup
PUBLIC temp01

SELECT maesprod
SET ORDER TO TAG indice1 OF maesprod.cdx

IF SEEK(pcItem)
   pcTitle = "HISTORICO DE COMPRA - " + ALLTRIM(maesprod.nombre) + " (" + ALLTRIM(maesprod.codigo) + ")"
ENDIF

*-- MS-DOS Definici¢n de ventana.
IF .NOT. WEXIST("preview")
   DEFINE WINDOW preview ;
      FROM 01,00 ;
      TO 23,79 ;
      TITLE pcTitle ;
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

WAIT WINDOW "CREANDO TABLA TEMPORAL..." NOWAIT

*-- MS-DOS Base de datos, ¡ndices, relaciones.
SELECT 0
temp01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"

CREATE TABLE &temp01 (tipodocu   N(01) ,;
                      nrodocu    N(09) ,;
                      fechadocu  D(08) ,;
                      proveedor  N(05) ,;
                      precio     N(10) ,;
                      cantidad   N(11,2))

USE &temp01 ALIAS tmpcompras EXCLUSIVE

INDEX ON STR(tipodocu, 1) + STR(nrodocu, 9) + STR(proveedor, 5) + DTOS(fechadocu) TAG indice1 
INDEX ON DTOS(fechadocu) + STR(proveedor, 5) + STR(tipodocu, 1) + STR(nrodocu, 9) TAG indice2 
INDEX ON STR(proveedor, 5) + DTOS(fechadocu) + STR(tipodocu, 1) + STR(nrodocu, 9) TAG indice3 

*-- Ordena las tablas.

SELECT cabecomp 
SET ORDER TO TAG indice1 OF cabecomp.cdx

SELECT detacomp 
SET ORDER TO TAG indice1 OF detacomp.cdx

SELECT proveedo
SET ORDER TO indice1 OF proveedo.cdx

*-- Estable relaciones entre las tablas.
SELECT tmpcompras
SET RELATION TO tmpcompras.proveedor INTO proveedo ADDITIVE

*
* CLEANUP - C¢digo de limpieza.
*
PROCEDURE Cleanup

IF WEXIST("preview")
   RELEASE WINDOW preview
ENDIF

IF USED("tmpcompras")
   SELECT tmpcompras
   USE
ENDIF

DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"