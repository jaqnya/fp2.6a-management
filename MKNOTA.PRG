*:*********************************************************************
*:
*: Archivo de Procedimiento: MKSELL.PRG
*:
*:                  Sistema: Agrega o Modifica una Ventas.
*:                    Autor: Jos‚ Avilio Acu¤a Acosta
*:                 Copyright (c) 2004, Alben S.R.L.             
*:            Last modified: 12/02/2004           
*:
*:            Procs & Fncts:
*:
*:*********************************************************************
PARAMETER pcWhatToDo

PUSH KEY CLEAR

*-- Variables de la Tabla de Cabecera.
PRIVATE m.tiponota, m.nronota, m.tipodocu, m.nrodocu, m.fechanota, m.cliente, m.motivonota, m.aplicontra, m.fechaanu, m.anulado, m.monto_nota

*-- Variables para c lculos del programa.
PRIVATE pnGravada, pnExenta, pnImpuesto, pnSubTotal
                                                                                    
IF pcWhatToDo = "Add"
   SELECT cabenotc
   SCATTER MEMVAR MEMO BLANK
   
ELSE
   IF pcWhatToDo = "Edit"
      	IF cabenotc.anulado
      	   WAIT WINDOW "­ ESTA NOTA SE ENCUENTRA ANULADA, IMPOSIBLE MODIFICARLA !"
      	   POP KEY
      	   RETURN
      	ENDIF
        
        SELECT cabenotc
      	SCATTER MEMVAR MEMO
   ENDIF
ENDIF

*-- Inicializaci¢n de variables.
STORE 0 TO pnGravada, pnExenta, pnImpuesto, pnSubTotal

IF pcWhatToDo = "Add"
   plAdding    = .T.
   plEditing   = .F.
   plDeleting  = .F.
   m.fechanota = DTOC(DATE()) 

   SELECT tmpdetnota
   ZAP
ELSE
   IF pcWhatToDo = "Edit"
      plAdding    = .F.
      plEditing   = .T.
      plDeleting  = .F.
      m.fechanota = DTOC(m.fechadocu) 
   ENDIF
ENDIF  

SELECT cabenotc

DO _fmtInvoice

IF pcWhatToDo = "Edit"
   DO _RefreshInvoice
ENDIF

@ 02,14 GET m.tiponota ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN plAdding ;
   VALID _vldTipoNota() ;
   COLOR SCHEME 1

@ 02,44 GET m.nronota ;
   SIZE 1,7 ;
   DEFAULT 0 ;
   PICTURE "9999999" ;
   WHEN plAdding ;
   VALID _vldNroNota() ;
   COLOR SCHEME 1

@ 02,69 GET m.fechanota ;
   SIZE 1,10 ;
   DEFAULT DTOC(DATE()) ;
   PICTURE "99/99/9999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldFechaNota() ;
   COLOR SCHEME 1

@ 03,14 GET m.tipodocu ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN plAdding ;
   VALID _vldTipoDocu() ;
   COLOR SCHEME 1

@ 03,44 GET m.nrodocu ;
   SIZE 1,7 ;
   DEFAULT 0 ;
   PICTURE "9999999" ;
   WHEN plAdding ;
   VALID _vldNroDocu() ;
   COLOR SCHEME 1

@ 05,14 GET m.motivonota ;
   SIZE 1,3 ;
   DEFAULT 0 ;
   PICTURE "999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldMotivoNota() ;
   COLOR SCHEME 1
   
@ 05,67 GET m.aplicontra ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldAplicontra() ;
   COLOR SCHEME 1


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

READ CYCLE ;
   MODAL ;
   VALID _vldReadCycle() ;
   COLOR , W+/BG 

*!*********************************************************************
*!
*!      Funci¢n: _vldReadCycle
*!
*!  Llamado por: MKSELL.PRG      
*!
*!  Descripci¢n: Valida la terminaci¢n del comando READ.
*!
*!*********************************************************************
FUNCTION _vldReadCycle
IF LASTKEY() = 27 
*  IF LOWER(SYS(18)) = "pnImpues" .OR. LOWER(SYS(18)) = "importdesc"
*     _CUROBJ = OBJNUM(m.porcdesc)      
*     RETURN .F.
*  ENDIF
ENDIF

