*:*********************************************************************
*:
*: Archivo de Procedimiento: NOTACLIE.PRG
*:
*:                  Sistema: Notas de D‚bito / Cr‚dito de Clientes.
*:                    Autor: Jos‚ Avilio Acu¤a Acosta
*:                 Copyright (c) 2004, Alben S.R.L.             
*:            Last modified: 13/02/2004           
*:
*:            Procs & Fncts: _RefreshInvoice             
*:                         : _fmtInvoice
*:                         : _ShowHeader
*:                         : _ShowDetail
*:                         : _PrintDetail
*:                         : _InvoiceFoot
*:                         : _LoadQuota
*:                         : _brwDetail
*:                         : _brwQuota      
*:                         : _brwInvoices   
*:                         : _vtaSwitch
*:                         : _DeleteInvoice
*:                         : _updMaesprod
*:                         : _NextRecord
*:                         : _PriorRecord
*:                         : _TopRecord
*:                         : _BottomRecord
*:
*:*********************************************************************
WAIT WINDOW "POR FAVOR, ESPERE MIENTRAS SE CARGA EL MODULO..." NOWAIT

*-- Variables de la Tabla de Cabecera.
PRIVATE m.tiponota, m.nronota, m.tipodocu, m.nrodocu, m.fechanota, m.cliente, m.motivonota, m.aplicontra, m.fechaanu, m.anulado, m.monto_nota, m.moneda

*-- Variables para c lculos del programa.
PRIVATE pnGravada, pnExenta, pnImpuesto, pnSubTotal

*-- Inicializa variables del programa.
STORE .F. TO plAdding, plEditing

*-- MS-DOS  Definiciones de ventanas.
IF NOT WEXIST("tmpdetnota")
   DEFINE WINDOW tmpdetnota ;
      FROM 06,00 ;
      TO 19,79 ;
      TITLE "DETALLE" ;
      NOFLOAT ;
      CLOSE ;
      NOSHADOW ;
      ZOOM ;
      NOMINIMIZE ;
      SYSTEM ;
      COLOR SCHEME 15
ENDIF

IF NOT WEXIST("tmpcuonota")
   DEFINE WINDOW tmpcuonota ;
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

IF NOT WEXIST("brwNotas")
   DEFINE WINDOW brwNotas ;
      FROM 01,00 ;
      TO 23,79 ;
      TITLE "< NOTAS DE DEBITOS Y CREDITOS DE CLIENTES >" ;
      NOFLOAT ;
      CLOSE ;
      NOSHADOW ;
      ZOOM ;
      NOMINIMIZE ;
      SYSTEM ;
      COLOR SCHEME 15
ENDIF

IF NOT WEXIST("tmpformapl")
   DEFINE WINDOW tmpformapl ;
      FROM 04,01 ;
      TO 20,78 ;
      TITLE "FORMA DE APLICACION" ;
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
temp01 = "tm" + RIGHT(SYS(3),6) + ".dbf"
CREATE TABLE &temp01 (tiponota   N(01),;
                      nronota    N(07),;
                      tipo       C(01),;
                      articulo   C(15),;
                      cantidad   N(09,2),;
                      precio     N(11,2),;
                      impuesto   L(01),;
                      pimpuesto  N(06,2),;
                      serie      C(15))

USE &temp01 ALIAS tmpdetnota EXCLUSIVE
INDEX ON STR(tiponota, 1) + STR(nronota, 7) TAG indice1
SET RELATION TO tmpdetnota.articulo INTO maesprod ADDITIVE

SELECT 0
temp02 = "tm" + RIGHT(SYS(3),6) + ".dbf"
CREATE TABLE &temp02 (tipodocu   N(01),;
                      nrodocu    N(07),;
                      tipo       N(01),;
                      nrocuota   N(03),;
                      fecha      D(08),;
                      importe    N(09),;
                      abonado    N(09),;
                      monto_ndeb N(09),;
                      monto_ncre N(09),;
                      monto      N(09))

USE &temp02 ALIAS tmpcuonota EXCLUSIVE
INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) + STR(nrocuota, 3) TAG indice1

