* +-------------------------------------------------------------+
* |  IMPORTAC.PRG  Release 1.0  14/02/2006                      |
* |  Copyright (C) Turtle Software Paraguay, 2000-2006          |
* |  All Rights Reserved.                                       |
* |                                                             |
* |  This Module contains Proprietary Information of            |
* |  Turtle Software Paraguay and should be treated             |
* |  as Confidential.                                           |
* +-------------------------------------------------------------+

* +-------------------------------------------------------------+
* |  Module  : IMPORTACIONES                                    |
* |  Comment :                                                  |
* |  Modified:                                                  |
* +-------------------------------------------------------------+
WAIT "POR FAVOR, ESPERE MIENTRAS SE CARGA EL MODULO..." WINDOW NOWAIT

*/ Function keys */

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

*/ Cursor movement keys */

#DEFINE K_UP                5   &&   Up arrow, Ctrl-E
#DEFINE K_DOWN             24   &&   Down arrow, Ctrl-X
#DEFINE K_LEFT             19   &&   Left arrow, Ctrl-S
#DEFINE K_RIGHT             4   &&   Right arrow, Ctrl-D
#DEFINE K_HOME              1   &&   Home, Ctrl-A
#DEFINE K_END               6   &&   End, Ctrl-F
#DEFINE K_PGUP             18   &&   PgUp, Ctrl-R
#DEFINE K_PGDN              3   &&   PgDn, Ctrl-C

*/ Misc. keys */

#DEFINE K_ENTER            13   &&   Enter, Ctrl-M
#DEFINE K_RETURN           13   &&   Return, Ctrl-M
#DEFINE K_SPACE            32   &&   Space bar
#DEFINE K_ESC              27   &&   Esc, Ctrl-[
#DEFINE K_UPPER_D          68   &&   D, uppercase
#DEFINE K_LOWER_D         100   &&   d, lowercase

*/ System messages */

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

PRIVATE cSetCentury, cSetCompatible, cSetDate, cSetDeleted, cSetExact, ;
        cSetNotify, cSetSafety, cSetTalk, cMacros, nSelect, ;
        cWindow, cWindow2, cWindow3, cFile, mdec_pos

STORE "" TO cSetCentury, cSetCompatible, cSetDate, cSetDeleted, cSetExact, ;
            cSetNotify, cSetSafety, cSetTalk, cMacros, nSelect, ;
            cWindow, cWindow2, cWindow3, cFile, mdec_pos

STORE "" to m.TIPODOCU, m.NRODOCU, m.PROVEEDOR, m.FECHADOCU, m.DIVISA, m.CAMBIO, m.CAMBIO2, m.PORCDESC, m.IMPORTDESC, m.MONTO_FACT, m.MONTO_PAGO, m.GASTOS

*/ Setup code */
DO setup

*/ Screen design */
DO screenlayout

*/ Main program loop */
DO WHILE .T.  
   DO refresh
   nKey = INKEY(0, "HM")                       && Get INKEY(), hide cursor, check mouse
   IF nKey = 0                                 && No key or mouse press
      LOOP
   ENDIF
   IF nKey = K_ESC                             && Esc key pressed, exit main loop
      EXIT
   ENDIF
   IF nKey = 151                               && Single mouse click
      LOOP
   ENDIF

   DO CASE
      CASE nKey = K_F2                         && Add record
         DO navigate WITH "ADD"
      CASE nKey = K_F3                         && Edit record
         DO navigate WITH "EDIT"
      CASE nKey = K_F4                         && Sort records
         DO navigate WITH "ORDER"
      CASE nKey = K_F5                         && Search data
         DO navigate WITH "SEARCH"
      CASE nKey = K_F8                         && Remove record
         DO navigate WITH "DELETE"
      CASE nKey = K_F10                        && Browse the header of the file
         DO navigate WITH "BROWSEHEADER"            
      CASE nKey = K_UP                         && Next record
         DO navigate WITH "NEXT"
      CASE nKey = K_DOWN                       && Previous record
         DO navigate WITH "PREV"
      CASE nKey = K_LEFT                       && First record
         DO navigate WITH "TOP"
      CASE nKey = K_RIGHT                      && Last record
         DO navigate WITH "END"
      CASE INLIST(nKey, K_UPPER_D, K_LOWER_D)  && Browse the detail
         DO navigate WITH "BROWSEDETAIL"
   ENDCASE