**-------------------------------------------------------------------**
**                            ENCABEZADO                             **
**-------------------------------------------------------------------**

*!*********************************************************************
*!
*!      Funci¢n: _vldTipoDocu
*!
*!  Llamado por: MKSELL.PRG      
*!
*!  Descripci¢n: Validaci¢n del campo tipo de documento.
*!
*!*********************************************************************
FUNCTION _vldTipoDocu
IF INLIST(LASTKEY(), 5, 19, 28, 127)
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
*!  Llamado por: MKSELL.PRG                 
*!
*!  Descripci¢n: Validaci¢n del campo n£mero de documento.    
*!
*!*********************************************************************
FUNCTION _vldNroDocu
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

IF m.nrodocu <= 0
   WAIT WINDOW "­ EL N§ DEL DOCUMENTO DEBE SER MAYOR QUE CERO !"
   RETURN .F.
ENDIF

SELECT cabevent
SET ORDER TO TAG indice1 OF cabevent.cdx

IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7))
   WAIT WINDOW "­ ESTA VENTA YA HA SIDO CARGADA !"

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
*!      Funci¢n: NextNumber 
*!
*!  Llamado por: MKSELL.PRG                  
*!
*!  Descripci¢n: Obtiene el pr¢ximo n£mero  de  comprobante  de  venta,
*!               disponible,  teniendo en cuenta el tipo  de boleta.
*!
*!*********************************************************************
FUNCTION NextNumber

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT cabevent
SET ORDER TO TAG indice1 OF cabevent.cdx DESCENDING

IF SEEK(STR(m.tipodocu, 1))
   NextCode = cabevent.nrodocu + 1
ELSE
   NextCode = 1
ENDIF

SET ORDER TO TAG indice1 OF cabevent.cdx ASCENDING

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

RETURN (NextCode)

*!*********************************************************************
*!
*!      Funci¢n: _vldFechaDocu
*!
*!  Llamado por: MKSELL.PRG                  
*!
*!  Descripci¢n: Validaci¢n del campo fecha de documento.
*!
*!*********************************************************************
FUNCTION _vldFechaDocu
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
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
*!  Llamado por: MKSELL.PRG                  
*!
*!  Descripci¢n: Validaci¢n del liste de precio.
*!
*!*********************************************************************
FUNCTION _vldLstPrecio
IF INLIST(LASTKEY(), 5, 19, 27, 127) .AND. plAdding
   RETURN 
ELSE
   IF INLIST(LASTKEY(), 5, 19, 28, 127) .AND. plEditing
      RETURN .F.
   ENDIF
ENDIF

IF m.lstprecio <= 0
   WAIT WINDOW "­ LA LISTA DE PRECIOS DEBE SER 1, 2, 3, 4 à 5 !"
   RETURN .F.
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldCliente
*!
*!  Llamado por: MKSELL.PRG                  
*!
*!  Descripci¢n: Validaci¢n del campo cliente.
*!
*!*********************************************************************
FUNCTION _vldCliente
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

IF m.cliente <= 0
   @ 05,22 SAY REPLICATE(CHR(32), 56) ;
      SIZE 1,56 ;
      PICTURE "@!" ;
      COLOR W/N

   PUSH KEY CLEAR

   *-- Procedimiento de inspecci¢n de art¡culos.
   ON KEY LABEL "ENTER" KEYBOARD "{CTRL+W}"
   DO brwClien.prg
   ON KEY LABEL "ENTER" 

   POP KEY

   IF LASTKEY() <> K_ESCAPE
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
   @ 06,22 SAY REPLICATE(CHR(32), 28) ;
      SIZE 1,28 ;
      PICTURE "@!" ;
      COLOR W/N
   DO mone_pop.spr WITH "m.moneda", 0, .F.
ENDIF