SELECT 0
temp03 = "tm" + SYS(3) + ".dbf"
CREATE TABLE &temp03 (codigo     C(15),;
                      codigo2    C(15),;
                      codorig    C(15),;
                      nombre     C(40),;
                      lista3     L(01),;
                      lista4     L(01),;
                      lista5     L(01),;
                      familia    N(04),;
                      rubro      N(04),;
                      subrubro   N(04),;
                      marca      N(04),;
                      unidad     N(03),;
                      proveedor  N(05),;
                      procedenci N(04),;                           
                      ubicacion  C(10),;
                      vigente    L(01),;
                      lprecio    L(01),;
                      impuesto   L(01),;
                      pimpuesto  N(06,2),;                                                                                 
                      pcostog    N(13,4),;
                      pcostod    N(13,4),;
                      pventag1   N(13,4),;
                      pventag2   N(13,4),;
                      pventag3   N(13,4),;
                      pventag4   N(13,4),;
                      pventag5   N(13,4),;
                      pventad1   N(13,4),;
                      pventad2   N(13,4),;
                      pventad3   N(13,4),;
                      pventad4   N(13,4),;
                      pventad5   N(13,4),;
                      paumento1  N(06,2),;
                      paumento2  N(06,2),;
                      paumento3  N(06,2),;
                      paumento4  N(06,2),;
                      paumento5  N(06,2),;
                      stock_min  N(11,2),;
                      stock_max  N(11,2),;
                      polinvsmin L(01),;
                      polinvsmax L(01),;
                      garantia   C(20),;
                      caracter1  C(60),;
                      caracter2  C(60),;
                      caracter3  C(60),;
                      otros1     C(60),;
                      otros2     C(60),;
                      fecucompra D(08),;
                      fecrepo    D(08),;
                      stock_actu N(11,2),;
                      stock_ot   N(11,2),;
                      cantidad   N(09,2))

INDEX ON codigo      TAG indice1
INDEX ON nombre      TAG indice2
INDEX ON rubro       TAG indice3
INDEX ON subrubro    TAG indice4
INDEX ON marca       TAG indice5
INDEX ON codigo2     TAG indice6
INDEX ON codorig     TAG indice7
INDEX ON val(codigo) TAG indice8
INDEX ON familia     TAG indice9
INDEX ON nombre      TAG indice10
INDEX ON codigo      TAG indice11 FOR vigente 
INDEX ON codigo2     TAG indice12 FOR vigente 
INDEX ON codorig     TAG indice13 FOR vigente

USE &temp03 ALIAS maestemp
SET ORDER TO indice2 
SET RELATION TO maestemp.familia    INTO familias ,;
                maestemp.rubro      INTO rubros1  ,;
                maestemp.subrubro   INTO rubros2  ,;
                maestemp.marca      INTO marcas1  ,;
                maestemp.unidad     INTO unidad   ,;
                maestemp.procedenci INTO proceden ,;
                maestemp.proveedor  INTO proveedo ADDITIVE

WAIT CLEAR

DO _BackGround WITH 1
DO _Center WITH 00, gcLocal, "N/W"

*-- Establece relaciones entre las tablas.
SELECT detanotc
SET RELATION TO detanotc.articulo INTO maesprod ADDITIVE

SELECT cabenotc
SET RELATION TO cabenotc.cliente INTO clientes ADDITIVE

SELECT cabenotc
GO TOP

SCATTER MEMVAR MEMO

DO _RefreshInvoice

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
         IF UserConfig("notaclie.prg", "Add", .T.) THEN
            DO mknota_c.prg WITH "Add"
            DO _RefreshInvoice
         ENDIF
      CASE pnKey = K_F3           && Tecla F3 presionada, modificar registro.
         IF UserConfig("notaclie.prg", "Edit", .T.) THEN
            DO mknota_c.prg WITH "Edit"
            DO _RefreshInvoice
         ENDIF
      CASE pnKey = K_F8           && Tecla F8 presionada, eliminar registro
         IF cabenotc.fechanota <> DATE() THEN
            WAIT "LOS REGISTROS DE ESTA TABLA NO PUEDEN SER BORRADOS O ANULADOS !" WINDOW NOWAIT
            LOOP
         ENDIF

         IF UserConfig("notaclie.prg", "Delete", .T.) THEN
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
         IF RECCOUNT("tmpdetnota") > 0
            DO _brwDetail
         ENDIF
      CASE pnKey = K_ENTER        && Tecla ENTER, visualizar cuotas.
         IF INLIST(cabenotc.tiponota, 1, 3) .AND. .NOT. cabenotc.anulado
            WAIT WINDOW "­ LAS VENTAS AL CONTADO NO POSEEN CUOTAS !"
         ELSE
            IF cabenotc.tiponota <> 0 .AND. cabenotc.nronota <> 0
               DO _brwQuota 
            ENDIF
         ENDIF
      CASE pnKey = K_F4           && Tecla F4 presionada, ordenar.         
         DO orden.spr
      CASE pnKey = K_F10          && Tecla F10 presionada, examinar notas.
         ON KEY LABEL "F4" DO orden.spr
         ON KEY LABEL "F5" DO _NotaSwitch

         DO _brwInvoices 

         ON KEY LABEL "F4" 
         ON KEY LABEL "F5" 

         DO _RefreshInvoice
      CASE pnKey = K_F5           && Tecla F5 presionada, buscar.
         DO _NotaSwitch
      ENDCASE
