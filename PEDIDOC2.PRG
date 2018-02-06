PARAMETER m.adding
PUSH KEY CLEAR

PRIVATE m.nropedido, m.fecha, m.hora, m.lista, m.serieot, m.nroot, m.cliente, m.vendedor, m.comision1, m.comision2, m.comision3, m.porcdesc, m.importdesc, m.total, m.condicion, m.plazo, m.facturado ;
        m.subtotal

STORE 0 TO m.subtotal

IF m.adding THEN
   SELECT cabepedc
   SCATTER MEMVAR BLANK

   SELECT tmp_detape
   ZAP

   m.serieot = "A"
ELSE
   SELECT cabepedc
   SCATTER MEMVAR

   IF m.facturado THEN
      WAIT "ESTE PEDIDO YA HA SIDO FACTURADO, IMPOSIBLE MODIFICARLO !" WINDOW NOWAIT
      POP KEY
      RETURN
   ENDIF
ENDIF

DO print_format

IF !m.adding THEN
   DO refresh
   DO center WITH 1, "[ MODIFICAR PEDIDO DE CLIENTE ]", "GR+/B"
ELSE
   DO center WITH 1, "[ AGREGAR PEDIDO DE CLIENTE ]", "GR+/B"
ENDIF

@ 02,14 GET m.nropedido PICTURE "9999999999" DEFAULT 0 SIZE 1,10 WHEN .F.
@ 02,77 GET m.lista PICTURE "9" DEFAULT 0 SIZE 1,1 WHEN .F.
@ 03,14 GET m.fecha PICTURE "@D" DEFAULT CTOD("  /  /    ") SIZE 1,10 WHEN .F.
@ 03,25 GET m.hora PICTURE "99:99:99" DEFAULT "  :  :  " SIZE 1,8 WHEN .F.
@ 03,63 GET m.serieot PICTURE "@!" DEFAULT " " SIZE 1,1
@ 03,65 GET m.nroot PICTURE "9999999999" DEFAULT 0 SIZE 1,10 VALID vldnroot()
@ 05,14 GET m.cliente PICTURE "99999" DEFAULT 0 SIZE 1,5 VALID vldcliente() WHEN EMPTY(m.nroot)
@ 06,14 GET m.vendedor PICTURE "99999" DEFAULT 0 SIZE 1,5 VALID vldvendedor() WHEN EMPTY(m.nroot) AND EMPTY(m.vendedor)

@ 20,68 SAY m.subtotal PICTURE "999,999,999" SIZE 1,11 COLOR W+/BG
@ 21,46 GET m.porcdesc PICTURE "999.9999" DEFAULT 0 SIZE 1,8 VALID vldporcdesc()
@ 21,68 GET m.importdesc PICTURE "999,999,999" DEFAULT 0 SIZE 1,11 VALID vldimportdesc()
@ 22,68 SAY m.total PICTURE "999,999,999" SIZE 1,11 COLOR W+/BG

READ CYCLE ;
   MODAL ;
   VALID vldreadcycle() ;
   COLOR ,W+/G

*--------------------------------------------------------------------------*
FUNCTION vldreadcycle

IF LASTKEY() = 27 THEN
   IF INLIST(LOWER(SYS(18)), "porcdesc", "importdesc") THEN
      _CUROBJ = OBJNUM(m.porcdesc)
      RETURN 0
   ENDIF
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldcliente

@ 05,21 SAY REPLICATE(CHR(32), 40) SIZE 1,40 COLOR W+/B

IF m.cliente <= 0 THEN
   DO buscclie WITH "m.cliente"
ENDIF

IF m.cliente = 0
   RETURN 0
ENDIF

SELECT clientes
SET ORDER TO 1
IF SEEK(m.cliente) THEN
   m.lista = lista
   m.vendedor = vendedor
   @ 05,21 SAY LEFT(look_up("nombre", "clientes", m.cliente), 40) SIZE 1,40 COLOR W+/B
   SHOW GET m.lista
   SHOW GET m.vendedor

   IF estado = "I" THEN
      WAIT "CLIENTE INACTIVO NO SE LE PUEDE FACTURAR !" WINDOW
      _CUROBJ = OBJNUM(m.cliente)
      RETURN
   ENDIF

   * verifica si el cliente se encuentra al dia con sus obligaciones
   IF INLIST(look_up("ruta", "clientes", m.cliente), 0, 1) THEN
      m.saldo_ok2 = saldo_ok2()
      IF m.saldo_ok2 <> 0 THEN
         IF gnUser = 1   && ADMINISTRADOR
            WAIT "EL CLIENTE TIENE UN SALDO EN MORA DE" + CHR(13) + "Gs. " + ALLTRIM(TRANSFORM(m.saldo_ok2, "999,999,999")) + ". NO SE PUEDE FACTURAR." WINDOW
         ELSE
            WAIT "NO SE PUEDE FACTURAR. POR FAVOR, VERIFIQUE" + CHR(13) + "EL ESTADO DE CUENTA DEL CLIENTE." WINDOW
         ENDIF
         _CUROBJ = OBJNUM(m.cliente)
         RETURN
      ENDIF
   ENDIF
ELSE
   WAIT "CODIGO DE CLIENTE INEXISTENTE !" WINDOW
   RETURN 0
ENDIF

IF !EMPTY(m.vendedor) THEN
   SELECT vendedor
   SET ORDER TO 1
   IF SEEK(m.vendedor) THEN
      @ 06,21 SAY LEFT(look_up("nombre", "vendedor", m.vendedor), 40) SIZE 1,40 COLOR W+/B
      m.comision1 = comision1
      m.comision2 = comision2
      m.comision3 = comision3
   ENDIF

   IF INLIST(LASTKEY(), 4, 9, 13, 23, 24) THEN
      DO load_detail
   ENDIF
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldvendedor

@ 06,21 SAY REPLICATE(CHR(32), 40) SIZE 1,40 COLOR W+/B

