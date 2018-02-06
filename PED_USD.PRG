PRIVATE m.nropedido, m.fecha, m.hora, m.lista, m.serieot, m.nroot, m.cliente, m.vendedor, m.comision1, m.comision2, m.comision3, m.porcdesc, m.importdesc, m.total, m.condicion, m.plazo, m.facturado ;
        m.archi_01, m.key, m.subtotal

STORE  0  TO m.nropedido, m.lista, m.nroot, m.cliente, m.vendedor, m.comision1, m.comision2, m.comision3, m.porcdesc, m.importdesc, m.total, m.condicion, m.plazo
STORE " " TO m.hora, m.serieot
STORE .F. TO m.facturado
STORE CTOD("  /  /    ") TO m.fecha

STORE 0 TO m.key, m.subtotal
STORE createmp() TO m.archi_01

DO load
DO init

SELECT cabepusd
GOTO TOP
DO refresh

IF !WVISIBLE("nota_pedid") THEN
   ACTIVATE WINDOW nota_pedid
ENDIF

DO WHILE .T.
   IF INLIST(m.key, -1, -2, -3, -4, -5, -6, -7, -9, 134, 5, 24, 19, 4) THEN   && F2, F3, F4, F5, F8, UP, DOWN, LEFT, RIGHT
      DO refresh
   ENDIF

   m.key = INKEY(0, "HM")

   IF INLIST(m.key, 0, 151) THEN
      LOOP
   ENDIF

   IF m.key = 27 THEN   && ESC
      EXIT
   ENDIF

   DO CASE
      CASE m.key = 16   && CTRL+P
         IF messagebox("DESEA IMPRIMIR UN REPORTE DE ESTE PEDIDO ?", 48) = 6 THEN
            DO rpt_ped3 WITH m.nropedido
         ENDIF
      CASE m.key = -1   && F2
         DO ped_usd2 WITH .T.
      CASE m.key = -2   && F3
         SELECT cabepusd
         IF EOF() THEN
            WAIT "EL ARCHIVO ESTA VACIO, NO SE PUEDE REALIZAR MODIFICACIONES !" WINDOW
            LOOP
         ENDIF
         
         IF m.facturado THEN
            WAIT "ESTE PEDIDO YA HA SIDO FACTURADO, IMPOSIBLE MODIFICARLO !" WINDOW
            LOOP
         ENDIF
         
         DO ped_usd2 WITH .F.
      CASE m.key = -3   && F4
         DO select_order
      CASE m.key = -4   && F5
         DO search
      CASE m.key = -5   && F6
         DO datos_clie
      CASE m.key = -6   && F7 
         IF m.facturado THEN
            DO view_invoice
         ELSE
            WAIT "ESTE PEDIDO AUN NO HA SIDO FACTURADO !" WINDOW
            LOOP
         ENDIF
      CASE m.key = -7   && F8
         SELECT cabepusd
         IF EOF() THEN
            WAIT "EL ARCHIVO ESTA VACIO, NO SE PUEDE REALIZAR BORRADOS !" WINDOW
            LOOP
         ENDIF

         IF m.facturado THEN
            WAIT "ESTE PEDIDO YA HA SIDO FACTURADO, IMPOSIBLE BORRARLO !" WINDOW
            LOOP
         ENDIF

         IF messagebox("DESEA BORRARLO ?", 48) = 6 THEN
            DO delete_record

            SELECT cabepusd
            IF !BOF() THEN
               SKIP -1
               IF BOF() THEN
                  GOTO TOP
               ENDIF
            ENDIF
         ENDIF
      CASE m.key = -9   && F10
         DO lista
      CASE m.key = 134  && F12
         IF !m.facturado THEN
            IF EMPTY(m.nroot) THEN
               IF hay_stock() THEN
                  IF messagebox("DESEA FACTURAR ESTE PEDIDO ?", 48) = 6 THEN
                     DO calc_net
                     * BOB: parche, hasta encontrar la manera de acelerar el proceso de impresion.
*!*                     DO unload
*!*                     CLOSE DATABASES
*!*                     CLOSE ALL
*!*                     CLEAR ALL
*!*                     CLEAR
*!*                     QUIT
                     * EOB: parche
                  ENDIF
               ENDIF
            ELSE
               IF messagebox("DESEA FACTURAR ESTE PEDIDO ?", 48) = 6 THEN
                  DO calc_net
                  * BOB: parche, hasta encontrar la manera de acelerar el proceso de impresion.
*!*                  DO unload
*!*                  CLOSE DATABASES
*!*                  CLOSE ALL
*!*                  CLEAR ALL
*!*                  CLEAR
*!*                  QUIT
                  * EOB: parche
               ENDIF
            ENDIF
         ELSE
            WAIT "ESTE PEDIDO YA HA SIDO FACTURADO !" WINDOW
            LOOP
         ENDIF
      CASE m.key = 5    && UP
         DO next
      CASE m.key = 24   && DOWN
         DO previous
      CASE m.key = 19   && LEFT
         DO top
      CASE m.key = 4    && RIGHT
         DO bottom
      CASE INLIST(m.key, ASC("D"), ASC("d"))
         DO view_detail
   ENDCASE   
ENDDO

DO unload

*--------------------------------------------------------------------------*
PROCEDURE load

SET CENTURY    ON
SET DATE       BRITISH
SET DELETED    ON
SET NOTIFY     OFF
SET SAFETY     OFF
SET STATUS BAR OFF
SET SYSMENU    OFF
SET TALK       OFF
=CAPSLOCK(.T.)
=INSMODE(.T.)

IF !USED("cabepusd") THEN
   USE cabepusd IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabepus2") THEN
   USE cabepus2 IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detapusd") THEN
   USE detapusd IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("pedi_usd") THEN
   USE pedi_usd IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("plazos") THEN
   USE plazos IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("clientes") THEN
   USE clientes IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("vendedor") THEN
   USE vendedor IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("maesprod") THEN
   USE maesprod IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("marcas1") THEN
   USE marcas1 IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("ot") THEN
   USE ot IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabemot") THEN
   USE cabemot IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detamot") THEN
   USE detamot IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("mecanico") THEN
   USE mecanico IN 0 AGAIN ORDER 1 SHARED
ENDIF

SELECT 0
CREATE TABLE &archi_01 (;
   nrolinea N(5),;
   nropedido N(10),;
   articulo C(20),;
   cantidad N(9,2),;
   precio N(10,2),;
   porcdesc N(8,4),;
   porc_iva N(6,2),;
   mecanico N(5),;
   comi_mecan N(6,2),;
   descr_trab C(50),;
   mec_nombre C(50),;
   lista N(1);
)
USE &archi_01 ALIAS tmp_detape EXCLUSIVE

*--------------------------------------------------------------------------*
PROCEDURE unload

IF USED("cabepusd") THEN
   SELECT cabepusd
*   USE
ENDIF

IF USED("cabepus2") THEN
   SELECT cabepus2
*   USE
ENDIF

IF USED("detapusd") THEN
   SELECT detapusd
*   USE
ENDIF

IF USED("pedi_usd") THEN
   SELECT pedi_usd
*   USE
ENDIF

IF USED("plazos") THEN
   SELECT plazos
*   USE
ENDIF

IF USED("clientes") THEN
   SELECT clientes
*   USE
ENDIF

IF USED("vendedor") THEN
   SELECT vendedor
*   USE
ENDIF

IF USED("maesprod") THEN
   SELECT maesprod
*   USE
ENDIF

IF USED("marcas1") THEN
   SELECT marcas1
*   USE
ENDIF

IF USED("ot") THEN
   SELECT ot
*   USE
ENDIF

IF USED("cabemot") THEN
   SELECT cabemot
*   USE
ENDIF

IF USED("detamot") THEN
   SELECT detamot
*   USE
ENDIF

IF USED("mecanico") THEN
   SELECT mecanico
*   USE
ENDIF

IF USED("tmp_detape") THEN
   SELECT tmp_detape
   USE
ENDIF

SET COLOR OF SCHEME 1 TO W/N,N/W,W/N,N/W,W/N,W+/B,W/N,N+/N,W/N,W/N,-

