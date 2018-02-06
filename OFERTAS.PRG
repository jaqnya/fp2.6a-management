PRIVATE m.id_oferta, m.fecha, m.hora, m.lista, m.serieot, m.nroot, m.cliente, m.vendedor, m.comision1, m.comision2, m.comision3, m.porcdesc, m.importdesc, m.total, m.condicion, m.plazo, m.facturado ;
        m.archi_01, m.key, m.subtotal, m.adding

STORE  0  TO m.id_oferta, m.lista, m.nroot, m.cliente, m.vendedor, m.comision1, m.comision2, m.comision3, m.porcdesc, m.importdesc, m.total, m.condicion, m.plazo
STORE " " TO m.hora, m.serieot
STORE .F. TO m.adding
STORE CTOD("  /  /    ") TO m.fecha

STORE 0 TO m.key, m.subtotal
STORE createmp() TO m.archi_01

DO load
DO init

SELECT cabeofer
GOTO TOP

IF !WVISIBLE("fondo_ofer") THEN
   ACTIVATE WINDOW fondo_ofer
ENDIF

* begin: main program
PUSH KEY CLEAR

@ 00,00 TO 00,79 " " COLOR N/W
DO center WITH 0, " A & A IMPORTACIONES S.R.L. ", "N/W"
@ 01,00,23,79 BOX REPLICATE(CHR(178), 8) + CHR(178)
@ 01,00 FILL TO 23,79 COLOR BG/B
@ 24,00 TO 24,79 " " COLOR N/W
@ 24,01 SAY "F2=Agrega  F3=Modifica  F5=Busca  F8=Borra  ENTER=Consulta         ³  ESC=Sale" COLOR N/W

SELECT cabeofer
SET ORDER TO 1

ON KEY LABEL "F2" DO insert_record
ON KEY LABEL "F3" DO edit_record
ON KEY LABEL "F5" DO search
ON KEY LABEL "F8" DO confirm_delete
ON KEY LABEL "ENTER" DO view_detail

BROWSE WINDOW browse_ofe FIELDS ;
   id_oferta :R:10:P = "9999999999" :H = "Oferta N§",;
   b1 = LEFT(ALLTRIM(nombre) + SPACE(43), 43) :R:43:P = "@!" :H = "Descripci¢n",;
   fecha_fin :R:10:P = "@D" :H = " Validez",;
   fecha_alta :R:10:P = "@D" :H = "  F.Alta";
   NOAPPEND NODELETE NOMODIFY

ON KEY LABEL "F2"
ON KEY LABEL "F3"
ON KEY LABEL "F5"
ON KEY LABEL "F8"
ON KEY LABEL "ENTER"

POP KEY
* end: main program

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

IF !USED("cabeofer") THEN
   USE cabeofer IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("detaofer") THEN
   USE detaofer IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("maesprod") THEN
   USE maesprod IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("marcas1") THEN
   USE marcas1 IN 0 AGAIN ORDER 1 SHARED
ENDIF

SELECT 0
CREATE TABLE &archi_01 (;
   id_oferta N(10),;
   articulo C(15),;
   art_nombre C(40),;
   precio N(10),;
   precio2 N(10);
)
USE &archi_01 ALIAS tmp_detaof EXCLUSIVE

*--------------------------------------------------------------------------*
PROCEDURE unload

IF USED("cabeofer") THEN
   SELECT cabeofer
*   USE
ENDIF

IF USED("detaofer") THEN
   SELECT detaofer
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

IF USED("tmp_detaof") THEN
   SELECT tmp_detaof
   USE
ENDIF

SET COLOR OF SCHEME 1 TO W/N,N/W,W/N,N/W,W/N,W+/B,W/N,N+/N,W/N,W/N,-

DO borratemp WITH m.archi_01

RELEASE WINDOW browse_ofe
RELEASE WINDOW fondo_ofer

*--------------------------------------------------------------------------*
PROCEDURE init

SET COLOR OF SCHEME 1 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,,R+/B,+

IF !WEXIST("fondo_ofer") THEN
   DEFINE WINDOW fondo_ofer ;
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

IF WVISIBLE("fondo_ofer") THEN
   ACTIVATE WINDOW fondo_ofer SAME
ELSE
   ACTIVATE WINDOW fondo_ofer NOSHOW
ENDIF

