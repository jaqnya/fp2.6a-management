*:*********************************************************************
*:
*: Archivo de Procedimiento: VENTAS.PRG
*:
*:                  Sistema: Integrado de Gesti¢n Financiera.
*:              Sub-Sistema: Ventas.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 28/02/2004
*:
*:*********************************************************************
WAIT WINDOW "POR FAVOR, ESPERE MIENTRAS SE CARGA EL MODULO..." NOWAIT

*-- Variables de la Tabla de Cabecera.
PRIVATE m.tipodocu, m.nrodocu, m.lstprecio, m.fechadocu, m.serie, m.nroot, m.moneda, m.tipocambio, m.nroremi, m.fecharemi, m.cliente, m.vendedor, m.comision_1, m.porcdesc, m.importdesc, m.impreso, m.fechaanu, m.anulado, m.monto_fact, m.monto_cobr, m.monto_ndeb, m.monto_ncre

*-- Variables para c lculos del programa.
PRIVATE pnGravada, pnExenta, pnImpuesto, pnSubTotal

*-- Inicializa variables del programa.
STORE .F. TO plAdding, plEditing

*-- MS-DOS  Definiciones de ventanas.
IF NOT WEXIST("tmpdetvent")
   DEFINE WINDOW tmpdetvent ;
      FROM 08,00 ;
      TO 18,79 ;
      TITLE "DETALLE" ;
      NOFLOAT ;
      CLOSE ;
      NOSHADOW ;
      ZOOM ;
      NOMINIMIZE ;
      SYSTEM ;
      COLOR SCHEME 15
ENDIF

IF NOT WEXIST("tmpcuovent")
   DEFINE WINDOW tmpcuovent ;
      FROM 04,01 ;
      TO 20,78 ;
      TITLE "CUOTAS" ;
      NOFLOAT ;
      CLOSE ;
      NOSHADOW ;
      ZOOM ;
      NOMINIMIZE ;
      SYSTEM ;
      COLOR SCHEME 15
ENDIF

IF NOT WEXIST("tmpmarcuot")
   DEFINE WINDOW tmpmarcuot ;
      FROM 03,00 ;
      TO 21,79 ;
      NOFLOAT ;
      NOCLOSE ;
      NOSHADOW ;
      NOZOOM ;
      NOMINIMIZE ;
      COLOR SCHEME 1
ENDIF

IF NOT WEXIST("brwVentas")
   DEFINE WINDOW brwVentas ;
      FROM 01,00 ;
      TO 23,79 ;
      TITLE "< VENTAS >" ;
      NOFLOAT ;
      CLOSE ;
      NOSHADOW ;
      ZOOM ;
      NOMINIMIZE ;
      SYSTEM ;
      COLOR SCHEME 15
ENDIF

*-- MS-DOS Base de datos, ¡ndices, relaciones.
SELECT 0
temp01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp01 (tipodocu   N(01) ,;
                      nrodocu    N(07) ,;
                      articulo   C(15) ,;
                      cantidad   N(09,2) ,;
                      precio     N(13,4) ,;
                      pdescuento N(07,4) ,;
                      impuesto   L(01) ,;
                      pimpuesto  N(06,2) ,;
                      mecanico   N(03) ,;
                      comision_m N(06,2) ,;
                      descr_trab C(40))

USE &temp01 ALIAS tmpdetvent EXCLUSIVE
INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) TAG indice1
SET RELATION TO tmpdetvent.articulo INTO maesprod ,;        
                tmpdetvent.mecanico INTO mecanico ADDITIVE

SELECT 0
temp02 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp02 (tipodocu   N(01),;
                      nrodocu    N(07),;
                      tipo       N(01),;
                      nrocuota   N(03),;
                      fecha      D(08),;
                      importe    N(09),;
                      abonado    N(09),;
                      monto_ndeb N(09),;
                      monto_ncre N(09))
USE &temp02 ALIAS tmpcuovent EXCLUSIVE
INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) + STR(nrocuota, 3) TAG indice1

SELECT 0
temp03 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp03 (tipobole   N(01) ,;
                      serie      C(01) ,;
                      nrobole    N(07) ,;
                      articulo   C(15) ,;
                      cantidad   N(09,2) ,;
                      precio     N(13,4) ,;
                      pdescuento N(07,4) ,;
                      impuesto   L(01) ,;
                      pimpuesto  N(06,2) ,;
                      mecanico   N(03) ,;
                      comision_m N(06,2) ,;
                      descr_trab C(40))

USE &temp03 ALIAS tmpdetmot EXCLUSIVE
INDEX ON STR(tipobole, 1) + serie + STR(nrobole, 7) TAG indice1
INDEX ON articulo                                   TAG indice2

WAIT CLEAR

*-- Establece relaciones entre las tablas.
SELECT detavent
SET RELATION TO detavent.articulo INTO maesprod ADDITIVE

SELECT cabevent
SET RELATION TO cabevent.cliente INTO clientes ADDITIVE
SET RELATION TO cabevent.moneda  INTO monedas  ADDITIVE

SELECT cabevent
GO TOP
SCATTER MEMVAR MEMO

DO _RefreshInvoice
DO _PrintHelpBar