ENDDO     Fin del bucle principal.     
        
*-- MS-DOS Cierre de Bases de Datos.
IF USED("tmpdetnota")
   SELECT tmpdetnota
   USE
ENDIF

DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"

IF USED("tmpcuonota")
   SELECT tmpcuonota
   USE
ENDIF

DELETE FILE &temp02
DELETE FILE SUBSTR(temp02, 1, ATC(".", temp02)) + "CDX"

IF USED("maestemp")
   SELECT maestemp
   USE
ENDIF

DELETE FILE &temp03
DELETE FILE SUBSTR(temp03, 1, ATC(".", temp03)) + "CDX"

*-- Quiebra las relaciones entre las tablas.
SELECT detanotc
SET RELATION OFF INTO maesprod

SELECT cabenotc
SET RELATION OFF INTO clientes

*-- Elimina ventanas.
IF WEXIST("tmpdetnota")
   RELEASE WINDOW tmpdetnota
ENDIF

IF WEXIST("tmpcuonota")
   RELEASE WINDOW tmpcuonota
ENDIF

IF WEXIST("tmpmarcuot")
   RELEASE WINDOW tmpmarcuot
ENDIF

IF WEXIST("brwNotas")
   RELEASE WINDOW brwNotas
ENDIF

IF WEXIST("tmpformapl")
   RELEASE WINDOW tmpformapl
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
DO _InvoiceFoot
DO _LoadQuota

IF cabenotc.anulado
   IF INLIST(cabenotc.tiponota, 1, 3)
      WAIT WINDOW "­ NOTA DE DEBITO ANULADA !" NOWAIT
   ELSE
      IF INLIST(cabenotc.tiponota, 2, 4)
         WAIT WINDOW "­ NOTA DE CREDITO ANULADA !" NOWAIT  
      ENDIF
   ENDIF
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _fmtInvoice  
*!
*!  Llamado por: _RefreshInvoice
*!
*!  Descripci¢n: Dibuja el formato de la nota de d‚bito / credito.
*!
*!*********************************************************************
FUNCTION _fmtInvoice
@ 01,00 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 02,00 SAY "³ Documento.:                           N§:             Fecha Nota.:           ³"
@ 03,00 SAY "³ Aplicado a:                           N§:             Fecha Fact.:           ³"
@ 04,00 SAY "³ Cliente...:                                                                  ³"
@ 05,00 SAY "³ Motivo....:                                     Aplicado Contra:             ³"
@ 06,00 SAY "ÃÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´"
@ 07,00 SAY "³ ³Descripci¢n                             ³ Cantidad ³ Precio Un.  ³ Importe  ³"
@ 08,00 SAY "ÃÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´"
@ 09,00 SAY "³ ³                                        ³          ³             ³          ³"
@ 10,00 SAY "³ ³                                        ³          ³             ³          ³"
@ 11,00 SAY "³ ³                                        ³          ³             ³          ³"
@ 12,00 SAY "³ ³                                        ³          ³             ³          ³"
@ 13,00 SAY "³ ³                                        ³          ³             ³          ³"
@ 14,00 SAY "³ ³                                        ³          ³             ³          ³"
@ 15,00 SAY "³ ³                                        ³          ³             ³          ³"
@ 16,00 SAY "³ ³                                        ³          ³             ³          ³"
@ 17,00 SAY "³ ³                                        ³          ³             ³          ³"
@ 18,00 SAY "³ ³                                        ³          ³             ³          ³"
@ 19,00 SAY "ÃÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´"
@ 20,00 SAY "³ Rubro..:                                             SUB-TOTALES:            ³"
@ 21,00 SAY "³ Gravado:                                                  I.V.A.:            ³"
@ 22,00 SAY "³ Stock..:                                           TOTAL GENERAL:            ³"
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

