*!*********************************************************************
*!
*!      Funci¢n: _AddInvoice 
*!
*!  Llamado por: VENTAS.PRG       
*!
*!  Descripci¢n: Agrega un nuevo documento de venta.
*!
*!*********************************************************************
*FUNCTION _AddInvoice
*PUSH KEY CLEAR

SCATTER MEMVAR MEMO BLANK

STORE 0 TO pnGravada, pnExenta, pnImpuesto, pnSubTotal, m.tipodocu, m.nrodocu, m.moneda, m.cambio, m.nroremi, m.dias_plazo, m.cliente, m.cliente2, m.vendedor, m.comision_v, m.porcdesc, m.importdesc, m.monto_fact, m.monto_cobr, m.monto_ndeb, m.monto_ncre, m.nroot

plAdding = .t.

SELECT tmpdetvent
ZAP

m.fechadocu = DTOC(DATE()) 
STORE 1 TO m.lstprecio, m.moneda

DO _fmtInvoice

@ 02,15 GET m.tipodocu ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN plAdding ;
   VALID _vldTipoDocu() ;
   COLOR SCHEME 1

@ 02,47 GET m.nrodocu ;
   SIZE 1,7 ;
   DEFAULT 0 ;
   PICTURE "9999999" ;
   WHEN plAdding ;
   VALID _vldNroDocu() ;
   COLOR SCHEME 1

@ 02,77 GET m.lstprecio ;
   SIZE 1,1 ;
   DEFAULT 1 ;
   PICTURE "9" ;
   WHEN plAdding ;
   VALID _vldLstPrecio() ;
   COLOR SCHEME 1

@ 03,15 GET m.fechadocu ;
   SIZE 1,10 ;
   DEFAULT DTOC(DATE()) ;
   PICTURE "99/99/9999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldFechaDocu() ;
   COLOR SCHEME 1

@ 03,47 GET m.serie ;
   SIZE 1,1 ;
   DEFAULT "" ;
   PICTURE "@A!" ;
   WHEN plAdding .OR. plEditing ;   
   COLOR SCHEME 1

@ 03,49 GET m.nroot ;
   SIZE 1,7 ;
   DEFAULT 0 ;
   PICTURE "9999999" ;
   COLOR SCHEME 1

@ 05,15 GET m.cliente  ;
   SIZE 1,5 ;
   DEFAULT 0 ;
   PICTURE "99999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldCliente() ;
   COLOR SCHEME 1
   
@ 06,15 GET m.moneda ;
   SIZE 1,4 ;
   DEFAULT 0 ;
   PICTURE "9999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldMoneda() ;
   COLOR SCHEME 1
   
@ 06,68 GET m.tipocambio ;
   SIZE 1,09 ;
   DEFAULT 0 ;
   PICTURE "999999.99" ;
   WHEN (plAdding .OR. plEditing) .AND. m.moneda # 1 ;
   VALID _vldTipoCambio() ;
   COLOR SCHEME 1

@ 07,15 GET m.vendedor ;
   SIZE 1,3 ;
   DEFAULT 0 ;
   PICTURE "999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldVendedor() ;
   COLOR SCHEME 1
   
@ 07,68 GET m.comision_v ;
   SIZE 1,6 ;
   DEFAULT 0 ;
   PICTURE "999.99" ;
   WHEN .F. ;
   VALID _vldComision_V() ;
   COLOR SCHEME 1

@ 19,68 SAY pnSubTotal ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

@ 20,46 GET m.porcdesc ;
   SIZE 1,8 ;
   DEFAULT 0 ;
   PICTURE "999.9999" ;
   WHEN (plAdding .OR. plEditing) ;
   VALID _vldPorcDesc() ;
   COLOR SCHEME 1   

@ 20,68 GET m.importdesc ;
   SIZE 1,11 ;
   DEFAULT 0 ;
   PICTURE "999,999,999" ;
   WHEN (plAdding .OR. plEditing) .AND. m.porcdesc = 0 ; 
   VALID _vldImportDesc() ;
   COLOR SCHEME 1   

@ 21,68 SAY pnImpuesto ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W     

@ 22,68 SAY m.monto_fact ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

READ CYCLE ;
   MODAL ;
   VALID _vldReadCycle() ;
   COLOR , W+/BG 

*!*********************************************************************
*!
*!      Funci¢n: _vldTipoDocu
*!
*!  Llamado por: _AddInvoice      
*!
*!  Descripci¢n: Validaci¢n del campo tipo de documento.
*!
*!*********************************************************************
FUNCTION _vldTipoDocu
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_F1, K_BSPACE)
   RETURN .F.
ENDIF

IF m.tipodocu > 4 
   @ 02,18 SAY REPLICATE(CHR(32), 21) ;
      SIZE 1,21 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ EL TIPO DE DOCUMENTO DE VENTA DEBE SER: 1, 2, 3 à 4 !"
   RETURN .F.
ENDIF   

IF m.tipodocu <= 0
   @ 02,18 SAY REPLICATE(CHR(32), 21) ;
      SIZE 1,21 ;
      PICTURE "@!" ;
      COLOR W/N
   DO vttipodo.spr WITH "m.tipodocu", 0, .F.
ENDIF

IF m.tipodocu = 0
   RETURN .F.
ENDIF

DO CASE
   CASE m.tipodocu = 1
      @ 02,18 SAY "VENTA CONTADO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
      m.nrodocu = NextNumber()
   CASE m.tipodocu = 2
      @ 02,18 SAY "VENTA CREDITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
      m.nrodocu = NextNumber()
   CASE m.tipodocu = 3
      @ 02,18 SAY "VENTA I.V.A. INCLUIDO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
      m.nrodocu = NextNumber()
   CASE m.tipodocu = 4
      @ 02,18 SAY "VENTA TRIBUTO UNICO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
      m.nrodocu = NextNumber()
   OTHERWISE
      @ 02,18 SAY REPLICATE(CHR(32), 21) ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
      m.nrodocu = 0
ENDCASE


*!*********************************************************************
*!
*!      Funci¢n: _vldNroDocu
*!
*!  Llamado por: _AddInvoice                 
*!
*!  Descripci¢n: Validaci¢n del campo n£mero de documento.    
*!
*!*********************************************************************
FUNCTION _vldNroDocu
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_F1, K_BSPACE)
   RETURN .T.
ENDIF

