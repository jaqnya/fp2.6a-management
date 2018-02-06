PRIVATE pcMaesItem

DO WHILE .T.
   WAIT WINDOW "¨ DESEA UTILIZAR CODIGO: (O)RIGINAL O (A)LTERNATIVO ?" TO pcWhatCode
   IF UPPER(pcWhatCode) = "O"
      pcMpdOrder = "INDICE7"
      EXIT DO
   ELSE
      IF UPPER(pcWhatCode) = "A"
         pcMpdOrder = "INDICE6"
         EXIT DO 
      ENDIF
   ENDIF
ENDDO

DO _fmtInvoice
m.fechadocu = DTOC(DATE()) 
@ 02,13 GET m.tipodocu ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN plAdding .AND. _ConfirmOn() ;
   VALID _vldTipoDocu() ;
   COLOR SCHEME 1
@ 04,13 GET m.proveedor ;
   SIZE 1,5 ;
   DEFAULT 0 ;
   PICTURE "99999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldProveedor() ;
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
@ 06,13 GET m.moneda ;
   SIZE 1,4 ;
   DEFAULT 0 ;
   PICTURE "9999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldMoneda() ;
   COLOR SCHEME 1
@ 06,68 GET m.tipocambio ;
   SIZE 1,10 ;
   DEFAULT 0 ;
   PICTURE "999,999.99" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldTipoCambio() ;
   COLOR SCHEME 1
@ 19,68 SAY pnSubTotal ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W
@ 20,46 GET m.porcdesc ;
   SIZE 1,8 ;
   DEFAULT 0 ;
   PICTURE "999.9999" ;
   WHEN (plAdding .OR. plEditing) .AND. _ConfirmOff();
   VALID _vldPorcDesc() ;
   COLOR SCHEME 1   
@ 20,68 GET m.importdesc ;
   SIZE 1,11 ;
   DEFAULT 0 ;
   PICTURE "999,999,999" ;
   WHEN (plAdding .OR. plEditing) .AND. m.porcdesc = 0 .AND. _ConfirmOff(); 
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



FUNCTION __fmtInvoice     &&  Dibuja el formato de la factura y las etiquetas.
@ 01,00 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 02,00 SAY "³ Documento:                             N§:              F.Compra:            ³"
@ 03,00 SAY "³                                                                              ³"
@ 04,00 SAY "³ Proveedor:                                                                   ³"
@ 05,00 SAY "³                                                                              ³"
@ 06,00 SAY "ÃÄDescripci¢nÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄCantidadÄÂÄPrecio Un.ÄÄÂÄImporteÄÄ´"
@ 07,00 SAY "³                                          ³          ³             ³          ³"
@ 08,00 SAY "³                                          ³          ³             ³          ³"
@ 09,00 SAY "³                                          ³          ³             ³          ³"
@ 10,00 SAY "³                                          ³          ³             ³          ³"
@ 11,00 SAY "³                                          ³          ³             ³          ³"
@ 12,00 SAY "³                                          ³          ³             ³          ³"
@ 13,00 SAY "³                                          ³          ³             ³          ³"
@ 14,00 SAY "³                                          ³          ³             ³          ³"
@ 15,00 SAY "³                                          ³          ³             ³          ³"
@ 16,00 SAY "³                                          ³          ³             ³          ³"
@ 17,00 SAY "³                                          ³          ³             ³          ³"
@ 18,00 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´"
@ 19,00 SAY "³ Rubro...:                                            SUB-TOTALES:            ³"
@ 20,00 SAY "³ Gravado.:                                            % DESCUENTO:            ³"
@ 21,00 SAY "³ S.Actual:                                                 I.V.A.:            ³"
@ 22,00 SAY "³                                                    TOTAL GENERAL:            ³"
@ 23,00 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"


FUNCTION _vldTipoDocu
IF INLIST(LASTKEY(), 5, 19))
   RETURN .F.
ENDIF
IF m.tipodocu > 4 
   @ 02,16 SAY REPLICATE(CHR(32),22) ;
      SIZE 1,22 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ EL TIPO DE DOCUMENTO DE COMPRA DEBE SER: 1, 2, 3 à 4 !"
   RETURN .F.
ENDIF   
IF m.tipodocu <= 0
   @ 02,16 SAY REPLICATE(CHR(32),22) ;
      SIZE 1,22 ;
      PICTURE "@!" ;
      COLOR W/N
   DO cmtipodo.spr WITH "m.tipodocu", 0, .F.
ENDIF
IF m.tipodocu = 0
   RETURN .F.
ENDIF
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


FUNCTION _vldNroDocu
IF INLIST(LASTKEY(), 5, 19))
   RETURN .T.
ENDIF
IF m.nrodocu <= 0
   WAIT WINDOW "­ EL N§ DEL DOCUMENTO DEBE SER MAYOR QUE CERO !"
   RETURN .F.
