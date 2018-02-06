* +-------------------------------------------------------------+
* |  IMPORTAC.PRG  Release 1.0  24/10/2005                      |
* |  Copyright (C) Turtle Software Paraguay, 2000-2004          |
* |  All Rights Reserved.                                       |
* |                                                             |
* |  This Module contains Proprietary Information of            |
* |  Turtle Software Paraguay and should be treated             |
* |  as Condifential.                                           |
* +-------------------------------------------------------------+

* +-------------------------------------------------------------+
* |  M¢dulo: IMPORTACIONES.                                     |
* |  Este m¢dulo administra las importaciones.                  |
* |                                                             |
* |  Modificado:                                                |
* |                                                             |
* +-------------------------------------------------------------+
WAIT WINDOW "POR FAVOR, ESPERE MIENTRAS SE CARGA EL MODULO..." NOWAIT

* Declaraci¢n de variables.
STORE 0 TO m.nroot, m.lstprecio, m.almacen, m.moneda, m.tipocambio, ;
           m.vendedor, m.comision_v, m.porcdesc, m.importdesc, ;
           m.descuento, m.monto_fact, m.cliente, m.mecanico, m.estadoot, ;
           m.maquina, m.marca, m.modelo, m.localrep, nGravada, nExenta, ;
           nImpuesto, nSubTotal
STORE "" TO m.serie, m.obs1, m.obs2, m.obs3, m.nombreot, m.accesorio, ;
            m.referencia, temp01
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
#DEFINE K_UPPER_D          68   &&   D, uppercase
#DEFINE K_LOWER_D         100   &&   d, lowercase

*-- Teclas de control.

#DEFINE K_CTRL_A            1   &&   Ctrl-A, Home

*-- Mensajes del sistema.

#DEFINE C_DBFEMPTY		"¨ LA TABLA ESTA VACIA, AGREGAR UN REGISTRO ?"
#DEFINE C_TOPFILE		"­ INICIO DE LA TABLA !"
#DEFINE C_ENDFILE		"­ FIN DE LA TABLA !"
#DEFINE C_DELREC		"¨ ESTA SEGURO DE BORRAR EL REGISTRO ACTUAL ?"
#DEFINE C_MESSA_01      "ESTE MOVIMIENTO DE OT YA HA SIDO FACTURADO, IMPOSIBLE BORRARLO."
#DEFINE C_MESSA_02      "IMPOSIBLE ACTUALIZAR EL SALDO DEL ARTICULO: "
#DEFINE C_MESSA_03      "NO SE HA ENCONTRADO DETALLE A BORRAR."
#DEFINE C_MESSA_04      "NO SE ENCONTRO LA OT N§: "
#DEFINE C_MESSA_05      "NO SE ENCONTRO EL ENCABEZADO DE LA OT N§: "
#DEFINE C_MESSA_06      "ESTE MOVIMIENTO DE OT YA HA SIDO FACTURADO, IMPOSIBLE MODIFICARLO."
#DEFINE C_MESSA_07      "NO EXISTE DETALLE."

* C¢digo de configuraci¢n.
=Setup()

* Dise¤o de pantalla.
=ScreenLayout()

* Programa principal.
DO WHILE .T.  
   =Refresh()
   nKey = INKEY(0, "HM")                       && Tomar INKEY(), ocultar cursor, comprobar rat¢n.
   IF nKey = 0                                 && No hay pulsaci¢n de tecla ni rat¢n.
      LOOP
   ENDIF
   IF nKey = K_ESC                             && Salir del bucle principal.
      EXIT
   ENDIF
   IF nKey = 151                               && Clic sencillo del rat¢n.
      LOOP
   ENDIF

   DO CASE
      CASE nKey = K_F2                         && Agregar registro.
         =Navigate("ADD")
      CASE nKey = K_F3                         && Modificar registro.
         =Navigate("EDIT")
      CASE nKey = K_F4                         && Ordenar registros.
         =Navigate("ORDER")
      CASE nKey = K_F5                         && Buscar datos.
         =Navigate("SEARCH")
      CASE nKey = K_F8                         && Eliminar registro.
         =Navigate("DELETE")
      CASE nKey = K_F10                        && Examinar cabeceras de movimientos
         =Navigate("BROWSEHEADER")             && de ordenes de trabajo.
      CASE nKey = K_UP                         && Siguiente registro. 
         =Navigate("NEXT")
      CASE nKey = K_DOWN                       && Registro anterior.
         =Navigate("PREV")
      CASE nKey = K_LEFT                       && Primer registro.
         =Navigate("TOP")
      CASE nKey = K_RIGHT                      && Ultimo registro.
         =Navigate("END")
      CASE INLIST(nKey, K_UPPER_D, K_LOWER_D)  && Tecla "D" may£scula o min£scula,
         =Navigate("BROWSEDETAIL")             && examinar detalle.
      CASE nKey = K_CTRL_A                     && Actualizar precios.
         =Navigate("UPDATEDETAILPRICE")
   ENDCASE
