PARAMETER m.storeto

IF PARAMETERS() < 1 THEN
   m.storeto = ""
ENDIF

PRIVATE m.select, m.codigo, m.nombre, m.aplicacion, m.cod_origen, m.cod_altern, m.ubicacion

STORE " " TO m.select, m.codigo, m.nombre, m.aplicacion, m.cod_origen, m.cod_altern, m.ubicacion

*-*-*-*-*-*-
PRIVATE pcSys16, pcProgram, pcPriorDir
pcSys16    = SYS(16, 0)
pcProgram  = SUBSTR(pcSys16, RAT("\", pcSys16) + 1)
pcPriorDir = SUBSTR(pcSys16, RAT("\", pcSys16, 2) + 1, RAT("\", pcSys16) - RAT("\", pcSys16, 2) - 1)
*-*-*-*-*-*-

DO load
DO init

@ 01,00 TO 05,79 COLOR GR+/B
DO center WITH 1, "[ BUSCAR ARTICULO ]", "GR+/B"

@ 02,02 SAY "Descripci¢n:" COLOR BG+/B
@ 03,02 SAY "C¢digo.....:" COLOR BG+/B
@ 04,02 SAY "Aplicaci¢n.:" COLOR BG+/B
@ 02,42 SAY "C¢d. Original...:" COLOR BG+/B
@ 03,42 SAY "C¢d. Alternativo:" COLOR BG+/B
@ 04,42 SAY "Ubicaci¢n.......:" COLOR BG+/B

@ 02,15 GET m.nombre PICTURE "@!T" DEFAULT " " SIZE 1,25 VALID vldnombre()
@ 03,15 GET m.codigo PICTURE "@!T" DEFAULT " " SIZE 1,25 VALID vldcodigo()
@ 04,15 GET m.aplicacion PICTURE "@!T" DEFAULT " " SIZE 1,25 VALID vldaplicacion()
@ 02,60 GET m.cod_origen PICTURE "@!T" DEFAULT " " SIZE 1,18 VALID vldcod_origen()
@ 03,60 GET m.cod_altern PICTURE "@!T" DEFAULT " " SIZE 1,18 VALID vldcod_altern()
@ 04,60 GET m.ubicacion  PICTURE "@!T" DEFAULT " " SIZE 1,18 VALID vldubicacion()

@ 00,00 TO 00,79 " " COLOR N/W
DO center WITH 0, " A & A IMPORTACIONES S.R.L. ", "N/W"
@ 06,00,23,79 BOX REPLICATE(CHR(178), 8) + CHR(178)
@ 06,00 FILL TO 23,79 COLOR BG/B
@ 24,00 TO 24,79 " " COLOR N/W

IF !WVISIBLE("busc_artic") THEN
   ACTIVATE WINDOW busc_artic
ENDIF

ON KEY LABEL "F2" DO addProduct

READ CYCLE ;
   MODAL ;
   COLOR ,W+/G

ON KEY LABEL "F2"

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
   USE maesprod IN 0 AGAIN ORDER 0 SHARED
ENDIF

IF !USED("maesprod2") THEN
   USE SYS(5) + "\turtle\aya\integrad.001\maesprod" IN 0 AGAIN ORDER 0 SHARED ALIAS maesprod2
ENDIF

IF !USED("maesprod3") THEN
   USE SYS(5) + "\turtle\allparts\integrad.000\maesprod" IN 0 AGAIN ORDER 0 SHARED ALIAS maesprod3
ENDIF

IF pcPriorDir = 'INTEGRAD.006' THEN   && [SUCURSAL AVDA. EUSEBIO AYALA]
   IF !USED("maesprod4") THEN
      USE SYS(5) + "\turtle\aya\integrad.000\maesprod" IN 0 AGAIN ORDER 1 SHARED ALIAS maesprod4
   ENDIF
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

IF USED("maesprod4") THEN
   SELECT maesprod4
   USE
ENDIF

IF !EMPTY(ALIAS(m.select)) THEN
   SELECT (m.select)
ENDIF

RELEASE WINDOW busc_artic
POP KEY

*--------------------------------------------------------------------------*
PROCEDURE init

*!*	SET COLOR OF SCHEME 1 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,,R+/B,+

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
   PRIVATE m.string, m.sql_result, m.sql_resul2, m.sql_resul3, m.sql
   m.string = STRTRAN(m.nombre + "*", "*", "%")

   DO WHILE AT("%%", m.string) > 0
      m.string = STRTRAN(m.string, "%%", "%")
   ENDDO

   IF LEN(m.string) > 1 THEN
      WAIT "BUSCANDO..." WINDOW NOWAIT

      *-- BOB: Casa Central --*
      m.sql_result = CreaTemp()

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod a " + ;
                 "INTO TABLE " + m.sql_result + " " + ;
                 "WHERE nombre LIKE '" + m.string + "' " + ;
                 "ORDER BY nombre"
      &sql
      *-- EOB: Casa Central --*

      *-- BOB: Deposito --*
      m.sql_resul2 = CreaTemp()   && Deposito

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod2 a " + ;
                 "INTO TABLE " + m.sql_resul2 + " " + ;
                 "WHERE nombre LIKE '" + m.string + "' " + ;
                 "ORDER BY nombre"
      &sql

      SELECT (m.sql_resul2)
      SCAN ALL
         xrubro     = rubro
         xcodigo    = codigo
         xubicacion = ubicacion
         xnombre    = nombre
         xpventag1  = pventag1
         xstock     = stock
         xpventag2  = pventag2
         xpventag3  = pventag3
         xcodigo2   = codigo2
         xcodorig   = codorig

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xubicacion, xnombre, xpventag1, xstock, xpventag2, xpventag3, xcodigo2, xcodorig)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito --*

      *-- BOB: Deposito [All Parts SRL] --*
      m.sql_resul3 = CreaTemp()   && Deposito [All Parts SRL]

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod3 a " + ;
                 "INTO TABLE " + m.sql_resul3 + " " + ;
                 "WHERE nombre LIKE '" + m.string + "' " + ;
                 "ORDER BY nombre"
      &sql

      SELECT (m.sql_resul3)
      SCAN ALL
         xrubro     = rubro
         xcodigo    = codigo
         xubicacion = ubicacion
         xnombre    = nombre
         xpventag1  = pventag1
         xstock     = stock
         xpventag2  = pventag2
         xpventag3  = pventag3
         xcodigo2   = codigo2
         xcodorig   = codorig

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xubicacion, xnombre, xpventag1, xstock, xpventag2, xpventag3, xcodigo2, xcodorig)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito [All Parts SRL] --*


      *-- BOB: Sucursal [006] --*
IF pcPriorDir = 'INTEGRAD.006' THEN
      m.sql_resul4 = CreaTemp()

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod4 a " + ;
                 "INTO TABLE " + m.sql_resul4 + " " + ;
                 "WHERE nombre LIKE '" + m.string + "' " + ;
                   "AND a.stock_actu - a.stock_ot > 0 " + ;
                 "ORDER BY nombre"
      &sql

      SELECT (m.sql_resul4)
      SCAN ALL
         xrubro = rubro
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
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xnombre, xpventag1, xstock, xpventag2, xpventag3)
         ENDIF
      ENDSCAN
      
      SELECT (m.sql_result)
      GOTO TOP
ENDIF
      *-- EOB: Sucursal [006] --*

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
   PRIVATE m.string, m.sql_result, m.sql_resul2, m.sql_resul3, m.sql
   m.string = STRTRAN(m.codigo + "*", "*", "%")

   DO WHILE AT("%%", m.string) > 0
      m.string = STRTRAN(m.string, "%%", "%")
   ENDDO

   IF LEN(m.string) > 1 THEN
      WAIT "BUSCANDO..." WINDOW NOWAIT

      *-- BOB: Casa Central --*
      m.sql_result = CreaTemp()

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod a " + ;
                 "INTO TABLE " + m.sql_result + " " + ;
                 "WHERE codigo LIKE '" + m.string + "' " + ;
                 "ORDER BY codigo"
      &sql
      *-- EOB: Casa Central --*

      *-- BOB: Deposito --*
      m.sql_resul2 = CreaTemp()   && Deposito

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod2 a " + ;
                 "INTO TABLE " + m.sql_resul2 + " " + ;
                 "WHERE codigo LIKE '" + m.string + "' " + ;
                 "ORDER BY codigo"
      &sql

      SELECT (m.sql_resul2)
      SCAN ALL
         xrubro     = rubro
         xcodigo    = codigo
         xubicacion = ubicacion
         xnombre    = nombre
         xpventag1  = pventag1
         xstock     = stock
         xpventag2  = pventag2
         xpventag3  = pventag3
         xcodigo2   = codigo2
         xcodorig   = codorig

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xubicacion, xnombre, xpventag1, xstock, xpventag2, xpventag3, xcodigo2, xcodorig)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito --*

      *-- BOB: Deposito [All Parts SRL] --*
      m.sql_resul3 = CreaTemp()   && Deposito [All Parts SRL]

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod3 a " + ;
                 "INTO TABLE " + m.sql_resul3 + " " + ;
                 "WHERE codigo LIKE '" + m.string + "' " + ;
                 "ORDER BY codigo"
      &sql

      SELECT (m.sql_resul3)
      SCAN ALL
         xrubro     = rubro
         xcodigo    = codigo
         xubicacion = ubicacion
         xnombre    = nombre
         xpventag1  = pventag1
         xstock     = stock
         xpventag2  = pventag2
         xpventag3  = pventag3
         xcodigo2   = codigo2
         xcodorig   = codorig

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xubicacion, xnombre, xpventag1, xstock, xpventag2, xpventag3, xcodigo2, xcodorig)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito [All Parts SRL] --*

      *-- BOB: Sucursal [006] --*