DO borratemp WITH m.archi_01

RELEASE WINDOW nota_pedid

*--------------------------------------------------------------------------*
PROCEDURE init

SET COLOR OF SCHEME 1 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,,R+/B,+

IF !WEXIST("nota_pedid") THEN
   DEFINE WINDOW nota_pedid ;
      FROM 00,00 ;
      TO 24,79 ;
      TITLE "" ;
      NONE ;
      NOCLOSE ;
      NOFLOAT ;
      NOGROW ;
      NOMDI ;
      NOMINIMIZE ;
      NOSHADOW ;
      NOZOOM ;
      COLOR W+/B
ENDIF

IF WVISIBLE("nota_pedid") THEN
   ACTIVATE WINDOW nota_pedid SAME
ELSE
   ACTIVATE WINDOW nota_pedid NOSHOW
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE refresh

DO print_format
DO print_header
DO load_detail
DO print_detail
DO print_footer

IF m.facturado THEN
   @ 12,35 FILL TO 14,47 COLOR N+/N
   @ INT((SROW()-3)/2),INT((SCOL()-13)/2) TO INT((SROW()-3)/2)+2,INT((SCOL()-13)/2)+12 COLOR W+/RB
   DO center WITH 12, " FACTURADO ", "W+/RB"
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE print_format

*!*	@ 01,00 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ[ PEDIDOS DE CLIENTES ]ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿" COLOR W/B
*!*	@ 02,00 SAY "³ Pedido N§.:                                           Lista de Precios N§:   ³" COLOR W/B
*!*	@ 03,00 SAY "³ Fecha/Hora:                                           OT N§:                 ³" COLOR W/B
*!*	@ 04,00 SAY "³                                                                              ³" COLOR W/B
*!*	@ 05,00 SAY "³ Cliente...:                                                                  ³" COLOR W/B
*!*	@ 06,00 SAY "³ Vendedor..:                                                                  ³" COLOR W/B
*!*	@ 07,00 SAY "ÃÄDescripci¢nÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄCantidadÄÂÄPrecio Unit.ÄÄÂÄImporteÄÄ´" COLOR W/B
*!*	@ 08,00 SAY "³                                        ³          ³               ³          ³" COLOR W/B
*!*	@ 09,00 SAY "³                                        ³          ³               ³          ³" COLOR W/B
*!*	@ 10,00 SAY "³                                        ³          ³               ³          ³" COLOR W/B
*!*	@ 11,00 SAY "³                                        ³          ³               ³          ³" COLOR W/B
*!*	@ 12,00 SAY "³                                        ³          ³               ³          ³" COLOR W/B
*!*	@ 13,00 SAY "³                                        ³          ³               ³          ³" COLOR W/B
*!*	@ 14,00 SAY "³                                        ³          ³               ³          ³" COLOR W/B
*!*	@ 15,00 SAY "³                                        ³          ³               ³          ³" COLOR W/B
*!*	@ 16,00 SAY "³                                        ³          ³               ³          ³" COLOR W/B
*!*	@ 17,00 SAY "³                                        ³          ³               ³          ³" COLOR W/B
*!*	@ 18,00 SAY "³                                        ³          ³               ³          ³" COLOR W/B
*!*	@ 19,00 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´" COLOR W/B 
*!*	@ 20,00 SAY "³                                                        SUB-TOTAL:            ³" COLOR W/B
*!*	@ 21,00 SAY "³                                                      % DESCUENTO:            ³" COLOR W/B
*!*	@ 22,00 SAY "³                                                    TOTAL GENERAL:            ³" COLOR W/B
*!*	@ 23,00 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ" COLOR W/B

@ 01,00 CLEAR TO 23,79
@ 01,00 TO 23,79 COLOR GR+/B
DO center WITH 1, "[ PEDIDOS DE CLIENTES ]", "GR+/B"
@ 02,02 SAY "Pedido N§.:" COLOR BG+/B
@ 02,56 SAY "Lista de Precios N§:" COLOR BG+/B
@ 03,02 SAY "Fecha/Hora:" COLOR BG+/B
@ 03,56 SAY "OT N§:" COLOR BG+/B
@ 05,02 SAY "Cliente...:" COLOR BG+/B
@ 06,02 SAY "Vendedor..:" COLOR BG+/B
@ 07,00 SAY "ÃÄDescripci¢nÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄCantidadÄÂÄPrecio Unit.ÄÄÂÄImporteÄÄ´" COLOR GR+/B
FOR i = 8 TO 18
   @ i,00 SAY "³                                        ³          ³               ³          ³" COLOR GR+/B
ENDFOR
@ 19,00 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´" COLOR GR+/B
@ 20,57 SAY "SUB-TOTAL:" COLOR BG+/B
@ 21,55 SAY "% DESCUENTO:" COLOR BG+/B
@ 22,53 SAY "TOTAL GENERAL:" COLOR BG+/B

@ 00,00 TO 00,79 " " COLOR N/W
DO center WITH 0, " A & A IMPORTACIONES S.R.L. ", "N/W"
@ 24,00 TO 24,79 " " COLOR N/W
@ 24,00 SAY "1Ayuda  2Agrega 3Modif. 4Ordena 5Busca  6CamNom 7VerFAC 8Borra  9       10Lista " COLOR N/W
@ 24,00 SAY "1" SIZE 1,1 COLOR W+/B
j = 1
FOR i = 7 TO 63 STEP 8
   j = j + 1
   @ 24,i SAY STR(j, 2) SIZE 1,2 COLOR W+/B
ENDFOR
@ 24,71 SAY " 10" SIZE 1,3 COLOR W+/B
   
*--------------------------------------------------------------------------*
PROCEDURE print_header

SELECT cabepusd
SCATTER MEMVAR
@ 02,14 SAY m.nropedido SIZE 1,10 COLOR W+/BG
@ 02,77 SAY m.lista SIZE 1,1 COLOR W+/BG
@ 03,14 SAY m.fecha SIZE 1,10 COLOR W+/BG
@ 03,25 SAY m.hora SIZE 1,8 COLOR W+/BG
@ 03,63 SAY m.serieot PICTURE "@!" SIZE 1,1 COLOR W+/BG
@ 03,65 SAY m.nroot SIZE 1,10 COLOR W+/BG
@ 05,14 SAY m.cliente SIZE 1,5 COLOR W+/BG
@ 05,21 SAY LEFT(look_up("nombre", "clientes", m.cliente), 40) SIZE 1,40 COLOR W+/B 
@ 05,21 SAY LEFT(IIF(EMPTY(look_up("nombre", "cabepus2", m.nropedido)), look_up("nombre", "clientes", m.cliente), look_up("nombre", "cabepus2", m.nropedido)), 40) SIZE 1,40 COLOR W+/B 
@ 06,14 SAY m.vendedor SIZE 1,5 COLOR W+/BG
@ 06,21 SAY LEFT(look_up("nombre", "vendedor", m.vendedor), 40) SIZE 1,40 COLOR W+/B

@ 20,02 SAY IIF(INLIST(m.condicion, 1, 2), "Cond. de Venta:", "") SIZE 1,15 COLOR BG+/B
@ 20,18 SAY IIF(m.condicion = 1, "CONTADO", IIF(m.condicion = 2, "CREDITO", "")) SIZE 1,20 COLOR W+/BG

IF m.condicion = 2 THEN
   @ 21,02 SAY "Plazo de Venta:" SIZE 1,15 COLOR BG+/B
   @ 21,18 SAY LEFT(look_up("nombre", "plazos", m.plazo), 20) SIZE 1,20 COLOR W+/BG
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE print_detail

SELECT tmp_detape
GOTO TOP

@ 08,01 CLEAR TO 18,40   && Descripci¢n
@ 08,42 CLEAR TO 18,51   && Cantidad
@ 08,53 CLEAR TO 18,67   && Precio Unit.
@ 08,69 CLEAR TO 18,78   && Importe

