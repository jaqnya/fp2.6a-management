WAIT WINDOW "POR FAVOR, ESPERE MIENTRAS SE CARGA EL MODULO..." NOWAIT
*-- Configuraci¢n Temporal
CLEAR
plAdding = .F.
plEditing = .F.

gcLocal = " ALBEN S.R.L. "

store .f. to m.editing
store .t. to m.adding
set deleted on
set safety off
set century on
set date british

PRIVATE m.tipodocu, pnGravada, pnExenta, pnImpuesto, pnSubTotal, m.monto_fact, pnTipoDocu, plClearRead, plCancel
STORE 0 TO pnGravada, pnExenta, pnImpuesto, pnSubTotal, m.porcdesc, m.importdesc, m.monto_fact, pnTipoDocu
STORE .F. TO plClearRead, plCancel

*-- MS-DOS Definiciones de ventanas.
IF NOT WEXIST("tmpdetcomp")
   DEFINE WINDOW tmpdetcomp ;
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

IF NOT WEXIST("tmpcuocomp")
   DEFINE WINDOW tmpcuocomp ;
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
      noCLOSE ;
      NOSHADOW ;
      noZOOM ;
      NOMINIMIZE ;
      COLOR SCHEME 15
ENDIF

IF NOT WEXIST("BCompras")
   DEFINE WINDOW BCompras ;
      FROM 01,00 ;
      TO 23,79 ;
      TITLE "< COMPRAS >" ;
      NOFLOAT ;
      CLOSE ;
      NOSHADOW ;
      ZOOM ;
      NOMINIMIZE ;
      SYSTEM ;
      COLOR SCHEME 15
ENDIF

*-- MS-DOS Base de datos, ¡ndices, relaciones.
IF USED("familias")
   SELECT familias
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("familias.dbf", "DBF", "¨ D¢nde est  FAMILIAS.DBF ?")) ;
      AGAIN ALIAS familias ;
      ORDER TAG indice1
ENDIF

IF USED("rubros1")
   SELECT rubros1
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("rubros1.dbf", "DBF", "¨ D¢nde est  RUBROS1.DBF ?")) ;
      AGAIN ALIAS rubros1 ;
      ORDER TAG indice1
ENDIF

IF USED("rubros2")
   SELECT rubros2
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("rubros2.dbf", "DBF", "¨ D¢nde est  RUBROS2.DBF ?")) ;
      AGAIN ALIAS rubros2 ;
      ORDER TAG indice1
ENDIF

IF USED("marcas")
   SELECT marcas
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("marcas.dbf", "DBF", "¨ D¢nde est  MARCAS.DBF ?")) ;
      AGAIN ALIAS marcas ;
      ORDER TAG indice1
ENDIF

IF USED("unidad")
   SELECT unidad
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("unidad.dbf", "DBF", "¨ D¢nde est  UNIDAD.DBF ?")) ;
      AGAIN ALIAS unidad ;
      ORDER TAG indice1
ENDIF

IF USED("proceden")
   SELECT proceden
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("proceden.dbf", "DBF", "¨ D¢nde est  PROCEDEN.DBF ?")) ;
      AGAIN ALIAS proceden ;
      ORDER TAG indice1
ENDIF

IF USED("proveedo")
   SELECT proveedo
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("proveedo.dbf", "DBF", "¨ D¢nde est  PROVEEDO.DBF ?")) ;
      AGAIN ALIAS proveedo ;
      ORDER TAG indice1
ENDIF

IF USED("maesprod")
   SELECT maesprod
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("maesprod.dbf", "DBF", "¨ D¢nde est  MAESPROD.DBF ?")) ;
      AGAIN ALIAS maesprod ;
      ORDER TAG indice1
ENDIF

**-- Carga la matriz con los datos de la tabla de art¡culos.
*WAIT WINDOW "CARGANDO..." NOWAIT
PRIVATE pcCurrSelect, pcCurrOrder, pnCurrRecord, pnCount, pnChoice, paMaesprod, pnCounter