SELECT cabenotc
SCATTER MEMVAR

@ 02,14 SAY m.tiponota ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W

*-- Imprime la etiqueta del tipo de documento.
DO CASE
   CASE m.tiponota = 1
      @ 02,17 SAY "NOTA DE DEBITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tiponota = 2
      @ 02,17 SAY "NOTA DE CREDITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tiponota = 3
      @ 02,17 SAY "C.I. NOTA DE DEBITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tiponota = 4
      @ 02,17 SAY "C.I. NOTA DE CREDITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   OTHERWISE
      @ 02,17 SAY REPLICATE(CHR(32), 21) ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
ENDCASE

@ 02,44 SAY m.nronota ;
   SIZE 1,7 ;
   PICTURE "9999999" ;
   COLOR N/W

@ 02,69 SAY m.fechanota ;
   SIZE 1,10 ;
   PICTURE "@D" ;
   COLOR N/W

@ 03,14 SAY m.tipodocu ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W

*-- Imprime la etiqueta del tipo de documento.
DO CASE
   CASE INLIST(m.tipodocu, 1, 7)
      @ 03,17 SAY "VENTA CONTADO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE INLIST(m.tipodocu, 2, 8)
      @ 03,17 SAY "VENTA CREDITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 3
      @ 03,17 SAY "VENTA I.V.A. INCLUIDO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 4
      @ 03,17 SAY "VENTA TRIBUTO UNICO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   OTHERWISE
      @ 03,17 SAY REPLICATE(CHR(32), 21) ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
ENDCASE

@ 03,44 SAY m.nrodocu ;
   SIZE 1,7 ;
   PICTURE "9999999" ;
   COLOR N/W

*-- Imprime la fecha del documento de venta.
SELECT cabevent
SET ORDER TO TAG indice1 OF cabevent.cdx


IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7))
   m.fechadocu = cabevent.fechadocu
   m.cliente   = cabevent.cliente
   
   @ 03,69 SAY m.fechadocu ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W
ELSE
   @ 03,69 SAY {} ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W
ENDIF

SELECT cabenotc

@ 04,14 SAY m.cliente  ;
   SIZE 1,5 ;
   PICTURE "99999" ;
   COLOR N/W

*-- Imprime el nombre del cliente selecionado.
SELECT clientes
SET ORDER TO TAG indice1 OF clientes.cdx

IF SEEK(m.cliente)
   @ 04,21 SAY PADR(ALLTRIM(clientes.nombre), 56, CHR(32)) ;
      SIZE 1,56 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 04,21 SAY REPLICATE(CHR(32), 56) ;
      SIZE 1,56 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

SELECT cabenotc

@ 05,14 SAY m.motivonota ;
   SIZE 1,3 ;
   PICTURE "999" ;
   COLOR N/W
   
*-- Imprime el nombre del motivo de la nota.
SELECT motivono
SET ORDER TO TAG indice1 OF motivono.cdx

IF SEEK(m.motivonota)
   @ 05,19 SAY PADR(ALLTRIM(motivono.nombre), 30, CHR(32)) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 05,19 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

SELECT cabenotc
   
@ 05,67 SAY m.aplicontra ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W
   
*-- Imprime el nombre de aplicado contra.
IF m.aplicontra = 1
   @ 05,69 SAY PADR(ALLTRIM("CAJA"), 10, CHR(32)) ;
      SIZE 1,10 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   IF m.aplicontra = 2
      @ 05,69 SAY PADR(ALLTRIM("CTA. CTE."), 10, CHR(32)) ;
         SIZE 1,10 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 05,69 SAY REPLICATE(CHR(32), 10) ;
         SIZE 1,10 ;
         PICTURE "@!" ;
         COLOR W/N
   ENDIF
ENDIF

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