ENDDO

*/ Cleanup code */
DO cleanup

* +-------------------------------------------------------------+
* |  MS-DOS© Supporting Procedures and Functions                |
* +-------------------------------------------------------------+

**-----------------------------------------------------------****
* SETUP - Setup code                                            *
****-----------------------------------------------------------**
PROCEDURE setup
   DO environment WITH "ON"

   cWindow  = LOWER(SYS(2015))
   cWindow2 = LOWER(SYS(2015))
   cWindow3 = LOWER(SYS(2015))

   IF .NOT. WEXIST(cWindow)
      DEFINE WINDOW (cWindow) ;
         FROM INT((SROW() - 25) / 2), INT((SCOL() - 80) / 2) ;
         TO INT((SROW() - 25) / 2) + 24, INT((SCOL() - 80) / 2) + 79 ;
         NONE ;
         NOCLOSE ;
         NOFLOAT ;
         NOGROW ;
         NOMDI ;
         NOMINIMIZE ;
         NOSHADOW ;
         NOZOOM  ;
         COLOR &color_01
   ENDIF

   IF .NOT. WEXIST(cWindow2)
      DEFINE WINDOW (cWindow2) ;
         FROM 05,00 ;
         TO 18,79 ;
         TITLE "DETALLE" ;
         SYSTEM ;
         CLOSE ;
         NOFLOAT ;
         NOGROW ;
         NOMDI ;
         NOMINIMIZE ;
         NOSHADOW ;
         ZOOM ;
         COLOR &color_07 
   ENDIF

   IF .NOT. WEXIST(cWindow3)
      DEFINE WINDOW (cWindow3) ;
         FROM 01,00 ;
         TO 23,79 ;
         TITLE "< IMPORTACIONES >" ;
         SYSTEM ;
         CLOSE ;
         NOFLOAT ;
         NOGROW ;
         NOMDI ;
         NOMINIMIZE ;
         NOSHADOW ;
         ZOOM ;
         COLOR &color_02   
   ENDIF
   
   SELECT 0
   cFile    = "tm" + RIGHT(SYS(3), 6)
   CREATE TABLE &cFile (tipodocu   N(01) ,;
                        nrodocu    C(09) ,;
                        proveedor  N(05) ,;
                        codigo     C(15) ,;
                        cod_altern C(15) ,;
                        cod_origen C(15) ,;
                        descr_arti C(40) ,;
                        familia    N(04) ,;
                        rubro      N(04) ,;
                        subrubro   N(04) ,;
                        marca      N(04) ,;
                        unidad     N(04) ,;
                        procedenci N(04) ,;
                        cantidad   N(09,2) ,;
                        precio     N(13,4) ,;
                        descuento  N(07,4) ,;
                        tasa_iva   N(06,2) ,;
                        tipo_cod   C(01) ,;
                        h_familia  N(04) ,;
                        h_pcostog  N(13,4) ,;
                        h_pcostod  N(13,4) ,;
                        h_pventag1 N(13,4) ,;
                        h_pventag2 N(13,4) ,;
                        h_pventag3 N(13,4) ,;
                        h_pventag4 N(13,4) ,;
                        h_pventag5 N(13,4) ,;
                        h_pventad1 N(13,4) ,;
                        h_pventad2 N(13,4) ,;
                        h_pventad3 N(13,4) ,;
                        h_pventad4 N(13,4) ,;
                        h_pventad5 N(13,4) ,;
                        h_tasa_iva N(06,2) ,;
                        h_fecucomp D(08))

   USE &cFile ALIAS detatemp EXCLUSIVE
                        
   SELECT cabeimpo
   SET ORDER TO TAG "indice1"
   GO TOP

   SELECT detaimpo
   SET ORDER TO TAG "indice1"

   SELECT cuotas_i
   SET ORDER TO TAG "indice1"

   SELECT almacen
   SET ORDER TO TAG "indice1"

   SELECT monedas
   SET ORDER TO TAG "indice1"

   SELECT maesprod
   SET ORDER TO TAG "indice1"

   * Establece relacion(es) entre tablas.