ENDDO

* C¢digo de limpieza.
=Cleanup()

* +-------------------------------------------------------------+
* |  MS-DOS© Procedimientos y funciones del soporte.            |
* +-------------------------------------------------------------+

**-----------------------------------------------------------****
* SETUP - C¢digo de configuraci¢n.                              *
****-----------------------------------------------------------**
PROCEDURE Setup

* Definici¢n de ventana(s).

IF .NOT. WEXIST("DskMoviOT2")
   DEFINE WINDOW DskMoviOT2 ;
      FROM INT((SROW()-25)/2),INT((SCOL()-80)/2) ;
      TO INT((SROW()-25)/2)+24,INT((SCOL()-80)/2)+79 ;
      NONE ;
      NOCLOSE ;
      NOFLOAT ;
      NOGROW ;
      NOMDI ;
      NOMINIMIZE ;
      NOSHADOW ;
      NOZOOM ;
      COLOR &color_01
ENDIF

IF .NOT. WEXIST("brwDetail")
   DEFINE WINDOW brwDetail ;
      FROM 07,00 ;
      TO 18,79 ;
      TITLE "DETALLE" ;
      SYSTEM ;
      CLOSE ;
      NOFLOAT ;
      NOGROW ;
      NOMINIMIZE ;
      NOSHADOW ;
      ZOOM ;
      COLOR &color_07 
ENDIF

IF .NOT. WEXIST("brwHeader")
   DEFINE WINDOW brwHeader ;
      FROM 01,00 ;
      TO 23,79 ;
      TITLE "< MOVIMIENTOS DE ARTICULOS POR ORDENES DE TRABAJO >" ;
      SYSTEM ;
      CLOSE ;
      NOFLOAT ;
      NOGROW ;
      NOMINIMIZE ;
      NOSHADOW ;
      ZOOM ;
      COLOR &color_02   
ENDIF

* Creaci¢n de tabla(s) temporal(es).

SELECT 0
temp01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp01 (serie      C(01) ,;
                      nroot      N(07) ,;
                      articulo   C(15) ,;
                      cantidad   N(08,2) ,;
                      precio     N(13,4) ,;
                      impuesto   L(01) ,;
                      pimpuesto  N(06,2) ,;
                      mecanico   N(03) ,;
                      comision_m N(06,2) ,;
                      descr_trab C(40))

USE &temp01 ALIAS temporal EXCLUSIVE

INDEX ON serie + STR(nroot, 7) TAG indice1
INDEX ON articulo              TAG indice2

* Ordena tabla(s).
SELECT cabemot
SET ORDER TO TAG indice1 OF cabemot.cdx
GO TOP

SELECT detamot
SET ORDER TO TAG indice1 OF detamot.cdx

SELECT almacen
SET ORDER TO TAG indice1 OF almacen.cdx

SELECT ot
SET ORDER TO TAG indice1 OF ot.cdx

SELECT mecanico
SET ORDER TO TAG indice1 OF mecanico.cdx

SELECT estadoot
SET ORDER TO TAG indice1 OF estadoot.cdx

SELECT maquinas
SET ORDER TO TAG indice1 OF maquinas.cdx

SELECT marcas2
SET ORDER TO TAG indice1 OF marcas2.cdx

SELECT modelos
SET ORDER TO TAG indice1 OF modelos.cdx

SELECT monedas
SET ORDER TO TAG indice1 OF monedas.cdx

SELECT vendedor
SET ORDER TO TAG indice1 OF vendedor.cdx

SELECT locales
SET ORDER TO TAG indice1 OF locales.cdx

SELECT maesprod
SET ORDER TO TAG indice1 OF maesprod.cdx

* Establece relacion(es) entre tablas.

SELECT temporal
SET RELATION TO temporal.articulo INTO maesprod ADDITIVE  
SET RELATION TO temporal.mecanico INTO mecanico ADDITIVE

SELECT cabemot
SET RELATION TO cabemot.serie + STR(cabemot.nroot, 7) INTO ot ADDITIVE

**-----------------------------------------------------------****
* CLEANUP - C¢digo de limpieza.                                 *
****-----------------------------------------------------------**
PROCEDURE Cleanup

* Libera la(s) ventana(s) de la memoria.

IF WEXIST("DskMoviOT2")
   RELEASE WINDOW DskMoviOT2
ENDIF

