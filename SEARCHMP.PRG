*!**************************************************************************
*!
*!  PROCEDIMIENTO: SearchMp
*!
*!    DESCRIPCION: Busca registros que coincidan con la condici¢n.
*!
*!**************************************************************************
PARAMETER pcString, pcField
PUSH KEY CLEAR

PRIVATE pcCurrWindow, xselect, xorder

pcCurrWindow = WONTOP()
xselect = SELECT()
xorder = ORDER()

WAIT WINDOW "BUSCANDO..." NOWAIT

SELECT 0
arch_temp = "tm" + SYS(3) + ".dbf"

CREATE TABLE &arch_temp (codigo     C(15),;
                         codigo2    C(15),;
                         codorig    C(15),;
                         nombre     C(40),;
                         aplicacion M ,;
                         lista3     L(01),;
                         lista4     L(01),;
                         lista5     L(01),;
                         familia    N(04),;
                         rubro      N(04),;
                         subrubro   N(04),;
                         marca      N(04),;
                         unidad     N(03),;
                         proveedor  N(05),;
                         procedenci N(04),;                           
                         ubicacion  C(10),;
                         vigente    L(01),;
                         lprecio    L(01),;
                         impuesto   L(01),;
                         pimpuesto  N(06,2),;                                                                                 
                         pcostog    N(13,4),;
                         pcostod    N(13,4),;
                         pventag1   N(13,4),;
                         pventag2   N(13,4),;
                         pventag3   N(13,4),;
                         pventag4   N(13,4),;
                         pventag5   N(13,4),;
                         pventad1   N(13,4),;
                         pventad2   N(13,4),;
                         pventad3   N(13,4),;
                         pventad4   N(13,4),;
                         pventad5   N(13,4),;
                         paumento1  N(06,2),;
                         paumento2  N(06,2),;
                         paumento3  N(06,2),;
                         paumento4  N(06,2),;
                         paumento5  N(06,2),;
                         stock_min  N(11,2),;
                         stock_max  N(11,2),;
                         polinvsmin L(01),;
                         polinvsmax L(01),;
                         garantia   C(20),;
                         caracter1  C(60),;
                         caracter2  C(60),;
                         caracter3  C(60),;
                         otros1     C(60),;
                         otros2     C(60),;
                         fecucompra D(08),;
                         fecrepo    D(08),;
                         stock_actu N(11,2),;
                         stock_ot   N(11,2))

INDEX ON codigo      TAG indice1
INDEX ON nombre      TAG indice2
INDEX ON rubro       TAG indice3
INDEX ON subrubro    TAG indice4
INDEX ON marca       TAG indice5
INDEX ON codigo2     TAG indice6
INDEX ON codorig     TAG indice7
INDEX ON val(codigo) TAG indice8
INDEX ON familia     TAG indice9
INDEX ON nombre      TAG indice10
INDEX ON codigo      TAG indice11 FOR vigente 
INDEX ON codigo2     TAG indice12 FOR vigente 
INDEX ON codorig     TAG indice13 FOR vigente

USE &arch_temp ALIAS maestemp
SET ORDER TO indice2 

SET RELATION TO maestemp.familia    INTO familias ,;
                maestemp.rubro      INTO rubros1  ,;
                maestemp.subrubro   INTO rubros2  ,;
                maestemp.marca      INTO marcas1   ,;
                maestemp.unidad     INTO unidad   ,;
                maestemp.procedenci INTO proceden ,;
                maestemp.proveedor  INTO proveedo ADDITIVE

pcString = UPPER(ALLTRIM(pcString))
DO WHILE AT("**", pcString) > 0
   pcString = STRTRAN(pcString, "**", "*")
ENDDO

IF LEFT(pcString, 1) = "*"
   pcFirst = ".NULL."
ELSE
   IF OCCURS("*", pcString) = 0
      pcFirst = pcString
   ELSE
      pcFirst = SUBSTR(pcString, 1, (ATC("*", pcString) - 1))
   ENDIF
ENDIF

IF RIGHT(pcString, 1) = "*"
   pnOccurs = OCCURS("*", pcString) - 1
ELSE
   pnOccurs = OCCURS("*", pcString)
ENDIF

pcExpresion = ""
PRIVATE paString

