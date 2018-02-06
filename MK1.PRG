* +-------------------------------------------------------------+
* |  MKMOVOT2.PRG  Release 1.0  23/08/2004                      |
* |  Copyright (C) Turtle Software Paraguay, 2000-2004          |
* |  All Rights Reserved.                                       |
* |                                                             |
* |  This Module contains Proprietary Information of            |
* |  Turtle Software Paraguay and should be treated             |
* |  as Condifential.                                           |
* +-------------------------------------------------------------+

* +-------------------------------------------------------------+
* |  M¢dulo: MOVIMIENTOS DE ARTICULOS POR ORDENES DE TRABAJO.   |
* |  Este m¢dulo se encarga de agregar y modificar movimientos  |
* |  de ordenes de trabajo de m quinas en garant¡a.             |
* |                                                             |
* |  Modificado:                                                |
* |                                                             |
* +-------------------------------------------------------------+
PARAMETER cWhatToDo

* Declaraci¢n de variables.
STORE 0 TO m.nroot, m.lstprecio, m.monto_fact, m.almacen, m.cliente, ;
           m.mecanico, m.estadoot, m.maquina, m.marca, m.modelo, ;
           m.localrep, nGravada, nExenta, nImpuesto, nSubTotal
STORE "" TO m.serie, m.obs1, m.obs2, m.nombreot, m.accesorio, ;
            m.referencia, temp01
STORE {} TO fecha

* Declaraci¢n de constantes.
*-- Mensajes del sistema.

#DEFINE C_DBFEMPTY		"¨ LA TABLA ESTA VACIA, AGREGAR UN REGISTRO ?"
#DEFINE C_NOEDIT        "ESTE MOVIMIENTO DE OT YA HA SIDO FACTURADO, IMPOSIBLE MODIFICARLO !"


IF UPPER(cWhatToDo) = "ADD"
   SELECT cabemot2
   SCATTER MEMVAR MEMO BLANK
   m.serie = SUBSTR(control.serieot, 1, 1)   
ELSE
   IF UPPER(cWhatToDo) = "EDIT"
      IF EOF() .OR. BOF()
         IF MSGBOX(C_DBFEMPTY, "", 4, "MESSAGE", "C") = 6
            =Navigate("Add")
         ENDIF         
         RETURN
      ENDIF

      IF ot2.estadoot = 6 
         MSGBOX(C_NOEDIT, "", 0, "MESSAGE", "C")
      	 RETURN
      ENDIF
        
      SELECT cabemot2
      SCATTER MEMVAR MEMO
      
      SELECT ot
      SET ORDER TO TAG indice1 OF ot.cdx

      IF .NOT. SEEK(m.serie + STR(m.nrobole, 7))
         IF EMPTY(m.serie) .AND. m.nrobole = 0
            WAIT WINDOW "NO SE ENCONTRO LA OT N§: " + cabemot.serie + "/" + ALLTRIM(STR(cabemot.nrobole, 7))
         ENDIF
         STORE 0 TO m.cliente, m.mecanico, m.estadoot, m.maquina, m.marca, m.modelo, m.localrep  
         m.referencia = SPACE(01)
      ELSE
         m.cliente    = ot.cliente
         m.mecanico   = ot.mecanico
         m.estadoot   = ot.estadoot
         m.maquina    = ot.maquina
         m.marca      = ot.marca
         m.modelo     = ot.modelo
         m.accesorio  = ot.accesorio
         m.localrep   = ot.localrep
         m.referencia = ot.referencia
      ENDIF
   ENDIF
ENDIF

*-- Inicializaci¢n de variables.
STORE 0 TO pnGravada, pnExenta, pnImpuesto, pnSubTotal

IF pcWhatToDo = "Add"

   STORE 0 TO m.cliente, m.mecanico, m.estadoot, m.maquina, m.marca, m.modelo, m.localrep, m.monto_fact
   STORE SPACE(01) TO m.referencia, m.obs1, m.obs2

   plAdding    = .T.
   plEditing   = .F.
   plDeleting  = .F.
   m.fecha     = DATE()
   m.lstprecio = 1

   SELECT tmpdetmot 
   ZAP
ELSE
   IF pcWhatToDo = "Edit"
      plAdding    = .F.
      plEditing   = .T.
      plDeleting  = .F.
      IF m.lstprecio = 0
         m.lstprecio = 1
      ENDIF
   ENDIF
ENDIF  

SELECT cabemot 

DO _fmtInvoice

IF pcWhatToDo = "Edit"
   DO _RefreshInvoice
ENDIF

@ 02,12 GET m.serie ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "@A!" ;
   WHEN plAdding ;
   VALID _vldSerie() ;
   COLOR SCHEME 1

@ 02,14 GET m.nrobole ;
   SIZE 1,7 ;
   DEFAULT 0 ;
   PICTURE "9999999" ;
   WHEN plAdding ;
   VALID _vldNroBole() ;
   COLOR SCHEME 1

@ 02,32 GET m.fecha ;
   SIZE 1,10 ;
   DEFAULT DATE() ;
   PICTURE "@D" ;
   WHEN _whenFecha() ;
   VALID _vldFecha() ;
   COLOR SCHEME 1

@ 02,68 GET m.lstprecio ;
   SIZE 1,1 ;
   DEFAULT 1 ;
   PICTURE "9" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldLstPrecio() ;
   COLOR SCHEME 1

@ 04,12 GET m.mecanico ;
   SIZE 1,3 ;
   DEFAULT 1 ;
   PICTURE "999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldMecanico() ;
   COLOR SCHEME 1

@ 04,58 GET m.estadoot ;
   SIZE 1,3 ;
   DEFAULT 1 ;
   PICTURE "999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldEstadoOt() ;
   COLOR SCHEME 1

@ 20,16 GET m.localrep ;
   SIZE 1,2 ;
   DEFAULT 1 ;
   PICTURE "99" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldLocalRep() ;
   COLOR SCHEME 1

@ 20,42 GET m.referencia ;
   SIZE 1,10 ;
   DEFAULT 1 ;
   PICTURE "@! A 99999999" ;
   WHEN (plAdding .OR. plEditing) .AND. m.localrep <> control.id_local ;
   VALID _vldReferencia() ;
   COLOR SCHEME 1