IF WEXIST("brwDetail")
   RELEASE WINDOW brwDetail
ENDIF

IF WEXIST("brwHeader")
   RELEASE WINDOW brwHeader
ENDIF

* Elimina tabla(s) temporal(es).

IF USED("temporal")
   SELECT temporal 
   USE
ENDIF

DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"

* Quiebra la(s) relacion(es) entre tablas.

SELECT cabemot
SET RELATION OFF INTO ot

**-----------------------------------------------------------****
* SCREENLAYOUT - Dise¤o de pantalla.                            *
****-----------------------------------------------------------**
PROCEDURE ScreenLayout

IF WVISIBLE("DskMoviOT2")
   ACTIVATE WINDOW DskMoviOT2 SAME
ELSE
   ACTIVATE WINDOW DskMoviOT2 NOSHOW
ENDIF

* Limpia la pantalla.

CLEAR

* Dibuja el fondo.

@ 01,00,23,79 BOX REPLICATE(CHR(178), 8) + CHR(178)
@ 01,00 FILL TO 23,79 ;
   COLOR BG/B    

* Imprime el encabezado y el pie de la pantalla.

@ 00,00 FILL TO 00,79 ;
   COLOR N/BG   
 
=GetDate()

IF TYPE("gcCompany") <> "U"
   =Center(00, gcCompany, "N/BG")
ENDIF

@ 24,00 FILL TO 24,79 ;
   COLOR N/BG   

* F1
@ 24,00 SAY "1" ;
   SIZE 1,1 ;
   COLOR W/N

@ 24,01 SAY "Ayuda" ;
   SIZE 1,6 ;
   COLOR N/BG
           
* F2
@ 24,07 SAY " 2" ;
   SIZE 1,2 ;
   COLOR W/N

* F3
@ 24,15 SAY " 3" ;
   SIZE 1,2 ;
   COLOR W/N

* F4
@ 24,23 SAY " 4" ;
   SIZE 1,2 ;
   COLOR W/N

@ 24,25 SAY "Ordena" ;
   SIZE 1,6 ;
   COLOR N/BG

* F5
@ 24,31 SAY " 5" ;
   SIZE 1,2 ;
   COLOR W/N

@ 24,33 SAY "Busca" ;
   SIZE 1,6 ;
   COLOR N/BG

* F6
@ 24,39 SAY " 6" ;
   SIZE 1,2 ;
   COLOR W/N

* F7
@ 24,47 SAY " 7" ;
   SIZE 1,2 ;
   COLOR W/N

* F8
@ 24,55 SAY " 8" ;
   SIZE 1,2 ;
   COLOR W/N

* F9
@ 24,63 SAY " 9" ;
   SIZE 1,2 ;
   COLOR W/N

* F10
@ 24,71 SAY " 10" ;
   SIZE 1,3 ;
   COLOR W/N

* Verifica e imprime la etiqueta de las teclas que est n habilitadas.
IF usercfg("brwMaesp.prg", "Add", .F.)
   @ 24,09 SAY "Agrega" ;
      SIZE 1,6 ;
      COLOR N/BG
ELSE
   @ 24,09 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR N/BG
ENDIF

IF usercfg("brwMaesp.prg", "Edit", .F.)
   @ 24,17 SAY "Modif." ;
      SIZE 1,6 ;
      COLOR N/BG
ELSE
   @ 24,17 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR N/BG
ENDIF

IF usercfg("brwMaesp.prg", "Delete", .F.)
   @ 24,57 SAY "Borra" ;
      SIZE 1,6 ;
      COLOR N/BG
ELSE
   @ 24,57 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR N/BG
ENDIF

IF .NOT. WVISIBLE("DskMoviOT2")
   ACTIVATE WINDOW DskMoviOT2
ENDIF

WAIT CLEAR

**-----------------------------------------------------------****
* CENTER - Impresi¢n centrada de cadenas de texto.              *
****-----------------------------------------------------------**
PROCEDURE Center
PARAMETERS nRow, cText, cColor
nColumn = 40 - (LEN(cText) / 2)
@ nRow, nColumn SAY cText COLOR (cColor)