*pcCurrSelect = SELECT()
*pcCurrOrder  = ORDER()
*pnCurrRecord = IIF(EOF(),0,RECNO())

*SELECT maesprod
SET ORDER TO TAG indice2 OF maesprod.cdx
GO TOP
COUNT TO pnCount
IF EMPTY(pnCount)
   DIMENSION paMaesprod[1,4]
   paMaesprod = ""
ELSE
   DIMENSION paMaesprod[pnCount,4]
   pnCounter = 1
   SCAN
      paMaesprod[pnCounter,1] = codigo      
      paMaesprod[pnCounter,2] = nombre + " ³" + codorig + "³" + codigo2
      paMaesprod[pnCounter,3] = codorig
      paMaesprod[pnCounter,4] = codigo2
      pnCounter = pnCounter + 1
   ENDSCAN
*   WAIT CLEAR
ENDIF
SET ORDER TO TAG indice1 OF maesprod.cdx
*SELECT (pcCurrSelect)
*SET ORDER TO TAG (pcCurrOrder)
*IF pnCurrRecord # 0
*   GOTO RECORD pnCurrRecord
*ENDIF
**--

GO TOP

SELECT 0
temp01 = "tm"+RIGHT(SYS(3),6)+".dbf"
CREATE TABLE &temp01 (tipodocu   n(01), ;
                      nrodocu    n(09), ;
                      proveedor  n(05), ;
                      articulo   c(15), ;
                      cantidad   n(09,2), ;
                      precio     n(13,4), ;
                      pdescuento n(07,4), ;
                      impuesto   l(01), ;
                      pimpuesto  n(06,2), ;
                      tipoc      c(01))
                      
USE &temp01 ALIAS tmpdetcomp EXCLUSIVE
INDEX ON STR(tipodocu,1)+STR(nrodocu,9)+STR(PROVEEDOR,5) TAG indice1
SET RELATION TO tmpdetcomp.articulo INTO maesprod ADDITIVE

SELECT 0
temp02 = "tm"+RIGHT(SYS(3),6)+".dbf"
CREATE TABLE &temp02 (tipodocu   n(01), ;
                      nrodocu    n(09), ;
                      proveedor  n(05), ;
                      tipo       n(01), ;
                      nrocuota   n(03), ;
                      fecha      d(08), ;
                      importe    n(09), ;
                      abonado    n(09), ;
                      monto_ndeb n(09), ;
                      monto_ncre n(09))
USE &temp02 ALIAS tmpcuocomp EXCLUSIVE
INDEX ON STR(tipodocu,1)+STR(nrodocu,9)+STR(nrocuota,3) TAG indice1

IF USED("cuotas_c")
   SELECT cuotas_c
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cuotas_c.dbf", "DBF", "¨ D¢nde est  CUOTAS_C.DBF ?")) ;
      AGAIN ALIAS cuotas_c ;
      ORDER TAG indice1
ENDIF


IF USED("cabecomp")
   SELECT cabecomp
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabecomp.dbf", "DBF", "¨ D¢nde est  CABECOMP.DBF ?")) ;
      AGAIN ALIAS cabecomp ;
      ORDER TAG indice1
ENDIF

GO TOP


IF USED("detacomp")
   SELECT detacomp
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detacomp.dbf", "DBF", "¨ D¢nde est  DETACOMP.DBF ?")) ;
      AGAIN ALIAS detacomp ;
      ORDER TAG indice1
ENDIF

GO TOP
SET RELATION TO detacomp.articulo INTO maesprod ADDITIVE

IF USED("control")
   SELECT control
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("control.dbf", "DBF", "¨ D¢nde est  CONTROL.DBF ?")) ;
      AGAIN ALIAS control ;
      ORDER TAG 0
ENDIF

IF USED("monedas")
   SELECT monedas
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("monedas.dbf", "DBF", "¨ D¢nde est  MONEDAS.DBF ?")) ;
      AGAIN ALIAS monedas ;
      ORDER TAG indice1