IF m.nrodocu <= 0
   WAIT WINDOW "­ EL N§ DEL DOCUMENTO DEBE SER MAYOR QUE CERO !"
   RETURN .F.
ENDIF

DO SaveWorkArea

SELECT cabevent
SET ORDER TO TAG indice1 OF cabevent.cdx
IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7))
   WAIT WINDOW "­ ESTA VENTA YA HA SIDO CARGADA !"
   DO RestoreWorkArea
   RETURN .F.
ENDIF

DO RestoreWorkArea


*!*********************************************************************
*!
*!      Funci¢n: NextNumber 
*!
*!  Llamado por: _AddInvoice                  
*!
*!  Descripci¢n: Obtiene el pr¢ximo n£mero  de  comprobante  de  venta,
*!               disponible,  teniendo en cuenta el tipo  de boleta.
*!
*!*********************************************************************
FUNCTION NextNumber

DO SaveWorkArea

SELECT cabevent
SET ORDER TO TAG indice1 OF cabevent.cdx DESCENDING

IF SEEK(STR(m.tipodocu, 1))
   NextCode = cabevent.nrodocu + 1
ELSE
   NextCode = 1
ENDIF

SET ORDER TO TAG indice1 OF cabevent.cdx ASCENDING

DO RestoreWorkArea

RETURN (NextCode)



*!*********************************************************************
*!
*!      Funci¢n: _vldFechaDocu
*!
*!  Llamado por: _AddInvoice                  
*!
*!  Descripci¢n: Validaci¢n del campo fecha de documento.
*!
*!*********************************************************************
FUNCTION _vldFechaDocu
IF INLIST(LASTKEY(), K_UP, K_LEFT)
   RETURN .T.
ENDIF

PRIVATE pnDia, pnMes, pnAnyo

IF m.fechadocu = "00/00/0000" .OR. m.fechadocu = "  /  /    "
   WAIT WINDOW "­ FECHA INVALIDA !"
   RETURN .F.
ELSE
   STORE VAL(SUBSTR(m.fechadocu,1,2)) TO pnDia
   STORE VAL(SUBSTR(m.fechadocu,4,2)) TO pnMes

   IF VAL(SUBSTR(m.fechadocu,7,4)) < 1000
      pnAnyo = YEAR(DATE())
   ELSE
      pnAnyo = VAL(SUBSTR(m.fechadocu,7,4))
   ENDIF

   m.fechadocu = IIF(pnDia > 0 .AND. pnDia < 10, "0"+STR(pnDia,1), STR(pnDia,2)) +  "/"+ IIF(pnMes > 0 .AND. pnMes < 10, "0"+STR(pnMes,1), STR(pnMes,2)) + "/"+ STR(pnAnyo,4)

   IF pnDia  < 1    .OR. pnDia  > 31 .OR.;
      pnMes  < 1    .OR. pnMes  > 12 .OR.;
      pnAnyo < 1900 .OR. pnAnyo > 2500
      WAIT WINDOW "­ FECHA INVALIDA !"
      RETURN .F.
   ELSE
      DO CASE
         CASE INLIST(pnMes, 1, 3, 5, 7, 8, 10, 12)
            IF pnDia <= 31
               RETURN .T.
            ELSE
               WAIT WINDOW "­ FECHA INVALIDA !"
               RETURN .F.
            ENDIF 
         CASE pnMes = 2
            IF MOD(pnAnyo,4) # 0
               IF pnDia <= 28
                  RETURN .T.
               ELSE
                  WAIT WINDOW "­ FECHA INVALIDA !"
                  RETURN .F.
               ENDIF
            ELSE
               IF MOD(pnAnyo,100) = 0 .AND. MOD(pnAnyo,400) # 0
                  IF pnDia <= 28
                     RETURN .T.
                  ENDIF
               ELSE
                  IF pnDia <= 29
                     RETURN .T.
                  ELSE
                     WAIT WINDOW "­ FECHA INVALIDA !"
                     RETURN .F.
                  ENDIF
               ENDIF 
            ENDIF
         CASE INLIST(pnMes, 4, 6, 9, 11)
            IF pnDia <= 30
               RETURN .T.
            ELSE
               WAIT WINDOW "­ FECHA INVALIDA !"
               RETURN .F.
            ENDIF
            RETURN .T.
      ENDCASE
   ENDIF
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldLstPrecio
*!
*!  Llamado por: _AddInvoice                  
*!
*!  Descripci¢n: Validaci¢n del liste de precio.
*!
*!*********************************************************************
FUNCTION _vldLstPrecio
IF INLIST(LASTKEY(), K_UP, K_LEFT)
   RETURN .T.
ENDIF

IF m.lstprecio <= 0
   WAIT WINDOW "­ LA LISTA DE PRECIOS DEBE SER 1, 2, 3, 4 à 5 !"
   RETURN .F.
ENDIF


*!*********************************************************************
*!
*!      Funci¢n: _vldCliente
*!
*!  Llamado por: _AddInvoice                  
*!
*!  Descripci¢n: Validaci¢n del campo cliente.
*!
*!*********************************************************************
FUNCTION _vldCliente
IF INLIST(LASTKEY(), K_UP, K_LEFT)
   RETURN .T.
ENDIF

IF m.cliente <= 0
   @ 05,22 SAY REPLICATE(CHR(32), 56) ;
      SIZE 1,56 ;
      PICTURE "@!" ;
      COLOR W/N

   PUSH KEY CLEAR
   ON KEY LABEL "ENTER" KEYBOARD "{CTRL+W}"
   DO _brwClientes
   ON KEY LABEL "ENTER" 
   POP KEY

   IF NOT LASTKEY() = K_ESCAPE
      m.cliente = clientes.codigo    
   ELSE 
      RETURN .F.
   ENDIF

ENDIF

IF m.cliente = 0
   RETURN .F.
ENDIF

DO SaveWorkArea

SELECT clientes
SET ORDER TO TAG indice1 OF clientes.cdx
IF SEEK(m.cliente)
   @ 05,22 SAY PADR(ALLTRIM(clientes.nombre), 56, CHR(32)) ;
      SIZE 1,56 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 05,22 SAY REPLICATE(CHR(32), 56) ;
      SIZE 1,56 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE CLIENTE INEXISTENTE !"
ENDIF

DO RestoreWorkArea