SELECT tmpdetnota     &&   Vac¡a la  tabla  temporal  que  contiene  el
ZAP                   &&   detalle de art¡culos del documento.

SELECT detanotc

IF SEEK(STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7))
   SCAN WHILE STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7) = STR(detanotc.tiponota, 1) + STR(detanotc.nronota, 7)
      INSERT INTO tmpdetnota (tiponota, nronota, tipo, articulo, cantidad, precio, impuesto, pimpuesto, serie) ;
         VALUES (detanotc.tiponota, detanotc.nronota, detanotc.tipo, detanotc.articulo, detanotc.cantidad, detanotc.precio, detanotc.impuesto, detanotc.pimpuesto, detanotc.serie) 
   ENDSCAN
ELSE
  IF NOT cabenotc.anulado .AND. cabenotc.tiponota <> 0 .AND. cabenotc.nronota <> 0
     WAIT WINDOW "ESTE DOCUMENTO NO POSEE DETALLE, BORRELO Y VUELVA A CARGARLO"
  ENDIF
ENDIF

SELECT cabenotc
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
#DEFINE pnColumn 1

SELECT tmpdetnota
GO TOP

SCAN WHILE RECNO() <= 10 .AND. .NOT. (EMPTY(articulo) .OR. EMPTY(cantidad) .OR. EMPTY(precio))
   @ pnRow + RECNO(), pnColumn      SAY tipo                                                   COLOR N/W
   @ pnRow + RECNO(), pnColumn + 2  SAY SUBSTR(maesprod.nombre, 1, 40)                         COLOR N/W
   @ pnRow + RECNO(), pnColumn + 43 SAY cantidad                       PICTURE "999,999.99"    COLOR N/W
   @ pnRow + RECNO(), pnColumn + 54 SAY precio                         PICTURE "99,999,999.99" COLOR N/W
   @ pnRow + RECNO(), pnColumn + 68 SAY ROUND(precio * cantidad, 0)    PICTURE "99,999,999"    COLOR N/W
ENDSCAN

DO RestoreWorkArea

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

DO SaveWorkArea

SELECT tmpdetnota
GO TOP

STORE 0 TO m.monto_nota, pnGravada, pnExenta, pnImpuesto, pnSubTotal

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
m.monto_nota = pnSubTotal + pnImpuesto

@ 20,68 SAY pnSubTotal ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

@ 21,68 SAY pnImpuesto ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

@ 22,68 SAY m.monto_nota ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

DO RestoreWorkArea

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

SELECT tmpcuonota     &&   Vac¡a la  tabla  temporal  que  contiene las
ZAP                   &&   cuotas del documento.

SELECT cuotas_v

IF SEEK(STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7))
   SCAN WHILE STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7) = STR(cuotas_v.tipodocu, 1) + STR(cuotas_v.nrodocu, 7)
      INSERT INTO tmpcuonota (tipodocu, nrodocu, tipo, nrocuota, fecha, importe, abonado, monto_ndeb, monto_ncre) ;
         VALUES (cuotas_v.tipodocu, cuotas_v.nrodocu, cuotas_v.tipo, cuotas_v.nrocuota, cuotas_v.fecha, cuotas_v.importe, cuotas_v.abonado, cuotas_v.monto_ndeb, cuotas_v.monto_ncre)
   ENDSCAN
ELSE
  IF .NOT. cabevent.anulado .AND. INLIST(cabevent.tipodocu, 2, 6, 8)
     WAIT WINDOW "     ­ ESTE DOCUMENTO NO POSEE CUOTAS !" + CHR(13) + ;
                 "MODIFIQUELO PARA VOLVER A GENERAR LAS CUOTAS"
  ENDIF
ENDIF

SELECT cabenotc

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

SELECT tmpdetnota
GO TOP

BROWSE WINDOW tmpdetnota FIELDS ;
   tipo                                     :R:01:H = "" ,;
   calc_f0 = SUBSTR(articulo, 1, 13)        :R:13:H = "C¢digo" ,;
   calc_f1 = SUBSTR(maesprod.nombre, 1, 34) :R:34:H = "Descripci¢n"  :P = "@!" :W = .F. ,;
   cantidad                                 :R:09:H = "Cantidad"     :P = "999999.99" ,;
   precio                                   :R:15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = .F. ,;
   calc_f2 = ROUND(precio * cantidad, 0)    :R:15:H = "Sub-Total"    :P = "999,999,999,999" ,;
   calc_f3 = IIF(impuesto, "   S¡", "")     :R:08:H = "Impuesto"     :W = .F. ,;
   pimpuesto                                :R:06:H = "% Imp."       :P = "999.99" :W = .F. ;
   NOAPPEND NODELETE NOMODIFY