IF pnOccurs > 0
   DIMENSION paString(pnOccurs)
ENDIF

FOR pnCounter = 1 TO pnOccurs
   paString(pnCounter) = ALLTRIM(SUBSTR(pcString, ATC("*", pcString, pnCounter) + 1, (ATC("*", pcString, pnCounter + 1) - 1) - ATC("*", pcString, pnCounter)))
   IF pnCounter = pnOccurs
      IF RIGHT(pcString, 1) = "*"
         paString(pnCounter) = ALLTRIM(SUBSTR(pcString, ATC("*", pcString, pnCounter) + 1, (ATC("*", pcString, pnCounter + 1) - 1) - ATC("*", pcString, pnCounter)))
      ELSE
         paString(pnCounter) = ALLTRIM(SUBSTR(pcString, ATC("*", pcString, pnCounter) + 1))
      ENDIF
   ENDIF
ENDFOR

FOR pnCounter = 1 TO pnOccurs
   IF pnCounter < pnOccurs
*     pcExpresion = pcExpresion + [ATC("] + paString(pnCounter) + [", maesprod.nombre) > 0] + [ .and. ]
      pcExpresion = pcExpresion + [ATC("] + paString(pnCounter) + [", ] + pcField + [) > 0] + [ .and. ]
   ELSE 
      pcExpresion = pcExpresion + [ATC("] + paString(pnCounter) + [", ] + pcField + [) > 0]
*      pcExpresion = pcExpresion + [ATC("] + paString(pnCounter) + [", maesprod.nombre) > 0]
   ENDIF
ENDFOR

SELECT maesprod

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

IF pcFirst = ".NULL."
   HIDE WINDOW (pcCurrWindow)
   
   GO TOP
   pnDoCounter = 1
   DO WHILE .NOT. EOF()
*     wait window "PROCESANDO: " + ALLTRIM(transform(nDoCounter, "9,999,999")) + "/" + ALLTRIM(transFORm(reccount(), "9,999,999")) nowait
      IF EVAL(pcExpresion)
         =SaveSearch()
      ENDIF
      SKIP
      DO progress WITH ((pnDoCounter * 100) / RECCOUNT()), "PROCESANDO: ARTICULOS..."
      pnDoCounter = pnDoCounter + 1
   ENDDO

   SHOW WINDOW (pcCurrWindow)
   RELEASE WINDOW _thermom
ELSE
   IF SEEK(pcFirst) 
      DO WHILE SUBSTR(&pcField, 1, LEN(ALLTRIM(pcFirst))) = ALLTRIM(pcFirst) .AND. NOT EOF()
*     DO WHILE SUBSTR(maesprod.nombre,1, LEN(ALLTRIM(pcFirst))) = ALLTRIM(pcFirst) .AND. NOT EOF()
         IF pnOccurs = 0
            =SaveSearch()
         ELSE
            IF EVAL(pcExpresion)
               =SaveSearch()
            ENDIF
         ENDIF
         SKIP
      ENDDO
   ENDIF
ENDIF
WAIT CLEAR

SELECT maestemp
DO CASE
   CASE pcField = "maesprod.codigo"
      SET ORDER TO TAG indice1
   CASE pcField = "maesprod.nombre"
      SET ORDER TO TAG indice2
   CASE pcField = "maesprod.codigo2"
      SET ORDER TO TAG indice6
   CASE pcField = "maesprod.codorig"
      SET ORDER TO TAG indice7
ENDCASE