*!*********************************************************************
*!
*!      Funci¢n: _brwClientes   
*!
*!  Llamado por: _vldCliente
*!
*!  Descripci¢n: Abre una ventana de inspecci¢n para visualizar la lis-
*!               ta de clientes.
*!
*!*********************************************************************
FUNCTION _brwClientes
*-- MS-DOS Definiciones de ventanas.
IF NOT WEXIST("brwClientes")
   DEFINE WINDOW brwClientes ;
      FROM 01,00 ;
      TO   23,79 ;
      TITLE "< CLIENTES >" ;
      SYSTEM ;
      CLOSE ;
      FLOAT ;
      GROW ;
      MDI ;         
      NOMINIMIZE ;
      SHADOW ;
      ZOOM ;
      COLOR SCHEME 15
      *COLOR "W+/BG,GR+/RB,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,,," 
ENDIF

DO SaveWorkArea

SELECT clientes
SET ORDER TO TAG indice2 OF clientes.cdx
GO TOP
                
*-- MS-DOS Macros de teclado.
ON KEY LABEL "F2" DO clientes.prg WITH "Add"
ON KEY LABEL "F3" DO clientes.prg WITH "Edit"
ON KEY LABEL "F4" DO cliorden.spr
ON KEY LABEL "F5" DO switch.prg WITH ALIAS()
ON KEY LABEL "F8" DO clientes.prg WITH "Delete"
ON KEY LABEL "CTRL+ENTER" DO clientes.prg WITH "Consult"
ON KEY LABEL "CTRL+HOME"  GO TOP
ON KEY LABEL "CTRL+END"   GO BOTTOM

DO SaveScreen
@ 00,00 TO 00,79 CHR(32)
@ 24,00 TO 24,79 CHR(32)
DO _Center WITH 00, gcLocal, "W/N"

BROWSE WINDOW brwClientes FIELDS ;
   codigo                              :R:06:H = "C¢digo"             :P = "999999" ,;
   calc_f1 = SUBSTR(nombre, 1, 54)     :R:54:H = "Nombre"             :P = "@!" ,;
   saldo_actu                          :R:14:H = " Saldo Actual"      :P = "99,999,999,999" ,;
   calc_f2 = SUBSTR(ruc, 1, 12)        :R:12:H = "R.U.C." ,;
   calc_f3 = SUBSTR(telefono, 1, 30)   :R:30:H = "Tel‚fono" ,;
   calc_f4 = SUBSTR(documento, 1, 15)  :R:15:H = "Documento Clie" ,;
   calc_f5 = SUBSTR(nombre_c, 1, 50)   :R:50:H = "Nombre del C¢nyuge" :P = "@!" ,;
   calc_f6 = SUBSTR(docconyuge, 1, 15) :R:15:H = "Documento Cony" ,;
   calc_f7 = SUBSTR(nombre_g, 1, 50)   :R:50:H = "Nombre del Garante" :P = "@!" ,;
   calc_f8 = SUBSTR(docgarante, 1, 15) :R:15:H = "Documento Garan" ;
   NOAPPEND NODELETE NOMODIFY

DO RestoreScreen
SET ORDER TO TAG indice1 OF clientes.cdx

*-- MS-DOS Restablece macros de teclado.
ON KEY LABEL "F2" 
ON KEY LABEL "F3" 
ON KEY LABEL "F4"
ON KEY LABEL "F5"
ON KEY LABEL "F8" 
ON KEY LABEL "CTRL+ENTER"
ON KEY LABEL "CTRL+HOME" 
ON KEY LABEL "CTRL+END"  

DO RestoreWorkArea

return

















*!*********************************************************************
*!
*!      Funci¢n: _vldCodigo
*!
*!  Llamado por: _AddInvoice                 
*!
*!  Descripci¢n: Validaci¢n del campo de detalle codigo.      
*!
*!*********************************************************************
*FUNCTION _vldCodigo
PARAMETER pnCodigo
IF LASTKEY() = 24
   RETURN .T.
ENDIF   
IF LASTKEY() = -7
   RETURN .T.
ENDIF  

PRIVATE pcCurrSelect, pcCurrOrder, pnCurrRecord
	
pcCurrSelect = SELECT()
pcCurrOrder  = ORDER()
pnCurrRecord = IIF(EOF(),0,RECNO())

IF EMPTY(pnCodigo)
   DO maes_pop.spr WITH "tmpdetvent.articulo", "", .T.
   IF LASTKEY() # 27 .AND. .NOT. EMPTY(tmpdetvent.articulo)
      IF maesprod.pimpuesto > 10
         WAIT WINDOW "­ PORCENTAJE DE IMPUESTO INVALIDO !"
         RETURN .F.
      ENDIF
      IF .NOT. (ALLTRIM(maesprod.codigo) = "99015" .OR. ALLTRIM(maesprod.codigo) = "99016")
         IF EMPTY(tmpdetvent.precio)
            IF m.moneda = 1     && Guaran¡es.
               REPLACE tmpdetvent.precio    WITH maesprod.pcostog
            ELSE
               IF m.moneda = 2     && D¢lares Americanos.
                  REPLACE tmpdetvent.precio    WITH maesprod.pcostod
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      REPLACE tmpdetvent.impuesto  WITH maesprod.impuesto
      REPLACE tmpdetvent.pimpuesto WITH maesprod.pimpuesto
      RETURN 
   ELSE
      RETURN .F.
   ENDIF
ENDIF

SELECT maesprod
   SET ORDER TO TAG indice1 OF maesprod.cdx
IF SEEK(pnCodigo)
   SET ORDER TO TAG indice1 OF maesprod.cdx
   REPLACE tmpdetvent.articulo WITH maesprod.codigo
   IF maesprod.pimpuesto > 10
      WAIT WINDOW "­ PORCENTAJE DE IMPUESTO INVALIDO !"
      RETURN .F.
   ENDIF
   IF .NOT. (ALLTRIM(maesprod.codigo) = "99015" .OR. ALLTRIM(maesprod.codigo) = "99016")
      IF EMPTY(tmpdetvent.precio)
         IF m.moneda = 1     && Guaran¡es.
            REPLACE tmpdetvent.precio    WITH maesprod.pcostog
         ELSE
            IF m.moneda = 2     && D¢lares Americanos.
               REPLACE tmpdetvent.precio    WITH maesprod.pcostod
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   REPLACE tmpdetvent.impuesto  WITH maesprod.impuesto
   REPLACE tmpdetvent.pimpuesto WITH maesprod.pimpuesto
   @ 19,12 SAY rubros1.nombre ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
   @ 20,12 SAY IIF(maesprod.impuesto, "S¡   " + STR(maesprod.pimpuesto,6,2)+ " %", "No") ;
      SIZE 1,13 ;
      COLOR W/N  
   @ 21,12 SAY maesprod.stock_actu ;
      SIZE 1,11 ;
      PICTURE "99999999.99" ;
      COLOR W/N      

   SELECT (pcCurrSelect)
   SET ORDER TO TAG (pcCurrOrder)
   IF pnCurrRecord # 0
      GOTO RECORD pnCurrRecord
   ENDIF
