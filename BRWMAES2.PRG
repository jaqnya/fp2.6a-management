*:**************************************************************************
*:
*: Archivo de Procedimiento: BRWMAESP.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Vista hoja de datos para Art¡culos.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/04/2004
*:
*:**************************************************************************
*-- Variables para c lculos del programa.
PRIVATE pcAppend

cCriteria = BuildExpr()

*-- MS-DOS Definiciones de ventanas.
IF .NOT. WEXIST("brwMaesprod")
   DEFINE WINDOW brwMaesprod ;
      FROM 01,00 ;
      TO   23,79 ;
      TITLE "< LISTA DE PRECIOS DE VENTA DE ARTICULOS VIGENTES >" ;
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

SELECT maesprod
SET ORDER TO indice10 OF maesprod.cdx
GO TOP

*-- Estable relaciones entre las tablas.
SET RELATION TO maesprod.familia    INTO familias ADDITIVE   
SET RELATION TO maesprod.rubro      INTO rubros1  ADDITIVE   
SET RELATION TO maesprod.subrubro   INTO rubros2  ADDITIVE   
SET RELATION TO maesprod.marca      INTO marcas1  ADDITIVE   
SET RELATION TO maesprod.unidad     INTO unidad   ADDITIVE   
SET RELATION TO maesprod.procedenci INTO proceden ADDITIVE   
SET RELATION TO maesprod.proveedor  INTO proveedo ADDITIVE
               
*-- MS-DOS Macros de teclado.
ON KEY LABEL "F2" DO maesprod.prg WITH "Add"
ON KEY LABEL "F3" DO maesprod.prg WITH "Edit"
ON KEY LABEL "F4" DO orden02a.spr
ON KEY LABEL "F5" DO _Switch
ON KEY LABEL "F9" DO stock
ON KEY LABEL "F10" DO filter01.spr
ON KEY LABEL "F8" DO maesprod.prg WITH "Delete"
ON KEY LABEL "CTRL+ENTER" DO maesinf1.spr
ON KEY LABEL "CTRL+HOME"  GO TOP
ON KEY LABEL "CTRL+END"   GO BOTTOM
ON KEY LABEL "SPACEBAR"   WAIT WINDOW "STOCK ACTUAL: " + TRANSFORM(stock_actu - stock_ot, "9,999.99")

DO HelpBar.spr
DO _PrintHelpBar


IF .NOT. EMPTY(cCriteria)
   SET FILTER TO &cCriteria
ENDIF   

