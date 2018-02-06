*:**************************************************************************
*:
*: Archivo de Procedimiento: COMPRAS.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Vista formulario de Compras.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/04/2004
*:
*:**************************************************************************
WAIT WINDOW "POR FAVOR, ESPERE MIENTRAS SE CARGA EL MODULO..." NOWAIT

*-- Variables de la Tabla de Cabecera.
PRIVATE m.tipodocu, m.nrodocu, m.fechadocu, m.proveedor, m.moneda, m.tipocambio, m.porcdesc, m.importdesc, m.descuento, m.monto_fact, m.monto_ndeb, m.monto_ncre, m.monto_pago, m.consignaci, m.id_local

*-- Variables para c lculos del programa.
PRIVATE pnGravada, pnExenta, pnImpuesto, msubtotal, pcDelete

*-- Inicializa variables del programa.
STORE .F. TO plAdding, plEditing

*-- MS-DOS Definiciones de ventanas.
IF .NOT. WEXIST("tmpdetcomp")
   DEFINE WINDOW tmpdetcomp ;
      FROM 08,00 ;
      TO 18,79 ;
      TITLE "DETALLE" ;
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

IF .NOT. WEXIST("tmpcuocomp")
   DEFINE WINDOW tmpcuocomp ;
      FROM 04,01 ;
      TO 20,78 ;
      TITLE "CUOTAS" ;
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

IF .NOT. WEXIST("tmpmarcuot")
   DEFINE WINDOW tmpmarcuot ;
      FROM 03,00 ;
      TO 21,79 ;
      NOCLOSE ;
      NOFLOAT ;
      GROW ;
      MDI ;         
      NOMINIMIZE ;
      SHADOW ;
      NOZOOM ;
      COLOR SCHEME 1
ENDIF

IF .NOT. WEXIST("brwCompras")
   DEFINE WINDOW brwCompras ;
      FROM 01,00 ;
      TO 23,79 ;
      TITLE "< COMPRAS >" ;
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

*-- MS-DOS Base de datos, ¡ndices, relaciones.
SELECT 0
temp01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp01 (tipodocu   N(01) ,;
                      nrodocu    N(09) ,;
                      proveedor  N(05) ,;
                      articulo   C(15) ,;
                      cantidad   N(09,2) ,;
                      precio     N(13,4) ,;
                      pdescuento N(07,4) ,;
                      impuesto   L(01) ,;
                      pimpuesto  N(06,2) ,;
                      tipoc      C(01) ,;
                      taxinclude L(01))

USE &temp01 ALIAS tmpdetcomp EXCLUSIVE
INDEX ON STR(tipodocu, 1) + STR(nrodocu, 9) + STR(proveedor, 5) TAG indice1
SET RELATION TO tmpdetcomp.articulo INTO maesprod ADDITIVE

SELECT 0
temp02 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp02 (tipodocu   N(01), ;
                      nrodocu    N(09), ;
                      proveedor  N(05), ;
                      tipo       N(01), ;
                      nrocuota   N(03), ;
                      fecha      D(08), ;
                      importe    N(12,2), ;
                      abonado    N(12,2), ;
                      monto_ndeb N(12,2), ;
                      monto_ncre N(12,2))

USE &temp02 ALIAS tmpcuocomp EXCLUSIVE
INDEX ON STR(tipodocu, 1) + STR(nrodocu, 9) + STR(nrocuota, 3) TAG indice1

WAIT CLEAR

SELECT cabecomp
SET ORDER TO TAG indice1 OF cabecomp.cdx
GO TOP

*-- Estable relaciones entre las tablas.
SELECT detacomp
SET RELATION TO detacomp.articulo INTO maesprod ADDITIVE

SELECT cabecomp
SET RELATION TO cabecomp.proveedor INTO proveedo ADDITIVE
SET RELATION TO cabecomp.moneda    INTO monedas  ADDITIVE

SCATTER MEMVAR MEMO

DO _RefreshInvoice