**-----------------------------------------------------------****
* FORMAT - Dibuja el formato del movimiento de orden de trabajo *
****-----------------------------------------------------------**
PROCEDURE Format     
@ 01,00 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR &color_01
@ 02,00 SAY "³ OT N§...:              Fecha:                Lista N§.:                      ³" COLOR &color_01
@ 03,00 SAY "³ Cliente.:                                    Almac‚n..:                      ³" COLOR &color_01
@ 04,00 SAY "³ Mec nico:                                    Estado OT:                      ³" COLOR &color_01
@ 05,00 SAY "³ M quina.:                                                                    ³" COLOR &color_01
@ 06,00 SAY "³ Vendedor:                                               Comisi¢n:            ³" COLOR &color_01
@ 07,00 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´" COLOR &color_01
@ 08,00 SAY "³ Descripci¢n                            ³ Cantidad ³ Precio Unit.  ³ Importe  ³" COLOR &color_01
@ 09,00 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´" COLOR &color_01
@ 10,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 11,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 12,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 13,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 14,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 15,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 16,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 17,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 18,00 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´" COLOR &color_01
@ 19,00 SAY "³Local de Rep.:                     Ref.:              SUB-TOTALES:            ³" COLOR &color_01
@ 20,00 SAY "³Obs.:                                                 % DESCUENTO:            ³" COLOR &color_01
@ 21,00 SAY "³                                                           I.V.A.:            ³" COLOR &color_01
@ 22,00 SAY "³                                                    TOTAL GENERAL:            ³" COLOR &color_01
@ 23,00 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR &color_01

**-----------------------------------------------------------****
* REFRESH - Actualiza la visualizaci¢n del formato, cabecera,   *
*           detalle y pie del movimiento de orden de trabajo.   *
****-----------------------------------------------------------**
PROCEDURE Refresh

=Format()
=ShowHeader()
=ShowDetail()
=ShowFoot()

**-----------------------------------------------------------****
* SHOWHEADER - Carga la cabecera del movimiento de orden de     *
*              trabajo.                                         *
****-----------------------------------------------------------**
PROCEDURE ShowHeader 

SELECT cabemot
SCATTER MEMVAR MEMO

SELECT ot
SET ORDER TO TAG indice1 OF ot.cdx

IF .NOT. SEEK(m.serie + STR(m.nrobole, 7))
   IF .NOT. EMPTY(m.serie) .AND. m.nrobole <> 0
      WAIT WINDOW "NO SE ENCONTRO LA OT N§: " + m.serie + "-" + ALLTRIM(STR(m.nrobole, 7))
   ENDIF
   
   STORE 0  TO m.cliente, m.mecanico, m.estadoot, m.maquina, m.marca, ;
               m.modelo, m.localrep
   STORE "" TO m.nombreot, m.accesorio, m.referencia
ELSE
   m.cliente    = ot.cliente
   m.nombreot   = ot.nombreot
   m.mecanico   = ot.mecanico
   m.estadoot   = ot.estadoot
   m.maquina    = ot.maquina
   m.marca      = ot.marca
   m.modelo     = ot.modelo
   m.accesorio  = ot.accesorio
   m.localrep   = ot.localrep
   m.referencia = ot.referencia
ENDIF

@ 02,12 SAY m.serie ;
   SIZE 1,1 ;
   PICTURE "@!" ;
   COLOR B/W

@ 02,14 SAY m.nrobole ;
   SIZE 1,7 ;
   PICTURE "9999999" ;
   COLOR B/W

@ 02,32 SAY m.fecha ;
   SIZE 1,10 ;
   PICTURE "@D" ;
   COLOR B/W

@ 02,58 SAY m.lstprecio ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR B/W

@ 03,12 SAY m.cliente ;
   SIZE 1,5 ;
   PICTURE "99999" ;
   COLOR B/W

@ 03,19 SAY PADR(ALLTRIM(m.nombreot), 26, CHR(32)) ;
   SIZE 1,26 ;
   PICTURE "@!" ;
   COLOR W/B

@ 03,58 SAY m.almacen ;
   SIZE 1,3 ;
   PICTURE "999" ;
   COLOR B/W

* Imprime el nombre del almac‚n.
SELECT almacen 
SET ORDER TO TAG indice1 OF almacen.cdx

IF SEEK(m.almacen)
   @ 03,63 SAY PADR(ALLTRIM(almacen.nombre), 15, CHR(32)) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR W/B
ELSE
   @ 03,63 SAY REPLICATE(CHR(32), 15) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR W/B
ENDIF

@ 04,12 SAY m.mecanico ;
   SIZE 1,3 ;
   PICTURE "999" ;
   COLOR B/W

* Imprime el nombre del mecanico.
SELECT mecanico
SET ORDER TO TAG indice1 OF mecanico.cdx

IF SEEK(m.mecanico)
   @ 04,19 SAY PADR(ALLTRIM(mecanico.nombre), 26, CHR(32)) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR W/B
ELSE
   @ 04,19 SAY REPLICATE(CHR(32), 26) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR W/B
ENDIF

@ 04,58 SAY m.estadoot ;
   SIZE 1,3 ;
   PICTURE "999" ;
   COLOR B/W

