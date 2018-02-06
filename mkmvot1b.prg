* +-------------------------------------------------------------+
* |  MKMVOT1A.PRG  Release 1.0  23/08/2004                      |
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
STORE 0 TO m.nrobole, m.lstprecio, m.almacen, m.moneda, m.tipocambio, ;
           m.vendedor, m.comision_1, m.porcdesc, m.importdesc, ;
           m.descuento, m.monto_fact, m.cliente, m.mecanico, m.estadoot, ;
           m.maquina, m.marca, m.modelo, m.localrep, nGravada, nExenta, ;
           nImpuesto, nSubTotal, m.tipobole, m.comision_1, m.comision_2, m.comision_3
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
#DEFINE C_NOEDIT        "ESTA OT YA FIGURA ENTRE LAS MAQUINAS TERMINADAS."
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
#DEFINE C_MESSA_28      "SI DESEA REALIZAR ALGUN DESCUENTO, CONSULTE CON EL ADMINISTRADOR."

IF UPPER(cWhatToDo) = "ADD"
   SELECT cabemot2
   SCATTER MEMVAR MEMO BLANK
   m.serie = SUBSTR(control.serieot, 1, 1)   

   lAdding     = .T.
   lEditing    = .F.
   lDeleting   = .F.
   m.fecha     = DATE()
   m.lstprecio = 1
   m.almacen   = 4
   m.localrep  = 1

   SELECT temporal
   ZAP
ELSE
   IF UPPER(cWhatToDo) = "EDIT"
      SELECT cabemot2
      SCATTER MEMVAR MEMO
      
      SELECT ot
      SET ORDER TO TAG indice1 OF ot.cdx

      IF .NOT. SEEK(m.serie + STR(m.nrobole, 7))
         IF EMPTY(m.serie) .AND. m.nrobole = 0
            =MsgBox(C_MESSA_01 + m.serie + "-" + ALLTRIM(STR(m.nrobole, 7)), "", 0, "MESSAGE", "C")
         ENDIF

         STORE 0 TO m.almacen, m.cliente, m.mecanico, m.estadoot, m.maquina, ;
                    m.marca, m.modelo, m.localrep, nGravada, nExenta, nImpuesto, nSubTotal
         STORE "" TO m.referencia
      ELSE
         m.cliente    = ot.cliente
         m.nombreot   = ot.nombreot
         m.mecanico   = ot.mecanico
         m.estadoot   = ot.estadoot
         m.maquina    = ot.maquina
         m.marca      = ot.marca
         m.modelo     = ot.modelo
         m.accesorio  = ot.accesorio
         m.localrep   = IIF(ot.localrep = 0, 1, ot.localrep)
         m.referencia = ot.chasis
      ENDIF

      lAdding    = .F.
      lEditing   = .T.
      lDeleting  = .F.
      m.lstprecio = IIF(m.lstprecio = 0, 1, m.lstprecio)
   ENDIF
ENDIF

SELECT cabemot2

=Format()

IF UPPER(cWhatToDo) = "EDIT"
   =Refresh()
ENDIF

@ 02,12 GET m.serie ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "@A!" ;
   WHEN lAdding ;
   VALID vldSerie() ;
   COLOR &color_01

@ 02,14 GET m.nrobole ;
   SIZE 1,7 ;
   DEFAULT 0 ;
   PICTURE "9999999" ;
   WHEN lAdding ;
   VALID vldNroOt() ;
   COLOR &color_01

@ 02,32 GET m.fecha ;
   SIZE 1,10 ;
   DEFAULT DATE() ;
   PICTURE "@D" ;
   WHEN .F. ;
   VALID vldFecha() ;
   COLOR &color_01
*!*	   WHEN whenFecha()

@ 02,58 GET m.lstprecio ;
   SIZE 1,1 ;
   DEFAULT 1 ;
   PICTURE "9" ;
   WHEN .F. ;
   VALID vldLstPrecio() ;
   COLOR &color_01

@ 03,58 GET m.almacen ;
   SIZE 1,3 ;
   DEFAULT 1 ;
   PICTURE "999" ;
   WHEN .F. ;
   VALID vldAlmacen() ;
   COLOR &color_01
*!*	   WHEN lAdding .OR. lEditing 