IF m.moneda = 0
   RETURN .F.
ENDIF

DO SaveWorkArea

SELECT monedas
SET ORDER TO TAG indice1 OF monedas.cdx

IF SEEK(m.moneda)
   IF monedas.vigente
      @ 06,22 SAY PADR(ALLTRIM(monedas.nombre), 28, CHR(32)) ;
         SIZE 1,28 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 06,22 SAY REPLICATE(CHR(32), 28) ;
         SIZE 1,28 ;
         PICTURE "@!" ;
         COLOR W/N
      WAIT WINDOW "­ CODIGO DE MONEDA NO VIGENTE !"
      DO RestoreWorkArea
      RETURN .F.
   ENDIF
ELSE
   @ 06,22 SAY REPLICATE(CHR(32), 28) ;
      SIZE 1,28 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE MONEDA INEXISTENTE !"
   DO mone_pop.spr WITH "m.moneda", 0, .F.
   SHOW GET m.moneda

   SELECT monedas
   SET ORDER TO TAG indice1 OF monedas.cdx
 
   IF SEEK(m.moneda)
      IF monedas.vigente
         @ 06,22 SAY PADR(ALLTRIM(monedas.nombre), 28, CHR(32)) ;
            SIZE 1,28 ;
            PICTURE "@!" ;
            COLOR W/N
      ELSE
         @ 06,22 SAY REPLICATE(CHR(32), 28) ;
            SIZE 1,28 ;
            PICTURE "@!" ;
            COLOR W/N
         WAIT WINDOW "­ CODIGO DE MONEDA NO VIGENTE !"
         DO RestoreWorkArea
         RETURN .F.
      ENDIF
   ELSE
      @ 06,22 SAY REPLICATE(CHR(32), 28) ;
         SIZE 1,28 ;
         PICTURE "@!" ;
         COLOR W/N
      DO RestoreWorkArea
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

   pcString1 = "­ HA SELECCIONADO FACTURAR EN: " + ALLTRIM(monedas.nombre) + " !"
   pcString2 = PADC("¨ ESTA SEGURO DE CONTINUAR ?  [S/N]", LEN(pcString1), CHR(32))

   DO WHILE .T.
      WAIT WINDOW pcString1 + CHR(13) + pcString2 TO pcMoneda
      IF UPPER(pcMoneda) = "S"
         EXIT DO 
      ENDIF
      IF UPPER(pcMoneda) = "N"
         @ 06,22 SAY REPLICATE(CHR(32), 28) ;
            SIZE 1,28 ;
            PICTURE "@!" ;
            COLOR W/N
         m.moneda = 1
         SHOW GET m.moneda
         _CUROBJ = OBJNUM(m.moneda)         
         EXIT DO
      ENDIF
   ENDDO
ENDIF

DO RestoreWorkArea

*!*********************************************************************
*!
*!      Funci¢n: _vldTipoCambio
*!
*!  Llamado por: MKSELL.PRG             
*!
*!  Descripci¢n: Validaci¢n del campo tipo de cambio.         
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

*!*********************************************************************
*!
*!      Funci¢n: _vldVendedor
*!
*!  Llamado por: MKSELL.PRG                 
*!
*!  Descripci¢n: Validaci¢n del campo vendedor.               
*!
*!*********************************************************************
FUNCTION _vldVendedor
IF INLIST(LASTKEY(), 5, 19, 27, 127)
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
   IF vendedor.vigente
      @ 07,22 SAY PADR(ALLTRIM(vendedor.nombre), 28, CHR(32)) ;
         SIZE 1,28 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 07,22 SAY REPLICATE(CHR(32), 28) ;
         SIZE 1,28 ;
         PICTURE "@!" ;
         COLOR W/N
      WAIT WINDOW "­ CODIGO DE VENDEDOR NO VIGENTE !"
      DO RestoreWorkArea
      RETURN .F.
   ENDIF