IF !WEXIST("browse_ofe") THEN
   DEFINE WINDOW browse_ofe ;
      FROM 01,00 ;
      TO 23,79 ;
      TITLE "OFERTAS" ;
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

*--------------------------------------------------------------------------*
PROCEDURE load_detail
PRIVATE m.articulo, m.art_nombre, m.precio, m.precio2

SELECT tmp_detaof
ZAP

SELECT detaofer
SET ORDER TO 1

IF SEEK(m.id_oferta) THEN
   SCAN WHILE id_oferta = m.id_oferta
      m.articulo   = ALLTRIM(articulo)
      m.art_nombre = look_up("nombre", "maesprod", m.articulo)
      m.precio     = ROUND(look_up("pventag" + STR(m.lista, 1), "maesprod", m.articulo) * (1 + look_up("pimpuesto", "maesprod", m.articulo) / 100), 0)
      m.precio2    = m.precio - ROUND(m.precio * m.porcdesc / 100, 0)
      INSERT INTO tmp_detaof FROM MEMVAR
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
PROCEDURE delete_record
PRIVATE m.order

* Borra el encabezado.
SELECT cabeofer
m.order = VAL(SYS(21))
SET ORDER TO 1
IF SEEK(m.id_oferta) THEN
   DELETE
ENDIF
SET ORDER TO m.order

* Borra el detalle.
SELECT detaofer
DELETE FOR id_oferta = m.id_oferta

* Borra otros datos.
SELECT cabeped2
DELETE FOR id_oferta = m.id_oferta

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
PROCEDURE search

SELECT cabeofer
IF EOF() THEN
   WAIT "EL ARCHIVO ESTA VACIO, NO SE PUEDE REALIZAR BUSQUEDAS !" WINDOW
   RETURN
ENDIF

PRIVATE m.order, m.recno, m.id_oferta, m.fecha, m.cliente

SELECT cabeofer
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

      STORE 0 TO m.id_oferta

      @ 00,02 SAY "N§ DE OFERTA:" SIZE 1,13 COLOR W+/B
      @ 00,16 GET m.id_oferta PICTURE "9999999999" DEFAULT 0 SIZE 1,10 VALID vldid_oferta()

      IF !WVISIBLE("buscar") THEN
         ACTIVATE WINDOW buscar
      ENDIF

      READ CYCLE ;
        MODAL ;
        COLOR ,W+/G

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

      @ 00,02 SAY "FECHA DE OFERTA:" SIZE 1,16 COLOR W+/B
      @ 00,19 GET m.fecha PICTURE "@D" DEFAULT DATE() SIZE 1,10 VALID vldfecha()

      IF !WVISIBLE("buscar") THEN
         ACTIVATE WINDOW buscar
      ENDIF

      READ CYCLE ;
         MODAL ;
         COLOR ,W+/G

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

      READ CYCLE ;
         MODAL ;
         COLOR ,W+/G

      RELEASE WINDOW buscar
ENDCASE

*--------------------------------------------------------------------------*
PROCEDURE vldid_oferta

IF m.id_oferta > 0 THEN
   IF !SEEK(m.id_oferta) THEN
      IF m.recno <> 0 THEN
         GOTO RECORD m.recno
      ENDIF

      WAIT "EL DATO BUSCADO NO HA SIDO ENCONTRADO !" WINDOW
      RETURN 0
   ELSE
      CLEAR READ
   ENDIF
ELSE
   WAIT "EL N§ DE OFERTA DEBE SER MAYOR QUE CERO !" WINDOW
   RETURN 0
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldfecha
PARAMETER m.fecha

IF EMPTY(m.fecha) THEN
   WAIT "LA FECHA NO PUEDE QUEDAR EN BLANCO !" WINDOW
   RETURN 0
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldlista
PARAMETER m.lista

IF !BETWEEN(m.lista, 1, 5) THEN
   WAIT "LA LISTA DE PRECIOS DEBE SER 1, 2, 3, 4 ¢ 5 !" WINDOW
   RETURN 0
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldporcdesc
PARAMETER m.porcdesc

IF m.porcdesc <= 0 THEN
   WAIT "EL PORCENTAJE DE DESCUENTO DEBE SER MAYOR QUE CERO !" WINDOW
   RETURN 0
ENDIF

IF m.porcdesc > 100 THEN
   WAIT "EL PORCENTAJE DE DESCUENTO DEBE SER MAYOR QUE CERO Y MENOR QUE CIEN !" WINDOW
   RETURN 0