IF pcPriorDir = 'INTEGRAD.006' THEN
      m.sql_resul4 = CreaTemp()

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod4 a " + ;
                 "INTO TABLE " + m.sql_resul4 + " " + ;
                 "WHERE codigo LIKE '" + m.string + "' " + ;
                   "AND a.stock_actu - a.stock_ot > 0 " + ;
                 "ORDER BY codigo"
      &sql

      SELECT (m.sql_resul4)
      SCAN ALL
         xrubro  = rubro
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
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xnombre, xpventag1, xstock, xpventag2, xpventag3)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP

ENDIF
      *-- EOB: Sucursal [006] --*

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
PROCEDURE vldaplicacion

SHOW GETS

IF !EMPTY(m.aplicacion) THEN
   PRIVATE m.string, m.sql_result, m.sql_resul2, m.sql_resul3, m.sql
   m.string = STRTRAN(m.aplicacion + "*", "*", "%")

   DO WHILE AT("%%", m.string) > 0
      m.string = STRTRAN(m.string, "%%", "%")
   ENDDO

   IF LEN(m.string) > 1 THEN
      WAIT "BUSCANDO..." WINDOW NOWAIT

      *-- BOB: Casa Central --*
      m.sql_result = CreaTemp()

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod a " + ;
                 "INTO TABLE " + m.sql_result + " " + ;
                 "WHERE aplicacion LIKE '" + m.string + "' " + ;
                 "ORDER BY nombre"
      &sql
      *-- EOB: Casa Central --*

      *-- BOB: Deposito --*
      m.sql_resul2 = CreaTemp()   && Deposito

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod2 a " + ;
                 "INTO TABLE " + m.sql_resul2 + " " + ;
                 "WHERE aplicacion LIKE '" + m.string + "' " + ;
                 "ORDER BY nombre"
      &sql

      SELECT (m.sql_resul2)
      SCAN ALL
         xrubro     = rubro
         xcodigo    = codigo
         xubicacion = ubicacion
         xnombre    = nombre
         xpventag1  = pventag1
         xstock     = stock
         xpventag2  = pventag2
         xpventag3  = pventag3
         xcodigo2   = codigo2
         xcodorig   = codorig

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xubicacion, xnombre, xpventag1, xstock, xpventag2, xpventag3, xcodigo2, xcodorig)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito --*

      *-- BOB: Deposito [All Parts SRL] --*
      m.sql_resul3 = CreaTemp()   && Deposito [All Parts SRL]

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod3 a " + ;
                 "INTO TABLE " + m.sql_resul3 + " " + ;
                 "WHERE aplicacion LIKE '" + m.string + "' " + ;
                 "ORDER BY nombre"
      &sql

      SELECT (m.sql_resul3)
      SCAN ALL
         xrubro     = rubro
         xcodigo    = codigo
         xubicacion = ubicacion
         xnombre    = nombre
         xpventag1  = pventag1
         xstock     = stock
         xpventag2  = pventag2
         xpventag3  = pventag3
         xcodigo2   = codigo2
         xcodorig   = codorig

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xubicacion, xnombre, xpventag1, xstock, xpventag2, xpventag3, xcodigo2, xcodorig)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito [All Parts SRL] --*
      
      *-- BOB: Sucursal [006] --*