ENDIF

WAIT CLEAR

SELECT cabecomp
GO TOP
SCATTER MEMVAR

DO _fmtInvoice
DO _ShowHeader
DO _ShowDetail
DO _InvoiceFoot
DO _LoadQuota

*-- Bucle principal del programa.
DO WHILE .T.  
   pnKey = INKEY(0, "HM")       && Tomar INKEY(), ocultar cursor, comprobar rat¢n.
   IF pnKey = 0                 && No hay pulsaci¢n de tecla ni rat¢n.
      LOOP
   ENDIF
   IF pnKey = 27                && Tecla Esc presionada,              
      EXIT                      && salir del bucle principal.
   ENDIF
   IF pnKey = 151               && Clic sencillo del rat¢n.
      LOOP
   ENDIF
   DO CASE
      CASE pnKey = -1           && Tecla F2 presionada, agregar registro.
         STORE 0 TO pnGravada, pnExenta, pnImpuesto, pnSubTotal, m.porcdesc, m.importdesc, m.monto_fact, pnTipoDocu
         SCATTER MEMVAR MEMO BLANK
         SELECT tmpdetcomp 
         ZAP
         SELECT tmpcuocomp 
         ZAP
         SELECT CABECOMP
         plAdding = .T.
         SET EXACT ON
         DO COMPNEW1.PRG
         SET EXACT OFF
         DO _fmtInvoice
         DO _ShowHeader
         DO _ShowDetail
         DO _InvoiceFoot
         DO _LoadQuota
         SELECT cabecomp
      CASE pnKey = -7            && Tecla F8 presionada, eliminar registro
         DO WHILE .T.
            WAIT WINDOW "¨ DESEA BORRAR ESTA COMPRA ? [S/N]" TO pcWhatToDo
            IF UPPER(pcWhatToDo) = "S"
               IF m.monto_ndeb = 0 .OR. ;
                  m.monto_ncre = 0 .OR. ;
                  m.monto_pago = 0 
                  SELECT cuotas_c
                  IF SEEK(STR(m.tipodocu, 1)+STR(m.nrodocu, 9)+STR(m.proveedor, 5))
                     SCAN WHILE m.tipodocu = cuotas_c.tipodocu .AND. m.nrodocu = cuotas_c.nrodocu .AND. m.proveedor = cuotas_c.proveedor .AND. .NOT. EOF()
                        DELETE
                     ENDSCAN
                  ENDIF
                  SELECT detacomp
                  IF SEEK(STR(m.tipodocu, 1)+STR(m.nrodocu, 9)+STR(m.proveedor, 5))
                     SCAN WHILE m.tipodocu = detacomp.tipodocu .AND. m.nrodocu = detacomp.nrodocu .AND. m.proveedor = detacomp.proveedor .AND. .NOT. EOF()
                        DELETE
                     ENDSCAN
                  ENDIF
                  SELECT cabecomp
                  IF SEEK(STR(m.tipodocu, 1)+STR(m.nrodocu, 9)+STR(m.proveedor, 5))
                     SCAN WHILE m.tipodocu = cabecomp.tipodocu .AND. m.nrodocu = cabecomp.nrodocu .AND. m.proveedor = cabecomp.proveedor .AND. .NOT. EOF()
                        DELETE
                     ENDSCAN
                  ENDIF
                  WAIT WINDOW "­ ESTA COMPRA HA SIDO BORRADA !"
               ELSE
                  WAIT WINDOW "IMPOSIBLE BORRAR"
               ENDIF
               EXIT DO
            ELSE
               IF UPPER(pcWhatToDo) = "N"
                  EXIT DO 
               ENDIF
            ENDIF
         ENDDO
            DO _fmtInvoice
            DO _ShowHeader
            DO _ShowDetail
            DO _InvoiceFoot
            DO _LoadQuota
      CASE pnKey = 5            && Tecla  presionada, siguiente registro.
         IF .NOT. EOF()
            SKIP 1
            IF EOF("cabecomp")           
               WAIT WINDOW "­ FIN DE LA TABLA !" NOWAIT
               SKIP -1
            ELSE
               DO _fmtInvoice
               DO _ShowHeader
               DO _ShowDetail
               DO _InvoiceFoot
               DO _LoadQuota
            ENDIF
         ELSE
            WAIT WINDOW "­ FIN DE LA TABLA !" NOWAIT
         ENDIF
      CASE pnKey = 24           && Tecla  presionada, registro anterior.
         IF .NOT. BOF()
            SKIP -1
            IF BOF("cabecomp")
               WAIT WINDOW "­ INICIO DE LA TABLA !" NOWAIT
               GO TOP
            ELSE
               DO _fmtInvoice
               DO _ShowHeader
               DO _ShowDetail
               DO _InvoiceFoot
               DO _LoadQuota
            ENDIF
         ELSE
            WAIT WINDOW "­ INICIO DE LA TABLA !" NOWAIT            
         ENDIF
      CASE pnKey = 19           && Tecla  presionada, primer registro.  
         GO TOP 
         IF .NOT. BOF()
            DO _fmtInvoice
            DO _ShowHeader
            DO _ShowDetail
            DO _InvoiceFoot
            DO _LoadQuota
         ELSE
            WAIT WINDOW "­ INICIO DE LA TABLA !" NOWAIT
         ENDIF
      CASE pnKey = 4            && Tecla -> presionada, £ltimo registro.  
         GO BOTTOM
         IF .NOT. EOF()
            DO _fmtInvoice
            DO _ShowHeader
            DO _ShowDetail
            DO _InvoiceFoot
            DO _LoadQuota
         ELSE
            WAIT WINDOW "­ FIN DE LA TABLA !" NOWAIT
         ENDIF
      CASE INLIST(pnKey,68,100) && Tecla "D" may£scula o min£scula, examinar detalle.
         DO _brwDetail
      CASE pnKey = 13           && Tecla ENTER
         IF m.tipodocu # 2
            WAIT WINDOW "­ LAS COMPRAS AL CONTADO NO POSEEN CUOTAS !"
         ELSE
            DO _brwQuota 
         ENDIF
      CASE pnKey = -3           && Tecla F4 presionada, ordenar.         
         DO cmporden.spr
      CASE pnKey = -9           && Tecla F10 presionada, examinar facturas.
         DO _brwInvoices 
         DO _fmtInvoice
         DO _ShowHeader
         DO _ShowDetail
         DO _InvoiceFoot
         DO _LoadQuota
      CASE pnKey = -4           && Tecla F5 presionada, buscar.
         DO _cmpSwitch
         IF FOUND()
            DO _fmtInvoice
            DO _ShowHeader
            DO _ShowDetail
            DO _InvoiceFoot
            DO _LoadQuota
         ENDIF
      ENDCASE
