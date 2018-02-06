*:*********************************************************************
*:
*: Archivo de Procedimiento: MKCOMPRA.PRG
*:
*:                  Sistema: Integrado de Gesti¢n Financiera.
*:              Sub-Sistema: Agrega o Modifica una Compra.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 28/02/2004
*:
*:*********************************************************************
PARAMETER pcWhatToDo

PUSH KEY CLEAR

*-- Variables de la tabla.
PRIVATE m.tipodocu, m.nrodocu, m.fechadocu, m.proveedor, m.moneda, m.tipocambio, m.porcdesc, m.importdesc, m.descuento, m.monto_fact, m.monto_ndeb, m.monto_ncre, m.monto_pago, m.importac

*-- Variables para c lculos del programa.
PRIVATE plAdding, plEditing, plDeleting, plpnGravada, pnExenta, pnImpuesto, msubtotal, pcString1, pcString2, pcMoneda, pnDescGrav, pnDescExen, pnSubTota1, pcWhatCode
                                                                                    
IF pcWhatToDo = "Add"
   SELECT cabecomp
   SCATTER MEMVAR MEMO BLANK
   
ELSE
   IF pcWhatToDo = "Edit"
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
   	     WAIT WINDOW "­ COMPRA CON MOVIMIENTO(S) ASOCIADO(S), IMPOSIBLE MODIFICARLA !"
   	     POP KEY
   	     RETURN
   	  ENDIF

      IF cabecomp.fechadocu <> DATE() THEN
         WAIT "LOS REGISTROS DE ESTA TABLA NO PUEDEN SER MODIFICADOS !" WINDOW NOWAIT
         POP KEY 
         RETURN
      ENDIF

      SELECT cabecomp
      SCATTER MEMVAR MEMO
   ENDIF
ENDIF

*-- Inicializaci¢n de variables.
STORE 0 TO pnGravada, pnExenta, pnImpuesto, msubtotal

IF pcWhatToDo = "Add"
   plAdding    = .T.
   plEditing   = .F.
   plDeleting  = .F.
   m.fechadocu = DTOC(DATE()) 
   m.moneda    = 1

   SELECT tmpdetcomp
   ZAP
ELSE
   IF pcWhatToDo = "Edit"
      plAdding    = .F.
      plEditing   = .T.
      plDeleting  = .F.
      m.fechadocu = DTOC(m.fechadocu) 
   ENDIF
ENDIF  

*-- Determina que c¢digo se utilizar  para la carga del detalle de la compra.
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

SELECT cabecomp

DO _fmtInvoice

IF pcWhatToDo = "Edit"
   DO _RefreshInvoice
ENDIF

@ 02,13 GET m.tipodocu ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN plAdding ;
   VALID _vldTipoDocu() ;
   COLOR SCHEME 1

@ 04,13 GET m.proveedor ;
   SIZE 1,5 ;
   DEFAULT 0 ;
   PICTURE "99999" ;
   WHEN plAdding ;
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

IF plEditing
   m.fechadocu = DTOC(m.fechadocu)
ENDIF

@ 06,13 GET m.moneda ;
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
   WHEN (plAdding .OR. plEditing) .AND. m.moneda <> 1 ;
   VALID _vldTipoCambio() ;
   COLOR SCHEME 1

@ 19,65 SAY msubtotal ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR N/W

@ 20,43 GET m.porcdesc ;
   SIZE 1,8 ;
   DEFAULT 0 ;
   PICTURE "999.9999" ;
   WHEN (plAdding .OR. plEditing) ;
   VALID _vldPorcDesc() ;
   COLOR SCHEME 1   

@ 20,65 GET m.importdesc ;
   SIZE 1,14 ;
   DEFAULT 0 ;
   PICTURE "999,999,999.99" ;
   WHEN (plAdding .OR. plEditing) .AND. m.porcdesc = 0 ; 
   VALID _vldImportDesc() ;
   COLOR SCHEME 1   

@ 21,65 SAY pnImpuesto ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR N/W     

@ 22,65 SAY m.monto_fact ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR B/W

READ CYCLE ;
   MODAL ;
   VALID _vldReadCycle() ;
   COLOR , W+/BG 