@ 21,07 GET m.obs1 ;
   SIZE 1,45 ;
   PICTURE "@!" ;
   COLOR SCHEME 1

@ 22,07 GET m.obs2 ;
   SIZE 1,45 ;
   PICTURE "@!" ;
   VALID _vldObs2() ;
   COLOR SCHEME 1

READ CYCLE ;
   MODAL ;
   COLOR , W+/BG 

**-------------------------------------------------------------------**
**                            ENCABEZADO                             **
**-------------------------------------------------------------------**

*!*********************************************************************
*!
*!      Funci¢n: _vldSerie   
*!
*!  Llamado por: MKMOVIOT.PRG      
*!
*!  Descripci¢n: Validaci¢n del campo serie.
*!
*!*********************************************************************
FUNCTION _vldSerie    
IF INLIST(LASTKEY(), 5, 19, 28, 127)
   RETURN .F.
ENDIF

IF EMPTY(m.serie)
   WAIT WINDOW "­ LA SERIE NO PUEDE QUEDAR EN BLANCO !"
   RETURN .F.
ENDIF


*!*********************************************************************
*!
*!      Funci¢n: _vldNroBole 
*!
*!  Llamado por: MKMOVIOT.PRG                 
*!
*!  Descripci¢n: Validaci¢n del campo n£mero de documento.    
*!
*!*********************************************************************
FUNCTION _vldNroBole
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

IF m.nrobole <= 0
   WAIT WINDOW "­ EL N§ DE LA ORDEN DE TRABAJO DEBE SER MAYOR QUE CERO !"
   RETURN .F.
ENDIF

SELECT ot
SET ORDER TO TAG indice1 OF ot.cdx

IF SEEK(m.serie + STR(m.nrobole, 7))
   m.cliente    = ot.cliente
   m.mecanico   = ot.mecanico
   m.estadoot   = ot.estadoot
   m.maquina    = ot.maquina
   m.marca      = ot.marca
   m.modelo     = ot.modelo
   m.accesorio  = ot.accesorio
   m.localrep   = ot.localrep
   m.referencia = ot.referencia
ELSE
   WAIT WINDOW "­ N§ DE ORDEN DE TRABAJO NO ENCONTRADA !"
   
   STORE 0 TO m.cliente, m.mecanico, m.estadoot, m.maquina, m.marca, m.modelo, m.localrep  
   STORE SPACE(01) TO m.referencia, m.obs1, m.obs2

   SELECT (pnSelect)
   SET ORDER TO TAG (pcOrder)
   IF pnRecNo <> 0
      GOTO RECORD pnRecNo
   ENDIF

   RETURN .F.
ENDIF

@ 03,12 SAY m.cliente ;
   SIZE 1,5 ;
   PICTURE "99999" ;
   COLOR N/W

@ 03,19 SAY ot.nombreot ;
   SIZE 1,40 ;
   PICTURE "@!" ;
   COLOR W/N

*-- Imprime el nombre del mecanico.
SELECT mecanico
SET ORDER TO TAG indice1 OF mecanico.cdx

IF SEEK(m.mecanico)
   @ 04,19 SAY PADR(ALLTRIM(mecanico.nombre), 26, CHR(32)) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 04,19 SAY REPLICATE(CHR(32), 25) ;
      SIZE 1,25 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

SELECT cabemot

*-- Imprime el nombre del estado de la orden de trabajo.
SELECT estadoot
SET ORDER TO TAG indice1 OF estadoot.cdx

IF SEEK(m.estadoot)
   @ 04,63 SAY PADR(ALLTRIM(estadoot.nombre), 15, CHR(32)) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 04,63 SAY REPLICATE(CHR(32), 15) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

SELECT cabemot

*-- Imprime el nombre de la marca y el del modelo.
SELECT maquinas
SET ORDER TO TAG indice1 OF maquinas.cdx

IF .NOT. SEEK(m.maquina) .AND. m.maquina <> 0
   @ 05,12 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR N/W
   WAIT WINDOW "NO SE ENCONTRO LA MAQUINA N§: " + ALLTRIM(STR(ot.maquina, 3))
ENDIF

SELECT marcas2
SET ORDER TO TAG indice1 OF marcas2.cdx

IF .NOT. SEEK(m.marca) .AND. m.marca <> 0
   @ 05,12 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR N/W
   WAIT WINDOW "NO SE ENCONTRO LA MARCA N§: " + ALLTRIM(STR(ot.marca, 4))
ENDIF

SELECT modelos
SET ORDER TO TAG indice1 OF modelos.cdx

IF .NOT. SEEK(m.modelo) .AND. m.modelo <> 0
   @ 05,12 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR N/W
   WAIT WINDOW "NO SE ENCONTRO EL MODELO N§: " + ALLTRIM(STR(ot.modelo, 4))
ENDIF

@ 05,12 SAY ALLTRIM(maquinas.nombre) + " " + ALLTRIM(marcas2.nombre) + " " + ALLTRIM(modelos.nombre) ;
   SIZE 1,30 ;
   PICTURE "@!" ;
   COLOR N/W

SELECT cabemot

@ 05,44 SAY PADR(ALLTRIM(m.accesorio), 35, CHR(32)) ;
   SIZE 1,35 ;
   PICTURE "@!" ;
   COLOR N/W

*-- Imprime el nombre del local de reparaci¢n.
IF m.localrep <> 0
   SELECT locales  
   SET ORDER TO indice1 OF locales.cdx

   IF SEEK(m.localrep)
      @ 20,20 SAY PADR(ALLTRIM(locales.nombre), 14, CHR(32)) ;
            SIZE 1,14 ;
            PICTURE "@!" ;
            COLOR W/N
      ELSE
         @ 20,20 SAY REPLICATE(CHR(32), 14) ;
            SIZE 1,14 ;
            PICTURE "@!" ;
            COLOR W/N
      ENDIF
   ELSE
      @ 20,20 SAY REPLICATE(CHR(32), 14) ;
         SIZE 1,14 ;
         PICTURE "@!" ;
         COLOR W/N
   ENDIF

SHOW GETS

SELECT cabemot
SET ORDER TO TAG indice1 OF cabemot.cdx