ENDIF

SELECT tmp_detaof

IF RECCOUNT() = 0 THEN
   INSERT INTO tmp_detaof (id_oferta, articulo, art_nombre, precio, precio2) ;
      VALUES (m.id_oferta, "", "", 0, 0)
ENDIF

SHOW GETS

ON KEY LABEL "F8" DO delete_line

DO WHILE LASTKEY() <> 27
   SELECT tmp_detaof
   GOTO BOTTOM

   BROWSE WINDOW detalle FIELDS ;
      articulo :13:H = "C¢digo" :V = vldarticulo() :F,;
      b2 = LEFT(art_nombre, 36) :R:36:P = "@!" :H = "Descripci¢n" :W = .F.,;
      precio :R:12:P = "9999,999,999" :H = "Precio Lista" :W = .F.,;
      precio2 :R:12:P = "9999,999,999" :H = "Prec. Oferta" :W = .F.;
      NOAPPEND NODELETE
ENDDO

ON KEY LABEL "F8"

IF messagebox("DESEA GRABARLO ?", 48) = 6 THEN
   IF m.adding THEN
      SELECT cabeofer
      CALCULATE MAX(id_oferta) TO m.id_oferta
      m.id_oferta = m.id_oferta + 1
      m.fecha_alta = DATE()
   ELSE
      DO delete_record
   ENDIF

   INSERT INTO cabeofer (id_oferta, nombre, lista, porcdesc, fecha_fin, fecha_alta);
      VALUES (m.id_oferta, m.nombre, m.lista, m.porcdesc, m.fecha_fin, m.fecha_alta)

   SELECT tmp_detaof
   SCAN FOR !EMPTY(articulo)
      INSERT INTO detaofer (id_oferta, articulo);
         VALUES (m.id_oferta, tmp_detaof.articulo)
   ENDSCAN
   CLEAR READ
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE delete_line
   PUSH KEY CLEAR

   SELECT tmp_detaof
   DELETE
   PACK

   IF RECCOUN() = 0 THEN
      INSERT INTO tmp_detaof (id_oferta, articulo, art_nombre, precio, precio2) ;
         VALUES (m.id_oferta, "", "", 0, 0)
   ENDIF

   POP KEY

*--------------------------------------------------------------------------*
PROCEDURE insert_line
   IF LASTKEY() = 13 THEN
      IF RECNO() = RECCOUNT() THEN
         KEYBOARD "{CTRL+W}"
         INSERT INTO tmp_detaof (id_oferta, articulo, art_nombre, precio, precio2) ;
            VALUES (m.id_oferta, "", "", 0, 0)
      ENDIF
   ENDIF

*--------------------------------------------------------------------------*
PROCEDURE view_detail

PUSH KEY CLEAR

IF !WEXIST("cabecera") THEN
   DEFINE WINDOW cabecera ;
      FROM 01,00 ;
      TO 05,79 ;
      TITLE "[ CONSULTA DE OFERTA ]" ;
      NOCLOSE ;
      NOFLOAT ;
      NOGROW ;
      NOMDI ;
      NOMINIMIZE ;
      NOSHADOW ;
      NOZOOM
ENDIF

IF !WEXIST("detalle") THEN
   DEFINE WINDOW detalle ;
      FROM 06,00 ;
      TO 23,79 ;
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

IF !WEXIST("pie") THEN
   DEFINE WINDOW pie ;
      FROM 24,00 ;
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

IF WVISIBLE("cabecera") THEN
   ACTIVATE WINDOW cabecera
ELSE
   ACTIVATE WINDOW cabecera NOSHOW
ENDIF

SELECT cabeofer
SCATTER MEMVAR

@ 00,02 SAY "Oferta N§..:" SIZE 1,12 COLOR BG+/B
@ 01,02 SAY "Descripci¢n:" SIZE 1,12 COLOR BG+/B
@ 02,02 SAY "Validez....:" SIZE 1,12 COLOR BG+/B
@ 02,27 SAY "Lista N§:" SIZE 1,9 COLOR BG+/B
@ 02,40 SAY "Descuento:         %" SIZE 1,20 COLOR BG+/B