ELSE 
   SET ORDER TO TAG indice1 OF maesprod.cdx
   WAIT WINDOW "­ CODIGO DE ARTICULO INEXISTENTE !"
   SELECT (pcCurrSelect)
   SET ORDER TO TAG (pcCurrOrder)
   IF pnCurrRecord # 0
      GOTO RECORD pnCurrRecord
   ENDIF
   RETURN .F.
ENDIF


FUNCTION _vldCantidad
PARAMETER pnCantidad

IF pnCantidad = 0
   WAIT WINDOW "­ LA CANTIDAD DEBE SER MAYOR QUE CERO !"
   RETURN .F.
ENDIF         


FUNCTION _vldPrecio
PARAMETER pnPrecio
IF pnPrecio = 0
   WAIT WINDOW "­ EL PRECIO DEBE SER MAYOR QUE CERO !"
   RETURN .F.
ENDIF         



FUNCTION _DeleteLine
PRIVATE pcCurrSelect, pcCurrOrder
	
pcCurrSelect = SELECT()
pcCurrOrder  = ORDER()

SELECT tmpdetvent
DELETE 
PACK
IF RECCOUNT() = 0
   INSERT INTO tmpdetvent (tipodocu, nrodocu, articulo, cantidad, precio, impuesto, pimpuesto, serie, mecanico, descr_trab) ;
      VALUES (0, 0, "", 0, 0, .F., 0, "", 0, "")
ENDIF

SELECT (pcCurrSelect)
SET ORDER TO TAG (pcCurrOrder)
DO _InvoiceFoot


FUNCTION _brwLoadDetail
PRIVATE pcCurrSelect, pcCurrOrder, pnCurrRecord
	
pcCurrSelect = SELECT()
pcCurrOrder  = ORDER()
pnCurrRecord = IIF(EOF(),0,RECNO())

SELECT tmpdetvent

IF RECCOUNT() = 0
   INSERT INTO tmpdetvent (tipodocu, nrodocu, articulo, cantidad, precio, impuesto, pimpuesto, serie, mecanico, descr_trab) ;
      VALUES (0, 0, "", 0, 0, .F., 0, "", 0, "")
ENDIF

ON KEY LABEL "F8" DO _DeleteLine

DO WHILE LASTKEY() # 27
   @ 19,12 CLEAR TO 21,41
   
   @ 09,01 CLEAR TO 17,40     && Descripci¢n.
   @ 09,42 CLEAR TO 17,51     && Cantidad.
   @ 09,53 CLEAR TO 17,67     && Precio Unit.
   @ 09,69 CLEAR TO 17,78     && Importe.

   GO BOTTOM
   BROWSE WINDOW tmpdetvent FIELDS ;
      articulo                                   :13:H = "C¢digo"                                 :V = _vldCodigo(articulo):F ,;
      calc_f1 = SUBSTR(maesprod.nombre, 1, 37) :R:37:H = "Descripci¢n"  :W = .F. ,;
      cantidad                                   :08:H = "Cantidad"     :P = "99999.99"           :V = _vldCantidad(cantidad):F ,;
      precio                                     :15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = _whenPrecioUnit(articulo) :V = _vldPrecio(precio):F  ,;
      calc_f2 = ROUND(precio * cantidad, 0)      :11:H = " Sub-Total"   :P = "999,999,999" :W = _whenSubTotal(articulo) :V = _vldAddNewLine() :F ,;
      mecanico                                   :03:H = "Mec"          :P = "999"    :V = _vldMecanico(mecanico):F ,;
      calc_f3 = SUBSTR(mecanico.nombre, 1, 30) :R:30:H = "Nombre del Mec nico" :W = .F. ,;
      descr_trab                                 :40:H = "Descripci¢n de Trabajo" :P = "@!" :V = _vldAddNewLine() :F ;
      NODELETE NOAPPEND 
ENDDO

ON KEY LABEL "F8"

SELECT (pcCurrSelect)
SET ORDER TO TAG (pcCurrOrder)
IF pnCurrRecord # 0
   GOTO RECORD pnCurrRecord
ENDIF

DO _printDetail

*------------------------------------------------------------
*------------------------------------------------------------
*!*********************************************************************
*!
*!      Funci¢n: _InvoiceFoot   
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Calcula e imprime el pie del comprobante.
*!
*!*********************************************************************
FUNCTION _InvoiceFoot

DO SaveWorkArea

SELECT tmpdetvent

STORE 0 TO pnGravada, pnExenta, pnImpuesto, pnSubTotal, m.monto_fact

GO TOP
SCAN ALL
   DO CASE
      CASE impuesto .AND. pimpuesto > 0 .AND. pimpuesto < 10
         pnGravada = pnGravada + ROUND(precio * cantidad,0) * (pimpuesto * 10 / 100)
         pnExenta  = pnExenta + ROUND(precio * cantidad,0) * (1 - (pimpuesto * 10 / 100))
      CASE impuesto .AND. pimpuesto = 10
         pnGravada = pnGravada + ROUND(precio * cantidad,0)            
      CASE .NOT. impuesto .AND. pimpuesto = 0
         pnExenta = pnExenta + ROUND(precio * cantidad,0)
   ENDCASE
ENDSCAN

pnSubTotal = pnGravada + pnExenta
IF m.importdesc > 0 .AND. m.porcdesc = 0
   pnDescGrav   = ROUND(m.importdesc * ROUND(pnGravada * 100 / pnSubTotal, 2) / 100, 0)
   pnDescExen   = m.importdesc - pnDescGrav
   pnSubTota1   = pnSubTotal - m.importdesc
   pnImpuesto   = ROUND((pnGravada - pnDescGrav) * 0.1, 0)
   m.monto_fact = pnSubTota1 + pnImpuesto