i = 8
SCAN WHILE RECNO() <= 11 AND !(EMPTY(articulo) OR EMPTY(cantidad) OR EMPTY(precio))
   @ i,02 SAY LEFT(IIF(EMPTY(descr_trab), look_up("nombre", "maesprod", ALLTRIM(articulo)), descr_trab), 39) PICTURE "@!" SIZE 1,39 COLOR W+/BG
   @ i,42 SAY cantidad PICTURE "999,999.99" SIZE 1,10 COLOR W+/BG
   @ i,53 SAY precio PICTURE "9999,999,999.99" SIZE 1,15 COLOR W+/BG
   @ i,69 SAY ROUND(precio * cantidad, 2) PICTURE "999,999.99" SIZE 1,10 COLOR W+/BG
   i = i + 1
ENDSCAN

*--------------------------------------------------------------------------*
PROCEDURE print_footer

STORE 0 TO m.subtotal, m.total

SELECT tmp_detape
SCAN ALL
   m.subtotal = m.subtotal + ROUND(precio * cantidad, 2)
ENDSCAN

IF m.porcdesc <> 0 THEN
   m.importdesc = ROUND(m.subtotal * m.porcdesc / 100, 2)
ENDIF

m.total = m.subtotal - m.importdesc

@ 20,68 SAY m.subtotal PICTURE "9999,999.99" SIZE 1,11 COLOR W+/BG
@ 21,46 SAY m.porcdesc PICTURE "999.9999" SIZE 1,8 COLOR W+/BG
@ 21,68 SAY m.importdesc PICTURE "9999,999.99" SIZE 1,11 COLOR W+/BG
@ 22,68 SAY m.total PICTURE "9999,999.99" SIZE 1,11 COLOR W+/BG

*--------------------------------------------------------------------------*
PROCEDURE load_detail
PRIVATE m.nrolinea, m.articulo, m.cantidad, m.precio, m.porcdesc, m.porc_iva, m.mecanico, m.comi_mecan, m.descr_trab

SELECT tmp_detape
ZAP

SELECT detapusd
SET ORDER TO 1

IF SEEK(m.nropedido) THEN
   SCAN WHILE nropedido = m.nropedido
      SCATTER MEMVAR
      m.descr_trab = IIF(EMPTY(descr_trab), look_up("nombre", "maesprod", ALLTRIM(articulo)), descr_trab)
      m.mec_nombre = IIF(!EMPTY(mecanico), look_up("nombre", "mecanico", mecanico), "")
      INSERT INTO tmp_detape FROM MEMVAR
   ENDSCAN
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE center
PARAMETERS m.row, m.text, m.color
m.column = 40 - (LEN(m.text) / 2)
@ m.row, m.column SAY m.text COLOR (m.color)

*--------------------------------------------------------------------------*
PROCEDURE look_up
PARAMETER m.campo, m.tabla, m.expr_buscada

PRIVATE m.select, m.order, m.recno, m.retorno
m.select = SELECT()

SELECT (m.tabla)
m.order = VAL(SYS(21))
m.recno = IIF(EOF(), 0, RECNO())
SET ORDER TO 1

IF SEEK(m.expr_buscada) THEN
   m.retorno = &campo
ELSE
   m.retorno = " "
ENDIF

SET ORDER TO m.order
IF m.recno <> 0 THEN
   GOTO RECORD m.recno
ENDIF

IF !EMPTY(ALIAS(m.select)) THEN
   SELECT (m.select)
ENDIF

RETURN (m.retorno)

*--------------------------------------------------------------------------*
FUNCTION createmp
PRIVATE m.retorno

DO WHILE .T.
   m.retorno = "tm" + RIGHT(SYS(3), 6)
   IF !FILE(m.retorno + ".dbf") AND !FILE(m.retorno + ".cdx") AND !FILE(m.retorno + ".txt") THEN
      EXIT
   ENDIF
ENDDO

RETURN m.retorno

*--------------------------------------------------------------------------*
PROCEDURE borratemp
PARAMETER m.archivo

PRIVATE m.architm1, m.architm2, m.architm3

m.architm1 = m.archivo + ".dbf"
m.architm2 = m.archivo + ".cdx"
m.architm3 = m.archivo + ".txt"

IF FILE(m.architm1) THEN
   DELETE FILE (m.architm1)
ENDIF

IF FILE(m.architm2) THEN
   DELETE FILE (m.architm2)
ENDIF

IF FILE(m.architm3) THEN
   DELETE FILE (m.architm3)
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE next

SELECT cabepusd
IF !EOF() THEN
   SKIP 1
   IF EOF() THEN
      WAIT "FIN DEL ARCHIVO !" WINDOW NOWAIT
      GOTO BOTTOM
   ENDIF
ELSE
   WAIT "FIN DEL ARCHIVO !" WINDOW NOWAIT
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE previous

SELECT cabepusd
IF !BOF() THEN
   SKIP -1
   IF BOF() THEN
      WAIT "INICIO DEL ARCHIVO !" WINDOW NOWAIT
      GOTO TOP
   ENDIF
ELSE
   WAIT "INICIO DEL ARCHIVO !" WINDOW NOWAIT
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE top

SELECT cabepusd
GOTO TOP

*--------------------------------------------------------------------------*
PROCEDURE bottom

SELECT cabepusd
GOTO BOTTOM

*--------------------------------------------------------------------------*
PROCEDURE delete_record
PRIVATE m.order

* Borra el encabezado.
SELECT cabepusd
m.order = VAL(SYS(21))
SET ORDER TO 1
IF SEEK(m.nropedido) THEN
   DELETE
ENDIF
SET ORDER TO m.order

* Borra el detalle.
SELECT detapusd
DELETE FOR nropedido = m.nropedido

* Borra otros datos.
SELECT cabepus2
DELETE FOR nropedido = m.nropedido

*--------------------------------------------------------------------------*
FUNCTION messagebox
PARAMETER m.text, m.type

PRIVATE m.return

DO CASE
   CASE m.type = 48
      DO WHILE .T.
         WAIT m.text + " [S/N]" TO m.return WINDOW
         m.return = UPPER(m.return)
   
         IF INLIST(m.return, "S", "N") THEN
            EXIT
         ENDIF
      ENDDO
         
      IF m.return = "S" THEN
         m.return = 6
      ELSE
         m.return = 7
      ENDIF
      
      RETURN m.return
ENDCASE

*--------------------------------------------------------------------------*
PROCEDURE select_order

SELECT cabepusd
IF EOF() THEN
   WAIT "EL ARCHIVO ESTA VACIO, NO SE PUEDE ORDENAR !" WINDOW
   RETURN
ENDIF

PUSH KEY CLEAR

PRIVATE m.choice, a_order

IF !WEXIST("ordenar") THEN
   DEFINE WINDOW ordenar ;
      FROM INT((SROW()-7)/2),INT((SCOL()-24)/2) ;
      TO INT((SROW()-7)/2)+6,INT((SCOL()-24)/2)+23 ;
      TITLE " ORDENAR POR " ;
      SYSTEM ;
      NOCLOSE ;
      NOFLOAT ;
      NOGROW ;
      NOMDI ;
      NOMINIMIZE ;
      SHADOW ;
      NOZOOM ; 
      COLOR ,,N/W,N/W
ENDIF

IF WVISIBLE("ordenar") THEN
   ACTIVATE WINDOW ordenar SAME
ELSE
   ACTIVATE WINDOW ordenar NOSHOW
ENDIF

DIMENSION a_order[3]

a_order[1] = "1. N§ DE PEDIDO"
a_order[2] = "2. FECHA DE PEDIDO"
a_order[3] = "3. CLIENTE"

@ 00,00 GET m.choice PICTURE "@&T" FROM a_order SIZE 5,22 DEFAUL 1 VALID vldchoice() COLOR W+/BG,,W+/BG,,,BG+/B

IF !WVISIBLE("ordenar") THEN
   ACTIVATE WINDOW ordenar
ENDIF

READ CYCLE MODAL

RELEASE WINDOW ordenar
POP KEY

IF LASTKEY() <> 27 THEN
   DO search
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldchoice

SELECT cabepusd
SET ORDER TO m.choice

*--------------------------------------------------------------------------*
PROCEDURE search

SELECT cabepusd
IF EOF() THEN
   WAIT "EL ARCHIVO ESTA VACIO, NO SE PUEDE REALIZAR BUSQUEDAS !" WINDOW
   RETURN
