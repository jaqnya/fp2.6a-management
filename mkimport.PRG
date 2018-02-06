* +-------------------------------------------------------------+
* |  MKMOVOT2.PRG  Release 1.0  23/08/2004                      |
* |  Copyright (C) Turtle Software Paraguay, 2000-2004          |
* |  All Rights Reserved.                                       |
* |                                                             |
* |  This Module contains Proprietary Information of            |
* |  Turtle Software Paraguay and should be treated             |
* |  as Condifential.                                           |
* +-------------------------------------------------------------+

* +-------------------------------------------------------------+
* |  M¢dulo: MOVIMIENTOS DE ARTICULOS POR ORDENES DE TRABAJO.   |
* |  Este m¢dulo se encarga de agregar y modificar movimientos  |
* |  de ordenes de trabajo de m quinas en garant¡a.             |
* |                                                             |
* |  Modificado:                                                |
* |                                                             |
* +-------------------------------------------------------------+
PARAMETER cWhatToDo

* Declaraci¢n de variables.
STORE "" to m.TIPODOCU, m.NRODOCU, m.PROVEEDOR, m.FECHADOCU, m.DIVISA, m.CAMBIO, m.CAMBIO2, m.PORCDESC, m.IMPORTDESC, m.MONTO_FACT, m.MONTO_PAGO, m.GASTOS

STORE 0 TO m.nroot, m.lstprecio, m.almacen, m.moneda, m.tipocambio, ;
           m.vendedor, m.comision_v, m.porcdesc, m.importdesc, ;
           m.descuento, m.monto_fact, m.cliente, m.mecanico, m.estadoot, ;
           m.maquina, m.marca, m.modelo, m.localrep, nGravada, nExenta, ;
           nImpuesto, nSubTotal
STORE "" TO m.serie, m.obs1, m.obs2, m.obs3, m.nombreot, m.accesorio, ;
            m.referencia
STORE {} TO fecha

* Declaraci¢n de constantes.
*-- Teclas de funci¢n.

#DEFINE K_F1           28    &&   F1, Ctrl-\
#DEFINE K_F2           -1    &&   F2
#DEFINE K_F3           -2    &&   F3
#DEFINE K_F4           -3    &&   F4
#DEFINE K_F5           -4    &&   F5
#DEFINE K_F6           -5    &&   F6
#DEFINE K_F7           -6    &&   F7
#DEFINE K_F8           -7    &&   F8
#DEFINE K_F9           -8    &&   F9
#DEFINE K_F10          -9    &&   F10
#DEFINE K_F11         -40    && * F11
#DEFINE K_F12         -41    && * F12

*-- Teclas de movimiento del cursor.

#DEFINE K_UP                5   &&   Up arrow, Ctrl-E
#DEFINE K_DOWN             24   &&   Down arrow, Ctrl-X
#DEFINE K_LEFT             19   &&   Left arrow, Ctrl-S
#DEFINE K_RIGHT             4   &&   Right arrow, Ctrl-D
#DEFINE K_HOME              1   &&   Home, Ctrl-A
#DEFINE K_END               6   &&   End, Ctrl-F
#DEFINE K_PGUP             18   &&   PgUp, Ctrl-R
#DEFINE K_PGDN              3   &&   PgDn, Ctrl-C

*-- Miscel nea de teclas.

#DEFINE K_ENTER            13   &&   Enter, Ctrl-M
#DEFINE K_RETURN           13   &&   Return, Ctrl-M
#DEFINE K_SPACE            32   &&   Space bar
#DEFINE K_ESC              27   &&   Esc, Ctrl-[
#DEFINE K_BSPACE          127   &&   Back space  

*-- Mensajes del sistema.

#DEFINE C_DBFEMPTY		"¨ LA TABLA ESTA VACIA, AGREGAR UN REGISTRO ?"
#DEFINE C_NOEDIT        "ESTE MOVIMIENTO DE OT YA HA SIDO FACTURADO, IMPOSIBLE MODIFICARLO."
#DEFINE C_MESSA_01      "NO SE ENCONTRO LA OT N§: "
#DEFINE C_MESSA_02      "LA SERIE DEBE SER: "
#DEFINE C_MESSA_03      "EL N§ DE LA OT DEBE SER MAYOR QUE CERO."
#DEFINE C_MESSA_04      "N§ DE OT NO ENCONTRADA."
#DEFINE C_MESSA_05      "NO SE ENCONTRO LA MAQUINA N§: " 
#DEFINE C_MESSA_06      "NO SE ENCONTRO LA MARCA N§: "
#DEFINE C_MESSA_07      "NO SE ENCONTRO EL MODELO: "
#DEFINE C_MESSA_08      "ESTE MOVIMIENTO DE OT YA HA SIDO CARGADO."
#DEFINE C_MESSA_09      "LA LISTA DE PRECIOS DEBE SER DEL 1 AL 5."
#DEFINE C_MESSA_10      "CODIGO DE ALMACEN INEXISTENTE."
#DEFINE C_MESSA_11      "CODIGO DE MECANICO INEXISTENTE."
#DEFINE C_MESSA_12      "CODIGO DE ESTADO DE LA OT INEXISTENTE."
#DEFINE C_MESSA_13      "CODIGO DE VENDEDOR INEXISTENTE."
#DEFINE C_MESSA_14      "CODIGO DE LOCAL INEXISTENTE."
#DEFINE C_MESSA_15      "LA REFERENCIA NO PUEDE QUEDAR EN BLANCO."
#DEFINE C_MESSA_16      "CODIGO DE ARTICULO INEXISTENTE."
#DEFINE C_MESSA_17      "LA CANTIDAD DEBE SER MAYOR QUE CERO."
#DEFINE C_MESSA_18      "EL PRECIO UNITARIO DEBE SER MAYOR QUE CERO."
#DEFINE C_MESSA_19      "PORCENTAJE DE IMPUESTO INVALIDO."
#DEFINE C_MESSA_20      "EL MECANICO SELECCIONADO NO POSEE ESTA CONFIGURACION DE MANO DE OBRA."
#DEFINE C_MESSA_21      "­ EL REGISTRO HA SIDO GRABADO !"
#DEFINE C_MESSA_22      "EL PORCENTAJE DEL DESCUENTO DEBE SER MAYOR O IGUAL QUE CERO."
#DEFINE C_MESSA_23      "EL PORCENTAJE DEL DESCUENTO DEBE SER MENOR O IGUAL QUE CIEN."
#DEFINE C_MESSA_24      "EL SUB-TOTAL DEBE SER MAYOR QUE CERO."
#DEFINE C_MESSA_25      "EL DESCUENTO DEBE SER CERO, MENOR O IGUAL AL SUB-TOTAL."
#DEFINE C_MESSA_26      "IMPOSIBLE ACTUALIZAR EL SALDO DEL ARTICULO: "

IF UPPER(cWhatToDo) = "ADD"
   SELECT cabeimpo
   SCATTER MEMVAR MEMO BLANK

   lAdding     = .T.
   lEditing    = .F.
   lDeleting   = .F.
   m.fechadocu = DATE()

   SELECT detatemp
   ZAP
