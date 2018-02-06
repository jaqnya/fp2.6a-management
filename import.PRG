*--------------------------------------------------------------------------*
PRIVATE color_01, color_02, color_03, color_04, color_05, color_06

color_01 = "GR+/B"   && Yellow / Blue
color_02 = "BG+/B"   && Cyan   / Blue
color_03 = "W+/BG,GR+/RB,GR+/B+,GR+/B,,,GR+/RB"   && Browse
color_04 = "W+/BG"   && White  / Cyan
color_05 = "W+/B"    && White  / Blue
color_06 = "GR+/B,GR+/B,GR+/B,GR+/B,GR+/B"

*--------------------------------------------------------------------------*
PRIVATE m.tipodocu, m.nrodocu, m.proveedor, m.fechadocu, m.divisa, ;
        m.decimales, m.cambio_adu, m.cambio_gto, m.cambio_vta, ;
        m.almacen, m.porcdesc, m.importdesc, m.descuento, ;
        m.monto_gast, m.monto_fact, m.monto_pago, file_01, file_02
        
STORE 0 TO m.proveedor, m.divisa, m.decimales, m.cambio_adu, ;
           m.cambio_gto, m.cambio_vta, m.almacen, m.porcdesc, ;
           m.importdesc, m.descuento, m.monto_gast, m.monto_fact, ;
           m.monto_pago 

STORE SPACE(1) TO m.tipodocu, m.nrodocu, file_01, file_02

*--------------------------------------------------------------------------*
PRIVATE K_UP, K_DOWN, K_LEFT, K_RIGHT, K_ENTER, K_ESC, K_F1, K_F2, K_F3, ;
        K_F4, K_F5, K_F6, K_F7, K_F8, K_F9, K_F10, K_F11, K_F12

STORE SPACE(1) TO K_UP, K_DOWN, K_LEFT, K_RIGHT, K_ENTER, K_ESC, ;
                  K_F1, K_F2, K_F3, K_F4, K_F5, K_F6, K_F7, K_F8, ;
                  K_F9, K_F10, K_F11, K_F12

*--------------------------------------------------------------------------*                  
                  
DO setup

SELECT cabeimpo
GOTO TOP

*/ Screen design */
*DO screenlayout

*/ Main program loop */
DO WHILE .T.  
   DO refresh
   nKey = INKEY(0, "HM")                       && Get INKEY(), hide cursor, check mouse
   IF nKey = 0                                 && No key or mouse press
      LOOP
   ENDIF
   IF nKey = 27                             && Esc key pressed, exit main loop
      EXIT
   ENDIF
   IF nKey = 151                               && Single mouse click
      LOOP
   ENDIF

   DO CASE
      CASE nKey = K_ENTER     
         DO browse_cuotas
      CASE nKey = -1                           && Add record
         DO navigate WITH "ADD"
      CASE nKey = -2                           && Edit record
         DO navigate WITH "EDIT"
      CASE nKey = -3                           && Sort records
         DO navigate WITH "ORDER"
      CASE nKey = -4                           && Search data
         DO navigate WITH "SEARCH"
      CASE nKey = -7                           && Remove record
         DO navigate WITH "DELETE"
      CASE nKey = -9                           && Browse the header of the file
         DO navigate WITH "BROWSEHEADER"            
      CASE nKey = K_UP                         && Next record
         DO navigate WITH "NEXT"
      CASE nKey = K_DOWN                       && Previous record
         DO navigate WITH "PREV"
      CASE nKey = K_LEFT                       && First record
         DO navigate WITH "TOP"
      CASE nKey = K_RIGHT                      && Last record
         DO navigate WITH "END"
      CASE INLIST(nKey, 68, 100)  && Browse the detail
         DO navigate WITH "BROWSEDETAIL"
   ENDCASE
ENDDO

*/ Cleanup code */
DO cleanup

*--------------------------------------------------------------------------*
PROCEDURE refresh
   DO format
   DO header
   DO detail
   DO footer
*ENDPROC

