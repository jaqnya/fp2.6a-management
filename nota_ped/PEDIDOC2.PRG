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
@ 06,14 GET m.vendedor PICTURE "99999" DEFAULT 0 SIZE 1,5 VALID vldvendedor() WHEN EMPTY(m.nroot)

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
   @ 05,21 SAY LEFT(look_up("nombre", "clientes", m.cliente), 40) SIZE 1,40 COLOR W+/B
   SHOW GET m.lista
ELSE
   WAIT "CODIGO DE CLIENTE INEXISTENTE !" WINDOW
   RETURN 0
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
ENDIF

ON KEY LABEL "F8" DO delete_line

DO WHILE LASTKEY() <> 27
   @ 08,01 CLEAR TO 18,40   && Descripci¢n
   @ 08,42 CLEAR TO 18,51   && Cantidad
   @ 08,53 CLEAR TO 18,67   && Precio Unit.
   @ 08,69 CLEAR TO 18,78   && Importe
   
   GOTO BOTTOM
   
   BROWSE WINDOW detalle FIELDS ;
      articulo :15:V = vldarticulo() :F:P = "@!" :H = "C¢digo",;
      descr_trab :38:V = vlddescr_trab() :F:P = "@!" :H = "Descripci¢n" :W = es_editable(),;
      cantidad :8:V = vldcantidad() :F:P = "99999.99" :H = "Cantidad",;
      precio :12:V = vldprecio() :F:P = "9999,999,999" :H = "Precio Unit." :W = es_editable(),;
      b1 = ROUND(precio * cantidad, 0) :R:11:V = insert_line() :F:P = "999,999,999" :H = " Sub-Total " :W = !es_editable() OR !es_servicio(),;
      mecanico :5:V = vldmecanico(mecanico) :F:P = "99999" :H = "Mec." :W = es_servicio(),;
      mec_nombre :R:38:V = insert_line() :F:P = "@!" :H = "Nombre del Mec nico" :W = es_servicio();
      NOAPPEND NODELETE
ENDDO

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
   DO buscarti WITH "m.articulo"
ELSE
   m.articulo = ALLTRIM(articulo)
ENDIF

IF EMPTY(m.articulo) THEN
   RETURN 0
ENDIF

REPLACE articulo WITH m.articulo

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
      RETURN 0
   ENDIF
   * verifica si el art¡culo est  agotado.
   m.stock = calc_stock(ALLTRIM(articulo))
   m.control_stock = control_stock(ALLTRIM(articulo))
   
   IF m.control_stock THEN   && controlar stock
      IF m.stock <= 0 THEN
         WAIT "ESTE ARTICULO ESTA AGOTADO, NO SE PUEDE FACTURAR !" WINDOW
         REPLACE descr_trab WITH " "
         RETURN 0
      ENDIF
   ENDIF
ELSE
   WAIT "CODIGO DE ARTICULO INEXISTENTE !" WINDOW
   RETURN 0
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

REPLACE porc_iva WITH maesprod.pimpuesto

IF !INLIST(ALLTRIM(articulo), "99013", "99014", "99015", "99016", "10001") THEN
   IF precio <= 0 THEN
      WAIT "EL PRECIO DEL ARTICULO DEBE SER MAYOR QUE CERO !" WINDOW
      REPLACE descr_trab WITH " "
      RETURN 0
   ENDIF
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

IF !INLIST(ALLTRIM(articulo), "99013", "99014", "99015", "99016", "10001") THEN
   m.stock = calc_stock(ALLTRIM(articulo))
   m.control_stock = control_stock(ALLTRIM(articulo))
  
   IF m.control_stock THEN   && controlar stock
      IF cantidad > m.stock THEN
         WAIT "LA CANTIDAD INGRESADA SUPERA EL STOCK" + CHR(13) + REPLICATE(CHR(196), 37) + CHR(13) + "UD. DISPONE DE " + ALLTRIM(STR(m.stock, 11, 2)) + " UNIDAD(ES)" WINDOW
         RETURN .F.
      ENDIF
   ENDIF
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

IF !INLIST(ALLTRIM(tmp_detape.articulo), "99013", "99014") THEN
   RETURN .F.
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE insert_line

SELECT tmp_detape
IF LASTKEY() = 13 THEN
   IF RECNO() = RECCOUNT() THEN
      KEYBOARD "{CTRL+W}"
      APPEND BLANK
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
      DO save_record
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
      DO save_record
   ENDIF
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE save_record

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

IF m.adding THEN
   SELECT cabepedc
   CALCULATE MAX(nropedido) TO m.nropedido
   
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
   IF !INLIST(m.articulo, "99013", "99014", "99015", "99016", "10001") THEN
      m.descr_trab = ""
   ENDIF
   INSERT INTO detapedc FROM MEMVAR
ENDSCAN

IF !EMPTY(m.nroot) THEN
   SELECT ot
   SET ORDER TO 1
   IF SEEK(m.serieot + STR(m.nroot, 7)) THEN
      INSERT INTO cabeped2 (nropedido, nombre) VALUES (m.nropedido, ot.nombreot)
   ENDIF
ENDIF

CLEAR READ  
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