ELSE
   IF UPPER(cWhatToDo) = "EDIT"
      SELECT cabeimpo
      SCATTER MEMVAR MEMO
      
      lAdding    = .F.
      lEditing   = .T.
      lDeleting  = .F.
   ENDIF
ENDIF

SELECT cabeimpo

=Format()

IF UPPER(cWhatToDo) = "EDIT"
   =Refresh()
ENDIF

@ 02,09 GET m.tipodocu ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN lAdding ;
   VALID _vldTipoDocu() ;
   COLOR &color_01

@ 02,25 GET m.nrodocu ;
   SIZE 1,9 ;
   DEFAULT 0 ;
   PICTURE "@!" ;
   WHEN lAdding ;
   VALID vldNroDocu() ;
   COLOR &color_01

@ 02,45 GET m.proveedor ;
   SIZE 1,5 ;
   DEFAULT 0 ;
   PICTURE "99999" ;
   WHEN lAdding ;
   VALID _vldProveedor() ;
   COLOR &color_01

@ 03,09 GET m.fechadocu ;
   SIZE 1,10 ;
   DEFAULT DATE() ;
   PICTURE "@D" ;
   WHEN whenFecha() ;
   VALID vldFecha() ;
   COLOR &color_01

@ 04,17 GET m.cambio ;
   SIZE 1,12 ;
   DEFAULT 0 ;
   PICTURE "999,999.9999" ;
   WHEN (lAdding .OR. lEditing);
   VALID _vldCambio() ;
   COLOR &color_01
   
@ 04,45 GET m.cambio2 ;
   SIZE 1,12 ;
   DEFAULT 0 ;
   PICTURE "999,999.9999" ;
   WHEN (lAdding .OR. lEditing) ;
   VALID _vld2Cambio() ;
   COLOR &color_01

@ 19,68 SAY nSubTotal ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR B/W

@ 20,46 GET m.porcdesc ;
   SIZE 1,8 ;
   DEFAULT 0 ;
   PICTURE "999.9999" ;
   WHEN (lAdding .OR. lEditing) ;
   VALID vldPorcDesc() ;
   COLOR &color_01

@ 20,68 GET m.importdesc ;
   SIZE 1,11 ;
   DEFAULT 0 ;
   PICTURE "999,999,999" ;
   WHEN (lAdding .OR. lEditing) .AND. m.porcdesc = 0 ; 
   VALID vldImportDesc() ;
   COLOR &color_01

@ 21,68 SAY nImpuesto ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR B/W     

@ 22,68 SAY m.monto_fact ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

READ CYCLE ;
   MODAL ;
   VALID ReadCycle() ;
   COLOR , B/BG 

**-----------------------------------------------------------****
* READCYCLE - VALID del comando READ.                           *
****-----------------------------------------------------------**
FUNCTION ReadCycle

IF LASTKEY() = K_ESC
   IF LOWER(SYS(18)) = "porcdesc" .OR. LOWER(SYS(18)) = "importdesc"
      _CUROBJ = OBJNUM(m.porcdesc)      
      RETURN .F.
   ENDIF
ENDIF

**-----------------------------------------------------------****
* REFRESH - Actualiza la visualizaci¢n del formato, cabecera,   *
*           detalle y pie del movimiento de orden de trabajo.   *
****-----------------------------------------------------------**
PROCEDURE Refresh

=ShowHeader()
=ShowDetail()
=ShowFoot()

**-------------------------------------------------------------------**
**                            ENCABEZADO                             **
**-------------------------------------------------------------------**

**-----------------------------------------------------------****
* VLDSERIE - VALID del campo SERIE.                             *
****-----------------------------------------------------------**
FUNCTION vldSerie    
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_F1, K_BSPACE)
   RETURN .F.
ENDIF

IF ATC(m.serie, control.serieot) = 0 .OR. EMPTY(m.serie)

   STORE "" TO cString
   FOR nCounter = 1 TO LEN(ALLTRIM(control.serieot))
      IF ISALPHA(SUBSTR(ALLTRIM(control.serieot), nCounter, 1))
         cString = cString + "< " + SUBSTR(ALLTRIM(control.serieot), nCounter, 1) + " >" + IIF(nCounter <> LEN(ALLTRIM(control.serieot)), ", ", "")
      ENDIF
   ENDFOR

   =MsgBox(C_MESSA_02 + cString, "", 0, "MESSAGE", "C")
   RETURN .F.
ENDIF

**-----------------------------------------------------------****
* VLDNROOT - VALID del campo NROOT.                             *
****-----------------------------------------------------------**
FUNCTION vldNroOt
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_ESC, K_BSPACE)
   RETURN 
ENDIF

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder, nRecNo
nSelect = SELECT()
cOrder  = ORDER()
nRecNo  = IIF(EOF(), 0, RECNO())

IF m.nroot <= 0
   =MsgBox(C_MESSA_03, "", 0, "MESSAGE", "C")
   RETURN .F.
ENDIF

SELECT ot2
SET ORDER TO TAG indice1 OF ot2.cdx

IF SEEK(m.serie + STR(m.nroot, 7))
   m.cliente    = ot2.cliente
   m.nombreot   = ot2.nombreot
   m.mecanico   = ot2.mecanico
   m.estadoot   = ot2.estadoot
   m.maquina    = ot2.maquina
   m.marca      = ot2.marca
   m.modelo     = ot2.modelo
   m.accesorio  = ot2.accesorio
   m.localrep   = ot2.localrep
   m.referencia = ot2.referencia
ELSE
   =MsgBox(C_MESSA_04, "", 0, "MESSAGE", "C")
  
   STORE 0 TO m.cliente, m.mecanico, m.estadoot, m.maquina, ;
              m.marca, m.modelo, m.localrep  
   STORE "" TO m.obs1, m.obs2, m.obs3, m.referencia, m.nombreot, ;
               m.accesorio

   IF .NOT. EMPTY(ALIAS(nSelect))
      SELECT (nSelect)
      SET ORDER TO TAG (cOrder)
      IF nRecNo <> 0
         GOTO RECORD nRecNo
      ENDIF
   ENDIF

   RETURN .F.
ENDIF

@ 03,12 SAY m.cliente ;
   SIZE 1,5 ;
   PICTURE "99999" ;
   COLOR B/W

@ 03,19 SAY m.nombreot ;
   SIZE 1,26 ;
   PICTURE "@!" ;
   COLOR &color_01

* Imprime el nombre del mec nico.
SELECT mecanico
SET ORDER TO TAG indice1 OF mecanico.cdx

IF SEEK(m.mecanico)
   @ 04,19 SAY PADR(ALLTRIM(mecanico.nombre), 26, CHR(32)) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR &color_01
ELSE
   @ 04,19 SAY REPLICATE(CHR(32), 26) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR &color_01
ENDIF

* Imprime el nombre del almac‚n.
SELECT almacen
SET ORDER TO TAG indice1 OF almacen.cdx

IF SEEK(m.almacen)
   @ 03,63 SAY PADR(ALLTRIM(almacen.nombre), 15, CHR(32)) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR &color_01
ELSE
   @ 03,63 SAY REPLICATE(CHR(32), 15) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR &color_01
ENDIF

