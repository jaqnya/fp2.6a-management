*:**************************************************************************
*:
*: Archivo de Procedimiento: NOTAPROV.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Vista formulario de  Notas de Deb. / Cred.  de 
*:                           Proveedores.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 05/05/2004
*:
*:**************************************************************************
WAIT WINDOW "POR FAVOR, ESPERE MIENTRAS SE CARGA EL MODULO..." NOWAIT

*-- Variables de la Tabla de Cabecera.
PRIVATE m.tiponota,m.nronota, m.tipodocu, m.nrodocu, m.fechanota, m.proveedor, m.motivonota, m.monto_nota, m.aplicontra, m.id_local, m.moneda, m.tipocambio

*-- Variables para c lculos del programa.
PRIVATE pnGravada, pnExenta, pnImpuesto, pnSubTotal

*-- Inicializa variables del programa.
STORE .F. TO plAdding, plEditing
STORE 0   TO m.moneda

*-- MS-DOS  Definiciones de ventanas.
IF .NOT. WEXIST("tmpdetnota")
   DEFINE WINDOW tmpdetnota ;
      FROM 07,00 ;
      TO 19,79 ;
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

IF .NOT. WEXIST("tmpcuonota")
   DEFINE WINDOW tmpcuonota ;
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

IF .NOT. WEXIST("brwNotas")
   DEFINE WINDOW brwNotas ;
      FROM 01,00 ;
      TO 23,79 ;
      TITLE "< NOTAS DE DEBITOS Y CREDITOS DE PROVEEDORES >" ;
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

IF .NOT. WEXIST("tmpformapl")
   DEFINE WINDOW tmpformapl ;
      FROM 04,01 ;
      TO 20,78 ;
      TITLE "FORMA DE APLICACION" ;
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
CREATE TABLE &temp01 (tiponota   N(01) ,;
                      nronota    N(09) ,;
                      proveedor  N(05) ,;
                      tipo       C(01) ,;
                      tipoc      C(01) ,;
                      articulo   C(15) ,;
                      cantidad   N(09,2) ,;
                      precio     N(13,4) ,;
                      pdescuento N(07,4) ,;
                      impuesto   L(01) ,;
                      pimpuesto  N(06,2))

USE &temp01 ALIAS tmpdetnota EXCLUSIVE
INDEX ON STR(tiponota, 1) + STR(nronota, 9) + STR(proveedor, 5) TAG indice1
SET RELATION TO tmpdetnota.articulo INTO maesprod ADDITIVE

SELECT 0
temp02 = "tm" + RIGHT(SYS(3),6) + ".dbf"
CREATE TABLE &temp02 (tipodocu   N(01) ,;
                      nrodocu    N(09) ,;
                      proveedor  N(05) ,;
                      tipo       N(01) ,;
                      nrocuota   N(03) ,;
                      fecha      D(08) ,;
                      importe    N(12,2) ,;
                      abonado    N(12,2) ,;
                      monto_ndeb N(12,2) ,;
                      monto_ncre N(12,2) ,;
                      monto      N(12,2))

USE &temp02 ALIAS tmpcuonota EXCLUSIVE
INDEX ON STR(tipodocu, 1) + STR(nrodocu, 9) + STR(proveedor, 5) + STR(nrocuota, 3) TAG indice1

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

SET RELATION TO maestemp.familia    INTO familias ADDITIVE   
SET RELATION TO maestemp.rubro      INTO rubros1  ADDITIVE   
SET RELATION TO maestemp.subrubro   INTO rubros2  ADDITIVE   
SET RELATION TO maestemp.marca      INTO marcas1  ADDITIVE   
SET RELATION TO maestemp.unidad     INTO unidad   ADDITIVE   
SET RELATION TO maestemp.procedenci INTO proceden ADDITIVE   
SET RELATION TO maestemp.proveedor  INTO proveedo ADDITIVE

WAIT CLEAR

SELECT cabenotp
SET ORDER TO TAG indice1 OF cabenotp.cdx
GO TOP