*-- Bucle principal del programa.
DO WHILE .T.  
   pnKey = INKEY(0, "HM")         && Tomar INKEY(), ocultar cursor, comprobar rat¢n.
   IF pnKey = 0                   && No hay pulsaci¢n de tecla ni rat¢n.
      LOOP
   ENDIF
   IF pnKey = 27                  && Tecla ESC presionada,              
      EXIT                        && salir del bucle principal.
   ENDIF
   IF pnKey = 151                 && Clic sencillo del rat¢n.
      LOOP
   ENDIF
   DO CASE
      CASE pnKey = -1             && Tecla F2 presionada, agregar registro.
         IF UserConfig("compras.prg", "Add", .T.)
            DO mkcompra.prg WITH "Add"
            DO _RefreshInvoice
         ENDIF
      CASE pnKey = -2             && Tecla F3 presionada, modificar registro.
         IF UserConfig("compras.prg", "Edit", .T.)
            DO mkcompra.prg WITH "Edit"
            DO _RefreshInvoice
         ENDIF
      CASE pnKey = -7             && Tecla F8 presionada, eliminar registro
         IF cabecomp.fechadocu <> DATE() THEN
            WAIT "LOS REGISTROS DE ESTA TABLA NO PUEDEN SER BORRADOS !" WINDOW NOWAIT
            LOOP
         ENDIF

         IF UserConfig("compras.prg", "Delete", .T.)
            DO _DeleteInvoice
         ENDIF
      CASE pnKey = 5              && Tecla  presionada, siguiente registro.
         DO _NextRecord
      CASE pnKey = 24             && Tecla  presionada, registro anterior.
         DO _PriorRecord         
      CASE pnKey = 19             && Tecla  presionada, primer registro.
         DO _TopRecord
      CASE pnKey = 4              && Tecla -> presionada, £ltimo registro.
         DO _BottomRecord
      CASE INLIST(pnKey, 68, 100) && Tecla "D" may£scula o min£scula, examinar detalle.
         IF RECCOUNT("tmpdetcomp") > 0
            DO _brwDetail
         ENDIF
      CASE pnKey = 13             && Tecla ENTER, visualizar cuotas.
         IF INLIST(cabecomp.tipodocu, 1, 3, 4, 5)
            WAIT WINDOW "­ LAS COMPRAS AL CONTADO NO POSEEN CUOTAS !"
         ELSE
            IF INLIST(cabecomp.tipodocu, 2, 6, 8) .AND. cabecomp.nrodocu <> 0
               DO _brwQuota 
            ENDIF
         ENDIF
      CASE pnKey = -3             && Tecla F4 presionada, ordenar.         
         DO orden04.spr
      CASE pnKey = -9             && Tecla F10 presionada, examinar facturas.
         ON KEY LABEL "F4" DO orden04.spr
         ON KEY LABEL "F5" DO _cmpSwitch
         ON KEY LABEL "CTRL+ENTER" DO compinfo.spr
         ON KEY LABEL "CTRL+HOME"  GO TOP
         ON KEY LABEL "CTRL+END"   GO BOTTOM

         DO _brwInvoices 

         ON KEY LABEL "F4" 
         ON KEY LABEL "F5" 
         ON KEY LABEL "CTRL+ENTER" 
         ON KEY LABEL "CTRL+HOME" 
         ON KEY LABEL "CTRL+END"  

         DO _RefreshInvoice
      CASE pnKey = -4             && Tecla F5 presionada, buscar.
         DO _cmpSwitch
      CASE pnKey = 10
         DO compinfo.spr
      ENDCASE
ENDDO     Fin del bucle principal.     
       
*-- MS-DOS Cierre de Bases de Datos.
IF USED("tmpdetcomp")
   SELECT tmpdetcomp
   USE
ENDIF

DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"

IF USED("tmpcuocomp")
   SELECT tmpcuocomp
   USE
ENDIF

DELETE FILE &temp02
DELETE FILE SUBSTR(temp02, 1, ATC(".", temp02)) + "CDX"

*-- Quiebra las relaciones entre las tablas.
SELECT cabecomp
SET RELATION OFF INTO proveedo
SET RELATION OFF INTO monedas 

SELECT detacomp
SET RELATION OFF INTO maesprod 

*-- Elimina ventanas.
IF WEXIST("tmpdetcomp")
   RELEASE WINDOW tmpdetcomp
ENDIF

IF WEXIST("tmpcuocomp")
   RELEASE WINDOW tmpcuocomp
ENDIF

IF WEXIST("tmpmarcuot")
   RELEASE WINDOW tmpmarcuot
ENDIF

IF WEXIST("brwCompras")
   RELEASE WINDOW brwCompras
ENDIF

*-- MS-DOS Procedimientos y funciones de soporte.
*!*********************************************************************
*!
*!      Funci¢n: _RefreshInvoice
*!
*!  Llamado por: COMPRAS.PRG                 
*!
*!  Descripci¢n: Actualiza  la  visualizaci¢n  del  formato,  cabecera, 
*!               detalle, pie y cuota de la factura.
*!
*!*********************************************************************
FUNCTION _RefreshInvoice

DO _fmtInvoice
DO _ShowHeader
DO _ShowDetail
DO calc_pie_factura
DO _LoadQuota

*!*********************************************************************
*!
*!      Funci¢n: _fmtInvoice     
*!
*!  Llamado por: _RefreshInvoice
*!
*!  Descripci¢n: Dibuja el formato de la factura. 
*!
*!*********************************************************************
FUNCTION _fmtInvoice     &&  Dibuja el formato de la factura y las etiquetas.
@ 01,00 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 02,00 SAY "³ Documento:                             N§:              F.Compra:            ³"
@ 03,00 SAY "³                                                                              ³"
@ 04,00 SAY "³ Proveedor:                                                                   ³"
@ 05,00 SAY "³                                                                              ³"
@ 06,00 SAY "³ Moneda...:                                        Tipo de Cambio:            ³"
@ 07,00 SAY "³                                                                              ³"
@ 08,00 SAY "ÃÄDescripci¢nÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄCantidadÄÂÄPrecio Unit.ÄÄÂÄImporteÄÄ´"
@ 09,00 SAY "³                                        ³          ³               ³          ³"
@ 10,00 SAY "³                                        ³          ³               ³          ³"
@ 11,00 SAY "³                                        ³          ³               ³          ³"
@ 12,00 SAY "³                                        ³          ³               ³          ³"
@ 13,00 SAY "³                                        ³          ³               ³          ³"
@ 14,00 SAY "³                                        ³          ³               ³          ³"
@ 15,00 SAY "³                                        ³          ³               ³          ³"
@ 16,00 SAY "³                                        ³          ³               ³          ³"
@ 17,00 SAY "³                                        ³          ³               ³          ³"
@ 18,00 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´"
@ 19,00 SAY "³ Rubro...:                                         SUB-TOTALES:               ³"
@ 20,00 SAY "³ Gravado.:                                         % DESCUENTO:               ³"
@ 21,00 SAY "³ S.Actual:                                              I.V.A.:               ³"
@ 22,00 SAY "³                                                 TOTAL GENERAL:               ³"
@ 23,00 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