*--------------------------------------------------------------------------*
PROCEDURE format
   @ 01,00 CLEAR TO 23,79
   @ 01,00 TO 23,79 COLOR &color_01

   @ 01,00 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR "W/B"
   @ 02,00 SAY "³ Documento:                           N§:                F.Compra:            ³" COLOR "W/B"
   @ 03,00 SAY "³ Proveedor:                                                                   ³" COLOR "W/B"
   @ 04,00 SAY "³ Divisa...:                                         Cambio Aduana:            ³" COLOR "W/B"
   @ 05,00 SAY "³ Almac‚n..:                                                                   ³" COLOR "W/B"
   @ 06,00 SAY "ÃÄDescripci¢nÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄCantidadÄÂÄPrecio Unit.ÄÄÂÄImporteÄÄ´" COLOR "W/B"
   @ 07,00 SAY "³                                        ³          ³               ³          ³" COLOR "W/B"
   @ 08,00 SAY "³                                        ³          ³               ³          ³" COLOR "W/B"
   @ 09,00 SAY "³                                        ³          ³               ³          ³" COLOR "W/B"
   @ 10,00 SAY "³                                        ³          ³               ³          ³" COLOR "W/B"
   @ 11,00 SAY "³                                        ³          ³               ³          ³" COLOR "W/B"
   @ 12,00 SAY "³                                        ³          ³               ³          ³" COLOR "W/B"
   @ 13,00 SAY "³                                        ³          ³               ³          ³" COLOR "W/B"
   @ 14,00 SAY "³                                        ³          ³               ³          ³" COLOR "W/B"
   @ 15,00 SAY "³                                        ³          ³               ³          ³" COLOR "W/B"
   @ 16,00 SAY "³                                        ³          ³               ³          ³" COLOR "W/B"
   @ 17,00 SAY "³                                        ³          ³               ³          ³" COLOR "W/B"
   @ 18,00 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´" COLOR "W/B"
   @ 19,00 SAY "³ Familia.:                                         SUB-TOTALES:               ³" COLOR "W/B"
   @ 20,00 SAY "³ % Listas:                                         % DESCUENTO:               ³" COLOR "W/B"
   @ 21,00 SAY "³ Gravado.:                                              GASTOS:               ³" COLOR "W/B"
   @ 22,00 SAY "³ Stock...:                                       TOTAL GENERAL:               ³" COLOR "W/B"
   @ 23,00 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR "W/B"

   @ 01,01 SAY REPLICATE("Ä", 78) COLOR &color_01
   @ 06,01 SAY REPLICATE("Ä", 78) COLOR &color_01
   @ 18,01 SAY REPLICATE("Ä", 78) COLOR &color_01
   @ 23,01 SAY REPLICATE("Ä", 78) COLOR &color_01

   FOR nCounter = 2 TO 22
      @ nCounter,00 SAY "³" COLOR &color_01
      @ nCounter,79 SAY "³" COLOR &color_01
      IF BETWEEN(nCounter, 7, 17) THEN
         @ nCounter,41 SAY "³" COLOR &color_01
         @ nCounter,52 SAY "³" COLOR &color_01
         @ nCounter,68 SAY "³" COLOR &color_01
      ENDIF
   ENDFOR

   @ 01,00 SAY "Ú" COLOR &color_01
   @ 01,79 SAY "¿" COLOR &color_01

   @ 23,00 SAY "À" COLOR &color_01
   @ 23,79 SAY "Ù" COLOR &color_01

   @ 06,00 SAY "Ã" COLOR &color_01
   @ 06,79 SAY "´" COLOR &color_01
   @ 18,00 SAY "Ã" COLOR &color_01
   @ 18,79 SAY "´" COLOR &color_01

   @ 06,41 SAY "Â" COLOR &color_01
   @ 06,52 SAY "Â" COLOR &color_01
   @ 06,68 SAY "Â" COLOR &color_01

   @ 18,41 SAY "Á" COLOR &color_01
   @ 18,52 SAY "Á" COLOR &color_01
   @ 18,68 SAY "Á" COLOR &color_01

   DO center WITH 01, "[ IMPORTACIONES ]", color_01

   @ 02,02 SAY "Documento:" COLOR &color_02
   @ 02,39 SAY "N§:" COLOR &color_02
   @ 02,58 SAY "F.Compra:" COLOR &color_02
   @ 03,02 SAY "Proveedor:" COLOR &color_02
   @ 04,02 SAY "Divisa...:" COLOR &color_02
   @ 04,53 SAY "Cambio Aduana:" COLOR &color_02
   @ 05,02 SAY "Almac‚n..:" COLOR &color_02
   @ 06,02 SAY "Descripci¢n" COLOR &color_01
   @ 06,43 SAY "Cantidad" COLOR &color_01
   @ 06,54 SAY "Precio Unit." COLOR &color_01
   @ 06,70 SAY "Importe" COLOR &color_01

   @ 19,02 SAY "Familia.:" COLOR &color_02
   @ 20,02 SAY "% Listas:" COLOR &color_02
   @ 21,02 SAY "Gravado.:" COLOR &color_02
   @ 22,02 SAY "Stock...:" COLOR &color_02

   @ 19,52 SAY "SUB-TOTALES:" COLOR &color_02
   @ 20,52 SAY "% DESCUENTO:" COLOR &color_02
   @ 21,57 SAY "GASTOS:" COLOR &color_02
   @ 22,50 SAY "TOTAL GENERAL:" COLOR &color_02