*-- Bucle principal del programa.
DO WHILE .T.  
   pnKey = INKEY(0, "HM")         && Tomar INKEY(), ocultar cursor, comprobar rat¢n.
   IF pnKey = 0                   && No hay pulsaci¢n de tecla ni rat¢n.
      LOOP
   ENDIF
   IF pnKey = K_ESCAPE            && Tecla ESC presionada,              
      EXIT                        && salir del bucle principal.
   ENDIF
   IF pnKey = 151                 && Clic sencillo del rat¢n.
      LOOP
   ENDIF
   DO CASE
      CASE pnKey = K_F2           && Tecla F2 presionada, agregar registro.
         IF UserConfig("ventas.prg", "Add", .T.)
            DO mkventas.prg WITH "Add"
            DO _RefreshInvoice
         ENDIF
      CASE pnKey = K_F3           && Tecla F3 presionada, modificar registro.
         IF UserConfig("ventas.prg", "Edit", .T.)
            DO mkventas.prg WITH "Edit"
            DO _RefreshInvoice
         ENDIF
      CASE pnKey = K_F8           && Tecla F8 presionada, eliminar registro
         IF cabevent.fechadocu <> DATE() THEN
            WAIT "LOS REGISTROS DE ESTA TABLA NO PUEDEN SER BORRADOS O ANULADOS !" WINDOW NOWAIT
            LOOP
         ENDIF

         IF UserConfig("ventas.prg", "Delete", .T.)
            DO _DeleteInvoice
         ENDIF
      CASE pnKey = K_UP           && Tecla  presionada, siguiente registro.
         DO _NextRecord
      CASE pnKey = K_DOWN         && Tecla  presionada, registro anterior.
         DO _PriorRecord         
      CASE pnKey = K_LEFT         && Tecla  presionada, primer registro.
         DO _TopRecord
      CASE pnKey = K_RIGHT        && Tecla -> presionada, £ltimo registro.
         DO _BottomRecord
      CASE INLIST(pnKey, 68, 100) && Tecla "D" may£scula o min£scula, examinar detalle.
         IF RECCOUNT("tmpdetvent") > 0
            DO _brwDetail
         ENDIF
      CASE pnKey = K_ENTER        && Tecla ENTER, visualizar cuotas.
         IF INLIST(cabevent.tipodocu, 1, 3, 4, 7) .AND. .NOT. cabevent.anulado
            WAIT WINDOW "­ LAS VENTAS AL CONTADO NO POSEEN CUOTAS !"
         ELSE
            IF cabevent.tipodocu <> 0 .AND. cabevent.nrodocu <> 0
               DO _brwQuota 
            ENDIF
         ENDIF
      CASE pnKey = K_F4           && Tecla F4 presionada, ordenar.         
         DO orden04.spr
      CASE pnKey = K_F10          && Tecla F10 presionada, examinar facturas.
         ON KEY LABEL "F4" DO orden04.spr
         ON KEY LABEL "F5" DO _vtaSwitch
         ON KEY LABEL "CTRL+HOME"  GO TOP
         ON KEY LABEL "CTRL+END"   GO BOTTOM

         DO _brwInvoices 

         ON KEY LABEL "F4" 
         ON KEY LABEL "F5" 
         ON KEY LABEL "CTRL+HOME"
         ON KEY LABEL "CTRL+END" 
         
         DO _RefreshInvoice
      CASE pnKey = K_F5           && Tecla F5 presionada, buscar.
         DO _vtaSwitch
      CASE pnKey = 15             && Tecla CTRL+O presionada, Datos de Cliente.
         DO _OthersData
      ENDCASE
ENDDO     Fin del bucle principal.     
        
*-- MS-DOS Cierre de Bases de Datos.
IF USED("tmpdetvent")
   SELECT tmpdetvent
   USE
ENDIF

DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"

IF USED("tmpcuovent")
   SELECT tmpcuovent
   USE
ENDIF

DELETE FILE &temp02
DELETE FILE SUBSTR(temp02, 1, ATC(".", temp02)) + "CDX"

IF USED("tmpdetmot")
   SELECT tmpdetmot 
   USE
ENDIF

DELETE FILE &temp03
DELETE FILE SUBSTR(temp03, 1, ATC(".", temp03)) + "CDX"

*-- Quiebra las relaciones entre las tablas.
SELECT detavent
SET RELATION OFF INTO maesprod

SELECT cabevent
SET RELATION OFF INTO clientes
SET RELATION OFF INTO monedas

*-- Elimina ventanas.
IF WEXIST("tmpdetvent")
   RELEASE WINDOW tmpdetvent
ENDIF

IF WEXIST("tmpcuovent")
   RELEASE WINDOW tmpcuovent
ENDIF

IF WEXIST("tmpmarcuot")
   RELEASE WINDOW tmpmarcuot
ENDIF

IF WEXIST("brwVentas")
   RELEASE WINDOW brwVentas
ENDIF

*-- MS-DOS Procedimientos y funciones de soporte.
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

DO _fmtInvoice
DO _ShowHeader
DO _ShowDetail
DO calc_pie_factura
DO _LoadQuota

IF cabevent.anulado
   WAIT WINDOW "­ FACTURA ANULADA !" NOWAIT
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _fmtInvoice     
*!
*!  Llamado por: _RefreshInvoice
*!
*!  Descripci¢n: Dibuja el formato de la factura. 
*!
*!*********************************************************************
FUNCTION _fmtInvoice
@ 01,00 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 02,00 SAY "³ Documento..:                             N§:          Lista de Precios N§:   ³"
@ 03,00 SAY "³ Fecha Fact.:                          OT N§:                                 ³"
@ 04,00 SAY "³                                                                              ³"
@ 05,00 SAY "³ Cliente....:                                                                 ³"
@ 06,00 SAY "³ Moneda.....:                                      Tipo de Cambio:            ³"
@ 07,00 SAY "³ Vendedor...:                                                                 ³"
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

