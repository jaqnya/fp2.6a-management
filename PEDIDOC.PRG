PRIVATE m.nropedido, m.fecha, m.hora, m.lista, m.serieot, m.nroot, m.cliente, m.vendedor, m.comision1, m.comision2, m.comision3, m.porcdesc, m.importdesc, m.total, m.condicion, m.plazo, m.facturado ;
        m.archi_01, m.key, m.subtotal, m.mostrar_desc

STORE  0  TO m.nropedido, m.lista, m.nroot, m.cliente, m.vendedor, m.comision1, m.comision2, m.comision3, m.porcdesc, m.importdesc, m.total, m.condicion, m.plazo
STORE " " TO m.hora, m.serieot
STORE .F. TO m.facturado, m.mostrar_desc
STORE CTOD("  /  /    ") TO m.fecha

STORE 0 TO m.key, m.subtotal
STORE createmp() TO m.archi_01

DO load
DO init

SELECT cabepedc
GOTO TOP
DO refresh

IF !WVISIBLE("nota_pedid") THEN
   ACTIVATE WINDOW nota_pedid
ENDIF

DO WHILE .T.
   IF INLIST(m.key, -1, -2, -3, -4, -5, -6, -7, -9, 134, 5, 24, 19, 4, 96, 16) THEN   && F2, F3, F4, F5, F8, F12, UP, DOWN, LEFT, RIGHT, CTRL+F3, CTRL+P
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
*!*	            DO rpt_ped2 WITH m.nropedido   && utilizar cuando es un solo local
            DO rpt_ped4 WITH m.nropedido
         ENDIF
      CASE m.key = -1   && F2
         DO pedidoc2 WITH .T.
      CASE m.key = -2   && F3
         IF !look_up("facturado", "cabepedc", m.nropedido) THEN
            SELECT cabepedc
            IF EOF() THEN
               WAIT "EL ARCHIVO ESTA VACIO, NO SE PUEDE REALIZAR MODIFICACIONES !" WINDOW
               LOOP
            ENDIF

            IF m.facturado THEN
               WAIT "ESTE PEDIDO YA HA SIDO FACTURADO, IMPOSIBLE MODIFICARLO !" WINDOW
               LOOP
            ENDIF
         
            DO pedidoc2 WITH .F.
         ELSE
            WAIT "ESTE PEDIDO YA HA SIDO FACTURADO !" WINDOW
            LOOP
         ENDIF
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
         IF !look_up("facturado", "cabepedc", m.nropedido) THEN
            SELECT cabepedc
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

               SELECT cabepedc
               IF !BOF() THEN
                  SKIP -1
                  IF BOF() THEN
                     GOTO TOP
                  ENDIF
               ENDIF
            ENDIF
         ELSE
            WAIT "ESTE PEDIDO YA HA SIDO FACTURADO !" WINDOW
            LOOP
         ENDIF
      CASE m.key = -9   && F10
         DO lista
      CASE m.key = 134  && F12
      IF !look_up("facturado", "cabepedc", m.nropedido) THEN
         IF !m.facturado THEN
            * intenta bloquear los archivos de ventas.
            SET NOTIFY ON
            IF !FLOCK("cabevent") THEN
               SET NOTIFY OFF
               LOOP
            ENDIF

            IF !FLOCK("cabeven2") THEN
               SET NOTIFY OFF
               UNLOCK IN cabevent
               LOOP
            ENDIF

            IF !FLOCK("detavent") THEN
               SET NOTIFY OFF
               UNLOCK IN cabevent
               UNLOCK IN cabeven2
               LOOP
            ENDIF

            IF !FLOCK("cuotas_v") THEN
               SET NOTIFY OFF
               UNLOCK IN cabevent
               UNLOCK IN cabeven2
               UNLOCK IN detavent
               LOOP
            ENDIF

            IF !FLOCK("ot") THEN
               SET NOTIFY OFF
               UNLOCK IN cabevent
               UNLOCK IN cabeven2
               UNLOCK IN detavent
               UNLOCK IN cuotas_v
               LOOP
            ENDIF

            IF !FLOCK("clientes") THEN
               SET NOTIFY OFF
               UNLOCK IN cabevent
               UNLOCK IN cabeven2
               UNLOCK IN detavent
               UNLOCK IN cuotas_v
               UNLOCK IN ot
               LOOP
            ENDIF

*!*	            IF !FLOCK("maesprod") THEN
*!*	               SET NOTIFY OFF
*!*	               UNLOCK IN cabevent
*!*	               UNLOCK IN cabeven2
*!*	               UNLOCK IN detavent
*!*	               UNLOCK IN cuotas_v
*!*	               UNLOCK IN ot
*!*	               UNLOCK IN clientes
*!*	               LOOP
*!*	            ENDIF

            IF !FLOCK("pedifact") THEN
               SET NOTIFY OFF
               UNLOCK IN cabevent
               UNLOCK IN cabeven2
               UNLOCK IN detavent
               UNLOCK IN cuotas_v
               UNLOCK IN ot
               UNLOCK IN clientes
               UNLOCK IN maesprod
               LOOP
            ENDIF
            *----------------------------------------*

            IF EMPTY(m.nroot) THEN
               IF saldo_ok() THEN

                  m.saldo_ok2 = saldo_ok2()

                  IF m.saldo_ok2 = 0 THEN
                     IF hay_stock() THEN
                        IF messagebox("DESEA FACTURAR ESTE PEDIDO ?", 48) = 6 THEN

                           m.mostrar_desc = .F.

                           IF gnUser = 1 AND m.importdesc > 0 THEN
                              IF messagebox("DESEA QUE EL DESCUENTO FIGURE EN LA FACTURA ?", 48) = 6 THEN
                                 m.mostrar_desc = .T.
                              ENDIF
                           ENDIF

                           DO calc_net
                           * BOB: parche, hasta encontrar la manera de acelerar el proceso de impresion.
*!*	                           DO unload
*!*	                           CLOSE DATABASES
*!*	                           CLOSE ALL
*!*	                           CLEAR ALL
*!*	                           CLEAR
*!*	                           QUIT
                           * EOB: parche
                        ENDIF
                     ENDIF
                  ELSE
                     IF gnUser = 1   && ADMINISTRADOR
                        WAIT "EL CLIENTE TIENE UN SALDO EN MORA DE" + CHR(13) + "Gs. " + ALLTRIM(TRANSFORM(m.saldo_ok2, "999,999,999")) + ". NO SE PUEDE FACTURAR." WINDOW
                     ELSE
                        WAIT "NO SE PUEDE FACTURAR. POR FAVOR, CONSULTE CON EL ADMINISTRADOR" WINDOW
                     ENDIF
                  ENDIF
               ELSE
                  IF gnUser = 1   && ADMINISTRADOR
                     PRIVATE msaldo_actu, mlimite_cre
   
                     msaldo_actu = look_up("saldo_actu", "clientes", m.cliente)
                     mlimite_cre = look_up("limite_cre", "clientes", m.cliente)
   
                     WAIT "EL CLIENTE HA EXCEDIDO SU LINEA DE CREDITO EN Gs. " + ALLTRIM(TRANSFORM((msaldo_actu + m.total) - mlimite_cre, "999,999,999")) WINDOW
                  ELSE
                     WAIT "LIMITE DE CREDITO EXCEDIDO, NO SE PUEDE FACTURAR" + CHR(13) + "POR FAVOR, CONSULTE CON EL ADMINISTRADOR." WINDOW
                  ENDIF
               ENDIF
            ELSE   && Imprime factura de una OT.
               IF saldo_ok() THEN

                  m.saldo_ok2 = saldo_ok2()

                  IF m.saldo_ok2 = 0 THEN
                     IF messagebox("DESEA FACTURAR ESTE PEDIDO ?", 48) = 6 THEN
                        m.mostrar_desc = .F.

                        IF gnUser = 1 AND m.importdesc > 0 THEN
                           IF messagebox("DESEA QUE EL DESCUENTO FIGURE EN LA FACTURA ?", 48) = 6 THEN
                              m.mostrar_desc = .T.
                           ENDIF
                        ENDIF



                        * BOB: Descuento promo servicio tecnico, por mes aniversario.
                        IF YEAR(DATE()) = 2018 AND MONTH(DATE()) = 9 THEN
                           IF m.porcdesc = 15 AND m.importdesc > 0 THEN
                              m.mostrar_desc = .T.
                           ENDIF
                        ENDIF
                        * EOB: Descuento promo servicio tecnico, por mes aniversario.



                        DO calc_net
                           * BOB: parche, hasta encontrar la manera de acelerar el proceso de impresion.