*!*********************************************************************
*!
*!      Funci¢n: _vldReadCycle
*!
*!  Llamado por: MKCOMPRA.PRG    
*!
*!  Descripci¢n: Valida la terminaci¢n del comando READ.
*!
*!*********************************************************************
FUNCTION _vldReadCycle
IF LASTKEY() = 27 
   IF LOWER(SYS(18)) = "porcdesc" .OR. LOWER(SYS(18)) = "importdesc"
      _CUROBJ = OBJNUM(m.porcdesc)      
      RETURN .F.
   ENDIF
ENDIF

**-------------------------------------------------------------------**
**                            ENCABEZADO                             **
**-------------------------------------------------------------------**

*!*********************************************************************
*!
*!      Funci¢n: _vldTipoDocu
*!
*!  Llamado por: MKCOMPRA.PRG    
*!
*!  Descripci¢n: Validaci¢n del campo tipo de documento.
*!
*!*********************************************************************
FUNCTION _vldTipoDocu
IF INLIST(LASTKEY(), 5, 19, 28, 127)
   RETURN .F.
ENDIF

IF glLegal
   IF m.tipodocu > 4 
      @ 02,16 SAY REPLICATE(CHR(32), 22) ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
      WAIT WINDOW "­ EL TIPO DE DOCUMENTO DEBE SER DEL 1 AL 4 !"
      RETURN .F.
   ENDIF   
ELSE
   IF m.tipodocu > 8 
      @ 02,16 SAY REPLICATE(CHR(32), 23) ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
      WAIT WINDOW "­ EL TIPO DE DOCUMENTO DEBE SER DEL 1 AL 8 !"
      RETURN .F.
   ENDIF   
ENDIF


IF m.tipodocu <= 0
   @ 02,16 SAY REPLICATE(CHR(32), 23) ;
      SIZE 1,23 ;
      PICTURE "@!" ;
      COLOR W/N
   DO tipodoc2.spr WITH "m.tipodocu", 0, .F.
ENDIF

IF m.tipodocu = 0
   RETURN .F.
ENDIF

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

*!*********************************************************************
*!
*!      Funci¢n: _vldProveedor
*!
*!  Llamado por: MKCOMPRA.PRG                
*!
*!  Descripci¢n: Validaci¢n del campo m.proveedor
*!
*!*********************************************************************
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
      IF pnRecNo <> 0
         GOTO RECORD pnRecNo
      ENDIF
      RELEASE pcSelect, pcOrder, pnRecNo
      RETURN .F.
   ENDIF
ENDIF

SELECT (pcSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldNroDocu
*!
*!  Llamado por: MKCOMPRA.PRG               
*!
*!  Descripci¢n: Validaci¢n del campo n£mero de documento.    
*!
*!*********************************************************************
FUNCTION _vldNroDocu
IF INLIST(LASTKEY(), 5, 19, 27, 127)
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

*!*********************************************************************
*!
*!      Funci¢n: _vldFechaDocu
*!
*!  Llamado por: MKCOMPRA.PRG                
*!
*!  Descripci¢n: Validaci¢n del campo fecha de documento.
*!
*!*********************************************************************
FUNCTION _vldFechaDocu
IF plAdding
   IF INLIST(LASTKEY(), 5, 19, 27, 127)
      RETURN .T.
   ENDIF
ELSE
   IF plEditing
      IF INLIST(LASTKEY(), 5, 19, 28, 127)
         RETURN .F.
      ENDIF
   ENDIF
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
*!      Funci¢n: _vldMoneda
*!
*!  Llamado por: MKSELL.PRG                 
*!
*!  Descripci¢n: Validaci¢n del campo moneda. 
*!
*!*********************************************************************
FUNCTION _vldMoneda
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

IF m.moneda <= 0
   @ 06,20 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
   DO mone_pop.spr WITH "m.moneda", 0, .F.
ENDIF

IF m.moneda = 0
   RETURN .F.
ENDIF

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT monedas
SET ORDER TO TAG indice1 OF monedas.cdx

IF SEEK(m.moneda)
   IF monedas.vigente
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
      WAIT WINDOW "­ CODIGO DE MONEDA NO VIGENTE !"

      SELECT (pnSelect)
      SET ORDER TO TAG (pcOrder) 
      IF pnRecNo <> 0
         GOTO RECORD pnRecNo
      ENDIF
      
      RETURN .F.
   ENDIF
ELSE
   @ 06,20 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE MONEDA INEXISTENTE !"
   DO mone_pop.spr WITH "m.moneda", 0, .F.
   SHOW GET m.moneda

   SELECT monedas
   SET ORDER TO TAG indice1 OF monedas.cdx
 
   IF SEEK(m.moneda)
      IF monedas.vigente
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
         WAIT WINDOW "­ CODIGO DE MONEDA NO VIGENTE !"

         SELECT (pnSelect)
         SET ORDER TO TAG (pcOrder) 
         IF pnRecNo <> 0
            GOTO RECORD pnRecNo
         ENDIF
         
         RETURN .F.
      ENDIF
   ELSE
      @ 06,20 SAY REPLICATE(CHR(32), 30) ;
         SIZE 1,30 ;
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

IF m.moneda = 1
   m.tipocambio = 0
   SHOW GET m.tipocambio
ELSE   
   IF EMPTY(m.tipocambio)
      m.tipocambio = control.tipocambio
   ENDIF
ENDIF

IF m.moneda > 1
   SHOW GET m.moneda  

   pcString1 = "­ HA SELECCIONADO COMPRAR EN: " + ALLTRIM(monedas.nombre) + " !"
   pcString2 = PADC("¨ ESTA SEGURO DE CONTINUAR ?  [S/N]", LEN(pcString1), CHR(32))

   DO WHILE .T.
      WAIT WINDOW pcString1 + CHR(13) + pcString2 TO pcMoneda
      IF UPPER(pcMoneda) = "S"
         EXIT DO 
      ENDIF
      IF UPPER(pcMoneda) = "N"
         @ 06,20 SAY REPLICATE(CHR(32), 30) ;
            SIZE 1,30 ;
            PICTURE "@!" ;
            COLOR W/N
         m.moneda = 1
         SHOW GET m.moneda
         _CUROBJ = OBJNUM(m.moneda)         
         RETURN 
         EXIT DO
      ENDIF
   ENDDO
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder) 
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