SELECT cabevent
SCATTER MEMVAR

@ 02,15 SAY m.tipodocu ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W

*-- Imprime la etiqueta del tipo de documento.
DO CASE
   CASE m.tipodocu = 1
      @ 02,18 SAY "VENTA CONTADO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 2
      @ 02,18 SAY "VENTA CREDITO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 3
      @ 02,18 SAY "VENTA I.V.A. INCLUIDO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 4
      @ 02,18 SAY "VENTA TRIBUTO UNICO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 5
      @ 02,18 SAY "C.I. VENTA CONTADO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 6
      @ 02,18 SAY "C.I. VENTA CREDITO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 7
      @ 02,18 SAY "CONTADO I.V.A. INCLUIDO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 8
      @ 02,18 SAY "CREDITO I.V.A. INCLUIDO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   OTHERWISE
      @ 02,18 SAY REPLICATE(CHR(32), 23) ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
ENDCASE

@ 02,47 SAY m.nrodocu ;
   SIZE 1,7 ;
   PICTURE "9999999" ;
   COLOR N/W

@ 02,77 SAY m.lstprecio ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W

@ 03,15 SAY m.fechadocu ;
   SIZE 1,10 ;
   PICTURE "@D" ;
   COLOR N/W

@ 03,47 SAY m.serie ;
   SIZE 1,1 ;
   PICTURE "@A!" ;
   COLOR N/W

@ 03,49 SAY m.nroot ;
   SIZE 1,7 ;
   PICTURE "9999999" ;
   COLOR N/W

@ 05,15 SAY m.cliente  ;
   SIZE 1,5 ;
   PICTURE "99999" ;
   COLOR N/W

*-- Imprime el nombre del cliente selecionado.
IF EMPTY(m.nroot)
   SELECT clientes
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
   ENDIF
ELSE
   SELECT ot             
   IF SEEK(m.serie + STR(m.nroot, 7))
      @ 05,22 SAY PADR(ALLTRIM(ot.nombreot), 56, CHR(32)) ;
         SIZE 1,56 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 05,22 SAY REPLICATE(CHR(32), 56) ;
         SIZE 1,56 ;
         PICTURE "@!" ;
         COLOR W/N
   ENDIF
ENDIF
SELECT cabevent

*-- Imprime el nombre del cliente selecionado.
SELECT cabeven2
IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
   IF .NOT. EMPTY(nombre)
      @ 05,22 SAY PADR(ALLTRIM(cabeven2.nombre), 56, CHR(32)) ;
         SIZE 1,56 ;
         PICTURE "@!" ;
         COLOR W/N
   ENDIF
ENDIF
SELECT cabevent

@ 06,15 SAY m.moneda ;
   SIZE 1,4 ;
   PICTURE "9999" ;
   COLOR N/W

*-- Imprime la nombre de la moneda seleccionada.
SELECT monedas
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
ENDIF
SELECT cabevent

@ 06,68 SAY m.tipocambio ;
   SIZE 1,09 ;
   PICTURE "999999.99" ;
   COLOR N/W

@ 07,15 SAY m.vendedor ;
   SIZE 1,3 ;
   PICTURE "999" ;
   COLOR N/W

*-- Imprime el nombre del vendedor seleccionado.
SELECT vendedor
SET ORDER TO TAG indice1 OF vendedor.cdx

IF SEEK(m.vendedor)
   @ 07,22 SAY PADR(ALLTRIM(vendedor.nombre), 30, CHR(32)) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 07,22 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF
SELECT cabevent

*@ 07,68 SAY m.comision_1 ;   // deactivado por orden de
*   SIZE 1,6 ;                // FELIPE ALVAREZ
*   PICTURE "999.99" ;        // motivo: confidencialidad
*   COLOR N/W
  

*----////----////----////----////----////----*
PRIVATE mRepuestos, mServicios, mOtros

STORE 0 TO mRepuestos, mServicios, mOtros

SELECT detavent
SET ORDER TO TAG indice1 OF detavent.cdx

IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
   SCAN WHILE STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7) = STR(detavent.tipodocu, 1) + STR(detavent.nrodocu, 7)
      IF INLIST(detavent.articulo, "99001", "99002", "99003", "99010", "99011", "99012", "99013", "99014", "99020", "99021", "99022", "10001")            
         mServicios = mServicios+ ROUND(detavent.precio * detavent.cantidad, 0)
      ELSE
         mRepuestos = mRepuestos+ ROUND(detavent.precio * detavent.cantidad, 0)
      ENDIF
   ENDSCAN
   *//mRepuestos = mRepuestos - cabevent.importdesc
   mRepuestos = mRepuestos - IIF(INLIST(cabevent.tipodocu, 3, 7, 8), ROUND(cabevent.importdesc / 1.1, 0), cabevent.importdesc)
ENDIF

@ 22,01 SAY " Repuestos:" ;
   SIZE 1,11 ;
   PICTURE "@" ;
   COLOR W+/N