*!*********************************************************************
*!
*!      Funci¢n: _ShowHeader
*!
*!  Llamado por: _RefreshInvoice
*!
*!  Descripci¢n: Carga la cabecera de la factura y lo visualiza.
*!
*!*********************************************************************
FUNCTION _ShowHeader    

SELECT cabecomp
SCATTER MEMVAR

@ 02,13 SAY m.tipodocu ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W

*-- Imprime la etiqueta del tipo de documento.
DO CASE
   CASE m.tipodocu = 1
      @ 02,16 SAY "COMPRA CONTADO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 2
      @ 02,16 SAY "COMPRA CREDITO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 3
      @ 02,16 SAY "COMPRA I.V.A. INCLUIDO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 4
      @ 02,16 SAY "COMPRA TRIBUTO UNICO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 5
      @ 02,16 SAY "C.I. COMPRA CONTADO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 6
      @ 02,16 SAY "C.I. COMPRA CREDITO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 7
      @ 02,16 SAY "CONTADO I.V.A. INCLUIDO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 8
      @ 02,16 SAY "CREDITO I.V.A. INCLUIDO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   OTHERWISE
      @ 02,16 SAY REPLICATE(CHR(32), 23) ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
ENDCASE

@ 04,13 SAY m.proveedor ;
   SIZE 1,5 ;
   PICTURE "99999" ;
   COLOR N/W

*-- Imprime el nombre del proveedor selecionado.
SELECT proveedo
IF SEEK(m.proveedor)
   @ 04,20 SAY PADR(ALLTRIM(proveedo.nombre), 40, CHR(32)) ;
      SIZE 1,40 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 04,20 SAY REPLICATE(CHR(32), 40) ;
      SIZE 1,40 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF
SELECT cabecomp

@ 02,45 SAY m.nrodocu ;
   SIZE 1,9 ;
   PICTURE "999999999" ;
   COLOR N/W

@ 02,68 SAY m.fechadocu ;
   SIZE 1,10 ;
   PICTURE "@D" ;
   COLOR N/W

@ 06,13 SAY m.moneda ;
   SIZE 1,4 ;
   PICTURE "9999" ;
   COLOR N/W

*-- Imprime la nombre de la moneda seleccionada.
SELECT monedas
IF SEEK(m.moneda)
   IF m.moneda = 1
      @ 06,20 SAY PADR(ALLTRIM(monedas.nombre), 30, CHR(32)) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 06,20 SAY PADR(ALLTRIM(monedas.nombre), 30, CHR(32)) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR G/N
   ENDIF
ELSE
   @ 06,20 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF
SELECT cabecomp

@ 06,68 SAY m.tipocambio ;
   SIZE 1,09 ;
   PICTURE "999999.99" ;
   COLOR N/W

*!*********************************************************************
*!
*!      Funci¢n: _ShowDetail
*!
*!  Llamado por: _RefreshInvoice
*!
*!  Descripci¢n: Carga el detalle de la factura y lo visualiza.
*!
*!*********************************************************************
FUNCTION _ShowDetail

SELECT tmpdetcomp     &&   Vac¡a la  tabla  temporal  que  contiene  el
ZAP                   &&   detalle de art¡culos del documento.

SELECT detacomp

IF SEEK(STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9) + STR(cabecomp.proveedor, 5))
   SCAN WHILE STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9)  + STR(cabecomp.proveedor, 5) = STR(detacomp.tipodocu, 1) + STR(detacomp.nrodocu, 9) + STR(detacomp.proveedor, 5)
*     x = IIF(INLIST(m.tipodocu, 3, 7, 8), ROUND(precio * (1 + pimpuesto / 100), IIF(m.moneda = 1, 0, 2)), precio)
      x = IIF(INLIST(m.tipodocu, 3, 7, 8), ROUND(precio * (1 + pimpuesto / 100), 4), precio)
      INSERT INTO tmpdetcomp (tipodocu, nrodocu, proveedor, articulo, cantidad, precio, pdescuento, impuesto, pimpuesto, tipoc, taxinclude) ;
         VALUES (detacomp.tipodocu, detacomp.nrodocu, detacomp.proveedor, detacomp.articulo, detacomp.cantidad, x, detacomp.pdescuento, detacomp.impuesto, detacomp.pimpuesto, "A", IIF(cabecomp.tipodocu = 3, .T., .F.))
   ENDSCAN
ELSE
  IF cabecomp.tipodocu <> 0 .AND. cabecomp.nrodocu <> 0
     WAIT WINDOW "ESTE DOCUMENTO NO POSEE DETALLE, BORRELO Y VUELVA A CARGARLO"
  ENDIF
ENDIF

SELECT cabecomp
DO _PrintDetail

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
#DEFINE pnColumn 2

SELECT tmpdetcomp
GO TOP