ENDIF

PRIVATE m.order, m.recno, m.nropedido, m.fecha, m.cliente

SELECT cabepusd
m.order = VAL(SYS(21))
m.recno = IIF(EOF(), 0, RECNO())

DO CASE
   CASE m.order = 1
      IF !WEXIST("buscar") THEN
         DEFINE WINDOW buscar ;
            FROM INT((SROW()-3)/2),INT((SCOL()-30)/2) ;
            TO INT((SROW()-3)/2)+2,INT((SCOL()-30)/2)+29 ;
            TITLE "[ BUSCAR POR ]" ;
            NOCLOSE ;
            NOFLOAT ;
            NOGROW ;
            NOMDI ;
            NOMINIMIZE ;
            SHADOW ;
            NOZOOM
      ENDIF

      IF WVISIBLE("buscar") THEN
         ACTIVATE WINDOW buscar SAME
      ELSE
         ACTIVATE WINDOW buscar NOSHOW
      ENDIF

      STORE 0 TO m.nropedido

      @ 00,02 SAY "N§ DE PEDIDO:" SIZE 1,13 COLOR W+/B
      @ 00,16 GET m.nropedido PICTURE "9999999999" DEFAULT 0 SIZE 1,10 VALID vldnropedido()

      IF !WVISIBLE("buscar") THEN
         ACTIVATE WINDOW buscar
      ENDIF

      READ CYCLE MODAL

      RELEASE WINDOW buscar
   CASE m.order = 2
      IF !WEXIST("buscar") THEN
         DEFINE WINDOW buscar ;
            FROM INT((SROW()-3)/2),INT((SCOL()-33)/2) ;
            TO INT((SROW()-3)/2)+2,INT((SCOL()-33)/2)+32 ;
            TITLE "[ BUSCAR POR ]" ;
            NOCLOSE ;
            NOFLOAT ;
            NOGROW ;
            NOMDI ;
            NOMINIMIZE ;
            SHADOW ;
            NOZOOM
      ENDIF

      IF WVISIBLE("buscar") THEN
         ACTIVATE WINDOW buscar SAME
      ELSE
         ACTIVATE WINDOW buscar NOSHOW
      ENDIF

      STORE DATE() TO m.fecha

      @ 00,02 SAY "FECHA DE PEDIDO:" SIZE 1,16 COLOR W+/B
      @ 00,19 GET m.fecha PICTURE "@D" DEFAULT DATE() SIZE 1,10 VALID vldfecha()

      IF !WVISIBLE("buscar") THEN
         ACTIVATE WINDOW buscar
      ENDIF

      READ CYCLE MODAL

      RELEASE WINDOW buscar
   CASE m.order = 3
      IF !WEXIST("buscar") THEN
         DEFINE WINDOW buscar ;
            FROM INT((SROW()-3)/2),INT((SCOL()-20)/2) ;
            TO INT((SROW()-3)/2)+2,INT((SCOL()-20)/2)+19 ;
            TITLE "[ BUSCAR POR ]" ;
            NOCLOSE ;
            NOFLOAT ;
            NOGROW ;
            NOMDI ;
            NOMINIMIZE ;
            SHADOW ;
            NOZOOM
      ENDIF

      IF WVISIBLE("buscar") THEN
         ACTIVATE WINDOW buscar SAME
      ELSE
         ACTIVATE WINDOW buscar NOSHOW
      ENDIF

      STORE 0 TO m.cliente

      @ 00,02 SAY "CLIENTE:" SIZE 1,8 COLOR W+/B
      @ 00,11 GET m.cliente PICTURE "99999" DEFAULT 0 SIZE 1,5 VALID vldcliente()

      IF !WVISIBLE("buscar") THEN
         ACTIVATE WINDOW buscar
      ENDIF

      READ CYCLE MODAL

      RELEASE WINDOW buscar
ENDCASE

*--------------------------------------------------------------------------*
PROCEDURE vldnropedido

IF m.nropedido > 0 THEN
   IF !SEEK(m.nropedido) THEN
      IF m.recno <> 0 THEN
         GOTO RECORD m.recno
      ENDIF

      WAIT "EL DATO BUSCADO NO HA SIDO ENCONTRADO !" WINDOW
      RETURN 0
   ELSE
      CLEAR READ
   ENDIF
ELSE
   WAIT "EL N§ DE PEDIDO DEBE SER MAYOR QUE CERO !" WINDOW
   RETURN 0
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldfecha

IF !EMPTY(m.fecha) THEN
   IF !SEEK(DTOS(m.fecha)) THEN
      IF m.recno <> 0 THEN
         GOTO RECORD m.recno
      ENDIF

      WAIT "EL DATO BUSCADO NO HA SIDO ENCONTRADO !" WINDOW
      RETURN 0
   ELSE
      CLEAR READ
   ENDIF
ELSE
   WAIT "LA FECHA DE PEDIDO NO PUEDE QUEDAR EN BLANCO !" WINDOW
   RETURN 0
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldcliente
PRIVATE m.select

IF m.cliente > 0 THEN
   IF !SEEK(m.cliente) THEN
      IF m.recno <> 0 THEN
         GOTO RECORD m.recno
      ENDIF

      WAIT "EL DATO BUSCADO NO HA SIDO ENCONTRADO !" WINDOW
      RETURN 0
   ELSE
      CLEAR READ
   ENDIF
ELSE
   m.select = SELECT()

   DO buscclie WITH "m.cliente"

   IF !EMPTY(ALIAS(m.select)) THEN
      SELECT (m.select)
   ENDIF

   IF m.cliente = 0
      RETURN 0
   ENDIF
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE lista
PUSH KEY CLEAR

IF !WEXIST("lista") THEN
   DEFINE WINDOW lista ;
      FROM 01,00 ;
      TO 23,79 ;
      TITLE "PEDIDOS DE CLIENTES" ;
      SYSTEM ;
      CLOSE ;
      FLOAT ;
      NOGROW ;
      NOMDI ;
      NOMINIMIZE ;
      NOSHADOW ;
      NOZOOM ;
      COLOR W+/BG,GR+/RB,GR+/B,GR+/B,,,GR+/RB
ENDIF

@ 00,00 TO 00,79 " " COLOR N/W
DO center WITH 0, " A & A IMPORTACIONES S.R.L. ", "N/W"
@ 01,00,23,79 BOX REPLICATE(CHR(178), 8) + CHR(178)
@ 01,00 FILL TO 23,79 COLOR BG/B
@ 24,00 TO 24,79 " " COLOR N/W
@ 24,01 SAY "F4=Ordena  F5=Busca                                                ³  ESC=Sale" COLOR N/W

SELECT clientes
SET ORDER TO 1

SELECT cabepusd
SET RELATION TO cliente INTO clientes

ON KEY LABEL "F4" DO select_order
ON KEY LABEL "F5" DO search

BROWSE WINDOW lista FIELDS ;
   nropedido :R:9:P = "999999999" :H = "Pedido N§",;
   fecha :R:10:P = "@D" :H = "  Fecha",;
   hora :R:8:P = "99:99:99" :H = "  Hora",;
   total :R:11:P = "9999,999.99" :H = "  Importe",;
   b1 = IIF(facturado, "S", "") :R:1:P = "@!" :H = "",;
   b2 = LEFT(ALLTRIM(clientes.nombre) + SPACE(32), 32) :R:32:P = "@!" :H = "Cliente",;
   b3 = TRANSFORM(cliente, "9999999") :R:7:P = "9999999" :H = "C¢d.Cli";
   NOAPPEND NODELETE NOMODIFY

ON KEY LABEL "F4"
ON KEY LABEL "F5"

RELEASE WINDOW lista

POP KEY

*--------------------------------------------------------------------------*
PROCEDURE view_detail

IF !WEXIST("detalle") THEN
   DEFINE WINDOW detalle ;
      FROM 07,00 ;
      TO 19,79 ;
      TITLE "DETALLE" ;
      NONE ;
      NOCLOSE ;
      NOFLOAT ;
      GROW ;
      NOMDI ;
      NOMINIMIZE ;
      NOSHADOW ;
      NOZOOM ;
      COLOR W+/BG,GR+/RB,GR+/B,GR+/B,,,GR+/RB