@ 22,23 SAY "Servicios:" ;
   SIZE 1,10 ;
   PICTURE "@" ;
   COLOR W+/N

@ 22,13 SAY mRepuestos ;
   SIZE 1,9 ;
   PICTURE "9,999,999" ;
   COLOR N/W

@ 22,34 SAY mServicios ;
   SIZE 1,9 ;
   PICTURE "9,999,999" ;
   COLOR N/W
*----////----////----////----////----////----*

IF INLIST(m.tipodocu, 3, 7, 8)
   */ Calcula el I.V.A. */

   PRIVATE nSelect, cOrder, nRecNo
   nSelect = SELECT()
   cOrder  = ORDER()
   nRecNo  = IIF(EOF(), 0, RECNO())

   STORE 0 TO mdecimales, mgrav_10, mgrav_5, mgrav_2, mexento, miva, ;
              msubtotal, mporc_desc, msubtotal2, mpart_10, mpart_5, ;
              mpart_2, mpart_exen
             
   mdecimales = IIF(m.moneda = 1, 0, 2)

   SELECT detavent
   SET ORDER TO TAG "indice1"
   
   IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
      SCAN WHILE cabevent.tipodocu = tipodocu AND cabevent.nrodocu = nrodocu
         x = IIF(INLIST(m.tipodocu, 3, 7, 8), ROUND(precio * (1 + pimpuesto / 100), IIF(m.moneda = 1, 0, 2)), precio)
         DO CASE
            CASE pimpuesto = 10     && I.V.A. 10%
               mgrav_10 = mgrav_10 + ROUND(x * cantidad, mdecimales)
            CASE pimpuesto = 5      && I.V.A. 5%
               mgrav_5  = mgrav_5  + ROUND(x * cantidad, mdecimales)
            CASE pimpuesto = 2      && I.V.A. 2%
               mgrav_2  = mgrav_2  + ROUND(x * cantidad, mdecimales)
            CASE pimpuesto = 0      && EXENTO
               mexento  = mexento  + ROUND(x * cantidad, mdecimales)
            OTHERWISE
               WAIT WINDOW "ERROR, TIPO DE IMPUESTO DESCONOCIDO; NOTIFIQUE AL PROGRAMADOR !"
         ENDCASE
      ENDSCAN
   ENDIF

   msubtotal  = mgrav_10 + mgrav_5 + mgrav_2 + mexento
   msubtotal2 = msubtotal

   mpart_10   = ROUND(mgrav_10 / msubtotal, 8)
   mpart_5    = ROUND(mgrav_5  / msubtotal, 8)
   mpart_2    = ROUND(mgrav_2  / msubtotal, 8)

   IF m.importdesc > 0 THEN
      mporc_desc = ROUND(m.importdesc / msubtotal, 8)
      msubtotal2 = msubtotal - ROUND(msubtotal * mporc_desc, mdecimales)

      mgrav_10 = mgrav_10 - ROUND(m.importdesc * mpart_10, mdecimales)
      mgrav_5  = mgrav_5  - ROUND(m.importdesc * mpart_5 , mdecimales)
      mgrav_2  = mgrav_2  - ROUND(m.importdesc * mpart_2 , mdecimales)
      mexento  = mexento  - (m.importdesc - (ROUND(m.importdesc * mpart_10, mdecimales) + ;
                                             ROUND(m.importdesc * mpart_5 , mdecimales) + ;
                                             ROUND(m.importdesc * mpart_2 , mdecimales)))
   ENDIF


   IF INLIST(m.tipodocu, 3, 7, 8)
      miva10 =  ROUND(mgrav_10 / 11, mdecimales)
      miva5  =  ROUND(mgrav_5  / 21, mdecimales)
      miva2  =  ROUND(mgrav_2  / 51, mdecimales)
   ELSE
      miva10 =  ROUND(mgrav_10 * 0.10, mdecimales)
      miva5  =  ROUND(mgrav_5  * 0.05, mdecimales)
      miva2  =  ROUND(mgrav_2  * 0.02, mdecimales)
   ENDIF

   @ 19,02 CLEAR TO 21,41

   @ 19,02 SAY "I.V.A.: ( 5%)"
   @ 20,02 SAY "I.V.A.: (10%)"

   @ 19,16 SAY miva5 ;
      SIZE 1,14 ;
      PICTURE "999,999,999.99" ;
      COLOR N/W

   @ 20,16 SAY miva10 + miva2 ;
      SIZE 1,14 ;
      PICTURE "999,999,999.99" ;
      COLOR N/W

   IF .NOT. EMPTY(ALIAS(nSelect)) THEN
      SELECT (nSelect)
      SET ORDER TO TAG (cOrder)
      IF nRecNo <> 0 THEN
         GOTO RECORD nRecNo
      ENDIF
   ENDIF
ENDIF
*----////----////----////----////----////----*


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

SELECT tmpdetvent     &&   Vaca la  tabla  temporal  que  contiene  el
ZAP                   &&   detalle de art¡culos del documento.

SELECT detavent

IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
   SCAN WHILE STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7) = STR(detavent.tipodocu, 1) + STR(detavent.nrodocu, 7)
      INSERT INTO tmpdetvent (tipodocu, nrodocu, articulo, cantidad, precio, pdescuento, impuesto, pimpuesto, mecanico, comision_m, descr_trab) ;
         VALUES (detavent.tipodocu, detavent.nrodocu, detavent.articulo, detavent.cantidad, IIF(INLIST(m.tipodocu, 3, 7, 8), ROUND(detavent.precio * (1 + detavent.pimpuesto / 100), 4), detavent.precio), detavent.pdescuento, detavent.impuesto, detavent.pimpuesto, detavent.mecanico, detavent.comision_m, detavent.descr_trab)
   ENDSCAN