*ENDPROC

*--------------------------------------------------------------------------*
PROCEDURE header
   SELECT cabeimpo
   SCATTER MEMVAR

   @ 02,13 SAY m.tipodocu PICTURE "@!" SIZE 1,1 COLOR &color_04

   DO CASE
      CASE m.tipodocu = "1"
         @ 02,16 SAY "COMPRA CONTADO" PICTURE "@!" SIZE 1,20 COLOR &color_05
      CASE m.tipodocu = "2"
         @ 02,16 SAY "COMPRA CREDITO" PICTURE "@!" SIZE 1,20 COLOR &color_05
      OTHERWISE
         @ 02,16 SAY REPLICATE(CHR(32), 20) PICTURE "@!" SIZE 1,20 COLOR &color_05
   ENDCASE

   @ 02,43 SAY m.nrodocu PICTURE "@!" SIZE 1,13 COLOR &color_04
   @ 02,68 SAY m.fechadocu PICTURE "@D" SIZE 1,10 COLOR &color_04

   @ 03,13 SAY m.proveedor PICTURE "99999" SIZE 1,5 COLOR &color_04
   @ 03,20 SAY LEFT(look_up("nombre", "proveedo", "codigo = m.proveedor"), 40) PICTURE "@!" SIZE 1,40 COLOR &color_05

   @ 04,13 SAY m.divisa PICTURE "9999" SIZE 1,4 COLOR &color_04
   @ 04,20 SAY LEFT(look_up("nombre", "divisas", "codigo = m.divisa"), 30) PICTURE "@!" SIZE 1,30 COLOR &color_05
   @ 04,68 SAY m.cambio_adu PICTURE "999999.9999" SIZE 1,11 COLOR &color_04

   @ 05,13 SAY m.almacen PICTURE "9999" SIZE 1,4 COLOR &color_04
   @ 05,20 SAY LEFT(look_up("nombre", "almacen", "codigo = m.almacen"), 30) PICTURE "@!" SIZE 1,30 COLOR &color_05
*ENDPROC

*--------------------------------------------------------------------------*
PROCEDURE detail
   SELECT detalle   && Vac¡a la tabla temporal que contiene el
   ZAP             && detalle de art¡culos del documento.

   SELECT detaimpo 
   SET ORDER TO 1

   SEEK m.tipodocu + m.nrodocu + STR(m.proveedor, 5)
   SCAN WHILE m.tipodocu = tipodocu .AND. m.nrodocu = nrodocu .AND. m.proveedor = proveedor
      INSERT INTO detalle (tipodocu, nrodocu, proveedor, articulo, cantidad, precio, descuento, tasa_iva) ;
         VALUES (detaimpo.tipodocu, detaimpo.nrodocu, detaimpo.proveedor, detaimpo.articulo, detaimpo.cantidad, detaimpo.precio, detaimpo.descuento, detaimpo.tasa_iva)
   ENDSCAN

   SELECT cabeimpo
   DO print_detail
*ENDPROC

*--------------------------------------------------------------------------*
PROCEDURE print_detail
   PRIVATE nRow, nCol, marticulo

   STORE 6 TO nRow
   STORE 2 TO nCol
   STORE SPACE(1) TO marticulo

   SELECT detalle
   GOTO TOP

   SCAN WHILE RECNO() <= 11 .AND. .NOT. (EMPTY(articulo) .OR. EMPTY(cantidad) .OR. EMPTY(precio))
      marticulo = articulo
      @ nRow + RECNO(), nCol SAY LEFT(look_up("nombre", "maesprod", "codigo = marticulo"), 39) COLOR &color_04
      @ nRow + RECNO(), nCol + 40 SAY cantidad PICTURE "999,999.99" COLOR &color_04
      @ nRow + RECNO(), nCol + 51 SAY precio PICTURE "99,999,999.9999" COLOR &color_04
      @ nRow + RECNO(), nCol + 67 SAY ROUND(precio * cantidad, m.decimales) - ROUND(ROUND(precio * cantidad, m.decimales) * descuento / 100, m.decimales) PICTURE IIF(m.decimales = 0, "99,999,999", "999,999.99") COLOR &color_04
   ENDSCAN
   
   SELECT cabeimpo