* Imprime el nombre del estado de la orden de trabajo.
SELECT estadoot
SET ORDER TO TAG indice1 OF estadoot.cdx

IF SEEK(m.estadoot)
   @ 04,63 SAY PADR(ALLTRIM(estadoot.nombre), 15, CHR(32)) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR &color_01
ELSE
   @ 04,63 SAY REPLICATE(CHR(32), 15) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR &color_01
ENDIF

* Imprime el nombre de la marca y el del modelo.
SELECT maquinas
SET ORDER TO TAG indice1 OF maquinas.cdx

IF .NOT. SEEK(m.maquina) .AND. m.maquina <> 0
   @ 05,12 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR B/W
   =MsgBox(C_MESSA_05 + ALLTRIM(STR(m.maquina, 3)), "", 0, "MESSAGE", "C")
ENDIF

SELECT marcas2
SET ORDER TO TAG indice1 OF marcas2.cdx

IF .NOT. SEEK(m.marca) .AND. m.marca <> 0
   @ 05,12 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR B/W
   =MsgBox(C_MESSA_06 + ALLTRIM(STR(m.marca, 4)), "", 0, "MESSAGE", "C")
ENDIF

SELECT modelos
SET ORDER TO TAG indice1 OF modelos.cdx

IF .NOT. SEEK(m.modelo) .AND. m.modelo <> 0
   @ 05,12 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR B/W
   =MsgBox(C_MESSA_07 + ALLTRIM(STR(m.modelo, 4)), "", 0, "MESSAGE", "C")
ENDIF

@ 05,12 SAY ALLTRIM(maquinas.nombre) + " " + ALLTRIM(marcas2.nombre) + " " + ALLTRIM(modelos.nombre) ;
   SIZE 1,30 ;
   PICTURE "@!" ;
   COLOR B/W

@ 05,44 SAY PADR(ALLTRIM(m.accesorio), 35, CHR(32)) ;
   SIZE 1,35 ;
   PICTURE "@!" ;
   COLOR B/W

* Imprime el nombre del local de reparaci¢n.
IF m.localrep <> 0
   SELECT locales  
   SET ORDER TO TAG indice1 OF locales.cdx

   IF SEEK(m.localrep)
      @ 19,20 SAY PADR(ALLTRIM(locales.nombre), 14, CHR(32)) ;
         SIZE 1,14 ;
         PICTURE "@!" ;
         COLOR &color_01
   ELSE
      @ 19,20 SAY REPLICATE(CHR(32), 14) ;
         SIZE 1,14 ;
         PICTURE "@!" ;
         COLOR &color_01 
   ENDIF
ELSE
   @ 19,20 SAY REPLICATE(CHR(32), 14) ;
      SIZE 1,14 ;
      PICTURE "@!" ;
      COLOR &color_01
ENDIF

SHOW GETS

SELECT cabemot2
SET ORDER TO TAG indice1 OF cabemot2.cdx

IF SEEK(m.serie + STR(m.nroot, 7))
   =MsgBox(C_MESSA_08, "", 0, "MESSAGE", "C")
   
   IF .NOT. EMPTY(ALIAS(nSelect))
      SELECT (nSelect)
      SET ORDER TO TAG (cOrder)
      IF nRecNo <> 0
         GOTO RECORD nRecNo
      ENDIF
   ENDIF

   RETURN .F.
ENDIF

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

**-----------------------------------------------------------****
* VLDFECHA - VALID del campo FECHA.                             *
****-----------------------------------------------------------**
PROCEDURE vldFecha

IF INLIST(LASTKEY(), K_UP, K_LEFT, K_F1, K_BSPACE)
   _CUROBJ = OBJNUM(m.fecha)
ELSE
   SET NOTIFY OFF
ENDIF

**-----------------------------------------------------------****
* WHENFECHA - WHEN del campo FECHA.                             *
****-----------------------------------------------------------**
PROCEDURE whenFecha
SET NOTIFY ON

**-----------------------------------------------------------****
* VLDLSTPRECIO - VALID del campo LSTPRECIO.                     *
****-----------------------------------------------------------**
FUNCTION vldLstPrecio
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_ESC, K_BSPACE) 
   RETURN 
ENDIF

IF .NOT. BETWEEN(m.lstprecio, 1, 5)
   =MsgBox(C_MESSA_09, "", 0, "MESSAGE", "C")
   RETURN .F.
ENDIF

**-----------------------------------------------------------****
* VLDALMACEN - VALID del campo ALMACEN.                         *
****-----------------------------------------------------------**
FUNCTION vldAlmacen
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_ESC, K_BSPACE)
   RETURN 
ENDIF

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder, nRecNo
nSelect = SELECT()
cOrder  = ORDER()
nRecNo  = IIF(EOF(), 0, RECNO())

IF m.almacen <= 0
   @ 03,63 SAY REPLICATE(CHR(32), 15) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR &color_01
   DO alma_pop.spr WITH "m.almacen", 0, .F.
ENDIF

IF m.almacen = 0
   RETURN .F.
ENDIF

SELECT almacen
SET ORDER TO TAG indice1 OF almacen.cdx

IF SEEK(m.almacen)
   @ 03,63 SAY PADR(ALLTRIM(almacen.nombre), 15, CHR(32)) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR &color_01
ELSE
   @ 03,63 SAY REPLICATE(CHR(32), 15) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR &color_01 
   =MsgBox(C_MESSA_10, "", 0, "MESSAGE", "C")
   DO alma_pop.spr WITH "m.almacen", 0, .F.
   SHOW GETS

   SELECT almacen
   SET ORDER TO TAG indice1 OF almacen.cdx

   IF SEEK(m.almacen)
      @ 03,63 SAY PADR(ALLTRIM(almacen.nombre), 15, CHR(32)) ;
         SIZE 1,15 ;
         PICTURE "@!" ;
         COLOR &color_01
   ELSE
      @ 03,63 SAY REPLICATE(CHR(32), 15) ;
         SIZE 1,15 ;
         PICTURE "@!" ;
         COLOR &color_01

      IF .NOT. EMPTY(ALIAS(nSelect))
         SELECT (nSelect)
         SET ORDER TO TAG (cOrder)
         IF nRecNo <> 0
            GOTO RECORD nRecNo
         ENDIF
      ENDIF

      RETURN .F.
   ENDIF   
ENDIF

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

**-----------------------------------------------------------****
* VLDMECANICO - VALID del campo MECANICO.                       *
****-----------------------------------------------------------**
FUNCTION vldMecanico
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_ESC, K_BSPACE)
   RETURN 
ENDIF

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder, nRecNo
nSelect = SELECT()
cOrder  = ORDER()
nRecNo  = IIF(EOF(), 0, RECNO())

IF m.mecanico <= 0
   @ 04,19 SAY REPLICATE(CHR(32), 26) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR &color_01
   DO meca_pop.spr WITH "m.mecanico", 0, .F., ""
ENDIF

IF m.mecanico = 0
   RETURN .F.
ENDIF

SELECT mecanico
SET ORDER TO TAG indice1 OF mecanico.cdx

IF SEEK(m.mecanico)
   @ 04,19 SAY PADR(ALLTRIM(mecanico.nombre), 26, CHR(32)) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR &color_01