*ENDPROC
   
**-----------------------------------------------------------****
* ENVIRONMENT - ON/OFF the module environment                   *
****-----------------------------------------------------------**
PROCEDURE environment
PARAMETER cStatus

   IF UPPER(ALLTRIM(cStatus)) = "ON"
      IF SET("TALK") = "ON"
         SET TALK OFF
         cSetTalk = "ON"
      ELSE
         cSetTalk = "OFF"
      ENDIF

      IF SET("CENTURY") = "OFF"
         SET CENTURY ON 
         cSetCentury = "OFF"
      ELSE
         cSetCentury = "ON"
      ENDIF

      cSetCompatible = SET("COMPATIBLE")
      SET COMPATIBLE FOXPLUS

      IF SET("DATE") <> "BRITISH"
         cSetDate = SET("DATE")
         SET DATE BRITISH
      ELSE
         cSetDate = "BRITISH"
      ENDIF

      IF SET("DELETED") = "OFF"
         SET DELETED ON
         cSetDeleted = "OFF"
      ELSE
         cSetDeleted = "ON"
      ENDIF

      IF SET("EXACT") = "ON"
         SET EXACT OFF
         cSetExact = "ON"
      ELSE
         cSetExact = "OFF"
      ENDIF

      IF SET("NOTIFY") = "OFF"
         SET NOTIFY ON
         cSetNotify = "OFF"
      ELSE
         cSetNotify = "ON"
      ENDIF

      IF SET("SAFETY") = "ON"
         SET SAFETY OFF
         cSetSafety = "ON"
      ELSE
         cSetSafety = "OFF"
      ENDIF
      
      cMacros = "tm" + RIGHT(SYS(3), 6) + ".fky"
      SAVE MACROS TO &cMacros
      CLEAR MACROS
      
      nSelect = SELECT()
   ELSE
      IF UPPER(ALLTRIM(cStatus)) = "OFF"
         IF cSetTalk = "ON"
            SET TALK ON
         ENDIF
         
         IF cSetCentury = "OFF"
            SET CENTURY OFF
         ENDIF

         IF cSetCompatible = "ON"
            SET COMPATIBLE ON
         ENDIF

         IF cSetDate <> "BRITISH"
            SET DATE &cSetDate
         ENDIF

         IF cSetDeleted = "OFF"
            SET DELETED OFF
         ENDIF

         IF cSetExact = "ON"
            SET EXACT ON
         ENDIF

         IF cSetNotify = "OFF"
            SET NOTIFY OFF
         ENDIF

         IF cSetSafety = "ON"
            SET SAFETY ON
         ENDIF
      
         RESTORE MACROS FROM &cMacros
 
         IF .NOT. EMPTY(ALIAS(nSelect))
            SELECT (nSelect)
         ENDIF
      ENDIF
   ENDIF
*ENDPROC