SCAN WHILE RECNO() <= 9 .AND. .NOT. (EMPTY(articulo) .OR. EMPTY(cantidad) .OR. EMPTY(precio))
   @ pnRow + RECNO(), pnColumn      SAY SUBSTR(maesprod.nombre, 1, 39)                                                 COLOR N/W
   @ pnRow + RECNO(), pnColumn + 40 SAY cantidad                                             PICTURE "999,999.99"      COLOR N/W
   @ pnRow + RECNO(), pnColumn + 51 SAY precio                                               PICTURE "99,999,999.9999" COLOR N/W
   IF m.moneda <> 1
      @ pnRow + RECNO(), pnColumn + 67 SAY ROUND(precio * cantidad, 2) - ROUND(ROUND(precio * cantidad, 2) * pdescuento / 100, 2) PICTURE "999,999.99"   COLOR N/W
   ELSE
      @ pnRow + RECNO(), pnColumn + 67 SAY ROUND(precio * cantidad, 0) - ROUND(ROUND(precio * cantidad, 0) * pdescuento / 100, 0) PICTURE "99,999,999"   COLOR N/W  
   ENDIF
ENDSCAN

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder) 
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _LoadQuota     
*!
*!  Llamado por: _RefreshInvoice
*!
*!  Descripci¢n: Carga las cuotas del documento.
*!
*!*********************************************************************
FUNCTION _LoadQuota

SELECT tmpcuocomp     &&   Vac¡a la  tabla  temporal  que  contiene las
ZAP                   &&   cuotas del documento.

SELECT cuotas_c

IF SEEK(STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9) + STR(cabecomp.proveedor, 5))
   SCAN WHILE STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9)+ STR(cabecomp.proveedor, 5) = STR(cuotas_c.tipodocu, 1) + STR(cuotas_c.nrodocu, 9) + str(cuotas_c.proveedor, 5)
      INSERT INTO tmpcuocomp (tipodocu, nrodocu, proveedor, tipo, nrocuota, fecha, importe, abonado, monto_ndeb, monto_ncre) ;
         VALUES (cuotas_c.tipodocu, cuotas_c.nrodocu, cuotas_c.proveedor, cuotas_c.tipo, cuotas_c.nrocuota, cuotas_c.fecha, cuotas_c.importe, cuotas_c.abonado, cuotas_c.monto_ndeb, cuotas_c.monto_ncre)
   ENDSCAN
ELSE
  IF cabecomp.tipodocu = 2
     WAIT WINDOW "     ­ ESTE DOCUMENTO NO POSEE CUOTAS !" + CHR(13) + ;
                 "MODIFIQUELO PARA VOLVER A GENERAR LAS CUOTAS"
  ENDIF
ENDIF

SELECT cabecomp

*!*********************************************************************
*!
*!      Funci¢n: _brwDetail     
*!
*!  Llamado por: COMPRAS.PRG      
*!
*!  Descripci¢n: Examina el detalle de art¡culos del documento.
*!
*!*********************************************************************
FUNCTION _brwDetail 

SELECT tmpdetcomp
GO TOP

IF cabecomp.moneda <> 1
   BROWSE WINDOW tmpdetcomp FIELDS ;
      calc_f0 = SUBSTR(articulo,1,12)         :R:12:H="C¢digo", ;
      calc_f1 = SUBSTR(maesprod.nombre,1,40)  :R:40:H="Descripci¢n" :W = .F. ,;
      cantidad                                :R:08:H="Cantidad"     :P="99999.99", ;
      precio                                  :R:13:H="Precio Unit." :P="9999,999.9999", ;
      pdescuento                              :R:07:H="% Dcto."   :P="99.9999" ,;      
      calc_f2 = ROUND(precio * cantidad, 2) - ROUND(ROUND(precio * cantidad, 2) * pdescuento / 100, 2) :R:11:H=" Sub-Total" :P="9999,999.99" ,;
      calc_f3 = IIF(impuesto,"   S¡","   No") :R:08:H="Impuesto" :W = .F. ,;    
      pimpuesto                               :R:06:H="% Imp."       :P="999.99" ;
      NODELETE NOAPPEND NOMODIFY
   SELECT cabecomp
ELSE
   BROWSE WINDOW tmpdetcomp FIELDS ;
      calc_f0 = SUBSTR(articulo,1,12)         :R:12:H="C¢digo", ;
      calc_f1 = SUBSTR(maesprod.nombre,1,40)  :R:40:H="Descripci¢n"  :W = .F. ,;
      cantidad                                :R:08:H="Cantidad"     :P="99999.99", ;
      precio                                  :R:13:H="Precio Unit." :P="9999,999.9999", ;
      pdescuento                              :R:07:H="% Dcto."   :P="99.9999" ,;      
      calc_f2 = ROUND(precio * cantidad, 0) - ROUND(ROUND(precio * cantidad, 0) * pdescuento / 100, 0) :R:11:H=" Sub-Total"   :P="999,999,999" ,;
      calc_f3 = IIF(impuesto,"   S¡","   No") :R:08:H="Impuesto" :W = .F. ,;    
      pimpuesto                               :R:06:H="% Imp."       :P="999.99" ;
      NODELETE NOAPPEND NOMODIFY
   SELECT cabecomp
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _brwQuota      
*!
*!  Llamado por: VENTAS.PRG       
*!
*!  Descripci¢n: Examina las cuotas del documento.
*!
*!*********************************************************************
FUNCTION _brwQuota