ENDDO     Fin del bucle principal.     
        

*-- MS-DOS Cierre de Bases de Datos.
IF USED("familias")
   SELECT familias
   USE
ENDIF

IF USED("rubros1")
   SELECT rubros1
   USE 
ENDIF

IF USED("rubros2")
   SELECT rubros2
   USE
ENDIF

IF USED("marcas")
   SELECT marcas
   USE 
ENDIF

IF USED("unidad")
   SELECT unidad
   USE
ENDIF

IF USED("proceden")
   SELECT proceden
   USE 
ENDIF

*IF USED("proveedo")
*   SELECT proveedo
*   USE
*ENDIF

*IF USED("maesprod")
*   SELECT maesprod
*   USE
*ENDIF

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

IF USED("cuotas_c")
   SELECT cuotas_c
   USE 
ENDIF

*IF USED("cabecomp")
*   SELECT cabecomp
*   USE 
*ENDIF

IF USED("detacomp")
   SELECT detacomp
   USE 
ENDIF

IF USED("control")
   SELECT control
   USE 
ENDIF


IF WEXIST("tmpdetcomp")
   RELEASE WINDOW tmpdetcomp
ENDIF

IF WEXIST("tmpcuocomp")
   RELEASE WINDOW tmpcuocomp
ENDIF