* Imprime el nombre del estado de la orden de trabajo.
SELECT estadoot
SET ORDER TO TAG indice1 OF estadoot.cdx

IF SEEK(m.estadoot)
   @ 04,63 SAY PADR(ALLTRIM(estadoot.nombre), 15, CHR(32)) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR W/B
ELSE
   @ 04,63 SAY REPLICATE(CHR(32), 15) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR W/B
ENDIF

* Imprime el nombre de la m quina, marca y modelo.
SELECT maquinas
SET ORDER TO TAG indice1 OF maquinas.cdx

IF .NOT. SEEK(m.maquina) .AND. m.maquina <> 0
   @ 05,12 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR B/W
   WAIT WINDOW "NO SE ENCONTRO LA MAQUINA N§: " + ALLTRIM(STR(m.maquina, 3))
ENDIF

SELECT marcas2
SET ORDER TO TAG indice1 OF marcas2.cdx

IF .NOT. SEEK(m.marca) .AND. m.marca <> 0
   @ 05,12 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR B/W
   WAIT WINDOW "NO SE ENCONTRO LA MARCA N§: " + ALLTRIM(STR(m.marca, 4))
ENDIF

SELECT modelos
SET ORDER TO TAG indice1 OF modelos.cdx

IF .NOT. SEEK(m.modelo) .AND. m.modelo <> 0
   @ 05,12 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR B/W
   WAIT WINDOW "NO SE ENCONTRO EL MODELO N§: " + ALLTRIM(STR(m.modelo, 4))
ENDIF

@ 05,12 SAY PADR(ALLTRIM(maquinas.nombre) + " " + ALLTRIM(marcas2.nombre) + " " + ALLTRIM(modelos.nombre), 30, CHR(32)) ;
   SIZE 1,30 ;
   PICTURE "@!" ;
   COLOR B/W

@ 06,12 SAY m.vendedor ;
   SIZE 1,3 ;
   PICTURE "999" ;
   COLOR B/W

* Imprime el nombre del vendedor.
SELECT vendedor
SET ORDER TO TAG indice1 OF vendedor.cdx

IF SEEK(m.vendedor)
   @ 06,19 SAY PADR(ALLTRIM(vendedor.nombre), 30, CHR(32)) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/B
ELSE
   @ 06,19 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/B
ENDIF

@ 06,68 SAY m.comision_v ;
   SIZE 1,6 ;
   PICTURE "999.99" ;
   COLOR B/W

@ 05,44 SAY PADR(ALLTRIM(m.accesorio), 35, CHR(32)) ;
   SIZE 1,35 ;
   PICTURE "@!" ;
   COLOR B/W

@ 19,16 SAY m.localrep ;
   SIZE 1,2 ;
   PICTURE "99" ;
   COLOR B/W

* Imprime el nombre del local de reparaci¢n.
IF m.localrep <> 0
   SELECT locales  
   SET ORDER TO TAG indice1 OF locales.cdx

   IF SEEK(m.localrep)
      @ 19,20 SAY PADR(ALLTRIM(locales.nombre), 14, CHR(32)) ;
         SIZE 1,14 ;
         PICTURE "@!" ;
         COLOR W/B
   ELSE
      @ 19,20 SAY REPLICATE(CHR(32), 14) ;
         SIZE 1,14 ;
         PICTURE "@!" ;
         COLOR W/B
   ENDIF
ELSE
   @ 20,20 SAY REPLICATE(CHR(32), 14) ;
      SIZE 1,14 ;
      PICTURE "@!" ;
      COLOR W/B
ENDIF

@ 19,42 SAY m.referencia ;
   SIZE 1,10 ;
   PICTURE "@!" ;
   COLOR B/W

@ 20,07 SAY PADR(ALLTRIM(m.obs1), 37, CHR(32)) ;
   SIZE 1,37 ;
   PICTURE "@!" ;
   COLOR B/W

@ 21,07 SAY PADR(ALLTRIM(m.obs2), 37, CHR(32)) ;
   SIZE 1,37 ;
   PICTURE "@!" ;
   COLOR B/W
   
@ 22,07 SAY PADR(ALLTRIM(m.obs3), 37, CHR(32)) ;
   SIZE 1,37 ;
   PICTURE "@!" ;
   COLOR B/W

**-----------------------------------------------------------****
* SHOWDETAIL - Carga el detalle del movimiento de orden de      *
*              trabajo y lo visualiza.                          *
****-----------------------------------------------------------**
PROCEDURE ShowDetail

SELECT temporal  &&  Vac¡a la tabla temporal que contiene  el
ZAP              &&  detalle de art¡culos.

SELECT detamot
SET ORDER TO TAG indice1 OF detamot.cdx