IF m.vendedor <= 0 THEN
   DO buscvend WITH "m.vendedor"
ENDIF

IF m.vendedor = 0
   RETURN 0
ENDIF

SELECT vendedor
SET ORDER TO 1
IF SEEK(m.vendedor) THEN
   @ 06,21 SAY LEFT(look_up("nombre", "vendedor", m.vendedor), 40) SIZE 1,40 COLOR W+/B
   m.comision1 = comision1
   m.comision2 = comision2
   m.comision3 = comision3

   IF !vigente THEN
      WAIT "VENDEDOR INACTIVO." WINDOW
      RETURN 0
   ENDIF
ELSE
   WAIT "CODIGO DE VENDEDOR INEXISTENTE !" WINDOW
   RETURN 0
ENDIF

IF INLIST(LASTKEY(), 4, 9, 13, 23, 24) THEN
   DO load_detail
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE load_detail

IF !WEXIST("detalle") THEN
   DEFINE WINDOW detalle ;
      FROM 07,00 ;
      TO 19,79 ;
      TITLE "DETALLE" ;
      NONE ;
      NOCLOSE ;
      NOFLOAT ;
      NOGROW ;
      NOMDI ;
      NOMINIMIZE ;
      NOSHADOW ;
      NOZOOM ;
      COLOR W+/BG,GR+/RB,GR+/B,GR+/B,,,GR+/RB
ENDIF

SHOW GETS

SELECT tmp_detape
IF RECCOUNT() = 0 THEN
   APPEND BLANK
   REPLACE lista WITH m.lista
ENDIF

ON KEY LABEL "F8" DO delete_line

DO WHILE LASTKEY() <> 27
   @ 08,01 CLEAR TO 18,40   && Descripci¢n
   @ 08,42 CLEAR TO 18,51   && Cantidad
   @ 08,53 CLEAR TO 18,67   && Precio Unit.
   @ 08,69 CLEAR TO 18,78   && Importe

   GOTO BOTTOM

*      lista :1:V = vldlista() :F:P = "9" :H = "" :W = es_super(gnUser) AND m.cliente <> 1,;

   BROWSE WINDOW detalle FIELDS ;
      articulo :10:V = vldarticulo() :F:P = "@!" :H = "C¢digo",;
      b1 = LEFT(ubicacion, 10) :R:10:P = "@!" :H = "Ubicaci¢n" :W = .F.,;
      lista :1:V = vldlista() :F:P = "9" :H = "" :W = es_super(gnUser) ,;
      descr_trab :30:V = vlddescr_trab() :F:P = "@!" :H = "Descripci¢n" :W = es_editable(),;
      cantidad :8:V = vldcantidad() :F:P = "99999.99" :H = "Cantidad" :W = (ALLTRIM(articulo) <> "PROMO TARJETA"),;
      precio :12:V = vldprecio() :F:P = "9999,999,999" :H = "Precio Unit." :W = es_editable(),;
      b2 = ROUND(precio * cantidad, 0) :R:11:V = insert_line() :F:P = "999,999,999" :H = " Sub-Total " :W = !es_editable() AND !es_servicio(),;
      mecanico :5:V = vldmecanico(mecanico) :F:P = "99999" :H = "Mec." :W = es_servicio(),;
      mec_nombre :R:38:V = insert_line() :F:P = "@!" :H = "Nombre del Mec nico" :W = es_servicio();
      NOAPPEND NODELETE
ENDDO

*!*      articulo :15:V = vldarticulo() :F:P = "@!" :H = "C¢digo",;
*!*      lista :1:V = vldlista() :F:P = "9" :H = "" :W = es_super(gnUser),;
*!*      descr_trab :36:V = vlddescr_trab() :F:P = "@!" :H = "Descripci¢n" :W = es_editable(),;

ON KEY LABEL "F8"
RELEASE WINDOW detalle

DO print_detail
DO print_footer

*--------------------------------------------------------------------------*
PROCEDURE vldarticulo

PRIVATE m.articulo, m.count, m.stock, m.control_stock
STORE " " TO m.articulo
STORE  0  TO m.count, m.stock
STORE .F. TO m.control_stock

SELECT tmp_detape
IF EMPTY(articulo) THEN
   IF m.lista = 1 THEN
      DO buscarti WITH "m.articulo"
   ELSE
      DO buscart2 WITH "m.articulo"
   ENDIF
ELSE
   m.articulo = ALLTRIM(articulo)
ENDIF

IF EMPTY(m.articulo) THEN
   RETURN 0
ENDIF

REPLACE articulo WITH m.articulo

IF SET("EXACT") = "OFF"
   SET EXACT ON
   cSetExact = "OFF"
ELSE
   cSetExact = "ON"
ENDIF

SELECT maesprod
SET ORDER TO 1
IF SEEK(ALLTRIM(tmp_detape.articulo)) THEN
   SELECT tmp_detape
   IF !es_editable() THEN
      REPLACE descr_trab WITH maesprod.nombre
   ELSE
      IF EMPTY(descr_trab) THEN
         REPLACE descr_trab WITH maesprod.nombre
      ENDIF
   ENDIF
   * verifica si el art¡culo ya ha sido cargado anteriormente.
   IF !INLIST(ALLTRIM(articulo), "99013", "99014", "99015", "99016", "10001") THEN
      m.count = count_id(articulo)
   ENDIF

   IF m.count > 1 THEN
      WAIT "ESTE ARTICULO YA HA SIDO CARGADO EN ESTE PEDIDO !" WINDOW

      IF cSetExact = "OFF"
         SET EXACT OFF
      ENDIF

      RETURN 0
   ENDIF
   * verifica si el art¡culo est  agotado.
   m.stock = calc_stock(ALLTRIM(articulo))
   m.control_stock = control_stock(ALLTRIM(articulo))

   IF m.control_stock THEN   && controlar stock
      IF m.stock <= 0 THEN
         IF m.lista = 1 THEN
            WAIT "ESTE ARTICULO ESTA AGOTADO, NO SE PUEDE FACTURAR !" WINDOW
            REPLACE descr_trab WITH " "

            IF cSetExact = "OFF"
               SET EXACT OFF
            ENDIF

            RETURN 0
         ELSE
            WAIT "ESTE ARTICULO ESTA AGOTADO." WINDOW NOWAIT
         ENDIF
      ENDIF
   ENDIF