ELSE
   @ 07,22 SAY REPLICATE(CHR(32), 28) ;
      SIZE 1,28 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE VENDEDOR INEXISTENTE !"
   DO vend_pop.spr WITH "m.vendedor", 0, .F.
   SHOW GETS

   SELECT vendedor
   SET ORDER TO TAG indice1 OF vendedor.cdx

   IF SEEK(m.vendedor)
      IF vendedor.vigente
         @ 07,22 SAY PADR(ALLTRIM(vendedor.nombre), 28, CHR(32)) ;
            SIZE 1,28 ;
            PICTURE "@!" ;
            COLOR W/N
      ELSE
         @ 07,22 SAY REPLICATE(CHR(32), 28) ;
            SIZE 1,28 ;
            PICTURE "@!" ;
            COLOR W/N
         WAIT WINDOW "­ CODIGO DE VENDEDOR NO VIGENTE !"
         DO RestoreWorkArea
         RETURN .F.
      ENDIF
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
*!      Funci¢n: _vldComision_V
*!
*!  Llamado por: MKSELL.PRG                 
*!
*!  Descripci¢n: Validaci¢n del campo comisi¢n de vendedor.  
*!
*!*********************************************************************
FUNCTION _vldComision_V
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN
ENDIF

IF m.comision_v < 0
   WAIT WINDOW "­ LA COMISION DEL VENDEDOR DEBE SER MAYOR O IGUAL QUE CERO !"
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

DO SaveWorkArea

SELECT tmpdetvent
SET ORDER TO 0

IF RECCOUNT() = 0
   INSERT INTO tmpdetvent (tipodocu, nrodocu, articulo, cantidad, precio, impuesto, pimpuesto, serie, mecanico, descr_trab) ;
      VALUES (0, 0, "", 0, 0, .F., 0, "", 0, "")
ENDIF

ON KEY LABEL "F8" DO _DeleteLine

DO WHILE LASTKEY() <> 27
   @ 19,12 CLEAR TO 21,41
   
   @ 09,01 CLEAR TO 17,40     && Descripci¢n.
   @ 09,42 CLEAR TO 17,51     && Cantidad.
   @ 09,53 CLEAR TO 17,67     && Precio Unit.
   @ 09,69 CLEAR TO 17,78     && Importe.

   GO BOTTOM
   BROWSE WINDOW tmpdetvent FIELDS ;
      articulo                                   :13:H = "C¢digo"                                 :V = _vldCodigo():F ,;
      calc_f1 = SUBSTR(maesprod.nombre, 1, 37) :R:37:H = "Descripci¢n"  :W = .F. ,;
      cantidad                                   :08:H = "Cantidad"     :P = "99999.99"           :V = _vldCantidad():F ,;
      precio                                     :15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = .T. :V = _vldPrecio():F  ,;
      calc_f2 = ROUND(precio * cantidad, 0)      :11:H = " Sub-Total"   :P = "999,999,999" :W = _whenSubTotal(articulo) :V = _vldAddNewLine() :F ,;
      mecanico                                   :03:H = "Mec"          :P = "999"    :V = _vldMecanico(mecanico):F ,;
      calc_f3 = SUBSTR(mecanico.nombre, 1, 30) :R:30:H = "Nombre del Mec nico" :W = .F. ,;
      descr_trab                                 :40:H = "Descripci¢n de Trabajo" :P = "@!" :V = _vldAddNewLine() :F ;
      NODELETE NOAPPEND 
ENDDO

*&&      precio                                     :15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = _whenPrecioUnit(articulo) :V = _vldPrecio():F  ,;

ON KEY LABEL "F8"

DO RestoreWorkArea
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

   *-- Procedimiento de inspecci¢n de art¡culos.
   ON KEY LABEL "ENTER" KEYBOARD "{CTRL+W}"
   DO brwMaesprod.prg
   ON KEY LABEL "ENTER" 

   POP KEY

   IF LASTKEY() <> K_ESCAPE
      REPLACE tmpdetvent.articulo WITH maesprod.codigo
   ELSE 
      RETURN .F.
   ENDIF
ENDIF