*-- Establece relaciones entre las tablas.
SET RELATION TO cabenotp.proveedor INTO proveedo ADDITIVE

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
         DO mknota_p.prg WITH "Add"
         DO _RefreshInvoice
      CASE pnKey = -2             && Tecla F3 presionada, modificar registro.
         DO mknota_p.prg WITH "Edit"
         DO _RefreshInvoice
      CASE pnKey = -7             && Tecla F8 presionada, eliminar registro
         IF cabenotp.fechanota <> DATE() THEN
            WAIT "LOS REGISTROS DE ESTA TABLA NO PUEDEN SER BORRADOS !" WINDOW NOWAIT
            LOOP
         ENDIF

         DO _DeleteInvoice
      CASE pnKey = 5              && Tecla  presionada, siguiente registro.
         DO _NextRecord
      CASE pnKey = 24             && Tecla  presionada, registro anterior.
         DO _PriorRecord         
      CASE pnKey = 19             && Tecla  presionada, primer registro.
         DO _TopRecord
      CASE pnKey = 4              && Tecla -> presionada, £ltimo registro.
         DO _BottomRecord
      CASE INLIST(pnKey, 68, 100) && Tecla "D" may£scula o min£scula, examinar detalle.
         IF RECCOUNT("tmpdetnota") > 0
            DO _brwDetail
         ENDIF
      CASE pnKey = 13             && Tecla ENTER, visualizar cuotas.
         IF INLIST(cabenotp.tiponota, 1, 3) 
            WAIT WINDOW "­ LAS COMPRAS AL CONTADO NO POSEEN CUOTAS !"
         ELSE
            IF cabenotp.tiponota <> 0 .AND. cabenotp.nronota <> 0
               DO _brwQuota 
            ENDIF
         ENDIF
      CASE pnKey = -3             && Tecla F4 presionada, ordenar.         
         DO orden04.spr
      CASE pnKey = -9             && Tecla F10 presionada, examinar notas.
         ON KEY LABEL "F4" DO orden04.spr
         ON KEY LABEL "F5" DO _NotaSwitch

         DO _brwInvoices 

         ON KEY LABEL "F4" 
         ON KEY LABEL "F5" 

         DO _RefreshInvoice
      CASE pnKey = -4             && Tecla F5 presionada, buscar.
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
SELECT cabenotp
SET RELATION OFF INTO proveedo

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
*!               detalle, pie y cuota de la nota de d‚b./cr‚d.
*!
*!*********************************************************************
FUNCTION _RefreshInvoice

DO _fmtInvoice
DO _ShowHeader
DO _ShowDetail
DO _InvoiceFoot
DO _LoadQuota

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
@ 03,00 SAY "³ Proveedor.:                                                                  ³"
@ 04,00 SAY "³ Aplicado a:                           N§:             Fecha Fact.:           ³"
@ 05,00 SAY "³ Moneda....:                                        Tipo de Cambio:           ³"
@ 06,00 SAY "³ Motivo....:                                     Aplicado Contra:             ³"
@ 07,00 SAY "ÃÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´"
@ 08,00 SAY "³ ³Descripci¢n                           ³ Cantidad ³ Precio Unit.  ³ Importe  ³"
@ 09,00 SAY "ÃÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´"
@ 10,00 SAY "³ ³                                      ³          ³               ³          ³"
@ 11,00 SAY "³ ³                                      ³          ³               ³          ³"
@ 12,00 SAY "³ ³                                      ³          ³               ³          ³"
@ 13,00 SAY "³ ³                                      ³          ³               ³          ³"
@ 14,00 SAY "³ ³                                      ³          ³               ³          ³"
@ 15,00 SAY "³ ³                                      ³          ³               ³          ³"
@ 16,00 SAY "³ ³                                      ³          ³               ³          ³"
@ 17,00 SAY "³ ³                                      ³          ³               ³          ³"
@ 18,00 SAY "³ ³                                      ³          ³               ³          ³"
@ 19,00 SAY "ÃÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´"
@ 20,00 SAY "³ Rubro..:                                          SUB-TOTALES:               ³"
@ 21,00 SAY "³ Gravado:                                               I.V.A.:               ³"
@ 22,00 SAY "³ Stock..:                                        TOTAL GENERAL:               ³"
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

SELECT cabenotp
SCATTER MEMVAR

@ 02,14 SAY m.tiponota ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W