*   IF m.control_stock THEN   && controlar stock
*      IF m.stock <= 0 THEN
*         WAIT "ESTE ARTICULO ESTA AGOTADO, NO SE PUEDE FACTURAR !" WINDOW
*         REPLACE descr_trab WITH " "
*
*         IF cSetExact = "OFF"
*            SET EXACT OFF
*         ENDIF
*
*         RETURN 0
*      ENDIF
*   ENDIF
ELSE
   WAIT "CODIGO DE ARTICULO INEXISTENTE !" WINDOW

   IF cSetExact = "OFF"
      SET EXACT OFF
   ENDIF

   RETURN 0
ENDIF

IF cSetExact = "OFF"
   SET EXACT OFF
ENDIF

REPLACE porc_iva  WITH maesprod.pimpuesto,;
        ubicacion WITH maesprod.ubicacion

IF m.articulo = "10001" THEN
   REPLACE descr_trab WITH "GASTOS DE ENVIO"
ENDIF

IF es_editable() THEN
   RETURN
ENDIF

DO CASE
   CASE m.lista = 1
      REPLACE precio WITH ROUND(maesprod.pventag1 * (1 + maesprod.pimpuesto / 100), 0)
   CASE m.lista = 2
      IF maesprod.pventag2 = 0 THEN
         REPLACE precio WITH ROUND(maesprod.pventag1 * (1 + maesprod.pimpuesto / 100), 0)
      ELSE
         REPLACE precio WITH ROUND(maesprod.pventag2 * (1 + maesprod.pimpuesto / 100), 0)
      ENDIF
   CASE m.lista = 3
      IF maesprod.pventag3 = 0 THEN
         IF maesprod.pventag2 = 0 THEN
            REPLACE precio WITH ROUND(maesprod.pventag1 * (1 + maesprod.pimpuesto / 100), 0)
         ELSE
            REPLACE precio WITH ROUND(maesprod.pventag2 * (1 + maesprod.pimpuesto / 100), 0)
         ENDIF
      ELSE
         REPLACE precio WITH ROUND(maesprod.pventag3 * (1 + maesprod.pimpuesto / 100), 0)
      ENDIF
   CASE m.lista = 4
      IF maesprod.pventag4 = 0 THEN
         IF maesprod.pventag3 = 0 THEN
            IF maesprod.pventag2 = 0 THEN
               REPLACE precio WITH ROUND(maesprod.pventag1 * (1 + maesprod.pimpuesto / 100), 0)
            ELSE
               REPLACE precio WITH ROUND(maesprod.pventag2 * (1 + maesprod.pimpuesto / 100), 0)
            ENDIF
         ELSE
            REPLACE precio WITH ROUND(maesprod.pventag3 * (1 + maesprod.pimpuesto / 100), 0)
         ENDIF
      ELSE
         REPLACE precio WITH ROUND(maesprod.pventag4 * (1 + maesprod.pimpuesto / 100), 0)
      ENDIF
   CASE m.lista = 5
      IF maesprod.pventag5 = 0 THEN
         IF maesprod.pventag4 = 0 THEN
            IF maesprod.pventag3 = 0 THEN
               IF maesprod.pventag2 = 0 THEN
                  REPLACE precio WITH ROUND(maesprod.pventag1 * (1 + maesprod.pimpuesto / 100), 0)
               ELSE
                  REPLACE precio WITH ROUND(maesprod.pventag2 * (1 + maesprod.pimpuesto / 100), 0)
               ENDIF
            ELSE
               REPLACE precio WITH ROUND(maesprod.pventag3 * (1 + maesprod.pimpuesto / 100), 0)
            ENDIF
         ELSE
            REPLACE precio WITH ROUND(maesprod.pventag4 * (1 + maesprod.pimpuesto / 100), 0)
         ENDIF
      ELSE
         REPLACE precio WITH ROUND(maesprod.pventag5 * (1 + maesprod.pimpuesto / 100), 0)
      ENDIF
ENDCASE

* REPLACE porc_iva WITH maesprod.pimpuesto

IF !INLIST(ALLTRIM(articulo), "99001", "99002", "99003", "99010", "99011", "99012", "99013", "99014", "99015", "99016", "99020", "99021", "99022", "10001", "PROMO TARJETA") THEN
   IF precio <= 0 THEN
      WAIT "EL PRECIO DEL ARTICULO DEBE SER MAYOR QUE CERO !" WINDOW
      REPLACE descr_trab WITH " "
      RETURN 0
   ENDIF
ENDIF

IF ALLTRIM(articulo) = "PROMO TARJETA" THEN
   IF m.lista = 1 THEN
      lnSubTotal = CalcSubTotal()

      SELECT tmp_detape
      LOCATE FOR articulo = "PROMO TARJETA"
      IF FOUND() THEN
         REPLACE cantidad WITH 1, ;
                 precio   WITH -ROUND(lnSubTotal * 0.1, 0), ;
                 porc_iva WITH 10
      ENDIF
   ELSE
      WAIT "LA PROMOCION SOLO SE APLICA A CLIENTES DEL MOSTRADOR !" WINDOW NOWAIT
      RETURN 0
   ENDIF
ELSE
   DO vldlista
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vlddescr_trab

SELECT tmp_detape
IF EMPTY(descr_trab) THEN
   WAIT "LA DESCRIPCION NO PUEDE QUEDAR EN BLANCO !" WINDOW
   RETURN 0
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldcantidad
PRIVATE m.stock, m.control_stock