SELECT maesprod
SET ORDER TO TAG indice1 OF maesprod.cdx

IF NOT SEEK(tmpdetvent.articulo)
   WAIT WINDOW "­ CODIGO DE ARTICULO INEXISTENTE !"
   RETURN .F.
ENDIF

REPLACE tmpdetvent.articulo  WITH maesprod.codigo
REPLACE tmpdetvent.impuesto  WITH maesprod.impuesto
REPLACE tmpdetvent.pimpuesto WITH maesprod.pimpuesto

SELECT servicio
SET ORDER TO indice1 OF servicio.cdx

PRIVATE pcSetExact

IF SET("EXACT") = "OFF"
   SET EXACT ON 
   pcSetExact = "OFF"
ELSE
   pcSetExact = "ON"
ENDIF

IF NOT SEEK(ALLTRIM(tmpdetvent.articulo))
   SELECT tmpdetvent
   DO CASE
      CASE m.lstprecio = 1
         REPLACE tmpdetvent.precio WITH maesprod.pventag1
      CASE m.lstprecio = 2
         REPLACE tmpdetvent.precio WITH maesprod.pventag2
      CASE m.lstprecio = 3
         IF maesprod.pventag3 = 0
            REPLACE tmpdetvent.precio WITH maesprod.pventag2
         ELSE
            REPLACE tmpdetvent.precio WITH maesprod.pventag3
         ENDIF
      CASE m.lstprecio = 4
         REPLACE tmpdetvent.precio WITH maesprod.pventag4
      CASE m.lstprecio = 5
         REPLACE tmpdetvent.precio WITH maesprod.pventag5
   ENDCASE      
ENDIF

IF pcSetExact = "OFF"
   SET EXACT OFF
ENDIF

SELECT tmpdetvent

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

IF precio <= 0
   WAIT WINDOW "­ EL PRECIO UNITARIO DE VENTA DEBE SER MAYOR QUE CERO !"
   RETURN .F.
ENDIF

IF pimpuesto < 0 .OR. pimpuesto > control.pimpuesto
   WAIT WINDOW "­ PORCENTAJE DE IMPUESTO INVALIDO !"
   RETURN .F.
ENDIF

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
      INSERT INTO tmpdetvent (tipodocu, nrodocu, articulo, cantidad, precio, impuesto, pimpuesto, serie, mecanico, descr_trab) ;
         VALUES (0, 0, "", 0, 0, .F., 0, "", 0, "")
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

SELECT tmpdetvent
DELETE 
PACK

IF RECCOUNT() = 0
   INSERT INTO tmpdetvent (tipodocu, nrodocu, articulo, cantidad, precio, impuesto, pimpuesto, serie, mecanico, descr_trab) ;
      VALUES (0, 0, "", 0, 0, .F., 0, "", 0, "")
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)

DO _InvoiceFoot

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

DO SaveWorkArea

#DEFINE pnRow    8
#DEFINE pnColumn 2

SELECT tmpdetvent
GO TOP

SCAN WHILE RECNO() <= 9 .AND. .NOT. (EMPTY(articulo) .OR. EMPTY(cantidad) .OR. EMPTY(precio))
   @ pnRow + RECNO(), pnColumn      SAY SUBSTR(maesprod.nombre, 1, 39)                           COLOR N/W
   @ pnRow + RECNO(), pnColumn + 40 SAY cantidad                       PICTURE "999,999.99"      COLOR N/W
   @ pnRow + RECNO(), pnColumn + 51 SAY precio                         PICTURE "99,999,999.9999" COLOR N/W
   @ pnRow + RECNO(), pnColumn + 67 SAY ROUND(precio * cantidad, 0)    PICTURE "99,999,999"      COLOR N/W
ENDSCAN

DO RestoreWorkArea

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

DO SaveWorkArea

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
   COLOR N/W