ACTIVATE WINDOW tmpmarcuot 

SELECT tmpcuocomp
GO TOP

IF m.moneda <> 1
   BROWSE WINDOW tmpcuocomp FIELDS ;
      calc_f1 = IIF(tipo = 1,"Entr",IIF(tipo = 2,"Cuota"," "))    :R:04:H="Tipo", ;
      nrocuota                                                    :R:03:H="N§"         :P="999", ;
      fecha                                                       :R:10:H="Fecha Vcto", ;
      importe                                                     :R:10:H="Importe"    :P="999,999.99", ;
      calc_f2 = ((importe + monto_ndeb) - (monto_ncre + abonado)) :R:10:H="Saldo"      :P="999,999.99", ;
      abonado                                                     :R:10:H="Abonado"    :P="999,999.99", ;
      monto_ndeb                                                  :R:10:H="Monto Ndeb" :P="999,999.99", ;
      monto_ncre                                                  :R:10:H="Monto Ncre" :P="999,999.99"  ;
      NODELETE NOAPPEND NOMODIFY  
ELSE
   BROWSE WINDOW tmpcuocomp FIELDS ;
      calc_f1 = IIF(tipo = 1,"Entr",IIF(tipo = 2,"Cuota"," "))    :R:04:H="Tipo", ;
      nrocuota                                                    :R:03:H="N§"         :P="999", ;
      fecha                                                       :R:10:H="Fecha Vcto", ;
      importe                                                     :R:10:H="Importe"    :P="99,999,999", ;
      calc_f2 = ((importe + monto_ndeb) - (monto_ncre + abonado)) :R:10:H="Saldo"      :P="99,999,999", ;
      abonado                                                     :R:10:H="Abonado"    :P="99,999,999", ;
      monto_ndeb                                                  :R:10:H="Monto Ndeb" :P="99,999,999", ;
      monto_ncre                                                  :R:10:H="Monto Ncre" :P="99,999,999"  ;
      NODELETE NOAPPEND NOMODIFY  
ENDIF

DEACTIVATE WINDOW tmpmarcuot

SELECT cabecomp

*!*********************************************************************
*!
*!      Funci¢n: _brwInvoices   
*!
*!  Llamado por: COMPRAS.PRG      
*!
*!  Descripci¢n: Examina los documentos cargados.
*!
*!*********************************************************************
FUNCTION _brwInvoices

SELECT cabecomp

BROWSE WINDOW brwCompras FIELDS ;
   calc_f1 = IIF(tipodocu = 1,"CCON ", IIF(tipodocu = 2,"CCRE ", IIF(tipodocu = 3, "CII  ", IIF(tipodocu = 4, "CTU  ", IIF(tipodocu = 5, "CICCO", IIF(tipodocu = 6, "CICCR", "     ")))))) :R:05:H = "" ,;
   nrodocu    :R:09:P = "999999999" :H = "N§ Doc." ,;
   fechadocu  :R:10:H = "Fecha Doc." ,;
   calc_f2 = SUBSTR(monedas.simbolo, 1, 4) + "  " :R:06:H = "Moneda" ,;
   monto_fact :R:14:P = "999,999,999.99" :H = "Monto Fact." ,;
   calc_f3 = ((monto_fact + monto_ndeb) - (monto_ncre + monto_pago)) :R:14:P = "999,999,999.99" :H = "    Saldo"  ,;
   calc_f4 = SUBSTR(proveedo.nombre, 1, 51) :R:51:P = "@!" :H = "Proveedor" ,;
   calc_f5 = IIF(tipodocu = 1,"CCO", IIF(tipodocu = 2,"CCR", IIF(tipodocu = 3, "CII", IIF(tipodocu = 4, "CTU",  " ")))) :R:03:H = "" ,;
   calc_f6 = nrodocu    :R:09: P = "999999999"   :H = "N§ Doc." ,;
   calc_f7 = monto_fact :R:14: P = "999,999,999.99" :H = "Monto Fact." ,;
   monto_pago :R:14:P = "999,999,999.99" :H = "Monto Pago" ,;
   monto_ndeb :R:14:P = "999,999,999.99" :H = "Monto N.Deb" ,;
   monto_ncre :R:14:P = "999,999,999.99" :H = "Monto N.Cre" ,;
   calc_f8 = ((monto_fact + monto_ndeb) - (monto_ncre + monto_pago)) :R:14: P = "999,999,999.99" :H = "    Saldo" ,;
   proveedor  :R:07:P = "9999999" :H = "C¢d.Pro" ;
   NOAPPEND NODELETE NOMODIFY

*!*********************************************************************
*!
*!      Funci¢n: _cmpSwitch
*!
*!  Llamado por: COMPRAS.PRG
*!
*!  Descripci¢n: Selecciona el tipo de ventana a desplegar  para reali-
*!               zar la b£squeda.
*!
*!*********************************************************************
FUNCTION _cmpSwitch

PUSH KEY CLEAR

IF EOF()
   DO WHILE .T.
      WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
      IF UPPER(pcAppend) = "S"
         DO mkcompra.prg WITH "Add"
         DO _RefreshInvoice
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

IF FOUND()
   DO _RefreshInvoice
ENDIF