SELECT tmp_detape
IF cantidad <= 0 THEN
   WAIT "LA CANTIDAD DEBE SER MAYOR QUE CERO !" WINDOW
   RETURN 0
ENDIF

IF !INLIST(ALLTRIM(articulo), "99013", "99014", "99015", "99016", "10001", "PROMO TARJETA") THEN
   m.stock = calc_stock(ALLTRIM(articulo))
   m.control_stock = control_stock(ALLTRIM(articulo))

   IF m.control_stock THEN   && controlar stock
      IF m.lista = 1 THEN
         IF cantidad > m.stock THEN
            WAIT "LA CANTIDAD INGRESADA SUPERA EL STOCK" + CHR(13) + REPLICATE(CHR(196), 37) + CHR(13) + "UD. DISPONE DE " + ALLTRIM(STR(m.stock, 11, 2)) + " UNIDAD(ES)" WINDOW
            RETURN .F.
         ENDIF
      ELSE
         IF cantidad > m.stock THEN
            WAIT "LA CANTIDAD INGRESADA SUPERA EL STOCK" + CHR(13) + REPLICATE(CHR(196), 37) + CHR(13) + "UD. DISPONE DE " + ALLTRIM(STR(m.stock, 11, 2)) + " UNIDAD(ES)" WINDOW NOWAIT
         ENDIF
      ENDIF
   ENDIF
ENDIF

* permite valores con coma flotante solo si la unidad de medida es igual a 3, es decir, metro.

nUnidad = look_up("unidad", "maesprod", ALLTRIM(articulo))

IF nUnidad <> 3 AND RIGHT(STR(cantidad, 9, 2), 2) <> "00" THEN
   WAIT "CANTIDAD INVALIDA, ESTA INTENTANDO INGRESAR UN VALOR CON COMA FLOTANTE." WINDOW
   RETURN .F.
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldprecio

SELECT tmp_detape
IF precio <= 0 THEN
   WAIT "EL PRECIO DEBE SER MAYOR QUE CERO !" WINDOW
   RETURN 0
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldmecanico
PARAMETER m.mecanico

IF m.mecanico <= 0 THEN
   DO buscmeca WITH "m.mecanico"
ENDIF

IF m.mecanico = 0
   RETURN 0
ENDIF

SELECT mecanico
SET ORDER TO 1
IF SEEK(m.mecanico) THEN
   SELECT tmp_detape
   REPLACE mecanico   WITH m.mecanico
   REPLACE mec_nombre WITH LEFT(look_up("nombre", "mecanico", m.mecanico) + SPACE(40), 40)
ELSE
   WAIT "CODIGO DE MECANICO INEXISTENTE !" WINDOW
   RETURN 0
ENDIF

*--------------------------------------------------------------------------*
FUNCTION es_editable

IF !INLIST(ALLTRIM(tmp_detape.articulo), "99013", "99014", "99015", "99016", "10001") THEN
   RETURN .F.
ENDIF

*--------------------------------------------------------------------------*
FUNCTION es_servicio

IF !INLIST(ALLTRIM(tmp_detape.articulo), "99013", "99014") AND !BETWEEN(ALLTRIM(tmp_detape.articulo), "99901", "99999") THEN
   RETURN .F.
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE insert_line

IF ALLTRIM(articulo) <> "PROMO TARJETA" THEN
   SELECT tmp_detape
   IF LASTKEY() = 13 THEN
      IF RECNO() = RECCOUNT() THEN
         KEYBOARD "{CTRL+W}"
         APPEND BLANK
         REPLACE lista WITH m.lista
      ENDIF
   ENDIF
ENDIF

DO print_footer

*--------------------------------------------------------------------------*
PROCEDURE delete_line

SELECT tmp_detape
DELETE
PACK

IF RECCOUNT() = 0 THEN
   APPEND BLANK
   REPLACE lista WITH m.lista
ENDIF

DO print_footer

*--------------------------------------------------------------------------*
FUNCTION vldporcdesc

IF m.porcdesc > 100 THEN
   WAIT "EL PORCENTAJE DE DESCUENTO DEBE SER MENOR O IGUAL A CIEN !" WINDOW
   RETURN 0
ELSE
   IF m.porcdesc <> 0 THEN
      IF m.subtotal = 0 THEN
         WAIT "EL SUB-TOTAL DEL PEDIDO DEBE SER MAYOR QUE CERO !" WINDOW
         RETURN 0
      ENDIF

      DO print_footer

      *BOB: Si la lista es distinta a 1 no permite descuento.
      IF m.porcdesc > 0 THEN
         IF gnUser <> 1 THEN   && Administrador
            IF m.lista > 1 THEN
               WAIT "LA LISTA DE PRECIOS ES MAYOR QUE 1" + CHR(13) + "NO SE PUEDE REALIZAR EL DESCUENTO." WINDOW
               RETURN 0
            ELSE
               IF !precio_ok() THEN
                  RETURN 0
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      *EOB

      *BOB: Si el subtotal del pedido es menor o igual que 50 mil y si no es Administrador, entonces error.
      IF m.porcdesc > 0 THEN
         IF gnUser <> 1 THEN   && Administrador
            IF m.subtotal <= 50000 AND m.porcdesc > 0 THEN
               WAIT "LA COMPRA MINIMA PARA ACCEDER AL DESCUENTO ES DE 50 MIL GUARANIES." WINDOW
               RETURN 0
            ENDIF
         ENDIF
      ENDIF
      *EOB

      *BOB: Si tiene promo tarjeta no permite descuento.
      SELECT tmp_detape
      LOCATE FOR ALLTRIM(articulo) = "PROMO TARJETA"
      IF FOUND() THEN
         llPromoTarjeta = .T.
      ELSE
         llPromoTarjeta = .F.
      ENDIF
      
      GOTO BOTTOM

      IF m.porcdesc > 0 THEN
         IF llPromoTarjeta THEN
            WAIT "DESCUENTO NO PERMITIDO PARA ESTA TRANSACCION !" WINDOW
            RETURN 0
         ENDIF
      ENDIF
      *EOB

      IF LASTKEY() <> 3 OR LASTKEY() <> 13 THEN   && PGDN, ENTER
         _CUROBJ = OBJNUM(m.porcdesc)
      ENDIF
   ELSE
      _CUROBJ = OBJNUM(m.importdesc)
   ENDIF