SELECT cabenotc

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

SELECT tmpcuonota
GO TOP

BROWSE WINDOW tmpcuonota FIELDS ;
   calc_f1 = IIF(tipo = 1,"Entr",IIF(tipo = 2,"Cuot",""))     :R:04:H="Tipo" ,;
   nrocuota                                                    :R:03:H="N§"         :P="999",;
   fecha                                                       :R:10:H="Fecha Vcto" ,;
   importe                                                     :R:10:H="Importe"    :P="99,999,999" ,;
   calc_f2 = ((importe + monto_ndeb) - (monto_ncre + abonado)) :R:10:H="Saldo"      :P="99,999,999" ,;
   abonado                                                     :R:10:H="Abonado"    :P="99,999,999" ,;
   monto_ndeb                                                  :R:10:H="Monto Ndeb" :P="99,999,999" ,;
   monto_ncre                                                  :R:10:H="Monto Ncre" :P="99,999,999"  ;
   NOAPPEND NODELETE NOMODIFY

DEACTIVATE WINDOW tmpmarcuot

SELECT cabenotc

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

SELECT cabenotc

BROWSE WINDOW brwNotas FIELDS ;
   calc_f1 = IIF(tiponota = 1,"NDEB", IIF(tiponota = 2,"NCRE", IIF(tiponota = 3, "CINDE", IIF(tiponota = 4, "CINCR", "")))) :R:05:H = "" ,;
   nronota    :R:07:P = "9999999"     :H = "N§ Nota" ,;
   fechanota  :R:10:P = "@D"          :H = "Fecha Nota" ,;
   calc_f2 = IIF(tipodocu = 1,"VCO", IIF(tipodocu = 2,"VCR", IIF(tipodocu = 3, "VII", IIF(tipodocu = 4, "VTU", "")))) :R:03:H = "" ,;
   nrodocu    :R:07:P = "9999999"     :H = "N§ Doc." ,;
   monto_nota :R:11:P = "999,999,999" :H = "Monto Nota" ,;
   calc_f3 = IIF(anulado, "A N U L A D O", SUBSTR(clientes.nombre, 1, 56)) :R:56:P = "@!" :H = "Cliente" ,;
   cliente :R:07:P = "9999999" :H = "C¢d.Cli" ;
   NOAPPEND NODELETE NOMODIFY

*!*********************************************************************
*!
*!      Funci¢n: _NotaSwitch     
*!
*!  Llamado por: VENTAS.PRG       
*!
*!  Descripci¢n: Selecciona el tipo de ventana a desplegar  para reali-
*!               zar la b£squeda.
*!
*!*********************************************************************
FUNCTION _NotaSwitch

PUSH KEY CLEAR

IF EOF()
   DO WHILE .T.
      WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
      IF UPPER(pcAppend) = "S"
         DO mknota_c.prg
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
      DO search01.spr
      POP KEY
   CASE LOWER(TAG()) = "indice2"
      DO search02.spr
      POP KEY
   CASE LOWER(TAG()) = "indice4"
      DO search03.spr
      POP KEY
ENDCASE

IF FOUND()
   DO _RefreshInvoice
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _DeleteInvoice
*!
*!  Llamado por: MKNOTA_C.PRG       
*!
*!  Descripci¢n: Borra o anula la nota de debito o credito - clientes.
*!
*!*********************************************************************
FUNCTION _DeleteInvoice

PUSH KEY CLEAR

IF EOF()
   DO WHILE .T.
      WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
      IF UPPER(pcAppend) = "S"
         DO mknota_c.prg WITH "Add"
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

DO WHILE .T.
   IF INLIST(m.tiponota, 1, 3)
      WAIT WINDOW "¨ DESEA BORRAR ESTA NOTA DE DEBITO ? [S/N]" TO pcDelete  
   ELSE
      IF INLIST(m.tiponota, 2, 4)
         WAIT WINDOW "¨ DESEA BORRAR ESTA NOTA DE CREDITO ? [S/N]" TO pcDelete  
      ENDIF
   ENDIF
   IF INLIST(UPPER(pcDelete), "S", "N")
      EXIT DO
   ENDIF