*-- Imprime la etiqueta del tipo de documento.
DO CASE
   CASE m.tiponota = 1
      @ 02,17 SAY "NOTA DE DEBITO" ;
         SIZE 1,20 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tiponota = 2
      @ 02,17 SAY "NOTA DE CREDITO" ;
         SIZE 1,20 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tiponota = 3
      @ 02,17 SAY "C.I. NOTA DE DEBITO" ;
         SIZE 1,20 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tiponota = 4
      @ 02,17 SAY "C.I. NOTA DE CREDITO" ;
         SIZE 1,20 ;
         PICTURE "@!" ;
         COLOR W/N
   OTHERWISE
      @ 02,17 SAY REPLICATE(CHR(32), 20) ;
         SIZE 1,20 ;
         PICTURE "@!" ;
         COLOR W/N
ENDCASE

@ 02,44 SAY m.nronota ;
   SIZE 1,9 ;
   PICTURE "999999999" ;
   COLOR N/W

@ 02,69 SAY m.fechanota ;
   SIZE 1,10 ;
   PICTURE "@D" ;
   COLOR N/W

@ 03,14 SAY m.proveedor  ;
   SIZE 1,5 ;
   PICTURE "99999" ;
   COLOR N/W

*-- Imprime el nombre del proveedor selecionado.
SELECT proveedo
SET ORDER TO TAG indice1 OF proveedo.cdx

IF SEEK(m.proveedor)
   @ 03,21 SAY PADR(ALLTRIM(proveedo.nombre), 40, CHR(32)) ;
      SIZE 1,40 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 03,21 SAY REPLICATE(CHR(32), 40) ;
      SIZE 1,40 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

SELECT cabenotp

@ 04,14 SAY m.tipodocu ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W

*-- Imprime la etiqueta del tipo de documento.
DO CASE
   CASE INLIST(m.tipodocu, 1, 7)
      @ 04,17 SAY "COMPRA CONTADO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE INLIST(m.tipodocu, 2, 8)
      @ 04,17 SAY "COMPRA CREDITO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 3
      @ 04,17 SAY "COMPRA I.V.A. INCLUIDO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 4
      @ 04,17 SAY "COMPRA TRIBUTO UNICO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   OTHERWISE
      @ 04,17 SAY REPLICATE(CHR(32), 22) ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
ENDCASE

@ 04,44 SAY m.nrodocu ;
   SIZE 1,9 ;
   PICTURE "999999999" ;
   COLOR N/W

*-- Imprime la fecha del documento, moneda y tipo de cambio de compra.
SELECT cabecomp
SET ORDER TO TAG indice1 OF cabecomp.cdx

IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 9) + STR(m.proveedor, 5))
   m.fechadocu  = cabecomp.fechadocu
   m.moneda     = cabecomp.moneda    
   m.tipocambio = cabecomp.tipocambio  

   @ 04,69 SAY m.fechadocu ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W

   @ 05,14 SAY m.moneda ;
      SIZE 1,4 ;
      PICTURE "9999" ;
      COLOR N/W
   
   *-- Imprime el nombre de la moneda.
   SELECT monedas
   SET ORDER TO TAG indice1 OF monedas.cdx
 
   IF SEEK(m.moneda)
      IF m.moneda = 1
         @ 05,20 SAY PADR(ALLTRIM(monedas.nombre), 30, CHR(32)) ;
            SIZE 1,30 ;
            PICTURE "@!" ;
            COLOR W/N
      ELSE
         @ 05,20 SAY PADR(ALLTRIM(monedas.nombre), 30, CHR(32)) ;
            SIZE 1,30 ;
            PICTURE "@!" ;
            COLOR G/N
      ENDIF
   ELSE
      @ 05,20 SAY REPLICATE(CHR(32), 30) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR W/N
   ENDIF

   SELECT cabenotp

   @ 05,69 SAY m.tipocambio ;
      SIZE 1,09 ;
      PICTURE "999999.99" ;
      COLOR N/W
ELSE
   m.fechadocu  = {}
   m.moneda     = 0
   m.tipocambio = 0

   @ 04,69 SAY m.fechadocu ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W

   @ 05,14 SAY m.moneda ;
      SIZE 1,4 ;
      PICTURE "9999" ;
      COLOR N/W

   @ 05,69 SAY m.tipocambio ;
      SIZE 1,09 ;
      PICTURE "999999.99" ;
      COLOR N/W