IF pcPriorDir = 'INTEGRAD.006' THEN
      m.sql_resul4 = CreaTemp()

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod4 a " + ;
                 "INTO TABLE " + m.sql_resul4 + " " + ;
                 "WHERE aplicacion LIKE '" + m.string + "' " + ;
                 "ORDER BY nombre"
      &sql

      SELECT (m.sql_resul4)
      SCAN ALL
         xrubro     = rubro
         xcodigo    = codigo
         xubicacion = ubicacion
         xnombre    = nombre
         xpventag1  = pventag1
         xstock     = stock
         xpventag2  = pventag2
         xpventag3  = pventag3
         xcodigo2   = codigo2
         xcodorig   = codorig

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xubicacion, xnombre, xpventag1, xstock, xpventag2, xpventag3, xcodigo2, xcodorig)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
ENDIF
      *-- EOB: Sucursal [006] --*

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
   PRIVATE m.string, m.sql_result, m.sql_resul2, m.sql_resul3, m.sql
   m.string = STRTRAN(m.cod_origen + "*", "*", "%")

   DO WHILE AT("%%", m.string) > 0
      m.string = STRTRAN(m.string, "%%", "%")
   ENDDO

   IF LEN(m.string) > 1 THEN
      WAIT "BUSCANDO..." WINDOW NOWAIT

      *-- BOB: Casa Central --*
      m.sql_result = CreaTemp()

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod a " + ;
                 "INTO TABLE " + m.sql_result + " " + ;
                 "WHERE codorig LIKE '" + m.string + "' " + ;
                 "ORDER BY codorig"
      &sql
      *-- EOB: Casa Central --*

      *-- BOB: Deposito --*
      m.sql_resul2 = CreaTemp()   && Deposito

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod2 a " + ;
                 "INTO TABLE " + m.sql_resul2 + " " + ;
                 "WHERE codorig LIKE '" + m.string + "' " + ;
                 "ORDER BY codorig"
      &sql

      SELECT (m.sql_resul2)
      SCAN ALL
         xrubro     = rubro
         xcodigo    = codigo
         xubicacion = ubicacion
         xnombre    = nombre
         xpventag1  = pventag1
         xstock     = stock
         xpventag2  = pventag2
         xpventag3  = pventag3
         xcodigo2   = codigo2
         xcodorig   = codorig

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xubicacion, xnombre, xpventag1, xstock, xpventag2, xpventag3, xcodigo2, xcodorig)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito --*

      *-- BOB: Deposito [All Parts SRL] --*
      m.sql_resul3 = CreaTemp()   && Deposito [All Parts SRL]

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod3 a " + ;
                 "INTO TABLE " + m.sql_resul3 + " " + ;
                 "WHERE codorig LIKE '" + m.string + "' " + ;
                 "ORDER BY codorig"
      &sql

      SELECT (m.sql_resul3)
      SCAN ALL
         xrubro     = rubro
         xcodigo    = codigo
         xubicacion = ubicacion
         xnombre    = nombre
         xpventag1  = pventag1
         xstock     = stock
         xpventag2  = pventag2
         xpventag3  = pventag3
         xcodigo2   = codigo2
         xcodorig   = codorig

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xubicacion, xnombre, xpventag1, xstock, xpventag2, xpventag3, xcodigo2, xcodorig)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito [All Parts SRL] --*

      *-- BOB: Sucursal [006] --*