ELSE
   @ 04,19 SAY REPLICATE(CHR(32), 26) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR &color_01
   
   =MsgBox(C_MESSA_11, "", 0, "MESSAGE", "C")
   DO meca_pop.spr WITH "m.mecanico", 0, .F., ""
   SHOW GETS

   SELECT mecanico
   SET ORDER TO TAG indice1 OF mecanico.cdx

   IF SEEK(m.mecanico)
      @ 04,19 SAY PADR(ALLTRIM(mecanico.nombre), 26, CHR(32)) ;
         SIZE 1,26 ;
         PICTURE "@!" ;
         COLOR &color_01
   ELSE
      @ 04,19 SAY REPLICATE(CHR(32), 26) ;
         SIZE 1,26 ;
         PICTURE "@!" ;
         COLOR &color_01

      IF .NOT. EMPTY(ALIAS(nSelect))
         SELECT (nSelect)
         SET ORDER TO TAG (cOrder)
         IF nRecNo <> 0
            GOTO RECORD nRecNo
         ENDIF
      ENDIF

      RETURN .F.
   ENDIF   
ENDIF

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

**-----------------------------------------------------------****
* VLDESTADOOT - VALID del campo ESTADOOT.                       *
****-----------------------------------------------------------**
FUNCTION vldEstadoOt
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_ESC, K_BSPACE)
   RETURN 
ENDIF

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder, nRecNo
nSelect = SELECT()
cOrder  = ORDER()
nRecNo  = IIF(EOF(), 0, RECNO())

IF m.estadoot <= 0
   @ 04,63 SAY REPLICATE(CHR(32), 15) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR &color_01
   DO esot_pop.spr WITH "m.estadoot", 0, .F.
ENDIF

IF m.estadoot = 0
   RETURN .F.
ENDIF

SELECT estadoot
SET ORDER TO TAG indice1 OF estadoot.cdx

IF SEEK(m.estadoot)
   @ 04,63 SAY PADR(ALLTRIM(estadoot.nombre), 15, CHR(32)) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR &color_01
ELSE
   @ 04,63 SAY REPLICATE(CHR(32), 15) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR &color_01
   =MsgBox(C_MESSA_12, "", 0, "MESSAGE", "C")
   DO esot_pop.spr WITH "m.estadoot", 0, .F.
   SHOW GETS

   SELECT estadoot
   SET ORDER TO TAG indice1 OF estadoot.cdx

   IF SEEK(m.estadoot)
      @ 04,63 SAY PADR(ALLTRIM(estadoot.nombre), 15, CHR(32)) ;
         SIZE 1,15 ;
         PICTURE "@!" ;
         COLOR &color_01
   ELSE
      @ 04,63 SAY REPLICATE(CHR(32), 15) ;
         SIZE 1,15 ;
         PICTURE "@!" ;
         COLOR &color_01

      IF .NOT. EMPTY(ALIAS(nSelect))
         SELECT (nSelect)
         SET ORDER TO TAG (cOrder)
         IF nRecNo <> 0
            GOTO RECORD nRecNo
         ENDIF
      ENDIF

      RETURN .F.
   ENDIF   
ENDIF

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

**-----------------------------------------------------------****
* VLDVENDEDOR - VALID del campo VENDEDOR.                       *
****-----------------------------------------------------------**
FUNCTION vldVendedor
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_ESC, K_BSPACE)
   RETURN
ENDIF

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder, nRecNo
nSelect = SELECT()
cOrder  = ORDER()
nRecNo  = IIF(EOF(), 0, RECNO())

IF m.vendedor <= 0
   @ 06,19 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR &color_01
   DO vend_pop.spr WITH "m.vendedor", 0, .F.
ENDIF

IF m.vendedor = 0
   RETURN .F.
ENDIF

SELECT vendedor
SET ORDER TO TAG indice1 OF vendedor.cdx

IF SEEK(m.vendedor)
   @ 06,19 SAY PADR(ALLTRIM(vendedor.nombre), 30, CHR(32)) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR &color_01
   m.comision_v = vendedor.comision1
ELSE
   @ 06,19 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR &color_01
   =MsgBox(C_MESSA_13, "", 0, "MESSAGE", "C")
   DO vend_pop.spr WITH "m.vendedor", 0, .F.
   SHOW GETS

   SELECT vendedor
   SET ORDER TO TAG indice1 OF vendedor.cdx

   IF SEEK(m.vendedor)
      @ 06,19 SAY PADR(ALLTRIM(vendedor.nombre), 30, CHR(32)) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR &color_01
      m.comision_v = vendedor.comision1
   ELSE
      @ 06,19 SAY REPLICATE(CHR(32), 30) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR &color_01

      IF .NOT. EMPTY(ALIAS(nSelect))
         SELECT (nSelect)
         SET ORDER TO TAG (cOrder)
         IF nRecNo <> 0
            GOTO RECORD nRecNo
         ENDIF
      ENDIF

      RETURN .F.
   ENDIF   
ENDIF

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

SHOW GETS

**-----------------------------------------------------------****
* VLDLOCALREP - VALID del campo LOCALREP.                       *
****-----------------------------------------------------------**
FUNCTION vldLocalRep
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_ESC, K_BSPACE)
   RETURN 
ENDIF

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder, nRecNo
nSelect = SELECT()
cOrder  = ORDER()
nRecNo  = IIF(EOF(), 0, RECNO())

IF m.localrep <= 0
   @ 19,20 SAY REPLICATE(CHR(32), 14) ;
      SIZE 1,14 ;
      PICTURE "@!" ;
      COLOR &color_01
   DO loca_pop.spr WITH "m.localrep", 0, .F.
ENDIF

IF m.localrep = 0
   RETURN .F.
ENDIF

SELECT locales
SET ORDER TO TAG indice1 OF locales.cdx

IF SEEK(m.localrep)
   @ 19,20 SAY PADR(ALLTRIM(locales.nombre), 14, CHR(32)) ;
      SIZE 1,14 ;
      PICTURE "@!" ;
      COLOR &color_01
ELSE
   @ 19,20 SAY REPLICATE(CHR(32), 14) ;
      SIZE 1,14 ;
      PICTURE "@!" ;
      COLOR &color_01
   =MsgBox(C_MESSA_14, "", 0, "MESSAGE", "C")
   DO loca_pop.spr WITH "m.localrep", 0, .F.
   SHOW GETS

   SELECT locales
   SET ORDER TO TAG indice1 OF locales.cdx

   IF SEEK(m.localrep)
      @ 19,20 SAY PADR(ALLTRIM(locales.nombre), 14, CHR(32)) ;
         SIZE 1,14 ;
         PICTURE "@!" ;
         COLOR &color_01
   ELSE
      @ 19,20 SAY REPLICATE(CHR(32), 14) ;
         SIZE 1,14 ;
         PICTURE "@!" ;
         COLOR &color_01

      IF .NOT. EMPTY(ALIAS(nSelect))
         SELECT (nSelect)
         SET ORDER TO TAG (cOrder)
         IF nRecNo <> 0
            GOTO RECORD nRecNo
         ENDIF
      ENDIF

      RETURN .F.
   ENDIF   
ENDIF

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