ELSE
   IF m.porcdesc > 0
      pnDescGrav   = ROUND((pnGravada * (m.porcdesc / 100)),0)
      pnDescExen   = ROUND((pnExenta * (m.porcdesc / 100)),0)
      m.importdesc = pnDescGrav + pnDescExen
      pnSubTota1   = pnGravada - pnDescGrav + pnExenta - pnDescExen
      pnImpuesto   = ROUND(((pnGravada * (1 - (m.porcdesc / 100))) * 0.1),0)
      m.monto_fact = pnSubTota1 + pnImpuesto
   ELSE
      IF m.importdesc = 0 .AND. m.porcdesc = 0
         pnImpuesto   = ROUND(pnGravada * 0.1,0)
         m.monto_fact = pnSubTotal + pnImpuesto
      ENDIF
   ENDIF
ENDIF


@ 19,68 SAY pnSubTotal ;
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
   COLOR N/W
SHOW GETS

DO RestoreWorkAra

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

DO SaveWorkArea

#DEFINE pnRow    8
#DEFINE pnColumn 2

SELECT tmpdetvent
GO TOP

SCAN WHILE RECNO() <= 9 .AND. .NOT. (EMPTY(articulo) .OR. EMPTY(cantidad) .OR. EMPTY(precio))
   @ pnRow + RECNO(), pnColumn      SAY SUBSTR(maesprod.nombre, 1, 39)                                                 COLOR N/W
   @ pnRow + RECNO(), pnColumn + 40 SAY cantidad                       PICTURE "999,999.99"      COLOR N/W
   @ pnRow + RECNO(), pnColumn + 51 SAY precio                         PICTURE "99,999,999.9999" COLOR N/W
   @ pnRow + RECNO(), pnColumn + 67 SAY ROUND(precio * cantidad, 0)    PICTURE "99,999,999"      COLOR N/W
ENDSCAN

DO RestoreWorkArea

FUNCTION _ConfirmOff
*SET CONFIRM OFF

FUNCTION _ConfirmOn
*SET IRM ON


FUNCTION _vldReadCycle
IF LASTKEY() = 27 
   IF LOWER(SYS(18)) = "porcdesc" .OR. LOWER(SYS(18)) = "importdesc"
      _CUROBJ = OBJNUM(m.porcdesc)      
      RETURN .F.
   ENDIF
ENDIF

FUNCTION _vldMoneda
PRIVATE pcSelect, pcOrder, pnRecNo

pcSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

IF INLIST(LASTKEY(), 5, 19))
   RELEASE pcSelect, pcOrder, pnRecNo
   RETURN .T.
ENDIF

IF m.moneda <= 0
   @ 06,22 SAY REPLICATE(CHR(32), 28) ;
      SIZE 1,28 ;
      PICTURE "@!" ;
      COLOR W/N
   DO mone_pop.spr WITH "m.moneda", 0, .F.
ENDIF

IF m.moneda = 0
   RETURN .F.
ENDIF

SELECT monedas
SET ORDER TO TAG indice1 OF monedas.cdx
IF SEEK(m.moneda)
   @ 06,22 SAY PADR(ALLTRIM(monedas.nombre), 28, CHR(32)) ;
      SIZE 1,28 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 06,22 SAY REPLICATE(CHR(32), 28) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE MONEDA INEXISTENTE !"
   DO mone_pop.spr WITH "m.moneda", 0, .F.
   SHOW GETS
   IF SEEK(m.moneda)
      @ 06,22 SAY PADR(ALLTRIM(monedas.nombre), 28, CHR(32)) ;
         SIZE 1,28 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 06,22 SAY REPLICATE(CHR(32), 28) ;
         SIZE 1,28 ;
         PICTURE "@!" ;
         COLOR W/N
      SELECT (pcSelect)
      SET ORDER TO TAG (pcOrder)
      IF pnRecNo # 0
         GOTO RECORD pnRecNo
      ENDIF
      RELEASE pcSelect, pcOrder, pnRecNo
      RETURN .F.
   ENDIF
ENDIF

IF EMPTY(m.tipocambio)
   m.tipocambio = control.tipocambio
ENDIF

IF m.moneda = 1
   m.tipocambio = 0
   SHOW GET m.tipocambio
ENDIF


SELECT (pcSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo # 0
   GOTO RECORD pnRecNo
ENDIF
RELEASE pcSelect, pcOrder, pnRecNo





FUNCTION _ShowHeader
@ 02,13 GET m.tipodocu ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN plAdding .AND. _ConfirmOn() ;
   VALID _vldTipoDocu() ;
   COLOR SCHEME 1
@ 04,13 GET m.cliente ;
   SIZE 1,5 ;
   DEFAULT 0 ;
   PICTURE "99999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldCliente() ;
   COLOR SCHEME 1
@ 02,45 GET m.nrodocu ;
   SIZE 1,9 ;
   DEFAULT 0 ;
   PICTURE "999999999" ;
   WHEN plAdding ;
   VALID _vldNroDocu() ;
   COLOR SCHEME 1
@ 02,68 GET m.fechadocu ;
   SIZE 1,10 ;
   DEFAULT DTOC(DATE()) ;
   PICTURE "99/99/9999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldFechaDocu() ;
   COLOR SCHEME 1



FUNCTION _vldMecanico
PARAMETER NRO
RETURN


*!*********************************************************************
*!
*!      Funci¢n: _vldComision_V
*!
*!  Llamado por: _AddInvoice                 
*!
*!  Descripci¢n: Validaci¢n del campo comisi¢n de vendedor.  
*!
*!*********************************************************************
FUNCTION _vldComision_V
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_ESCAPE, K_BSCAPE)
   RETURN
ENDIF

IF m.comision_v < 0
   WAIT WINDOW "­ LA COMISION DEL VENDEDOR DEBE SER MAYOR O IGUAL QUE CERO !"
   RETURN .F.
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldTipoCambio
*!
*!  Llamado por: _AddInvoice                 
*!
*!  Descripci¢n: Validaci¢n del campo tipo de cambio.         
*!
*!*********************************************************************
FUNCTION _vldTipoCambio
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_ESCAPE, K_BSPACE)
   RETURN