*!**************************************************************************
*!
*!  PROCEDIMIENTO: _InvoiceFoot   
*!
*!    DESCRIPCION: Calcula e imprime el pie del comprobante.
*!
*!**************************************************************************
PROCEDURE _InvoiceFoot

PRIVATE pnSelect, pcOrder, pnRecNo, pnDecimals
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0,  RECNO())

SELECT tmpdetcomp

*-- Inicializa variables del programa.
STORE 0 TO pnGravada, pnExenta, pnImpuesto, msubtotal, pnSubTota1, ;
           pnDescGrav, pnDescExen, pnDecimals

*-- Inicializa variables de la tabla.
STORE 0 TO m.monto_fact, m.descuento

*-- Especifica el n£mero de lugares decimales desplegado en las expresiones num‚ricas.
IF m.moneda <> 1
   pnDecimals = 2
ELSE
   pnDecimals = 0
ENDIF

*-- Calcula el importe gravado y exento del comprobante de venta.
SCAN ALL
   DO CASE
      CASE impuesto .AND. pimpuesto > 0 .AND. pimpuesto < control.pimpuesto
         */ Inicio calculo (una articulo a la vez) */
         nMontoBruto = ROUND(precio * cantidad, pnDecimals)
         nDescLineal = ROUND(nMontoBruto * pdescuento / 100, pnDecimals)
         nMontoNeto  = nMontoBruto - nDescLineal
         nGravada    = ROUND(nMontoNeto * (pimpuesto * control.pimpuesto / 100), pnDecimals)
         nExenta     = nMontoNeto - nGravada
         */ Fin calculo */
         pnGravada = pnGravada + nGravada
         pnExenta  = pnExenta + nExenta
*        pnGravada = pnGravada + ROUND(precio * cantidad, pnDecimals) - ROUND(ROUND(precio * cantidad, pnDecimals) * pdescuento / 100, pnDecimals) * (pimpuesto * control.pimpuesto / 100)
*        pnExenta  = pnExenta  + ROUND(precio * cantidad, pnDecimals) - ROUND(ROUND(precio * cantidad, pnDecimals) * pdescuento / 100, pnDecimals) * (1 - (pimpuesto * control.pimpuesto / 100))
      CASE impuesto .AND. pimpuesto = control.pimpuesto
         pnGravada = pnGravada + ROUND(precio * cantidad, pnDecimals) - ROUND(ROUND(precio * cantidad, pnDecimals) * pdescuento / 100, pnDecimals)
      CASE .NOT. impuesto .AND. pimpuesto = 0
         pnExenta  = pnExenta + ROUND(precio * cantidad, pnDecimals) - ROUND(ROUND(precio * cantidad, pnDecimals) * pdescuento / 100, pnDecimals)
   ENDCASE
ENDSCAN
   
msubtotal = pnGravada + pnExenta
   
IF m.importdesc > 0 .AND. m.porcdesc = 0
   pnDescGrav   = ROUND(m.importdesc * ROUND(pnGravada * 100 / msubtotal, pnDecimals) / 100, pnDecimals)
   pnDescExen   = m.importdesc - pnDescGrav
   pnSubTota1   = msubtotal - m.importdesc
   pnImpuesto   = ROUND((pnGravada - pnDescGrav) * (control.pimpuesto / 100), pnDecimals)
   m.monto_fact = pnSubTota1 + pnImpuesto
   m.descuento  = ROUND(m.importdesc / msubtotal * 100, 4)
ELSE
   IF m.porcdesc > 0
      pnDescGrav   = ROUND((pnGravada * (m.porcdesc / 100)), pnDecimals)
      pnDescExen   = ROUND((pnGravada + pnExenta) * (m.porcdesc / 100), pnDecimals) - pnDescGrav
      m.importdesc = pnDescGrav + pnDescExen
      pnSubTota1   = (pnGravada + pnExenta) - (pnDescGrav + pnDescExen)
      pnImpuesto   = ROUND(ROUND(pnGravada * (1 - m.porcdesc / 100), pnDecimals) * (control.pimpuesto / 100), pnDecimals)
      m.monto_fact = pnSubTota1 + pnImpuesto

      *pnDescGrav   = ROUND((pnGravada * (m.porcdesc / 100)), pnDecimals)
      *pnDescExen   = ROUND((pnExenta * (m.porcdesc / 100)), pnDecimals)
      *m.importdesc = pnDescGrav + pnDescExen
      *pnSubTota1   = (pnGravada + pnExenta) - (pnDescGrav + pnDescExen)
      *pnImpuesto   = ROUND(ROUND(pnGravada * (1 - m.porcdesc / 100), pnDecimals) * (control.pimpuesto / 100), pnDecimals)
      *m.monto_fact = pnSubTota1 + pnImpuesto
   ELSE
      IF m.importdesc = 0 .AND. m.porcdesc = 0
         pnImpuesto   = ROUND(pnGravada * (control.pimpuesto / 100), pnDecimals)
         m.monto_fact = msubtotal + pnImpuesto
      ENDIF
   ENDIF
ENDIF

@ 19,65 SAY msubtotal ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR N/W

@ 20,43 SAY m.porcdesc ;
   SIZE 1,8 ;
   PICTURE "999.9999" ;
   COLOR N/W

@ 20,65 SAY m.importdesc ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR N/W

@ 21,65 SAY pnImpuesto ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR N/W

