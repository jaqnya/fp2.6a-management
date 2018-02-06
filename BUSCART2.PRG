PARAMETER m.storeto

PRIVATE m.select, m.codigo, m.nombre, m.cod_origen, m.cod_altern

STORE " " TO m.select, m.codigo, m.nombre, m.cod_origen, m.cod_altern

DO load
DO init

@ 01,00 TO 04,79 COLOR GR+/B
DO center WITH 1, "[ BUSCAR ARTICULO ]", "GR+/B"

@ 02,02 SAY "Descripci¢n:" COLOR BG+/B
@ 03,02 SAY "C¢digo.....:" COLOR BG+/B
@ 02,42 SAY "C¢d. Original...:" COLOR BG+/B
@ 03,42 SAY "C¢d. Alternativo:" COLOR BG+/B

@ 02,15 GET m.nombre PICTURE "@!T" DEFAULT " " SIZE 1,25 VALID vldnombre()
@ 03,15 GET m.codigo PICTURE "@!T" DEFAULT " " SIZE 1,18 VALID vldcodigo()
@ 02,60 GET m.cod_origen PICTURE "@!T" DEFAULT " " SIZE 1,18 VALID vldcod_origen()
@ 03,60 GET m.cod_altern PICTURE "@!T" DEFAULT " " SIZE 1,18 VALID vldcod_altern()

@ 00,00 TO 00,79 " " COLOR N/W
DO center WITH 0, " A & A IMPORTACIONES S.R.L. ", "N/W"
@ 05,00,23,79 BOX REPLICATE(CHR(178), 8) + CHR(178)
@ 05,00 FILL TO 23,79 COLOR BG/B
@ 24,00 TO 24,79 " " COLOR N/W

IF !WVISIBLE("busc_artic") THEN
   ACTIVATE WINDOW busc_artic
ENDIF

READ CYCLE ;
   MODAL ;
   COLOR ,W+/G

DO unload

*--------------------------------------------------------------------------*
PROCEDURE load

PUSH KEY CLEAR

SET CENTURY    ON
SET DATE       BRITISH
SET DELETED    ON
SET SAFETY     OFF
SET STATUS BAR OFF
SET SYSMENU    OFF
SET TALK       OFF
=CAPSLOCK(.T.)
=INSMODE(.T.)

m.select = SELECT()

IF !USED("maesprod") THEN
   USE maesprod IN 0 AGAIN SHARED
ENDIF

IF !USED("maesprod2") THEN
   USE SYS(5) + "\turtle\aya\integrad.001\maesprod" IN 0 AGAIN ORDER 1 SHARED ALIAS maesprod2
ENDIF

IF !USED("maesprod3") THEN
   USE SYS(5) + "\turtle\allparts\integrad.000\maesprod" IN 0 AGAIN ORDER 1 SHARED ALIAS maesprod3
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE unload

IF USED("maesprod2") THEN
   SELECT maesprod2
   USE
ENDIF

IF USED("maesprod3") THEN
   SELECT maesprod3
   USE
ENDIF

IF !EMPTY(ALIAS(m.select)) THEN
   SELECT (m.select)
ENDIF

RELEASE WINDOW busc_artic
POP KEY

*--------------------------------------------------------------------------*
PROCEDURE init

SET COLOR OF SCHEME 1 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,,R+/B,+

IF !WEXIST("busc_artic") THEN
   DEFINE WINDOW busc_artic ;
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

IF WVISIBLE("busc_artic") THEN
   ACTIVATE WINDOW busc_artic SAME
ELSE
   ACTIVATE WINDOW busc_artic NOSHOW
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE center
PARAMETERS m.row, m.text, m.color
m.column = 40 - (LEN(m.text) / 2)
@ m.row, m.column SAY m.text COLOR (m.color)

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
PROCEDURE vldnombre

SHOW GETS