ENDIF

SELECT tmp_detape
GOTO TOP

BROWSE WINDOW detalle FIELDS ;
   b1 = LEFT(articulo, 15) :R:15:P = "@!" :H = "Codigo",;
   lista :R:1:P = "9" :H = "",;
   b2 = LEFT(descr_trab, 36) :R:36:P = "@!" :H = "Descripcion",;
   cantidad :R:8:P = "99999.99" :H = "Cantidad",;
   precio :R:12:P = "9,999,999.99" :H = "Precio Unit.",;
   b3 = ROUND(precio * cantidad, 0) :R:11:P = "9999,999.99" :H = " Sub-Total ",;
   mecanico :R:5:P = "99999" :H = "Mec.",;
   b4 = LEFT(mec_nombre, 38) :R:38:P = "@!" :H = "Nombre del Mecanico";
   NOAPPEND NODELETE NOMODIFY

RELEASE WINDOW detalle

*--------------------------------------------------------------------------*
PROCEDURE datos_clie

PRIVATE m.documento, m.nombre, m.direccion, m.telefono, m.fax, m.observacio, ;
        m.editing, m.choice2
STORE " " TO m.documento, m.nombre, m.direccion, m.telefono, m.fax, m.observacio
STORE .F. TO m.editing
STORE  1  TO m.choice2

IF !WEXIST("datos_clie") THEN
   DEFINE WINDOW datos_clie ;
      FROM INT((SROW()-16)/2),INT((SCOL()-71)/2) ;
      TO INT((SROW()-16)/2)+15,INT((SCOL()-71)/2)+70 ;
      TITLE "[ DATOS DEL CLIENTE ]" ;
      NOCLOSE ;
      NOFLOAT ;
      NOGROW ;
      NOMDI ;
      NOMINIMIZE ;
      SHADOW ;
      NOZOOM
 ENDIF

IF WVISIBLE("datos_clie") THEN
   ACTIVATE WINDOW datos_clie SAME
ELSE
   ACTIVATE WINDOW datos_clie NOSHOW
ENDIF

SELECT cabepus2
SET ORDER TO 1
IF SEEK(m.nropedido) THEN
   SCATTER MEMVAR
ENDIF

@ 01,02 SAY "R.U.C. o C.I.:" SIZE 1,14 COLOR BG+/B
@ 02,02 SAY "Nombre.......:" SIZE 1,14 COLOR BG+/B
@ 03,02 SAY "Direcci¢n....:" SIZE 1,14 COLOR BG+/B
@ 05,02 SAY "Tel‚fono.....:" SIZE 1,14 COLOR BG+/B
@ 06,02 SAY "Fax..........:" SIZE 1,14 COLOR BG+/B
@ 08,02 SAY "Observaciones:" SIZE 1,14 COLOR BG+/B

@ 01,17 GET m.documento PICTURE "@!" DEFAULT " " SIZE 1,15 VALID vlddocumento() WHEN m.editing
@ 02,17 GET m.nombre PICTURE "@!" DEFAULT " " SIZE 1,50 VALID vldnombre() WHEN m.editing
@ 03,17 GET m.direccion PICTURE "@!" DEFAULT " " SIZE 2,50 WHEN m.editing
@ 05,17 GET m.telefono PICTURE "@!" DEFAULT " " SIZE 1,20 WHEN m.editing
@ 06,17 GET m.fax PICTURE "@!" DEFAULT " " SIZE 1,20 WHEN m.editing
@ 08,17 GET m.observacio PICTURE "@!" DEFAULT " " SIZE 3,50 WHEN m.editing
@ 12,21 GET m.choice2 PICTURE "@*HN \!\<Grabar;\?\<Cancelar" SIZE 1,12,3 DEFAULT 1 VALID vldchoice2()

IF !WVISIBLE("datos_clie") THEN
   ACTIVATE WINDOW datos_clie
ENDIF

READ CYCLE ACTIVATE actread() MODAL COLOR ,W+/G

RELEASE WINDOW datos_clie

*--------------------------------------------------------------------------*
FUNCTION vlddocumento

IF EMPTY(m.documento) THEN
   WAIT "EL N§ DE DOCUMENTO NO PUEDE QUEDAR EN BLANCO !" WINDOW
   RETURN 0
ELSE
   SELECT cabepus2
   SET ORDER TO 2
   IF SEEK(m.documento) THEN
      m.nombre    = nombre
      m.direccion = direccion
      m.telefono  = telefono
      m.fax       = fax
      SHOW GETS
   ENDIF
   
   IF NOT FOUND() THEN
      USE SYS(5) + "\turtle\aya\integrad.000\people\personas" IN 0 ORDER 1 ALIAS personas SHARED
      SELECT personas
      IF SEEK(ALLTRIM(m.documento)) THEN
         m.nombre = ALLTRIM(apellido) + ", " + ALLTRIM(nombre)
         SHOW GETS
      ELSE
         IF AT("-", m.documento) > 0 THEN
            IF SEEK(ALLTRIM(SUBSTR(m.documento, 1, AT("-", m.documento) - 1))) THEN
               m.nombre = ALLTRIM(apellido) + ", " + ALLTRIM(nombre)      
            ENDIF
         ENDIF
      ENDIF
      USE
   ENDIF
ENDIF

*--------------------------------------------------------------------------*
FUNCTION vldnombre

IF EMPTY(m.nombre) THEN
   WAIT "EL NOMBRE NO PUEDE QUEDAR EN BLANCO !" WINDOW
   RETURN 0
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldchoice2

IF m.facturado THEN
   WAIT "ESTE PEDIDO YA HA SIDO FACTURADO, IMPOSIBLE MODIFICARLO !" WINDOW
   RETURN 0
ENDIF

IF m.editing THEN
   IF m.choice2 = 1 THEN
      SELECT cabepus2
      SET ORDER TO 1
      IF SEEK(m.nropedido) THEN
         GATHER MEMVAR
      ELSE
         INSERT INTO cabepus2 FROM MEMVAR
      ENDIF

      FLUSH
      CLEAR READ
   ELSE
      CLEAR READ
   ENDIF
ELSE
   IF m.choice2 = 1 THEN
      m.editing = .T.

     SHOW GET m.choice2, 1 PROMPT "\!\<Grabar"
     SHOW GET m.choice2, 2 PROMPT "\<Cancelar"
     _CUROBJ = OBJNUM(m.documento)
   ELSE
      CLEAR READ
   ENDIF
ENDIF
      
*--------------------------------------------------------------------------*
PROCEDURE actread

SHOW GET m.choice2, 1 PROMPT "\!\<Modif."
SHOW GET m.choice2, 2 PROMPT "\<Salir"

*--------------------------------------------------------------------------*
PROCEDURE crear_dbf
CREATE TABLE cabepusd (;
   nropedido N(10),;
   fecha D(8),;
   hora C(8),;
   lista N(1),;
   serieot C(1),;
   nroot N(10),;
   cliente N(5),;
   vendedor N(5),;
   comision1 N(6,2),;
   comision2 N(6,2),;
   comision3 N(6,2),; 
   porcdesc N(8,4),;
   importdesc N(9),;
   total N(9),;
   condicion N(1),;
   plazo N(5),;
   facturado L(1);
)
INDEX ON nropedido TAG "nropedido"
INDEX ON DTOS(fecha) TAG "fecha"
INDEX ON cliente TAG "cliente"

CREATE TABLE cabepus2 (;
   nropedido N(10),;
   documento C(15),;
   nombre C(50),;
   direccion C(100),;
   telefono C(20),;
   fax C(20),;
   observacio C(150);
)
INDEX ON nropedido TAG "nropedido"
INDEX ON documento TAG "documento"

CREATE TABLE detapusd (;
   nrolinea N(5),;
   nropedido N(10),;
   articulo C(20),;
   cantidad N(9,2),;
   precio N(9),;
   porcdesc N(8,4),;
   porc_iva N(6,2),;
   mecanico N(5),;
   comi_mecan N(6,2),;
   descr_trab C(50);
)
INDEX ON nropedido TAG "nropedido"