ELSE
  IF NOT cabevent.anulado .AND. cabevent.tipodocu <> 0 .AND. cabevent.nrodocu <> 0
     WAIT WINDOW "ESTE DOCUMENTO NO POSEE DETALLE, BORRELO Y VUELVA A CARGARLO"
  ENDIF
ENDIF

SELECT cabevent
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

DO SaveWorkArea

#DEFINE pnRow    8
#DEFINE pnColumn 2

SELECT tmpdetvent
GO TOP

SCAN WHILE RECNO() <= 9 .AND. .NOT. (EMPTY(articulo) .OR. EMPTY(cantidad) .OR. EMPTY(precio))
   @ pnRow + RECNO(), pnColumn      SAY IIF(EMPTY(tmpdetvent.descr_trab), SUBSTR(maesprod.nombre, 1, 39), SUBSTR(tmpdetvent.descr_trab, 1, 39)) COLOR N/W
   @ pnRow + RECNO(), pnColumn + 40 SAY cantidad                       PICTURE "999,999.99"      COLOR N/W
   @ pnRow + RECNO(), pnColumn + 51 SAY precio                         PICTURE "99,999,999.9999" COLOR N/W
   @ pnRow + RECNO(), pnColumn + 67 SAY ROUND(precio * cantidad, 0)    PICTURE "99,999,999"      COLOR N/W
ENDSCAN

DO RestoreWorkArea

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

   SELECT tmpdetvent
   SCAN ALL
      DO CASE
         CASE pimpuesto = 10     && I.V.A. 10%
            mgrav_10 = mgrav_10 + ROUND(precio * cantidad, mdecimales)
         CASE pimpuesto = 5      && I.V.A. 5%
            mgrav_5  = mgrav_5  + ROUND(precio * cantidad, mdecimales)
         CASE pimpuesto = 2      && I.V.A. 2%
            mgrav_2  = mgrav_2  + ROUND(precio * cantidad, mdecimales)
         CASE pimpuesto = 0      && EXENTO
            mexento  = mexento  + ROUND(precio * cantidad, mdecimales)
         OTHERWISE
            WAIT WINDOW "ERROR, TIPO DE IMPUESTO DESCONOCIDO; NOTIFIQUE AL PROGRAMADOR !"
      ENDCASE
   ENDSCAN

   msubtotal  = mgrav_10 + mgrav_5 + mgrav_2 + mexento
   msubtotal2 = msubtotal

   mpart_10   = ROUND(mgrav_10 / msubtotal, 8)
   mpart_5    = ROUND(mgrav_5  / msubtotal, 8)
   mpart_2    = ROUND(mgrav_2  / msubtotal, 8)

   IF m.importdesc > 0 THEN
      mporc_desc = ROUND(m.importdesc / msubtotal, 8)
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

SELECT tmpcuovent     &&   Vac¡a la  tabla  temporal  que  contiene las
ZAP                   &&   cuotas del documento.

SELECT cuotas_v

IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
   SCAN WHILE STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7) = STR(cuotas_v.tipodocu, 1) + STR(cuotas_v.nrodocu, 7)
      INSERT INTO tmpcuovent (tipodocu, nrodocu, tipo, nrocuota, fecha, importe, abonado, monto_ndeb, monto_ncre) ;
         VALUES (cuotas_v.tipodocu, cuotas_v.nrodocu, cuotas_v.tipo, cuotas_v.nrocuota, cuotas_v.fecha, cuotas_v.importe, cuotas_v.abonado, cuotas_v.monto_ndeb, cuotas_v.monto_ncre)
   ENDSCAN
ELSE
  IF .NOT. cabevent.anulado .AND. cabevent.tipodocu = 2
     WAIT WINDOW "     ­ ESTE DOCUMENTO NO POSEE CUOTAS !" + CHR(13) + ;
                 "MODIFIQUELO PARA VOLVER A GENERAR LAS CUOTAS"
  ENDIF
ENDIF

SELECT cabevent

*!*********************************************************************
*!
*!      Funci¢n: _brwDetail     
*!
*!  Llamado por: VENTAS.PRG       
*!
*!  Descripci¢n: Examina el detalle de art¡culos del documento.
*!
*!*********************************************************************
FUNCTION _brwDetail 

SELECT tmpdetvent
GO TOP

BROWSE WINDOW tmpdetvent FIELDS ;
   calc_f0 = SUBSTR(articulo, 1, 13)        :R:13:H = "C¢digo" ,;
   calc_f1 = IIF(EMPTY(descr_trab), SUBSTR(maesprod.nombre, 1, 36), descr_trab) :R:36:H = "Descripci¢n" :P = "@!" :W = .F. ,;
   cantidad                                 :R:09:H = "Cantidad"     :P = "999999.99" ,;
   precio                                   :R:15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = .F. ,;
   calc_f2 = ROUND(precio * cantidad, 0)    :R:15:H = "Sub-Total"    :P = "999,999,999,999"    :W = .F. ,;
   calc_f3 = IIF(impuesto, "   S¡", "")     :R:08:H = "Impuesto"     :W = .F. ,;
   pimpuesto                                :R:06:H = "% Imp."       :P = "999.99" :W = .F. ,;
   mecanico                                 :R:03:H = "Mec"          :P = "999" ,;
   calc_f5 = SUBSTR(mecanico.nombre, 1, 30) :R:30:H = "Nombre del Mec nico" ;
   NOAPPEND NODELETE NOMODIFY