IF WEXIST("tmpmarcuot")
   RELEASE WINDOW tmpmarcuot
ENDIF

IF WEXIST("BCompras")
   RELEASE WINDOW BCompras
ENDIF




*-- MS-DOS Procedimientos y funciones de soporte.

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
@ 19,00 SAY "³ Rubro...:                                            SUB-TOTALES:            ³"
@ 20,00 SAY "³ Gravado.:                                            % DESCUENTO:            ³"
@ 21,00 SAY "³ S.Actual:                                                 I.V.A.:            ³"
@ 22,00 SAY "³                                                    TOTAL GENERAL:            ³"
@ 23,00 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"


FUNCTION _ShowHeader     && Carga la cabecera de la factura y lo muestra.
SELECT cabecomp
SCATTER MEMVAR
@ 02,13 SAY m.tipodocu ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W
DO CASE
   CASE m.tipodocu = 1
      @ 02,16 SAY "COMPRA CONTADO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 2
      @ 02,16 SAY "COMPRA CREDITO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 3
      @ 02,16 SAY "COMPRA I.V.A. INCLUIDO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 4
      @ 02,16 SAY "COMPRA TRIBUTO UNICO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   OTHERWISE
      @ 02,16 SAY REPLICATE(CHR(32),22) ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
ENDCASE
@ 04,13 SAY m.proveedor ;
   SIZE 1,5 ;
   PICTURE "99999" ;
   COLOR N/W

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

SELECT monedas
IF SEEK(m.moneda)
   @ 06,20 SAY PADR(ALLTRIM(monedas.nombre), 30, CHR(32)) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 06,20 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF
SELECT cabecomp

@ 06,68 SAY m.tipocambio ;
   SIZE 1,10 ;
   PICTURE "999,999.99" ;
   COLOR N/W


FUNCTION _ShowDetail     && Carga el detalle de la factura y lo muestra.
SELECT tmpdetcomp        
ZAP
SELECT detacomp
STORE 0 TO pnGravada, pnExenta, pnImportIVA, pnSubTotal, pnTotalGeneral
IF SEEK(STR(m.tipodocu,1)+STR(m.nrodocu,9)+STR(m.proveedor,5))
   DO WHILE m.tipodocu = detacomp.tipodocu .AND. m.nrodocu = detacomp.nrodocu .AND. m.proveedor = detacomp.proveedor .AND. .NOT. EOF()
      SELECT tmpdetcomp
      APPEND BLANK
      REPLACE tipodocu   WITH detacomp.tipodocu
      REPLACE nrodocu    WITH detacomp.nrodocu
      REPLACE proveedor  WITH detacomp.proveedor
      REPLACE articulo   WITH detacomp.articulo
      REPLACE cantidad   WITH detacomp.cantidad
      REPLACE precio     WITH detacomp.precio
      REPLACE pdescuento WITH detacomp.pdescuento
      REPLACE impuesto   WITH detacomp.impuesto
      REPLACE pimpuesto  WITH detacomp.pimpuesto
      SELECT detacomp
      SKIP 1
   ENDDO
ENDIF
SELECT cabecomp
DO _printDetail



FUNCTION _printDetail
PRIVATE pcSelect, pcOrder, pnRecNo, pnRow, pnColumn

pcSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())
pnRow    = 8
pnColumn = 2