CREATE TABLE pedi_usd (;
   nropedido N(10),;
   tipodocu N(5),;
   nrodocu N(10);
)
INDEX ON nropedido TAG "nropedido"

CREATE TABLE plazos (;
   codigo N(5),;
   nombre C(40),;
   num_vtos N(5),;
   separacion C(1),;
   primero N(5),;
   resto N(5);
)
INDEX ON codigo TAG "codigo"
INDEX ON nombre TAG "nombre"

INSERT INTO plazos VALUES (1, "A LA VISTA", 1, "M", 0, 0)
INSERT INTO plazos VALUES (2, "30 DIAS", 1, "M", 1, 1)
INSERT INTO plazos VALUES (3, "30/60 DIAS", 2, "M", 1, 1)
INSERT INTO plazos VALUES (4, "30/60/90 DIAS", 3, "M", 1, 1)

*--------------------------------------------------------------------------*
PROCEDURE calc_net
PRIVATE m.archi_01, m.subtotal, m.porcdesc, mtotal, m.diferencia

m.archi_01 = createmp()

SELECT cabepusd
REPLACE facturado WITH .T.

SELECT ot
SET ORDER TO 1
IF SEEK(m.serieot + STR(m.nroot, 7)) THEN
   REPLACE estadoot WITH 6
ENDIF

SELECT 0
CREATE TABLE &archi_01 (;
   nrolinea N(5),;
   nropedido N(10),;
   articulo C(20),;
   cantidad N(9,2),;
   precio N(10,2),;
   prec_neto N(10,2),;
   porcdesc N(8,4),;
   porc_iva N(6,2),;
   mecanico N(5),;
   comi_mecan N(6,2),;
   descr_trab C(50),;
   mec_nombre C(50);
)
USE &archi_01 ALIAS tmp_neto EXCLUSIVE

SELECT tmp_detape
SCAN ALL
   SCATTER MEMVAR
   INSERT INTO tmp_neto FROM MEMVAR
ENDSCAN

m.subtotal = 0
SELECT tmp_neto
SCAN ALL
   IF !INLIST(articulo, "99013", "99014", "10001") THEN
      m.subtotal = m.subtotal + ROUND(precio * cantidad, 2)
   ENDIF
ENDSCAN

m.porcdesc = m.importdesc * 100 / m.subtotal

SCAN ALL
   IF !INLIST(articulo, "99013", "99014", "10001") THEN
      REPLACE prec_neto WITH precio - ROUND(precio * m.porcdesc / 100, 2)
   ELSE
      REPLACE prec_neto WITH precio
   ENDIF
ENDSCAN

mtotal = 0
SCAN ALL
   mtotal = mtotal + ROUND(prec_neto * cantidad, 2)
ENDSCAN

m.diferencia = mtotal - m.total

IF m.diferencia <> 0.00 THEN
   SCAN ALL
      IF !INLIST(articulo, "99013", "99014", "10001") THEN
         IF MOD(m.diferencia, cantidad) = 0 THEN
            REPLACE prec_neto WITH prec_neto - (m.diferencia / cantidad)
            EXIT
         ENDIF
      ENDIF
   ENDSCAN
ENDIF

SCAN ALL
   IF !INLIST(ALLTRIM(articulo), "99013", "99014", "99015", "99016", "10001") THEN
      REPLACE descr_trab WITH ""
   ENDIF
ENDSCAN

*DO desc_art WITH m.nropedido
DO geninvoice

SELECT tmp_neto
USE
DO borratemp WITH m.archi_01
FLUSH

*--------------------------------------------------------------------------*
PROCEDURE geninvoice
PRIVATE m.tipodocu, m.nrodocu, m.articulo, m.cantidad, m.precio, m.pdescuento, m.impuesto, m.pimpuesto, m.mecanico, m.comision_m, m.descr_trab, m.id_local, ;
        i

IF m.condicion = 1 THEN
   m.tipodocu = 7
ELSE
   m.tipodocu = 8
ENDIF

i = 1
SELECT tmp_neto
SCAN ALL
   IF i = 1 THEN
      m.nrodocu    = calc_nrodocu()
      m.lstprecio  = m.lista
      m.fechadocu  = DATE()
      m.serie      = m.serieot
      m.nroot      = m.nroot
      m.moneda     = 2
      m.tipocambio = 0
      m.qty_cuotas = IIF(m.tipodocu = 7, 0, look_up("num_vtos", "plazos", m.plazo))
      m.nroremi    = 0
      m.fecharemi  = CTOD("  /  /    ")
      m.cliente    = m.cliente
      m.vendedor   = m.vendedor
      m.comision_1 = m.comision1
      m.comision_2 = m.comision2
      m.comision_3 = m.comision3
      m.porcdesc   = 0
      m.importdesc = 0
      m.descuento  = 0
      m.impreso    = .T.
      m.fechaanu   = CTOD("  /  /    ")
      m.anulado    = .F.
      m.monto_fact = 0
      m.monto_cobr = 0
      m.monto_ndeb = 0
      m.monto_ncre = 0
      m.consignaci = .F.
      m.id_local   = 0

      INSERT INTO cabevent FROM MEMVAR
      INSERT INTO pedi_usd FROM MEMVAR
   ENDIF

   m.articulo    = articulo
   m.cantidad    = cantidad
   m.precio      = ROUND(prec_neto / (1 + porc_iva / 100), 4)
   m.pdescuento  = porcdesc
   m.impuesto    = IIF(porc_iva > 0, .T., .F.)
   m.pimpuesto   = porc_iva
   m.mecanico    = mecanico
   m.comision_m  = comi_mecan
   m.descr_trab  = descr_trab
   m.id_local    = 0

   INSERT INTO detavent FROM MEMVAR

   m.monto_fact = m.monto_fact + ROUND(prec_neto * cantidad, 2)

   i = i + 1

   IF i > 18 OR RECCOUNT() = RECNO() THEN
      SELECT cabevent
      SET ORDER TO 1
      IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7)) THEN
         REPLACE monto_fact WITH m.monto_fact
      ENDIF

      IF m.condicion = 2 THEN
         DO calc_cuota

         SELECT clientes
         SET ORDER TO 1
         IF SEEK(m.cliente) THEN
            REPLACE saldo_usd WITH saldo_usd + m.monto_fact
         ENDIF
      ENDIF

      SELECT cabepus2
      SET ORDER TO 1
      IF SEEK(m.nropedido) THEN
         m.nombre     = nombre
         m.documento  = documento
         m.direc1     = SUBSTR(direccion, 1, 50)
         m.direc2     = SUBSTR(direccion, 51)
         m.telefono   = telefono
         m.fax        = fax

         IF RECCOUNT("tmp_neto") = RECNO("tmp_neto") THEN
            m.obs1 = SUBSTR(observacio, 1, 66)
            m.obs2 = SUBSTR(observacio, 67, 132)
            m.obs3 = SUBSTR(observacio, 133)
         ENDIF
         
         INSERT INTO cabeven2 FROM MEMVAR
      ENDIF
      i = 1
   ENDIF
   
   SELECT tmp_neto
   IF !INLIST(ALLTRIM(articulo), "99001", "99002", "99003", "99010", "99011", "99012", "99013", "99014", "99015", "99016", "99020", "99021", "99022", "10001") THEN
      SELECT maesprod
      SET ORDER TO 1
      IF SEEK(ALLTRIM(tmp_neto.articulo)) THEN
         REPLACE stock_actu WITH stock_actu - tmp_neto.cantidad
         IF !EMPTY(m.nroot) THEN
            REPLACE stock_ot WITH stock_ot - tmp_neto.cantidad
         ENDIF
      ENDIF
   ENDIF
   
   SELECT ot
   SET ORDER TO 1
   IF SEEK(m.serieot + STR(m.nroot, 7)) THEN
      REPLACE tipodocu WITH m.tipodocu
      REPLACE nrodocu  WITH m.nrodocu
   ENDIF
ENDSCAN