ENDIF

SELECT cabenotp

@ 06,14 SAY m.motivonota ;
   SIZE 1,3 ;
   PICTURE "999" ;
   COLOR N/W
   
*-- Imprime el nombre del motivo de la nota.
SELECT motivono
SET ORDER TO TAG indice1 OF motivono.cdx

IF SEEK(m.motivonota)
   @ 06,19 SAY PADR(ALLTRIM(motivono.nombre), 30, CHR(32)) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 06,19 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

SELECT cabenotp
   
@ 06,67 SAY m.aplicontra ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W
   
*-- Imprime el nombre de aplicado contra.
IF m.aplicontra = 1
   @ 06,69 SAY PADR(ALLTRIM("CAJA"), 10, CHR(32)) ;
      SIZE 1,10 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   IF m.aplicontra = 2
      @ 06,69 SAY PADR(ALLTRIM("CTA. CTE."), 10, CHR(32)) ;
         SIZE 1,10 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 06,69 SAY REPLICATE(CHR(32), 10) ;
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
*!  Descripci¢n: Carga  el detalle  de  la  nota  de  d‚b. / cr‚d. y lo 
*!               visualiza.
*!
*!*********************************************************************
FUNCTION _ShowDetail

SELECT tmpdetnota     &&   Vac¡a la  tabla  temporal  que  contiene  el
ZAP                   &&   detalle de art¡culos del documento.

SELECT detanotp

IF SEEK(STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5))
   SCAN WHILE STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5) = STR(detanotp.tiponota, 1) + STR(detanotp.nronota, 9) + STR(detanotp.proveedor, 5)
      INSERT INTO tmpdetnota (tiponota, nronota, proveedor, tipo, tipoc, articulo, cantidad, precio, pdescuento, impuesto, pimpuesto) ;
         VALUES (detanotp.tiponota, detanotp.nronota, detanotp.proveedor, detanotp.tipo, "A", detanotp.articulo, detanotp.cantidad, detanotp.precio, detanotp.pdescuento, detanotp.impuesto, detanotp.pimpuesto) 
   ENDSCAN
ELSE
  IF cabenotp.tiponota <> 0 .AND. cabenotp.nronota <> 0
     WAIT WINDOW "ESTE DOCUMENTO NO POSEE DETALLE, BORRELO Y VUELVA A CARGARLO"
  ENDIF
ENDIF

SELECT cabenotp
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

#DEFINE pnRow    9
#DEFINE pnColumn 1

SELECT tmpdetnota
GO TOP

SCAN WHILE RECNO() <= 9 .AND. .NOT. (EMPTY(articulo) .OR. EMPTY(cantidad) .OR. EMPTY(precio))
   @ pnRow + RECNO(), pnColumn      SAY tipo                                                   COLOR N/W
   @ pnRow + RECNO(), pnColumn + 2  SAY SUBSTR(maesprod.nombre, 1, 38)                         COLOR N/W
   @ pnRow + RECNO(), pnColumn + 41 SAY cantidad                       PICTURE "999,999.99"    COLOR N/W
   @ pnRow + RECNO(), pnColumn + 52 SAY precio                         PICTURE "99,999,999.9999" COLOR N/W
   IF m.moneda <> 1
      @ pnRow + RECNO(), pnColumn + 68 SAY ROUND(precio * cantidad, 2) PICTURE "999,999.99"    COLOR N/W
   ELSE
      @ pnRow + RECNO(), pnColumn + 68 SAY ROUND(precio * cantidad, 0) PICTURE "99,999,999"    COLOR N/W  
   ENDIF
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

SELECT tmpdetnota
GO TOP

STORE 0 TO m.monto_nota, pnGravada, pnExenta, pnImpuesto, pnSubTotal