IF pcPriorDir = 'INTEGRAD.006' THEN
      m.sql_resul4 = CreaTemp()

      m.sql = "SELECT a.rubro, " + ; 
                 "a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod4 a " + ;
                 "INTO TABLE " + m.sql_resul4 + " " + ;
                 "WHERE codorig LIKE '" + m.string + "' " + ;
                   "AND a.stock_actu - a.stock_ot > 0 " + ;
                 "ORDER BY codorig"
      &sql

      SELECT (m.sql_resul4)
      SCAN ALL
         xrubro  = rubro
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
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xnombre, xpventag1, xstock, xpventag2, xpventag3)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
ENDIF
      *-- EOB: Sucursal [006] --*


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
   PRIVATE m.string, m.sql_result, m.sql_resul2, m.sql_resul3, m.sql
   m.string = STRTRAN(m.cod_altern + "*", "*", "%")

   DO WHILE AT("%%", m.string) > 0
      m.string = STRTRAN(m.string, "%%", "%")
   ENDDO

   IF LEN(m.string) > 1 THEN
      WAIT "BUSCANDO..." WINDOW NOWAIT

      *-- BOB: Casa Central --*
      m.sql_result = CreaTemp()

      m.sql = "SELECT a.rubro, " + ; 
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod a " + ;
                 "INTO TABLE " + m.sql_result + " " + ;
                 "WHERE codigo2 LIKE '" + m.string + "' " + ;
                 "ORDER BY codigo2"
      &sql
      *-- EOB: Casa Central --*

      *-- BOB: Deposito --*
      m.sql_resul2 = CreaTemp()   && Deposito

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod2 a " + ;
                 "INTO TABLE " + m.sql_resul2 + " " + ;
                 "WHERE codigo2 LIKE '" + m.string + "' " + ;
                 "ORDER BY codigo2"
      &sql

      SELECT (m.sql_resul2)
      SCAN ALL
         xrubro     = rubro
         xcodigo    = codigo
         xubicacion = ubicacion
         xnombre    = nombre
         xpventag1  = pventag1
         xstock     = stock
         xpventag2  = pventag2
         xpventag3  = pventag3
         xcodigo2   = codigo2
         xcodorig   = codorig

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xubicacion, xnombre, xpventag1, xstock, xpventag2, xpventag3, xcodigo2, xcodorig)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito --*

      *-- BOB: Deposito [All Parts SRL] --*
      m.sql_resul3 = CreaTemp()   && Deposito [All Parts SRL]

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod3 a " + ;
                 "INTO TABLE " + m.sql_resul3 + " " + ;
                 "WHERE codigo2 LIKE '" + m.string + "' " + ;
                 "ORDER BY codigo2"
      &sql

      SELECT (m.sql_resul3)
      SCAN ALL
         xrubro     = rubro
         xcodigo    = codigo
         xubicacion = ubicacion
         xnombre    = nombre
         xpventag1  = pventag1
         xstock     = stock
         xpventag2  = pventag2
         xpventag3  = pventag3
         xcodigo2   = codigo2
         xcodorig   = codorig

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xubicacion, xnombre, xpventag1, xstock, xpventag2, xpventag3, xcodigo2, xcodorig)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito [All Parts SRL] --*

      *-- BOB: Sucursal [006] --*
IF pcPriorDir = 'INTEGRAD.006' THEN
      m.sql_resul4 = CreaTemp()

      m.sql = "SELECT a.rubro, " + ; 
                 "a.codigo, a.nombre, ROUND(a.pventag1 * (1 + a.pimpuesto / 100), 0) AS pventag1, a.stock_actu - a.stock_ot AS stock, ROUND(a.pventag2 * (1 + a.pimpuesto / 100), 0) AS pventag2, ROUND(a.pventag3 * (1 + a.pimpuesto / 100), 0) AS pventag3 " + ;
                 "FROM maesprod4 a " + ;
                 "INTO TABLE " + m.sql_resul4 + " " + ;
                 "WHERE codigo2 LIKE '" + m.string + "' " + ;
                   "AND a.stock_actu - a.stock_ot > 0 " + ;
                 "ORDER BY codigo2"
      &sql
      
      SELECT (m.sql_resul4)
      SCAN ALL
         xrubro  = rubro
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
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xnombre, xpventag1, xstock, xpventag2, xpventag3)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
ENDIF
      *-- EOB: Sucursal [006] --*


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
PROCEDURE vldubicacion

SHOW GETS

IF !EMPTY(m.ubicacion) THEN
   PRIVATE m.string, m.sql_result, m.sql_resul2, m.sql_resul3, m.sql
   m.string = STRTRAN(m.ubicacion + "*", "*", "%")

   DO WHILE AT("%%", m.string) > 0
      m.string = STRTRAN(m.string, "%%", "%")
   ENDDO

   IF LEN(m.string) > 1 THEN
      WAIT "BUSCANDO..." WINDOW NOWAIT

      *-- BOB: Casa Central --*
      m.sql_result = CreaTemp()

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod a " + ;
                 "INTO TABLE " + m.sql_result + " " + ;
                 "WHERE ubicacion LIKE '" + m.string + "' " + ;
                 "ORDER BY nombre"
      &sql
      *-- EOB: Casa Central --*

      *-- BOB: Deposito --*
      m.sql_resul2 = CreaTemp()   && Deposito

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod2 a " + ;
                 "INTO TABLE " + m.sql_resul2 + " " + ;
                 "WHERE ubicacion LIKE '" + m.string + "' " + ;
                 "ORDER BY nombre"
      &sql

      SELECT (m.sql_resul2)
      SCAN ALL
         xrubro      = rubro
         xcodigo    = codigo
         xubicacion = ubicacion
         xnombre    = nombre
         xpventag1  = pventag1
         xstock     = stock
         xpventag2  = pventag2
         xpventag3  = pventag3
         xcodigo2   = codigo2
         xcodorig   = codorig

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xubicacion, xnombre, xpventag1, xstock, xpventag2, xpventag3, xcodigo2, xcodorig)
         ENDIF
      ENDSCAN

      SELECT (m.sql_result)
      GOTO TOP
      *-- EOB: Deposito --*

      *-- BOB: Deposito [All Parts SRL] --*
      m.sql_resul3 = CreaTemp()   && Deposito [All Parts SRL]

      m.sql = "SELECT a.rubro, " + ;
                 "a.codigo, a.ubicacion, a.nombre, ROUND(a.pventag1*(1+a.pimpuesto/100),0) AS pventag1, a.stock_actu-a.stock_ot AS stock, ROUND(a.pventag2*(1+a.pimpuesto/100),0) AS pventag2, ROUND(a.pventag3*(1+a.pimpuesto/100),0) AS pventag3, a.codigo2, a.codorig " + ;
                 "FROM maesprod3 a " + ;
                 "INTO TABLE " + m.sql_resul3 + " " + ;
                 "WHERE ubicacion LIKE '" + m.string + "' " + ;
                 "ORDER BY nombre"
      &sql

      SELECT (m.sql_resul3)
      SCAN ALL
         xrubro     = rubro
         xcodigo    = codigo
         xubicacion = ubicacion
         xnombre    = nombre
         xpventag1  = pventag1
         xstock     = stock
         xpventag2  = pventag2
         xpventag3  = pventag3
         xcodigo2   = codigo2
         xcodorig   = codorig

         SELECT (m.sql_result)
         LOCATE FOR codigo = xcodigo
         IF FOUND() THEN
            REPLACE stock WITH stock + xstock
         ELSE
            INSERT INTO (m.sql_result) VALUES (xrubro, xcodigo, xubicacion, xnombre, xpventag1, xstock, xpventag2, xpventag3, xcodigo2, xcodorig)
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
      FROM 06,00 ;
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