IF SEEK(STR(2, 1) + m.serie + STR(m.nrobole, 7))
   WAIT WINDOW "­ ESTE MOVIMIENTO DE OT YA HA SIDO CARGADO !"

   SELECT (pnSelect)
   SET ORDER TO TAG (pcOrder)
   IF pnRecNo <> 0
      GOTO RECORD pnRecNo
   ENDIF

   RETURN .F.
ENDIF


SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldFecha
*!
*!  Llamado por: MKMOVIOT.PRG                  
*!
*!  Descripci¢n: Validaci¢n del campo fecha de documento.
*!
*!*********************************************************************
FUNCTION _vldFecha
SET NOTIFY OFF


*!*********************************************************************
*!
*!      Funci¢n: _vldLstPrecio
*!
*!  Llamado por: MKSELL.PRG                  
*!
*!  Descripci¢n: Validaci¢n del liste de precio.
*!
*!*********************************************************************
FUNCTION _vldLstPrecio
IF INLIST(LASTKEY(), 5, 19, 27, 127) 
   RETURN 
ENDIF

IF m.lstprecio <= 0 .OR. m.lstprecio > 5
   WAIT WINDOW "­ LA LISTA DE PRECIOS DEBE SER DEL 1 AL 5 !"
   RETURN .F.
ENDIF

**-------------------------------------------------------------------**
**                              DETALLE                              **
**-------------------------------------------------------------------**

*!*********************************************************************
*!
*!      Funci¢n: _brwLoadDetail
*!
*!  Llamado por: _vldVendedor
*!
*!  Descripci¢n: Abre una ventana de inspecci¢n para la cargar el deta-
*!               lle del comprobante de venta.
*!
*!*********************************************************************
FUNCTION _brwLoadDetail
PRIVATE pnSelect, pcOrder, pnRecNo
	
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(),0,RECNO())

SELECT tmpdetmot
SET ORDER TO 0

IF RECCOUNT() = 0
   INSERT INTO tmpdetmot (tipobole, serie, nrobole, articulo, cantidad, precio, pimpuesto, impuesto, mecanico, descr_trab) ;
      VALUES (0, "", 0, "", 0, 0, 0, .F. , 0, "")
ENDIF

ON KEY LABEL "F8" DO _DeleteLine

DO WHILE LASTKEY() <> 27
  
   @ 09,01 CLEAR TO 17,40     && Descripci¢n.
   @ 09,42 CLEAR TO 17,51     && Cantidad.
   @ 09,53 CLEAR TO 17,67     && Precio Unit.
   @ 09,69 CLEAR TO 17,78     && Importe.

   GO BOTTOM
   BROWSE WINDOW tmpdetmot FIELDS ;
      articulo                                   :13:H = "C¢digo"                                 :V = _vldCodigo():F ,;
      calc_f1 = SUBSTR(maesprod.nombre, 1, 37) :R:37:H = "Descripci¢n"  :W = .F. ,;
      cantidad                                   :08:H = "Cantidad"     :P = "99999.99"           :V = _vldCantidad():F ,;
      precio                                     :15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = _whenService() :V = _vldPrecio():F  ,;
      calc_f2 = ROUND(precio * cantidad, 0)      :11:H = " Sub-Total"   :P = "999,999,999" :W = _whenSubTotal(articulo) :V = _vldAddNewLine() :F ,;
      mecanico                                   :03:H = "Mec"          :P = "999"  :W = _whenService()  :V = _vldbrwMecanico():F ,;
      calc_f3 = SUBSTR(mecanico.nombre, 1, 30) :R:30:H = "Nombre del Mec nico" :W = .F. ,;
      descr_trab                                 :40:H = "Descripci¢n de Trabajo" :P = "@!" :V = _vldAddNewLine() :F ;
      NODELETE NOAPPEND 
ENDDO

ON KEY LABEL "F8"

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

DO _PrintDetail
DO _InvoiceFoot

*!*********************************************************************
*!
*!      Funci¢n: _vldCodigo     
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Validaci¢n   del   campo   c¢digo  en  el detalle  del   
*!               comprobante de venta.
*!
*!*********************************************************************
FUNCTION _vldCodigo

IF INLIST(LASTKEY(), 19, 127)
   RETURN .F.
ENDIF

IF INLIST(LASTKEY(), K_DOWN, K_F8)
   RETURN 
ENDIF  

IF EMPTY(articulo)
   PUSH KEY CLEAR

*!*   *-- Procedimiento de inspecci¢n de art¡culos.
*!*	   ON KEY LABEL "ENTER" KEYBOARD "{CTRL+W}"
*!*	   DO brwMaesp.prg
*!*	   ON KEY LABEL "ENTER" 

   m.articulo = ""
   DO brwmaesp WITH "m.articulo"

   POP KEY

   IF LASTKEY() <> 27
      REPLACE tmpdetmot.articulo WITH m.articulo
   ELSE 
      RETURN .F.
   ENDIF
ENDIF

PRIVATE pcSetExact

IF SET("EXACT") = "OFF"
   SET EXACT ON 
   pcSetExact = "OFF"
ELSE
   pcSetExact = "ON"
ENDIF

SELECT maesprod
SET ORDER TO TAG indice1 OF maesprod.cdx

IF .NOT. SEEK(tmpdetmot.articulo)
   WAIT WINDOW "­ CODIGO DE ARTICULO INEXISTENTE !"

   IF pcSetExact = "OFF"
      SET EXACT OFF
   ENDIF

   RETURN .F.
ENDIF

REPLACE tmpdetmot.articulo  WITH maesprod.codigo
REPLACE tmpdetmot.impuesto  WITH maesprod.impuesto
REPLACE tmpdetmot.pimpuesto WITH maesprod.pimpuesto

SELECT servicio
SET ORDER TO indice1 OF servicio.cdx
SET RELATION OFF INTO maesprod