SELECT cabevent

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

SELECT tmpcuovent
GO TOP

BROWSE WINDOW tmpcuovent FIELDS ;
   calc_f1 = IIF(tipo = 1,"Entr",IIF(tipo = 2,"Cuota",""))     :R:04:H="Tipo" ,;
   nrocuota                                                    :R:03:H="N§"         :P="999",;
   fecha                                                       :R:10:H="Fecha Vcto" ,;
   importe                                                     :R:10:H="Importe"    :P="99,999,999" ,;
   calc_f2 = ((importe + monto_ndeb) - (monto_ncre + abonado)) :R:10:H="Saldo"      :P="99,999,999" ,;
   abonado                                                     :R:10:H="Abonado"    :P="99,999,999" ,;
   monto_ndeb                                                  :R:10:H="Monto Ndeb" :P="99,999,999" ,;
   monto_ncre                                                  :R:10:H="Monto Ncre" :P="99,999,999"  ;
   NOAPPEND NODELETE NOMODIFY

DEACTIVATE WINDOW tmpmarcuot

SELECT cabevent

*!*********************************************************************
*!
*!      Funci¢n: _brwInvoices   
*!
*!  Llamado por: VENTAS.PRG       
*!
*!  Descripci¢n: Examina los documentos cargados.
*!
*!*********************************************************************
FUNCTION _brwInvoices

SELECT cabevent

BROWSE WINDOW brwVentas FIELDS ;
   calc_f1 = IIF(INLIST(tipodocu, 1, 7),"VCO", IIF(INLIST(tipodocu, 2, 8),"VCR", IIF(tipodocu = 3, "VII", IIF(tipodocu = 4, "VTU", IIF(tipodocu = 5, "CIV", IIF(tipodocu = 6, "CCR", "")))))) :R:03:H = "" ,;
   nrodocu    :R:07:P = "9999999"     :H = "N§ Doc." ,;
   fechadocu  :R:10:P = "@D"          :H = "Fecha Doc." ,;
   monto_fact :R:11:P = "999,999,999" :H = "Monto Fact." ,;
   calc_f2 = ((monto_fact + monto_ndeb) - (monto_cobr + monto_ncre)) :R:11:P = "999,999,999" :H = "   Saldo" ,;
   calc_f3 = IIF(anulado, "A N U L A D O", SUBSTR(clientes.nombre, 1, 56)) :R:56:P = "@!" :H = "Cliente" ,;
   calc_f4 = IIF(tipodocu = 1,"VCO", IIF(tipodocu = 2,"VCR", IIF(tipodocu = 3, "VII", IIF(tipodocu = 4, "VTU", "")))) :R:03:H = "" ,;
   calc_f5 = nrodocu :R:07:P = "9999999" :H = "N§ Doc." ,;
   calc_f6 = monto_fact :R:11:P = "999,999,999" :H = "Monto Fact." ,;
   monto_cobr :R:11:P = "999,999,999" :H = "Monto Cobr." ,;
   monto_ndeb :R:11:P = "999,999,999" :H = "Monto N.Deb" ,;
   monto_ncre :R:11:P = "999,999,999" :H = "Monto N.Cre", ;
   calc_f7 = ((monto_fact + monto_ndeb) - (monto_cobr + monto_ncre)) :R:11:P = "999,999,999" :H = "   Saldo" ,;
   cliente :R:07:P = "9999999" :H = "C¢d.Cli" ;
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
FUNCTION _vtaSwitch

PUSH KEY CLEAR

IF EOF()
   DO WHILE .T.
      WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
      IF UPPER(pcAppend) = "S"
         DO mkventas.prg WITH "Add"
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
      DO buscar14.spr
ENDCASE

POP KEY

IF FOUND()
   DO _RefreshInvoice
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _DeleteInvoice 
*!
*!  Llamado por: VENTAS.PRG       
*!
*!  Descripci¢n: Borra el documento de venta siempre y cuando los  cam- 
*!               pos monto_cobr, monto_ndeb, monto_ncre  sean  igual  a 
*!               cero.
*!
*!*********************************************************************
FUNCTION _DeleteInvoice

PUSH KEY CLEAR

IF EOF()
   DO WHILE .T.
      WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
      IF UPPER(pcAppend) = "S"
         DO mkventas.prg WITH "Add"
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

IF cabevent.monto_cobr <> 0 .OR. ;
   cabevent.monto_ndeb <> 0 .OR. ;
   cabevent.monto_ncre <> 0
   WAIT WINDOW "­ ESTA VENTA POSEE ALGUN DEBITO Y/O CREDITO, IMPOSIBLE BORRARLA !"   
   POP KEY 
   RETURN
ENDIF

DO WHILE .T.
   WAIT WINDOW "¨ DESEA BORRAR ESTA VENTA ? [S/N]" TO pcDelete  

   IF UPPER(pcDelete) = "S"
      EXIT DO
   ENDIF

   IF UPPER(pcDelete) = "N"
      EXIT DO 
   ENDIF