*!* ON KEY LABEL "F2" DO addProduct
ON KEY LABEL "F3" DO editProduct
ON KEY LABEL "F8" DO deleteProduct
ON KEY LABEL "CTRL+ENTER" DO maesinfo.spr
ON KEY LABEL "CTRL+HOME"  GO TOP
ON KEY LABEL "CTRL+END"   GO BOTTOM
ON KEY LABEL "SPACEBAR"   DO ver_stock2

BROWSE WINDOW busqueda FIELDS ;
   b0 = codigo :R:6:P = "@!" :H = "C¢digo",;
   b1 = ubicacion :R:9:P = "@!" :H = "Ubicacion",;
   b2 = LEFT(nombre, 40) :R:40:P = "@!" :H = "Descripci¢n",;
   b3 = pventag1 :R:10:P = "99,999,999" :H = " P.Vta. 1",;
   b4 = stock :R:7:P = "9999.99" :H = " Stock",;
   b5 = pventag2 :R:10:P = "99,999,999" :H = " P.Vta. 2",;
   b6 = pventag3 :R:10:P = "99,999,999" :H = " P.Vta. 3",;
   b7 = LEFT(nombre, 40) :R:40:P = "@!" :H = "Descripci¢n",;
   b8 = codigo2 :R:15:P = "@!" :H = "C¢d.Alternativo",;
   b9 = codorig :R:15:P = "@!" :H = "C¢d. Original";
   FONT "Courier New", 9 ;
   NOAPPEND NODELETE NOMODIFY

*!* ON KEY LABEL "F2"
ON KEY LABEL "F3"
ON KEY LABEL "F8"
ON KEY LABEL "CTRL+ENTER"
ON KEY LABEL "CTRL+HOME"
ON KEY LABEL "CTRL+END"
ON KEY LABEL "SPACEBAR"

IF !EMPTY(m.storeto) THEN
   ON KEY LABEL "ENTER"
   IF LASTKEY() <> 27 THEN
      &storeto = codigo
   ENDIF
ENDIF

RELEASE WINDOW busqueda

STORE " " TO m.codigo, m.nombre, m.aplicacion, m.cod_origen, m.cod_altern, m.ubicacion
SHOW GETS
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

*--------------------------------------------------------------------------*
PROCEDURE ver_stock