@ 00,15 SAY m.id_oferta SIZE 1,10 COLOR W+/BG
@ 01,15 SAY m.nombre SIZE 1,40 COLOR W+/BG
@ 02,15 SAY m.fecha_fin SIZE 1,10 COLOR W+/BG
@ 02,37 SAY m.lista SIZE 1,1 COLOR W+/BG
@ 02,51 SAY m.porcdesc SIZE 1,8 COLOR W+/BG

IF !WVISIBLE("cabecera") THEN
   ACTIVATE WINDOW cabecera
ENDIF

IF !WVISIBLE("pie") THEN
   ACTIVATE WINDOW pie
ENDIF

@ 00,00 TO 00,79 " " COLOR N/W
@ 00,01 SAY "                                                                   ³  ESC=Sale" COLOR N/W

DO load_detail

SELECT tmp_detaof
GOTO TOP

BROWSE WINDOW detalle FIELDS ;
   b1 = LEFT(articulo, 13) :R:13:P = "@!" :H = "C¢digo",;
   b2 = LEFT(art_nombre, 36) :R:36:P = "@!" :H = "Descripci¢n",;
   precio :R:12:P = "9999,999,999" :H = "Precio Lista",;
   precio2 :R:12:P = "9999,999,999" :H = "Prec. Oferta";
   NOAPPEND NODELETE NOMODIFY

RELEASE WINDOW cabecera
RELEASE WINDOW detalle
RELEASE WINDOW pie

POP KEY

*--------------------------------------------------------------------------*
FUNCTION vldnombre
PARAMETER m.nombre
IF EMPTY(m.nombre) THEN
   WAIT "EL NOMBRE NO PUEDE QUEDAR EN BLANCO !" WINDOW
   RETURN 0
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE crear_dbf
CREATE TABLE cabeofer (;
   id_oferta N(10),;
   nombre C(40),;
   lista N(1),;
   porcdesc N(8,4),;
   fecha_fin D(8),;
   fecha_alta D(8);
)
INDEX ON id_oferta TAG "id_oferta"

CREATE TABLE detaofer (;
   id_oferta N(10),;
   articulo C(15);
)
INDEX ON id_oferta TAG "id_oferta"

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
   precio N(10),;
   porc_iva N(6,2),;
   iva_5p N(9),;
   iva_10p N(9),;
   monto_fact N(9),;
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
      m.precio     = ROUND(precio * (1 + pimpuesto / 100), 0)
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
         m.iva_5p = m.iva_5p + ROUND(precio * cantidad, 0)
      CASE porc_iva = 10
         m.iva_10p = m.iva_10p + ROUND(precio * cantidad, 0)
   ENDCASE
ENDSCAN

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

*REPORT FORM factura PREVIEW
REPORT FORM factura TO PRINTER NOCONSOLE

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
PROCEDURE insert_record
PRIVATE m.id_oferta, m.nombre, m.fecha_fin, m.fecha_alta, m.lista, m.porcdesc

STORE .T. TO m.adding

PUSH KEY CLEAR

IF !WEXIST("cabecera") THEN
   DEFINE WINDOW cabecera ;
      FROM 01,00 ;
      TO 05,79 ;
      TITLE "[ AGREGAR LISTA DE OFERTA ]" ;
      NOCLOSE ;
      NOFLOAT ;
      NOGROW ;
      NOMDI ;
      NOMINIMIZE ;
      NOSHADOW ;
      NOZOOM
ENDIF

IF !WEXIST("detalle") THEN
   DEFINE WINDOW detalle ;
      FROM 06,00 ;
      TO 23,79 ;
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

IF !WEXIST("pie") THEN
   DEFINE WINDOW pie ;
      FROM 06,00 ;
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

IF !WVISIBLE("pie") THEN
   ACTIVATE WINDOW pie
ENDIF

@ 00,00,17,79 BOX REPLICATE(CHR(178), 8) + CHR(178)
@ 00,00 FILL TO 17,79 COLOR BG/B
@ 18,00 TO 18,79 " " COLOR N/W
@ 18,01 SAY "                                                                   ³  ESC=Sale" COLOR N/W

IF WVISIBLE("cabecera") THEN
   ACTIVATE WINDOW cabecera
ELSE
   ACTIVATE WINDOW cabecera NOSHOW
ENDIF

SELECT tmp_detaof
ZAP

SELECT cabeofer
SCATTER MEMVAR BLANK
STORE DATE() TO m.fecha_fin, m.fecha_alta
m.lista = 1