@ 22,65 SAY m.monto_fact ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR B/W

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder) 
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _NextRecord    
*!
*!  Llamado por: VENTAS.PRG
*!
*!  Descripci¢n: Desplaza el puntero de registro al siguiente registro.
*!
*!*********************************************************************
FUNCTION _NextRecord
IF .NOT. EOF()
   SKIP 1
   IF EOF("cabecomp")           
      WAIT WINDOW "­ FIN DE LA TABLA !" NOWAIT
      SKIP -1
   ELSE
      DO _RefreshInvoice
   ENDIF
ELSE
   WAIT WINDOW "­ FIN DE LA TABLA !" NOWAIT
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _PriorRecord    
*!
*!  Llamado por: VENTAS.PRG
*!
*!  Descripci¢n: Desplaza el puntero de registro al registro anterior.
*!
*!*********************************************************************
FUNCTION _PriorRecord
IF .NOT. BOF()
   SKIP -1
   IF BOF("cabecomp")
      WAIT WINDOW "­ INICIO DE LA TABLA !" NOWAIT
      GO TOP
   ELSE
      DO _RefreshInvoice
   ENDIF
ELSE
   WAIT WINDOW "­ INICIO DE LA TABLA !" NOWAIT            
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _TopRecord    
*!
*!  Llamado por: VENTAS.PRG
*!
*!  Descripci¢n: Desplaza el puntero de registro al primer registro.
*!
*!*********************************************************************
FUNCTION _TopRecord
GO TOP 
IF NOT BOF()
   DO _RefreshInvoice
ELSE
   WAIT WINDOW "­ INICIO DE LA TABLA !" NOWAIT
ENDIF


*!*********************************************************************
*!
*!      Funci¢n: _BottomRecord 
*!
*!  Llamado por: VENTAS.PRG
*!
*!  Descripci¢n: Desplaza el puntero de registro al £ltimo registro.
*!
*!*********************************************************************
FUNCTION _BottomRecord
GO BOTTOM
IF .NOT. EOF()
   DO _RefreshInvoice
ELSE
   WAIT WINDOW "­ FIN DE LA TABLA !" NOWAIT
ENDIF

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

IF EOF()
   DO WHILE .T.
      WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
      IF UPPER(pcAppend) = "S"
         DO mkcompra.prg WITH "Add"
         DO _RefreshInvoice
         EXIT DO
      ENDIF
      IF UPPER(pcAppend) = "N"
         EXIT DO
      ENDIF
   ENDDO    
   POP KEY
   RETURN
ENDIF

IF cabecomp.monto_pago <> 0 .OR. ;
   cabecomp.monto_ndeb <> 0 .OR. ;
   cabecomp.monto_ncre <> 0
   WAIT WINDOW "­ ESTA COMPRA POSEE ALGUN DEBITO Y/O CREDITO, IMPOSIBLE BORRARLA !"   
   POP KEY 
   RETURN
ENDIF

DO WHILE .T.
   WAIT WINDOW "¨ DESEA BORRAR ESTA COMPRA ? [S/N]" TO pcDelete  

   IF UPPER(pcDelete) = "S"
      EXIT DO
   ENDIF

   IF UPPER(pcDelete) = "N"
      EXIT DO 
   ENDIF

ENDDO

IF UPPER(pcDelete) = "S"
   *-- Borra la(s) cuota(s) de la compra.
   SELECT cuotas_c
   SET ORDER TO TAG indice1 OF cuotas_c.cdx

   IF SEEK(STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9))
      SCAN WHILE STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9) = STR(cuotas_c.tipodocu, 1) + STR(cuotas_c.nrodocu, 9)
         DELETE
     ENDSCAN
   ENDIF
   
   *-- Borra detalle de la compra y actualiza la existencia de mercader¡as.
   SELECT detacomp
   SET ORDER TO TAG indice1 OF detacomp.cdx
   
   IF SEEK(STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9) + STR(cabecomp.proveedor, 5))
      SCAN WHILE STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9) + STR(cabecomp.proveedor, 5) = STR(detacomp.tipodocu, 1) + STR(detacomp.nrodocu, 9) + STR(detacomp.proveedor, 5)
         SELECT maesprod
         SET ORDER TO TAG indice1 OF maesprod.cdx

         IF SEEK(detacomp.articulo)
            REPLACE maesprod.stock_actu WITH (maesprod.stock_actu - detacomp.cantidad)
         ELSE
            WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL ARTICULO: " + ALLTRIM(detacomp.articulo) + " !"
         ENDIF
         SELECT detacomp
         DELETE
      ENDSCAN
   ELSE
      IF cabecomp.tipodocu <> 0 .AND. cabecomp.nrodocu <> 0
         WAIT WINDOW "­ NO SE HA ENCONTRADO DETALLE A BORRAR !"
      ENDIF
   ENDIF
  
   *-- Actualiza el saldo del proveedor, si es una compra a cr‚dito.
   IF cabecomp.tipodocu = 2
      SELECT proveedo
      IF SEEK(cabecomp.proveedor)
         REPLACE proveedo.saldo_actu WITH (proveedo.saldo_actu - cabecomp.monto_fact)
      ENDIF
   ENDIF
 
   *-- Borra el encabezado del comprobante de venta.
   SELECT cabecomp
   SET ORDER TO TAG indice1 OF cabecomp.cdx

   IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 9))
      SCAN WHILE STR(m.tipodocu, 1) + STR(m.nrodocu, 9) = STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9)
         DELETE
      ENDSCAN
   ENDIF

   WAIT WINDOW "­ ESTA COMPRA HA SIDO BORRADA !"

   IF EOF()
      GO BOTTOM
   ENDIF

   DO _RefreshInvoice