IF SEEK(m.serie + STR(m.nrobole, 7))
   SCAN WHILE serie + STR(m.nrobole, 7) = detamot.serie + STR(detamot.nroot, 7)
      INSERT INTO temporal (serie, nroot, articulo, cantidad, precio, pimpuesto, impuesto, mecanico, comision_m, descr_trab) ;
         VALUES (detamot.serie, detamot.nroot, detamot.articulo, detamot.cantidad, detamot.precio, detamot.pimpuesto, detamot.impuesto, detamot.mecanico, detamot.comision_m, detamot.descr_trab)
   ENDSCAN
ELSE
   IF .NOT. EMPTY(m.serie) .AND. m.nrobole <> 0
      WAIT WINDOW "ESTE MOVIMIENTO DE OT NO POSEE DETALLE, BORRELO Y VUELVA A CARGARLO"
   ENDIF
ENDIF

=PrintDetail()

**-----------------------------------------------------------****
* PRINTDETAIL - Imprime el detalle de art¡culos.                *
****-----------------------------------------------------------**
PROCEDURE PrintDetail

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder, nRecNo
nSelect = SELECT()
cOrder  = ORDER()
nRecNo  = IIF(EOF(), 0, RECNO())

* Declaraci¢n de constantes.
#DEFINE c_row    9
#DEFINE c_column 1

SELECT temporal  
SET ORDER TO 0
GO TOP

SCAN WHILE RECNO() <= 8 .AND. .NOT. (EMPTY(articulo) .OR. EMPTY(cantidad) .OR. EMPTY(precio))
   @ c_row + RECNO(), c_column + 1  SAY IIF(EMPTY(descr_trab), SUBSTR(maesprod.nombre, 1, 39), SUBSTR(descr_trab, 1, 39)) COLOR B/W
   @ c_row + RECNO(), c_column + 41 SAY cantidad                       PICTURE "999,999.99"                               COLOR B/W
   @ c_row + RECNO(), c_column + 52 SAY precio                         PICTURE "99,999,999.9999"                          COLOR B/W
   @ c_row + RECNO(), c_column + 68 SAY ROUND(precio * cantidad, 0)    PICTURE "99,999,999"                               COLOR B/W 
ENDSCAN

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

**-----------------------------------------------------------****
* SHOWFOOT - Imprime el pie del documento.                      *
****-----------------------------------------------------------**
PROCEDURE ShowFoot

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder, nRecNo
nSelect = SELECT()
cOrder  = ORDER()
nRecNo  = IIF(EOF(), 0, RECNO())

STORE 0 TO m.monto_fact, nGravada, nExenta, nImpuesto, nSubTotal, ;
           nDescGrav, nDescExen, nSubTota1

SELECT temporal  

SCAN ALL
   DO CASE
      CASE impuesto .AND. pimpuesto > 0 .AND. pimpuesto < 10
         nGravada = nGravada + ROUND(precio * cantidad, 0) * (pimpuesto * (control.pimpuesto / 100))
         nExenta  = nExenta  + ROUND(precio * cantidad, 0) * (1 - (pimpuesto * (control.pimpuesto / 100)))
      CASE impuesto .AND. pimpuesto = control.pimpuesto
         nGravada = nGravada + ROUND(precio * cantidad, 0)            
      CASE .NOT. impuesto .AND. pimpuesto = 0
         nExenta  = nExenta  + ROUND(precio * cantidad, 0)
   ENDCASE
ENDSCAN

nSubTotal = nGravada + nExenta
  
IF m.importdesc > 0 .AND. m.porcdesc = 0
   nDescGrav    = ROUND(m.importdesc * ROUND(nGravada * 100 / nSubTotal, 0) / 100, 0)
   nDescExen    = m.importdesc - nDescGrav
   nSubTota1    = nSubTotal - m.importdesc
   nImpuesto    = ROUND((nGravada - nDescGrav) * (control.pimpuesto / 100), 0)
   m.monto_fact = nSubTota1 + nImpuesto
   m.descuento  = ROUND(m.importdesc / nSubTotal * 100, 4)
ELSE
   IF m.porcdesc > 0
      nDescGrav    = ROUND((nGravada * (m.porcdesc / 100)), 0)
      nDescExen    = ROUND((nGravada + nExenta) * (m.porcdesc / 100), 0) - nDescGrav
      m.importdesc = nDescGrav + nDescExen
      nSubTota1    = (nGravada + nExenta) - (nDescGrav + nDescExen)
      nImpuesto    = ROUND(ROUND(nGravada * (1 - m.porcdesc / 100), 0) * (control.pimpuesto / 100), 0)
      m.monto_fact = nSubTota1 + nImpuesto
   ELSE
      IF m.importdesc = 0 .AND. m.porcdesc = 0
         nImpuesto    = ROUND(nGravada * (control.pimpuesto / 100), 0)
         m.monto_fact = nSubTotal + nImpuesto
      ENDIF
   ENDIF