IF .NOT. SEEK(tmpdetmot.articulo)
   SELECT tmpdetmot
   DO CASE
      CASE m.lstprecio = 1
         REPLACE tmpdetmot.precio WITH maesprod.pventag1
      CASE m.lstprecio = 2
         REPLACE tmpdetmot.precio WITH maesprod.pventag2
      CASE m.lstprecio = 3
         IF maesprod.pventag3 = 0
            REPLACE tmpdetmot.precio WITH maesprod.pventag2
         ELSE
            REPLACE tmpdetmot.precio WITH maesprod.pventag3
         ENDIF
      CASE m.lstprecio = 4
         REPLACE tmpdetmot.precio WITH maesprod.pventag4
      CASE m.lstprecio = 5
         REPLACE tmpdetmot.precio WITH maesprod.pventag5
   ENDCASE      
ELSE
   SELECT tmpdetmot 
   IF maesprod.pventag1 <> 0
      REPLACE tmpdetmot.precio WITH maesprod.pventag1
   ENDIF
ENDIF

SELECT servicio
SET RELATION TO servicio.articulo INTO maesprod ADDITIVE

IF pcSetExact = "OFF"
   SET EXACT OFF
ENDIF

SELECT tmpdetmot

*!*********************************************************************
*!
*!      Funci¢n: _vldCantidad   
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Validaci¢n   del   campo cantidad  en  el detalle  del   
*!               comprobante de venta.
*!
*!*********************************************************************
FUNCTION _vldCantidad
  
IF cantidad <= 0
   WAIT WINDOW "­ LA CANTIDAD DEBE SER MAYOR QUE CERO !"
   IF INLIST(LASTKEY(), 5, 19, 127)
      RETURN 
   ELSE
      RETURN .F.
   ENDIF
ENDIF 

IF .NOT. _whenService()
   IF tmpdetmot.precio <= 0
      WAIT WINDOW "­ EL PRECIO UNITARIO DE VENTA DEBE SER MAYOR QUE CERO !"
      RETURN .F.
   ENDIF
ENDIF

IF tmpdetmot.pimpuesto < 0 .OR. tmpdetmot.pimpuesto > control.pimpuesto
   WAIT WINDOW "­ PORCENTAJE DE IMPUESTO INVALIDO !"
   RETURN .F.
ENDIF

DO _InvoiceFoot   

*!*********************************************************************
*!
*!      Funci¢n: _vldPrecio   
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Validaci¢n del campo precio unitario en el detalle del   
*!               comprobante de venta.
*!
*!*********************************************************************
FUNCTION _vldPrecio
IF precio <= 0
   WAIT WINDOW "­ EL PRECIO DEBE SER MAYOR QUE CERO !"
   RETURN .F.
ENDIF         

DO _InvoiceFoot   

*!*********************************************************************
*!
*!      Funci¢n: _vldAddNewLine
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Agrega una nueva linea  al  detalle  del  comprobante, 
*!               siempre y cuando al £ltima tecla presionada sea ENTER.
*!
*!*********************************************************************
FUNCTION _vldAddNewLine 
IF LASTKEY() = 13  
   IF RECNO() = RECCOUNT()
      KEYBOARD "{CTRL+W}"      
      INSERT INTO tmpdetmot (tipobole, serie, nrobole, articulo, cantidad, precio, pimpuesto, impuesto, mecanico, descr_trab) ;
         VALUES (0, "", 0, "", 0, 0, 0, .F. , 0, "")
   ENDIF
ENDIF

DO _InvoiceFoot   

*!*********************************************************************
*!
*!      Funci¢n: _DeleteLine  
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Borra una l¡nea de detalle del comprobante de venta.
*!
*!*********************************************************************
FUNCTION _DeleteLine

PRIVATE pnSelect, pcOrder
pnSelect = SELECT()
pcOrder  = ORDER()

SELECT tmpdetmot
DELETE 
PACK

IF RECCOUNT() = 0
   INSERT INTO tmpdetmot (tipobole, serie, nrobole, articulo, cantidad, precio, pimpuesto, impuesto, mecanico, descr_trab) ;
      VALUES (0, "", 0, "", 0, 0, 0, .F. , 0, "")
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)

DO _InvoiceFoot

*!*********************************************************************
*!
*!      Funci¢n: _whenService
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: When del campo precio unitario.            
*!
*!*********************************************************************
FUNCTION _whenService
PRIVATE pnSelect, pcOrder, pnRecNo, pcSetExact, plFound

pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

IF SET("EXACT") = "OFF"
   SET EXACT ON 
   pcSetExact = "OFF"
ELSE
   pcSetExact = "ON"
ENDIF

SELECT servicio
SET ORDER TO indice1 OF servicio.cdx
SET RELATION OFF INTO maesprod

IF SEEK(tmpdetmot.articulo)
   plFound = .T.
ELSE
   plFound = .F.
ENDIF

SET RELATION TO servicio.articulo INTO maesprod

IF pcSetExact = "OFF"
   SET EXACT OFF
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

RETURN (plFound)

*!*********************************************************************
*!
*!      Funci¢n: _whenSubTotal
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: When del campo sub-total.            
*!
*!*********************************************************************
FUNCTION _whenSubTotal
PARAMETER pcArticulo

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT servicio
SET ORDER TO indice1 OF servicio.cdx

IF SEEK(pcArticulo)
   RETURN .F.
ELSE
   RETURN 
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

**-------------------------------------------------------------------**
**                                PIE                                **
**-------------------------------------------------------------------**

*!*********************************************************************
*!
*!      Funci¢n: _InvoiceFoot   
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Calcula e imprime el pie del comprobante de venta.
*!
*!*********************************************************************
FUNCTION _InvoiceFoot

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT tmpdetvent
GO TOP

STORE 0 TO m.monto_fact, pnGravada, pnExenta, pnImpuesto, pnSubTotal, pnDescGrav, pnDescExen, pnSubTota1

SCAN ALL
   DO CASE
      CASE impuesto .AND. pimpuesto > 0 .AND. pimpuesto < 10
         pnGravada = pnGravada + ROUND(precio * cantidad, 0) * (pimpuesto * (control.pimpuesto / 100))
         pnExenta  = pnExenta  + ROUND(precio * cantidad, 0) * (1 - (pimpuesto * (control.pimpuesto / 100)))
      CASE impuesto .AND. pimpuesto = control.pimpuesto
         pnGravada = pnGravada + ROUND(precio * cantidad, 0)            
      CASE .NOT. impuesto .AND. pimpuesto = 0
         pnExenta  = pnExenta  + ROUND(precio * cantidad, 0)
   ENDCASE