ENDIF

PRIVATE pcSelect, pcOrder, pnRecNo

pcSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT cabecomp
SET ORDER TO TAG indice1 OF cabecomp.cdx
IF SEEK(STR(m.tipodocu,1)+STR(m.nrodocu,9)+STR(m.proveedor,5))
   WAIT WINDOW "­ ESTA COMPRA YA HA SIDO CARGADA !"
   SELECT (pcSelect)
   SET ORDER TO TAG (pcOrder)
   IF pnRecNo # 0
      GOTO RECORD pnRecNo
   ENDIF
   RELEASE pcSelect, pcOrder, pnRecNo
   RETURN .F.
ENDIF
SELECT (pcSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo # 0
   GOTO RECORD pnRecNo
ENDIF
RELEASE pcSelect, pcOrder, pnRecNo


FUNCTION _vldFechaDocu
IF INLIST(LASTKEY(), 5, 19))
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
*              DO _brwLoadDetail
               RETURN .T.
            ELSE
               WAIT WINDOW "­ FECHA INVALIDA !"
               RETURN .F.
            ENDIF 
         CASE pnMes = 2
            IF MOD(pnAnyo,4) # 0
               IF pnDia <= 28
*                 DO _brwLoadDetail
                  RETURN .T.
               ELSE
                  WAIT WINDOW "­ FECHA INVALIDA !"
                  RETURN .F.
               ENDIF
            ELSE
               IF MOD(pnAnyo,100) = 0 .AND. MOD(pnAnyo,400) # 0
                  IF pnDia <= 28
*                    DO _brwLoadDetail
                     RETURN .T.
                  ENDIF
               ELSE
                  IF pnDia <= 29
*                    DO _brwLoadDetail
                     RETURN .T.
                  ELSE
                     WAIT WINDOW "­ FECHA INVALIDA !"
                     RETURN .F.
                  ENDIF
               ENDIF 
            ENDIF
         CASE INLIST(pnMes, 4, 6, 9, 11)
            IF pnDia <= 30
*              DO _brwLoadDetail
               RETURN .T.
            ELSE
               WAIT WINDOW "­ FECHA INVALIDA !"
               RETURN .F.
            ENDIF
*           DO _brwLoadDetail
            RETURN .T.
      ENDCASE
   ENDIF
ENDIF


FUNCTION _vldProveedor
PRIVATE pcSelect, pcOrder, pnRecNo

pcSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

IF INLIST(LASTKEY(), 5, 19))
   RELEASE pcSelect, pcOrder, pnRecNo
   RETURN .T.
ENDIF

IF m.proveedor <= 0
   @ 04,20 SAY REPLICATE(CHR(32),40) ;
      SIZE 1,40 ;
      PICTURE "@!" ;
      COLOR W/N
   DO prov_pop.spr WITH "m.proveedor", 0, .F.
ENDIF

IF m.proveedor = 0
   RETURN .F.
ENDIF

SELECT proveedo
SET ORDER TO TAG indice1 OF proveedo.cdx
IF SEEK(m.proveedor)
   @ 04,20 SAY PADR(ALLTRIM(proveedo.nombre), 40, CHR(32)) ;
      SIZE 1,40 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 04,20 SAY REPLICATE(CHR(32),40) ;
      SIZE 1,40 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE PROVEEDOR INEXISTENTE !"
   DO prov_pop.spr WITH "m.proveedor", 0, .F.
   SHOW GETS
   IF SEEK(m.proveedor)
      @ 04,20 SAY PADR(ALLTRIM(proveedo.nombre), 40, CHR(32)) ;
         SIZE 1,40 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 04,20 SAY REPLICATE(CHR(32),40) ;
         SIZE 1,40 ;
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