ENDIF

@ 19,68 SAY nSubTotal ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR B/W

@ 20,46 SAY m.porcdesc ;
   SIZE 1,8 ;
   PICTURE "999.9999" ;
   COLOR B/W

@ 20,68 SAY m.importdesc ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR B/W

@ 21,68 SAY nImpuesto ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR B/W

@ 22,68 SAY m.monto_fact ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W 

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

SELECT cabemot

**-----------------------------------------------------------****
* NAVIGATE - Administra pulsaciones de teclas.                  *
****-----------------------------------------------------------**
PROCEDURE Navigate
PARAMETER cBtnName

PUSH KEY CLEAR

DO CASE
   CASE UPPER(cBtnName) = "TOP"
      GO TOP
      WAIT WINDOW C_TOPFILE NOWAIT
   CASE UPPER(cBtnName) = "PREV"
      IF !BOF()
         SKIP -1
      ENDIF
      IF BOF()
         WAIT WINDOW C_TOPFILE NOWAIT
         GO TOP
      ENDIF
   CASE UPPER(cBtnName) = "NEXT"
      IF !EOF()
         SKIP 1
      ENDIF
      IF EOF()
         WAIT WINDOW C_ENDFILE NOWAIT
         GO BOTTOM
      ENDIF
   CASE UPPER(cBtnName) = "END"
      GO BOTTOM
      WAIT WINDOW C_ENDFILE NOWAIT
   CASE UPPER(cBtnName) = "ADD"
      DO mkmovot2.prg WITH "ADD"     
   CASE UPPER(cBtnName) = "EDIT"
      IF EOF()
         IF MsgBox(C_DBFEMPTY, "", 4, "MESSAGE", "C") = 6
            =Navigate("Add")
         ENDIF         
         RETURN
      ENDIF

      IF ot.estadoot = 6   && Facturado.
         =MsgBox(C_MESSA_06, "", 0, "MESSAGE", "C")
         RETURN
      ENDIF
      
      DO mkmovot2.prg WITH "EDIT"     
   CASE UPPER(cBtnName) = "DELETE"
      IF EOF()
         IF MsgBox(C_DBFEMPTY, "", 4, "MESSAGE", "C") = 6
            =Navigate("ADD")
         ENDIF         
         RETURN
      ENDIF

      IF ot.estadoot = 6   && Facturado.
         =MsgBox(C_MESSA_01, "", 0, "MESSAGE", "C")
         RETURN
      ENDIF

      IF MsgBox(C_DELREC, "", 4, "ALERT", "C") = 6
         =DeleteRecord()
         IF EOF()
            GO BOTTOM
            IF EOF() .AND. BOF() &&.AND. DELETE()
               IF MsgBox(C_DBFEMPTY, "", 4, "MESSAGE", "C") = 6
                  =Navigate("ADD")
               ENDIF         
               RETURN
            ENDIF
         ENDIF
      ENDIF
   CASE UPPER(cBtnName) = "BROWSEHEADER"
      =brwHeader()
   CASE UPPER(cBtnName) = "BROWSEDETAIL"
      =brwDetail()
   CASE UPPER(cBtnName) = "ORDER"
      IF EOF()
         IF MsgBox(C_DBFEMPTY, "", 4, "MESSAGE", "C") = 6
            =Navigate("ADD")
         ENDIF         
         RETURN
      ENDIF

      DO orden07.spr
   CASE UPPER(cBtnName) = "SEARCH"
      IF EOF()
         IF MsgBox(C_DBFEMPTY, "", 4, "MESSAGE", "C") = 6
            =Navigate("ADD")
         ENDIF         
         RETURN
      ENDIF
      
      =Switch()
ENDCASE

POP KEY

**-----------------------------------------------------------****
* DELETERECORD - Borra el movimiento de orden de trabajo.       *
****-----------------------------------------------------------**
PROCEDURE DeleteRecord

* Borra el detalle y actualiza la existencia de mercader¡a.
SELECT detamot
SET ORDER TO TAG indice1 OF detamot.cdx