IF m.moneda <> 1
   SCAN ALL
      DO CASE
         CASE impuesto .AND. pimpuesto > 0 .AND. pimpuesto < 10
            pnGravada = pnGravada + ROUND(precio * (1 - pdescuento / 100) * cantidad, 2) * (pimpuesto * (control.pimpuesto / 100))
            pnExenta  = pnExenta  + ROUND(precio * (1 - pdescuento / 100) * cantidad, 2) * (1 - (pimpuesto * (control.pimpuesto / 100)))
         CASE impuesto .AND. pimpuesto = control.pimpuesto
            pnGravada = pnGravada + ROUND(precio * (1 - pdescuento / 100) * cantidad, 2)            
         CASE .NOT. impuesto .AND. pimpuesto = 0
            pnExenta  = pnExenta  + ROUND(precio * (1 - pdescuento / 100) * cantidad, 2)
      ENDCASE
   ENDSCAN

   pnSubTotal   = pnGravada + pnExenta
   pnImpuesto   = ROUND(pnGravada * (control.pimpuesto / 100), 2)
   m.monto_nota = pnSubTotal + pnImpuesto
ELSE
   SCAN ALL
      DO CASE
         CASE impuesto .AND. pimpuesto > 0 .AND. pimpuesto < 10
            pnGravada = pnGravada + ROUND(precio * (1 - pdescuento / 100) * cantidad, 0) * (pimpuesto * (control.pimpuesto / 100))
            pnExenta  = pnExenta  + ROUND(precio * (1 - pdescuento / 100) * cantidad, 0) * (1 - (pimpuesto * (control.pimpuesto / 100)))
         CASE impuesto .AND. pimpuesto = control.pimpuesto
            pnGravada = pnGravada + ROUND(precio * (1 - pdescuento / 100) * cantidad, 0)            
         CASE .NOT. impuesto .AND. pimpuesto = 0
            pnExenta  = pnExenta  + ROUND(precio * (1 - pdescuento / 100) * cantidad, 0)
      ENDCASE
   ENDSCAN

   pnSubTotal   = pnGravada + pnExenta
   pnImpuesto   = ROUND(pnGravada * (control.pimpuesto / 100), 0)
   m.monto_nota = pnSubTotal + pnImpuesto
ENDIF

@ 20,65 SAY pnSubTotal ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR N/W

@ 21,65 SAY pnImpuesto ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR N/W

@ 22,65 SAY m.monto_nota ;
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

SELECT cuotas_c

IF SEEK(STR(cabenotp.tipodocu, 1) + STR(cabenotp.nrodocu, 9) + STR(cabenotp.proveedor, 5))
   SCAN WHILE STR(cabenotp.tipodocu, 1) + STR(cabenotp.nrodocu, 9) + STR(cabenotp.proveedor, 5) = STR(cuotas_c.tipodocu, 1) + STR(cuotas_c.nrodocu, 9) + STR(cuotas_c.proveedor, 5)
      INSERT INTO tmpcuonota (tipodocu, nrodocu, proveedor, tipo, nrocuota, fecha, importe, abonado, monto_ndeb, monto_ncre) ;
         VALUES (cuotas_c.tipodocu, cuotas_c.nrodocu, cuotas_c.proveedor, cuotas_c.tipo, cuotas_c.nrocuota, cuotas_c.fecha, cuotas_c.importe, cuotas_c.abonado, cuotas_c.monto_ndeb, cuotas_c.monto_ncre)
   ENDSCAN
ELSE
  IF INLIST(cabecomp.tipodocu, 2, 6, 8)
     WAIT WINDOW "     ­ ESTE DOCUMENTO NO POSEE CUOTAS !" + CHR(13) + ;
                 "MODIFIQUELO PARA VOLVER A GENERAR LAS CUOTAS"
  ENDIF
ENDIF

SELECT cabenotp

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

SELECT tmpdetnota
GO TOP