SELECT pedi_usd
SET ORDER TO 1
IF SEEK(m.nropedido) THEN
   SCAN WHILE nropedido = m.nropedido
      DO print_invoice WITH tipodocu, nrodocu
   ENDSCAN
ENDIF

*--------------------------------------------------------------------------*
FUNCTION calc_nrodocu
PRIVATE m.select, m.archi_01, m.return

m.select = SELECT()
m.return = 4004450

SELECT cabevent
SET ORDER TO 4

SEEK m.return

DO WHILE FOUND()
   m.return = m.return + 1
   SEEK m.return
ENDDO

IF !EMPTY(ALIAS(m.select)) THEN
   SELECT (m.select)
ENDIF

RETURN (m.return)

*--------------------------------------------------------------------------*
FUNCTION xcalc_nrodocu
PRIVATE m.select, m.archi_01, m.return

m.select = SELECT()
m.archi_01 = createmp()

SELECT nrodocu FROM cabevent WHERE nrodocu > 2000000 ORDER BY nrodocu DESC INTO TABLE &archi_01

IF RECCOUNT() = 0
   m.return = 2000001
ELSE
   m.return = nrodocu + 1
ENDIF

USE
DO borratemp WITH m.archi_01

IF !EMPTY(ALIAS(m.select)) THEN
   SELECT (m.select)
ENDIF

RETURN (m.return)

*--------------------------------------------------------------------------*
PROCEDURE view_invoice
PRIVATE m.archi_01

m.archi_01 = createmp()

SELECT 0
CREATE TABLE &archi_01 (;
   nropedido N(10),;
   tipodocu N(5),;
   nrodocu N(10);
)

USE &archi_01 ALIAS tmp_view EXCLUSIVE

SELECT pedi_usd
SET ORDER TO 1
IF SEEK(m.nropedido) THEN
   SCAN WHILE nropedido = m.nropedido
      SCATTER MEMVAR
      INSERT INTO tmp_view FROM MEMVAR
   ENDSCAN
ENDIF

IF !WEXIST("lista") THEN
   DEFINE WINDOW lista ;
      FROM INT((SROW()-10)/2),INT((SCOL()-33)/2) ;
      TO INT((SROW()-10)/2)+9,INT((SCOL()-33)/2)+32 ;
      TITLE "DOCUMENTOS GENERADOS" ;
      SYSTEM ;
      CLOSE ;
      FLOAT ;
      NOGROW ;
      NOMDI ;
      NOMINIMIZE ;
      NOSHADOW ;
      NOZOOM ;
      COLOR W+/BG,GR+/RB,GR+/B,GR+/B,,,GR+/RB
ENDIF

SELECT tmp_view
GOTO TOP
BROWSE WINDOW lista FIELDS ;
   b1 = IIF(tipodocu = 7, "FACTURA CONTADO   ", IIF(tipodocu = 8, "FACTURA CREDITO   ", "")) :R:18:P = "@!" :H = "",;
   b2 = TRANSFORM(nrodocu, "9999999999") :R:10:P = "9999999999" :H = "N§";
   NOAPPEND NODELETE NOMODIFY

USE
DO borratemp WITH m.archi_01
RELEASE WINDOW lista

*--------------------------------------------------------------------------*
PROCEDURE calc_cuota
PRIVATE m.num_vtos, m.separacion, m.primero, m.resto, m.resto2, m.monto_cuot, m.ulti_cuota, m.importe

m.num_vtos   = look_up("num_vtos", "plazos", m.plazo)
m.separacion = look_up("separacion", "plazos", m.plazo)
m.primero    = look_up("primero", "plazos", m.plazo)
m.resto      = look_up("resto", "plazos", m.plazo)
m.resto2     = m.resto
m.monto_cuot = ROUND(m.monto_fact / m.num_vtos, 2) 
m.ulti_cuota = m.monto_fact - (m.monto_cuot * (m.num_vtos - 1))

FOR i = 1 TO m.num_vtos
   * Calcula la fecha de vencimiento de la cuota.
   IF i = 1 THEN
      IF m.separacion = "D" THEN
         m.fecha = DATE() + m.primero
      ELSE
         m.fecha = GOMONTH(DATE(), m.primero)
      ENDIF
   ELSE
      IF m.separacion = "D" THEN
         m.fecha = DATE() + (m.primero + m.resto)
      ELSE
         m.fecha = GOMONTH(DATE(), (m.primero + m.resto))
      ENDIF
      m.resto = m.resto + m.resto2
   ENDIF
   
   IF DOW(m.fecha) = 1 THEN
      m.fecha = m.fecha + 1
   ENDIF
   
   * Calcula el importe de la cuota.
   IF i <> m.num_vtos THEN
      m.importe = m.monto_cuot
   ELSE
      m.importe = m.ulti_cuota
   ENDIF

   m.tipo       = 2
   m.nrocuota   = i
   m.abonado    = 0
   m.monto_ndeb = 0
   m.monto_ncre = 0
   m.id_local   = 0

   INSERT INTO cuotas_v FROM MEMVAR
ENDFOR

*--------------------------------------------------------------------------*
FUNCTION hay_stock
PRIVATE m.archi_01, m.return

m.archi_01 = createmp()
m.return   = .T.

SELECT 0
CREATE TABLE &archi_01 (;
   articulo C(20),;
   descr_trab C(40),;
   pedido N(9,2),;
   inventario N(9,2);
)

USE &archi_01 ALIAS tmp_hay EXCLUSIVE

SELECT tmp_detape
SCAN ALL
   IF !INLIST(ALLTRIM(articulo), "99001", "99002", "99003", "99010", "99011", "99012", "99013", "99014", "99015", "99016", "99020", "99021", "99022", "10001") THEN
      SCATTER MEMVAR
      m.pedido = m.cantidad
      m.inventario = calc_stock(ALLTRIM(articulo))
      IF m.pedido > m.inventario THEN
         INSERT INTO tmp_hay FROM MEMVAR
      ENDIF
   ENDIF
ENDSCAN

SELECT tmp_hay
IF RECCOUNT() > 0 THEN
   WAIT "NO SE PUEDE FACTURAR PORQUE HAY" + CHR(13) + "ARTICULOS SIN STOCK  SUFICIENTE" WINDOW NOWAIT
   m.return = .F.
   IF !WEXIST("lista") THEN
      DEFINE WINDOW lista ;
         FROM 07,00;
         TO 19,79 ;
         TITLE "ARTICULOS SIN STOCK SUFICIENTE" ;
         SYSTEM ;
         CLOSE ;
         FLOAT ;
         NOGROW ;
         NOMDI ;
         NOMINIMIZE ;
         NOSHADOW ;
         NOZOOM ;
         COLOR W+/BG,GR+/RB,GR+/B,GR+/B,,,GR+/RB
   ENDIF

   GOTO TOP
   BROWSE WINDOW lista FIELDS ;
      b1 = LEFT(articulo, 10) :R:10:P = "@!" :H = "C¢digo",;
      b2 = LEFT(descr_trab, 39) :R:39:P = "@!" :H = "Descripci¢n",;
      b3 = TRANSFORM(pedido, "999999999.99") :R:12:P = "999999999.99" :H = "Cant. Pedido",;
      b4 = TRANSFORM(inventario, "999999999.99") :R:12:P = "999999999.99" :H = "Stock Disp.";
      NOAPPEND NODELETE NOMODIFY
ENDIF

USE
DO borratemp WITH m.archi_01
RELEASE WINDOW lista

RETURN (m.return)

*--------------------------------------------------------------------------*
FUNCTION calc_stock
PARAMETER m.articulo

PRIVATE m.select, m.order, m.recno, m.return
m.select = SELECT()
m.return = 0

SELECT maesprod
m.order = VAL(SYS(21))
m.recno = IIF(EOF(), 0, RECNO())
SET ORDER TO 1

IF SEEK(m.articulo) THEN
   m.return = stock_actu - stock_ot
ENDIF

*-- BOF: Deposito --*
IF !USED("maesprod2") THEN
   USE SYS(5) + "\turtle\aya\integrad.001\maesprod" IN 0 AGAIN ORDER 1 SHARED ALIAS maesprod2
ENDIF

SELECT maesprod2
SET ORDER TO 1