*ENDPROC

*--------------------------------------------------------------------------*
PROCEDURE footer
   STORE 0 TO msubtotal

   SELECT detalle
   SCAN ALL
      msubtotal = msubtotal + ROUND(precio * cantidad, m.decimales) - ROUND(ROUND(precio * cantidad, m.decimales) * descuento / 100, m.decimales)
   ENDSCAN

   IF m.porcdesc > 0 THEN
      m.importdesc = ROUND(msubtotal * m.porcdesc / 100, m.decimales)
   ENDIF
   
   IF m.importdesc > 0 THEN
      m.descuento = ROUND(m.importdesc / msubtotal * 100, 4)
   ENDIF
   
   m.monto_fact = msubtotal - m.importdesc + m.monto_gast

   @ 19,65 SAY msubtotal PICTURE "999,999,999.99" SIZE 1,14 COLOR &color_04
   @ 20,43 SAY m.porcdesc PICTURE "999.9999" SIZE 1,8 COLOR &color_04
   @ 20,65 SAY m.importdesc PICTURE "999,999,999.99" SIZE 1,14 COLOR &color_04
   @ 21,65 SAY m.monto_gast PICTURE "999,999,999.99" SIZE 1,14 COLOR &color_04
   @ 22,65 SAY m.monto_fact PICTURE "999,999,999.99" SIZE 1,14 COLOR &color_04
*ENDPROC

*--------------------------------------------------------------------------*
PROCEDURE setup
   DO seteos
   DO define_keys
*  DEFINE WINDOW detalle FROM 06,00 TO 18,79 TITLE "Detalle" ;
*    CLOSE NOFLOAT NOGROW ZOOM COLOR &color_03

   DO open_db WITH "cabeimpo", "id_import", .T.
   DO open_db WITH "detaimpo", "id_import", .T.
   DO open_db WITH "cuotas_i", "id_import", .T.
   DO open_db WITH "maesprod", "indice1", .T.
   DO open_db WITH "proveedo", "indice1", .T.
   DO open_db WITH "monedas", "indice1", .T.
   DO open_db WITH "almacen", "indice1", .T.

   SELECT 0
   file_01 = createmp()
   CREATE TABLE &file_01 ;
     (tipodocu   C(1), ;
      nrodocu    C(15), ;
      proveedor  N(5), ;
      articulo   C(15), ;
      cantidad   N(9,2), ;
      precio     N(13,4), ;
      descuento  N(7,4), ;
      tasa_iva   N(6,2))
   USE &file_01 ALIAS detalle EXCLUSIVE

   SELECT 0
   file_02 = createmp()
   CREATE TABLE &file_02 ;
     (tipodocu   C(1), ;
      nrodocu    C(15), ;
      proveedor  N(5), ;
      tipo       N(1), ;
      nrocuota   N(3), ;
      fecha      D(8), ;
      importe    N(12,2), ;
      abonado    N(12,2), ;
      monto_ndeb N(12,2), ;
      monto_ncre N(12,2))
   USE &file_02 ALIAS detalle_cuotas EXCLUSIVE
*ENDPROC


*--------------------------------------------------------------------------------------------*
PROCEDURE cleanup

SELECT detalle
USE
DO borratemp WITH file_01

SELECT detalle_cuotas
USE
DO borratemp WITH file_02

*--------------------------------------------------------------------------------------------*
PROCEDURE old_look_up
PARAMETER cTable, cIndex, nKey, cField

   PRIVATE cReturn, nSelect, cOrder
   nSelect = SELECT()

   SELECT &cTable
   cOrder = ORDER()
   SET ORDER TO TAG &cIndex

   SEEK nKey
   IF FOUND() THEN
      cReturn = &cField
   ELSE
      cReturn = ""
   ENDIF
   
   SET ORDER TO TAG (cOrder)

   IF .NOT. EMPTY(ALIAS(nSelect))
      SELECT (nSelect)
   ENDIF

   RETURN (cReturn)
*ENDPROC