*!*	                           DO unload
*!*	                           CLOSE DATABASES
*!*	                           CLOSE ALL
*!*	                           CLEAR ALL
*!*	                           CLEAR
*!*	                           QUIT
                           * EOB: parche
                     ENDIF
                  ELSE
                     IF gnUser = 1   && ADMINISTRADOR
                        WAIT "EL CLIENTE TIENE UN SALDO EN MORA DE" + CHR(13) + "Gs. " + ALLTRIM(TRANSFORM(m.saldo_ok2, "999,999,999")) + ". NO SE PUEDE FACTURAR." WINDOW
                     ELSE
                        WAIT "NO SE PUEDE FACTURAR. POR FAVOR, CONSULTE CON EL ADMINISTRADOR" WINDOW
                     ENDIF
                  ENDIF
               ELSE
                  IF gnUser = 1   && ADMINISTRADOR
                     PRIVATE msaldo_actu, mlimite_cre
   
                     msaldo_actu = look_up("saldo_actu", "clientes", m.cliente)
                     mlimite_cre = look_up("limite_cre", "clientes", m.cliente)
   
                     WAIT "EL CLIENTE HA EXCEDIDO SU LINEA DE CREDITO EN Gs. " + ALLTRIM(TRANSFORM((msaldo_actu + m.total) - mlimite_cre, "999,999,999")) WINDOW
                  ELSE
                     WAIT "LIMITE DE CREDITO EXCEDIDO, NO SE PUEDE FACTURAR" + CHR(13) + "POR FAVOR, CONSULTE CON EL ADMINISTRADOR." WINDOW
                  ENDIF
               ENDIF
            ENDIF

            * desbloquea los archivos.
            UNLOCK IN cabevent
            UNLOCK IN cabeven2
            UNLOCK IN detavent
            UNLOCK IN cuotas_v
            UNLOCK IN ot
            UNLOCK IN clientes
            UNLOCK IN maesprod
            UNLOCK IN pedifact
         ELSE
            WAIT "ESTE PEDIDO YA HA SIDO FACTURADO !" WINDOW
            LOOP
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
      CASE m.key = 96   && CTRL+F3
         SELECT cabepedc
         IF EOF() THEN
            WAIT "EL ARCHIVO ESTA VACIO, NO SE PUEDE REALIZAR MODIFICACIONES !" WINDOW
            LOOP
         ENDIF
         
         IF m.facturado THEN
            WAIT "ESTE PEDIDO YA HA SIDO FACTURADO, IMPOSIBLE MODIFICARLO !" WINDOW
            LOOP
         ENDIF

         DO edit_prices
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

IF !USED("cabepedc") THEN
   USE cabepedc IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabeped2") THEN
   USE cabeped2 IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detapedc") THEN
   USE detapedc IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("pedifact") THEN
   USE pedifact IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("pediarti") THEN
   USE pediarti IN 0 AGAIN ORDER 0 SHARED
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

IF !USED("cabeofer") THEN
   USE cabeofer IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detaofer") THEN
   USE detaofer IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabevent") THEN
   USE cabevent IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabeven2") THEN
   USE cabeven2 IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detavent") THEN
   USE detavent IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cuotas_v") THEN
   USE cuotas_v IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("depar") THEN
   USE depar IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("ciudades") THEN
   USE ciudades IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF USED("tmp_detape") THEN
   SELECT tmp_detape
   USE
ENDIF

IF USED("tmp_neto") THEN
   SELECT tmp_neto
   USE
ENDIF

IF USED("tmp_factur") THEN
   SELECT tmp_factur
   USE
ENDIF

