PRIVATE m.append, m.archi_01, m.archi_02, m.sql

STORE "" TO m.append, m.sql
STORE createmp() TO m.archi_01
STORE "tm" + RIGHT(SYS(2015), 6) TO m.archi_02

DO load
DO init

ON KEY LABEL "F2" DO maesprod.prg WITH "Add"
ON KEY LABEL "F3" DO maesprod.prg WITH "Edit"
ON KEY LABEL "F4" DO orden02.spr
ON KEY LABEL "F5" DO _Switch
ON KEY LABEL "F8" DO maesprod.prg WITH "Delete"
ON KEY LABEL "CTRL+ENTER" DO maesinfo.spr
ON KEY LABEL "CTRL+HOME"  GO TOP
ON KEY LABEL "CTRL+END"   GO BOTTOM
ON KEY LABEL "SPACEBAR"   DO ver_stock

DO HelpBar.spr
DO _PrintHelpBar

SELECT (m.archi_01)
SET ORDER TO 2
GOTO TOP

BROWSE WINDOW brwMaesprod FIELDS ;
   calc_f1  = LEFT(codigo, 7)                            :R:07:H = "C¢digo" ,;
   calc_f2  = LEFT(ubicacion, 6)                         :R:06:H = "Ubicac" ,;  
   calc_f3  = LEFT(nombre, 40)                           :R:39:H = "Nombre" ,;
   calc_f4  = ROUND(pventag1 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 1 c/Iva":P = "9,999,999,999" ,;
   calc_f5  = stock_actu - stock_ot                      :R:07:H = " Stock ":P = "9999.99" ,;  
   calc_f6  = ROUND(pventag2 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 2 c/Iva":P = "9,999,999,999" ,;
   calc_f7  = ROUND(pventag3 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 3 c/Iva":P = "9,999,999,999" ,;
   calc_f8  = IIF(impuesto, "   S¡   ", "")              :R:08:H = "Impuesto" ,;
   calc_f9  = LEFT(nombre, 40)                           :R:40:H = "Nombre" ,;
   calc_f10 = LEFT(codigo2, 15)                          :R:15:H = "C¢d.Alternativo" ,;
   calc_f11 = LEFT(codorig, 15)                          :R:15:H = "C¢d. Origen" ;
   NOAPPEND NODELETE NOMODIFY

ON KEY LABEL "F2" 
ON KEY LABEL "F3" 
ON KEY LABEL "F4"
ON KEY LABEL "F5"
ON KEY LABEL "F8" 
ON KEY LABEL "CTRL+ENTER"
ON KEY LABEL "CTRL+HOME" 
ON KEY LABEL "CTRL+END"  
ON KEY LABEL "SPACEBAR" 

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

IF !USED("familias") THEN
   USE familias IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("maesprod") THEN
   USE maesprod IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("maesprod2") THEN
   USE SYS(5) + "\turtle\aya\integrad.001\maesprod" IN 0 AGAIN ORDER 1 SHARED ALIAS maesprod2
ENDIF

IF !USED("marcas1") THEN
   USE marcas1 IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("proceden") THEN
   USE proceden IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("proveedo") THEN
   USE proveedo IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("rubros1") THEN
   USE rubros1 IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("rubros2") THEN
   USE rubros2 IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("unidad") THEN
   USE unidad IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("unidad") THEN
   USE unidad IN 0 AGAIN ORDER 1 SHARED
ENDIF

m.sql = "SELECT * FROM maesprod INTO TABLE " + m.archi_01 + " ORDER BY nombre"
&sql
m.sql = "SELECT * FROM maesprod2 INTO TABLE " + m.archi_02 + " WHERE stock_actu - stock_ot <> 0 ORDER BY nombre"
&sql

SELECT (m.archi_02)
SCAN ALL
   SCATTER MEMVAR MEMO

   SELECT (m.archi_01)
   LOCATE FOR codigo = m.codigo
   IF FOUND() THEN
      REPLACE stock_actu WITH stock_actu + (m.stock_actu - m.stock_ot)
   ELSE
      INSERT INTO (m.archi_01) FROM MEMVAR
   ENDIF
ENDSCAN

SELECT (m.archi_01)
INDEX ON codigo      TAG indice1
INDEX ON nombre      TAG indice2
INDEX ON rubro       TAG indice3
INDEX ON subrubro    TAG indice4
INDEX ON marca       TAG indice5
INDEX ON codigo2     TAG indice6
INDEX ON codorig     TAG indice7
INDEX ON VAL(codigo) TAG indice8
INDEX ON familia     TAG indice9
INDEX ON nombre      TAG indice10 FOR vigente 
INDEX ON codigo      TAG indice11 FOR vigente 
INDEX ON codigo2     TAG indice12 FOR vigente 
INDEX ON codorig     TAG indice13 FOR vigente
INDEX ON ubicacion   TAG indice14

*--------------------------------------------------------------------------*
PROCEDURE unload

IF USED("familias") THEN
   SELECT familias
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

IF USED("proceden") THEN
   SELECT proceden
*   USE
ENDIF

IF USED("proveedo") THEN
   SELECT proveedo
*   USE
ENDIF

IF USED("rubros1") THEN
   SELECT rubros1
*   USE
ENDIF

IF USED("rubros2") THEN
   SELECT rubros2
*   USE
ENDIF

IF USED("unidad") THEN
   SELECT unidad
*   USE
ENDIF

IF USED("unidad") THEN
   SELECT unidad
*   USE
ENDIF

SELECT &archi_01
USE
DO borratemp WITH m.archi_01

SELECT &archi_02
USE
DO borratemp WITH m.archi_02

RELEASE WINDOW brwMaesprod

*--------------------------------------------------------------------------*
PROCEDURE init

IF !WEXIST("brwMaesprod") THEN
   DEFINE WINDOW brwMaesprod ;
      FROM 01,00 ;
      TO   23,79 ;
      TITLE "< ARTICULOS >" ;
      SYSTEM ;
      CLOSE ;
      FLOAT ;
      GROW ;
      MDI ;         
      NOMINIMIZE ;
      SHADOW ;
      ZOOM ;
      COLOR SCHEME 15
ENDIF

IF WVISIBLE("brwMaesprod") THEN
   ACTIVATE WINDOW brwMaesprod SAME
ELSE
   ACTIVATE WINDOW brwMaesprod NOSHOW
ENDIF

*!**************************************************************************
*!
*!  Procedimiento: _Switch        
*!
*!    Llamado por: BRWMAESP.PRG                  
*!
*!    Descripci¢n: Selecciona cual de las ventanas de b£squeda va a presen-
*!                 tarle al usuario.
*! 
*!**************************************************************************
PROCEDURE _Switch

PUSH KEY CLEAR

IF EOF()
   DO WHILE .T.
      WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
      IF UPPER(pcAppend) = "S"
         DO maesprod.prg WITH "Add"
         EXIT DO
      ENDIF
      IF UPPER(pcAppend) = "N"
         EXIT DO
      ENDIF
   ENDDO    
   POP KEY
   RETURN
ENDIF

DO CASE
   CASE LOWER(TAG()) == "indice1"
      DO buscar04.spr
   CASE LOWER(TAG()) == "indice2"
      DO buscar05.spr
   CASE LOWER(TAG()) == "indice6"
      DO buscar06.spr
   CASE LOWER(TAG()) == "indice7"
      DO buscar07.spr
   CASE LOWER(TAG()) == "indice14"
      DO buscar30.spr
ENDCASE

POP KEY

*!**************************************************************************
*!
*!      FUNCION: _PrintHelpBar
*!
*!  DESCRIPCION: Imprime la barra de ayuda.
*!
*!**************************************************************************
FUNCTION _PrintHelpBar

*-- Impresiones predeterminadas.
@ 00,00 SAY "1       2       3       4       5       6       7       8       9       10" ;
   SIZE 1,74 ;
   COLOR W/N

*-- F1
@ 00,01 SAY "" ;
   SIZE 1,6 ;
   COLOR N/W

@ 00,25 SAY "Ordena" ;
   SIZE 1,6 ;
   COLOR N/W

@ 00,33 SAY "Busca" ;
   SIZE 1,6 ;
   COLOR N/W

*-- F6
@ 00,41 SAY "" ;
   SIZE 1,6 ;
   COLOR N/W

*-- F7
@ 00,49 SAY "" ;
   SIZE 1,6 ;
   COLOR N/W

*-- F9
@ 00,65 SAY "" ;
   SIZE 1,6 ;
   COLOR N/W

*-- F10
@ 00,74 SAY "" ;
   SIZE 1,6 ;
   COLOR N/W

*-- Verifica e imprime la etiqueta de las teclas que est n habilitadas.
IF UserConfig("brwMaesp.prg", "Add", .F.)
   @ 00,09 SAY "Agrega" ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 00,09 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF

IF UserConfig("brwMaesp.prg", "Edit", .F.)
   @ 00,17 SAY "Modif." ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 00,17 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF

IF UserConfig("brwMaesp.prg", "Delete", .F.)
   @ 00,57 SAY "Borra" ;
      SIZE 1,6 ;
      COLOR N/W
ELSE
   @ 00,57 SAY REPLICATE(CHR(32), 6) ;
      SIZE 1,6 ;
      COLOR W/W
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE ver_ofertas

SELECT maesprod
REPLACE paumento1 WITH 0 ALL

SELECT cabeofer
SET ORDER TO 1
SCAN FOR fecha_fin >= DATE()
   IF lista = 1 THEN
      SELECT detaofer
      SET ORDER TO 1
      IF SEEK(cabeofer.id_oferta) THEN
         SCAN WHILE id_oferta = cabeofer.id_oferta
            SELECT maesprod
            SET ORDER TO 1
            IF SEEK(detaofer.articulo) THEN
               REPLACE paumento1 WITH cabeofer.porcdesc
            ELSE
               WAIT "ERROR, EL ARTICULO " + ALLTRIM(detaofer.articulo) + " NO HA SIDO ENCONTRADO !"
            ENDIF
         ENDSCAN
      ENDIF
   ENDIF
ENDSCAN

*--------------------------------------------------------------------------*
PROCEDURE oferta

PUSH KEY CLEAR

IF paumento1 > 0 THEN
   WAIT WINDOW "PRECIO DE OFERTA: " + ALLTRIM(TRANSFORM(ROUND(pventag1 * (1 + pimpuesto / 100), 0) - ROUND(ROUND(pventag1 * (1 + pimpuesto / 100), 0) * paumento1 / 100, 0), "999,999,999")) NOWAIT
ENDIF

POP KEY

*--------------------------------------------------------------------------*
PROCEDURE ver_stock

PRIVATE pcSys16, pcPriorDir
pcSys16 = SYS(16, 0)
pcPriorDir = SUBSTR(pcSys16, RAT("\", pcSys16, 2) + 1, RAT("\", pcSys16) - RAT("\", pcSys16, 2) - 1)

IF INLIST(pcPriorDir, "INTEGRAD.000") THEN
   *
   * Abre el archivo de la sucursal
   *
   USE SYS(5) + "\turtle\aya\integrad.001\maesprod" IN 0 ORDER 1 SHARED ALIAS maesprod2

   SELECT maesprod2
   SET ORDER TO 1
   IF SEEK(maesprod.codigo) THEN
      m.stock_sucursal = stock_actu - stock_ot
      m.ubicacion = ubicacion
   ELSE
      m.stock_sucursal = 0
      m.ubicacion = ""
   ENDIF

   SELECT maesprod2
   USE
   *
   * Muestra el Stock del Articulo
   *
   SELECT maesprod
   WAIT "C¢digo: " + maesprod.codigo + CHR(13) +;
        "Nombre: " + maesprod.nombre + CHR(13) +;
        REPLICATE("Ä", 48) + CHR(13) +;
        "CASA CENTRAL" + CHR(13) +;
        REPLICATE("~", 12) + CHR(13) +;
        "Stock:" + TRANSFORM(maesprod.stock_actu - maesprod.stock_ot, "9,999.99") + "    Ubicaci¢n: " + maesprod.ubicacion + CHR(13) + CHR(13) +;
        "DEPOSITO" + CHR(13) +;
        REPLICATE("~", 8) + CHR(13) +;
        "Stock:" + TRANSFORM(m.stock_sucursal, "9,999.99") + "    Ubicaci¢n: " + m.ubicacion WINDOW
ELSE
   WAIT "STOCK ACTUAL: " + ALLTRIM(TRANSFORM(stock_actu - stock_ot, "9,999.99")) WINDOW
ENDIF

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