@ 00,02 SAY "Oferta N§..:" SIZE 1,12 COLOR BG+/B
@ 01,02 SAY "Descripci¢n:" SIZE 1,12 COLOR BG+/B
@ 02,02 SAY "Validez....:" SIZE 1,12 COLOR BG+/B
@ 02,27 SAY "Lista N§:" SIZE 1,9 COLOR BG+/B
@ 02,40 SAY "Descuento:         %" SIZE 1,20 COLOR BG+/B

@ 00,15 GET m.id_oferta PICTURE "9999999999" DEFAULT 0 SIZE 1,10 WHEN .F.
@ 01,15 GET m.nombre PICTURE "@!" DEFAULT " " SIZE 1,40 VALID vldnombre(m.nombre)
@ 02,15 GET m.fecha_fin PICTURE "@D" DEFAULT DATE() SIZE 1,10 VALID vldfecha(m.fecha_fin)
@ 02,37 GET m.lista PICTURE "9" DEFAULT 1 SIZE 1,1 VALID vldlista(m.lista)
@ 02,51 GET m.porcdesc PICTURE "999.9999" DEFAULT 0 SIZE 1,8 VALID vldporcdesc(m.porcdesc)

IF !WVISIBLE("cabecera") THEN
   ACTIVATE WINDOW cabecera
ENDIF

READ CYCLE ;
   MODAL ;
   COLOR ,W+/G

RELEASE WINDOW cabecera
RELEASE WINDOW detalle
RELEASE WINDOW pie

POP KEY

*--------------------------------------------------------------------------*
PROCEDURE vldarticulo
PRIVATE m.articulo, m.count

   STORE " " TO m.articulo
   STORE  0  TO m.count

   SELECT tmp_detaof
   IF EMPTY(articulo) THEN
      DO buscarti WITH "m.articulo"
   ELSE
      m.articulo = ALLTRIM(articulo)
   ENDIF

   IF EMPTY(m.articulo) THEN
      RETURN 0
   ENDIF

   SELECT maesprod
   SET ORDER TO 1
   IF !SEEK(m.articulo) THEN
      WAIT "CODIGO DE ARTICULO INEXISTENTE !" WINDOW
      RETURN 0
   ENDIF

   m.art_nombre = look_up("nombre", "maesprod", m.articulo)
   m.precio     = ROUND(look_up("pventag" + STR(m.lista, 1), "maesprod", m.articulo) * (1 + look_up("pimpuesto", "maesprod", m.articulo) / 100), 0)
   m.precio2    = m.precio - ROUND(m.precio * m.porcdesc / 100, 0)

   SELECT tmp_detaof
   REPLACE articulo   WITH m.articulo
   REPLACE art_nombre WITH m.art_nombre
   REPLACE precio     WITH m.precio
   REPLACE precio2    WITH m.precio2

   * verifica si el art¡culo ya ha sido cargado anteriormente.
   m.count = count_id(articulo)

   IF m.count > 1 THEN
      WAIT "ESTE ARTICULO YA HA SIDO CARGADO EN ESTE LISTA DE OFERTAS !" WINDOW
      RETURN 0
   ENDIF

   * verifica si el articulo no figura en otra lista de oferta.
   SELECT cabeofer
   SET ORDER TO 1
   SCAN FOR fecha_fin >= DATE()
      IF lista = m.lista THEN
         SELECT detaofer
         SET ORDER TO 1
         IF SEEK(cabeofer.id_oferta) THEN
            SCAN WHILE id_oferta = cabeofer.id_oferta
               IF articulo = tmp_detaof.articulo THEN
                  WAIT "ESTE ARTICULO YA FIGURA EN LA LISTA DE OFERTA N§: " + ALLTRIM(STR(cabeofer.id_oferta)) WINDOW
                  RETURN 0
               ENDIF
            ENDSCAN
         ENDIF
      ENDIF
   ENDSCAN

   SELECT tmp_detaof
   DO insert_line
   GOTO BOTTOM

*--------------------------------------------------------------------------*
FUNCTION count_id
PARAMETER m.articulo

   PRIVATE m.select, m.archi_01, m.return
   m.select   = SELECT()
   m.archi_01 = createmp()

   SELECT * FROM tmp_detaof WHERE articulo = m.articulo INTO TABLE &archi_01
   m.return = RECCOUNT()
   USE
   DO borratemp WITH m.archi_01

   IF !EMPTY(ALIAS(m.select)) THEN
      SELECT (m.select)
   ENDIF