SELECT tmpdetcomp
SCAN FOR RECNO() <= 9 .AND. .NOT. EMPTY(articulo)
   @ pnRow + RECNO(), pnColumn      SAY SUBSTR(maesprod.nombre, 1, 39)                                                 COLOR N/W
   @ pnRow + RECNO(), pnColumn + 40 SAY cantidad                                             PICTURE "999,999.99"      COLOR N/W
   @ pnRow + RECNO(), pnColumn + 51 SAY precio                                               PICTURE "99,999,999.9999" COLOR N/W
   @ pnRow + RECNO(), pnColumn + 67 SAY ROUND(precio * (1 - pdescuento / 100) * cantidad, 0) PICTURE "99,999,999"      COLOR N/W
ENDSCAN

SELECT (pcSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo # 0
   GOTO RECORD pnRecNo
ENDIF




FUNCTION _LoadQuota     && Carga las cuotas de la factura.
SELECT tmpcuocomp
ZAP
SELECT cuotas_c
IF SEEK(STR(m.tipodocu,1)+STR(m.nrodocu,9)+STR(m.proveedor,5))
   DO WHILE m.tipodocu = cuotas_c.tipodocu .AND. m.nrodocu = cuotas_c.nrodocu .AND. m.proveedor = cuotas_c.proveedor .AND. .NOT. EOF() 
      SELECT tmpcuocomp 
      APPEND BLANK
      REPLACE tipodocu   WITH cuotas_c.tipodocu
      REPLACE nrodocu    WITH cuotas_c.nrodocu
      REPLACE tipo       WITH cuotas_c.tipo         
      REPLACE nrocuota   WITH cuotas_c.nrocuota
      REPLACE fecha      WITH cuotas_c.fecha 
      REPLACE importe    WITH cuotas_c.importe 
      REPLACE abonado    WITH cuotas_c.abonado  
      REPLACE monto_ndeb WITH cuotas_c.monto_ndeb
      REPLACE monto_ncre WITH cuotas_c.monto_ncre
      SELECT cuotas_c
      SKIP
   ENDDO
ENDIF
SELECT cabecomp


FUNCTION _brwDetail     && Examina el detalle de la factura. 
SELECT tmpdetcomp
GO TOP
BROWSE WINDOW tmpdetcomp FIELDS ;
   calc_f0 = SUBSTR(articulo,1,12)         :R:12:H="C¢digo", ;
   calc_f1 = SUBSTR(maesprod.nombre,1,40)  :R:40:H="Descripci¢n", ;
   cantidad                                :R:08:H="Cantidad"     :P="99999.99", ;
   precio                                  :R:13:H="Precio Unit." :P="999,999.9999", ;
   pdescuento                              :R:07:H="% Dcto."   :P="99.9999" ,;      
   calc_f2 = ROUND(precio * (1 - pdescuento / 100) * cantidad,0) :R:11:H=" Sub-Total"   :P="999,999,999",;
   calc_f3 = IIF(impuesto,"   S¡","   No") :R:08:H="Impuesto", ;    
   pimpuesto                               :R:06:H="% Imp."       :P="999.99" ;
   NODELETE NOAPPEND NOMODIFY
SELECT cabecomp


FUNCTION _brwQuota      && Examina la(s) cuota(s) de la factura.
ACTIVATE WINDOW tmpmarcuot 
SELECT tmpcuocomp
GO TOP
BROWSE WINDOW tmpcuocomp FIELDS ;
   calc_f1 = IIF(tipo = 1,"Entr",IIF(tipo == 2,"Cuota"," ")) :R:04:H="Tipo", ;
   nrocuota                                                  :R:03:H="N§"         :P="999", ;
   fecha                                                     :R:10:H="Fecha Vcto", ;
   importe                                                   :R:10:H="Importe"    :P="99,999,999", ;
   calc_f2 = ((importe+monto_ndeb)-(monto_ncre+abonado))     :R:10:H="Saldo"      :P="99,999,999", ;
   abonado                                                   :R:10:H="Abonado"    :P="99,999,999", ;
   monto_ndeb                                                :R:10:H="Monto Ndeb" :P="99,999,999", ;
   monto_ncre                                                :R:10:H="Monto Ncre" :P="99,999,999"  ;
   NODELETE NOAPPEND NOMODIFY  
DEACTIVATE WINDOW tmpmarcuot
SELECT cabecomp


FUNCTION _brwInvoices   && Examina facturas.
SELECT cabecomp
browse window BCompras fields ;
calc_f1 = iIF(tipodocu == 1,"FCO",iIF(tipodocu == 2,"FCR",iIF(tipodocu == 3, "VII", iIF(tipodocu == 4, "CVE", iIF(tipodocu ==  5, "CCR", " "))))) :r:03:h="", ;
nrodocu :r:09:p="9,999,999":h="N§ Doc.", ;
fechadocu :r:10:h="Fecha Doc.", ;
monto_fact :r:11:p="999,999,999":h="Monto Fact.", ;
calc_f2 = ((monto_fact+monto_ndeb)-(monto_ncre+monto_pago)) :r:11:p="999,999,999":h="   Saldo", ;
calc_f3 = proveedo.nombre :r:51:h="Proveedor", ;
calc_f4 = iIF(tipodocu == 1,"FCO",iIF(tipodocu == 2,"FCR",iIF(tipodocu == 3, "VII", iIF(tipodocu == 4, "CVE", iIF(tipodocu ==  5, "CCR", " "))))) :r:03:h="", ;
calc_f5 = nrodocu :r:09:p="9,999,999":h="N§ Doc.", ;
calc_f6 = monto_fact :r:11:p="999,999,999":h="Monto Fact.", ;
monto_pago :r:11:p="999,999,999":h="Monto Cobr.", ;
monto_ndeb :r:11:p="999,999,999":h="Monto N.Deb", ;
monto_ncre :r:11:p="999,999,999":h="Monto N.Cre", ;
calc_f7 = ((monto_fact+monto_ndeb)-(monto_ncre+monto_pago)) :r:11:p="999,999,999":h="   Saldo", ;
proveedor :r:09:p="99,999":h="C¢d.Cli"


FUNCTION _cmpSwitch     && Buscar.
PUSH KEY CLEAR
DO CASE
   CASE LOWER(ORDER()) = "indice1"
      DO cmpbusc1.spr
      POP KEY
   CASE LOWER(ORDER()) = "indice2"
      DO cmpbusc2.spr
      POP KEY
   CASE LOWER(ORDER()) = "indice3"
      DO cmpbusc3.spr
      POP KEY
ENDCASE


FUNCTION _InvoiceFoot
PRIVATE pcCurrSelect, pcCurrOrder, pnCurrRecord
	
pcCurrSelect = SELECT()
pcCurrOrder  = ORDER()
pnCurrRecord = IIF(EOF(),0,RECNO())

SELECT tmpdetcomp

STORE 0 TO pnGravada, pnExenta, pnImpuesto, pnSubTotal, m.monto_fact
GO TOP
SCAN
   DO CASE
      CASE impuesto .AND. pimpuesto > 0 .AND. pimpuesto < 10
         pnGravada = pnGravada + ROUND(precio * (1 - pdescuento / 100) * cantidad,0) * (pimpuesto * 10 / 100)
         pnExenta  = pnExenta + ROUND(precio * (1 - pdescuento / 100) * cantidad,0) * (1 - (pimpuesto * 10 / 100))
      CASE impuesto .AND. pimpuesto = 10
         pnGravada = pnGravada + ROUND(precio * (1 - pdescuento / 100) * cantidad,0)            
      CASE .NOT. impuesto .AND. pimpuesto = 0
         pnExenta = pnExenta + ROUND(precio * (1 - pdescuento / 100) * cantidad,0)
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
   COLOR N/W

SELECT (pcCurrSelect)
SET ORDER TO TAG (pcCurrOrder)
IF pnCurrRecord # 0
   GOTO RECORD pnCurrRecord
ENDIF
RELEASE pcCurrSelect, pcCurrOrder, pnCurrRecord