ENDDO

IF UPPER(pcDelete) = "S"
   DO WHILE .T.   
      WAIT WINDOW "¨ DESEA: (B)ORRARLO o (A)NULARLO ?" TO pcDelOrAnnul

      IF INLIST(UPPER(pcDelOrAnnul), "B", "A")
         *-- Actualiza el campo cuotas_v.monto_ndeb o cuotas_v.monto_ncre y borra la(s) cuota(s) de la nota de debito / credito.
         SELECT cuotas_n
         SET ORDER TO TAG indice1 OF cuotas_n.cdx
  
         IF SEEK("V" + STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7))
            SCAN WHILE ("V" + STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7)) = ("V" + STR(cuotas_n.tiponota, 1) + STR(cuotas_n.nronota, 7))
               SELECT cuotas_v
               SET ORDER TO TAG indice1 OF cuotas_v.cdx
      
               IF SEEK(STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7) + STR(cuotas_n.nrocuota, 3))
                  IF INLIST(cabenotc.tiponota, 1, 3)
                     REPLACE cuotas_v.monto_ndeb WITH (cuotas_v.monto_ndeb - cuotas_n.importe)
                  ELSE
                     IF INLIST(cabenotc.tiponota, 2, 4)
                        REPLACE cuotas_v.monto_ncre WITH (cuotas_v.monto_ncre - cuotas_n.importe)
                     ENDIF
                  ENDIF
               ELSE
                  WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR LA CUOTA N§: " + ALLTRIM(STR(cuotas_n.nrocuota, 3)) + " DE LA VENTA: " + ALLTRIM(STR(cabenotc.tipodocu, 1)) + "/" + ALLTRIM(STR(cabenotc.nrodocu, 7)) + " !"
               ENDIF
      
               SELECT cuotas_n
               DELETE
            ENDSCAN
         ENDIF

         *-- Actualiza el campo maesprod.stock_actu y borra el detalle de la nota de debito o credito.
         SELECT detanotc
         SET ORDER TO TAG indice1 OF detanotc.cdx
   
         IF SEEK(STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7))
            SCAN WHILE (STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7)) = (STR(detanotc.tiponota, 1) + STR(detanotc.nronota, 7))
               IF detanotc.tipo = "S"
                  SELECT maesprod
                  SET ORDER TO TAG indice1 OF maesprod.cdx
          
                  IF SEEK(detanotc.articulo)
                     IF INLIST(cabenotc.tiponota, 1, 3)
                        REPLACE maesprod.stock_actu WITH (maesprod.stock_actu + detanotc.cantidad)
                     ELSE
                        IF INLIST(cabenotc.tiponota, 2, 4)
                           REPLACE maesprod.stock_actu WITH (maesprod.stock_actu - detanotc.cantidad)
                        ENDIF
                     ENDIF
                  ELSE
                     WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL ARTICULO: " + ALLTRIM(detanotc.articulo) + " !"
                  ENDIF
               ENDIF
               SELECT detanotc
               DELETE
            ENDSCAN
         ELSE
            IF .NOT. cabenotc.anulado .AND. cabenotc.tiponota <> 0 .AND. cabenotc.nronota <> 0
               WAIT WINDOW "­ NO SE HA ENCONTRADO DETALLE A BORRAR !"
            ENDIF
         ENDIF

         *-- Actualiza el campo clientes.saldo_actu, si cabenotc.tipodocu = 2 y cabenotc.aplicontra = 2.
         SELECT cabevent
         SET ORDER TO TAG "indice1"
         SEEK STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7)

         IF INLIST(cabenotc.tipodocu, 2, 6, 8) .AND. cabenotc.aplicontra = 2
            SELECT clientes
            SET ORDER TO TAG indice1 OF clientes.cdx
     
            IF SEEK(cabenotc.cliente)
               IF INLIST(cabenotc.tiponota, 1, 3)
                  IF cabevent.moneda = 1 
                     REPLACE clientes.saldo_actu WITH (clientes.saldo_actu - cabenotc.monto_nota)
                  ELSE
                     REPLACE clientes.saldo_usd  WITH (clientes.saldo_usd  - cabenotc.monto_nota)
                  ENDIF
               ELSE
                  IF INLIST(cabenotc.tiponota, 2, 4)
                     IF cabevent.moneda = 1
                        REPLACE clientes.saldo_actu WITH (clientes.saldo_actu + cabenotc.monto_nota)
                     ELSE
                        REPLACE clientes.saldo_usd  WITH (clientes.saldo_usd  + cabenotc.monto_nota)
                     ENDIF
                  ENDIF
               ENDIF
            ELSE
               IF .NOT. cabenotc.anulado .AND. cabenotc.tiponota <> 0 .AND. cabenotc.nronota <> 0
                  WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DEL CLIENTE: " + ALLTRIM(STR(cabenotc.cliente, 5)) + " !"
               ENDIF
           ENDIF
         ENDIF

         *-- Actualiza el campo cabevent.monto_ndeb o cabevent.monto_ncre y borra el encabezado de la nota de debito / credito.
         SELECT cabevent
         SET ORDER TO TAG indice1 OF cabevent.cdx

         IF SEEK(STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7))
            IF INLIST(cabenotc.tiponota, 1, 3) .AND. cabenotc.aplicontra = 2
               REPLACE cabevent.monto_ndeb WITH (cabevent.monto_ndeb - cabenotc.monto_nota)
            ELSE
               IF INLIST(cabenotc.tiponota, 2, 4) .AND. cabenotc.aplicontra = 2
                  REPLACE cabevent.monto_ncre WITH (cabevent.monto_ncre - cabenotc.monto_nota)
               ENDIF
            ENDIF
         ELSE
            IF .NOT. cabenotc.anulado .AND. cabenotc.tiponota <> 0 .AND. cabenotc.nronota <> 0
               WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DE LA VENTA: " + ALLTRIM(STR(cabenotc.tipodocu, 1)) + "/" + ALLTRIM(STR(cabenotc.nrodocu, 7)) + " !" 
            ENDIF
         ENDIF

         SELECT cabenotc
         SET ORDER TO TAG indice1 OF cabenotc.cdx

         IF SEEK(STR(m.tiponota, 1) + STR(m.nronota, 7))
            SCAN WHILE (STR(m.tiponota, 1) + STR(m.nronota, 7)) = (STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7))
               DELETE
            ENDSCAN
         ENDIF
   
         IF UPPER(pcDelOrAnnul) = "A"
            INSERT INTO cabenotc (tiponota, nronota, tipodocu, nrodocu, fechanota, cliente, motivonota, aplicontra, fechaanu, anulado, monto_nota) ;
               VALUES (m.tiponota, m.nronota, 0, 0, {}, 0, 0, 0, DATE(), .T., 0)
            IF INLIST(cabenotc.tiponota, 1, 3)
               WAIT WINDOW "­ ESTA NOTA DE DEBITO HA SIDO ANULADA !"
            ELSE
               IF INLIST(cabenotc.tiponota, 2, 4)
                  WAIT WINDOW "­ ESTA NOTA DE CREDITO HA SIDO ANULADA !"
               ELSE
                  WAIT WINDOW "­ ESTA NOTA HA SIDO ANULADA !"
               ENDIF
            ENDIF

            DO _RefreshInvoice
         ELSE
            IF INLIST(m.tiponota, 1, 3)
               WAIT WINDOW "­ ESTA NOTA DE DEBITO HA SIDO BORRADA !"
            ELSE
               IF INLIST(m.tiponota, 2, 4)
                  WAIT WINDOW "­ ESTA NOTA DE CREDITO HA SIDO BORRADA !"
               ELSE
                  WAIT WINDOW "­ ESTA NOTA HA SIDO BORRADA !"
               ENDIF
            ENDIF

            DO _RefreshInvoice            

            IF EOF()
               IF NOT BOF()
                  SKIP -1 
                  IF BOF("cabenotc")
                     GO TOP
                  ELSE
                     DO _RefreshInvoice
                  ENDIF
               ENDIF
            ENDIF

         ENDIF

         EXIT DO
      ENDIF

      IF LASTKEY() = 27
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
   IF EOF("cabenotc")           
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
   IF BOF("cabenotc")
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