IF m.moneda = 1
   SHOW GETS
   DO _brwLoadDetail
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldTipoCambio
*!
*!  Llamado por: MKCOMPRA.PRG       
*!
*!  Descripci¢n: Validaci¢n del campo m.tipocambio
*!
*!*********************************************************************
FUNCTION _vldTipoCambio
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN
ENDIF

IF m.tipocambio < 0
   WAIT WINDOW "­ EL TIPO DE CAMBIO DEBE SER MAYOR O IGUAL QUE CERO !"
   RETURN .F.
ENDIF

SHOW GETS
DO _brwLoadDetail

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

SELECT tmpdetcomp
SET ORDER TO 0

IF RECCOUNT() = 0
   INSERT INTO tmpdetcomp (tipodocu, nrodocu, proveedor, articulo, cantidad, precio, pdescuento, impuesto, pimpuesto, tipoc, taxinclude) ;
      VALUES (0, 0, 0, " ", 0, 0, 0, .F., 0, "", .F.)
ENDIF

ON KEY LABEL "F8" DO _DeleteLine

DO WHILE LASTKEY() <> 27
   @ 19,12 CLEAR TO 21,41
   
   @ 09,01 CLEAR TO 17,40     && Descripci¢n.
   @ 09,42 CLEAR TO 17,51     && Cantidad.
   @ 09,53 CLEAR TO 17,67     && Precio Unit.
   @ 09,69 CLEAR TO 17,78     && Importe.

   GO BOTTOM
   
   IF m.moneda <> 1
      BROWSE WINDOW tmpdetcomp FIELDS ;
         articulo                                   :14:H = "C¢digo"       :P = "@!"               :V = _vldCodigo():F ,;
         calc_f1 = SUBSTR(maesprod.nombre, 1, 38) :R:38:H = "Descripci¢n"  :W = .F. ,;
         cantidad                                   :08:H = "Cantidad"     :P="99999.99"           :V = _vldCantidad():F, ;
         precio                                     :13:H = "Precio Unit." :P="@K 99999999.9999"   :V = _vldPrecio():F, ;
         pdescuento                                 :07:H = "% Dcto."      :P="99.9999" :V = _vldDescuento() ,;      
         calc_f2 = ROUND(precio * cantidad, 2) - ROUND(ROUND(precio * cantidad, 2) * pdescuento / 100, 2) :11:H=" Sub-Total"   :P="9999,999.99" :W = .F. ,;
         calc_f3 = SUBSTR(maesprod.nombre,1,40)   :R:40:H = "Descripci¢n"  :W = .F. ,;
         calc_f4 = IIF(impuesto,"   S¡","   No")  :R:08:H = "Impuesto"     :W = .F. ,;    
         pimpuesto                                :R:06:H = "% Imp."       :P="999.99"             :V = _vldAddNewLine():F  ;
         NODELETE NOAPPEND 

   ELSE
      BROWSE WINDOW tmpdetcomp FIELDS ;
         articulo                                   :14:H = "C¢digo"       :P = "@!"               :V = _vldCodigo():F  ,;
         calc_f1 = SUBSTR(maesprod.nombre, 1, 38) :R:38:H = "Descripci¢n"  :W = .F. ,;
         cantidad                                   :08:H = "Cantidad"     :P="99999.99"           :V = _vldCantidad():F, ;
         precio                                     :13:H = "Precio Unit." :P="@K 99999999.9999"   :V = _vldPrecio():F, ;
         pdescuento                                 :07:H = "% Dcto."      :P="99.9999" :V = _vldDescuento() ,;      
         calc_f2 = ROUND(precio * cantidad, 0) - ROUND(ROUND(precio * cantidad, 0) * pdescuento / 100, 0) :11:H=" Sub-Total"   :P="999,999,999" :W = .F. ,;
         calc_f3 = SUBSTR(maesprod.nombre,1,40)   :R:40:H = "Descripci¢n"  :W = .F. ,;
         calc_f4 = IIF(impuesto,"   S¡","   No")  :R:08:H = "Impuesto"     :W = .F. ,;    
         pimpuesto                                :R:06:H = "% Imp."       :P="999.99"             :V = _vldAddNewLine():F  ;
         NODELETE NOAPPEND 
   ENDIF