IF m.moneda <> 1
   BROWSE WINDOW tmpdetnota FIELDS ;
      tipo                                     :R:01:H = "" ,;
      calc_f0 = SUBSTR(articulo, 1, 13)        :R:13:H = "C¢digo" ,;
      calc_f1 = SUBSTR(maesprod.nombre, 1, 34) :R:34:H = "Descripci¢n"  :P = "@!" :W = .F. ,;
      cantidad                                 :R:09:H = "Cantidad"     :P = "999999.99" ,;
      precio                                   :R:15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = .F. ,;
      pdescuento                               :R:07:H = "% Dcto."   :P="99.9999" ,;      
      calc_f2 = ROUND(precio * (1 - pdescuento / 100) * cantidad, 2) :R:11:H = " Sub-Total"   :P = "9999,999.99" ,;
      calc_f3 = IIF(impuesto, "   S¡", "")     :R:08:H = "Impuesto"     :W = .F. ,;
      pimpuesto                                :R:06:H = "% Imp."       :P = "999.99" ;
      NOAPPEND NODELETE NOMODIFY

   SELECT cabenotp
ELSE
   BROWSE WINDOW tmpdetnota FIELDS ;
      tipo                                     :R:01:H = "" ,;
      calc_f0 = SUBSTR(articulo, 1, 13)        :R:13:H = "C¢digo" ,;
      calc_f1 = SUBSTR(maesprod.nombre, 1, 34) :R:34:H = "Descripci¢n"  :P = "@!" :W = .F. ,;
      cantidad                                 :R:09:H = "Cantidad"     :P = "999999.99" ,;
      precio                                   :R:15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = .F. ,;
      pdescuento                               :R:07:H = "% Dcto."      :P = "99.9999" ,;      
      calc_f2 = ROUND(precio * (1 - pdescuento / 100) * cantidad, 0)    :R:11:H = " Sub-Total"   :P = "999,999,999" ,;
      calc_f3 = IIF(impuesto, "   S¡", "")     :R:08:H = "Impuesto"     :W = .F. ,;
      pimpuesto                                :R:06:H = "% Imp."       :P = "999.99" ;
      NOAPPEND NODELETE NOMODIFY

   SELECT cabenotp
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

SELECT tmpcuonota
GO TOP

BROWSE WINDOW tmpcuonota FIELDS ;
   calc_f1 = IIF(tipo = 1,"Entr",IIF(tipo = 2,"Cuot",""))      :R:04:H = "Tipo" ,;
   nrocuota                                                    :R:03:H = "N§" :P = "999",;
   fecha                                                       :R:10:H = "Fecha Vcto" ,;
   calc_f2 = TRANSFORM(importe, IIF(m.moneda <> 1, "999,999.99", "99,999,999")) :10:H = "Importe" ,;
   calc_f3 = TRANSFORM((importe + monto_ndeb) - (monto_ncre + abonado), IIF(m.moneda <> 1, "999,999.99", "99,999,999")) :R:10:H = "Saldo" ,;
   calc_f4 = TRANSFORM(abonado, IIF(m.moneda <> 1, "999,999.99", "99,999,999")) :10:H = "Abonado" ,;
   calc_f5 = TRANSFORM(monto_ndeb, IIF(m.moneda <> 1, "999,999.99", "99,999,999")) :10:H = "Monto Ndeb" ,;
   calc_f6 = TRANSFORM(monto_ncre, IIF(m.moneda <> 1, "999,999.99", "99,999,999")) :10:H = "Monto Ncre" ;

DEACTIVATE WINDOW tmpmarcuot

SELECT cabenotp

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

SELECT cabenotp

BROWSE WINDOW brwNotas FIELDS ;
   calc_f1 = IIF(tiponota = 1,"NDEB", IIF(tiponota = 2,"NCRE", IIF(tiponota = 3, "CINDE", IIF(tiponota = 4, "CINCR", "")))) :R:05:H = "" ,;
   nronota    :R:09:P = "999999999"     :H = "N§ Nota" ,;
   fechanota  :R:10:P = "@D"          :H = "Fecha Nota" ,;
   calc_f2 = IIF(tipodocu = 1,"CCO", IIF(tipodocu = 2,"CCR", IIF(tipodocu = 3, "CII", IIF(tipodocu = 4, "CTU", "")))) :R:03:H = "" ,;
   nrodocu    :R:09:P = "999999999"     :H = "N§ Doc." ,;
   monto_nota :R:14:P = "999,999,999.99" :H = "Monto Nota" ,;
   calc_f3 = SUBSTR(proveedo.nombre, 1, 40) :R:40:P = "@!" :H = "Proveedor" ,;
   proveedor :R:07:P = "9999999" :H = "C¢d.Pro" ;
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
         DO mknota_p.prg
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