IF SEEK(m.articulo) THEN
   m.return = m.return + (stock_actu - stock_ot)
ENDIF

IF USED("maesprod2") THEN
   SELECT maesprod2
   USE
ENDIF

SELECT maesprod
*-- EOF: Deposito --*

SET ORDER TO m.order
IF m.recno <> 0 THEN
   GOTO RECORD m.recno
ENDIF

IF !EMPTY(ALIAS(m.select)) THEN
   SELECT (m.select)
ENDIF

RETURN (m.return)

*!*	FUNCTION calc_stock
*!*	PARAMETER m.articulo

*!*	PRIVATE m.select, m.order, m.recno, m.return
*!*	m.select = SELECT()
*!*	m.return = 0

*!*	SELECT maesprod
*!*	m.order = VAL(SYS(21))
*!*	m.recno = IIF(EOF(), 0, RECNO())
*!*	SET ORDER TO 1

*!*	IF SEEK(m.articulo) THEN
*!*	   m.return = stock_actu - stock_ot
*!*	ENDIF

*!*	SET ORDER TO m.order
*!*	IF m.recno <> 0 THEN
*!*	   GOTO RECORD m.recno
*!*	ENDIF

*!*	IF !EMPTY(ALIAS(m.select)) THEN
*!*	   SELECT (m.select)
*!*	ENDIF

*!*	RETURN (m.return)

*--------------------------------------------------------------------------*
PROCEDURE print_invoice
PARAMETERS m.tipodocu, m.nrodocu
PRIVATE m.nrofactura, m.vendedor, m.hora, m.condicion, m.fecha, m.cliente, m.nombre, m.ruc, m.direccion, m.telefono, m.cantidad, m.articulo, m.descr_trab, m.precio, m.porc_iva, m.iva_5p, m.iva_10p, ;
        m.archi_01

m.archi_01 = createmp()

SELECT 0
CREATE TABLE &archi_01 (;
   nrofactura C(6),;
   vendedor N(5),;
   hora C(8),;
   fecha C(30),;
   condicion C(30),;
   cliente N(5),;
   nombre C(50),;
   ruc C(15),;
   direccion C(100),;
   telefono C(30),;
   cantidad N(9,2),;
   articulo C(20),;
   descr_trab C(40),;
   precio N(10,2),;
   porc_iva N(6,2),;
   iva_5p N(9,2),;
   iva_10p N(9,2),;
   monto_fact N(9,2),;
   obs1 C(70),;
   obs2 C(70),;
   obs3 C(45),;
   serieot C(1),;
   nroot N(7);
)
USE &archi_01 ALIAS tmp_factur EXCLUSIVE

SELECT cabevent
SET ORDER TO 1
SEEK STR(m.tipodocu, 1) + STR(m.nrodocu, 7)

SELECT clientes
SET ORDER TO 1
SEEK cabevent.cliente

SELECT vendedor
SET ORDER TO 1
SEEK cabevent.vendedor

SELECT cabeven2
SET ORDER TO 1
SEEK STR(m.tipodocu, 1) + STR(m.nrodocu, 7)

SELECT detavent
SET ORDER TO 1
IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7)) THEN
   SCAN WHILE tipodocu = m.tipodocu AND nrodocu = m.nrodocu
      m.nrofactura = SUBSTR(STR(m.nrodocu, 7), 2)
      m.vendedor   = cabevent.vendedor
      m.hora       = TIME()
      m.condicion  = IIF(m.tipodocu = 7, "CONTADO", look_up("nombre", "plazos", m.plazo))
      m.fecha      = getdate(cabevent.fechadocu)
      m.cliente    = cabevent.cliente
      m.nombre     = IIF(EMPTY(cabeven2.nombre), clientes.nombre, cabeven2.nombre)
      m.ruc        = IIF(EMPTY(cabeven2.documento), clientes.ruc, cabeven2.documento)
      m.direccion  = IIF(EMPTY(cabeven2.direc1 + cabeven2.direc2), clientes.direc1, cabeven2.direc1 + cabeven2.direc2)
      m.telefono   = IIF(EMPTY(cabeven2.telefono), clientes.telefono, cabeven2.telefono)
      m.cantidad   = cantidad
      m.articulo   = articulo
      m.descr_trab = IIF(EMPTY(descr_trab), look_up("nombre", "maesprod", ALLTRIM(articulo)), descr_trab)
      m.precio     = ROUND(precio * (1 + pimpuesto / 100), 2)
      m.porc_iva   = pimpuesto
      m.iva_5p     = 0
      m.iva_10p    = 0      
      m.monto_fact = cabevent.monto_fact
      m.observacio = IIF(!EMPTY(cabeven2.obs1), cabeven2.obs1, "") + IIF(!EMPTY(cabeven2.obs2), cabeven2.obs2, "") + IIF(!EMPTY(cabeven2.obs3), cabeven2.obs3, "")
      m.obs1       = SUBSTR(m.observacio, 1, 70)
      m.obs2       = SUBSTR(m.observacio, 71, 70)
*     m.obs1       = SUBSTR(m.observacio, 1, 45)
*     m.obs2       = SUBSTR(m.observacio, 46, 90)
*     m.obs3       = SUBSTR(m.observacio, 91)
      m.serieot    = cabevent.serie
      m.nroot      = cabevent.nroot

      INSERT INTO tmp_factur FROM MEMVAR
   ENDSCAN
ENDIF

m.iva_5p  = 0
m.iva_10p = 0

SELECT tmp_factura
SCAN ALL
   DO CASE
      CASE porc_iva = 5 
         m.iva_5p = m.iva_5p + ROUND(precio * cantidad, 2)
      CASE porc_iva = 10
         m.iva_10p = m.iva_10p + ROUND(precio * cantidad, 2)
   ENDCASE
ENDSCAN  

m.iva_5p  = m.iva_5p - ROUND(m.iva_5p / 1.05, 2)
m.iva_10p = m.iva_10p - ROUND(m.iva_10p / 1.1, 2)

REPLACE iva_5p  WITH m.iva_5p ALL
REPLACE iva_10p WITH m.iva_10p ALL

IF _PADVANCE = "FORMFEED"
   _PADVANCE = "LINEFEEDS"
   cPageAdva = "FORMFEED"
ELSE
   cPageAdva = "LINEFEEDS"
ENDIF

*REPORT FORM factura2 PREVIEW
REPORT FORM factura2 TO PRINTER NOCONSOLE

IF cPageAdva = "FORMFEED"
   _PADVANCE = "FORMFEED"
ENDIF

USE
DO borratemp WITH m.archi_01

*--------------------------------------------------------------------------*
FUNCTION getdate
PARAMETER m.fecha

PRIVATE m.day, m.month, m.year

m.day = ALLTRIM(STR(DAY(m.fecha)))
m.day = IIF(LEN(m.day) = 1, "0" + m.day, m.day)

DO CASE
   CASE MONTH(m.fecha) = 1
      m.month = "ENERO    "
   CASE MONTH(m.fecha) = 2
      m.month = "FEBRERO  "
   CASE MONTH(m.fecha) = 3
      m.month = "MARZO    "
   CASE MONTH(m.fecha) = 4
      m.month = "ABRIL    "
   CASE MONTH(m.fecha) = 5
      m.month = "MAYO     "
   CASE MONTH(m.fecha) = 6
      m.month = "JUNIO    "
   CASE MONTH(m.fecha) = 7
      m.month = "JULIO    "
   CASE MONTH(m.fecha) = 8
      m.month = "AGOSTO   "
   CASE MONTH(m.fecha) = 9
      m.month = "SETIEMBRE"
   CASE MONTH(m.fecha) = 10
      m.month = "OCTUBRE  "
   CASE MONTH(m.fecha) = 11
      m.month = "NOVIEMBRE"
   CASE MONTH(m.fecha) = 12
      m.month = "DICIEMBRE"
ENDCASE

m.year = ALLTRIM(STR(YEAR(m.fecha)))

*RETURN (m.day + SPACE(6) + m.month + SPACE(6) + m.year)
RETURN (m.day + " DE " + ALLTRIM(m.month) + " DE " + m.year)