ENDIF
IF m.tipocambio < 0
   WAIT WINDOW "­ EL TIPO DE CAMBIO DEBE SER MAYOR O IGUAL QUE CERO !"
   RETURN .F.
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldVendedor
*!
*!  Llamado por: _AddInvoice                 
*!
*!  Descripci¢n: Validaci¢n del campo vendedor.               
*!
*!*********************************************************************
FUNCTION _vldVendedor
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_ESCAPE, K_BSPACE)
   RETURN
ENDIF

IF m.vendedor <= 0
   @ 07,22 SAY REPLICATE(CHR(32), 28) ;
      SIZE 1,28 ;
      PICTURE "@!" ;
      COLOR W/N
   DO vend_pop.spr WITH "m.vendedor", 0, .F.
ENDIF

IF m.vendedor = 0
   RETURN .F.
ENDIF

DO SaveWorkArea

SELECT vendedor
SET ORDER TO TAG indice1 OF vendedor.cdx
IF SEEK(m.vendedor)
   @ 07,22 SAY PADR(ALLTRIM(vendedor.nombre), 28, CHR(32)) ;
      SIZE 1,28 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 07,22 SAY REPLICATE(CHR(32), 28) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE VENDEDOR INEXISTENTE !"
   DO vend_pop.spr WITH "m.vendedor", 0, .F.
   SHOW GETS
   IF SEEK(m.vendedor)
      @ 07,22 SAY PADR(ALLTRIM(vendedor.nombre), 28, CHR(32)) ;
         SIZE 1,28 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 07,22 SAY REPLICATE(CHR(32), 28) ;
         SIZE 1,28 ;
         PICTURE "@!" ;
         COLOR W/N
      DO RestoreWorkArea
      RETURN .F.
   ENDIF
ENDIF

m.comision_v = vendedor.comision
SHOW GETS

DO RestoreWorkArea

DO _brwLoadDetail

*!*********************************************************************
*!
*!      Funci¢n: _whenPrecioUnit
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: When del campo precio unitario.            
*!
*!*********************************************************************
FUNCTION _whenPrecioUnit
PARAMETER pcArticulo

DO SaveWorkArea

SELECT servicio
SET ORDER TO indice1 OF servicio.cdx

IF SEEK(pcArticulo)
   RETURN 
ELSE
   RETURN .F.
ENDIF

DO RestoreWorkArea

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

DO SaveWorkArea

SELECT servicio
SET ORDER TO indice1 OF servicio.cdx

IF SEEK(pcArticulo)
   RETURN .F.
ELSE
   RETURN 
ENDIF

DO RestoreWorkArea

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
IF LASTKEY() = K_ENTER  
   IF RECNO() = RECCOUNT()
      KEYBOARD "{CTRL+W}"      
      INSERT INTO tmpdetvent (tipodocu, nrodocu, articulo, cantidad, precio, impuesto, pimpuesto, serie, mecanico, descr_trab) ;
         VALUES (0, 0, "", 0, 0, .F., 0, "", 0, "")
   ENDIF
ENDIF
DO _InvoiceFoot   

*!*********************************************************************
*!
*!      Funci¢n: _vldPorcDesc   
*!
*!  Llamado por: _AddInvoice    
*!
*!  Descripci¢n: Valida el campo de descuento en porcentaje.
*!
*!*********************************************************************
FUNCTION _vldPorcDesc
IF m.porcdesc < 0
   WAIT WINDOW " ­ EL PORCENTAJE DEL DESCUENTO DEBE SER MAYOR O IGUAL QUE CERO !"
   RETURN .F.
ELSE
   IF m.porcdesc > 0
      IF pnSubTotal = 0
         WAIT WINDOW "­ EL SUB-TOTAL DE LA FACTURA DEBE SER MAYOR QUE CERO !"
         RETURN .F.
      ENDIF
      DO _InvoiceFoot
      IF LASTKEY() # K_PGDN .OR. LASTKEY() # K_ENTER
         _CUROBJ = OBJNUM(m.porcdesc)
      ENDIF
   ELSE
      _CUROBJ = OBJNUM(m.importdesc)
   ENDIF
ENDIF

IF INLIST(LASTKEY(), K_UP, K_PGUP, K_LEFT)
   RETURN .F.
ELSE   
   IF LASTKEY() = K_ENTER .AND. .NOT. EMPTY(m.porcdesc)
      DO _InvoiceFoot
      DO cuotvent.spr WITH m.tipodocu
*      IF plClearRead .OR. plCancel
         CLEAR READ
*         IF plClearRead 
            WAIT WINDOW "­ LA VENTA FUE GRABADA !" TIMEOUT 0.75
 *        ENDIF
 *     ENDIF
   ENDIF
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldImportDesc 
*!
*!  Llamado por: 
*!
*!  Descripci¢n: Valida el campo de descuento en monto.
*!
*!*********************************************************************
FUNCTION _vldImportDesc
IF m.importdesc < 0
   WAIT WINDOW " ­ EL DESCUENTO DEBE SER CERO, O MENOR O IGUAL AL VALOR DE LA FACTURA !"
   RETURN .F.
ELSE
   IF m.importdesc > 0
      DO _InvoiceFoot
      IF LASTKEY() # 3 .OR. LASTKEY() # 13
         _CUROBJ = OBJNUM(m.porcdesc)
      ENDIF
   ELSE
      DO _InvoiceFoot
      _CUROBJ = OBJNUM(m.porcdesc)
   ENDIF
ENDIF

IF LASTKEY() = 19
   _CUROBJ = OBJNUM(m.porcdesc)
ENDIF

IF INLIST(LASTKEY(), 5, 18)
   RETURN .F.
ELSE   
   IF LASTKEY() = 13 &&.AND. EMPTY(m.importdesc)
      IF pnSubTotal = 0
         WAIT WINDOW "­ EL SUB-TOTAL DE LA FACTURA DEBE SER MAYOR QUE CERO !"
         _CUROBJ = OBJNUM(m.porcdesc)
         RETURN
      ENDIF
      DO _InvoiceFoot
      DO cuotvent.spr WITH m.tipodocu &&, plClearRead, plCancel
&&      IF plClearRead .OR. plCancel
         CLEAR READ
&&         IF plClearRead 
            WAIT WINDOW "­ LA VENTA FUE GRABADA !" TIMEOUT 0.75
&&         ENDIF
&&      ENDIF
   ENDIF
ENDIF