**-----------------------------------------------------------****
* VLDREFERENCIA - VALID del campo REFERENCIA.                   *
****-----------------------------------------------------------**
FUNCTION vldReferencia
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_ESC, K_BSPACE)
   RETURN 
ENDIF

IF EMPTY(m.referencia)
   =MsgBox(C_MESSA_15, "", 0, "MESSAGE", "C")
   RETURN .F.
ENDIF

**-----------------------------------------------------------****
* VLDOBS3 - VALID del campo OBS3.                               *
****-----------------------------------------------------------**
FUNCTION vldObs3
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_ESC, K_BSPACE)
   RETURN 
ENDIF

SHOW GETS

=brwLoadDetail()

**-------------------------------------------------------------------**
**                              DETALLE                              **
**-------------------------------------------------------------------**

**-----------------------------------------------------------****
* BRWLOADDETAIL - Abre una ventana de inspecci¢n para cargar    *
*                 el detalle del movimiento de orden de         *
*                 trabajo.                                      *
****-----------------------------------------------------------**
PROCEDURE brwLoadDetail

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder, nRecNo
nSelect = SELECT()
cOrder  = ORDER()
nRecNo  = IIF(EOF(), 0, RECNO())

SELECT temporal
SET ORDER TO 0

IF RECCOUNT() = 0
   INSERT INTO temporal (serie, nroot, articulo, cantidad, precio, impuesto, pimpuesto, mecanico, comision_m, descr_trab) ;
      VALUES ("", 0, "", 0, 0, .F., 0, 0, 0, "")
ENDIF

ON KEY LABEL "F8" DO DeleteLine

DO WHILE LASTKEY() <> K_ESC
  
   @ 10,01 CLEAR TO 17,40 COLOR &color_01    && Descripci¢n.
   @ 10,42 CLEAR TO 17,51 COLOR &color_01    && Cantidad.
   @ 10,53 CLEAR TO 17,67 COLOR &color_01    && Precio Unit.
   @ 10,69 CLEAR TO 17,78 COLOR &color_01    && Importe.

   @ 10,01 FILL TO 17,40 ;
      COLOR &color_01
   @ 10,42 FILL TO 17,51 ;
      COLOR &color_01
   @ 10,53 FILL TO 17,67 ;
      COLOR &color_01
   @ 10,69 FILL TO 17,78 ;
      COLOR &color_01

   GO BOTTOM

   BROWSE WINDOW brwDetail FIELDS ;
      articulo                                   :13:H = "C¢digo"                                 :V = vldCodigo():F ,;
      calc_f1 = SUBSTR(maesprod.nombre, 1, 37) :R:37:H = "Descripci¢n"  :W = .F. ,;
      cantidad                                   :08:H = "Cantidad"     :P = "99999.99"           :V = vldCantidad():F ,;
      precio                                     :15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = whenService() :V = vldPrecio():F  ,;
      calc_f2 = ROUND(precio * cantidad, 0)      :11:H = " Sub-Total"   :P = "999,999,999" :W = whenSubTotal() :V = AddNewLine() :F ,;
      mecanico                                   :03:H = "Mec"          :P = "999"  :W = whenService()  :V = vldbrwMecanico():F ,;
      calc_f3 = SUBSTR(mecanico.nombre, 1, 30) :R:30:H = "Nombre del Mec nico" :W = .F. ,;
      descr_trab                                 :40:H = "Descripci¢n de Trabajo" :P = "@!" :V = AddNewLine() :F ;
      NODELETE NOAPPEND
ENDDO

ON KEY LABEL "F8"

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

=PrintDetail()
=ShowFoot()

**-----------------------------------------------------------****
* VLDCODIGO -  VALID del campo ARTICULO.                        *
****-----------------------------------------------------------**
FUNCTION vldCodigo
IF INLIST(LASTKEY(), 19, 127)
   RETURN .F.
ENDIF

IF INLIST(LASTKEY(), K_DOWN, K_F8)
   RETURN 
ENDIF  

IF EMPTY(articulo)
   PUSH KEY CLEAR

   *-- Procedimiento de inspecci¢n de art¡culos.
   ON KEY LABEL "CTRL+INS" KEYBOARD "{CTRL+W}"
   DO brwMaesp.prg
   ON KEY LABEL "CTRL+INS" 

   POP KEY

   IF LASTKEY() <> K_ESC
      REPLACE temporal.articulo WITH maesprod.codigo
   ELSE 
      RETURN .F.
   ENDIF
ENDIF

PRIVATE cSetExact

IF SET("EXACT") = "OFF"
   SET EXACT ON 
   cSetExact = "OFF"
ELSE
   cSetExact = "ON"
ENDIF

SELECT maesprod
SET ORDER TO TAG indice1 OF maesprod.cdx

IF .NOT. SEEK(temporal.articulo)
   =MsgBox(C_MESSA_16, "", 0, "MESSAGE", "C")

   IF cSetExact = "OFF"
      SET EXACT OFF
   ENDIF

   RETURN .F.
ENDIF

REPLACE temporal.articulo  WITH maesprod.codigo
REPLACE temporal.impuesto  WITH maesprod.impuesto
REPLACE temporal.pimpuesto WITH maesprod.pimpuesto

SELECT servicio
SET ORDER TO indice1 OF servicio.cdx
SET RELATION OFF INTO maesprod

IF .NOT. SEEK(temporal.articulo)
   SELECT temporal
   DO CASE
      CASE m.lstprecio = 1
         REPLACE temporal.precio WITH maesprod.pventag1
      CASE m.lstprecio = 2
         REPLACE temporal.precio WITH maesprod.pventag2
      CASE m.lstprecio = 3
         IF maesprod.pventag3 = 0
            REPLACE temporal.precio WITH maesprod.pventag2
         ELSE
            REPLACE temporal.precio WITH maesprod.pventag3
         ENDIF
      CASE m.lstprecio = 4
         REPLACE temporal.precio WITH maesprod.pventag4
      CASE m.lstprecio = 5
         REPLACE temporal.precio WITH maesprod.pventag5
   ENDCASE      
ELSE
   SELECT temporal 
   IF maesprod.pventag1 <> 0
      REPLACE temporal.precio WITH maesprod.pventag1
   ENDIF
ENDIF

SELECT servicio
SET RELATION TO servicio.articulo INTO maesprod ADDITIVE

IF cSetExact = "OFF"
   SET EXACT OFF
ENDIF

SELECT temporal

**-----------------------------------------------------------****
* VLDCANTIDAD - VALID del campo CANTIDAD.                       *
****-----------------------------------------------------------**
FUNCTION vldCantidad
  
IF cantidad <= 0
   =MsgBox(C_MESSA_17, "", 0, "MESSAGE", "C")
   IF INLIST(LASTKEY(), 5, 19, 127)
      RETURN 
   ELSE
      RETURN .F.
   ENDIF
ENDIF 

IF .NOT. whenService()
   IF temporal.precio <= 0
      =MsgBox(C_MESSA_18, "", 0, "MESSAGE", "C")
      RETURN .F.
   ENDIF
ENDIF