ENDDO

ON KEY LABEL "F8"

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

DO _PrintDetail
DO calc_pie_factura

*!*********************************************************************
*!
*!      Funci¢n: _vldCodigo     
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Validaci¢n   del   campo   c¢digo  en  el  detalle  de   
*!               la compra.               
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
  
   IF LASTKEY() <> K_ESCAPE
      REPLACE tmpdetcomp.articulo WITH m.articulo
      REPLACE tmpdetcomp.tipoc    WITH "A"
   ELSE 
      RETURN .F.
   ENDIF
ENDIF

SELECT maesprod
IF tmpdetcomp.tipoc <> "A"
   SET ORDER TO TAG &pcMpdOrder OF maesprod.cdx
ELSE
   SET ORDER TO TAG indice1 OF maesprod.cdx
ENDIF

PRIVATE pcSetExact

IF SET("EXACT") = "OFF"
   SET EXACT ON 
   pcSetExact = "OFF"
ELSE
   pcSetExact = "ON"
ENDIF

IF SEEK(tmpdetcomp.articulo)
   SET ORDER TO TAG indice1 OF maesprod.cdx

   REPLACE tmpdetcomp.articulo WITH maesprod.codigo

   IF .NOT. EMPTY(tmpdetcomp.articulo) .AND. EMPTY(tmpdetcomp.precio) .AND. .NOT. INLIST(tmpdetcomp.articulo, "99015", "99016")
      IF m.moneda = 1  &&  Guaran¡es.
         IF INLIST(m.tipodocu, 3, 7, 8) THEN
            REPLACE tmpdetcomp.precio WITH ROUND(maesprod.pcostog * (1 + maesprod.pimpuesto / 100), 0)
         ELSE
            REPLACE tmpdetcomp.precio WITH maesprod.pcostog
         ENDIF
      ELSE
         IF m.moneda = 2  &&  D¢lares Americanos.
            IF INLIST(m.tipodocu, 3, 7, 8) THEN
               REPLACE tmpdetcomp.precio WITH ROUND(maesprod.pcostod * (1 + maesprod.pimpuesto / 100), 0)
            ELSE
               REPLACE tmpdetcomp.precio WITH maesprod.pcostod
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   IF .NOT. INLIST(m.tipodocu, 5, 6)
      REPLACE tmpdetcomp.impuesto  WITH maesprod.impuesto
      REPLACE tmpdetcomp.pimpuesto WITH maesprod.pimpuesto
      REPLACE tmpdetcomp.tipoc     WITH "A"
   ELSE
      REPLACE tmpdetcomp.impuesto  WITH .F.
      REPLACE tmpdetcomp.pimpuesto WITH 0
      REPLACE tmpdetcomp.tipoc     WITH "A"
   ENDIF

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
ELSE 

   SET ORDER TO TAG indice1 OF maesprod.cdx

   WAIT WINDOW "­ CODIGO DE ARTICULO INEXISTENTE !"

   IF pcSetExact = "OFF"
      SET EXACT OFF
   ENDIF

   RETURN .F.