SELECT 0
CREATE TABLE &archi_01 (;
   nrolinea N(5),;
   nropedido N(10),;
   articulo C(15),;
   codigo2 C(15),;
   ubicacion C(10),;
   cantidad N(9,2),;
   precio N(10),;
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

IF USED("cabepedc") THEN
   SELECT cabepedc
*   USE
ENDIF

IF USED("cabeped2") THEN
   SELECT cabeped2
*   USE
ENDIF

IF USED("detapedc") THEN
   SELECT detapedc
*   USE
ENDIF

IF USED("pedifact") THEN
   SELECT pedifact
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

SELECT cabepedc
SCATTER MEMVAR
@ 02,14 SAY m.nropedido SIZE 1,10 COLOR W+/BG
@ 02,77 SAY m.lista SIZE 1,1 COLOR W+/BG
@ 03,14 SAY m.fecha SIZE 1,10 COLOR W+/BG
@ 03,25 SAY m.hora SIZE 1,8 COLOR W+/BG
@ 03,63 SAY m.serieot PICTURE "@!" SIZE 1,1 COLOR W+/BG
@ 03,65 SAY m.nroot SIZE 1,10 COLOR W+/BG
@ 05,14 SAY m.cliente SIZE 1,5 COLOR W+/BG
@ 05,21 SAY LEFT(look_up("nombre", "clientes", m.cliente), 40) SIZE 1,40 COLOR W+/B 
@ 05,21 SAY LEFT(IIF(EMPTY(look_up("nombre", "cabeped2", m.nropedido)), look_up("nombre", "clientes", m.cliente), look_up("nombre", "cabeped2", m.nropedido)), 40) SIZE 1,40 COLOR W+/B 
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
   @ i,53 SAY precio PICTURE "999,999,999,999" SIZE 1,15 COLOR W+/BG
   @ i,69 SAY ROUND(precio * cantidad, 0) PICTURE "99,999,999" SIZE 1,10 COLOR W+/BG
   i = i + 1
ENDSCAN

*--------------------------------------------------------------------------*
PROCEDURE print_footer

STORE 0 TO m.subtotal, m.total

SELECT tmp_detape
SCAN ALL
   m.subtotal = m.subtotal + ROUND(precio * cantidad, 0)
ENDSCAN

IF m.porcdesc <> 0 THEN
   m.importdesc = ROUND(m.subtotal * m.porcdesc / 100, 0)
ENDIF

m.total = m.subtotal - m.importdesc

@ 20,68 SAY m.subtotal PICTURE "999,999,999" SIZE 1,11 COLOR W+/BG
@ 21,46 SAY m.porcdesc PICTURE "999.9999" SIZE 1,8 COLOR W+/BG
@ 21,68 SAY m.importdesc PICTURE "999,999,999" SIZE 1,11 COLOR W+/BG
@ 22,68 SAY m.total PICTURE "999,999,999" SIZE 1,11 COLOR W+/BG

*--------------------------------------------------------------------------*
PROCEDURE load_detail
PRIVATE m.nrolinea, m.articulo, m.cantidad, m.precio, m.porcdesc, m.porc_iva, m.mecanico, m.comi_mecan, m.descr_trab

SELECT tmp_detape
ZAP

SELECT detapedc
SET ORDER TO 1

IF SEEK(m.nropedido) THEN
   SCAN WHILE nropedido = m.nropedido
      SCATTER MEMVAR
      m.codigo2    = look_up("codigo2", "maesprod", ALLTRIM(articulo))
      m.ubicacion  = look_up("ubicacion", "maesprod", ALLTRIM(articulo))
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

SELECT cabepedc
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

SELECT cabepedc
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

SELECT cabepedc
GOTO TOP

*--------------------------------------------------------------------------*
PROCEDURE bottom

SELECT cabepedc
GOTO BOTTOM

*--------------------------------------------------------------------------*
PROCEDURE delete_record
PRIVATE m.order

* Borra el encabezado.
SELECT cabepedc
m.order = VAL(SYS(21))
SET ORDER TO 1
IF SEEK(m.nropedido) THEN
   DELETE
ENDIF
SET ORDER TO m.order

* Borra el detalle.
SELECT detapedc
DELETE FOR nropedido = m.nropedido

*BOB: Elimina datos de la tabla relacion entre articulo y pedido
SELECT PediArti
DELETE FOR NroPedido = m.NroPedido
*EOB: Elimina datos de la tabla relacion entre articulo y pedido

* Borra otros datos.
IF TYPE("m.adding") = "U" THEN
   SELECT cabeped2
   DELETE FOR nropedido = m.nropedido
ENDIF

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

SELECT cabepedc
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

SELECT cabepedc
SET ORDER TO m.choice

*--------------------------------------------------------------------------*
PROCEDURE search

SELECT cabepedc
IF EOF() THEN
   WAIT "EL ARCHIVO ESTA VACIO, NO SE PUEDE REALIZAR BUSQUEDAS !" WINDOW
   RETURN
ENDIF

PRIVATE m.order, m.recno, m.nropedido, m.fecha, m.cliente

SELECT cabepedc
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

SELECT cabepedc
SET RELATION TO cliente INTO clientes

ON KEY LABEL "F4" DO select_order
ON KEY LABEL "F5" DO search

BROWSE WINDOW lista FIELDS ;
   nropedido :R:10:P = "9999999999" :H = "Pedido N§",;
   fecha :R:10:P = "@D" :H = "  Fecha",;
   hora :R:8:P = "99:99:99" :H = "  Hora",;
   total :R:11:P = "999,999,999" :H = "  Importe",;
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
   b1 = LEFT(articulo, 10) :R:10:P = "@!" :H = "Codigo",;
   b2 = LEFT(ubicacion, 10) :R:10:P = "@!" :H = "Ubicaci¢n",;
   lista :R:1:P = "9" :H = "",;
   b3 = LEFT(descr_trab, 30) :R:30:P = "@!" :H = "Descripcion",;
   cantidad :R:8:P = "99999.99" :H = "Cantidad",;
   precio :R:12:P = "9999,999,999" :H = "Precio Unit.",;
   b4 = ROUND(precio * cantidad, 0) :R:11:P = "999,999,999" :H = " Sub-Total ",;
   mecanico :R:5:P = "99999" :H = "Mec.",;
   b5 = LEFT(mec_nombre, 38) :R:38:P = "@!" :H = "Nombre del Mecanico";
   NOAPPEND NODELETE NOMODIFY

*!*   b1 = LEFT(articulo, 15) :R:15:P = "@!" :H = "Codigo",;
*!*   b2 = LEFT(ubicacion, 10) :R:10:P = "@!" :H = "Ubicaci¢n",;
*!*   lista :R:1:P = "9" :H = "",;
*!*   b3 = LEFT(descr_trab, 36) :R:36:P = "@!" :H = "Descripcion",;

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

SELECT cabeped2
SET ORDER TO 1
IF SEEK(m.nropedido) THEN
   SCATTER MEMVAR
ELSE
   IF m.cliente > 1 THEN
      SELECT clientes
      SET ORDER TO 1
      IF SEEK(m.cliente) THEN
         m.documento = ruc
         m.nombre    = nombre
         m.direccion = direc1
         m.telefono  = telefono
         m.fax       = fax
      ENDIF
   ENDIF
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
   * BOC: Agregar DV al RUC
   IF AT("-", m.documento) > 0 THEN
      cRUC = ALLTRIM(SUBSTR(m.documento, 1, AT("-", m.documento) - 1))
   ELSE
      cRUC = m.documento
   ENDIF   

   IF ALLTRIM(STR(VAL(cRUC))) == ALLTRIM(cRUC) THEN
      cRUC = ALLTRIM(cRUC) + "-" + ALLTRIM(STR(getdv(ALLTRIM(cRUC))))
      m.documento = cRUC
   ENDIF
   * EOC: Agregar DV al RUC

   SELECT cabeped2
   SET ORDER TO 2
   IF SEEK(m.documento) THEN
      m.nombre    = nombre
      m.direccion = direccion
      m.telefono  = telefono
      m.fax       = fax
      SHOW GETS
   ENDIF

   IF m.cliente > 1 THEN
      SELECT clientes
      SET ORDER TO 1
      IF SEEK(m.cliente) THEN
         m.documento = ruc
         m.nombre    = nombre
         m.direccion = direc1
         m.telefono  = telefono
         m.fax       = fax
         SHOW GETS
      ENDIF
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
      SELECT cabeped2
      SET ORDER TO 1
      IF SEEK(m.nropedido) THEN
         GATHER MEMVAR
      ELSE
         INSERT INTO cabeped2 FROM MEMVAR
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
CREATE TABLE cabepedc (;
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

CREATE TABLE cabeped2 (;
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

CREATE TABLE detapedc (;
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

CREATE TABLE pedifact (;
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

SELECT cabepedc
REPLACE facturado WITH .T.

SELECT ot
SET ORDER TO 1
IF SEEK(m.serieot + STR(m.nroot, 7)) THEN
   REPLACE estadoot WITH 6
   REPLACE fentrega WITH DATE()
ENDIF

SELECT 0
CREATE TABLE &archi_01 (;
   nrolinea N(5),;
   nropedido N(10),;
   articulo C(20),;
   cantidad N(9,2),;
   precio N(10),;
   prec_neto N(10),;
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
   IF !INLIST(articulo, "99013", "99014", "10001") AND !BETWEEN(articulo, "99901", "99999") THEN
      m.subtotal = m.subtotal + ROUND(precio * cantidad, 0)
   ENDIF
ENDSCAN

m.porcdesc = m.importdesc * 100 / m.subtotal

SCAN ALL
   IF .NOT. m.mostrar_desc THEN   && Si no quiere que se imprima el descuento, entonces prorratea.
      IF !INLIST(articulo, "99013", "99014", "10001")  AND !BETWEEN(articulo, "99901", "99999") THEN
         REPLACE prec_neto WITH precio - ROUND(precio * m.porcdesc / 100, 0)
      ELSE
         REPLACE prec_neto WITH precio
      ENDIF
   ELSE
      REPLACE prec_neto WITH precio
   ENDIF
ENDSCAN

mtotal = 0
SCAN ALL
   mtotal = mtotal + ROUND(prec_neto * cantidad, 0)
ENDSCAN

m.diferencia = mtotal - m.total

IF .NOT. m.mostrar_desc THEN   && Si no quiere que se imprima el descuento, entonces ajusta.
   IF m.diferencia <> 0 THEN
      SCAN ALL
         IF !INLIST(articulo, "99013", "99014", "10001") AND !BETWEEN(articulo, "99901", "99999") THEN
            IF MOD(m.diferencia, cantidad) = 0 THEN
               REPLACE prec_neto WITH prec_neto - (m.diferencia / cantidad)
               EXIT
            ENDIF
         ENDIF
      ENDSCAN
   ENDIF
ENDIF

SCAN ALL
   IF !INLIST(ALLTRIM(articulo), "99013", "99014", "99015", "99016", "10001")  AND !BETWEEN(ALLTRIM(articulo), "99901", "99999") THEN
      REPLACE descr_trab WITH ""
   ENDIF
ENDSCAN

*!*   DO desc_art WITH m.nropedido
DO geninvoice

* BORRA LOS DATOS RELACION ENTRE PEDIDO Y ARTICULO
DO borrar_item
*


SELECT tmp_neto
USE
DO borratemp WITH m.archi_01
FLUSH

*--------------------------------------------------------------------------*
PROCEDURE geninvoice
PRIVATE m.tipodocu, m.nrodocu, m.articulo, m.cantidad, m.precio, m.pdescuento, m.impuesto, m.pimpuesto, m.mecanico, m.comision_m, m.descr_trab, m.id_local, ;
        i, m.horadocu

* BOB: Imprime en una factura diferente los productos en promocion por plazo.
PRIVATE m.archi_01, m.archi_02, m.archi_03, lnPlazo
lnPlazo = 0


*-- BOB: Calcula el porcentaje de descuento. --*
PRIVATE lnSubTotal, lnPorcDesc

lnSubTotal = 0
SELECT tmp_neto
SCAN ALL
   lnSubTotal = lnSubTotal + ROUND(precio * cantidad, 0)
ENDSCAN

lnPorcDesc = m.importdesc * 100 / lnSubTotal
*-- EOB: Calcula el porcentaje de descuento. --*

IF !USED("cabeprom") THEN
   USE cabeprom IN 0 AGAIN ORDER 0 SHARED
ENDIF

IF !USED("detaprom") THEN
   USE detaprom IN 0 AGAIN ORDER 0 SHARED
ENDIF

m.archi_01 = createmp()

SELECT 0
CREATE TABLE &archi_01 (;
   nrolinea N(5),;
   nropedido N(10),;
   articulo C(20),;
   cantidad N(9,2),;
   precio N(10),;
   prec_neto N(10),;
   porcdesc N(8,4),;
   porc_iva N(6,2),;
   mecanico N(5),;
   comi_mecan N(6,2),;
   descr_trab C(50),;
   mec_nombre C(50);
)
USE &archi_01 ALIAS tmp_neto1 EXCLUSIVE

m.archi_02 = createmp()

SELECT 0
CREATE TABLE &archi_02 (;
   nrolinea N(5),;
   nropedido N(10),;
   articulo C(20),;
   cantidad N(9,2),;
   precio N(10),;
   prec_neto N(10),;
   porcdesc N(8,4),;
   porc_iva N(6,2),;
   mecanico N(5),;
   comi_mecan N(6,2),;
   descr_trab C(50),;
   mec_nombre C(50);
)
USE &archi_02 ALIAS tmp_neto2 EXCLUSIVE

m.archi_03 = createmp()

SELECT;
   a.plazo,;
   b.articulo;
FROM;
   cabeprom a,;
   detaprom b;
WHERE;
   a.id_promo = b.id_promo AND;
   a.fecha_baja => DATE();
INTO TABLE &archi_03

USE &archi_03 ALIAS promocion EXCLUSIVE

SELECT promocion
lnPlazo = IIF(EOF(), 0, plazo)

IF m.condicion = 1 THEN
   SELECT tmp_neto
   SCAN ALL
      INSERT INTO tmp_neto1 VALUES (tmp_neto.nrolinea, tmp_neto.nropedido, tmp_neto.articulo, tmp_neto.cantidad, tmp_neto.precio, tmp_neto.prec_neto, tmp_neto.porcdesc, tmp_neto.porc_iva, tmp_neto.mecanico, tmp_neto.comi_mecan, tmp_neto.descr_trab, tmp_neto.mec_nombre)
   ENDSCAN
ELSE
   *-------------------------------------------------------------------------------------*
   *  La facturacion a credito debe cumplir las siguientes condiciones:
   *  a) m.plazo = 2, el codigo 2 corresponde al plazo 30 dias.
   *  b) m.cliente no puede ser ninguno de estos clientes:
   *      412 - PPS Service de Alcides Godoy.
   *      414 - Taller Los Hermanos de Lorenzo Fretes.
   *      586 - Wilson Maqueda Franco.
   *      587 - Wildo Maqueda Franco.
   *      588 - Bernardo Gabriel Maqueda Franco.
   *     1063 - Bernardo Gabriel Maqueda Franco (Cta. Cte. Especial)
   *-------------------------------------------------------------------------------------*
   IF m.condicion = 2 AND m.plazo = 2 AND !INLIST(m.cliente, 412, 414, 586, 587, 588, 1063) THEN
      SELECT tmp_neto
      SCAN ALL
         SELECT promocion
         LOCATE FOR articulo = LEFT(tmp_neto.articulo, 15)
         IF !FOUND() THEN
            INSERT INTO tmp_neto1 VALUES (tmp_neto.nrolinea, tmp_neto.nropedido, tmp_neto.articulo, tmp_neto.cantidad, tmp_neto.precio, tmp_neto.prec_neto, tmp_neto.porcdesc, tmp_neto.porc_iva, tmp_neto.mecanico, tmp_neto.comi_mecan, tmp_neto.descr_trab, tmp_neto.mec_nombre)
         ELSE
            IF m.plazo <> promocion.plazo THEN
               INSERT INTO tmp_neto2 VALUES (tmp_neto.nrolinea, tmp_neto.nropedido, tmp_neto.articulo, tmp_neto.cantidad, tmp_neto.precio, tmp_neto.prec_neto, tmp_neto.porcdesc, tmp_neto.porc_iva, tmp_neto.mecanico, tmp_neto.comi_mecan, tmp_neto.descr_trab, tmp_neto.mec_nombre)
            ELSE
               INSERT INTO tmp_neto1 VALUES (tmp_neto.nrolinea, tmp_neto.nropedido, tmp_neto.articulo, tmp_neto.cantidad, tmp_neto.precio, tmp_neto.prec_neto, tmp_neto.porcdesc, tmp_neto.porc_iva, tmp_neto.mecanico, tmp_neto.comi_mecan, tmp_neto.descr_trab, tmp_neto.mec_nombre)
            ENDIF
         ENDIF
      ENDSCAN
   ELSE
      SELECT tmp_neto
      SCAN ALL
         INSERT INTO tmp_neto1 VALUES (tmp_neto.nrolinea, tmp_neto.nropedido, tmp_neto.articulo, tmp_neto.cantidad, tmp_neto.precio, tmp_neto.prec_neto, tmp_neto.porcdesc, tmp_neto.porc_iva, tmp_neto.mecanico, tmp_neto.comi_mecan, tmp_neto.descr_trab, tmp_neto.mec_nombre)
      ENDSCAN
   ENDIF
ENDIF
* EOB: Imprime en una factura diferente los productos en promocion por plazo.

IF m.condicion = 1 THEN
   m.tipodocu = 7
ELSE
   m.tipodocu = 8
ENDIF

i = 1
SELECT tmp_neto1
SCAN ALL
   IF i = 1 THEN
      * BOB: Checksum *
      nNroDocu  = calc_nrodocu()
      nNroDocu2 = calc_nrodocu()

      DO WHILE nNroDocu <> nNroDocu2
         nNroDocu  = calc_nrodocu()
         nNroDocu2 = calc_nrodocu()
      ENDDO

      m.nrodocu = nNroDocu
      * EOB: Checksum *

*!*   m.nrodocu    = calc_nrodocu()
      m.lstprecio  = m.lista
      m.fechadocu  = DATE()
      m.horadocu   = TIME()
      m.serie      = m.serieot
      m.nroot      = m.nroot
      m.moneda     = 1
      m.tipocambio = 1
      m.qty_cuotas = IIF(m.tipodocu = 7, 0, look_up("num_vtos", "plazos", m.plazo))
      m.id_plazo   = m.plazo
      m.nroremi    = 0
      m.fecharemi  = CTOD("  /  /    ")
      m.cliente    = m.cliente
      m.vendedor   = m.vendedor
      m.comision_1 = m.comision1
      m.comision_2 = m.comision2
      m.comision_3 = m.comision3

      m.porcdesc   = IIF(.NOT. m.mostrar_desc, 0, lnPorcDesc)
      m.importdesc = 0      
      m.descuento  = IIF(.NOT. m.mostrar_desc, 0, lnPorcDesc)

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
      INSERT INTO pedifact FROM MEMVAR
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
*
   INSERT INTO detavent FROM MEMVAR

   m.monto_fact = m.monto_fact + ROUND(prec_neto * cantidad, 0)

   i = i + 1

   IF i > 18 OR RECCOUNT() = RECNO() THEN
      SELECT cabevent
      SET ORDER TO 1
      IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7)) THEN
*!*	         * Codigo original
*!*	         REPLACE monto_fact WITH m.monto_fact

         m.importdesc = ROUND(m.monto_fact * IIF(.NOT. m.mostrar_desc, 0, lnPorcDesc) / 100, 0)
         m.monto_fact = m.monto_fact - m.importdesc

         REPLACE monto_fact WITH m.monto_fact, ;
                 importdesc WITH m.importdesc
      ENDIF

      IF m.condicion = 2 THEN
         DO calc_cuota WITH m.plazo

         SELECT clientes
         SET ORDER TO 1
         IF SEEK(m.cliente) THEN
            REPLACE saldo_actu WITH saldo_actu + m.monto_fact
            REPLACE facturar WITH "N"
         ENDIF
      ENDIF

      SELECT cabeped2
      SET ORDER TO 1
      IF SEEK(m.nropedido) THEN
         m.nombre     = nombre
         m.documento  = documento
         m.direc1     = SUBSTR(direccion, 1, 50)
         m.direc2     = SUBSTR(direccion, 51)
         m.telefono   = telefono
         m.fax        = fax

         IF RECCOUNT("tmp_neto1") = RECNO("tmp_neto1") THEN
            m.obs1 = SUBSTR(observacio, 1, 66)
            m.obs2 = SUBSTR(observacio, 67, 132)
            m.obs3 = SUBSTR(observacio, 133)
         ENDIF
         
         INSERT INTO cabeven2 FROM MEMVAR
      ENDIF
      i = 1
   ENDIF

   IF SET("EXACT") = "OFF"
      SET EXACT ON
      cSetExact = "OFF"
   ELSE
      cSetExact = "ON"
   ENDIF

   SELECT tmp_neto1
   IF !INLIST(ALLTRIM(articulo), "99001", "99002", "99003", "99010", "99011", "99012", "99013", "99014", "99015", "99016", "99020", "99021", "99022", "10001") AND !BETWEEN(ALLTRIM(articulo), "99901", "99999") THEN
      SELECT maesprod
      SET ORDER TO 1
      IF SEEK(ALLTRIM(tmp_neto1.articulo)) THEN
         REPLACE stock_actu WITH stock_actu - tmp_neto1.cantidad
         IF !EMPTY(m.nroot) THEN
            REPLACE stock_ot WITH stock_ot - tmp_neto1.cantidad
         ENDIF
      ELSE
         WAIT "EL ARTICULO: " + ALLTRIM(tmp_neto1.articulo) + " NO EXISTE," + CHR(13) +;
         "POR FAVOR, TOME NOTA DEL CODIGO " + CHR(13) +;
         "DEL ARTICULO Y COMUNIQUESELO" + CHR(13) +;
         "AL ANALISTA DE SISTEMAS" WINDOW
      ENDIF
   ENDIF

   IF cSetExact = "OFF"
      SET EXACT OFF
   ENDIF


   SELECT ot
   SET ORDER TO 1
   IF SEEK(m.serieot + STR(m.nroot, 7)) THEN
      REPLACE tipodocu WITH m.tipodocu
      REPLACE nrodocu  WITH m.nrodocu
   ENDIF
ENDSCAN

* BOB: Procesa la factura con los articulo en promocion de plazo.
i = 1
SELECT tmp_neto2
SCAN ALL
   IF i = 1 THEN
      * BOB: Checksum *
      nNroDocu  = calc_nrodocu()
      nNroDocu2 = calc_nrodocu()

      DO WHILE nNroDocu <> nNroDocu2
         nNroDocu  = calc_nrodocu()
         nNroDocu2 = calc_nrodocu()
      ENDDO

      m.nrodocu = nNroDocu
      * EOB: Checksum *

*!*   m.nrodocu    = calc_nrodocu()
      m.lstprecio  = m.lista
      m.fechadocu  = DATE()
      m.serie      = m.serieot
      m.nroot      = m.nroot
      m.moneda     = 1
      m.tipocambio = 1
      m.qty_cuotas = IIF(m.tipodocu = 7, 0, look_up("num_vtos", "plazos", lnPlazo))
      m.id_plazo   = lnPlazo
      m.nroremi    = 0
      m.fecharemi  = CTOD("  /  /    ")
      m.cliente    = m.cliente
      m.vendedor   = m.vendedor
      m.comision_1 = m.comision1
      m.comision_2 = m.comision2
      m.comision_3 = m.comision3

      m.porcdesc   = IIF(.NOT. m.mostrar_desc, 0, lnPorcDesc)
      m.importdesc = 0      
      m.descuento  = IIF(.NOT. m.mostrar_desc, 0, lnPorcDesc)

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
      INSERT INTO pedifact FROM MEMVAR
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
**
   INSERT INTO detavent FROM MEMVAR

   m.monto_fact = m.monto_fact + ROUND(prec_neto * cantidad, 0)

   i = i + 1

   IF i > 18 OR RECCOUNT() = RECNO() THEN
      SELECT cabevent
      SET ORDER TO 1
      IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7)) THEN