IF temporal.pimpuesto < 0 .OR. temporal.pimpuesto > control.pimpuesto
   =MsgBox(C_MESSA_19, "", 0, "MESSAGE", "C")
   RETURN .F.
ENDIF

=ShowFoot()

**-----------------------------------------------------------****
* VLDPRECIO - VALID del campo PRECIO.                           *
****-----------------------------------------------------------**
FUNCTION vldPrecio
IF precio <= 0
   =MsgBox(C_MESSA_18, "", 0, "MESSAGE", "C")
   RETURN .F.
ENDIF         

=ShowFoot()

**-----------------------------------------------------------****
* VLDBRWMECANICO - VALID del campo MECANICO del detalle.        *
****-----------------------------------------------------------**
FUNCTION vldbrwMecanico
IF INLIST(LASTKEY(), K_UP, K_LEFT, K_ESC, K_BSPACE)
   RETURN 
ENDIF

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder, nRecNo
nSelect = SELECT()
cOrder  = ORDER()
nRecNo  = IIF(EOF(), 0, RECNO())

IF temporal.mecanico <= 0
   DO meca_pop.spr WITH "temporal.mecanico", 0, .T., temporal.articulo
ENDIF

IF temporal.mecanico = 0
   RETURN .F.
ENDIF

SELECT mecanico
SET ORDER TO TAG indice1 OF mecanico.cdx

IF .NOT. SEEK(temporal.mecanico)
   =MsgBox(C_MESSA_11, "", 0, "MESSAGE", "C")

   IF .NOT. EMPTY(ALIAS(nSelect))
      SELECT (nSelect)
      SET ORDER TO TAG (cOrder)
      IF nRecNo <> 0
         GOTO RECORD nRecNo
      ENDIF
   ENDIF

   RETURN .F.
ELSE
   PRIVATE cSetExact, nMecanico, lFound

   IF SET("EXACT") = "OFF"
      SET EXACT ON 
      cSetExact = "OFF"
   ELSE
      cSetExact = "ON"
   ENDIF

   nMecanico = temporal.mecanico
   lFound    = .F.

   SELECT mecancfg
   SET ORDER TO indice1 OF mecancfg.cdx
   SET RELATION OFF INTO maesprod
   SET RELATION OFF INTO servicio

   IF SEEK(temporal.mecanico)
      SCAN WHILE mecancfg.mecanico = nMecanico
         IF mecancfg.articulo = temporal.articulo
            lFound = .T.
            EXIT
         ENDIF
      ENDSCAN
   ENDIF            
   
   SELECT mecancfg
   SET RELATION TO mecancfg.articulo INTO maesprod ADDITIVE
   SET RELATION TO mecancfg.articulo INTO servicio 

   IF cSetExact = "OFF"
      SET EXACT OFF
   ENDIF
   
   IF .NOT. lFound
      =MsgBox(C_MESSA_20, "", 0, "MESSAGE", "C")

      IF .NOT. EMPTY(ALIAS(nSelect))
         SELECT (nSelect)
         SET ORDER TO TAG (cOrder)
         IF nRecNo <> 0
            GOTO RECORD nRecNo
         ENDIF
      ENDIF
      
      RETURN .F.
   ENDIF

ENDIF

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

**-----------------------------------------------------------****
* WHENSERVICE - WHEN del campo PRECIO.                          *
****-----------------------------------------------------------**
FUNCTION whenService

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder, nRecNo, cSetExact, lFound
nSelect = SELECT()
cOrder  = ORDER()
nRecNo  = IIF(EOF(), 0, RECNO())

IF SET("EXACT") = "OFF"
   SET EXACT ON 
   cSetExact = "OFF"
ELSE
   cSetExact = "ON"
ENDIF

SELECT servicio
SET ORDER TO indice1 OF servicio.cdx
SET RELATION OFF INTO maesprod

IF SEEK(temporal.articulo)
   lFound = .T.
ELSE
   lFound = .F.
ENDIF

SET RELATION TO servicio.articulo INTO maesprod

IF cSetExact = "OFF"
   SET EXACT OFF
ENDIF

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

RETURN (lFound)

**-----------------------------------------------------------****
* WHENSUBTOTAL - WHEN del campo calculado SUB-TOTAL.            *
****-----------------------------------------------------------**
FUNCTION whenSubTotal

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder, nRecNo
nSelect = SELECT()
cOrder  = ORDER()
nRecNo  = IIF(EOF(), 0, RECNO())

SELECT servicio
SET ORDER TO indice1 OF servicio.cdx

IF SEEK(temporal.articulo)
   RETURN .F.
ELSE
   RETURN 
ENDIF

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

**-----------------------------------------------------------****
* ADDNEWLINE - Agrega una nueva l¡nea al detalle, siempre y     *
*              cuando la £ltima tecla pulsada sea ENTER.        *
****-----------------------------------------------------------**
PROCEDURE AddNewLine 

IF LASTKEY() = K_ENTER
   IF RECNO() = RECCOUNT()
      KEYBOARD "{CTRL+W}"      
      INSERT INTO temporal (serie, nroot, articulo, cantidad, precio, impuesto, pimpuesto, mecanico, comision_m, descr_trab) ;
         VALUES ("", 0, "", 0, 0, .F., 0, 0, 0, "")
   ENDIF
ENDIF

=ShowFoot()

**-----------------------------------------------------------****
* DELETELINE - Borra una l¡nea al detalle.                      *
****-----------------------------------------------------------**
PROCEDURE DeleteLine

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder
nSelect = SELECT()
cOrder  = ORDER()

SELECT temporal
DELETE 
PACK

IF RECCOUNT() = 0
   INSERT INTO temporal (serie, nroot, articulo, cantidad, precio, impuesto, pimpuesto, mecanico, comision_m, descr_trab) ;
      VALUES ("", 0, "", 0, 0, .F., 0, 0, 0, "")
ENDIF

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
ENDIF

=ShowFoot()

**-------------------------------------------------------------------**
**                                PIE                                **
**-------------------------------------------------------------------**

**-----------------------------------------------------------****
* VLDPORCDESC - VALID del campo PORCDESC.                       *
****-----------------------------------------------------------**
FUNCTION vldPorcDesc

IF m.porcdesc < 0
   =MsgBox(C_MESSA_22, "", 0, "MESSAGE", "C")
   RETURN .F.
ELSE
   IF m.porcdesc > 100
      =MsgBox(C_MESSA_23, "", 0, "MESSAGE", "C")
      RETURN .F.
   ELSE
      IF m.porcdesc > 0
         IF nSubTotal = 0
            =MsgBox(C_MESSA_24, "", 0, "MESSAGE", "C")
            RETURN .F.
         ENDIF

         =ShowFoot()

         IF LASTKEY() <> K_PGDN .OR. LASTKEY() <> K_ENTER
            _CUROBJ = OBJNUM(m.porcdesc)
         ENDIF
      ELSE
         _CUROBJ = OBJNUM(m.importdesc)
      ENDIF
   ENDIF
ENDIF

IF LASTKEY() = K_PGUP
   SHOW GET m.porcdesc
   =brwLoadDetail()
   _CUROBJ= OBJNUM(m.porcdesc)
   RETURN .F.
ENDIF