IF !EMPTY(m.nombre) THEN
   PRIVATE m.string, m.sql_result, m.sql

   m.string = STRTRAN(m.nombre + "*", "*", "%")
   m.sql_result = createmp()
   m.sql_resul2 = "tm" + RIGHT(SYS(2015), 6)   && Deposito
   m.sql_resul3 = "tm" + RIGHT(SYS(2015), 6)   && Deposito [All Parts SRL]

   DO WHILE AT("%%", m.string) > 0
      m.string = STRTRAN(m.string, "%%", "%")
   ENDDO

   IF LEN(m.string) > 1 THEN
      WAIT "BUSCANDO..." WINDOW NOWAIT

      m.sql = "SELECT a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod a " + ;
                 "INTO TABLE " + m.sql_result + " " + ;
                 "WHERE nombre LIKE '" + m.string + "' " + ;
                 "ORDER BY nombre"
      &sql

      *-- BOB: Deposito --*
      m.sql = "SELECT a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod2 a " + ;
                 "INTO TABLE " + m.sql_resul2 + " " + ;
                 "WHERE nombre LIKE '" + m.string + "' " + ;
                 "ORDER BY nombre"
      &sql

      SELECT (m.sql_resul2)
      SCAN ALL
         xcodigo = codigo
         xnombre = nombre
         xpventag1 = pventag1
         xpventag2 = pventag2
         xpventag3 = pventag3
         xstock = stock

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xcodigo, xnombre, xpventag1, xstock, xpventag2, xpventag3)
         ENDIF
      ENDSCAN
      
      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito --*

      *-- BOB: Deposito [All Parts SRL]--*
      m.sql = "SELECT a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod3 a " + ;
                 "INTO TABLE " + m.sql_resul3 + " " + ;
                 "WHERE nombre LIKE '" + m.string + "' " + ;
                 "ORDER BY nombre"
      &sql

      SELECT (m.sql_resul3)
      SCAN ALL
         xcodigo = codigo
         xnombre = nombre
         xpventag1 = pventag1
         xpventag2 = pventag2
         xpventag3 = pventag3
         xstock = stock

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xcodigo, xnombre, xpventag1, xstock, xpventag2, xpventag3)
         ENDIF
      ENDSCAN
      
      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito [All Parts SRL] --*

      WAIT CLEAR
      
      IF RECCOUNT() > 0 THEN
         DO show_result
      ELSE
         WAIT "EL DATO BUSCADO NO HA SIDO ENCONTRADO !" WINDOW
         DO del_result
         RETURN 0
      ENDIF
   ELSE
      WAIT "DEBE PROPORCIONAR ALGUNA FRASE PARA LA BUSQUEDA !" WINDOW
      RETURN 0
   ENDIF
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldcodigo

SHOW GETS

IF !EMPTY(m.codigo) THEN
   PRIVATE m.string, m.sql_result, m.sql

   m.string = STRTRAN(m.codigo + "*", "*", "%")
   m.sql_result = createmp()
   m.sql_resul2 = "tm" + RIGHT(SYS(2015), 6)   && Deposito
   m.sql_resul3 = "tm" + RIGHT(SYS(2015), 6)   && Deposito [All Parts SRL]

   DO WHILE AT("%%", m.string) > 0
      m.string = STRTRAN(m.string, "%%", "%")
   ENDDO
   
   IF LEN(m.string) > 1 THEN
      WAIT "BUSCANDO..." WINDOW NOWAIT
      
      m.sql = "SELECT a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod a " + ;
                 "INTO TABLE " + m.sql_result + " " + ;
                 "WHERE codigo LIKE '" + m.string + "' " + ;
                 "ORDER BY codigo"
      &sql
      
      *-- BOB: Deposito --*
      m.sql = "SELECT a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod2 a " + ;
                 "INTO TABLE " + m.sql_resul2 + " " + ;
                 "WHERE codigo LIKE '" + m.string + "' " + ;
                 "ORDER BY codigo"
      &sql

      SELECT (m.sql_resul2)
      SCAN ALL
         xcodigo = codigo
         xnombre = nombre
         xpventag1 = pventag1
         xpventag2 = pventag2
         xpventag3 = pventag3
         xstock = stock

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xcodigo, xnombre, xpventag1, xstock, xpventag2, xpventag3)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito --*

      *-- BOB: Deposito [All Parts SRL] --*
      m.sql = "SELECT a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod3 a " + ;
                 "INTO TABLE " + m.sql_resul3 + " " + ;
                 "WHERE codigo LIKE '" + m.string + "' " + ;
                 "ORDER BY codigo"
      &sql

      SELECT (m.sql_resul3)
      SCAN ALL
         xcodigo = codigo
         xnombre = nombre
         xpventag1 = pventag1
         xpventag2 = pventag2
         xpventag3 = pventag3
         xstock = stock

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xcodigo, xnombre, xpventag1, xstock, xpventag2, xpventag3)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito [All Parts SRL] --*

      WAIT CLEAR
      
      IF RECCOUNT() > 0 THEN
         DO show_result
      ELSE
         WAIT "EL DATO BUSCADO NO HA SIDO ENCONTRADO !" WINDOW
         DO del_result
         RETURN 0
      ENDIF
   ELSE
      WAIT "DEBE PROPORCIONAR ALGUNA FRASE PARA LA BUSQUEDA !" WINDOW
      RETURN 0
   ENDIF
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldcod_origen