FUNCTION Format     &&  Dibuja el formato de la factura y las etiquetas.
@ 01,00 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR &color_01
@ 02,00 SAY "³ Referencia...:                     Prov..:                                   ³" COLOR &color_01
@ 03,00 SAY "³ Forma de Pago:                                          F.Compra: 99/99/9999 ³" COLOR &color_01
@ 04,00 SAY "³ Divisa.......:                                     Cambio Aduana:            ³" COLOR &color_01
@ 05,00 SAY "ÃÄDescripci¢nÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄCantidadÄÂÄPrecio Unit.ÄÄÂÄImporteÄÄ´" COLOR &color_01
@ 06,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 07,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 08,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 09,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 10,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 11,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 12,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 13,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 14,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 15,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 16,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 17,00 SAY "³                                        ³          ³               ³          ³" COLOR &color_01
@ 18,00 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´" COLOR &color_01
@ 19,00 SAY "³ Familia.:                                         SUB-TOTALES:               ³" COLOR &color_01
@ 20,00 SAY "³ % Listas:                                         % DESCUENTO:               ³" COLOR &color_01
@ 21,00 SAY "³ Gravado.:                                              GASTOS:               ³" COLOR &color_01
@ 22,00 SAY "³ S.Actual:                                       TOTAL GENERAL:               ³" COLOR &color_01
@ 23,00 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR &color_01
DO center WITH 01, "< IMPORTACIONES >", "BG+/B"

**-----------------------------------------------------------****
* SCREENLAYOUT - Dise¤o de pantalla.                            *
****-----------------------------------------------------------**
PROCEDURE ScreenLayout

IF WVISIBLE(cWindow)
   ACTIVATE WINDOW (cWindow) SAME
ELSE
   ACTIVATE WINDOW (cWindow) NOSHOW
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

IF .NOT. WVISIBLE(cWindow)
   ACTIVATE WINDOW (cWindow)
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
* REFRESH - Actualiza la visualizaci¢n del formato, cabecera,   *
*           detalle y pie del movimiento de orden de trabajo.   *
****-----------------------------------------------------------**
PROCEDURE Refresh

DO format
DO showheader
DO showdetail
DO showfoot

**-----------------------------------------------------------****
* CLEANUP - C¢digo de limpieza.                                 *
****-----------------------------------------------------------**
PROCEDURE Cleanup
* Libera la(s) ventana(s) de la memoria.

IF WEXIST(cWindow)
   RELEASE WINDOW (cWindow)
ENDIF

IF WEXIST(cWindow2)
   RELEASE WINDOW (cWindow2)
ENDIF

IF WEXIST(cWindow3)
   RELEASE WINDOW (cWindow3)
ENDIF

* Elimina tabla(s) temporal(es).

IF USED("temporal")
   SELECT temporal 
   USE
ENDIF

DELETE FILE &cFile
DELETE FILE cFile + ".CDX"

* Quiebra la(s) relacion(es) entre tablas.

SELECT cabemot
SET RELATION OFF INTO ot



**-----------------------------------------------------------****
* SHOWHEADER - Carga la cabecera del movimiento de orden de     *
*              trabajo.                                         *
****-----------------------------------------------------------**
PROCEDURE ShowHeader 

SELECT cabeimpo
SCATTER MEMVAR MEMO



@ 02,09 SAY m.tipodocu ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR B/W

*-- Imprime la etiqueta del tipo de documento.
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

@ 02,25 SAY m.nrodocu ;
   SIZE 1,9 ;
   PICTURE "@!" ;
   COLOR B/W

@ 03,09 SAY m.fechadocu ;
   SIZE 1,10 ;
   PICTURE "@D" ;
   COLOR B/W

@ 02,45 SAY m.proveedor ;
   SIZE 1,5 ;
   PICTURE "99999" ;
   COLOR B/W

* Imprime el nombre del proveedor
SELECT proveedo
SET ORDER TO TAG "indice1"

IF SEEK(m.proveedor)
   @ 02,52 SAY PADR(ALLTRIM(nombre), 26, CHR(32)) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR W/B
ELSE
   @ 02,52 SAY REPLICATE(CHR(32), 26) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR W/B
ENDIF

@ 03,45 SAY m.divisa ;
   SIZE 1,4 ;
   PICTURE "9999" ;
   COLOR B/W

mdec_pos = IIF(m.divisa = 1, 0, 2)

* Imprime el nombre del proveedor
SELECT monedas
SET ORDER TO TAG "indice1"

IF SEEK(m.divisa)
   @ 03,52 SAY PADR(ALLTRIM(nombre), 26, CHR(32)) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR W/B