BROWSE WINDOW brwMaesprod FIELDS ;
   calc_f1  = LEFT(codigo, 7)                            :R:07:H = "C¢digo" ,;
   calc_f15 = LEFT(ubicacion, 6)                         :R:06:H = "Ubicac" ,;  
   calc_f2  = LEFT(nombre, 37)                           :R:37:H = "Nombre" ,;
   calc_f3  = IIF(impuesto, "S", "")                     :R:01:H = "",;
   calc_f4 = ROUND(pventag1 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 1 c/Iva":P = "9,999,999,999" ,;
   calc_f14 = stock_actu - stock_ot                      :R:07:H = " Stock ":P = "9999.99" ,;  
   calc_f5 = ROUND(pventag2 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 2 c/Iva":P = "9,999,999,999" ,;
   calc_f7 = IIF(impuesto, "   S¡   ", "")              :R:08:H = "Impuesto" ,;
   calc_f11 = LEFT(nombre, 40)                          :R:40:H = "Nombre" ,;
   calc_f12 = LEFT(codigo2, 15)                         :R:15:H = "C¢d.Alternativo" ,;
   calc_f13 = LEFT(codorig, 15)                         :R:15:H = "C¢d. Origen" ;
   NOAPPEND NODELETE NOMODIFY


*BROWSE WINDOW brwMaesprod FIELDS ;
*   calc_f1 = SUBSTR(codigo, 1, 9)                       :R:09:H = "C¢digo" ,;
*   calc_f2 = SUBSTR(nombre, 1, 39)                      :R:39:H = "Nombre" ,;
*   calc_f3 = IIF(impuesto, "S", "")                     :R:01:H = "",;
*   pventag1                                             :R:10:H = "P.Vta 1":P = "99,999,999" ,;
*   calc_f4 = ROUND(pventag1 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 1 c/Iva":P = "9,999,999,999" ,;
*   pventag2                                             :R:10:H = "P.Vta 2":P = "99,999,999" ,;
*   calc_f5 = ROUND(pventag2 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 2 c/Iva":P = "9,999,999,999" ,;
*   calc_f7 = IIF(impuesto, "   S¡   ", "")              :R:08:H = "Impuesto" ,;
*   stock_actu                                           :R:13:H = "Stock Actual":P = "99,999,999.99" ,;  
*   calc_f8  = SUBSTR(rubros1.nombre, 1, 30)             :R:30:H = "Rubro" ,;
*   calc_f9  = SUBSTR(rubros2.nombre, 1, 30)             :R:30:H = "Sub-Rubro",;   
*   calc_f10 = SUBSTR(marcas1.nombre, 1, 30)             :R:30:H = "Marcas",;      
*   calc_f11 = SUBSTR(nombre, 1, 40)                     :R:40:H = "Nombre" ,;
*   calc_f12 = SUBSTR(codigo2, 1, 15)                    :R:15:H = "C¢d.Alternativo" ,;
*   calc_f13 = SUBSTR(codorig, 1, 15)                    :R:15:H = "C¢d. Origen" ;
*   NOAPPEND NODELETE NOMODIFY


SET FILTER TO

SET ORDER TO indice1 OF maesprod.cdx

*-- Quiebra las relaciones entre las tablas.
SET RELATION OFF INTO familias
SET RELATION OFF INTO rubros1 
SET RELATION OFF INTO rubros2 
SET RELATION OFF INTO marcas1 
SET RELATION OFF INTO unidad  
SET RELATION OFF INTO proceden
SET RELATION OFF INTO proveedo
   
*-- MS-DOS Restablece macros de teclado.
ON KEY LABEL "F2" 
ON KEY LABEL "F3" 
ON KEY LABEL "F4"
ON KEY LABEL "F5"
ON KEY LABEL "F10" 
ON KEY LABEL "F8" 
ON KEY LABEL "F9" 
ON KEY LABEL "CTRL+ENTER"
ON KEY LABEL "CTRL+HOME" 
ON KEY LABEL "CTRL+END"  
ON KEY LABEL "SPACEBAR" 

RELEASE WINDOW 
IF WEXIST("brwMaesprod")
   RELEASE WINDOW brwMaesprod
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
   CASE LOWER(TAG()) == "indice11"
      DO buscar04.spr
   CASE LOWER(TAG()) == "indice10"
      DO buscar05.spr
   CASE LOWER(TAG()) == "indice12"
      DO buscar06.spr
   CASE LOWER(TAG()) == "indice13"
      DO buscar07.spr
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
@ 00,74 SAY "Filtro" ;
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

*
* BUILDEXPR - Construir la expresion que se utilizara como filtro.
*
FUNCTION BuildExpr

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder, nRecNo
nSelect = SELECT()
cOrder  = ORDER()
nRecNo  = IIF(EOF(), 0, RECNO())

IF USED("filter01")
   SELECT filter01
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("filter01.dbf", "DBF", "¨ D¢nde est  FILTER01.DBF ?")) ;
      AGAIN ALIAS filter01 SHARED ;
      ORDER 0
ENDIF

cExpression = ""

SCAN FOR filter01.tabla = "rubros1.dbf"
   IF EMPTY(cExpression)
      cExpression = "rubro = " + ALLTRIM(STR(codigo, 4))
   ELSE
      cExpression = cExpression + " .OR. rubro = " + ALLTRIM(STR(codigo, 4))
   ENDIF      
ENDSCAN

IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

IF EMPTY(cExpression)
   RETURN ""
ELSE
   RETURN (cExpression)
ENDIF


PROCEDURE stock

IF .NOT. WEXIST("brwAlmacen")
   DEFINE WINDOW brwAlmacen ;
      FROM 01,00 ;
      TO   23,79 ;
      TITLE "< Saldo de Art¡culos en Unidades por Almac‚n >" ;
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

IF USED("stock")
   SELECT detacob 
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("stock.dbf", "DBF", "¨ D¢nde est  STOCK.DBF ?")) ;
      AGAIN ALIAS stock SHARED ;
      ORDER 0
ENDIF

SELECT stock
SET RELATION OFF INTO almacen
SET RELATION TO stock.codigo INTO almacen

BROWSE WINDOW brwAlmacen FIELDS ;
   calc_f1 = almacen.nombre                :R:20:H = "Almac‚n" ;
   NOAPPEND NODELETE NOMODIFY FOR maesprod.codigo = stock.codigo
   
RELEASE WINDOW brwalmacen