SHOW GETS

IF !EMPTY(m.cod_origen) THEN
   PRIVATE m.string, m.sql_result, m.sql

   m.string = STRTRAN(m.cod_origen + "*", "*", "%")
   m.sql_result = createmp()
   m.sql_resul2 = "tm" + RIGHT(SYS(2015), 6)   && Deposito
   m.sql_resul3 = "tm" + RIGHT(SYS(2015), 6)   && Deposito [All Parts SRL]

   DO WHILE AT("%%", m.string) > 0
      m.string = STRTRAN(m.string, "%%", "%")
   ENDDO
   
   IF LEN(m.string) > 1 THEN
      WAIT "BUSCANDO..." WINDOW NOWAIT
      
      m.sql = "SELECT a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod a " + ;
                 "INTO TABLE " + m.sql_result + " " + ;
                 "WHERE codorig LIKE '" + m.string + "' " + ;
                 "ORDER BY codorig"
      &sql

      *-- BOB: Deposito --*
      m.sql = "SELECT a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod2 a " + ;
                 "INTO TABLE " + m.sql_resul2 + " " + ;
                 "WHERE codorig LIKE '" + m.string + "' " + ;
                 "ORDER BY codorig"
      &sql

      SELECT (m.sql_resul2)
      SCAN ALL
         xcodigo = codigo
         xnombre = nombre
         xpventag1 = pventag1
         xpventag2 = pventag2
         xpventag3 = pventag3
         xstock = stock

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xcodigo, xnombre, xpventag1, xstock, xpventag2, xpventag3)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito --*
      
      *-- BOB: Deposito [All Parts SRL] --*
      m.sql = "SELECT a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod3 a " + ;
                 "INTO TABLE " + m.sql_resul3 + " " + ;
                 "WHERE codorig LIKE '" + m.string + "' " + ;
                 "ORDER BY codorig"
      &sql

      SELECT (m.sql_resul3)
      SCAN ALL
         xcodigo = codigo
         xnombre = nombre
         xpventag1 = pventag1
         xpventag2 = pventag2
         xpventag3 = pventag3
         xstock = stock

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xcodigo, xnombre, xpventag1, xstock, xpventag2, xpventag3)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito [All Parts SRL] --*

      WAIT CLEAR
      
      IF RECCOUNT() > 0 THEN
         DO show_result
      ELSE
         WAIT "EL DATO BUSCADO NO HA SIDO ENCONTRADO !" WINDOW
         DO del_result
         RETURN 0
      ENDIF
   ELSE
      WAIT "DEBE PROPORCIONAR ALGUNA FRASE PARA LA BUSQUEDA !" WINDOW
      RETURN 0
   ENDIF
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldcod_altern

SHOW GETS

