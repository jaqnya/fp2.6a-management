CLEAR ALL
CLEAR
plAdding = .T.
plEditing = .F.

PRIVATE m.tipodocu, pnGravada, pnExenta, pnImpuesto, pnSubTotal, m.monto_fact, pnTipoDocu, plClearRead, plCancel
STORE 0 TO pnGravada, pnExenta, pnImpuesto, pnSubTotal, m.porcdesc, m.importdesc, m.monto_fact, pnTipoDocu
STORE .F. TO plClearRead, plCancel

*-- MS-DOS Definiciones de ventanas.
IF NOT WEXIST("tmpdetcomp")
   DEFINE WINDOW tmpdetcomp ;
      FROM 06,00 ;
      TO 18,79 ;
      TITLE "DETALLE" ;
      NOFLOAT ;
      CLOSE ;
      NOSHADOW ;
      ZOOM ;
      NOMINIMIZE ;
      SYSTEM ;
      COLOR SCHEME 16
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
   SET ORDER TO TAG indice2
ELSE
   SELECT 0
   USE (LOCFILE("maesprod.dbf", "DBF", "¨ D¢nde est  MAESPROD.DBF ?")) ;
      AGAIN ALIAS maesprod ;
      ORDER TAG indice2
ENDIF

GO TOP
SET RELATION TO maesprod.familia    INTO familias ADDITIVE
SET RELATION TO maesprod.rubro      INTO rubros1  ADDITIVE
SET RELATION TO maesprod.subrubro   INTO rubros2  ADDITIVE
SET RELATION TO maesprod.marca      INTO marcas   ADDITIVE
SET RELATION TO maesprod.unidad     INTO unidad   ADDITIVE
SET RELATION TO maesprod.procedenci INTO proceden ADDITIVE
SET RELATION TO maesprod.proveedor  INTO proveedo ADDITIVE

SELECT 0
temp01 = "tm"+RIGHT(SYS(3),6)+".dbf"
CREATE TABLE &temp01 (tipodocu   n(01), ;
                      nrodocu    n(09), ;
                      proveedor  n(05), ;
                      articulo   c(15), ;
                      cantidad   n(09,2), ;
                      precio     n(11,2), ;
                      impuesto   l(01), ;
                      pimpuesto  n(06,2))
                      
USE &temp01 ALIAS tmpdetcomp EXCLUSIVE
INDEX ON STR(tipodocu,1)+STR(nrodocu,9) TAG indice1
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
SET RELATION TO cabecomp.proveedor INTO proveedo ADDITIVE

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

IF USED("otros")
   SELECT otros
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("otros.dbf", "DBF", "¨ D¢nde est  OTROS.DBF ?")) ;
      AGAIN ALIAS otros ;
      ORDER TAG 0
ENDIF


DO _fmtInvoice
@ 02,13 GET m.tipodocu ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN plAdding .AND. _ConfirmOn() ;
   VALID _vldTipoDocu() ;
   COLOR SCHEME 13
@ 04,13 GET m.proveedor ;
   SIZE 1,5 ;
   DEFAULT 0 ;
   PICTURE "99999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldProveedor() ;
   COLOR SCHEME 13
@ 02,45 GET m.nrodocu ;
   SIZE 1,9 ;
   DEFAULT 0 ;
   PICTURE "999999999" ;
   WHEN plAdding ;
   VALID _vldNroDocu() ;
   COLOR SCHEME 13
@ 02,68 GET m.fechadocu ;
   SIZE 1,10 ;
   DEFAULT DTOC(DATE()) ;
   PICTURE "99/99/9999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldFechaDocu() ;
   COLOR SCHEME 13
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
   COLOR SCHEME 13   
@ 20,68 GET m.importdesc ;
   SIZE 1,11 ;
   DEFAULT 0 ;
   PICTURE "999,999,999" ;
   WHEN (plAdding .OR. plEditing) .AND. m.porcdesc = 0 .AND. _ConfirmOff(); 
   VALID _vldImportDesc() ;
   COLOR SCHEME 13   
@ 21,68 SAY pnImpuesto ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W     
@ 22,68 SAY m.monto_fact ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

READ CYCLE ;
   VALID _vldReadCycle()


*-- MS-DOS Procedimientos y funciones de soporte.

FUNCTION _fmtInvoice     &&  Dibuja el formato de la factura y las etiquetas.
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
               DO _brwLoadDetail
               RETURN .T.
            ELSE
               WAIT WINDOW "­ FECHA INVALIDA !"
               RETURN .F.
            ENDIF 
         CASE pnMes = 2
            IF MOD(pnAnyo,4) # 0
               IF pnDia <= 28
                  DO _brwLoadDetail
                  RETURN .T.
               ELSE
                  WAIT WINDOW "­ FECHA INVALIDA !"
                  RETURN .F.
               ENDIF
            ELSE
               IF MOD(pnAnyo,100) = 0 .AND. MOD(pnAnyo,400) # 0
                  IF pnDia <= 28
                     DO _brwLoadDetail
                     RETURN .T.
                  ENDIF
               ELSE
                  IF pnDia <= 29
                     DO _brwLoadDetail
                     RETURN .T.
                  ELSE
                     WAIT WINDOW "­ FECHA INVALIDA !"
                     RETURN .F.
                  ENDIF
               ENDIF 
            ENDIF
         CASE INLIST(pnMes, 4, 6, 9, 11)
            IF pnDia <= 30
               DO _brwLoadDetail
               RETURN .T.
            ELSE
               WAIT WINDOW "­ FECHA INVALIDA !"
               RETURN .F.
            ENDIF
            DO _brwLoadDetail
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
      DO cuot_pop.spr WITH m.tipodocu, plClearRead, plCancel
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
      DO _InvoiceFoot
      DO cuot_pop.spr WITH m.tipodocu, plClearRead, plCancel
      IF plClearRead .OR. plCancel
         CLEAR READ
         IF plClearRead 
            WAIT WINDOW "­ LA COMPRA FUE GRABADA !" TIMEOUT 0.75
         ENDIF
      ENDIF
   ENDIF