ENDIF

IF LASTKEY() = 18 THEN   && PGUP
   SHOW GET m.porcdesc
   DO load_detail
   _CUROBJ = OBJNUM(m.porcdesc)
   RETURN 0
ENDIF

IF INLIST(LASTKEY(), 5, 18, 19) THEN   && UP, PGUP, LEFT
   RETURN 0
ELSE
   IF LASTKEY() = 13 AND !EMPTY(m.porcdesc) THEN
      IF m.subtotal = 0
         WAIT "EL SUB-TOTAL DEL PEDIDO DEBE SER MAYOR QUE CERO !" WINDOW
         _CUROBJ = OBJNUM(m.porcdesc)
         RETURN
      ENDIF
      DO print_foot
      IF !save_record() THEN
         RETURN 0
      ENDIF
   ENDIF
ENDIF

*--------------------------------------------------------------------------*
FUNCTION vldimportdesc

IF ABS(m.importdesc) > m.subtotal THEN
   WAIT "MONTO DE DESCUENTO INVALIDO !" WINDOW
   RETURN 0
ELSE
   DO print_footer
   IF m.importdesc <> 0 THEN
      IF LASTKEY() <> 3 OR LASTKEY() <> 13 THEN   && PGDN, ENTER
         _CUROBJ = OBJNUM(m.porcdesc)
      ENDIF

      *BOB: Si tiene promo tarjeta no permite descuento.
      SELECT tmp_detape
      LOCATE FOR ALLTRIM(articulo) = "PROMO TARJETA"
      IF FOUND() THEN
         llPromoTarjeta = .T.
      ELSE
         llPromoTarjeta = .F.
      ENDIF
      
      GOTO BOTTOM

      IF m.importdesc > 0 THEN
         IF llPromoTarjeta THEN
            WAIT "DESCUENTO NO PERMITIDO PARA ESTA TRANSACCION !" WINDOW
            RETURN 0
         ENDIF
      ENDIF
      *EOB

      *BOB: Si la lista es distinta a 1 no permite descuento.
      IF m.importdesc > 0 THEN
         IF gnUser <> 1 THEN   && Administrador
            IF m.lista > 1 THEN
               WAIT "LA LISTA DE PRECIOS ES MAYOR QUE 1" + CHR(13) + "NO SE PUEDE REALIZAR EL DESCUENTO." WINDOW
               RETURN 0
            ELSE
               IF !precio_ok() THEN
                  RETURN 0
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      *EOB

      *BOB: Si el subtotal del pedido es menor o igual que 50 mil y si no es Administrador, entonces error.
      IF m.importdesc > 0 THEN
         IF gnUser <> 1 THEN   && Administrador
            IF m.subtotal <= 50000 AND m.importdesc > 0 THEN
               WAIT "LA COMPRA MINIMA PARA ACCEDER AL DESCUENTO ES DE 50 MIL GUARANIES." WINDOW
               RETURN 0
            ENDIF
         ENDIF
      ENDIF
      *EOB
   ELSE
      _CUROBJ = OBJNUM(m.porcdesc)
   ENDIF
ENDIF

IF LASTKEY() = 19 THEN   && LEFT
   _CUROBJ = OBJNUM(m.porcdesc)
ENDIF

IF LASTKEY() = 18 THEN   && PGUP
   SHOW GET m.importdesc
   DO load_detail
   RETURN 0
ENDIF

IF INLIST(LASTKEY(), 5, 18) THEN   && UP, PGUP
   RETURN 0
ELSE
   IF LASTKEY() = 13 THEN
      IF m.subtotal = 0 THEN
         WAIT "EL SUB-TOTAL DEL PEDIDO DEBE SER MAYOR QUE CERO !" WINDOW
         _CUROBJ = OBJNUM(m.porcdesc)
         RETURN
      ENDIF
      DO print_footer
      IF !save_record() THEN
         RETURN 0
      ENDIF
   ENDIF
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE save_record

* intenta bloquear el archivo de cabecera.
SET NOTIFY ON
IF !FLOCK("cabepedc") THEN
   SET NOTIFY OFF
   RETURN .F.
ENDIF

* verifica si el cliente tiene credito.
SELECT clientes
SET ORDER TO 1
IF SEEK(m.cliente) THEN
   IF plazo = 0 THEN
      m.credito   = .F.
      m.condicion = 1
   ELSE
      m.credito = .T.
   ENDIF
ENDIF

IF m.credito THEN
   IF messagebox("CONTADO ?", 48) = 6 THEN
      m.condicion = 1
   ELSE
      m.condicion = 2

      SELECT clientes
      SET ORDER TO 1
      IF SEEK(m.cliente) THEN
         m.plazo = plazo
      ELSE
         m.plazo = 1
      ENDIF
   ENDIF
ENDIF