@ 04,12 GET m.mecanico ;
   SIZE 1,3 ;
   DEFAULT 1 ;
   PICTURE "999" ;
   WHEN lAdding .OR. lEditing ;
   VALID vldMecanico() ;
   COLOR &color_01

@ 04,58 GET m.estadoot ;
   SIZE 1,3 ;
   DEFAULT 1 ;
   PICTURE "999" ;
   WHEN .F. ;
   VALID vldEstadoOt() ;
   COLOR &color_01
*   WHEN lAdding .OR. lEditing ;

@ 06,12 GET m.vendedor ;
   SIZE 1,3 ;
   DEFAULT 0 ;
   PICTURE "999" ;
   WHEN lAdding ;
   VALID vldVendedor() ;
   COLOR &color_01

*   WHEN lAdding .OR. lEditing ;
   
*@ 06,68 GET m.comision_v ;
*   SIZE 1,6 ;
*   DEFAULT 0 ;
*   PICTURE "999.99" ;
*   WHEN .F. ;
*   VALID _vldComision_V() ;
*   COLOR &color_01

@ 19,16 GET m.localrep ;
   SIZE 1,2 ;
   DEFAULT 1 ;
   PICTURE "99" ;
   WHEN .F. ;
   VALID vldLocalRep() ;
   COLOR &color_01
*!*	   WHEN lAdding .OR. lEditing

@ 19,42 GET m.referencia ;
   SIZE 1,10 ;
   DEFAULT 1 ;
   PICTURE "@!" ;
   WHEN lAdding .OR. lEditing ;
   VALID vldReferencia() ;
   COLOR &color_01
*   WHEN (lAdding .OR. lEditing) .AND. m.localrep <> control.id_local ;

@ 20,07 GET m.obs1 ;
   SIZE 1,37 ;
   PICTURE "@!" ;
   COLOR &color_01

@ 21,07 GET m.obs2 ;
   SIZE 1,37 ;
   PICTURE "@!" ;
   COLOR &color_01

@ 22,07 GET m.obs3 ;
   SIZE 1,37 ;
   PICTURE "@!" ;
   VALID vldObs3() ;
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

IF m.nrobole <= 0
   =MsgBox(C_MESSA_03, "", 0, "MESSAGE", "C")
   RETURN .F.
ENDIF

SELECT ot
SET ORDER TO TAG indice1 OF ot.cdx

IF SEEK(m.serie + STR(m.nrobole, 7))
   m.cliente    = ot.cliente
   m.nombreot   = ot.nombreot
   m.mecanico   = ot.mecanico
   m.estadoot   = 15  && Presupuesto.
*  m.estadoot   = ot.estadoot
   m.maquina    = ot.maquina
   m.marca      = ot.marca
   m.modelo     = ot.modelo
   m.accesorio  = ot.accesorio
*   m.localrep   = IIF(ot.localrep = 0, 1, ot.localrep)
   m.referencia = ot.chasis

   * Recupera lista de precios con la cual el cliente opera.
   SELECT clientes
   SET ORDER TO 1
   IF SEEK(m.cliente)
      m.lstprecio = clientes.lista
   ENDIF

   SELECT ot
   SET ORDER TO 1
   
   SELECT cabemot
   SET ORDER TO TAG indice1 OF cabemot.cdx
   IF SEEK(STR(2, 1) + m.serie + STR(m.nrobole, 7))
      =MsgBox(C_NOEDIT, "", 0, "MESSAGE", "C")

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

IF SEEK(STR(2, 1) + m.serie + STR(m.nrobole, 7))
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
   m.comision_1 = vendedor.comision1
   m.comision_2 = vendedor.comision2
   m.comision_3 = vendedor.comision3      
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
      m.comision_1 = vendedor.comision1
      m.comision_2 = vendedor.comision2
      m.comision_3 = vendedor.comision3      
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

*!* Deshabilitado el 25/07/2013 porque el campo de chasis va a usarse
*!* para colocar el numero de caja.
*!* IF EMPTY(m.referencia)
*!*   =MsgBox(C_MESSA_15, "", 0, "MESSAGE", "C")
*!*   RETURN .F.
*!* ENDIF

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
   INSERT INTO temporal (tipobole, serie, nrobole, articulo, cantidad, precio, impuesto, pimpuesto, mecanico, comision_m, descr_trab) ;
      VALUES (0, "", 0, "", 0, 0, .F., 0, 0, 0, "")
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
      mecanico                                   :03:H = "Mec"          :P = "999"  :W = whenService() :V = vldbrwMecanico():F ,;
      calc_f3 = SUBSTR(mecanico.nombre, 1, 30) :R:30:H = "Nombre del Mec nico" :W = whenService() ,;
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