*!*********************************************************************
*!
*!      Funci¢n: _vldCodigo     
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Validaci¢n  del  campo  c¢digo  en  el detalle  de  la
*!               nota de env¡o o ajuste de inventario.         
*!
*!*********************************************************************
FUNCTION _vldCodigo
PARAMETER pnCodigo

IF LASTKEY() = K_DOWN
   RETURN .T.
ENDIF   
IF LASTKEY() = K_F8
   RETURN .T.
ENDIF  

IF EMPTY(pnCodigo)
   PUSH KEY CLEAR
   ON KEY LABEL "ENTER" KEYBOARD "{CTRL+W}"
   DO _brwMaesprod
   ON KEY LABEL "ENTER" 
   POP KEY
   IF NOT LASTKEY() = K_ESCAPE
      pnCodigo = tmpdetvent.articulo
   ELSE 
      RETURN .F.
   ENDIF
ENDIF

SELECT maesprod
SET ORDER TO TAG indice1 OF maesprod.cdx

PRIVATE pnRecNo
pnRecNo  = IIF(EOF(), 0, RECNO())

IF NOT SEEK(pnCodigo)
   WAIT WINDOW "­ CODIGO DE ARTICULO INEXISTENTE !"
   IF pnRecNo # 0 
      GOTO RECORD pnRecNo
   ENDIF
   RETURN .F.
ENDIF

REPLACE tmpdetvent.articulo WITH maesprod.codigo

DO SaveWorkArea

SELECT servicio
SET ORDER TO indice1 OF servicio.cdx

IF NOT SEEK(ALLTRIM(tmpdetvent.articulo))
   SELECT tmpdetvent
   DO CASE
      CASE m.lstprecio = 1
         REPLACE tmpdetvent.precio WITH maesprod.pventag1
      CASE m.lstprecio = 2
         REPLACE tmpdetvent.precio WITH maesprod.pventag2
      CASE m.lstprecio = 3
         REPLACE tmpdetvent.precio WITH maesprod.pventag3
      CASE m.lstprecio = 4
         REPLACE tmpdetvent.precio WITH maesprod.pventag4
      CASE m.lstprecio = 5
         REPLACE tmpdetvent.precio WITH maesprod.pventag5
   ENDCASE      
ENDIF

DO RestoreWorkArea

*!*********************************************************************
*!
*!      Funci¢n: _brwMaesprod   
*!
*!  Llamado por: _vldCodigo
*!
*!  Descripci¢n: Abre una ventana de inspecci¢n para visualizar la lis-
*!               ta de art¡culos.
*!
*!*********************************************************************
FUNCTION _brwMaesprod

DO SaveWorkArea

*-- MS-DOS Definiciones de ventanas.
IF NOT WEXIST("brwMaesprod")
   DEFINE WINDOW brwMaesprod ;
      FROM 01,00 ;
      TO   23,79 ;
      TITLE "< ARTICULOS >" ;
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

SELECT maesprod
SET ORDER TO TAG indice2 OF maesprod.cdx
GO TOP
                
*-- MS-DOS Macros de teclado.
ON KEY LABEL "F2" DO _AddMaesprod
ON KEY LABEL "F3" DO _EditMaesprod
ON KEY LABEL "F4" DO mporden.spr
ON KEY LABEL "F5" DO mpswitch.prg
ON KEY LABEL "F8" DO maesprod.prg WITH "Delete"
ON KEY LABEL "CTRL+HOME" GO TOP
ON KEY LABEL "CTRL+END"  GO BOTTOM

DO SaveScreen
@ 00,00 TO 00,79 CHR(32)
@ 24,00 TO 24,79 CHR(32)
DO _Center WITH 00, gcLocal, "W/N"