ENDSCAN

pnSubTotal = pnGravada + pnExenta

IF m.importdesc > 0 .AND. m.porcdesc = 0
   pnDescGrav   = ROUND(m.importdesc * ROUND(pnGravada * 100 / pnSubTotal, 2) / 100, 0)
   pnDescExen   = m.importdesc - pnDescGrav
   pnSubTota1   = pnSubTotal - m.importdesc
   pnImpuesto   = ROUND((pnGravada - pnDescGrav) * (control.pimpuesto / 100), 0)
   m.monto_fact = pnSubTota1 + pnImpuesto
   m.descuento  = ROUND(m.importdesc / pnSubTotal * 100, 4)
ELSE
   IF m.porcdesc > 0
      pnDescGrav   = ROUND((pnGravada * (m.porcdesc / 100)), 0)
      pnDescExen   = ROUND((pnExenta  * (m.porcdesc / 100)), 0)
      m.importdesc = pnDescGrav + pnDescExen
      pnSubTota1   = pnGravada - pnDescGrav + pnExenta - pnDescExen
      pnImpuesto   = ROUND(((pnGravada * (1 - (m.porcdesc / 100))) * (control.pimpuesto / 100)), 0)
      m.monto_fact = pnSubTota1 + pnImpuesto
   ELSE
      IF m.importdesc = 0 .AND. m.porcdesc = 0
         pnImpuesto   = ROUND(pnGravada * (control.pimpuesto / 100), 0)
         m.monto_fact = pnSubTotal + pnImpuesto
      ENDIF
   ENDIF
ENDIF

@ 19,68 SAY pnSubTotal ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

@ 20,46 SAY m.porcdesc ;
   SIZE 1,8 ;
   PICTURE "999.9999" ;
   COLOR N/W

@ 20,68 SAY m.importdesc ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

@ 21,68 SAY pnImpuesto ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

@ 22,68 SAY m.monto_fact ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR B/W

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _RefreshInvoice
*!
*!  Llamado por: VENTAS.PRG                  
*!
*!  Descripci¢n: Actualiza  la  visualizaci¢n  del  formato,  cabecera, 
*!               detalle, pie y cuota de la factura.
*!
*!*********************************************************************
FUNCTION _RefreshInvoice

DO _ShowHeader
DO _ShowDetail
DO _InvoiceFoot

*!*********************************************************************
*!
*!      Funci¢n: _ShowHeader
*!
*!  Llamado por: _RefreshInvoice
*!
*!  Descripci¢n: Visualiza el encabezado de la venta.
*!
*!*********************************************************************
FUNCTION _ShowHeader 

SELECT cabemot
SCATTER MEMVAR MEMO

*-- Inicializa variables de memoria
IF m.tipobole = 0 .AND. m.nrobole = 0
   m.cliente    = 0
   m.mecanico   = 0
   m.estadoot   = 0
   m.maquina    = 0
   m.marca      = 0
   m.modelo     = 0
   m.accesorio  = SPACE(56)
   m.localrep   = 0
   m.referencia = SPACE(10)
ENDIF

@ 02,12 SAY m.serie ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W

@ 02,14 SAY m.nrobole ;
   SIZE 1,7 ;
   PICTURE "9999999" ;
   COLOR N/W

@ 02,32 SAY m.fecha ;
   SIZE 1,10 ;
   PICTURE "@D" ;
   COLOR N/W

@ 02,68 SAY m.lstprecio ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W

@ 03,12 SAY m.cliente ;
   SIZE 1,5 ;
   PICTURE "99999" ;
   COLOR N/W

@ 03,19 SAY ot.nombreot ;
   SIZE 1,40 ;
   PICTURE "@!" ;
   COLOR W/N

@ 04,12 SAY m.mecanico ;
   SIZE 1,3 ;
   PICTURE "999" ;
   COLOR N/W

*-- Imprime el nombre del mecanico.
SELECT mecanico
SET ORDER TO TAG indice1 OF mecanico.cdx

IF SEEK(m.mecanico)
   @ 04,19 SAY PADR(ALLTRIM(mecanico.nombre), 26, CHR(32)) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 04,19 SAY REPLICATE(CHR(32), 25) ;
      SIZE 1,25 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

SELECT cabemot

@ 04,58 SAY m.estadoot ;
   SIZE 1,3 ;
   PICTURE "999" ;
   COLOR N/W

*-- Imprime el nombre del estado de la orden de trabajo.
SELECT estadoot
SET ORDER TO TAG indice1 OF estadoot.cdx

IF SEEK(m.estadoot)
   @ 04,63 SAY PADR(ALLTRIM(estadoot.nombre), 15, CHR(32)) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 04,63 SAY REPLICATE(CHR(32), 15) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

SELECT cabemot

*-- Imprime el nombre de la marca y el del modelo.
SELECT maquinas
SET ORDER TO TAG indice1 OF maquinas.cdx

IF .NOT. SEEK(m.maquina) .AND. m.maquina <> 0
   @ 05,12 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR N/W
   WAIT WINDOW "NO SE ENCONTRO LA MAQUINA N§: " + ALLTRIM(STR(ot.maquina, 3))
ENDIF

SELECT marcas2
SET ORDER TO TAG indice1 OF marcas2.cdx

IF .NOT. SEEK(m.marca) .AND. m.marca <> 0
   @ 05,12 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR N/W
   WAIT WINDOW "NO SE ENCONTRO LA MARCA N§: " + ALLTRIM(STR(ot.marca, 4))
ENDIF

SELECT modelos
SET ORDER TO TAG indice1 OF modelos.cdx

IF .NOT. SEEK(m.modelo) .AND. m.modelo <> 0
   @ 05,12 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR N/W
   WAIT WINDOW "NO SE ENCONTRO EL MODELO N§: " + ALLTRIM(STR(ot.modelo, 4))
ENDIF

@ 05,12 SAY PADR(ALLTRIM(maquinas.nombre) + " " + ALLTRIM(marcas2.nombre) + " " + ALLTRIM(modelos.nombre) , 30, CHR(32)) ;
   SIZE 1,30 ;
   PICTURE "@!" ;
   COLOR N/W