IF INLIST(LASTKEY(), K_UP, K_PGUP, K_LEFT)
   RETURN .F.
ELSE   
   IF LASTKEY() = K_ENTER .AND. .NOT. EMPTY(m.porcdesc)
      IF nSubTotal = 0
         =MsgBox(C_MESSA_24, "", 0, "MESSAGE", "C")
         _CUROBJ = OBJNUM(m.porcdesc)
         RETURN
      ENDIF
      =ShowFoot()
      =SaveRecord()
   ENDIF
ENDIF

**-----------------------------------------------------------****
* VLDIMPORTDESC -  VALID del campo IMPORTDESC.                  *
****-----------------------------------------------------------**
FUNCTION vldImportDesc

IF m.importdesc < 0
   =MsgBox(C_MESSA_25, "", 0, "MESSAGE", "C")
   RETURN .F.
ELSE
   IF m.importdesc > nSubTotal
      =MsgBox(C_MESSA_25, "", 0, "MESSAGE", "C")
      RETURN .F.
   ELSE
      IF m.importdesc > 0
         =ShowFoot()
         IF LASTKEY() <> K_PGDN .OR. LASTKEY() <> K_ENTER
            _CUROBJ = OBJNUM(m.porcdesc)
         ENDIF
      ELSE
         =ShowFoot()
         _CUROBJ = OBJNUM(m.porcdesc)
      ENDIF
   ENDIF
   
   IF LASTKEY() = K_LEFT
      _CUROBJ = OBJNUM(m.porcdesc)
   ENDIF

   IF LASTKEY() = K_PGUP
      SHOW GET m.importdesc
      =brwLoadDetail()
      _CUROBJ= OBJNUM(m.porcdesc)
      RETURN .F.
   ENDIF

   IF INLIST(LASTKEY(), K_UP, K_PGUP)
      RETURN .F.
   ELSE   
      IF LASTKEY() = K_ENTER
         IF nSubTotal = 0
            =MsgBox(C_MESSA_24, "", 0, "MESSAGE", "C")
            _CUROBJ = OBJNUM(m.porcdesc)
            RETURN
         ENDIF
         =ShowFoot()
         =SaveRecord()
      ENDIF
   ENDIF
ENDIF

**-----------------------------------------------------------****
* SAVERECORD - Graba el movimiento de orden de trabajo.         *
****-----------------------------------------------------------**
PROCEDURE SaveRecord

IF lEditing
   =DeleteRecord()
ENDIF

* Graba el encabecezado.
SELECT cabemot2

INSERT INTO cabemot2 (serie, nroot, fecha, lstprecio, almacen, moneda, tipocambio, vendedor, comision_v, obs1, obs2, obs3, porcdesc, importdesc, descuento, monto_fact) ;
   VALUES (m.serie, m.nroot, m.fecha, m.lstprecio, m.almacen, m.moneda, m.tipocambio, m.vendedor, m.comision_v, m.obs1, m.obs2, m.obs3, m.porcdesc, m.importdesc, m.descuento, m.monto_fact)
   
* Actualiza los datos en la orden de trabajo.
SELECT ot2
SET ORDER TO TAG indice1 OF ot2.cdx

IF SEEK(m.serie + STR(m.nroot, 7))
   REPLACE ot2.mecanico   WITH m.mecanico
   REPLACE ot2.estadoot   WITH m.estadoot
   REPLACE ot2.localrep   WITH m.localrep
   REPLACE ot2.referencia WITH m.referencia
ELSE
   =MsgBox(C_MESSA_01 + m.serie + "-" + ALLTRIM(STR(m.nroot, 7)), "", 0, "MESSAGE", "C")
ENDIF

* Graba el detalle y actualiza la existencia de la mercader¡a.
SELECT temporal

SCAN ALL
   IF .NOT. (EMPTY(temporal.articulo) .OR. EMPTY(temporal.cantidad) .OR. EMPTY(temporal.precio))
      INSERT INTO detamot2 (serie, nroot, articulo, cantidad, precio, impuesto, pimpuesto, mecanico, descr_trab) ;
         VALUES (m.serie, m.nroot, temporal.articulo, temporal.cantidad, temporal.precio, temporal.impuesto, temporal.pimpuesto, temporal.mecanico, temporal.descr_trab)
         
      * Actualiza la existencia de la mercader¡a.
      IF m.localrep == control.id_local
         SELECT maesprod
         SET ORDER TO TAG indice1 OF maesprod.cdx
      
         IF SEEK(temporal.articulo)
            REPLACE maesprod.stock_ot WITH (maesprod.stock_ot + temporal.cantidad)
         ELSE
            =MsgBox(C_MESSA_26 + ALLTRIM(temporal.articulo), "", 0, "MESSAGE", "C")
         ENDIF
         
         SELECT temporal
      ENDIF
   ENDIF
ENDSCAN

CLEAR READ
WAIT WINDOW C_MESSA_21 TIMEOUT 0.75



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

IF .NOT. INLIST(m.tipodocu, 1, 2)
   @ 02,12 SAY REPLICATE(CHR(32), 7) ;
      SIZE 1,7 ;
      PICTURE "@!" ;
      COLOR W/B
   =MsgBox("EL TIPO DE DOCUMENTO DEBE SER:" + "›" + "-------------------------------" + "›" + "1 - CONTADO " + "›" + "2 - CREDITO" , "", 0, "MESSAGE", "C")
   RETURN 0
ENDIF   

DO CASE
   CASE m.tipodocu = 1
      @ 02,12 SAY "CONTADO" ;
         SIZE 1,7 ;
         PICTURE "@!" ;
         COLOR W/B
   CASE m.tipodocu = 2
      @ 02,12 SAY "CREDITO" ;
         SIZE 1,7 ;
         PICTURE "@!" ;
         COLOR W/B
   OTHERWISE
      @ 02,12 SAY REPLICATE(CHR(32),7) ;
         SIZE 1,7 ;
         PICTURE "@!" ;
         COLOR W/B
ENDCASE

*!*********************************************************************
*!
*!      Funci¢n: _vldNroDocu
*!
*!  Llamado por: MKCOMPRA.PRG               
*!
*!  Descripci¢n: Validaci¢n del campo n£mero de documento.    
*!
*!*********************************************************************
FUNCTION vldNroDocu
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN .T.
ENDIF
IF EMPTY(m.nrodocu)
   WAIT WINDOW "EL N§ DEL DOCUMENTO NO PUEDE QUEDAR EN BLANCO !"
   RETURN 0
ENDIF

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
   @ 02,52 SAY REPLICATE(CHR(32),26) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR W/B
   DO prov_pop.spr WITH "m.proveedor", 0, .F.
ENDIF

IF m.proveedor = 0
   RETURN .F.
ENDIF

SELECT proveedo
SET ORDER TO TAG indice1 OF proveedo.cdx
IF SEEK(m.proveedor)
   @ 02,52 SAY PADR(ALLTRIM(proveedo.nombre), 26, CHR(32)) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR W/B