ELSE
   @ 03,52 SAY REPLICATE(CHR(32), 26) ;
      SIZE 1,26 ;
      PICTURE "@!" ;
      COLOR W/B
ENDIF

@ 04,17 SAY m.cambio ;
   SIZE 1,12 ;
   PICTURE "999,999.9999" ;
   COLOR B/W

@ 04,45 SAY m.cambio2 ;
   SIZE 1,12 ;
   PICTURE "999,999.9999" ;
   COLOR B/W


return
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

SELECT detatemp  &&  Vac¡a la tabla temporal que contiene  el
ZAP              &&  detalle de art¡culos.

SELECT detaimpo
SET ORDER TO TAG "indice1"

IF SEEK(STR(m.tipodocu, 1) + m.nrodocu + STR(m.proveedor,5))
   SCAN WHILE m.tipodocu = detaimpo.tipodocu .AND. m.nrodocu = detaimpo.nrodocu .AND. m.proveedor = detaimpo.proveedor
      SCATTER MEMVAR MEMO
      SELECT detatemp
      APPEND BLANK
      GATHER MEMVAR MEMO
      SELECT detaimpo
   ENDSCAN
ELSE
   IF m.tipodocu <> 0 .AND. .NOT. EMPTY(m.nrodocu) .AND. m.proveedor <> 0
      WAIT WINDOW "ESTA IMPORTACION NO POSEE DETALLE, BORRELO Y VUELVA A CARGARLO"
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
#DEFINE c_row    5
#DEFINE c_column 1


SELECT detatemp  
SET ORDER TO 0
GO TOP

SCAN WHILE RECNO() <= 12 .AND. .NOT. (EMPTY(codigo) .OR. EMPTY(cantidad) .OR. EMPTY(precio))
   @ c_row + RECNO(), c_column + 1  SAY LEFT(descr_arti, 39)                   COLOR B/W
   @ c_row + RECNO(), c_column + 41 SAY cantidad                       PICTURE "999,999.99"                               COLOR B/W
   @ c_row + RECNO(), c_column + 52 SAY precio                         PICTURE "99,999,999.9999"                          COLOR B/W
   IF m.divisa <> 1
      @ c_row + RECNO(), c_column + 68 SAY ROUND(precio * cantidad, 2) PICTURE "999,999.99"   COLOR B/W
   ELSE
      @ c_row + RECNO(), c_column + 68 SAY ROUND(precio * cantidad, 0) PICTURE "99,999,999"   COLOR B/W  
   ENDIF
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

SELECT detatemp  

SCAN ALL
   nSubTotal = nSubTotal + ROUND(precio * cantidad, mdec_pos)
ENDSCAN

IF m.importdesc > 0 .AND. m.porcdesc = 0
   nSubTota1    = nSubTotal - m.importdesc
   m.monto_fact = nSubTota1
   m.descuento  = ROUND(m.importdesc / nSubTotal * 100, 4)
ELSE
   IF m.porcdesc > 0
      m.importdesc = ROUND((nSubTotal * (m.porcdesc / 100)), 0)
      nSubTota1    = nSubTotal - m.importdesc
      m.monto_fact = nSubTota1
   ELSE
      IF m.importdesc = 0 .AND. m.porcdesc = 0
         m.monto_fact = nSubTotal
      ENDIF
   ENDIF
ENDIF


@ 19,65 SAY nSubTotal ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR B/W

@ 20,43 SAY m.porcdesc ;
   SIZE 1,8 ;
   PICTURE "999.9999" ;
   COLOR B/W

@ 20,65 SAY m.importdesc ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR B/W

@ 21,65 SAY m.gastos ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR B/W

@ 22,65 SAY m.monto_fact ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR B/W

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

SELECT cabeimpo

**-----------------------------------------------------------****
* NAVIGATE - Administra pulsaciones de teclas.                  *
****-----------------------------------------------------------**
PROCEDURE Navigate
PARAMETER cBtnName

PUSH KEY CLEAR

SELECT cabeimpo

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
      DO mkimport.prg WITH "ADD"     
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