SELECT (pcSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo # 0
   GOTO RECORD pnRecNo
ENDIF
RELEASE pcSelect, pcOrder, pnRecNo


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
      IF LASTKEY() # 3 .OR. LASTKEY() # 13
         _CUROBJ = OBJNUM(m.porcdesc)
      ENDIF
   ELSE
      _CUROBJ = OBJNUM(m.importdesc)
   ENDIF
ENDIF

IF INLIST(LASTKEY(), 5, 18, 19)
   RETURN .F.
ELSE   
   IF LASTKEY() = 13 .AND. .NOT. EMPTY(m.porcdesc)
      DO _InvoiceFoot
      DO cuot_po2.spr WITH m.tipodocu, plClearRead, plCancel
      IF plClearRead .OR. plCancel
         CLEAR READ
         IF plClearRead 
            WAIT WINDOW "­ LA COMPRA FUE GRABADA !" TIMEOUT 0.75
         ENDIF
      ENDIF
   ENDIF
ENDIF


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
      DO cuot_po2.spr WITH m.tipodocu, plClearRead, plCancel
      IF plClearRead .OR. plCancel
         CLEAR READ
         IF plClearRead 
            WAIT WINDOW "­ LA COMPRA FUE GRABADA !" TIMEOUT 0.75
         ENDIF
      ENDIF
   ENDIF
ENDIF


FUNCTION _ShowHeader
@ 02,13 GET m.tipodocu ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN plAdding .AND. _ConfirmOn() ;
   VALID _vldTipoDocu() ;
   COLOR SCHEME 1
@ 04,13 GET m.proveedor ;
   SIZE 1,5 ;
   DEFAULT 0 ;
   PICTURE "99999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldProveedor() ;
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



FUNCTION _vldCodigo
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
   DO maes_pop.spr WITH "tmpdetcomp.articulo", "", .T.
   IF LASTKEY() # 27 .AND. .NOT. EMPTY(tmpdetcomp.articulo)
      IF maesprod.pimpuesto > 10
         WAIT WINDOW "­ PORCENTAJE DE IMPUESTO INVALIDO !"
         RETURN .F.
      ENDIF
      IF .NOT. (ALLTRIM(maesprod.codigo) = "99015" .OR. ALLTRIM(maesprod.codigo) = "99016")
         IF EMPTY(tmpdetcomp.precio)
            IF m.moneda = 1     && Guaran¡es.
               REPLACE tmpdetcomp.precio    WITH maesprod.pcostog
            ELSE
               IF m.moneda = 2     && D¢lares Americanos.
                  REPLACE tmpdetcomp.precio    WITH maesprod.pcostod
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      REPLACE tmpdetcomp.impuesto  WITH maesprod.impuesto
      REPLACE tmpdetcomp.pimpuesto WITH maesprod.pimpuesto
      REPLACE tmpdetcomp.tipoc     WITH "A"
      RETURN 
   ELSE
      RETURN .F.
   ENDIF
ENDIF

SELECT maesprod
IF tmpdetcomp.tipoc # "A"
   SET ORDER TO TAG &pcMpdOrder OF maesprod.cdx
ELSE
   SET ORDER TO TAG indice1 OF maesprod.cdx
ENDIF
IF SEEK(pnCodigo)
   SET ORDER TO TAG indice1 OF maesprod.cdx
   REPLACE tmpdetcomp.articulo WITH maesprod.codigo
   IF maesprod.pimpuesto > 10
      WAIT WINDOW "­ PORCENTAJE DE IMPUESTO INVALIDO !"
      RETURN .F.
   ENDIF
   IF .NOT. (ALLTRIM(maesprod.codigo) = "99015" .OR. ALLTRIM(maesprod.codigo) = "99016")
      IF EMPTY(tmpdetcomp.precio)
         IF m.moneda = 1     && Guaran¡es.
            REPLACE tmpdetcomp.precio    WITH maesprod.pcostog
         ELSE
            IF m.moneda = 2     && D¢lares Americanos.
               REPLACE tmpdetcomp.precio    WITH maesprod.pcostod
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   REPLACE tmpdetcomp.impuesto  WITH maesprod.impuesto
   REPLACE tmpdetcomp.pimpuesto WITH maesprod.pimpuesto
   REPLACE tmpdetcomp.tipoc     WITH "A"
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


FUNCTION _vldAddNewLine 
IF LASTKEY() = 13     && Tecla ENTER presionada, agregar l¡nea de detalle.
   IF RECNO() = RECCOUNT()
      KEYBOARD "{CTRL+W}"      
      INSERT INTO tmpdetcomp (tipodocu, nrodocu, proveedor, articulo, cantidad, precio, pdescuento, impuesto, pimpuesto) ;
         VALUES            (0, 0, 0, " ", 0, 0, 0, .F., 0)
   ENDIF
ENDIF
DO _InvoiceFoot   


FUNCTION _DeleteLine
PRIVATE pcCurrSelect, pcCurrOrder
	
pcCurrSelect = SELECT()
pcCurrOrder  = ORDER()

SELECT tmpdetcomp
DELETE 
PACK
IF RECCOUNT() = 0
   INSERT INTO tmpdetcomp (tipodocu, nrodocu, proveedor, articulo, cantidad, precio, pdescuento, impuesto, pimpuesto) ;
      VALUES            (0, 0, 0, " ", 0, 0, 0, .F., 0)
ENDIF

SELECT (pcCurrSelect)
SET ORDER TO TAG (pcCurrOrder)
DO _InvoiceFoot


FUNCTION _brwLoadDetail
PRIVATE pcCurrSelect, pcCurrOrder, pnCurrRecord
	
pcCurrSelect = SELECT()
pcCurrOrder  = ORDER()
pnCurrRecord = IIF(EOF(),0,RECNO())

SELECT tmpdetcomp

IF RECCOUNT() = 0
   INSERT INTO tmpdetcomp (tipodocu, nrodocu, proveedor, articulo, cantidad, precio, pdescuento, impuesto, pimpuesto) ;
      VALUES            (0, 0, 0, " ", 0, 0, 0, .F., 0)
ENDIF

ON KEY LABEL "F8" DO _DeleteLine

DO WHILE LASTKEY() # 27
   @ 19,12 CLEAR TO 21,41
   
   @ 09,01 CLEAR TO 17,40     && Descripci¢n.
   @ 09,42 CLEAR TO 17,51     && Cantidad.
   @ 09,53 CLEAR TO 17,67     && Precio Unit.
   @ 09,69 CLEAR TO 17,78     && Importe.

   GO BOTTOM
   BROWSE WINDOW tmpdetcomp FIELDS ;
      articulo                                  :14:H="C¢digo"                               :V = _vldCodigo(articulo):F, ;
      calc_f1 = SUBSTR(maesprod.nombre,1,36)    :R:36:H="Descripci¢n"  :W = .F. , ;
      cantidad                                  :08:H="Cantidad"     :P="99999.99"           :V = _vldCantidad(cantidad):F, ;
      precio                                    :15:H="Precio Unit." :P="@K 99,999,999.9999" :V = _vldPrecio(precio):F, ;
      pdescuento                                :07:H="% Dcto."   :P="99.9999" ,;      
      calc_f2 = ROUND(precio * (1 - pdescuento / 100) * cantidad,0) :11:H=" Sub-Total"   :P="999,999,999" :W = .F. ,;
      calc_f3 = SUBSTR(maesprod.nombre,1,40)    :R:40:H="Descripci¢n"  :W = .F. , ;
      calc_f4 = IIF(impuesto,"   S¡","   No") :R:08:H="Impuesto"     :W = .F. , ;    
      pimpuesto                               :R:06:H="% Imp."       :P="999.99"             :V = _vldAddNewLine():F  ;
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
@ 21,68 SAY pnImpuesto ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W
@ 22,68 SAY m.monto_fact ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W
SHOW GETS

SELECT (pcCurrSelect)
SET ORDER TO TAG (pcCurrOrder)
IF pnCurrRecord # 0
   GOTO RECORD pnCurrRecord
ENDIF
RELEASE pcCurrSelect, pcCurrOrder, pnCurrRecord


FUNCTION _printDetail
PRIVATE pcSelect, pcOrder, pnRecNo, pnRow, pnColumn

pcSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())
pnRow    = 8
pnColumn = 2