IF m.adding THEN
   PRIVATE pcDriveC, pcSys16, pcProgram, pcPriorDir

   pcDriveC   = _DskSerie('C:')
   pcSys16    = SYS(16, 0)
   pcProgram  = SUBSTR(pcSys16, RAT("\", pcSys16) + 1)
   pcPriorDir = SUBSTR(pcSys16, RAT("\", pcSys16, 2) + 1, RAT("\", pcSys16) - RAT("\", pcSys16, 2) - 1)

   SELECT cabepedc

   DO CASE
      CASE pcDriveC = "B039-B8E6"   && Notebook Acer Aspire E11        [DON OSCAR]
         CALCULATE MAX(nropedido) FOR BETWEEN(nropedido, 49000000, 49999999) TO m.nropedido

         IF EMPTY(m.nropedido) THEN
            m.nropedido = 49000000
         ENDIF
      CASE pcDriveC = '3A8C-9C0B'   && Lenovo IdeaPad S10              [CASA CENTRAL]   Sergio Enrique Rodríguez Guerrero
         CALCULATE MAX(nropedido) FOR BETWEEN(nropedido, 17000000, 17999999) TO m.nropedido

         IF EMPTY(m.nropedido) THEN
            m.nropedido = 17000000
         ENDIF
*      CASE pcDriveC = '3484-F031'   && Lenovo IdeaPad S10              [CASA CENTRAL]   César Alcibiades Topacio González
*         CALCULATE MAX(nropedido) FOR BETWEEN(nropedido, 04000000, 04999999) TO m.nropedido
*
*         IF EMPTY(m.nropedido) THEN
*            m.nropedido = 04000000
*         ENDIF
      CASE pcDriveC = '26AC-D826' AND pcPriorDir = 'INTEGRAD.005'   && Felipe LT     [SUCURSAL SAN BERNARDINO]     computador5
         CALCULATE MAX(nropedido) FOR BETWEEN(nropedido, 05000000, 05999999) TO m.nropedido

         IF EMPTY(m.nropedido) THEN
            m.nropedido = 05000000
         ENDIF
      CASE pcPriorDir = 'INTEGRAD.006'   && [SUCURSAL AVDA. EUSEBIO AYALA]
         CALCULATE MAX(nropedido) FOR BETWEEN(nropedido, 06000000, 06999999) TO m.nropedido

         IF EMPTY(m.nropedido) THEN
            m.nropedido = 06000000
         ENDIF
      OTHERWISE
         CALCULATE MAX(nropedido) FOR BETWEEN(nropedido, 1, 3999999) TO m.nropedido
   ENDCASE

   m.nropedido = m.nropedido + 1
   m.fecha     = DATE()
   m.hora      = TIME()
ELSE
   DO delete_record
ENDIF

* Graba el encabezado.
INSERT INTO cabepedc FROM MEMVAR

* Graba el detalle.
i = 1
SELECT tmp_detape
SCAN ALL
   REPLACE nrolinea  WITH i
   REPLACE nropedido WITH m.nropedido
   i = i + 1
ENDSCAN

SCAN FOR !(EMPTY(articulo) OR EMPTY(cantidad) OR EMPTY(precio))
   SCATTER MEMVAR
   IF !INLIST(m.articulo, '99013', '99014', '99015', '99016', '10001') THEN
      m.descr_trab = ''
   ENDIF
   INSERT INTO detapedc FROM MEMVAR

   *BOB: Graba datos de relacion entre pedido y articulo, si en numero de ot esta vacia
   IF EMPTY(m.NroOT) THEN
      INSERT INTO PediArti FROM MEMVAR
   ENDIF
   *EOB: Graba datos de relacion entre pedido y articulo
ENDSCAN

IF !EMPTY(m.nroot) THEN
   SELECT cabemot
   SET ORDER TO 1
   IF SEEK(STR(2, 1) + m.serieot + STR(m.nroot, 7)) THEN
      m.observacio = obs1 + obs2 + obs3
   ELSE
      m.observacio = ""
   ENDIF

   SELECT ot
   SET ORDER TO 1
   IF SEEK(m.serieot + STR(m.nroot, 7)) THEN
      INSERT INTO cabeped2 (nropedido, nombre, observacio) VALUES (m.nropedido, ot.nombreot, m.observacio)
   ENDIF
ENDIF

CLEAR READ
FLUSH
UNLOCK IN cabepedc
WAIT "EL PEDIDO FUE GRABADO !" WINDOW TIMEOUT 0.75

*--------------------------------------------------------------------------*
PROCEDURE vldnroot

IF m.nroot = 0 THEN
   RETURN
ELSE
   IF m.nroot < 0 THEN
      WAIT "EL N§ DE LA OT DEBE SER MAYOR O IGUAL QUE CERO !" WINDOW
      RETURN 0
   ELSE
      IF m.nroot > 0 THEN
         IF EMPTY(m.serieot) THEN
            WAIT "LA SERIE DE LA OT NO PUEDE QUEDAR EN BLANCO !" WINDOW
            _CUROBJ = OBJNUM(m.serieot)
            RETURN
         ENDIF
      ENDIF
   ENDIF
ENDIF

SELECT ot
SET ORDER TO 1
IF SEEK(m.serieot + STR(m.nroot, 7)) THEN
   IF estadoot <> 6 THEN
      IF estadoot = 3 THEN   && 3 - En reparación.
         WAIT "LA OT EXISTE, PERO AUN ESTA EN REPARACION !" WINDOW
         RETURN 0
      ENDIF

      SELECT cabemot
      SET ORDER TO 1
      IF SEEK(STR(2,1) + ot.serie + STR(ot.nroot, 7)) THEN
         SELECT detamot
         SET ORDER TO 1
         IF SEEK(STR(2,1) + cabemot.serie + STR(cabemot.nrobole, 7)) THEN
            PRIVATE m.nrolinea, m.nropedido, m.articulo, m.cantidad, m.precio, m.porcdesc, m.porc_iva, m.mecanico, m.comi_mecan, m.descr_trab, m.mec_nombre

            SELECT tmp_detape
            ZAP
            SELECT detamot

            SCAN WHILE cabemot.tipobole = tipobole AND cabemot.serie = serie AND cabemot.nrobole = nrobole
               m.nrolinea   = 0
               m.nropedido  = 0
               m.articulo   = articulo
               m.cantidad   = cantidad
               m.precio     = ROUND(precio * (1 + pimpuesto / 100), 0)
               m.porcdesc   = pdescuento
               m.porc_iva   = pimpuesto
               m.mecanico   = mecanico
               m.comi_mecan = comision_m
               m.descr_trab = IIF(EMPTY(descr_trab), look_up("nombre", "maesprod", ALLTRIM(articulo)), descr_trab)
               m.mec_nombre = IIF(mecanico <> 0, look_up("nombre", "mecanico", mecanico), "")
               m.lista      = cabemot.lstprecio

               INSERT INTO tmp_detape FROM MEMVAR
            ENDSCAN

            m.cliente   = ot.cliente
            m.vendedor  = cabemot.vendedor
            m.comision1 = cabemot.comision_1
            m.comision2 = cabemot.comision_2
            m.comision3 = cabemot.comision_3
            m.lista     = cabemot.lstprecio

            SHOW GET m.cliente
            SHOW GET m.vendedor
            SHOW GET m.lista

            @ 05,21 SAY LEFT(ot.nombreot, 40) SIZE 1,40 COLOR W+/B
            @ 06,21 SAY LEFT(look_up("nombre", "vendedor", m.vendedor), 40) SIZE 1,40 COLOR W+/B

            DO print_detail
            DO print_footer

            *BOB: Recupera el descuento que figura en la reparación de la máquina
            IF m.subtotal <> cabemot.monto_fact THEN
               m.importdesc = m.subtotal - cabemot.monto_fact
               DO print_footer
            ENDIF
            *EOF

            *BOB: Graba directamente el pedido si es que se trata de una OT
            IF !save_record() THEN
               RETURN 0
            ENDIF
            *EOF
        ENDIF
      ELSE
         WAIT "LA OT EXISTE, PERO NO TIENE MOVIMIENTO !" WINDOW
         RETURN 0
      ENDIF
   ELSE
      WAIT "OT ANTERIORMENTE FACTURADA !" WINDOW
      RETURN 0
   ENDIF
ELSE
   WAIT "N§ DE OT INEXISTENTE !" WINDOW
   RETURN 0
ENDIF

*--------------------------------------------------------------------------*
FUNCTION count_id
PARAMETER m.articulo

PRIVATE m.select, m.archi_01, m.return
m.select   = SELECT()
m.archi_01 = createmp()

SELECT * FROM tmp_detape WHERE articulo = m.articulo INTO TABLE &archi_01
m.return = RECCOUNT()
USE
DO borratemp WITH m.archi_01

IF !EMPTY(ALIAS(m.select)) THEN
   SELECT (m.select)
ENDIF

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

*--------------------------------------------------------------------------*
FUNCTION control_stock
PARAMETER m.articulo

PRIVATE m.select, m.order, m.recno, m.return
m.select = SELECT()
m.return = .T.

SELECT maesprod
m.order = VAL(SYS(21))
m.recno = IIF(EOF(), 0, RECNO())
SET ORDER TO 1

IF SEEK(m.articulo) THEN
   IF stock_excl THEN
      m.return = .F.
   ENDIF
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
FUNCTION es_super
PARAMETERS m.user

PRIVATE m.return
m.return = .T.

IF m.user <> 1 THEN
   m.return = .F.
ENDIF

RETURN (m.return)

*--------------------------------------------------------------------------*
PROCEDURE vldlista

IF !BETWEEN(tmp_detape.lista, 1, 5) THEN
   WAIT WINDOW "LA LISTA DE PRECIOS DEBE SER 1, 2, 3, 4 à 5 !"
   RETURN 0
ENDIF

PRIVATE m.select, m.order, m.recno
m.select = SELECT()

SELECT maesprod
m.order = VAL(SYS(21))
m.recno = IIF(EOF(), 0, RECNO())
SET ORDER TO 1

IF SEEK(ALLTRIM(tmp_detape.articulo)) THEN
   SELECT tmp_detape
   IF !INLIST(ALLTRIM(articulo), "99001", "99002", "99003", "99010", "99011", "99012", "99013", "99014", "99015", "99016", "99020", "99021", "99022", "10001", "PROMO TARJETA") THEN
      DO CASE
         CASE lista = 1
            REPLACE precio WITH ROUND(maesprod.pventag1 * (1 + maesprod.pimpuesto / 100), 0)
         CASE lista = 2
            IF maesprod.pventag2 = 0 THEN
               REPLACE precio WITH ROUND(maesprod.pventag1 * (1 + maesprod.pimpuesto / 100), 0)
            ELSE
               REPLACE precio WITH ROUND(maesprod.pventag2 * (1 + maesprod.pimpuesto / 100), 0)
            ENDIF
         CASE lista = 3
            IF maesprod.pventag3 = 0 THEN
               IF maesprod.pventag2 = 0 THEN
                  REPLACE precio WITH ROUND(maesprod.pventag1 * (1 + maesprod.pimpuesto / 100), 0)
               ELSE
                  REPLACE precio WITH ROUND(maesprod.pventag2 * (1 + maesprod.pimpuesto / 100), 0)
               ENDIF
            ELSE
               REPLACE precio WITH ROUND(maesprod.pventag3 * (1 + maesprod.pimpuesto / 100), 0)
            ENDIF
         CASE lista = 4
            IF maesprod.pventag4 = 0 THEN
               IF maesprod.pventag3 = 0 THEN
                  IF maesprod.pventag2 = 0 THEN
                     REPLACE precio WITH ROUND(maesprod.pventag1 * (1 + maesprod.pimpuesto / 100), 0)
                  ELSE
                     REPLACE precio WITH ROUND(maesprod.pventag2 * (1 + maesprod.pimpuesto / 100), 0)
                  ENDIF
               ELSE
                  REPLACE precio WITH ROUND(maesprod.pventag3 * (1 + maesprod.pimpuesto / 100), 0)
               ENDIF
            ELSE
               REPLACE precio WITH ROUND(maesprod.pventag4 * (1 + maesprod.pimpuesto / 100), 0)
            ENDIF
         CASE lista = 5
            IF maesprod.pventag5 = 0 THEN
               IF maesprod.pventag4 = 0 THEN
                  IF maesprod.pventag3 = 0 THEN
                     IF maesprod.pventag2 = 0 THEN
                        REPLACE precio WITH ROUND(maesprod.pventag1 * (1 + maesprod.pimpuesto / 100), 0)
                     ELSE
                        REPLACE precio WITH ROUND(maesprod.pventag2 * (1 + maesprod.pimpuesto / 100), 0)
                     ENDIF
                  ELSE
                     REPLACE precio WITH ROUND(maesprod.pventag3 * (1 + maesprod.pimpuesto / 100), 0)
                  ENDIF
               ELSE
                  REPLACE precio WITH ROUND(maesprod.pventag4 * (1 + maesprod.pimpuesto / 100), 0)
               ENDIF
            ELSE
               REPLACE precio WITH ROUND(maesprod.pventag5 * (1 + maesprod.pimpuesto / 100), 0)
            ENDIF
      ENDCASE
   ENDIF
ELSE
   WAIT "CODIGO DE ARTICULO INEXISTENTE !" WINDOW
   RETURN 0
ENDIF

SELECT maesprod
SET ORDER TO m.order
IF m.recno <> 0 THEN
   GOTO RECORD m.recno
ENDIF

IF !EMPTY(ALIAS(m.select)) THEN
   SELECT (m.select)
ENDIF

DO precio_oferta
*--------------------------------------------------------------------------*
PROCEDURE precio_oferta

PRIVATE m.select
m.select = SELECT()

SELECT cabeofer
SET ORDER TO 1
SCAN FOR fecha_fin >= DATE()
   IF lista = tmp_detape.lista THEN
      SELECT detaofer
      SET ORDER TO 1
      IF SEEK(cabeofer.id_oferta) THEN
         SCAN WHILE id_oferta = cabeofer.id_oferta
            IF ALLTRIM(articulo) == ALLTRIM(tmp_detape.articulo) THEN
               m.precio     = ROUND(look_up("pventag" + STR(tmp_detape.lista, 1), "maesprod", ALLTRIM(tmp_detape.articulo)) * (1 + look_up("pimpuesto", "maesprod", ALLTRIM(tmp_detape.articulo)) / 100), 0)
               m.precio2    = m.precio - ROUND(m.precio * cabeofer.porcdesc / 100, 0)

               SELECT tmp_detape
               REPLACE precio WITH m.precio2
               EXIT
            ENDIF
         ENDSCAN
      ENDIF
   ENDIF
ENDSCAN

IF !EMPTY(ALIAS(m.select)) THEN
   SELECT (m.select)
ENDIF

*--------------------------------------------------------------------------*
FUNCTION precio_ok
PRIVATE m.archi_01, m.return, m.subtotal, m.porcdesc

m.archi_01 = createmp()
m.return   = .T.

SELECT 0
CREATE TABLE &archi_01 (;
   articulo C(20),;
   descr_trab C(40),;
   cantidad N(9,2),;
   precio N(9),;
   prec_neto N(9),;
   prec_tope N(9);
)

USE &archi_01 ALIAS tmp_precio EXCLUSIVE

m.subtotal = 0

SELECT tmp_detape
SCAN ALL
   IF !INLIST(articulo, "99001", "99002", "99003", "99010", "99011", "99012", "99013", "99014", "99020", "99021", "99022", "10001", "PROMO TARJETA")  AND !BETWEEN(articulo, "99901", "99999") THEN
      m.articulo   = articulo
      m.descr_trab = descr_trab
      m.precio = precio
      m.prec_neto = 0
      m.prec_tope = 0
      m.subtotal = m.subtotal + ROUND(precio * cantidad, 0)
      
      INSERT INTO tmp_precio FROM MEMVAR
   ENDIF
ENDSCAN

m.porcdesc = m.importdesc * 100 / m.subtotal

SELECT tmp_precio
SCAN ALL
   REPLACE prec_neto WITH precio - ROUND(precio * m.porcdesc / 100, 0)
   REPLACE prec_tope WITH ROUND(look_up("pventag2", "maesprod", ALLTRIM(articulo)) * (1 + look_up("pimpuesto", "maesprod", ALLTRIM(articulo)) / 100), 0)

   IF prec_tope = 0 THEN
      REPLACE prec_tope WITH precio - ROUND(precio * 10 / 100, 0)
   ENDIF
ENDSCAN

SCAN ALL
   IF prec_neto >= prec_tope THEN
      DELETE
   ENDIF
   IF EMPTY(articulo) THEN
      DELETE
   ENDIF
ENDSCAN

PACK

SELECT tmp_precio
IF RECCOUNT() > 0 THEN
   WAIT "NO SE PUEDE GRABAR PORQUE HAY ARTICULOS" + CHR(13) + "QUE EXCEDEN EL DESCUENTO PERMITIDO." WINDOW NOWAIT
   m.return = .F.
   IF !WEXIST("lista") THEN
      DEFINE WINDOW lista ;
         FROM 07,00;
         TO 19,79 ;
         TITLE "ARTICULOS QUE EXCEDEN EL DESCUENTO PERMITIDO" ;
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
      b3 = prec_neto :R:12:P = "9999,999,999" :H = "Precio Neto",;
      b4 = prec_tope :R:12:P = "9999,999,999" :H = "Precio Tope";
      NOAPPEND NODELETE NOMODIFY
ENDIF

USE
DO borratemp WITH m.archi_01
RELEASE WINDOW lista

RETURN (m.return)

*--------------------------------------------------------------------------*
FUNCTION CalcSubTotal

PRIVATE m.select
m.select = SELECT()

lnSubTotal = 0

SELECT tmp_detape
SCAN ALL
   IF !INLIST(articulo, "PROMO TARJETA") THEN
      lnSubTotal = lnSubTotal + ROUND(precio * cantidad, 0)
   ENDIF
ENDSCAN

IF !EMPTY(ALIAS(m.select)) THEN
   SELECT (m.select)
ENDIF

RETURN (lnSubTotal)