IF !EMPTY(m.cod_altern) THEN
   PRIVATE m.string, m.sql_result, m.sql

   m.string = STRTRAN(m.cod_altern + "*", "*", "%")
   m.sql_result = createmp()
   m.sql_resul2 = "tm" + RIGHT(SYS(2015), 6)   && Deposito
   m.sql_resul3 = "tm" + RIGHT(SYS(2015), 6)   && Deposito [All Parts SRL]

   DO WHILE AT("%%", m.string) > 0
      m.string = STRTRAN(m.string, "%%", "%")
   ENDDO
   
   IF LEN(m.string) > 1 THEN
      WAIT "BUSCANDO..." WINDOW NOWAIT
      
      m.sql = "SELECT a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod a " + ;
                 "INTO TABLE " + m.sql_result + " " + ;
                 "WHERE codigo2 LIKE '" + m.string + "' " + ;
                 "ORDER BY codigo2"
      &sql

      *-- BOB: Deposito --*
      m.sql = "SELECT a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod2 a " + ;
                 "INTO TABLE " + m.sql_resul2 + " " + ;
                 "WHERE codigo2 LIKE '" + m.string + "' " + ;
                 "ORDER BY codigo2"
      &sql
      
      SELECT (m.sql_resul2)
      SCAN ALL
         xcodigo = codigo
         xnombre = nombre
         xpventag1 = pventag1
         xpventag2 = pventag2
         xpventag3 = pventag3
         xstock = stock

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xcodigo, xnombre, xpventag1, xstock, xpventag2, xpventag3)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito --*

      *-- BOB: Deposito [All Parts SRL] --*
      m.sql = "SELECT a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod3 a " + ;
                 "INTO TABLE " + m.sql_resul3 + " " + ;
                 "WHERE codigo2 LIKE '" + m.string + "' " + ;
                 "ORDER BY codigo2"
      &sql
      
      SELECT (m.sql_resul3)
      SCAN ALL
         xcodigo = codigo
         xnombre = nombre
         xpventag1 = pventag1
         xpventag2 = pventag2
         xpventag3 = pventag3
         xstock = stock

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xcodigo, xnombre, xpventag1, xstock, xpventag2, xpventag3)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito [All Parts SRL] --*

      WAIT CLEAR
      
      IF RECCOUNT() > 0 THEN
         DO show_result
      ELSE
         WAIT "EL DATO BUSCADO NO HA SIDO ENCONTRADO !" WINDOW
         DO del_result
         RETURN 0
      ENDIF
   ELSE
      WAIT "DEBE PROPORCIONAR ALGUNA FRASE PARA LA BUSQUEDA !" WINDOW
      RETURN 0
   ENDIF
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE show_result

IF !WEXIST("busqueda") THEN
   DEFINE WINDOW busqueda ;
      FROM 05,00 ;
      TO 23,79 ;
      TITLE ALLTRIM(STR(RECCOUNT())) + IIF(RECCOUNT() > 1, " REGISTROS ENCONTRADOS", " REGISTRO ENCONTRADO") ;
      NOCLOSE ;
      NOFLOAT ;
      NOGROW ;
      NOMDI ;
      NOMINIMIZE ;
      NOSHADOW ;
      NOZOOM  ;
      COLOR W+/BG,GR+/RB,GR+/B,GR+/B,,,GR+/RB
ENDIF

@ 24,01 SAY IIF(EMPTY(m.storeto), "ESC=Realiza nueva busqueda", "ENTER=Selecciona el registro actual  ³  ESC=Realiza nueva busqueda") COLOR N/W

IF !EMPTY(m.storeto) THEN
   ON KEY LABEL "ENTER" KEYBOARD "{CTRL+W}"
ENDIF

BROWSE WINDOW busqueda FIELDS ;
   b1 = codigo :R:15:P = "@!" :H = "C¢digo",;
   b2 = LEFT(nombre, 41) :R:41:P = "@!" :H = "Descripci¢n",;
   b3 = pventag1 :R:10:P = "99,999,999" :H = " P.Vta. 1",;
   b4 = stock :R:7:P = "9999.99" :H = " Stock";
   FONT "Courier New", 9 ;
   NOAPPEND NODELETE NOMODIFY

IF !EMPTY(m.storeto) THEN
   ON KEY LABEL "ENTER"
   IF LASTKEY() <> 27 THEN
      &storeto = codigo
   ENDIF
ENDIF

RELEASE WINDOW busqueda

STORE " " TO m.codigo, m.nombre, m.cod_origen, m.cod_altern
_CUROBJ = OBJNUM(m.nombre)

@ 24,00 TO 24,79 " " COLOR N/W

IF !EMPTY(m.storeto) THEN
   IF LASTKEY() <> 27 THEN
      RELEASE WINDOW busc_artic
   ENDIF
ENDIF

DO del_result

*--------------------------------------------------------------------------*
PROCEDURE del_result

IF USED(m.sql_result) THEN
   SELECT (m.sql_result)
   USE
   DO borratemp WITH m.sql_result
ENDIF

IF USED(m.sql_resul2) THEN
   SELECT (m.sql_resul2)
   USE
   DO borratemp WITH m.sql_resul2
ENDIF

IF USED(m.sql_resul3) THEN
   SELECT (m.sql_resul3)
   USE
   DO borratemp WITH m.sql_resul3
ENDIF

*!*	SELECT &sql_result
*!*	USE
*!*	DO borratemp WITH m.sql_result

*!*	SELECT &sql_resul2
*!*	USE
*!*	DO borratemp WITH m.sql_resul2

*!*	SELECT &sql_resul3
*!*	USE
*!*	DO borratemp WITH m.sql_resul3