ENDIF

IF pcSetExact = "OFF"
   SET EXACT OFF
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldPorcDesc   
*!
*!  Llamado por: MKSELL.PRG    
*!
*!  Descripci¢n: Valida el campo de descuento en porcentaje.
*!
*!*********************************************************************
FUNCTION _vldPorcDesc

PRIVATE plK_ESCAPE

plK_ESCAPE = .F.

IF m.porcdesc < 0
   WAIT WINDOW "­ EL PORCENTAJE DEL DESCUENTO DEBE SER MAYOR O IGUAL QUE CERO !"
   RETURN .F.
ELSE
   IF m.porcdesc > 100
      WAIT WINDOW "­ EL PORCENTAJE DEL DESCUENTO DEBE SER MENOR O IGUAL QUE CIEN !"
      RETURN .F.
   ELSE
      IF m.porcdesc > 0
         IF msubtotal = 0
            WAIT WINDOW "­ EL SUB-TOTAL DE LA FACTURA DEBE SER MAYOR QUE CERO !"
            RETURN .F.
         ENDIF
         DO calc_pie_factura
         IF LASTKEY() # K_PGDN .OR. LASTKEY() # K_ENTER
            _CUROBJ = OBJNUM(m.porcdesc)
         ENDIF
      ELSE
         _CUROBJ = OBJNUM(m.importdesc)
      ENDIF
   ENDIF
ENDIF

IF LASTKEY() = K_PGUP
   SHOW GET m.porcdesc
   DO _brwLoadDetail
   _CUROBJ= OBJNUM(m.porcdesc)
   RETURN .F.
ENDIF

IF INLIST(LASTKEY(), K_UP, K_PGUP, K_LEFT)
   RETURN .F.
ELSE   
   IF LASTKEY() = K_ENTER .AND. .NOT. EMPTY(m.porcdesc)
      DO calc_pie_factura
      DO cuotcomp.spr WITH m.tipodocu

      IF .NOT. plAdding .AND. .NOT. plEditing
         CLEAR READ
         WAIT WINDOW "­ LA COMPRA FUE GRABADA !" TIMEOUT 0.75
      ELSE
         _CUROBJ = OBJNUM(m.porcdesc)
      ENDIF
   ENDIF
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldImportDesc 
*!
*!  Llamado por: MKSELL.PRG
*!
*!  Descripci¢n: Valida el campo de descuento en monto.
*!
*!*********************************************************************
FUNCTION _vldImportDesc

IF m.importdesc < 0
   WAIT WINDOW "­ EL DESCUENTO DEBE SER CERO, MENOR O IGUAL AL VALOR DE LA FACTURA !"
   RETURN .F.
ELSE
   IF m.importdesc > msubtotal
      WAIT WINDOW "­ EL DESCUENTO DEBE SER CERO, MENOR O IGUAL AL VALOR DE LA FACTURA !"
      RETURN .F.
   ELSE
      IF m.importdesc > 0
         DO calc_pie_factura
         IF LASTKEY() # 3 .OR. LASTKEY() # 13
            _CUROBJ = OBJNUM(m.porcdesc)
         ENDIF
      ELSE
         DO calc_pie_factura
         _CUROBJ = OBJNUM(m.porcdesc)
      ENDIF
   ENDIF
   
   IF LASTKEY() = 19
      _CUROBJ = OBJNUM(m.porcdesc)
   ENDIF

   IF LASTKEY() = K_PGUP
      SHOW GET m.importdesc
      DO _brwLoadDetail
      _CUROBJ= OBJNUM(m.porcdesc)
      RETURN .F.
   ENDIF

   IF INLIST(LASTKEY(), 5, 18)
      RETURN .F.
   ELSE   
      IF LASTKEY() = 13 
         IF msubtotal = 0
            WAIT WINDOW "­ EL SUB-TOTAL DE LA FACTURA DEBE SER MAYOR QUE CERO !"
            _CUROBJ = OBJNUM(m.porcdesc)
            RETURN
         ENDIF
   
         DO calc_pie_factura
         DO cuotcomp.spr WITH m.tipodocu
         
         IF .NOT. plAdding .AND. .NOT. plEditing
            CLEAR READ
            WAIT WINDOW "­ LA COMPRA FUE GRABADA !" TIMEOUT 0.75
         ELSE
            _CUROBJ = OBJNUM(m.importdesc)
         ENDIF
      ENDIF
   ENDIF
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _ShowHeader
*!
*!  Llamado por: _RefreshInvoice
*!
*!  Descripci¢n: Visualiza el encabezado de la compra.
*!
*!*********************************************************************
FUNCTION _ShowHeader 

