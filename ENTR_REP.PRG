.DEFINE WINDOW entre_rep ;
   FROM 01,00 ;
   TO   23,79 ;
   TITLE "< ARTICULOS ENTREGADOS PARA MAQUINAS EN REPARACION >" ;
   SYSTEM ;
   CLOSE ;
   FLOAT ;
   GROW ;
   MDI ;         
   NOMINIMIZE ;
   SHADOW ;
   ZOOM ;
   COLOR SCHEME 15


SELECT maesprod 
SET ORDER TO 1
SELECT

SELECT entr_rep
SET ORDER TO 1
GOTO TOP


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
ON KEY LABEL "F4" DO orden02.spr
ON KEY LABEL "F5" DO _Switch
ON KEY LABEL "F8" DO maesprod.prg WITH "Delete"
ON KEY LABEL "CTRL+ENTER" DO maesinfo.spr
ON KEY LABEL "CTRL+HOME"  GO TOP
ON KEY LABEL "CTRL+END"   GO BOTTOM
ON KEY LABEL "SPACEBAR"   WAIT WINDOW "STOCK ACTUAL: " + TRANSFORM(stock_actu - stock_ot, "9,999.99")

DO HelpBar.spr
DO _PrintHelpBar

BROWSE WINDOW brwMaesprod FIELDS ;
   calc_f1  = LEFT(codigo, 7)                            :R:07:H = "C¢digo" ,;
   calc_f15 = LEFT(ubicacion, 6)                         :R:06:H = "Ubicac" ,;  
   calc_f2  = LEFT(nombre, 37)                           :R:37:H = "Nombre" ,;
   calc_f3  = IIF(impuesto, "S", "")                     :R:01:H = "",;
   calc_f4 = ROUND(pventag1 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 1 c/Iva":P = "9,999,999,999" ,;
   calc_f14 = stock_actu - stock_ot                      :R:07:H = " Stock ":P = "9999.99" ,;  
   calc_f5 = ROUND(pventag2 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 2 c/Iva":P = "9,999,999,999" ,;
   calc_f6 = ROUND(pventag3 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 3 c/Iva":P = "9,999,999,999" ,;
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
*   pventag3                                             :R:10:H = "P.Vta 3":P = "99,999,999" ,;
*   calc_f6 = ROUND(pventag3 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 3 c/Iva":P = "9,999,999,999" ,;
*   calc_f7 = IIF(impuesto, "   S¡   ", "")              :R:08:H = "Impuesto" ,;
*   stock_actu                                           :R:13:H = "Stock Actual":P = "99,999,999.99" ,;  
*   calc_f8  = SUBSTR(rubros1.nombre, 1, 30)             :R:30:H = "Rubro" ,;
*   calc_f9  = SUBSTR(rubros2.nombre, 1, 30)             :R:30:H = "Sub-Rubro",;   
*   calc_f10 = SUBSTR(marcas1.nombre, 1, 30)             :R:30:H = "Marcas",;      
*   calc_f11 = SUBSTR(nombre, 1, 40)                     :R:40:H = "Nombre" ,;
*   calc_f12 = SUBSTR(codigo2, 1, 15)                    :R:15:H = "C¢d.Alternativo" ,;
*   calc_f13 = SUBSTR(codorig, 1, 15)                    :R:15:H = "C¢d. Origen" ;
*   NOAPPEND NODELETE NOMODIFY

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
ON KEY LABEL "F8" 
ON KEY LABEL "CTRL+ENTER"
ON KEY LABEL "CTRL+HOME" 
ON KEY LABEL "CTRL+END"  
ON KEY LABEL "SPACEBAR" 
ON KEY LABEL "F9"   

RELEASE WINDOW 
IF WEXIST("brwMaesprod")
   RELEASE WINDOW brwMaesprod
ENDIF