SELECT tmpdetcomp
SCAN FOR RECNO() <= 9 .AND. .NOT. EMPTY(articulo)
   @ pnRow + RECNO(), pnColumn      SAY SUBSTR(maesprod.nombre,1,39)                                                   COLOR N/W
   @ pnRow + RECNO(), pnColumn + 40 SAY cantidad                                             PICTURE "999,999.99"      COLOR N/W
   @ pnRow + RECNO(), pnColumn + 51 SAY precio                                               PICTURE "99,999,999.9999" COLOR N/W
   @ pnRow + RECNO(), pnColumn + 67 SAY ROUND(precio * (1 - pdescuento / 100) * cantidad, 0) PICTURE "99,999,999"      COLOR N/W
ENDSCAN

SELECT (pcSelect)
SET ORDER TO TAG (pcOrder)
IF pnCurrRecord # 0
   GOTO RECORD pnRecNo
ENDIF


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
   @ 06,20 SAY REPLICATE(CHR(32),30) ;
      SIZE 1,30 ;
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
   @ 06,20 SAY PADR(ALLTRIM(monedas.nombre), 30, CHR(32)) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 06,20 SAY REPLICATE(CHR(32),30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE MONEDA INEXISTENTE !"
   DO mone_pop.spr WITH "m.moneda", 0, .F.
   SHOW GETS
   IF SEEK(m.moneda)
      @ 06,20 SAY PADR(ALLTRIM(monedas.nombre), 30, CHR(32)) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 06,20 SAY REPLICATE(CHR(32),30) ;
         SIZE 1,30 ;
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

IF EMPTY(m.tipocambio) .AND. m.moneda # 1
   m.tipocambio = control.tipocambio
ENDIF

SELECT (pcSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo # 0
   GOTO RECORD pnRecNo
ENDIF
RELEASE pcSelect, pcOrder, pnRecNo


FUNCTION _vldTipoCambio
IF INLIST(LASTKEY(), 5, 19))
   RETURN .T.
ENDIF
IF m.tipocambio < 0
   WAIT WINDOW "­ EL TIPO DE CAMBIO DEBE SER MAYOR O IGUAL QUE CERO !"
   RETURN .F.
ENDIF
DO _brwLoadDetail