@ 02,13 GET m.tipodocu ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN plAdding ;
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

IF pimpuesto < 0 .OR. pimpuesto > control.pimpuesto
   WAIT WINDOW "­ PORCENTAJE DE IMPUESTO INVALIDO !"
   RETURN .F.
ENDIF

DO calc_pie_factura

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

IF m.tipodocu = 3     &&  3. COMPRA I.V.A. INCLUIDO
   IF .NOT. tmpdetcomp.taxinclude
      IF tmpdetcomp.impuesto .AND. tmpdetcomp.pimpuesto > 0
         REPLACE tmpdetcomp.precio     WITH ROUND(tmpdetcomp.precio / (1 + tmpdetcomp.pimpuesto / 100), 4) 
         REPLACE tmpdetcomp.taxinclude WITH .T.           
      ENDIF
   ENDIF
ELSE
   IF m.tipodocu = 4     &&  4. COMPRA TRIBUTO UNICO
      REPLACE tmpdetcomp.impuesto  WITH .F.
      REPLACE tmpdetcomp.pimpuesto WITH 0
   ENDIF
ENDIF

DO calc_pie_factura

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
      INSERT INTO tmpdetcomp (tipodocu, nrodocu, proveedor, articulo, cantidad, precio, pdescuento, impuesto, pimpuesto, tipoc, taxinclude) ;
         VALUES (0, 0, 0, " ", 0, 0, 0, .F., 0, "", .F.)
   ENDIF
ENDIF

DO calc_pie_factura   

*!*********************************************************************
*!
*!      Funci¢n: _DeleteLine  
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Borra una l¡nea de detalle del comprobante de compra.
*!
*!*********************************************************************
FUNCTION _DeleteLine

PRIVATE pnSelect, pcOrder
pnSelect = SELECT()
pcOrder  = ORDER()

SELECT tmpdetcomp
DELETE 
PACK

IF RECCOUNT() = 0
   INSERT INTO tmpdetcomp (tipodocu, nrodocu, proveedor, articulo, cantidad, precio, pdescuento, impuesto, pimpuesto, tipoc, taxinclude) ;
      VALUES (0, 0, 0, " ", 0, 0, 0, .F., 0, "", .F.)
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)

DO calc_pie_factura

*!**************************************************************************
*!
*!  PROCEDIMIENTO: calc_pie_factura   
*!
*!    DESCRIPCION: Calcula e imprime el pie del comprobante.
*!
*!**************************************************************************
PROCEDURE calc2pie_factura

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

@ 21,65 SAY pnImpuesto ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR N/W

@ 22,65 SAY m.monto_fact ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR B/W

SHOW GETS

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder) 
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _PrintDetail
*!
*!  Llamado por: _ShowDetail                 
*!
*!  Descripci¢n: Imprime  el  detalle  de  art¡culos del comprobante de         
*!               venta.
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
   @ pnRow + RECNO(), pnColumn      SAY SUBSTR(maesprod.nombre,1,39)                                                   COLOR N/W
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
*!      Funci¢n: _vldDescuento
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Validaci¢n del campo precio unitario en el detalle del   
*!               comprobante de venta.
*!
*!*********************************************************************
FUNCTION _vldDescuento
IF pdescuento < 0
   WAIT WINDOW "­ EL PORCENTAJE DE DESCUENTO DEBE SER MAYOR O IGUAL QUE CERO !"
   RETURN .F.
ENDIF         

DO calc_pie_factura