ENDDO

IF UPPER(pcDelete) = "S"
   DO WHILE .T.   
      WAIT WINDOW "¨ DESEA: (B)ORRARLO o (A)NULARLO ?" TO pcDelOrAnnul
   
      IF UPPER(pcDelOrAnnul) = "B" .OR. ;
         UPPER(pcDelOrAnnul) = "A"

         IF cabevent.monto_cobr = 0 .AND. ;
            cabevent.monto_ndeb = 0 .AND. ;
            cabevent.monto_ncre = 0
 
            *-- Borra la(s) cuota(s) del comprobate de venta.
            SELECT cuotas_v
            IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
               SCAN WHILE STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7) = STR(cuotas_v.tipodocu, 1) + STR(cuotas_v.nrodocu, 7)
                  DELETE
               ENDSCAN
            ENDIF
   
            *-- Borra detalle del comprobante de venta y actualiza la existencia de mercader¡as.
            SELECT detavent
            IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
               SCAN WHILE STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7) = STR(detavent.tipodocu, 1) + STR(detavent.nrodocu, 7)
                  SELECT maesprod
                  SET ORDER TO TAG indice1 OF maesprod.cdx
                  IF SEEK(detavent.articulo)
                     REPLACE maesprod.stock_actu WITH maesprod.stock_actu + detavent.cantidad
                  ELSE
                     WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL ARTICULO: " + ALLTRIM(detavent.articulo) + " !"
                  ENDIF
                  SELECT detavent
                  DELETE
               ENDSCAN
            ELSE
               IF NOT cabevent.anulado .AND. cabevent.tipodocu <> 0 .AND. cabevent.nrodocu <> 0
                  WAIT WINDOW "­ NO SE HA ENCONTRADO DETALLE A BORRAR !"
               ENDIF
            ENDIF
  
            *-- Actualiza el saldo del cliente, si es un comprobante de venta a cr‚dito.
            IF cabevent.tipodocu = 2
               SELECT clientes
               IF SEEK(cabevent.cliente)
                  REPLACE saldo_actu WITH saldo_actu - cabevent.monto_fact
               ENDIF
            ENDIF
 
            *-- Actualiza el saldo del cliente, si es un comprobante de venta a cr‚dito.
            IF cabevent.nroot > 0
               SELECT ot
               SET ORDER TO TAG indice1 OF ot.cdx
            
               IF SEEK(cabevent.serie + STR(cabevent.nroot, 7))
                  REPLACE ot.estadoot WITH 5 ,;
                          ot.tipodocu WITH 0 ,;
                          ot.nrodocu  WITH 0 ,;
                          ot.fentrega WITH {}
               ENDIF
            ENDIF

            *-- Borra o anula el encabezado del comprobante de venta.
            IF UPPER(pcDelOrAnnul) = "B"
               SELECT cabevent
               SET ORDER TO TAG indice1 OF cabevent.cdx
               
               IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7))
                  SCAN WHILE STR(m.tipodocu, 1) + STR(m.nrodocu, 7) = STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)
                     DELETE
                  ENDSCAN
                  WAIT WINDOW "­ ESTA VENTA HA SIDO BORRADA !"

                  IF EOF()
                     GO BOTTOM
                  ENDIF
                  DO _RefreshInvoice

               ENDIF
            ELSE
               IF UPPER(pcDelOrAnnul) = "A"
                  SELECT cabeven2
                  SET ORDER TO 1
                  
                  IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7)) THEN
                     DELETE
                  ENDIF
                  
                  SELECT cabevent
                  SET ORDER TO 1
                  
                  IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7))
*                    SCAN WHILE STR(m.tipodocu, 1) + STR(m.nrodocu, 7) = STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)
                        REPLACE lstprecio  WITH 0
                        REPLACE fechadocu  WITH {}
                        REPLACE serie      WITH ""
                        REPLACE nroot      WITH 0
                        REPLACE moneda     WITH 0
                        REPLACE tipocambio WITH 0
                        REPLACE nroremi    WITH 0
                        REPLACE fecharemi  WITH {}
                        REPLACE cliente    WITH 0
                        REPLACE vendedor   WITH 0
                        REPLACE comision_1 WITH 0
                        REPLACE comision_2 WITH 0                        
                        REPLACE comision_3 WITH 0                        
                        REPLACE porcdesc   WITH 0
                        REPLACE importdesc WITH 0
                        REPLACE impreso    WITH .F.
                        REPLACE fechaanu   WITH DATE()
                        REPLACE anulado    WITH .T.
                        REPLACE monto_fact WITH 0
                        REPLACE monto_cobr WITH 0
                        REPLACE monto_ndeb WITH 0
                        REPLACE monto_ncre WITH 0
*                    ENDSCAN
                     WAIT WINDOW "­ ESTA VENTA HA SIDO ANULADA !"
                     DO _RefreshInvoice                     
                  ENDIF
               ENDIF
            ENDIF

            EXIT DO
         ELSE
            WAIT WINDOW "­ ESTA VENTA POSEE ALGUN DEBITO Y/O CREDITO, IMPOSIBLE BORRARLA !"
            EXIT DO
         ENDIF
      ENDIF
      IF LASTKEY() = K_ESCAPE
         EXIT DO
      ENDIF
   ENDDO
ENDIF