ENDIF


FUNCTION _vldReadCycle
IF LASTKEY() = 27 
   IF LOWER(SYS(18)) = "porcdesc" .OR. LOWER(SYS(18)) = "importdesc"
      _CUROBJ = OBJNUM(m.porcdesc)      
      RETURN .F.
   ENDIF
ENDIF


FUNCTION _ShowHeader
@ 02,13 GET m.tipodocu ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN plAdding .AND. _ConfirmOn() ;
   VALID _vldTipoDocu() ;
   COLOR SCHEME 13
@ 04,13 GET m.proveedor ;
   SIZE 1,5 ;
   DEFAULT 0 ;
   PICTURE "99999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldProveedor() ;
   COLOR SCHEME 13
@ 02,45 GET m.nrodocu ;
   SIZE 1,9 ;
   DEFAULT 0 ;
   PICTURE "999999999" ;
   WHEN plAdding ;
   VALID _vldNroDocu() ;
   COLOR SCHEME 13
@ 02,68 GET m.fechadocu ;
   SIZE 1,10 ;
   DEFAULT DTOC(DATE()) ;
   PICTURE "99/99/9999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldFechaDocu() ;
   COLOR SCHEME 13



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
	
SELECT maesprod
SET ORDER TO TAG indice1 OF maesprod.cdx
IF SEEK(pnCodigo)	
   IF maesprod.pimpuesto > 10
      WAIT WINDOW "­ PORCENTAJE DE IMPUESTO INVALIDO !"
      RETURN .F.
   ENDIF
   IF .NOT. (ALLTRIM(maesprod.codigo) = "99015" .OR. ALLTRIM(maesprod.codigo) = "99016")
      IF EMPTY(tmpdetcomp.precio)
         REPLACE tmpdetcomp.precio    WITH maesprod.pcostog
      ENDIF
   ENDIF
   REPLACE tmpdetcomp.impuesto  WITH maesprod.impuesto
   REPLACE tmpdetcomp.pimpuesto WITH maesprod.pimpuesto

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
      INSERT INTO tmpdetcomp (tipodocu, nrodocu, proveedor, articulo, cantidad, precio, impuesto, pimpuesto) ;
         VALUES            (0, 0, 0, " ", 0, 0, .F., 0)
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
   INSERT INTO tmpdetcomp (tipodocu, nrodocu, proveedor, articulo, cantidad, precio, impuesto, pimpuesto) ;
      VALUES            (0, 0, 0, " ", 0, 0, .F., 0)
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
   INSERT INTO tmpdetcomp (tipodocu, nrodocu, proveedor, articulo, cantidad, precio, impuesto, pimpuesto) ;
      VALUES            (0, 0, 0, " ", 0, 0, .F., 0)
ENDIF

ON KEY LABEL "F8" DO _DeleteLine

DO WHILE LASTKEY() # 27
   @ 19,12 CLEAR TO 21,41
   GO BOTTOM
   BROWSE WINDOW tmpdetcomp FIELDS ;
      articulo                                  :15:H="C¢digo"                             :V = _vldCodigo(articulo):F, ;
      calc_f1 = maesprod.nombre               :R:37:H="Descripci¢n"  :W = .F. , ;
      cantidad                                  :08:H="Cantidad"     :P="99999.99"         :V = _vldCantidad(cantidad):F, ;
      precio                                    :13:H="Precio Unit." :P="@K 99,999,999.99" :V = _vldPrecio(precio):F, ;
      calc_f2 = ROUND(precio*cantidad,0)        :11:H=" Sub-Total"   :P="999,999,999" :W = .F. ,;
      calc_f3 = maesprod.nombre               :R:37:H="Descripci¢n"  :W = .F. , ;
      calc_f4 = IIF(impuesto,"   S¡","   No") :R:08:H="Impuesto"     :W = .F. , ;    
      pimpuesto                               :R:06:H="% Imp."       :P="999.99"           :V = _vldAddNewLine():F  ;
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
pnRow    = 6
pnColumn = 2

SELECT tmpdetcomp
SCAN FOR RECNO() <= 11 .AND. .NOT. EMPTY(articulo)
   @ pnRow + RECNO(), pnColumn      SAY maesprod.nombre                                    COLOR N/W
   @ pnRow + RECNO(), pnColumn + 42 SAY cantidad                   PICTURE "999,999.99"    COLOR N/W
   @ pnRow + RECNO(), pnColumn + 53 SAY precio                     PICTURE "99,999,999.99" COLOR N/W
   @ pnRow + RECNO(), pnColumn + 67 SAY ROUND(precio * cantidad,0) PICTURE "99,999,999"    COLOR N/W
ENDSCAN

SELECT (pcCurrSelect)
SET ORDER TO TAG (pcCurrOrder)
IF pnCurrRecord # 0
   GOTO RECORD pnCurrRecord
ENDIF


FUNCTION _ConfirmOff
SET CONFIRM OFF

FUNCTION _ConfirmOn
SET CONFIRM ON
