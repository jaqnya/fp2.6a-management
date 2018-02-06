PARAMETER m.storeto

PRIVATE m.select, m.codigo, m.nombre

STORE  0  TO m.codigo
STORE " " TO m.nombre, m.select

DO load
DO init

@ 01,00 TO 04,79 COLOR GR+/B
DO center WITH 1, "[ BUSCAR MARCA ]", "GR+/B"

@ 02,02 SAY "Nombre:" COLOR BG+/B
@ 03,02 SAY "C¢digo:" COLOR BG+/B

@ 02,10 GET m.nombre PICTURE "@!T" DEFAULT " " SIZE 1,43 VALID vldnombre()
@ 03,10 GET m.codigo PICTURE "99999" DEFAULT 0 SIZE 1,5 VALID vldcodigo()

@ 00,00 TO 00,79 " " COLOR N/W
DO center WITH 0, " A & A IMPORTACIONES S.R.L. ", "N/W"
@ 05,00,23,79 BOX REPLICATE(CHR(178), 8) + CHR(178)
@ 05,00 FILL TO 23,79 COLOR BG/B
@ 24,00 TO 24,79 " " COLOR N/W

IF !WVISIBLE("busc_marca") THEN
   ACTIVATE WINDOW busc_marca
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

IF !USED("marcas1") THEN
   USE marcas1 IN 0 AGAIN SHARED
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE unload

IF !EMPTY(ALIAS(m.select)) THEN
   SELECT (m.select)
ENDIF

RELEASE WINDOW busc_marca
POP KEY

*--------------------------------------------------------------------------*
PROCEDURE init

SET COLOR OF SCHEME 1 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,,R+/B,+

IF !WEXIST("busc_marca") THEN
   DEFINE WINDOW busc_marca ;
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

IF WVISIBLE("busc_marca") THEN
   ACTIVATE WINDOW busc_marca SAME
ELSE
   ACTIVATE WINDOW busc_marca NOSHOW
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
   
   DO WHILE AT("%%", m.string) > 0
      m.string = STRTRAN(m.string, "%%", "%")
   ENDDO
   
   IF LEN(m.string) > 1 THEN
      WAIT "BUSCANDO..." WINDOW NOWAIT
      
      m.sql = "SELECT codigo, nombre " + ;
                 "FROM marcas1 " + ;
                 "INTO TABLE " + m.sql_result + " " + ;
                 "WHERE nombre LIKE '" + m.string + "' " + ;
                 "ORDER BY nombre"
      &sql
      
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
   PRIVATE m.sql_result, m.sql

   m.sql_result = createmp()
   
   WAIT "BUSCANDO..." WINDOW NOWAIT
      
   m.sql = "SELECT codigo, nombre " + ;
              "FROM marcas1 " + ;
              "INTO TABLE " + m.sql_result + " " + ;
              "WHERE codigo = " + ALLTRIM(STR(m.codigo)) + " " + ;
              "ORDER BY codigo"
   &sql
      
   WAIT CLEAR
      
   IF RECCOUNT() > 0 THEN
      DO show_result
   ELSE
      WAIT "EL DATO BUSCADO NO HA SIDO ENCONTRADO !" WINDOW
      DO del_result
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

@ 24,01 SAY IIF(EMPTY(m.storeto), "ESC=Realiza nueva b£squeda", "ENTER=Selecciona el registro actual  ³  ESC=Realiza nueva b£squeda") COLOR N/W

IF !EMPTY(m.storeto) THEN
   ON KEY LABEL "ENTER" KEYBOARD "{CTRL+W}"
ENDIF

BROWSE WINDOW busqueda FIELDS ;
   b1 = TRANSFORM(codigo, "999999") :R:6:P = "999999" :H = "C¢digo",;
   b2 = LEFT(nombre, 30) :R:30:P = "@!" :H = "Nombre";
   FONT "Courier New", 9 ;
   NOAPPEND NODELETE NOMODIFY

*  b3 = LEFT(ruc, 12) :R:12:P = "@!" :H = "R.U.C.",;
*  b4 = LEFT(cedula,10) :R:10:P = "@!" :H = "Cedula";

IF !EMPTY(m.storeto) THEN
   ON KEY LABEL "ENTER"
   IF LASTKEY() <> 27 THEN
      &storeto = codigo
   ENDIF
ENDIF

RELEASE WINDOW busqueda

STORE "" TO m.nombre
STORE 0 TO m.codigo
_CUROBJ = OBJNUM(m.nombre)

@ 24,00 TO 24,79 " " COLOR N/W

IF !EMPTY(m.storeto) THEN
   IF LASTKEY() <> 27 THEN
      RELEASE WINDOW busc_marca
   ENDIF
ENDIF

DO del_result

*--------------------------------------------------------------------------*
PROCEDURE del_result
SELECT &sql_result
USE
DO borratemp WITH m.sql_result