IF SEEK(m.serie + STR(m.nrobole, 7))
   SCAN WHILE m.serie + STR(m.nrobole, 7) = detamot.serie + STR(detamot.nroot, 7)
      * Actualiza la existencia de la mercader¡a.
      IF m.localrep == control.id_local
         SELECT maesprod
         SET ORDER TO TAG indice1 OF maesprod.cdx

         IF SEEK(detamot.articulo)
            REPLACE maesprod.stock_ot WITH (maesprod.stock_ot - detamot.cantidad)
         ELSE
            =MsgBox(C_MESSA_02 + ALLTRIM(detamot.articulo), "", 0, "MESSAGE", "C")
         ENDIF
   
         SELECT detamot
      ENDIF
      DELETE
   ENDSCAN
ELSE
   IF EMPTY(m.serie) .AND. m.nrobole <> 0
      =MsgBox(C_MESSA_03, "", 0, "MESSAGE", "C")
   ENDIF
ENDIF
  
* Cambia el estado de la orden de trabajo
SELECT ot
SET ORDER TO TAG indice1 OF ot.cdx

IF SEEK(m.serie + STR(m.nrobole, 7))
   REPLACE ot.estadoot WITH 5   && Terminado.
ELSE
   =MsgBox(C_MESSA_04 + m.serie + "-" + ALLTRIM(STR(m.nrobole, 7)), "", 0, "MESSAGE", "C")
ENDIF

* Borra el encabezado.
SELECT cabemot
SET ORDER TO TAG indice1 OF cabemot.cdx

IF SEEK(m.serie + STR(m.nrobole, 7))
   SCAN WHILE m.serie + STR(m.nrobole, 7) = cabemot.serie + STR(cabemot.nroot, 7)
      DELETE
   ENDSCAN
ELSE
   IF EMPTY(m.serie) .AND. m.nrobole <> 0
      =MsgBox(C_MESSA_05 + m.serie + "-" + ALLTRIM(STR(m.nrobole, 7)), "", 0, "MESSAGE", "C")
   ENDIF
ENDIF

**-----------------------------------------------------------****
* BRWHEADER - Examina la cabecera de movimientos de orden de    *
*             trabajo.                                          *
****-----------------------------------------------------------**
FUNCTION brwHeader

ON KEY LABEL "F4" DO orden07.spr
ON KEY LABEL "F5" DO Switch

SELECT cabemot

BROWSE WINDOW brwHeader FIELDS ;
   calc_f1 = serie + " " + STR(nroot, 7) :R:09:H = "OT N§" ,;
   fecha                                 :R:10:P = "@D"          :H = "Fecha" ,;
   monto_fact                            :R:11:P = "999,999,999" :H = "Importe" ,;
   calc_f2 = SUBSTR(ot2.nombreot, 1, 40) :R:40:P = "@!"          :H = "Cliente" ;
   NOAPPEND NODELETE NOMODIFY
   
ON KEY LABEL "F4" 
ON KEY LABEL "F5"

**-----------------------------------------------------------****
* BRWDETAIL - Examina el detalle de art¡culos.                  *
****-----------------------------------------------------------**
PROCEDURE brwDetail 

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder, nRecNo
nSelect = SELECT()
cOrder  = ORDER()
nRecNo  = IIF(EOF(), 0, RECNO())

SELECT temporal  
GO TOP

IF RECCOUNT() <> 0
   BROWSE WINDOW brwDetail  FIELDS ;
      calc_f0 = SUBSTR(articulo, 1, 13)        :R:13:H = "C¢digo" ,;
      calc_f1 = IIF(EMPTY(descr_trab), SUBSTR(maesprod.nombre, 1, 37), SUBSTR(descr_trab, 1, 37)) :R:37:H = "Descripci¢n"  :P = "@!" :W = .F. ,;
      cantidad                                 :R:08:H = "Cantidad"     :P = "99999.99" ,;
      precio                                   :R:15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = .F. ,;
      calc_f2 = ROUND(precio * cantidad, 0)    :R:11:H = " Sub-Total"    :P = "999,999,999" ,;
      mecanico                                 :R:03:H = "Mec"          :P = "999" ,; 
      calc_f3 = SUBSTR(mecanico.nombre, 1, 30) :R:30:H = "Nombre del Mec nico" :P = "@!" :W = .F. ,;
      calc_f4 = IIF(impuesto, "   S¡", "")     :R:08:H = "Impuesto"     :W = .F. ,;
      pimpuesto                                :R:06:H = "% Imp."       :P = "999.99" ;
      NOAPPEND NODELETE NOMODIFY
ELSE
   =MsgBox(C_MESSA_07, "", 0, "MESSAGE", "C")
ENDIF

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

**-----------------------------------------------------------****
* SWITCH - B£squeda de datos.                                   *
****-----------------------------------------------------------**
PROCEDURE Switch

DO CASE
   CASE LOWER(TAG()) = "indice1"
      DO buscar22.spr
   CASE LOWER(TAG()) = "indice2"
      DO buscar23.spr
ENDCASE