ELSE
   @ 02,52 SAY REPLICATE(CHR(32),26) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR W/B
   WAIT WINDOW "­ CODIGO DE PROVEEDOR INEXISTENTE !"
   DO prov_pop.spr WITH "m.proveedor", 0, .F.
   SHOW GETS
   IF SEEK(m.proveedor)
      @ 02,52 SAY PADR(ALLTRIM(proveedo.nombre), 26, CHR(32)) ;
         SIZE 1,26 ;
         PICTURE "@!" ;
         COLOR W/B
   ELSE
      @ 02,52 SAY REPLICATE(CHR(32),26) ;
         SIZE 1,26 ;
         PICTURE "@!" ;
         COLOR W/B
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

PRIVATE pcSelect, pcOrder, pnRecNo

pcSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT cabeimpo
SET ORDER TO TAG indice1 OF cabeimpo.cdx
IF SEEK(STR(m.tipodocu,1)+m.nrodocu+STR(m.proveedor,5))
   WAIT WINDOW "­ ESTA IMPORTACION YA HA SIDO CARGADA !"
   SELECT (pcSelect)
   SET ORDER TO TAG (pcOrder)
   IF pnRecNo # 0
      GOTO RECORD pnRecNo
   ENDIF
   RELEASE pcSelect, pcOrder, pnRecNo
   RETURN 0
ENDIF
SELECT (pcSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo # 0
   GOTO RECORD pnRecNo
ENDIF
RELEASE pcSelect, pcOrder, pnRecNo


*!*********************************************************************
*!
*!      Funci¢n: _vldTipoCambio
*!
*!  Llamado por: MKCOMPRA.PRG       
*!
*!  Descripci¢n: Validaci¢n del campo m.tipocambio
*!
*!*********************************************************************
FUNCTION _vldCambio
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN
ENDIF

IF m.cambio < 0
   WAIT WINDOW "­ EL TIPO DE CAMBIO DEBE SER MAYOR O IGUAL QUE CERO !"
   RETURN .F.
ENDIF

SHOW GETS

*!*********************************************************************
*!
*!      Funci¢n: _vldTipoCambio
*!
*!  Llamado por: MKCOMPRA.PRG       
*!
*!  Descripci¢n: Validaci¢n del campo m.tipocambio
*!
*!*********************************************************************
FUNCTION _vld2Cambio
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN
ENDIF

IF m.cambio2 < 0
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

SELECT detatemp
SET ORDER TO 0

IF RECCOUNT() = 0
   APPEND BLANK
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
      BROWSE WINDOW (cWindow2) FIELDS ;
         codigo                                     :14:H = "C¢digo"       :P = "@!"               :V = _vldCodigo():F ,;
         calc_f1 = LEFT(descr_arti, 38)             :R:38:H = "Descripci¢n"  :W = .F. ,;
         cantidad                                   :08:H = "Cantidad"     :P="99999.99"           :V = _vldCantidad():F, ;
         precio                                     :13:H = "Precio Unit." :P="@K 99999999.9999"   :V = _vldPrecio():F, ;
         calc_f2 = ROUND(precio * cantidad, 2)      :11:H=" Sub-Total"   :P="9999,999.99" :W = .F. ,;
         calc_f3 = SUBSTR(maesprod.nombre,1,40)   :R:40:H = "Descripci¢n"  :W = .F. ,;
         calc_f4 = IIF(tasa_iva > 0,"   S¡","   No")  :R:08:H = "Impuesto"     :W = .F. ,;    
         tasa_iva                                 :R:06:H = "% Imp."       :P="999.99"             :V = _vldAddNewLine():F  ;
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

DO PrintDetail
DO _InvoiceFoot


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

DO _InvoiceFoot

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

IF EMPTY(codigo)
   PUSH KEY CLEAR

   *-- Procedimiento de inspecci¢n de art¡culos.
   ON KEY LABEL "ENTER" KEYBOARD "{CTRL+W}"
   DO brwMaesp.prg
   ON KEY LABEL "ENTER" 

   POP KEY
  
   IF LASTKEY() <> K_ESCAPE
      REPLACE detatemp.codigo     WITH maesprod.codigo
      REPLACE detatemp.descr_arti WITH maesprod.nombre
      REPLACE detatemp.familia    WITH maesprod.familia
      REPLACE detatemp.rubro      WITH maesprod.rubro
      REPLACE detatemp.subrubro   WITH maesprod.subrubro
      REPLACE detatemp.marca      WITH maesprod.marca
      REPLACE detatemp.unidad     WITH maesprod.unidad
      REPLACE detatemp.procedenci WITH maesprod.procedenci
      REPLACE detatemp.tipo_cod   WITH "A"
   ELSE 
      RETURN .F.
   ENDIF
ENDIF

SELECT maesprod
IF detatemp.tipo_cod <> "A"
   SET ORDER TO TAG &pcMpdOrder
ELSE
   SET ORDER TO TAG "indice1"
ENDIF

PRIVATE pcSetExact

IF SET("EXACT") = "OFF"
   SET EXACT ON 
   pcSetExact = "OFF"
ELSE
   pcSetExact = "ON"
ENDIF

IF SEEK(detatemp.codigo)
   SET ORDER TO TAG "indice1"

   REPLACE detatemp.codigo WITH maesprod.codigo

   IF .NOT. EMPTY(detatemp.codigo) .AND. EMPTY(detatemp.precio) .AND. .NOT. INLIST(detatemp.codigo, "99015", "99016")
      IF m.moneda = 1  &&  Guaran¡es.
         REPLACE detatemp.precio WITH maesprod.pcostog
      ELSE
         IF m.moneda = 2  &&  D¢lares Americanos.
            REPLACE detatemp.precio WITH maesprod.pcostod
         ENDIF
      ENDIF
   ENDIF

   IF .NOT. INLIST(m.tipodocu, 5, 6)
      REPLACE detatemp.tasa_iva  WITH maesprod.pimpuesto
      REPLACE detatemp.tipo_cod  WITH "A"
   ELSE
      REPLACE detatemp.tasa_iva  WITH 0  
      REPLACE detatemp.tipo_cod  WITH "A"
   ENDIF

   @ 19,12 SAY familias.nombre ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/B

*!*	   @ 20,12 SAY "1:     %" + " 2:         %" + " 3:      %" + ALLTRIM(STR(familias.p3, 6))
   @ 20,12 SAY "1: " + ALLTRIM(STR(familias.p1, 6)) + "%" + " 2: " + ALLTRIM(STR(familias.p2, 6)) + " % 3: " + ALLTRIM(STR(familias.p3, 6));
      SIZE 2,30 ;
      PICTURE "@!" ;
      COLOR W/B

   @ 21,12 SAY IIF(maesprod.impuesto, "S¡   " + STR(maesprod.pimpuesto,6,2)+ " %", "No") ;
      SIZE 1,13 ;
      COLOR W/B  

   @ 22,12 SAY maesprod.stock_actu ;
      SIZE 1,11 ;
      PICTURE "99999999.99" ;
      COLOR W/B      
ELSE 

   SET ORDER TO TAG "indice1"

   WAIT WINDOW "­ CODIGO DE ARTICULO INEXISTENTE !"

   IF pcSetExact = "OFF"
      SET EXACT OFF
   ENDIF

   RETURN .F.
ENDIF

IF pcSetExact = "OFF"
   SET EXACT OFF
ENDIF