BROWSE WINDOW brwMaesprod FIELDS ;
   calc_f1 = SUBSTR(codigo, 1, 9)                       :R:09:H = "C¢digo" ,;
   calc_f2 = SUBSTR(nombre, 1, 39)                      :R:39:H = "Nombre" ,;
   calc_f3 = IIF(impuesto, "S", "")                     :R:01:H = "",;
   pventag1                                             :R:10:H = "P.Vta 1":P = "99,999,999" ,;
   calc_f4 = ROUND(pventag1 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 1 c/Iva":P = "9,999,999,999" ,;
   pventag2                                             :R:10:H = "P.Vta 2":P = "99,999,999" ,;
   calc_f5 = ROUND(pventag2 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 2 c/Iva":P = "9,999,999,999" ,;
   pventag3                                             :R:10:H = "P.Vta 3":P = "99,999,999" ,;
   calc_f6 = ROUND(pventag3 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 3 c/Iva":P = "9,999,999,999" ,;
   calc_f7 = IIF(impuesto, "   S¡   ", "")              :R:08:H = "Impuesto" ,;
   stock_actu                                           :R:13:H = "Stock Actual":P = "99,999,999.99" ,;  
   calc_f8  = SUBSTR(rubros1.nombre, 1, 30)             :R:30:H = "Rubro" ,;
   calc_f9  = SUBSTR(rubros2.nombre, 1, 30)             :R:30:H = "Sub-Rubro",;   
   calc_f10 = SUBSTR(marcas.nombre, 1, 30)              :R:30:H = "Marcas",;      
   calc_f11 = SUBSTR(nombre, 1, 40)                     :R:40:H = "Nombre" ,;
   calc_f12 = SUBSTR(codigo2, 1, 15)                    :R:15:H = "C¢d.Alternativo" ,;
   calc_f13 = SUBSTR(codorig, 1, 15)                    :R:15:H = "C¢d. Origen" NOAPPEND NODELETE NOMODIFY

DO RestoreScreen
SET ORDER TO TAG indice1 OF maesprod.cdx

*-- MS-DOS Restablece macros de teclado.
ON KEY LABEL "F2" 
ON KEY LABEL "F3" 
ON KEY LABEL "F4"
ON KEY LABEL "F5"
ON KEY LABEL "F8" 
ON KEY LABEL "CTRL+HOME" 
ON KEY LABEL "CTRL+END"  

IF LASTKEY() # K_ESCAPE
   REPLACE tmpdetvent.articulo WITH maesprod.codigo
   
   DO SaveWorkArea
   
   SELECT servicio
   SET ORDER TO indice1 OF servicio.cdx

   IF NOT SEEK(tmpdetvent.articulo)
      SELECT tmpdetvent
      DO CASE
         CASE m.lstprecio = 1
            REPLACE tmpdetvent.precio WITH maesprod.pventag1
         CASE m.lstprecio = 2
            REPLACE tmpdetvent.precio WITH maesprod.pventag2
         CASE m.lstprecio = 3
            REPLACE tmpdetvent.precio WITH maesprod.pventag3
         CASE m.lstprecio = 4
            REPLACE tmpdetvent.precio WITH maesprod.pventag4
         CASE m.lstprecio = 5
            REPLACE tmpdetvent.precio WITH maesprod.pventag5
      ENDCASE      
   ENDIF

   DO RestoreWorkArea
ENDIF

DO RestoreWorkArea

*!*********************************************************************
*!
*!      Funci¢n: _AddMaesprod
*!
*!  Llamado por: _brwMaesprod
*!
*!  Descripci¢n: Agrega un registro a la lista de art¡culos.
*!
*!*********************************************************************
FUNCTION _AddMaesprod
PRIVATE plAdding, plEditing, plDeleting, pnNextScreen, m.codigo, m.codigo2,;
   m.codorig, m.nombre, m.lista3, m.lista4, m.lista5, m.familia, m.rubro,;
   m.subrubro, m.marca, m.unidad, m.proveedor, m.procedenci, m.ubicacion,;
   m.vigente, m.lprecio, m.impuesto, m.pimpuesto, m.pcostog, m.pcostod,;
   m.pcostogr, m.pcostodr, m.pcostogre, m.pcostodre, m.pventag1,;
   m.pventag2, m.pventag3, m.pventag4, m.pventag5, m.pventad1,;
   m.pventad2, m.pventad3, m.pventad4, m.pventad5, m.paumento1,;
   m.paumento2, m.paumento3, m.paumento4, m.paumento5, m.stock_min,;
   m.stock_max, m.polinvsmin, m.polinvsmax, m.garantia, m.caracter1,;
   m.caracter2, m.caracter3, m.otros1, m.otros2, m.fecucompra, m.fecrepo,;
   m.stock_actu, m.stock_ot


PUSH KEY CLEAR

SELECT maesprod
SCATTER MEMVAR MEMO BLANK

plAdding     = .T.
plEditing    = .F.
plDeleting   = .F.
pnNextScreen = 1
pnSaveWarn   = 0

DO WHILE  pnNextScreen # 0
   DO CASE
      CASE pnNextScreen = 1
         DO maespro1.spr
      CASE pnNextScreen = 2
         DO maespro2.spr
   ENDCASE
ENDDO

IF pnSaveWarn = 1     
   APPEND BLANK
   GATHER MEMVAR MEMO
ENDIF

plAdding     = .F.
plEditing    = .F.
plDeleting   = .F.
pnNextScreen = 0
pnSaveWarn   = 0

POP KEY

*!*********************************************************************
*!
*!      Funci¢n: _EditMaeprod
*!
*!  Llamado por: _brwMaesprod
*!
*!  Descripci¢n: Modifica un registro de la lista de art¡culos.
*!
*!*********************************************************************
FUNCTION _EditMaesprod
PRIVATE plAdding, plEditing, plDeleting, pnNextScreen, pcAppend, m.codigo,;
   m.codigo2, m.codorig, m.nombre, m.lista3, m.lista4, m.lista5, m.familia,;
   m.rubro, m.subrubro, m.marca, m.unidad, m.proveedor, m.procedenci,;
   m.ubicacion, m.vigente, m.lprecio, m.impuesto, m.pimpuesto, m.pcostog,;
   m.pcostod, m.pcostogr, m.pcostodr, m.pcostogre, m.pcostodre, m.pventag1,;
   m.pventag2, m.pventag3, m.pventag4, m.pventag5, m.pventad1, m.pventad2,;
   m.pventad3, m.pventad4, m.pventad5, m.paumento1, m.paumento2,;
   m.paumento3, m.paumento4, m.paumento5, m.stock_min, m.stock_max,;
   m.polinvsmin, m.polinvsmax, m.garantia, m.caracter1, m.caracter2,;
   m.caracter3, m.otros1, m.otros2, m.fecucompra, m.fecrepo, m.stock_actu,;
   m.stock_ot

PUSH KEY CLEAR
      
SELECT maesprod

IF DELETED()
   WAIT WINDOW "ESTE ARTICULO YA HA SIDO BORRADO, NO SE PUEDE EFECTUAR MODIFICACIONES !"
   POP KEY
   RETURN
ENDIF

IF EOF()
   DO WHILE .T.
      WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
      IF UPPER(pcAppend) = "S"
         DO _AddMaesprod
         EXIT DO
      ENDIF
      IF UPPER(pcAppend) = "N"
         EXIT DO
      ENDIF
   ENDDO    
   POP KEY
   RETURN
ENDIF

IF .NOT. RLOCK()
   WAIT WINDOW "­ ESTE REGISTRO ESTA SIENDO UTILIZADO POR OTRO USUARIO !"
   POP KEY
   RETURN         
ENDIF

SCATTER MEMVAR MEMO
      
plAdding     = .F.
plEditing    = .T.
plDeleting   = .F.
pnNextScreen = 1
pnSaveWarn   = 0

DO WHILE  pnNextScreen # 0
   DO CASE
      CASE pnNextScreen = 1
         DO maespro1.spr
      CASE pnNextScreen = 2
         DO maespro2.spr
   ENDCASE
ENDDO

IF pnSaveWarn = 1     
   GATHER MEMVAR MEMO FIELDS codigo, codigo2, codorig, nombre, lista3,;
      lista4, lista5, familia, rubro, subrubro, marca, unidad, proveedor,;
      procedenci, ubicacion, vigente, lprecio, impuesto, pimpuesto,;
      pcostog, pcostod, pcostogr, pcostodr, pcostogre, pcostodre,;
      pventag1, pventag2, pventag3, pventag4, pventag5, pventad1,;
      pventad2, pventad3, pventad4, pventad5, paumento1, paumento2,;
      paumento3, paumento4, paumento5, stock_min, stock_max, polinvsmin,;
      polinvsmax, garantia, caracter1, caracter2, caracter3, otros1,;
      otros2, fecucompra, fecrepo
ENDIF

UNLOCK IN maesprod

plAdding     = .F.
plEditing    = .F.
plDeleting   = .F.
pnNextScreen = 0
pnSaveWarn   = 0

POP KEY