*!*	   *-- Procedimiento de inspecci¢n de art¡culos.
*!*	   ON KEY LABEL "CTRL+INS" KEYBOARD "{CTRL+W}"
*!*	   DO brwMaesp.prg
*!*	   ON KEY LABEL "CTRL+INS" 

   m.articulo = ""
   DO brwmaesp WITH "m.articulo"

   POP KEY

   IF LASTKEY() <> K_ESC
      REPLACE temporal.articulo WITH m.articulo
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
      INSERT INTO temporal (tipobole, serie, nrobole, articulo, cantidad, precio, impuesto, pimpuesto, mecanico, comision_m, descr_trab) ;
         VALUES (0, "", 0, "", 0, 0, .F., 0, 0, 0, "")
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
   INSERT INTO temporal (tipobole, serie, nrobole, articulo, cantidad, precio, impuesto, pimpuesto, mecanico, comision_m, descr_trab) ;
      VALUES (0, "", 0, "", 0, 0, .F., 0, 0, 0, "")
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

         IF gnUser <> 1 THEN   && Si no es el Administrador no puede hacer descuento.
            =MsgBox(C_MESSA_28, "", 0, "MESSAGE", "C")
            RETURN 0
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
         IF gnUser <> 1 THEN   && Si no es el Administrador no puede hacer descuento.
            =MsgBox(C_MESSA_28, "", 0, "MESSAGE", "C")
            RETURN 0
         ENDIF

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

INSERT INTO cabemot2 (tipobole, serie, nrobole, fecha, lstprecio, almacen, moneda, tipocambio, vendedor, comision_1, comision_2, comision_3, obs1, obs2, obs3, porcdesc, importdesc, descuento, monto_fact) ;
   VALUES (2, m.serie, m.nrobole, m.fecha, m.lstprecio, m.almacen, m.moneda, m.tipocambio, m.vendedor, m.comision_1, m.comision_2, m.comision_3, m.obs1, m.obs2, m.obs3, m.porcdesc, m.importdesc, m.descuento, m.monto_fact)
   
* Actualiza los datos en la orden de trabajo.
SELECT ot
SET ORDER TO TAG indice1 OF ot.cdx

IF SEEK(m.serie + STR(m.nrobole, 7))
   REPLACE ot.mecanico WITH m.mecanico
   REPLACE ot.estadoot WITH m.estadoot
   REPLACE ot.localrep WITH m.localrep
   REPLACE ot.chasis   WITH m.referencia
ELSE
   =MsgBox(C_MESSA_01 + m.serie + "-" + ALLTRIM(STR(m.nrobole, 7)), "", 0, "MESSAGE", "C")
ENDIF

* Graba el detalle y actualiza la existencia de la mercader¡a.
SELECT temporal

SCAN ALL
   IF .NOT. (EMPTY(temporal.articulo) .OR. EMPTY(temporal.cantidad) .OR. EMPTY(temporal.precio))
      INSERT INTO detamot2 (tipobole, serie, nrobole, articulo, cantidad, precio, impuesto, pimpuesto, mecanico, descr_trab) ;
         VALUES (2, m.serie, m.nrobole, temporal.articulo, temporal.cantidad, temporal.precio, temporal.impuesto, temporal.pimpuesto, temporal.mecanico, ;
         temporal.descr_trab)
         
      * Actualiza la existencia de la mercader¡a.
      *IF m.localrep == control.id_local
      *   SELECT maesprod
      *   SET ORDER TO TAG indice1 OF maesprod.cdx
      
      *   IF SEEK(temporal.articulo)
      *      REPLACE maesprod.stock_ot WITH (maesprod.stock_ot + temporal.cantidad)
      *   ELSE
      *      =MsgBox(C_MESSA_26 + ALLTRIM(temporal.articulo), "", 0, "MESSAGE", "C")
      *   ENDIF
      *   
      *   SELECT temporal
      *ENDIF
   ENDIF
ENDSCAN

CLEAR READ
WAIT WINDOW C_MESSA_21 TIMEOUT 0.75