POP KEY

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
IF NOT EOF()
   SKIP 1
   IF EOF("cabevent")           
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
IF NOT BOF()
   SKIP -1
   IF BOF("cabevent")
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
IF NOT EOF()
   DO _RefreshInvoice
ELSE
   WAIT WINDOW "­ FIN DE LA TABLA !" NOWAIT
ENDIF

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
IF UserConfig("ventas.prg", "Add", .F.)
   @ 24,09 SAY "Agrega" ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 24,09 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF

IF UserConfig("ventas.prg", "Edit", .F.)
   @ 24,17 SAY "Modif." ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 24,17 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF

IF UserConfig("ventas.prg", "Delete", .F.)
   @ 24,57 SAY "Borra" ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 24,57 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF


**********************************
FUNCTION _OthersData
PRIVATE pnSelect, pcOrder, pnRecNo, plAdding, plEditing
pnSelect  = SELECT()
pcOrder   = ORDER()
pnRecNo   = IIF(EOF(), 0, RECNO())

SELECT cabeven2
SET ORDER TO TAG indice1 OF cabeven2.cdx

IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
   plAdding  = .F.
   plEditing = .T.
   SCATTER MEMVAR MEMO
ELSE
   plAdding  = .T.
   plEditing = .F.
   SCATTER MEMVAR MEMO BLANK
ENDIF

DO cabeven2.spr

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE xcalc_pie_factura
   PRIVATE file_01
      
*       1        2         3          4         5         6         7 
* +----------------------------------------------------------------------+
* | % I.V.A |  MONTO  |   DTO.  |   NETO   | GRAVADA | EXENTA | IMPUESTO |
* +----------------------------------------------------------------------+

   SELECT 0 
   file_01 = createmp()
   CREATE TABLE &file_01 ;
     (porc_iva   N(6,2),;
      monto      N(13,4),;
      descuento  N(13,4),;
      neto       N(13,4),;
      gravada    N(13,4),;
      exenta     N(13,4),;
      impuesto   N(13,4))
      
   INDEX ON porc_iva TAG porc_iva
   USE &file_01 ALIAS tax
   SET ORDER TO 1
   
   
   PRIVATE m.decimales, m.iva_inclui, m.iva_base

   m.decimales  = IIF(m.moneda = 1, 0, 2)
   m.iva_inclui = IIF(INLIST(m.tipodocu, 3, 7, 8), .T., .F.)
   m.iva_base   = 10
   STORE 0 TO m.suma_grav, m.suma_exen, m.suma_iva, m.suma_total

   SELECT tmpdetvent
   SCAN ALL
      m.monto_linea = ROUND(precio * cantidad, m.decimales)
      m.desc_linea  = ROUND(m.monto_linea * pdescuento / 100, m.decimales)
      m.monto_neto  = m.monto_linea - m.desc_linea
      
      m.suma_total  = m.suma_total + m.monto_neto 

      SELECT tax
      IF !SEEK(tmpdetvent.pimpuesto) THEN
         APPEND BLANK
         REPLACE porc_iva WITH tmpdetvent.pimpuesto
         REPLACE monto    WITH m.monto_neto
      ELSE
         REPLACE monto WITH (monto + m.monto_neto)
      ENDIF

      SELECT tmpdetvent
   ENDSCAN

   IF m.porcdesc > 0 THEN
      m.importdesc = ROUND(m.suma_total * m.porcdesc / 100, m.decimales)
*      wait window str(m.suma_total
   ELSE
      IF m.importdesc > 0 THEN
         m.porcdesc = ROUND(m.importdesc * 100 / m.suma_total, 4)
      ENDIF
   ENDIF

   SELECT tax
   SCAN ALL
      REPLACE descuento WITH ROUND(monto * m.porcdesc / 100, m.decimales)
      REPLACE neto WITH (monto - descuento)

      IF m.iva_inclui THEN
         IF porc_iva > 0 THEN
            m.base_imponible = ROUND(neto / (1 + porc_iva / 100), m.decimales)
            m.gravada = ROUND(m.base_imponible * porc_iva * m.iva_base / 100, m.decimales)
            m.exenta  = m.base_imponible - m.gravada
            m.iva     = neto - m.base_imponible
         ELSE
            m.gravada = 0
            m.exenta  = neto
            m.iva     = 0
         ENDIF
      ELSE
         m.gravada = ROUND(neto * porc_iva * m.iva_base / 100, m.decimales)
         m.exenta  = neto - m.gravada
         m.iva     = ROUND(neto * porc_iva / 100, m.decimales)
      ENDIF

      REPLACE gravada  WITH m.gravada
      REPLACE exenta   WITH m.exenta
      REPLACE impuesto WITH m.iva
   ENDSCAN
   
   IF m.iva_inclui THEN
      SUM monto TO msubtotal
   ELSE
      SUM gravada + exenta TO msubtotal
   ENDIF

   SUM impuesto TO m.iva
   SUM gravada + exenta + impuesto TO m.monto_fact

   
*  BROWSE
   USE 
   DO borratm WITH file_01

   SELECT tmpdetvent


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

   @ 21,65 SAY m.iva ;
      SIZE 1,14 ;
      PICTURE "999,999,999.99" ;
      COLOR N/W

   @ 22,65 SAY m.monto_fact ;
      SIZE 1,14 ;
      PICTURE "999,999,999.99" ;
      COLOR B/W

*ENDPROC