IF RECCOUNT() <> 0
   GO TOP
   IF NOT WEXIST ("brwMpdTemp")
      DEFINE WINDOW brwMpdTemp ;
         FROM 01,00 ;
         TO 23,79 ;
         TITLE " < RESULTADOS DE LA BUSQUEDA: " + pcString + " > " ;
         FLOAT ;
         GROW ;
         CLOSE ;
         NOSHADOW ;
         NOMINIMIZE ;
         ZOOM ;
         SYSTEM ;
         COLOR "W+/BG,GR+/RB,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,,," 
   ENDIF

   *-- MS-DOS Macros de teclado.
   ON KEY LABEL "F4" DO orden02.prg
   ON KEY LABEL "CTRL+ENTER" DO maesin1c.prg
   ON KEY LABEL "CTRL+HOME"  GO TOP
   ON KEY LABEL "CTRL+END"   GO BOTTOM
   ON KEY LABEL "SPACEBAR"   WAIT WINDOW "STOCK ACTUAL: " + TRANSFORM(stock_actu - stock_ot, "9,999.99")

   RELEASE WINDOW (pcCurrWindow)

   BROWSE WINDOW brwMpdTemp FIELDS ;
      calc_f1 = SUBSTR(codigo, 1, 9)                       :R:09:H = "C¢digo" ,;
      calc_f2 = SUBSTR(nombre, 1, 39)                      :R:39:H = "Nombre" ,;
      calc_f3 = IIF(impuesto, "S", "")                     :R:01:H = "",;
      pventag1                                             :R:10:H = "P.Vta 1":P = "99,999,999" ,;
      calc_f4 = ROUND(pventag1 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 1 c/Iva":P = "9,999,999,999" ,;
      pventag2                                             :R:10:H = "P.Vta 2":P = "99,999,999" ,;
      calc_f5 = ROUND(pventag2 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 2 c/Iva":P = "9,999,999,999" ,;
      pventag3                                             :R:10:H = "P.Vta 3":P = "99,999,999" ,;
      calc_f6 = ROUND(pventag3 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 3 c/Iva":P = "9,999,999,999" ,;
      calc_f7 = IIF(impuesto, "   S¡   ", "")              :R:08:H = "Impuesto" ,;
      stock_actu                                           :R:13:H = "Stock Actual":P = "99,999,999.99" ,;  
      calc_f8  = SUBSTR(rubros1.nombre, 1, 30)             :R:30:H = "Rubro" ,;
      calc_f9  = SUBSTR(rubros2.nombre, 1, 30)             :R:30:H = "Sub-Rubro",;   
      calc_f10 = SUBSTR(marcas1.nombre, 1, 30)             :R:30:H = "Marcas",;      
      calc_f11 = SUBSTR(nombre, 1, 40)                     :R:40:H = "Nombre" ,;
      calc_f12 = SUBSTR(codigo2, 1, 15)                    :R:15:H = "C¢d.Alternativo" ,;
      calc_f13 = SUBSTR(codorig, 1, 15)                    :R:15:H = "C¢d. Origen" ;
      NOAPPEND NODELETE NOMODIFY

   *-- MS-DOS Restablece macros de teclado.
   ON KEY LABEL "F4" 
   ON KEY LABEL "CTRL+ENTER"
   ON KEY LABEL "CTRL+HOME"
   ON KEY LABEL "CTRL+END"
   ON KEY LABEL "SPACEBAR"
   
   IF !EMPTY(ALIAS(xselect)) THEN
      SELECT (xselect)
   ENDIF

   SELECT (xselect)
   SET ORDER TO 1
   SEEK maestemp.codigo
   SET ORDER TO TAG (xorder)
ELSE
   WAIT WINDOW "­ LOS DATOS BUSCADOS NO HAN SIDO ENCONTRADOS !"
  
   SELECT (pnSelect)
   SET ORDER TO TAG (pcOrder)
   IF pnRecNo <> 0
      GOTO RECORD pnRecNo
   ENDIF

ENDIF
   
*-- MS-DOS Cierre de Bases de Datos.
IF USED("maestemp")
   SELECT maestemp
   USE
ENDIF

DELETE FILE &arch_temp
DELETE FILE SUBSTR(arch_temp, 1, ATC(".", arch_temp))+"CDX"

*-- Elimina ventanas.
IF WEXIST("brwMpdTemp")
   RELEASE WINDOW brwMpdTemp
ENDIF

SELECT (xselect)
POP KEY

*-- Procedimientos y funciones del soporte.
*!**************************************************************************
*!
*!  PROCEDIMIENTO: SaveSearch
*!
*!    DESCRIPCION: Graba el art¡culo en la tabla temporal que concuerda con
*!                 la condici¢n.
*!
*!**************************************************************************
PROCEDURE SaveSearch

SELECT maesprod
   SCATTER MEMVAR MEMO

SELECT maestemp
   APPEND BLANK
   GATHER MEMVAR MEMO

SELECT maesprod