SELECT cabemot

@ 05,44 SAY PADR(ALLTRIM(m.accesorio), 35, CHR(32)) ;
   SIZE 1,35 ;
   PICTURE "@!" ;
   COLOR N/W

@ 20,20 SAY m.localrep ;
   SIZE 1,2 ;
   PICTURE "99" ;
   COLOR N/W

*-- Imprime el nombre del local de reparaci¢n.
IF m.localrep <> 0
   SELECT locales  
   SET ORDER TO indice1 OF locales.cdx

   IF SEEK(m.localrep)
      @ 20,20 SAY PADR(ALLTRIM(locales.nombre), 14, CHR(32)) ;
         SIZE 1,14 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 20,20 SAY REPLICATE(CHR(32), 14) ;
         SIZE 1,14 ;
         PICTURE "@!" ;
         COLOR W/N
   ENDIF
ELSE
   @ 20,20 SAY REPLICATE(CHR(32), 14) ;
      SIZE 1,14 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

@ 20,42 SAY m.referencia ;
   SIZE 1,10 ;
   PICTURE "@!" ;
   COLOR N/W

@ 21,07 SAY PADR(ALLTRIM(m.obs1), 45, CHR(32)) ;
   SIZE 1,45 ;
   PICTURE "@!" ;
   COLOR N/W

@ 22,07 SAY PADR(ALLTRIM(m.obs2), 45, CHR(32)) ;
   SIZE 1,45 ;
   PICTURE "@!" ;
   COLOR N/W

*!*********************************************************************
*!
*!      Funci¢n: _PrintDetail
*!
*!  Llamado por: _ShowDetail                 
*!
*!  Descripci¢n: Imprime el detalle de art¡culos del documento.             
*!
*!*********************************************************************
FUNCTION _PrintDetail

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

#DEFINE pnRow    8
#DEFINE pnColumn 1

SELECT tmpdetmot 
SET ORDER TO 0
GO TOP

SCAN WHILE RECNO() <= 10 .AND. .NOT. (EMPTY(articulo) .OR. EMPTY(cantidad) .OR. EMPTY(precio))
   @ pnRow + RECNO(), pnColumn + 1  SAY IIF(EMPTY(descr_trab), SUBSTR(maesprod.nombre, 1, 39), SUBSTR(descr_trab, 1, 39)) COLOR N/W
   @ pnRow + RECNO(), pnColumn + 41 SAY cantidad                       PICTURE "999,999.99"                               COLOR N/W
   @ pnRow + RECNO(), pnColumn + 52 SAY precio                         PICTURE "99,999,999.9999"                          COLOR N/W
   @ pnRow + RECNO(), pnColumn + 68 SAY ROUND(precio * cantidad, 0)    PICTURE "99,999,999"                               COLOR N/W
ENDSCAN

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _InvoiceFoot   
*!
*!  Llamado por: _RefreshInvoice
*!
*!  Descripci¢n: Imprime el pie del documento.
*!
*!*********************************************************************
FUNCTION _InvoiceFoot

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT tmpdetmot 
GO TOP

STORE 0 TO m.monto_fact, pnGravada, pnExenta, pnImpuesto, pnSubTotal

SCAN ALL
   DO CASE
      CASE impuesto .AND. pimpuesto > 0 .AND. pimpuesto < 10
         pnGravada = pnGravada + ROUND(precio * cantidad, 0) * (pimpuesto * (control.pimpuesto / 100))
         pnExenta  = pnExenta  + ROUND(precio * cantidad, 0) * (1 - (pimpuesto * (control.pimpuesto / 100)))
      CASE impuesto .AND. pimpuesto = control.pimpuesto
         pnGravada = pnGravada + ROUND(precio * cantidad, 0)            
      CASE .NOT. impuesto .AND. pimpuesto = 0
         pnExenta  = pnExenta  + ROUND(precio * cantidad, 0)
   ENDCASE
ENDSCAN

pnSubTotal   = pnGravada + pnExenta
pnImpuesto   = ROUND(pnGravada * (control.pimpuesto / 100), 0)
m.monto_fact = pnSubTotal + pnImpuesto

@ 20,68 SAY pnSubTotal ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

@ 21,68 SAY pnImpuesto ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

@ 22,68 SAY m.monto_fact ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR B/W

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldLocalRep
*!
*!  Llamado por: MKMOVIOT.PRG                
*!
*!  Descripci¢n: Validaci¢n del campo local de reparaci¢n.             
*!
*!*********************************************************************
FUNCTION _vldLocalRep
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

IF m.localrep <= 0
   @ 20,20 SAY REPLICATE(CHR(32), 14) ;
      SIZE 1,14 ;
      PICTURE "@!" ;
      COLOR W/N
   DO loca_pop.spr WITH "m.localrep", 0, .F.
ENDIF

IF m.localrep = 0
   RETURN .F.
ENDIF

PRIVATE pnSelect, pcOrder, pnRecNo

pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT locales
SET ORDER TO TAG indice1 OF locales.cdx

IF SEEK(m.localrep)
   @ 20,20 SAY PADR(ALLTRIM(locales.nombre), 14, CHR(32)) ;
      SIZE 1,14 ;
      PICTURE "@!" ;
      COLOR W/N

   IF .NOT. locales.vigente
      WAIT WINDOW "­ CODIGO DE LOCAL NO VIGENTE !"
      @ 20,20 SAY REPLICATE(CHR(32), 14) ;
         SIZE 1,14 ;
         PICTURE "@!" ;
         COLOR W/N
      
      SELECT (pnSelect)
      SET ORDER TO TAG (pcOrder)
      IF pnRecNo <> 0
         GOTO RECORD pnRecNo
      ENDIF
      
      RETURN .F.
   ENDIF
   