*!*	         * Codigo original
*!*	         REPLACE monto_fact WITH m.monto_fact

         m.importdesc = ROUND(m.monto_fact * IIF(.NOT. m.mostrar_desc, 0, lnPorcDesc) / 100, 0)
         m.monto_fact = m.monto_fact - m.importdesc

         REPLACE monto_fact WITH m.monto_fact, ;
                 importdesc WITH m.importdesc
      ENDIF

      IF m.condicion = 2 THEN
         DO calc_cuota WITH lnPlazo

         SELECT clientes
         SET ORDER TO 1
         IF SEEK(m.cliente) THEN
            REPLACE saldo_actu WITH saldo_actu + m.monto_fact
            REPLACE facturar WITH "N"
         ENDIF
      ENDIF

      SELECT cabeped2
      SET ORDER TO 1
      IF SEEK(m.nropedido) THEN
         m.nombre     = nombre
         m.documento  = documento
         m.direc1     = SUBSTR(direccion, 1, 50)
         m.direc2     = SUBSTR(direccion, 51)
         m.telefono   = telefono
         m.fax        = fax

         IF RECCOUNT("tmp_neto2") = RECNO("tmp_neto2") THEN
            m.obs1 = SUBSTR(observacio, 1, 66)
            m.obs2 = SUBSTR(observacio, 67, 132)
            m.obs3 = SUBSTR(observacio, 133)
         ENDIF
         
         INSERT INTO cabeven2 FROM MEMVAR
      ENDIF
      i = 1
   ENDIF

   IF SET("EXACT") = "OFF"
      SET EXACT ON
      cSetExact = "OFF"
   ELSE
      cSetExact = "ON"
   ENDIF

   SELECT tmp_neto2
   IF !INLIST(ALLTRIM(articulo), "99001", "99002", "99003", "99010", "99011", "99012", "99013", "99014", "99015", "99016", "99020", "99021", "99022", "10001") AND !BETWEEN(ALLTRIM(articulo), "99901", "99999") THEN
      SELECT maesprod
      SET ORDER TO 1
      IF SEEK(ALLTRIM(tmp_neto2.articulo)) THEN
         REPLACE stock_actu WITH stock_actu - tmp_neto2.cantidad
         IF !EMPTY(m.nroot) THEN
            REPLACE stock_ot WITH stock_ot - tmp_neto2.cantidad
         ENDIF
      ELSE
         WAIT "EL ARTICULO: " + ALLTRIM(tmp_neto2.articulo) + " NO EXISTE," + CHR(13) +;
         "POR FAVOR, TOME NOTA DEL CODIGO " + CHR(13) +;
         "DEL ARTICULO Y COMUNIQUESELO" + CHR(13) +;
         "AL ANALISTA DE SISTEMAS" WINDOW
      ENDIF
   ENDIF

   IF cSetExact = "OFF"
      SET EXACT OFF
   ENDIF

   SELECT ot
   SET ORDER TO 1
   IF SEEK(m.serieot + STR(m.nroot, 7)) THEN
      REPLACE tipodocu WITH m.tipodocu
      REPLACE nrodocu  WITH m.nrodocu
   ENDIF