IF FOUND()
   DO _RefreshInvoice
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _DeleteInvoice
*!
*!  Llamado por: mknota_p.PRG       
*!
*!  Descripci¢n: Borra o anula la nota de debito o credito - proveedo.
*!
*!*********************************************************************
FUNCTION _DeleteInvoice

PUSH KEY CLEAR

IF EOF()
   DO WHILE .T.
      WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
      IF UPPER(pcAppend) = "S"
         DO mknota_p.prg WITH "Add"
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
   *-- Actualiza el campo cuotas_c.monto_ndeb o cuotas_c.monto_ncre y borra la(s) cuota(s) de la nota de d‚bito / cr‚dito.
   SELECT cuotas_p
   SET ORDER TO TAG indice1 OF cuotas_p.cdx
  
   IF SEEK(STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5))
      SCAN WHILE STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5) = STR(cuotas_p.tiponota, 1) + STR(cuotas_p.nronota, 9) + STR(cuotas_p.proveedor, 5)
         SELECT cuotas_c
         SET ORDER TO TAG indice1 OF cuotas_c.cdx
     
         IF SEEK(STR(cabenotp.tipodocu, 1) + STR(cabenotp.nrodocu, 9) + STR(cabenotp.proveedor, 5) + STR(cuotas_p.nrocuota, 3))
            IF INLIST(cabenotp.tiponota, 1, 3)
               REPLACE cuotas_c.monto_ndeb WITH (cuotas_c.monto_ndeb - cuotas_p.importe)
            ELSE
               IF INLIST(cabenotp.tiponota, 2, 4)
                  REPLACE cuotas_c.monto_ncre WITH (cuotas_c.monto_ncre - cuotas_p.importe)
               ENDIF
            ENDIF
         ELSE
            WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR LA CUOTA N§: " + ALLTRIM(STR(cuotas_p.nrocuota, 3)) + " DE LA COMPRA: " + ALLTRIM(STR(cabenotp.tipodocu, 1)) + "/" + ALLTRIM(STR(cabenotp.nrodocu, 9)) + " !"
         ENDIF
      
         SELECT cuotas_p
         DELETE
      ENDSCAN
   ENDIF

   *-- Actualiza el campo maesprod.stock_actu y borra el detalle de la nota de debito o credito.
   SELECT detanotp
   SET ORDER TO TAG indice1 OF detanotp.cdx
   
   IF SEEK(STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5))
      SCAN WHILE STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5) = STR(detanotp.tiponota, 1) + STR(detanotp.nronota, 9) + STR(detanotp.proveedor, 5)
         IF detanotp.tipo = "S"
            SELECT maesprod
            SET ORDER TO TAG indice1 OF maesprod.cdx
        
            IF SEEK(detanotp.articulo)
               IF INLIST(cabenotp.tiponota, 1, 3)
                  REPLACE maesprod.stock_actu WITH (maesprod.stock_actu - detanotp.cantidad)
               ELSE
                  IF INLIST(cabenotp.tiponota, 2, 4)
                     REPLACE maesprod.stock_actu WITH (maesprod.stock_actu + detanotp.cantidad)
                  ENDIF
               ENDIF
            ELSE
               WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL ARTICULO: " + ALLTRIM(detanotp.articulo) + " !"
            ENDIF
         ENDIF
         SELECT detanotp
         DELETE
      ENDSCAN
   ELSE
      IF cabenotp.tiponota <> 0 .AND. cabenotp.nronota <> 0
         WAIT WINDOW "­ NO SE HA ENCONTRADO DETALLE A BORRAR !"
      ENDIF
   ENDIF

   *-- Actualiza el campo proveedo.saldo_actu, si cabenotp.tipodocu = 2 y cabenotp.aplicontra = 2.
   IF INLIST(cabenotp.tipodocu, 2, 8) .AND. cabenotp.aplicontra = 2
      SELECT cabecomp
      SET ORDER TO TAG "indice1"
      SEEK STR(cabenotp.tipodocu, 1) + STR(cabenotp.nrodocu, 9) + STR(cabenotp.proveedor, 5)
      
      SELECT proveedo
      SET ORDER TO TAG "indice1"
      IF SEEK(cabenotp.proveedor)
         IF INLIST(cabenotp.tiponota, 1, 3)
            IF cabecomp.moneda = 1 THEN
               REPLACE saldo_actu WITH (saldo_actu - cabenotp.monto_nota)
            ELSE
               REPLACE saldo_usd  WITH (saldo_usd  - cabenotp.monto_nota)
            ENDIF
         ELSE
            IF INLIST(cabenotp.tiponota, 2, 4)
               IF cabecomp.moneda = 1 THEN
                  REPLACE saldo_actu WITH (saldo_actu + cabenotp.monto_nota)
               ELSE
                  REPLACE saldo_usd  WITH (saldo_usd + cabenotp.monto_nota)
               ENDIF
            ENDIF
         ENDIF
      ELSE
         IF cabenotp.tiponota <> 0 .AND. cabenotp.nronota <> 0
            WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DEL PROVEEDOR: " + ALLTRIM(STR(cabenotp.proveedor, 5)) + " !"
         ENDIF
     ENDIF
   ENDIF

   *-- Actualiza el campo cabecomp.monto_ndeb o cabecomp.monto_ncre y borra el encabezado de la nota de d‚bito / cr‚dito.
   SELECT cabecomp
   SET ORDER TO TAG indice1 OF cabecomp.cdx

   IF SEEK(STR(cabenotp.tipodocu, 1) + STR(cabenotp.nrodocu, 9) + STR(cabenotp.proveedor, 5))
      IF INLIST(cabenotp.tiponota, 1, 3) .AND. cabenotp.aplicontra = 2
         REPLACE cabecomp.monto_ndeb WITH (cabecomp.monto_ndeb - cabenotp.monto_nota)
      ELSE
         IF INLIST(cabenotp.tiponota, 2, 4) .AND. cabenotp.aplicontra = 2
            REPLACE cabecomp.monto_ncre WITH (cabecomp.monto_ncre - cabenotp.monto_nota)
         ENDIF
      ENDIF
   ELSE
      IF cabenotp.tiponota <> 0 .AND. cabenotp.nronota <> 0
         WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DE LA COMPRA: " + ALLTRIM(STR(cabenotp.tipodocu, 1)) + "/" + ALLTRIM(STR(cabenotp.nrodocu, 9)) + " !" 
      ENDIF
   ENDIF

   SELECT cabenotp
   SET ORDER TO TAG indice1 OF cabenotp.cdx

   IF SEEK(STR(m.tiponota, 1) + STR(m.nronota, 9) + STR(m.proveedor, 5))
      SCAN WHILE (STR(m.tiponota, 1) + STR(m.nronota, 9) + STR(m.proveedor, 5)) = (STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5))
         DELETE
      ENDSCAN
   ENDIF
   
   IF INLIST(m.tiponota, 1, 3)
      WAIT WINDOW "­ ESTA NOTA DE DEBITO HA SIDO BORRADA !"
   ELSE
      IF INLIST(m.tiponota, 2, 4)
         WAIT WINDOW "­ ESTA NOTA DE CREDITO HA SIDO BORRADA !"
      ELSE
         WAIT WINDOW "­ ESTA NOTA HA SIDO BORRADA !"
      ENDIF
   ENDIF

   IF EOF()
      GO BOTTOM
   ENDIF

   DO _RefreshInvoice

ENDIF

POP KEY

*!*********************************************************************
*!
*!      Funci¢n: _NextRecord    
*!
*!  Llamado por: COMPRAS.PRG
*!
*!  Descripci¢n: Desplaza el puntero de registro al siguiente registro.
*!
*!*********************************************************************
FUNCTION _NextRecord
IF NOT EOF()
   SKIP 1
   IF EOF("cabenotp")           
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
*!  Llamado por: COMPRAS.PRG
*!
*!  Descripci¢n: Desplaza el puntero de registro al registro anterior.
*!
*!*********************************************************************
FUNCTION _PriorRecord
IF NOT BOF()
   SKIP -1
   IF BOF("cabenotp")
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
*!  Llamado por: COMPRAS.PRG
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
*!  Llamado por: COMPRAS.PRG
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