ELSE
   @ 20,20 SAY REPLICATE(CHR(32), 14) ;
      SIZE 1,14 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE LOCAL INEXISTENTE !"   
   DO loca_pop.spr WITH "m.localrep", 0, .F.
   SHOW GETS

   SELECT locales
   SET ORDER TO TAG indice1 OF locales.cdx

   IF SEEK(m.localrep)
      @ 20,20 SAY PADR(ALLTRIM(locales.nombre), 14, CHR(32)) ;
         SIZE 1,14 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 20,20 SAY REPLICATE(CHR(32), 14) ;
         SIZE 1,14 ;
         PICTURE "@!" ;
         COLOR W/N

      SELECT (pnSelect)
      SET ORDER TO TAG (pcOrder)
      IF pnRecNo <> 0
         GOTO RECORD pnRecNo
      ENDIF

      RETURN .F.
   ENDIF   
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldReferencia
*!
*!  Llamado por: MKMOVIOT.PRG                
*!
*!  Descripci¢n: Validaci¢n del campo referencia.             
*!
*!*********************************************************************
FUNCTION _vldReferencia
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

IF EMPTY(m.referencia)
   WAIT WINDOW "­ LA REFERENCIA NO PUEDE QUEDAR EN BLANCO !"
   RETURN .F.
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldMecanico
*!
*!  Llamado por: MKMOVIOT.PRG                
*!
*!  Descripci¢n: Validaci¢n del campo mecanicos.        
*!
*!*********************************************************************
FUNCTION _vldMecanico
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

PRIVATE pnSelect, pcOrder, pnRecNo

pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

IF m.mecanico <= 0
   @ 04,19 SAY REPLICATE(CHR(32), 26) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR W/N
   DO meca_pop.spr WITH "m.mecanico", 0, .F., ""
ENDIF

IF m.mecanico = 0
   RETURN .F.
ENDIF

SELECT mecanico
SET ORDER TO TAG indice1 OF mecanico.cdx

IF SEEK(m.mecanico)
   @ 04,19 SAY PADR(ALLTRIM(mecanico.nombre), 26, CHR(32)) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 04,19 SAY REPLICATE(CHR(32), 26) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE MECANICO INEXISTENTE !"   
   DO meca_pop.spr WITH "m.mecanico", 0, .F., ""
   SHOW GETS

   SELECT mecanico
   SET ORDER TO TAG indice1 OF mecanico.cdx

   IF SEEK(m.mecanico)
      @ 04,19 SAY PADR(ALLTRIM(unidad.nombre), 26, CHR(32)) ;
         SIZE 1,26 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 04,19 SAY REPLICATE(CHR(32), 26) ;
         SIZE 1,26 ;
         PICTURE "@!" ;
         COLOR W/N

      SELECT (pnSelect)
      SET ORDER TO TAG (pcOrder)
      IF pnRecNo <> 0
         GOTO RECORD pnRecNo
      ENDIF

      RETURN .F.
   ENDIF   
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldEstadoOt
*!
*!  Llamado por: MKMOVIOT.PRG                
*!
*!  Descripci¢n: VALID del campo m.estadoot
*!
*!*********************************************************************
FUNCTION _vldEstadoOt
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

PRIVATE pnSelect, pcOrder, pnRecNo

pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

IF m.estadoot <= 0
   @ 04,63 SAY REPLICATE(CHR(32), 15) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR W/N
   DO esot_pop.spr WITH "m.estadoot", 0, .F.
ENDIF

IF m.estadoot = 0
   RETURN .F.
ENDIF

SELECT estadoot
SET ORDER TO TAG indice1 OF estadoot.cdx

IF SEEK(m.estadoot)
   @ 04,63 SAY PADR(ALLTRIM(estadoot.nombre), 15, CHR(32)) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 04,63 SAY REPLICATE(CHR(32), 15) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE ESTADO DE LA OT INEXISTENTE !"   
   DO esot_pop.spr WITH "m.estadoot", 0, .F.
   SHOW GETS

   SELECT estadoot
   SET ORDER TO TAG indice1 OF estadoot.cdx

   IF SEEK(m.estadoot)
      @ 04,63 SAY PADR(ALLTRIM(estadoot.nombre), 15, CHR(32)) ;
         SIZE 1,15 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 04,63 SAY REPLICATE(CHR(32), 15) ;
         SIZE 1,15 ;
         PICTURE "@!" ;
         COLOR W/N

      SELECT (pnSelect)
      SET ORDER TO TAG (pcOrder)
      IF pnRecNo <> 0
         GOTO RECORD pnRecNo
      ENDIF

      RETURN .F.
   ENDIF   
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldEstadoOt
*!
*!  Llamado por: MKMOVIOT.PRG                
*!
*!  Descripci¢n: VALID del campo m.estadoot
*!
*!*********************************************************************
FUNCTION _vldObs2
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

SHOW GETS

DO _brwLoadDetail

IF pnSubTotal = 0
   WAIT WINDOW "­ EL SUBTOTAL DEBE SER MAYOR QUE CERO !"
   _CUROBJ = OBJNUM(m.serie)
ELSE
   DO _SaveInvoice
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldbrwMecanico
*!
*!  Llamado por: MKMOVIOT.PRG                
*!
*!  Descripci¢n: Validaci¢n del campo mecanicos.        
*!
*!*********************************************************************
FUNCTION _vldbrwMecanico
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

PRIVATE pnSelect, pcOrder, pnRecNo

pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

IF tmpdetmot.mecanico <= 0
   DO meca_pop.spr WITH "tmpdetmot.mecanico", 0, .T., tmpdetmot.articulo
ENDIF

IF tmpdetmot.mecanico = 0
   RETURN .F.
ENDIF

SELECT mecanico
SET ORDER TO TAG indice1 OF mecanico.cdx

IF .NOT. SEEK(tmpdetmot.mecanico)
   WAIT WINDOW "­ CODIGO DE MECANICO INEXISTENTE !"   

   SELECT (pnSelect)
   SET ORDER TO TAG (pcOrder)
   IF pnRecNo <> 0
      GOTO RECORD pnRecNo
   ENDIF

   RETURN .F.