ENDIF

POP KEY

*!**************************************************************************
*!
*!  PROCEDIMIENTO: calc_pie_factura   
*!
*!    DESCRIPCION: Calcula e imprime el pie del comprobante de venta.
*!
*!**************************************************************************
PROCEDURE calc_pie_factura
   PRIVATE nSelect, cOrder, nRecNo
   nSelect = SELECT()
   cOrder  = ORDER()
   nRecNo  = IIF(EOF(), 0, RECNO())

   STORE 0 TO mdecimales, mgrav_10, mgrav_5, mgrav_2, mexento, miva, ;
              msubtotal, mporc_desc, msubtotal2, mpart_10, mpart_5, ;
              mpart_2, mpart_exen
             
   mdecimales = IIF(m.moneda = 1, 0, 2)

   SELECT tmpdetcomp
   SCAN ALL
      DO CASE
         CASE pimpuesto = 10     && I.V.A. 10%
            mgrav_10 = mgrav_10 + ROUND(precio * cantidad, mdecimales) - ROUND(ROUND(precio * cantidad, mdecimales) * pdescuento / 100, mdecimales)
         CASE pimpuesto = 5      && I.V.A. 5%
            mgrav_5  = mgrav_5  + ROUND(precio * cantidad, mdecimales) - ROUND(ROUND(precio * cantidad, mdecimales) * pdescuento / 100, mdecimales)
         CASE pimpuesto = 2      && I.V.A. 2%
            mgrav_2  = mgrav_2  + ROUND(precio * cantidad, mdecimales) - ROUND(ROUND(precio * cantidad, mdecimales) * pdescuento / 100, mdecimales)
         CASE pimpuesto = 0      && EXENTO
            mexento  = mexento  + ROUND(precio * cantidad, mdecimales) - ROUND(ROUND(precio * cantidad, mdecimales) * pdescuento / 100, mdecimales)
         OTHERWISE
            WAIT WINDOW "ERROR, TIPO DE IMPUESTO DESCONOCIDO; NOTIFIQUE AL PROGRAMADOR !"
      ENDCASE
   ENDSCAN

   msubtotal  = mgrav_10 + mgrav_5 + mgrav_2 + mexento
   msubtotal2 = msubtotal

   mpart_10   = ROUND(mgrav_10 / msubtotal, 8)
   mpart_5    = ROUND(mgrav_5  / msubtotal, 8)
   mpart_2    = ROUND(mgrav_2  / msubtotal, 8)

   IF m.porcdesc > 0 THEN
      m.importdesc = ROUND(msubtotal * m.porcdesc / 100, mdecimales)
   ENDIF
   
   IF m.importdesc > 0 THEN
      mporc_desc = ROUND(m.importdesc / msubtotal, 8)
      m.descuento = ROUND(m.importdesc / msubtotal * 100, 8)
      msubtotal2 = msubtotal - ROUND(msubtotal * mporc_desc, mdecimales)

      mgrav_10 = mgrav_10 - ROUND(m.importdesc * mpart_10, mdecimales)
      mgrav_5  = mgrav_5  - ROUND(m.importdesc * mpart_5 , mdecimales)
      mgrav_2  = mgrav_2  - ROUND(m.importdesc * mpart_2 , mdecimales)
      mexento  = mexento  - (m.importdesc - (ROUND(m.importdesc * mpart_10, mdecimales) + ;
                                             ROUND(m.importdesc * mpart_5 , mdecimales) + ;
                                             ROUND(m.importdesc * mpart_2 , mdecimales)))
   ENDIF

   IF .NOT. INLIST(m.tipodocu, 3, 7, 8) THEN
      miva = ROUND(mgrav_10 * 0.1, mdecimales)
      miva = miva + ROUND(mgrav_5 * 0.05, mdecimales)
      miva = miva + ROUND(mgrav_2 * 0.02, mdecimales)
   ENDIF

   IF .NOT. EMPTY(ALIAS(nSelect)) THEN
      SELECT (nSelect)
      SET ORDER TO TAG (cOrder)
      IF nRecNo <> 0 THEN
         GOTO RECORD nRecNo
      ENDIF
   ENDIF

   m.monto_fact = msubtotal2 + miva

   *// Imprime en la pantalla el resultado de los calculos
   @ 19,65 SAY msubtotal ;
      SIZE 1,14 ;
      PICTURE "999,999,999.99" ;
      COLOR N/W

   @ 20,43 SAY m.porcdesc ;
      SIZE 1,8 ;
      PICTURE "999.9999" ;
      COLOR N/W

   @ 20,65 SAY m.importdesc ;
      SIZE 1,14 ;
      PICTURE "999,999,999.99" ;
      COLOR N/W

   @ 21,65 SAY miva ;
      SIZE 1,14 ;
      PICTURE "999,999,999.99" ;
      COLOR N/W

   @ 22,65 SAY m.monto_fact ;
      SIZE 1,14 ;
      PICTURE "999,999,999.99" ;
      COLOR B/W
*ENDPROC