*--------------------------------------------------------------------------*
PROCEDURE open_db
PARAMETERS cTable, cTag, lNetwork

   IF PARAMETERS() < 3
      WAIT "No se han pasado suficientes par metros." WINDOW 
      RETURN 0
   ENDIF

   PRIVATE lcRoute, lcNetwork, lcOrder, lcOrder2

   lcRoute   = IIF(TYPE("gcPath") = "U", "", gcPath)
   lcNetwork = IIF(lNetwork, "SHARED", "EXCLUSIVE")
 
   IF EMPTY(cTag)
      lcOrder  = "SET ORDER TO 0"
      lcOrder2 = "ORDER 0"
   ELSE
      lcOrder  = [SET ORDER TO TAG "] + ALLTRIM(LOWER(cTag)) + [" OF ] + lcRoute + ALLTRIM(LOWER(cTable)) + ".cdx"
      lcOrder2 = [ORDER TAG "] + ALLTRIM(LOWER(cTag)) + [" OF ] + lcRoute + ALLTRIM(LOWER(cTable)) + ".cdx"
   ENDIF
   
   IF USED(cTable)
      SELECT (cTable)
      &lcOrder
   ELSE
      SELECT 0
      USE (LOCFILE(lcRoute + (cTable) + ".dbf", "DBF", "¿Dónde está " + ALLTRIM(UPPER(cTable)) + ".DBF?")) ;
         AGAIN ALIAS (cTable) &lcNetwork &lcOrder2
   ENDIF
*ENDPROC

*--------------------------------------------------------------------------------------------*
FUNCTION createmp
   PRIVATE cFileName, cReturn
   
   DO WHILE .T.
      cFileName = "tm" + RIGHT(SYS(3), 6)
      IF .NOT. (FILE(cFileName + ".DBF") .OR. FILE(cFileName + ".CDX"))
         cReturn = cFileName
         EXIT
      ENDIF
   ENDDO
   
   RETURN (cReturn)
*ENDFUNC

*--------------------------------------------------------------------------------------------*
PROCEDURE borratemp
PARAMETER cFileName
   
   PRIVATE architemp1, architemp2, architemp3, architemp4, architemp5, ;
           architemp6   
   
   architemp1 = cFileName + ".DBF"
   architemp2 = cFileName + ".FPT"   
   architemp3 = cFileName + ".IDX"
   architemp4 = cFileName + ".CDX"      
   architemp5 = cFileName + ".VUE"      
   architemp6 = cFileName + ".TXT"         
   
   IF FILE(architemp1)
      DELETE FILE &architemp1
   ENDIF
   
   IF FILE(architemp2)
      DELETE FILE &architemp2
   ENDIF
   
   IF FILE(architemp3)
      DELETE FILE &architemp3
   ENDIF   
   
   IF FILE(architemp4)
      DELETE FILE &architemp4
   ENDIF   
   
   IF FILE(architemp5)
      DELETE FILE &architemp5
   ENDIF   
   
   IF FILE(architemp6)
      DELETE FILE &architemp6
   ENDIF
*ENDPROC

*--------------------------------------------------------------------------*
PROCEDURE seteos
   SET CENTURY    ON
   SET DATE       BRITISH
   SET DELETED    ON
   SET EXACT      OFF
   SET SAFETY     OFF
   SET TALK       OFF
*ENDPROC


*--------------------------------------------------------------------------*
PROCEDURE center
PARAMETER nRow, cText, cColor
   nColumn = 40 - (LEN(cText) / 2)
   @ nRow, nColumn SAY cText COLOR (cColor)
*ENDPROC



*--------------------------------------------------------------------------*
PROCEDURE define_keys
****
*
*  Inkey.ch
*
*  Standard INKEY() key-code definitions
*
*  Copyright (c) 1990-1993, Computer Associates International, Inc.
*  All rights reserved.
*
*  NOTE: Keystroke descriptions marked with an asterick (*) are only
*        available on enhanced keyboards (those with more than 84 keys)
*
*/


&& Cursor movement keys

K_UP            =   5   &&   Up arrow, Ctrl-E
K_DOWN          =  24   &&   Down arrow, Ctrl-X
K_LEFT          =  19   &&   Left arrow, Ctrl-S
K_RIGHT         =   4   &&   Right arrow, Ctrl-D
K_HOME          =   1   &&   Home, Ctrl-A
K_END           =   6   &&   End, Ctrl-F
K_PGUP          =  18   &&   PgUp, Ctrl-R
K_PGDN          =   3   &&   PgDn, Ctrl-C

K_CTRL_UP       = 397   && * Ctrl-Up arrow
K_CTRL_DOWN     = 401   && * Ctrl-Down arrow
K_CTRL_LEFT     =  26   &&   Ctrl-Left arrow, Ctrl-Z
K_CTRL_RIGHT    =   2   &&   Ctrl-Right arrow, Ctrl-B
K_CTRL_HOME     =  29   &&   Ctrl-Home, Ctrl-]
K_CTRL_END      =  23   &&   Ctrl-End, Ctrl-W
K_CTRL_PGUP     =  31   &&   Ctrl-PgUp, Ctrl-Hyphen
K_CTRL_PGDN     =  30   &&   Ctrl-PgDn, Ctrl-^