ELSE
   PRIVATE pcSetExact, pnMecanico, plFound

   IF SET("EXACT") = "OFF"
      SET EXACT ON 
      pcSetExact = "OFF"
   ELSE
      pcSetExact = "ON"
   ENDIF

   pnMecanico = tmpdetmot.mecanico
   plFound    = .F.

   SELECT mecancfg
   SET ORDER TO indice1 OF mecancfg.cdx
   SET RELATION OFF INTO maesprod
   SET RELATION OFF INTO servicio

   IF SEEK(tmpdetmot.mecanico)
      SCAN WHILE mecancfg.mecanico = pnMecanico
         IF mecancfg.articulo = tmpdetmot.articulo
            plFound = .T.
            EXIT
         ENDIF
      ENDSCAN
   ENDIF            
   
   SELECT mecancfg
   SET RELATION TO mecancfg.articulo INTO maesprod ADDITIVE
   SET RELATION TO mecancfg.articulo INTO servicio 

   IF pcSetExact = "OFF"
      SET EXACT OFF
   ENDIF
   
   IF .NOT. plFound
      WAIT WINDOW "EL MECANICO SELECCIONADO NO POSEE ESTA CONFIGURACION DE MANO DE OBRA !"

      SELECT (pnSelect)
      SET ORDER TO TAG (pcOrder)
      IF pnRecNo <> 0
         GOTO RECORD pnRecNo
      ENDIF
      
      RETURN .F.
   ENDIF
      
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _SaveInvoice
*!
*!  Llamado por: CUOTVENT.SPR                 
*!
*!  Descripci¢n: Graba el comprobante de venta.
*!
*!        Pasos: 1. Grabar encabezado.
*!               2. Actualizar el saldo del cliente,  si es una venta a 
*!                  cr‚dito.                                     
*!               3. Grabar el detalle y actualizar la existencia de las 
*!                  mercader¡as.
*!               4. Grabar la(s) cuota(s), si es una venta a cr‚dito.
*!  
*!*********************************************************************
FUNCTION _SaveInvoice

IF plEditing
   DO _DeleteInvoice
ENDIF

*-- Graba el encabecezado.
SELECT cabemot

INSERT INTO cabemot (tipobole, serie, nrobole, fecha, lstprecio, monto_fact, obs1, obs2) ;
   VALUES (2, m.serie, m.nrobole, m.fecha, m.lstprecio, m.monto_fact, m.obs1, m.obs2)
   
*-- Actualiza los datos en la orden de trabajo.
SELECT ot

REPLACE ot.mecanico   WITH m.mecanico
REPLACE ot.estadoot   WITH m.estadoot
REPLACE ot.localrep   WITH m.localrep
REPLACE ot.referencia WITH m.referencia

*-- Graba el detalle y actualiza el stock de art¡culos.
SELECT tmpdetmot
GO TOP

SCAN ALL
   IF .NOT. (EMPTY(tmpdetmot.articulo) .OR. ;
           EMPTY(tmpdetmot.cantidad) .OR. ;
           EMPTY(tmpdetmot.precio))

      INSERT INTO detamot (tipobole, serie, nrobole, articulo, cantidad, precio, impuesto, pimpuesto, mecanico, descr_trab) ;
         VALUES (2, m.serie, m.nrobole, tmpdetmot.articulo, tmpdetmot.cantidad, tmpdetmot.precio, tmpdetmot.impuesto, tmpdetmot.pimpuesto, tmpdetmot.mecanico, tmpdetmot.descr_trab)
         
      *-- Actualiza la existencia de mercader¡as.
      SELECT maesprod
      SET ORDER TO TAG indice1 OF maesprod.cdx

      IF SEEK(detamot.articulo)
         REPLACE maesprod.stock_ot WITH (maesprod.stock_actu - detamot.cantidad)
      ENDIF
         
      SELECT tmpdetmot
      ENDIF
ENDSCAN
   
SELECT cabemot 

STORE .F. TO plAdding, plEditing

WAIT WINDOW "­ EL MOVIMIENTO DE LA OT FUE GRABADA !" TIMEOUT 0.75

CLEAR READ

*!*********************************************************************
*!
*!      Funci¢n: _DeleteInvoice 
*!
*!  Llamado por: CUOTVENT.SPR     
*!
*!  Descripci¢n: Borra las cuotas, el detalle y  el  encabezado  de  la 
*!               venta.
*!
*!*********************************************************************
FUNCTION _DeleteInvoice

PUSH KEY CLEAR

*-- Borra detalle del comprobante de venta y actualiza la existencia de mercader¡as.
SELECT detamot
SET ORDER TO TAG indice1 OF detamot.cdx

IF SEEK(STR(cabemot.tipobole, 1) + cabemot.serie + STR(cabemot.nrobole, 7))
   SCAN WHILE (STR(cabemot.tipobole, 1) + cabemot.serie + STR(cabemot.nrobole, 7)) = (STR(detamot.tipobole, 1) + detamot.serie + STR(detamot.nrobole, 7))
      SELECT maesprod
      SET ORDER TO TAG indice1 OF maesprod.cdx

      IF SEEK(detamot.articulo)
         REPLACE maesprod.stock_ot WITH (maesprod.stock_ot + detamot.cantidad)
      ELSE
         WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL ARTICULO: " + ALLTRIM(detamot.articulo) + " !"
      ENDIF
      SELECT detamot
      DELETE
   ENDSCAN
ELSE
   IF cabemot.tipobole <> 0 .AND. cabemot.nrobole <> 0
      WAIT WINDOW "­ NO SE HA ENCONTRADO DETALLE A BORRAR !"
   ENDIF
ENDIF
  
*-- Actualiza el saldo del cliente, si es un comprobante de venta a cr‚dito.
 
*-- Borra el encabezado del comprobante de venta.
SELECT cabemot
SET ORDER TO TAG indice1 OF cabemot.cdx

IF SEEK(STR(m.tipobole, 1) + m.serie + STR(m.nrobole, 7))
   SCAN WHILE (STR(m.tipobole, 1) + m.serie + STR(m.nrobole, 7)) = (STR(cabemot.tipobole, 1) + cabemot.serie + STR(cabemot.nrobole, 7))
      DELETE
   ENDSCAN
ENDIF

POP KEY

*!*********************************************************************
*!
*!      Funci¢n: _DeleteInvoice 
*!
*!  Llamado por: CUOTVENT.SPR     
*!
*!  Descripci¢n: Borra las cuotas, el detalle y  el  encabezado  de  la 
*!               venta.
*!
*!*********************************************************************
FUNCTION _whenFecha          
SET NOTIFY ON