ENDSCAN

SELECT tmp_neto1
USE
DO borratemp WITH m.archi_01

SELECT tmp_neto2
USE
DO borratemp WITH m.archi_02

SELECT promocion
USE
DO borratemp WITH m.archi_03
* EOB: Procesa la factura con los articulo en promocion de plazo.

SELECT pedifact
SET ORDER TO 1
IF SEEK(m.nropedido) THEN
   SCAN WHILE nropedido = m.nropedido
      DO print_invoice WITH tipodocu, nrodocu
   ENDSCAN
ENDIF

*!*	IF !EMPTY(m.nroot) THEN
*!*	   DO stock_ot.prg
*!*	ENDIF

*--------------------------------------------------------------------------*
FUNCTION calc_nrodocu
   PRIVATE m.select, m.archi_01, m.return, pcDriveC, pcSys16, pcProgram, pcPriorDir
   pcDriveC   = _DskSerie('C:')
   pcSys16    = SYS(16, 0)
   pcProgram  = SUBSTR(pcSys16, RAT("\", pcSys16) + 1)
   pcPriorDir = SUBSTR(pcSys16, RAT("\", pcSys16, 2) + 1, RAT("\", pcSys16) - RAT("\", pcSys16, 2) - 1)

   DO CASE
      CASE pcPriorDir = 'INTEGRAD.006'   && [SUCURSAL AVDA. EUSEBIO AYALA]
         m.return = 6000001
      CASE pcDriveC = '26AC-D826' AND pcPriorDir = 'INTEGRAD.005'   && Felipe LT     [SUCURSAL SAN BERNARDINO]     computador5
         m.return = 5000001
      OTHERWISE
         m.return = 4100050
   ENDCASE

   m.select = SELECT()

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
*ENDFUNC

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

SELECT pedifact
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
PARAMETERS tnPlazo

PRIVATE m.num_vtos, m.separacion, m.primero, m.resto, m.resto2, m.monto_cuot, m.ulti_cuota, m.importe

m.num_vtos   = look_up("num_vtos", "plazos", tnPlazo)
m.separacion = look_up("separacion", "plazos", tnPlazo)
m.primero    = look_up("primero", "plazos", tnPlazo)
m.resto      = look_up("resto", "plazos", tnPlazo)
m.resto2     = m.resto
m.monto_cuot = ROUND(m.monto_fact / m.num_vtos, 0) 
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

   m.tipo      = 2
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
   IF !INLIST(ALLTRIM(articulo), "99001", "99002", "99003", "99010", "99011", "99012", "99013", "99014", "99015", "99016", "99020", "99021", "99022", "10001", "PROMO TARJETA")  AND !BETWEEN(ALLTRIM(articulo), "99901", "99999") THEN
      SCATTER MEMVAR
      m.pedido = m.cantidad
      m.inventario = calc_stoc2(ALLTRIM(articulo))
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

*-- Calcula solamente el stock de la Casa Central -------------------------*
FUNCTION calc_stoc2
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

SET ORDER TO m.order
IF m.recno <> 0 THEN
   GOTO RECORD m.recno
ENDIF

IF !EMPTY(ALIAS(m.select)) THEN
   SELECT (m.select)
ENDIF

RETURN (m.return)

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
   localidad C(100),;
   telefono C(30),;
   cantidad N(9,2),;
   articulo C(20),;
   descr_trab C(40),;
   precio N(10),;
   porc_iva N(6,2),;
   iva_5p N(9),;
   iva_10p N(9),;
   importdesc N(9),;
   porcdesc N(15,13),;
   monto_fact N(9),;
   obs1 C(70),;
   obs2 C(70),;
   obs3 C(70),;
   serieot C(1),;
   nroot N(7),;
   ubicacion C(10),;
   codigo2 C(15);
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

SELECT ciudades
SET ORDER TO 1
SEEK clientes.ciudad

SELECT depar
SET ORDER TO 1
SEEK clientes.DEPARTAMEN

SELECT detavent
SET ORDER TO 1
IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7)) THEN
   SCAN WHILE tipodocu = m.tipodocu AND nrodocu = m.nrodocu
      m.nrofactura = SUBSTR(STR(m.nrodocu, 7), 2)
      m.vendedor   = cabevent.vendedor
      m.hora       = TIME()
      m.condicion  = IIF(m.tipodocu = 7, "CONTADO", look_up("nombre", "plazos", cabevent.id_plazo))
      m.fecha      = getdate(cabevent.fechadocu)
      m.cliente    = cabevent.cliente
      m.nombre     = IIF(EMPTY(cabeven2.nombre), clientes.nombre, cabeven2.nombre)
      m.ruc        = IIF(EMPTY(cabeven2.documento), clientes.ruc, cabeven2.documento)
      m.direccion  = IIF(EMPTY(cabeven2.direc1 + cabeven2.direc2), clientes.direc1, cabeven2.direc1 + cabeven2.direc2)
      m.localidad  = IIF(cabevent.cliente = 1, "", ALLTRIM(ciudades.nombre) + " ³ Dpto.: " + ALLTRIM(depar.nombre))
      m.telefono   = IIF(EMPTY(cabeven2.telefono), clientes.telefono, cabeven2.telefono)
      m.cantidad   = cantidad
      m.articulo   = articulo
      m.descr_trab = IIF(EMPTY(descr_trab), look_up("nombre", "maesprod", ALLTRIM(articulo)), descr_trab)
      m.precio     = ROUND(precio * (1 + pimpuesto / 100), 0)
      m.porc_iva   = pimpuesto
      m.iva_5p     = 0
      m.iva_10p    = 0      
      m.importdesc = cabevent.monto_fact
      m.porcdesc   = ROUND(cabevent.importdesc / (cabevent.monto_fact + cabevent.importdesc), 13)
      m.monto_fact = cabevent.monto_fact
      m.observacio = IIF(!EMPTY(cabeven2.obs1), cabeven2.obs1, "") + IIF(!EMPTY(cabeven2.obs2), cabeven2.obs2, "") + IIF(!EMPTY(cabeven2.obs3), cabeven2.obs3, "")
      m.ubicacion  = look_up("ubicacion", "maesprod", ALLTRIM(articulo))
      m.codigo2    = IIF(INLIST(look_up("marca", "maesprod", ALLTRIM(articulo)), 8, 21, 47, 467, 478), look_up("codigo2", "maesprod", ALLTRIM(articulo)), "")

      IF EMPTY(m.observacio) THEN
         IF m.tipodocu = 8 THEN   && credito
            m.observacio = "ESTA FACTURA DEBE CANCELARSE AL VENCIMIENTO, CASO CONTRARIO TENDRA UN RECARGO DE 4% MENSUAL." + SPACE(48) + "NO SE ACEPTAN DEVOLUCIONES DE COMPONENTES ELECTRICOS."
         ELSE
            m.observacio = "NO SE ACEPTAN DEVOLUCIONES DE COMPONENTES ELECTRICOS."
         ENDIF
      ENDIF

      m.obs1       = SUBSTR(m.observacio, 1, 70)
      m.obs2       = SUBSTR(m.observacio, 71, 70)
      m.obs3       = SUBSTR(m.observacio, 141, 70)
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

SELECT tmp_factur
SCAN ALL
   DO CASE
      CASE porc_iva = 5 
         m.iva_5p = m.iva_5p + ROUND(precio * cantidad, 0)
      CASE porc_iva = 10
         m.iva_10p = m.iva_10p + ROUND(precio * cantidad, 0)
   ENDCASE
ENDSCAN  

*-- BOB: Calcula el importe neto para calcular el IVA de cada categoria. --*
m.iva_5p  = m.iva_5p  - ROUND(m.iva_5p * m.porcdesc, 0)
m.iva_10p = m.iva_10p - ROUND(m.iva_10p * m.porcdesc, 0)
*-- EOB: Calcula el importe neto para calcular el IVA de cada categoria. --*

m.iva_5p  = m.iva_5p - ROUND(m.iva_5p / 1.05, 0)
m.iva_10p = m.iva_10p - ROUND(m.iva_10p / 1.1, 0)

REPLACE iva_5p  WITH m.iva_5p ALL
REPLACE iva_10p WITH m.iva_10p ALL

IF _PADVANCE = "FORMFEED"
   _PADVANCE = "LINEFEEDS"
   cPageAdva = "FORMFEED"
ELSE
   cPageAdva = "LINEFEEDS"
ENDIF

*!* REPORT FORM factura PREVIEW
*!* REPORT FORM factura TO PRINTER NOCONSOLE

pcSys16 = SYS(16, 0)
pcProgram = SUBSTR(pcSys16, RAT("\", pcSys16) + 1)
pcPriorDir = SUBSTR(pcSys16, RAT("\", pcSys16, 2) + 1, RAT("\", pcSys16) - RAT("\", pcSys16, 2) - 1)

IF pcPriorDir = "INTEGRAD.001" THEN
   REPORT FORM factura4 TO PRINTER NOCONSOLE
ELSE
   *BOB: Descuento promo servicio tecnico, por mes aniversario.
   IF YEAR(DATE()) = 2018 AND MONTH(DATE()) = 9 THEN
      IF BETWEEN(m.porcdesc, 0.13, 0.15) THEN
         IF !EMPTY(m.nroot) THEN
            WAIT 'DESCUENTO PROMO SERVICIO TECNICO, POR MES ANIVERSARIO :-)' WINDOW NOWAIT

            IF EMPTY(m.obs3) THEN
                m.obs3 = 'DESCUENTO PROMO SERVICIO TECNICO, POR MES ANIVERSARIO :-)'
            ENDIF
     	 ENDIF
     ENDIF
   ENDIF
   *EOB: Descuento promo servicio tecnico, por mes aniversario.

   REPORT FORM factura6 TO PRINTER NOCONSOLE
ENDIF

*!*	CASE pcDriveC = "C4E8-9B50"   && Central House WinXP Server      [CASA CENTRAL]   servidor
*!*	CASE pcDriveC = "1311-13D9"   && Printer Server                  [CASA CENTRAL]   computador6
*!*   CASE pcDriveC = "3088-BFDA"   && Show Room Left PC               [CASA CENTRAL]   computador1
*!*	CASE pcDriveC = "26B2-5ACD"   && Show Room Right PC              [CASA CENTRAL]   computador3
*!*	CASE pcDriveC = "123D-180C"   && Repair Shop PC                  [CASA CENTRAL]   computador4
*!*   CASE pcDriveC = "54AC-C238"   && Development PC                  [CASA CENTRAL]   computador2
*!*	CASE pcDriveC = "26AC-D826"   && Felipe LT                       [CASA CENTRAL]   computador5
*!*	CASE pcDriveC = "1659-57DA"   && Jose LT Dell                    [CASA CENTRAL]   dell-pc
*!*   CASE pcDriveC = "C8FE-D52A"   && Ricardo LT Toshiba              [CASA CENTRAL]   computador8
*!*	CASE pcDriveC = "0003-4F34"   && Branch House WinXP Server       [SUCURSAL Nº 1]  servidor
*!*	CASE pcDriveC = "1568-13FD"   && Show Room LT Acer Traveler 2420 [SUCURSAL Nº 1]  computador1
*!*	CASE pcDriveC = "0A9D-4716"   && Ricardo LT                      [SUCURSAL Nº 1]  computador2

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

*--------------------------------------------------------------------------*
FUNCTION saldo_ok
   IF m.condicion = 1 THEN   &&  Contado.
      RETURN
   ENDIF

   PRIVATE m.saldo_actu, m.limite_cre, m.retorno
   
   m.saldo_actu = look_up("saldo_actu", "clientes", m.cliente)
   m.limite_cre = look_up("limite_cre", "clientes", m.cliente)
   m.retorno = .T.

   IF (m.saldo_actu + m.total) > m.limite_cre THEN
      m.retorno = .F.
   ENDIF
RETURN (m.retorno)
*--------------------------------------------------------------------------*
FUNCTION saldo_ok2
   PRIVATE m.retorno, m.retorno2
   STORE 0 TO m.retorno, m.retorno2

   * Si el cliente es 1 entonces no verifica su estado de cuenta
   IF m.cliente = 1 THEN
      RETURN 0
   ENDIF
*!*	   Reactivar si no se desea la verificacion de saldo cuando es al contado.
*!*	   IF m.condicion = 1 THEN   &&  Contado.
*!*	      RETURN 0
*!*	   ENDIF

   IF look_up("facturar", "clientes", m.cliente) = "S" THEN
      RETURN 0
   ENDIF

   WAIT "Por favor, aguarde un momento..." WINDOW NOWAIT

   DO saldo_c WITH m.cliente

   SELECT tm_saldo_c
   SUM saldo FOR fecha_vto - DATE() < 0 TO m.retorno
   SUM saldo FOR (fecha_vto + 10) - DATE() < 0 TO m.retorno2
   USE

   IF m.retorno > 0 AND m.retorno2 = 0 THEN
      WAIT CLEAR
      WAIT "EL CLIENTE TIENE UN SALDO EN MORA DE" + CHR(13) + "Gs. " + ALLTRIM(TRANSFORM(m.retorno, "999,999,999")) + ".-" + CHR(13) + "PULSE ENTER PARA CONTINUAR..." WINDOW
      m.retorno = 0
   ENDIF

   WAIT CLEAR
RETURN (m.retorno)
*!*	*--------------------------------------------------------------------------*
*!*	FUNCTION saldo_ok2
*!*	   PRIVATE m.retorno

*!*	   * Si el cliente es 1 entonces no verifica su estado de cuenta
*!*	   IF m.cliente = 1 THEN
*!*	      RETURN 0
*!*	   ENDIF
*!*	*!*	   Reactivar si no se desea la verificacion de saldo cuando es al contado.
*!*	*!*	   IF m.condicion = 1 THEN   &&  Contado.
*!*	*!*	      RETURN 0
*!*	*!*	   ENDIF

*!*	   IF look_up("facturar", "clientes", m.cliente) = "S" THEN
*!*	      RETURN 0
*!*	   ENDIF

*!*	   WAIT "Por favor, aguarde un momento..." WINDOW NOWAIT

*!*	   DO saldo_c WITH m.cliente

*!*	   SELECT tm_saldo_c
*!*	   SUM saldo FOR fecha_vto - DATE() < 0 TO m.retorno
*!*	   USE

*!*	   WAIT CLEAR
*!*	RETURN (m.retorno)
*--------------------------------------------------------------------------*
PROCEDURE edit_prices
   IF !WEXIST("password") THEN
      DEFINE WINDOW password ;
         FROM INT((SROW()-3)/2),INT((SCOL()-30)/2) ;
         TO INT((SROW()-3)/2)+2,INT((SCOL()-30)/2)+29 ;
         TITLE "" ;
         NOCLOSE ;
         NOFLOAT ;
         NOGROW ;
         NOMDI ;
         NOMINIMIZE ;
         SHADOW ;
         NOZOOM
   ENDIF

   IF WVISIBLE("password") THEN
      ACTIVATE WINDOW password SAME
   ELSE
      ACTIVATE WINDOW password NOSHOW
   ENDIF

   STORE "" TO m.password

   @ 00,02 SAY "CONTRASE¥A:" SIZE 1,11 COLOR W+/B
   @ 00,14 GET m.password PICTURE "@!" DEFAULT "" SIZE 1,12 VALID vldpassword()

   IF !WVISIBLE("password") THEN
      ACTIVATE WINDOW password
   ENDIF

   READ CYCLE MODAL COLOR , X/X

   RELEASE WINDOW password

*--------------------------------------------------------------------------*
PROCEDURE vldpassword

IF m.password = "PARIS" THEN
   IF !WEXIST("prices") THEN
      DEFINE WINDOW prices;
         FROM 01,00 ;
         TO 23,79 ;
         TITLE "MODIFICACION DE PRECIOS" ;
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

   SELECT tmp_detape
   GOTO TOP

   BROWSE WINDOW prices FIELDS ;
      b1 = LEFT(articulo, 15) :R:15:P = "@!" :H = "Codigo",;
      lista :R:1:P = "9" :H = "",;
      b2 = LEFT(descr_trab, 36) :R:36:P = "@!" :H = "Descripcion",;
      cantidad :R:8:P = "99999.99" :H = "Cantidad",;
      precio :12:V = vldprecio() :F:P = "9999,999,999" :H = "Precio Unit." ;
      NOAPPEND NODELETE FREEZE precio

   RELEASE WINDOW prices

   * Borra el detalle.
   SELECT detapedc
   DELETE FOR nropedido = m.nropedido

   * Graba el detalle.
   SELECT tmp_detape
   SCAN FOR !(EMPTY(articulo) OR EMPTY(cantidad) OR EMPTY(precio))
      SCATTER MEMVAR
      IF !INLIST(m.articulo, "99013", "99014", "99015", "99016", "10001") AND !BETWEEN(m.articulo, "99901", "99999") THEN
         m.descr_trab = ""
      ENDIF
      INSERT INTO detapedc FROM MEMVAR
   ENDSCAN

   * Recalcula el total del pedido.
   STORE 0 TO m.subtotal, m.total

   SELECT tmp_detape
   SCAN ALL
      m.subtotal = m.subtotal + ROUND(precio * cantidad, 0)
   ENDSCAN

   IF m.porcdesc <> 0 THEN
      m.importdesc = ROUND(m.subtotal * m.porcdesc / 100, 0)
   ENDIF

   m.total = m.subtotal - m.importdesc

   SELECT cabepedc
   REPLACE total WITH m.total
ELSE
   WAIT WINDOW "CLAVE INCORRECTA !"
   STORE "" TO m.password
ENDIF

CLEAR READ

*--------------------------------------------------------------------------*
PROCEDURE vldprecio

SELECT tmp_detape
IF precio <= 0 THEN
   WAIT "EL PRECIO DEBE SER MAYOR QUE CERO !" WINDOW
   RETURN 0
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE borrar_item
   SELECT PediArti
   DELETE FOR NroPedido = m.NroPedido
*ENDPROC