K_ALT_UP        = 408   && * Alt-Up arrow
K_ALT_DOWN      = 416   && * Alt-Down arrow
K_ALT_LEFT      = 411   && * Alt-Left arrow
K_ALT_RIGHT     = 413   && * Alt-Right arrow
K_ALT_HOME      = 407   && * Alt-Home
K_ALT_END       = 415   && * Alt-End
K_ALT_PGUP      = 409   && * Alt-PgUp
K_ALT_PGDN      = 417   && * Alt-PgDn

&& Misc. keys

K_ENTER         =  13   &&   Enter, Ctrl-M
K_RETURN        =  13   &&   Return, Ctrl-M
K_SPACE         =  32   &&   Space bar
K_ESC           =  27   &&   Esc, Ctrl-[

K_CTRL_ENTER    =  10   &&   Ctrl-Enter
K_CTRL_RETURN   =  10   &&   Ctrl-Return
K_CTRL_RET      =  10   &&   Ctrl-Return (Compat.)
K_CTRL_PRTSCR   = 379   && * Ctrl-Print Screen
K_CTRL_QUESTION = 309   &&   Ctrl-?

K_ALT_ENTER     = 284   && * Alt-Enter
K_ALT_RETURN    = 284   && * Alt-Return
K_ALT_EQUALS    = 387   && * Alt-Equals
K_ALT_ESC       = 257   && * Alt-Esc

&& Keypad keys

KP_ALT_ENTER     = 422   && * Keypad Alt-Enter

KP_CTRL_5        = 399   && * Keypad Ctrl-5
KP_CTRL_SLASH    = 405   && * Keypad Ctrl-/
KP_CTRL_ASTERISK = 406   && * Keypad Ctrl-*
KP_CTRL_MINUS    = 398   && * Keypad Ctrl--
KP_CTRL_PLUS     = 400   && * Keypad Ctrl-+

KP_ALT_5         =   5   && * Keypad Alt-5
KP_ALT_SLASH     = 420   && * Keypad Alt-/
KP_ALT_ASTERISK  = 311   && * Keypad Alt-*
KP_ALT_MINUS     = 330   && * Keypad Alt--
KP_ALT_PLUS      = 334   && * Keypad Alt-+


&& Editing keys

K_INS           =  22   &&   Ins, Ctrl-V
K_DEL           =   7   &&   Del, Ctrl-G
K_BS            =   8   &&   Backspace, Ctrl-H
K_TAB           =   9   &&   Tab, Ctrl-I
K_SH_TAB        = 271   &&   Shift-Tab

K_CTRL_INS      = 402   && * Ctrl-Ins
K_CTRL_DEL      = 403   && * Ctrl-Del
K_CTRL_BS       = 127   &&   Ctrl-Backspace
K_CTRL_TAB      = 404   && * Ctrl-Tab

K_ALT_INS       = 418   && * Alt-Ins
K_ALT_DEL       = 419   && * Alt-Del
K_ALT_BS        = 270   && * Alt-Backspace
K_ALT_TAB       = 421   && * Alt-Tab


&& Control keys

K_CTRL_A     =  1    &&   Ctrl-A, Home
K_CTRL_B     =  2    &&   Ctrl-B, Ctrl-Right arrow
K_CTRL_C     =  3    &&   Ctrl-C, PgDn, Ctrl-ScrollLock
K_CTRL_D     =  4    &&   Ctrl-D, Right arrow
K_CTRL_E     =  5    &&   Ctrl-E, Up arrow
K_CTRL_F     =  6    &&   Ctrl-F, End
K_CTRL_G     =  7    &&   Ctrl-G, Del
K_CTRL_H     =  8    &&   Ctrl-H, Backspace
K_CTRL_I     =  9    &&   Ctrl-I, Tab
K_CTRL_J     = 10   &&   Ctrl-J
K_CTRL_K     = 11   &&   Ctrl-K
K_CTRL_L     = 12   &&   Ctrl-L
K_CTRL_M     = 13   &&   Ctrl-M, Return
K_CTRL_N     = 14   &&   Ctrl-N
K_CTRL_O     = 15   &&   Ctrl-O
K_CTRL_P     = 16   &&   Ctrl-P
K_CTRL_Q     = 17   &&   Ctrl-Q
K_CTRL_R     = 18   &&   Ctrl-R, PgUp
K_CTRL_S     = 19   &&   Ctrl-S, Left arrow
K_CTRL_T     = 20   &&   Ctrl-T
K_CTRL_U     = 21   &&   Ctrl-U
K_CTRL_V     = 22   &&   Ctrl-V, Ins
K_CTRL_W     = 23   &&   Ctrl-W, Ctrl-End
K_CTRL_X     = 24   &&   Ctrl-X, Down arrow
K_CTRL_Y     = 25   &&   Ctrl-Y
K_CTRL_Z     = 26   &&   Ctrl-Z, Ctrl-Left arrow


&& Alt keys

K_ALT_A       = 286   &&   Alt-A
K_ALT_B       = 304   &&   Alt-B
K_ALT_C       = 302   &&   Alt-C
K_ALT_D       = 288   &&   Alt-D
K_ALT_E       = 274   &&   Alt-E
K_ALT_F       = 289   &&   Alt-F
K_ALT_G       = 290   &&   Alt-G
K_ALT_H       = 291   &&   Alt-H
K_ALT_I       = 279   &&   Alt-I
K_ALT_J       = 292   &&   Alt-J
K_ALT_K       = 293   &&   Alt-K
K_ALT_L       = 294   &&   Alt-L
K_ALT_M       = 306   &&   Alt-M
K_ALT_N       = 305   &&   Alt-N
K_ALT_O       = 280   &&   Alt-O
K_ALT_P       = 281   &&   Alt-P
K_ALT_Q       = 272   &&   Alt-Q
K_ALT_R       = 275   &&   Alt-R
K_ALT_S       = 287   &&   Alt-S
K_ALT_T       = 276   &&   Alt-T
K_ALT_U       = 278   &&   Alt-U
K_ALT_V       = 303   &&   Alt-V
K_ALT_W       = 273   &&   Alt-W
K_ALT_X       = 301   &&   Alt-X
K_ALT_Y       = 277   &&   Alt-Y
K_ALT_Z       = 300   &&   Alt-Z
K_ALT_1       = 376   &&   Alt-1
K_ALT_2       = 377   &&   Alt-2
K_ALT_3       = 378   &&   Alt-3
K_ALT_4       = 379   &&   Alt-4
K_ALT_5       = 380   &&   Alt-5
K_ALT_6       = 381   &&   Alt-6
K_ALT_7       = 382   &&   Alt-7
K_ALT_8       = 383   &&   Alt-8
K_ALT_9       = 384   &&   Alt-9
K_ALT_0       = 385   &&   Alt-0


&& Function keys

K_F1        =  28    &&   F1, Ctrl-Backslash
K_F2        =  -1    &&   F2
K_F3        =  -2    &&   F3
K_F4        =  -3    &&   F4
K_F5        =  -4    &&   F5
K_F6        =  -5    &&   F6
K_F7        =  -6    &&   F7
K_F8        =  -7    &&   F8
K_F9        =  -8    &&   F9
K_F10       =  -9    &&   F10
K_F11       = -40    && * F11
K_F12       = -41    && * F12


&& Control-function keys

K_CTRL_F1     = -20   &&   Ctrl-F1
K_CTRL_F2     = -21   &&   Ctrl-F2
K_CTRL_F3     = -22   &&   Ctrl-F4
K_CTRL_F4     = -23   &&   Ctrl-F3
K_CTRL_F5     = -24   &&   Ctrl-F5
K_CTRL_F6     = -25   &&   Ctrl-F6
K_CTRL_F7     = -26   &&   Ctrl-F7
K_CTRL_F8     = -27   &&   Ctrl-F8
K_CTRL_F9     = -28   &&   Ctrl-F9
K_CTRL_F10    = -29   &&   Ctrl-F10
K_CTRL_F11    = -44   && * Ctrl-F11
K_CTRL_F12    = -45   && * Ctrl-F12


&& Alt-function keys

K_ALT_F1     = -30   &&   Alt-F1
K_ALT_F2     = -31   &&   Alt-F2
K_ALT_F3     = -32   &&   Alt-F3
K_ALT_F4     = -33   &&   Alt-F4
K_ALT_F5     = -34   &&   Alt-F5
K_ALT_F6     = -35   &&   Alt-F6
K_ALT_F7     = -36   &&   Alt-F7
K_ALT_F8     = -37   &&   Alt-F8
K_ALT_F9     = -38   &&   Alt-F9
K_ALT_F10    = -39   &&   Alt-F10
K_ALT_F11    = -46   && * Alt-F11
K_ALT_F12    = -47   && * Alt-F12


&& Shift-function keys

K_SH_F1     = -10   &&   Shift-F1
K_SH_F2     = -11   &&   Shift-F2
K_SH_F3     = -12   &&   Shift-F3
K_SH_F4     = -13   &&   Shift-F4
K_SH_F5     = -14   &&   Shift-F5
K_SH_F6     = -15   &&   Shift-F6
K_SH_F7     = -16   &&   Shift-F7
K_SH_F8     = -17   &&   Shift-F8
K_SH_F9     = -18   &&   Shift-F9
K_SH_F10    = -19   &&   Shift-F10
K_SH_F11    = -42   && * Shift-F11
K_SH_F12    = -43   && * Shift-F12


&& mouse keys

K_MOUSEMOVE   = 1001   &&   mouse location change
K_LBUTTONDOWN = 1002   &&   mouse left key press
K_LBUTTONUP   = 1003   &&   mouse left key release
K_RBUTTONDOWN = 1004   &&   mouse right key press
K_RBUTTONUP   = 1005   &&   mouse right key release
K_LDBLCLK     = 1006   &&   mouse left key double click
K_RDBLCLK     = 1007   &&   mouse right key double click

INKEY_MOVE     =  1    &&   Mouse movements
INKEY_LDOWN    =  2    &&   Mouse left button down
INKEY_LUP      =  4    &&   Mouse left button up
INKEY_RDOWN    =  8    &&   Mouse right button down
INKEY_RUP      = 16    &&   Mouse right button up
INKEY_KEYBOARD = 128   &&   Keyboard events

INKEY_ALL      = 159


*--------------------------------------------------------------------------*
PROCEDURE browse_cuotas
   SELECT detalle_cuotas
   ZAP    

   SELECT cuotas_i 
   SET ORDER TO 1

   SEEK m.tipodocu + m.nrodocu + STR(m.proveedor, 5)
   SCAN WHILE m.tipodocu = tipodocu .AND. m.nrodocu = nrodocu .AND. m.proveedor = proveedor
      INSERT INTO detalle_cuotas (tipodocu, nrodocu, proveedor, tipo, nrocuota, fecha, importe, abonado, monto_ndeb, monto_ncre) ;
         VALUES (cuotas_i.tipodocu, cuotas_i.nrodocu, cuotas_i.proveedor, cuotas_i.tipo, cuotas_i.nrocuota, cuotas_i.fecha, cuotas_i.importe, cuotas_i.abonado, cuotas_i.monto_ndeb, cuotas_i.monto_ncre)
   ENDSCAN

   SELECT detalle_cuotas
   GOTO TOP

   DEFINE WINDOW cuotas FROM 03,00 TO 21,79 ;
     COLOR &color_06
  
   DEFINE WINDOW detalle_cuotas FROM 04,01 TO 20,78 TITLE " CUOTAS " ;
     SYSTEM CLOSE NOFLOAT NOGROW ZOOM COLOR &color_03
     
   ACTIVATE WINDOW cuotas

   BROWSE FIELDS ; 
     f1 = IIF(tipo = 1, "Entr", IIF(tipo = 2, "Cuot", SPACE(7))) :04:H = "Tipo", ;
     f2 = STR(nrocuota, 3) :H = "N§", ;
     f3 = fecha :H = "Fecha Vcto", ;
     f4 = importe :H = "Importe" :P = IIF(m.decimales = 0, "99,999,999", "999,999.99"), ;
     f5 = (importe + monto_ndeb) - (abonado + monto_ncre) :H = "Saldo" :P = IIF(m.decimales = 0, "99,999,999", "999,999.99"), ;     
     f6 = abonado :H = "Abonado" :P = IIF(m.decimales = 0, "99,999,999", "999,999.99"), ;     
     f7 = monto_ndeb :H = "Monto Ndeb" :P = IIF(m.decimales = 0, "99,999,999", "999,999.99"), ;     
     f8 = monto_ncre :H = "Monto Ncre" :P = IIF(m.decimales = 0, "99,999,999", "999,999.99") ;
     NODELETE NOMODIFY WINDOW detalle_cuotas
   
   RELEASE WINDOW detalle_cuotas
   DEACTIVATE WINDOW cuotas
   RELEASE WINDOW cuotas
   SELECT cabeimpo
*ENDPROC

*--------------------------------------------------------------------------------------------*
PROCEDURE look_up
PARAMETER cField, cTable, cWhere
   PRIVATE mreturn
   SELECT &cField FROM &cTable WHERE &cWhere INTO ARRAY mreturn
   RETURN (mreturn)
*ENDPROC