PRIVATE pcSys16, pcPriorDir, m.id_product, m.product_name, m.cen_stock, m.suc_stock, m.cen_ubicacion, m.suc_ubicacion
pcSys16 = SYS(16, 0)
pcPriorDir = SUBSTR(pcSys16, RAT("\", pcSys16, 2) + 1, RAT("\", pcSys16) - RAT("\", pcSys16, 2) - 1)

STORE codigo TO m.id_product
STORE 0 TO m.cen_stock, m.suc_stock, m.all_stock, m.all_precio
STORE "" TO m.cen_ubicacion, m.suc_ubicacion, m.all_ubicacion,  m.product_name, m.mensaje

IF INLIST(pcPriorDir, "INTEGRAD.000") THEN
   SELECT maesprod
   SET ORDER TO 1
   IF SEEK(m.id_product) THEN
      m.product_name = nombre
      m.cen_stock = stock_actu - stock_ot
      m.cen_ubicacion = ubicacion
   ENDIF

   SELECT maesprod2
   SET ORDER TO 1
   IF SEEK(m.id_product) THEN
      m.suc_stock = stock_actu - stock_ot
      m.suc_ubicacion = ubicacion
   ENDIF

   SELECT maesprod3
   SET ORDER TO 1
   IF SEEK(m.id_product) THEN
      m.all_stock = stock_actu - stock_ot
      m.all_ubicacion = ubicacion
      m.all_precio = ROUND(pventag3 * (1 + pimpuesto / 100), 0)
   ENDIF

   IF m.cen_stock <> 0 THEN
      m.mensaje = "CASA CENTRAL" + CHR(13) + ;
                  REPLICATE("~", 12) + CHR(13) + ;
                  "Stock: " + TRANSFORM(m.cen_stock, "9,999.99") + "    Ubicaci¢n: " + m.cen_ubicacion
   ENDIF

   IF m.suc_stock <> 0 THEN
      IF !EMPTY(m.mensaje) THEN
         m.mensaje = m.mensaje + CHR(13) + CHR(13)
      ENDIF

      m.mensaje = m.mensaje + ;
                  "DEPOSITO" + CHR(13) +;
                  REPLICATE("~", 8) + CHR(13) +;
                  "Stock: " + TRANSFORM(m.suc_stock, "9,999.99") + "    Ubicaci¢n: " + m.suc_ubicacion
   ENDIF

   IF m.all_stock <> 0 THEN
      IF !EMPTY(m.mensaje) THEN
         m.mensaje = m.mensaje + CHR(13) + CHR(13)
      ENDIF

      m.mensaje = m.mensaje + ;
                  "ALL PARTS" + CHR(13) +;
                  REPLICATE("~", 9) + CHR(13) +;
                  "Stock: " + TRANSFORM(m.all_stock, "9,999.99") + "    Prec. Dist.: " + ALLTRIM(TRANSFORM(m.all_precio, "999,999,999"))
   ENDIF

   IF EMPTY(m.mensaje) THEN
      m.mensaje = "Sin existencia"
   ELSE
*     IF m.cen_stock <> 0 AND m.suc_stock = 0 AND m.all_stock = 0 THEN
*        m.mensaje = 'Idem'
*     ELSE
         m.mensaje = "C¢digo: " + m.id_product + CHR(13) + ;
                     "Nombre: " + m.product_name + CHR(13) + ;
                     REPLICATE("Ä", 48) + CHR(13) + ;
                     m.mensaje
*     ENDIF
   ENDIF

   WAIT m.mensaje WINDOW

*!*	   WAIT "C¢digo: " + m.id_product + CHR(13) +;
*!*	        "Nombre: " + m.product_name + CHR(13) +;
*!*	        REPLICATE("Ä", 48) + CHR(13) +;
*!*	        "CASA CENTRAL" + CHR(13) +;
*!*	        REPLICATE("~", 12) + CHR(13) +;
*!*	        "Stock: " + TRANSFORM(m.cen_stock, "9,999.99") + "    Ubicaci¢n: " + m.cen_ubicacion + CHR(13) + CHR(13) +;
*!*	        "DEPOSITO" + CHR(13) +;
*!*	        REPLICATE("~", 8) + CHR(13) +;
*!*	        "Stock: " + TRANSFORM(m.suc_stock, "9,999.99") + "    Ubicaci¢n: " + m.suc_ubicacion + CHR(13) + CHR(13) +;
*!*	        "ALL PARTS" + CHR(13) +;
*!*	        REPLICATE("~", 9) + CHR(13) +;
*!*	        "Stock: " + TRANSFORM(m.all_stock, "9,999.99") + "    Ubicaci¢n: " + m.all_ubicacion WINDOW

ELSE
   SELECT maesprod
   SET ORDER TO 1
   SEEK m.id_product

   WAIT "STOCK ACTUAL: " + ALLTRIM(TRANSFORM(stock_actu - stock_ot, "9,999.99")) WINDOW
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE editProduct

PRIVATE lnWorkArea, product_id, m.codigo, m.ubicacion, m.nombre, m.pventag1, m.pventag2, m.pventag3, m.codigo2, m.codorig
lnWorkArea = SELECT()
product_id = codigo
STORE "" TO m.codigo, m.ubicacion, m.nombre, m.pventag1, m.pventag2, m.pventag3, m.codigo2, m.codorig

SELECT maesprod
SET ORDER TO 1
IF !SEEK(product_id) THEN
   WAIT "El producto: " + ALLTRIM(product_id) + " no existe." WINDOW
ENDIF

DO maesprod.prg WITH "Edit"

SELECT maesprod
SET ORDER TO 1
IF SEEK(product_id) THEN
   m.codigo    = codigo
   m.ubicacion = ubicacion
   m.nombre    = nombre
   m.pventag1  = ROUND(pventag1 * (1 + pimpuesto / 100), 0)
   m.pventag2  = ROUND(pventag2 * (1 + pimpuesto / 100), 0)
   m.pventag3  = ROUND(pventag3 * (1 + pimpuesto / 100), 0)
   m.codigo2   = codigo2
   m.codorig   = codorig
ELSE
   WAIT "El producto: " + ALLTRIM(product_id) + " no existe." WINDOW
ENDIF

IF .NOT. EMPTY(ALIAS(lnWorkArea)) THEN
   SELECT (lnWorkArea)
   REPLACE codigo    WITH m.codigo,;
           ubicacion WITH m.ubicacion,;
           nombre    WITH m.nombre,;
           pventag1  WITH m.pventag1,;
           pventag2  WITH m.pventag2,;
           pventag3  WITH m.pventag3,;
           codigo2   WITH m.codigo2,;
           codorig   WITH m.codorig
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE addProduct

IF .NOT. UserConfig("brwMaesp.prg", "Add", .T.)
   RETURN
ENDIF

PRIVATE lnWorkArea, product_id, m.codigo, m.ubicacion, m.nombre, m.pventag1, m.pventag2, m.pventag3, m.codigo2, m.codorig
lnWorkArea = SELECT()

DO maesprod.prg WITH "Add"

IF LASTKEY() <> 27 THEN
   SELECT maesprod
   SET ORDER TO 0
   GOTO BOTTOM

   product_id  = ALLTRIM(codigo)
   m.codigo    = codigo
   m.ubicacion = ubicacion
   m.nombre    = nombre
   m.pventag1  = ROUND(pventag1 * (1 + pimpuesto / 100), 0)
   m.pventag2  = ROUND(pventag2 * (1 + pimpuesto / 100), 0)
   m.pventag3  = ROUND(pventag3 * (1 + pimpuesto / 100), 0)
   m.codigo2   = codigo2
   m.codorig   = codorig

   SET ORDER TO 1

   IF WEXIST("busqueda") THEN
      SELECT (lnWorkArea)
      APPEND BLANK
      REPLACE codigo WITH m.codigo, ubicacion WITH m.ubicacion, nombre WITH m.nombre, pventag1 WITH m.pventag1, pventag2 WITH m.pventag2, pventag3 WITH m.pventag3, codigo2 WITH m.codigo2, codorig WITH m.codorig
   ELSE
      m.codigo = product_id
      DO vldcodigo
   ENDIF
ENDIF

IF .NOT. EMPTY(ALIAS(lnWorkArea)) THEN
   SELECT (lnWorkArea)
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE deleteProduct

PRIVATE lnWorkArea, product_id
lnWorkArea = SELECT()
product_id = codigo

SELECT maesprod
SET ORDER TO 1
IF !SEEK(product_id) THEN
   WAIT "El producto: " + ALLTRIM(product_id) + " no existe." WINDOW
ENDIF

DO maesprod.prg WITH "Delete"

SELECT maesprod
SET ORDER TO 1
IF !SEEK(product_id) THEN
   IF .NOT. EMPTY(ALIAS(lnWorkArea)) THEN
      SELECT (lnWorkArea)
      DELETE
   ENDIF
ENDIF

IF .NOT. EMPTY(ALIAS(lnWorkArea)) THEN
   SELECT (lnWorkArea)
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE ver_stock2

PUSH KEY CLEAR

PRIVATE pcSys16, pcPriorDir, m.id_product, m.product_name, m.cen_stock, m.suc_stock, m.cen_ubicacion, m.suc_ubicacion, ;
        m.cod_origen, m.cod_altern

pcSys16 = SYS(16, 0)
pcPriorDir = SUBSTR(pcSys16, RAT("\", pcSys16, 2) + 1, RAT("\", pcSys16) - RAT("\", pcSys16, 2) - 1)

STORE codigo TO m.id_product
STORE 0 TO m.cen_stock, m.suc_stock, m.all_stock, m.all_precio, m.suc2_stock
STORE "" TO m.cen_ubicacion, m.suc_ubicacion, m.all_ubicacion, m.product_name, m.mensaje, ;
            m.cod_origen, m.cod_altern

*IF INLIST(pcPriorDir, "INTEGRAD.000") THEN
   SELECT maesprod
   SET ORDER TO 1
   IF SEEK(m.id_product) THEN
      m.product_name = nombre
      m.cen_stock = stock_actu - stock_ot
      m.cen_ubicacion = ubicacion
      m.cod_origen = codorig
      m.cod_altern = codigo2
   ENDIF

   SELECT maesprod2
   SET ORDER TO 1
   IF SEEK(m.id_product) THEN
      m.suc_stock = stock_actu - stock_ot
      m.suc_ubicacion = ubicacion
   ENDIF

   SELECT maesprod3
   SET ORDER TO 1
   IF SEEK(m.id_product) THEN
      m.all_stock = stock_actu - stock_ot
      m.all_ubicacion = ubicacion
      m.all_precio = ROUND(pventag3 * (1 + pimpuesto / 100), 0)
   ENDIF

   IF USED('maesprod4') THEN
      SELECT maesprod4
      SET ORDER TO 1
      IF SEEK(m.id_product) THEN
         m.suc2_stock = stock_actu - stock_ot
         m.suc2_ubicacion = ubicacion
      ENDIF
   ENDIF

   IF m.cen_stock = 0 AND m.suc_stock = 0 AND m.all_stock = 0 AND m.suc2_stock = 0 THEN
      WAIT "Sin existencia" WINDOW NOWAIT
   ELSE
      * Crea la ventana donde se visualizará la información del stock.
      IF !WEXIST("winInfoStock") THEN
         DEFINE WINDOW winInfoStock ;
            FROM 01,00 ;
            TO 24,53 ;
            TITLE 'Informaci¢n del Art¡culo ³ ESC p/Cerrar' ;
            NOCLOSE ;
            NOFLOAT ;
            NOGROW ;
            NOMDI ;
            NOMINIMIZE ;
            NOSHADOW ;
            NOZOOM  ;
            COLOR W+/BG,GR+/RB,GR+/B,GR+/B,,,GR+/RB
      ENDIF

      * Crea un cursor para guardar la información del stock.
      CREATE CURSOR InfoStock ( ;
         Registro C(50) ;
      )

      * Datos Generales.
      INSERT INTO InfoStock VALUES ("C¢digo: " + m.id_product)
      INSERT INTO InfoStock VALUES ("Nombre: " + m.product_name)
      INSERT INTO InfoStock VALUES ("")
      INSERT INTO InfoStock VALUES ("C¢digo Original...: " + m.cod_origen)
      INSERT INTO InfoStock VALUES ("C¢digo Alternativo: " + m.cod_altern)
      INSERT INTO InfoStock VALUES (REPLICATE("Ä", 48))
      INSERT INTO InfoStock VALUES ("Local             Stock          Ubicaci¢n")
      INSERT INTO InfoStock VALUES (REPLICATE("Ä", 48))
      * Stock de la Casa Central.
      IF pcPriorDir = 'INTEGRAD.006' THEN
         IF m.suc2_stock <> 0 THEN
            INSERT INTO InfoStock VALUES ("CASA CENTRAL" + SPACE(3) + IIF(RIGHT(TRANSFORM(m.suc2_stock, "9,999.99"), 2) = '00', SPACE(3) + TRANSFORM(m.suc2_stock, "9,999"), TRANSFORM(m.suc2_stock, "9,999.99")) + SPACE(10) + m.suc2_ubicacion)
         ENDIF
      ELSE
         IF m.cen_stock <> 0 THEN
            INSERT INTO InfoStock VALUES ("CASA CENTRAL" + SPACE(3) + IIF(RIGHT(TRANSFORM(m.cen_stock, "9,999.99"), 2) = '00', SPACE(3) + TRANSFORM(m.cen_stock, "9,999"), TRANSFORM(m.cen_stock, "9,999.99")) + SPACE(10) + m.cen_ubicacion)
   *!*	         INSERT INTO InfoStock VALUES ("CASA CENTRAL")
   *!*	         INSERT INTO InfoStock VALUES (REPLICATE("~", 12))
   *!*	         INSERT INTO InfoStock VALUES ("Stock: " + TRANSFORM(m.cen_stock, "9,999.99") + "    Ubicaci¢n: " + m.cen_ubicacion)
         ENDIF
      ENDIF

      * Stock del Tinglado.
      IF m.suc_stock <> 0 THEN
         INSERT INTO InfoStock VALUES ("DEPOSITO" + SPACE(7) + IIF(RIGHT(TRANSFORM(m.suc_stock, "9,999.99"), 2) = '00', SPACE(3) + TRANSFORM(m.suc_stock, "9,999"), TRANSFORM(m.suc_stock, "9,999.99"))+ SPACE(10) + m.suc_ubicacion)
*!*	         INSERT INTO InfoStock VALUES ("DEPOSITO")
*!*	         INSERT INTO InfoStock VALUES (REPLICATE("~", 8))
*!*	         INSERT INTO InfoStock VALUES ("Stock: " + TRANSFORM(m.suc_stock, "9,999.99") + "    Ubicaci¢n: " + m.suc_ubicacion)
      ENDIF

      * Stock de All Parts SRL
      IF m.all_stock <> 0 THEN
         INSERT INTO InfoStock VALUES ("ALL PARTS" + SPACE(6) + IIF(RIGHT(TRANSFORM(m.all_stock, "9,999.99"), 2) = '00', SPACE(3) + TRANSFORM(m.all_stock, "9,999"), TRANSFORM(m.all_stock, "9,999.99")) + SPACE(5) + "Prec. Dist.: " + ALLTRIM(TRANSFORM(m.all_precio, "999,999,999")))
*!*	         INSERT INTO InfoStock VALUES ("ALL PARTS")
*!*	         INSERT INTO InfoStock VALUES (REPLICATE("~", 9))
*!*	         INSERT INTO InfoStock VALUES ("Stock: " + TRANSFORM(m.all_stock, "9,999.99") + "    Prec. Dist.: " + ALLTRIM(TRANSFORM(m.all_precio, "999,999,999")))
      ENDIF

      IF pcPriorDir = 'INTEGRAD.006' THEN
         IF m.cen_stock <> 0 THEN
            INSERT INTO InfoStock VALUES ("SUC. E. AYALA" + SPACE(2) + IIF(RIGHT(TRANSFORM(m.cen_stock, "9,999.99"), 2) = '00', SPACE(3) + TRANSFORM(m.cen_stock, "9,999"), TRANSFORM(m.cen_stock, "9,999.99"))+ SPACE(10) + m.cen_ubicacion)
   *!*	         INSERT INTO InfoStock VALUES ("ALL PARTS")
   *!*	         INSERT INTO InfoStock VALUES (REPLICATE("~", 9))
   *!*	         INSERT INTO InfoStock VALUES ("Stock: " + TRANSFORM(m.all_stock, "9,999.99") + "    Prec. Dist.: " + ALLTRIM(TRANSFORM(m.all_precio, "999,999,999")))
         ENDIF
      ENDIF

      tmPediArti = createmp()

      SELECT * FROM PediArti WHERE Articulo LIKE m.id_product INTO TABLE (tmPediArti)

      SELECT (tmPediArti)
      IF RECCOUNT() > 0 THEN
         INSERT INTO InfoStock VALUES ("")
*         INSERT INTO InfoStock VALUES (REPLICATE(CHR(196), 48))
         INSERT INTO InfoStock VALUES (PADC("********************", 48, ' '))
         INSERT INTO InfoStock VALUES (PADC("*** COMPROMETIDO ***", 48, ' '))
         INSERT INTO InfoStock VALUES (PADC("********************", 48, ' '))
         INSERT INTO InfoStock VALUES ("")
*         INSERT INTO InfoStock VALUES (REPLICATE("#", 48))

         PRIVATE pnStock, pnNroPedido, pnCantidad
         pnStock = m.cen_stock + m.suc_stock + m.all_stock

         SCAN ALL
            pnNroPedido = nropedido
            pnCantidad  = cantidad

            IF pnStock < pnCantidad THEN
               pnCantidad = pnStock
            ENDIF

            pnStock = pnStock - pnCantidad

            IF pnCantidad <> 0 THEN
               INSERT INTO InfoStock VALUES ("Pedido N§: " + TRANSFORM(pnNroPedido, "99,999,999") + SPACE(8) + 'Cantidad: ' + IIF(RIGHT(TRANSFORM(pnCantidad, "9,999.99"), 2) = '00', SPACE(3) + TRANSFORM(pnCantidad, "9,999"), TRANSFORM(pnCantidad, "9,999.99")))
            ENDIF
         ENDSCAN
      ENDIF

      SELECT (tmPediArti)
      USE

      SELECT InfoStock
      GOTO TOP

      BROWSE WINDOW winInfoStock FIELDS ;
         campo = LEFT(Registro, 50) :R:50:H = "";
         NOAPPEND NODELETE NOMODIFY

      SELECT InfoStock
      USE

      RELEASE WINDOW winInfoStock

   ENDIF
   
*!*	ELSE
*!*	   SELECT maesprod
*!*	   SET ORDER TO 1
*!*	   SEEK m.id_product

*!*	   WAIT "STOCK ACTUAL: " + ALLTRIM(TRANSFORM(stock_actu - stock_ot, "9,999.99")) WINDOW
*ENDIF

POP KEY