RETURN (m.return)

*--------------------------------------------------------------------------*
PROCEDURE confirm_delete
   SELECT cabeofer
   IF EOF() THEN
      WAIT "EL ARCHIVO ESTA VACIO, NO SE PUEDE REALIZAR BORRADOS !" WINDOW
      RETURN
   ENDIF

   IF messagebox("DESEA BORRARLO ?", 48) = 6 THEN
      m.id_oferta = id_oferta
      DO delete_record
      SELECT cabeofer
      IF !BOF() THEN
         SKIP -1
         IF BOF() THEN
            GOTO TOP
         ENDIF
      ENDIF
   ENDIF

*--------------------------------------------------------------------------*
PROCEDURE delete_record
   PRIVATE m.order

   * Borra el encabezado.
   SELECT cabeofer
   m.order = VAL(SYS(21))
   SET ORDER TO 1
   IF SEEK(m.id_oferta) THEN
      DELETE
   ENDIF
   SET ORDER TO m.order

   * Borra el detalle.
   SELECT detaofer
   DELETE FOR id_oferta = m.id_oferta

*--------------------------------------------------------------------------*
PROCEDURE edit_record
PRIVATE m.id_oferta, m.nombre, m.fecha_fin, m.fecha_alta, m.lista, m.porcdesc

STORE .F. TO m.adding

PUSH KEY CLEAR

IF !WEXIST("cabecera") THEN
   DEFINE WINDOW cabecera ;
      FROM 01,00 ;
      TO 05,79 ;
      TITLE "[ AGREGAR LISTA DE OFERTA ]" ;
      NOCLOSE ;
      NOFLOAT ;
      NOGROW ;
      NOMDI ;
      NOMINIMIZE ;
      NOSHADOW ;
      NOZOOM
ENDIF

IF !WEXIST("detalle") THEN
   DEFINE WINDOW detalle ;
      FROM 06,00 ;
      TO 23,79 ;
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

IF !WEXIST("pie") THEN
   DEFINE WINDOW pie ;
      FROM 06,00 ;
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

IF !WVISIBLE("pie") THEN
   ACTIVATE WINDOW pie
ENDIF

@ 00,00,17,79 BOX REPLICATE(CHR(178), 8) + CHR(178)
@ 00,00 FILL TO 17,79 COLOR BG/B
@ 18,00 TO 18,79 " " COLOR N/W
@ 18,01 SAY "                                                                   ³  ESC=Sale" COLOR N/W

IF WVISIBLE("cabecera") THEN
   ACTIVATE WINDOW cabecera
ELSE
   ACTIVATE WINDOW cabecera NOSHOW
ENDIF

SELECT cabeofer
SCATTER MEMVAR

DO load_detail

@ 00,02 SAY "Oferta N§..:" SIZE 1,12 COLOR BG+/B
@ 01,02 SAY "Descripci¢n:" SIZE 1,12 COLOR BG+/B
@ 02,02 SAY "Validez....:" SIZE 1,12 COLOR BG+/B
@ 02,27 SAY "Lista N§:" SIZE 1,9 COLOR BG+/B
@ 02,40 SAY "Descuento:         %" SIZE 1,20 COLOR BG+/B

@ 00,15 GET m.id_oferta PICTURE "9999999999" DEFAULT 0 SIZE 1,10 WHEN .F.
@ 01,15 GET m.nombre PICTURE "@!" DEFAULT " " SIZE 1,40 VALID vldnombre(m.nombre)
@ 02,15 GET m.fecha_fin PICTURE "@D" DEFAULT DATE() SIZE 1,10 VALID vldfecha(m.fecha_fin)
@ 02,37 GET m.lista PICTURE "9" DEFAULT 1 SIZE 1,1 VALID vldlista(m.lista)
@ 02,51 GET m.porcdesc PICTURE "999.9999" DEFAULT 0 SIZE 1,8 VALID vldporcdesc(m.porcdesc)

IF !WVISIBLE("cabecera") THEN
   ACTIVATE WINDOW cabecera
ENDIF

READ CYCLE ;
   MODAL ;
   COLOR ,W+/G

RELEASE WINDOW cabecera
RELEASE WINDOW detalle
RELEASE WINDOW pie

POP KEY