DO RestoreWorkArea

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
      DO _InvoiceFoot
      DO cuotvent.spr WITH m.tipodocu

      IF plAdding 
         CLEAR READ
         WAIT WINDOW "­ LA VENTA FUE GRABADA !" TIMEOUT 0.75
      ENDIF

      IF plEditing 
         IF INLIST(m.tipodocu, 1, 3, 4)
            CLEAR READ
            WAIT WINDOW "­ LA VENTA FUE GRABADA !" TIMEOUT 0.75
         ENDIF

         IF m.tipodocu = 2 
            IF NOT plK_ESCAPE
               CLEAR READ
               WAIT WINDOW "­ LA VENTA FUE GRABADA !" TIMEOUT 0.75
            ENDIF
         ENDIF
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
PRIVATE plK_ESCAPE
plK_ESCAPE = .F.

IF m.importdesc < 0
   WAIT WINDOW "­ EL DESCUENTO DEBE SER CERO, MENOR O IGUAL AL VALOR DE LA FACTURA !"
   RETURN .F.
ELSE
   IF m.importdesc > pnSubTotal
      WAIT WINDOW "­ EL DESCUENTO DEBE SER CERO, MENOR O IGUAL AL VALOR DE LA FACTURA !"
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
      IF LASTKEY() = 13   && .AND. EMPTY(m.importdesc)
         IF pnSubTotal = 0
            WAIT WINDOW "­ EL SUB-TOTAL DE LA FACTURA DEBE SER MAYOR QUE CERO !"
            _CUROBJ = OBJNUM(m.porcdesc)
            RETURN
         ENDIF
   
         DO _InvoiceFoot
         DO cuotvent.spr WITH m.tipodocu

         IF plAdding 
            CLEAR READ
            WAIT WINDOW "­ LA VENTA FUE GRABADA !" TIMEOUT 0.75
         ENDIF

         IF plEditing 
            IF INLIST(m.tipodocu, 1, 3, 4)
               CLEAR READ
               WAIT WINDOW "­ LA VENTA FUE GRABADA !" TIMEOUT 0.75
            ENDIF

            IF m.tipodocu = 2 
               IF NOT plK_ESCAPE
                  CLEAR READ
                  WAIT WINDOW "­ LA VENTA FUE GRABADA !" TIMEOUT 0.75
               ENDIF
            ENDIF
         ENDIF

      ENDIF
   ENDIF
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

IF cabevent.anulado
   WAIT WINDOW "­ FACTURA ANULADA !" NOWAIT
ENDIF

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

@ 02,15 SAY m.tipodocu ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W

*-- Imprime la etiqueta del tipo de documento.
DO CASE
   CASE m.tipodocu = 1
      @ 02,18 SAY "VENTA CONTADO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 2
      @ 02,18 SAY "VENTA CREDITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 3
      @ 02,18 SAY "VENTA I.V.A. INCLUIDO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 4
      @ 02,18 SAY "VENTA TRIBUTO UNICO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   OTHERWISE
      @ 02,18 SAY REPLICATE(CHR(32), 21) ;
         SIZE 1,21 ;
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

@ 07,68 SAY m.comision_v ;
   SIZE 1,6 ;
   PICTURE "999.99" ;
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

DO SaveWorkArea

#DEFINE pnRow    8
#DEFINE pnColumn 2

SELECT tmpdetvent
GO TOP

SCAN WHILE RECNO() <= 9 .AND. .NOT. (EMPTY(articulo) .OR. EMPTY(cantidad) .OR. EMPTY(precio))
   @ pnRow + RECNO(), pnColumn      SAY SUBSTR(maesprod.nombre, 1, 39)                           COLOR N/W
   @ pnRow + RECNO(), pnColumn + 40 SAY cantidad                       PICTURE "999,999.99"      COLOR N/W
   @ pnRow + RECNO(), pnColumn + 51 SAY precio                         PICTURE "99,999,999.9999" COLOR N/W
   @ pnRow + RECNO(), pnColumn + 67 SAY ROUND(precio * cantidad, 0)    PICTURE "99,999,999"      COLOR N/W
ENDSCAN

DO RestoreWorkArea

*------------------------

FUNCTION _vldMecanico
parameter nro

RETURN
