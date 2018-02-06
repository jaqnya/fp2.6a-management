CLEAR

CLEAR ALL
CLOSE ALL

SET DELETED ON
SET EXACT ON
SET SAFETY OFF
SET CENTURY ON
SET DATE BRITISH
SET TALK OFF

USE maesprod IN 0 ORDER 0 SHARED
USE z:\turtle\aya\integrad.001\maesprod IN 0 ORDER 0 ALIAS maespdep SHARED
USE marcas1 IN 0 ORDER 0 SHARED

STORE 0 TO m.marca, m.lista, m.tipocambio
STORE "S" TO m.impuesto
STORE "N" TO m.stock_cero
STORE SYS(2015) TO lcFileName

@ 05,21 SAY "GENERADOR DE LISTA DE PRODUCTOS EN USD"
@ 06,21 SAY "--------------------------------------"
@ 08,21 SAY "C¢digo de Marca....: " GET m.marca VALID valMarca() PICTURE "9999"
@ 10,21 SAY "Lista de Precio....: " GET m.lista VALID valLista() PICTURE "9"
@ 12,21 SAY "Tipo de Cambio.....: " GET m.tipocambio VALID valTipoCambio() PICTURE "99,999"
@ 14,21 SAY "Listar productos"
@ 15,21 SAY "con existencia = 0.: " GET m.stock_cero VALID valStockCero() PICTURE "@!"
@ 17,21 SAY "Precio IVA Incluido: " GET m.impuesto VALID valImpuesto() PICTURE "@!"
@ 19,21 SAY ":: Nombre del Archivo EXCEL a Generar ::" COLOR W+/N
@ 20,29 SAY LEFT(lcFileName,8) + " en la unidad Z:" COLOR GR+/N

READ

IF LASTKEY() = 27 THEN
   QUIT
ENDIF

SELECT;
   codigo,;
   codorig AS cod_origen,;
   codigo2 AS cod_altern,;
   ubicacion,;
   nombre AS descripcion,;
   pventag1 AS lista_1g,;
   pventag2 AS lista_2g,;
   pventag3 AS lista_3g,;
   pventag4 AS lista_4g,;
   pventag5 AS lista_5g,;
   stock_actu-stock_ot AS existencia,;
   pcostog AS costo_gs,;
   pcostod AS costo_usd;
FROM;
   maesprod;
WHERE;
   marca = m.marca;
INTO TABLE;
   tmx86

SELECT;
   codigo,;
   codorig AS cod_origen,;
   codigo2 AS cod_altern,;
   ubicacion,;
   nombre AS descripcion,;
   pventag1 AS lista_1g,;
   pventag2 AS lista_2g,;
   pventag3 AS lista_3g,;
   pventag4 AS lista_4g,;
   pventag5 AS lista_5g,;
   stock_actu-stock_ot AS existencia,;
   pcostog AS costo_gs,;
   pcostod AS costo_usd;
FROM;
   maespdep;
WHERE;
   marca = m.marca;
INTO TABLE;
   tmx87

CREATE TABLE tmx88 (;
   codigo C(15),;
   cod_origen C(15),;
   cod_altern C(15),;
   ubicacion C(10),;
   descripcio C(40),;
   lista_1g N(9,2),;
   lista_2g N(9,2),;   
   lista_3g N(9,2),;
   lista_4g N(9,2),;
   lista_5g N(9,2),;
   precio N(9),;
   precio_usd N(9,2),;
   existencia N(6,2),;
   costo_gs N(9),;
   costo_usd N(9,2);
)
   
SELECT tmx86
SCAN ALL
   mcodigo = codigo
   mcod_origen = cod_origen
   mcod_altern = cod_altern
   mubicacion = ubicacion
   mdescripcio = descripcio
   mlista_1g = lista_1g
   mlista_2g = lista_2g
   mlista_3g = lista_3g
   mlista_4g = lista_4g
   mlista_5g = lista_5g
   mexistencia = existencia
   mcosto_gs = ROUND(costo_gs, 0)
   mcosto_usd = ROUND(costo_usd, 2)
   
   INSERT INTO tmx88 (codigo, cod_origen, cod_altern, ubicacion, descripcio, lista_1g, lista_2g, lista_3g, lista_4g, lista_5g, existencia, costo_gs, costo_usd);
      VALUES (mcodigo, mcod_origen, mcod_altern, mubicacion, mdescripcio, mlista_1g, mlista_2g, mlista_3g, mlista_4g, mlista_5g, mexistencia, mcosto_gs, mcosto_usd)
ENDSCAN

SELECT tmx87
SCAN ALL
   mcodigo = codigo
   mexistencia = existencia
   
   SELECT tmx88
   LOCATE FOR codigo = mcodigo
   IF FOUND() THEN
      REPLACE existencia WITH existencia + mexistencia
   ELSE
      WAIT "EL PRODUCTO " + ALLTRIM(mcodigo) + " NO EXISTE."
   ENDIF
ENDSCAN

SELECT tmx88
IF m.impuesto = "S" THEN
   REPLACE lista_1g WITH ROUND(lista_1g * 1.1, 0),;
           lista_2g WITH ROUND(lista_2g * 1.1, 0),;
           lista_3g WITH ROUND(lista_3g * 1.1, 0),;
           lista_4g WITH ROUND(lista_4g * 1.1, 0),;
           lista_5g WITH ROUND(lista_5g * 1.1, 0) ALL
ENDIF

SELECT tmx88
SCAN ALL
   DO CASE
      CASE m.lista = 1
         REPLACE precio WITH lista_1g
      CASE m.lista = 2
         IF lista_2g = 0 THEN
            REPLACE precio WITH lista_1g
         ELSE
            REPLACE precio WITH lista_2g
         ENDIF
      CASE m.lista = 3
         IF lista_3g = 0 THEN
            IF lista_2g = 0 THEN
               REPLACE precio WITH lista_1g
            ELSE
               REPLACE precio WITH lista_2g
            ENDIF
         ELSE
            REPLACE precio WITH lista_3g
         ENDIF
      CASE m.lista = 4
         IF lista_4g = 0 THEN
            IF lista_3g = 0 THEN
               IF lista_2g = 0 THEN
                  REPLACE precio WITH lista_1g
               ELSE
                  REPLACE precio WITH lista_2g
               ENDIF
            ELSE
               REPLACE precio WITH lista_3g
            ENDIF
         ELSE
            REPLACE precio WITH lista_4g
         ENDIF
      CASE m.lista = 5
         IF lista_5g = 0 THEN
            IF lista_4g = 0 THEN
               IF lista_3g = 0 THEN
                  IF lista_2g = 0 THEN
                     REPLACE precio WITH lista_1g
                  ELSE
                     REPLACE precio WITH lista_2g
                  ENDIF
               ELSE
                  REPLACE precio WITH lista_3g
               ENDIF
            ELSE
               REPLACE precio WITH lista_4g
            ENDIF
         ELSE
            REPLACE precio WITH lista_5g
         ENDIF
   ENDCASE
ENDSCAN

SELECT tmx88
REPLACE precio_usd WITH ROUND(precio / m.tipocambio, 2) ALL

IF m.stock_cero = "N" THEN
   DELETE FOR existencia = 0
ENDIF

SELECT;
   codigo,;
   cod_origen,;
   cod_altern,;
   descripcio,;
   precio AS precio_gs,;
   precio_usd,;
   existencia,;
   costo_gs,;
   costo_usd;
FROM;
   tmx88;
ORDER BY;
   descripcio;
INTO TABLE;
   tmx89

SELECT tmx89
lcRuta = "z:\" + LEFT(lcFileName, 8)
EXPORT TO (lcRuta) TYPE XLS
WAIT "ARCHIVO CREADO EXITOSAMENTE." WINDOW TIMEOUT 3
QUIT

*
*   Funciones para validacion de parametros ingresados por el usuario.
*
FUNCTION valLista
   IF !INLIST(m.lista, 1, 2, 3, 4, 5) THEN
      WAIT "LA LISTA DE PRECIO DEBE SER UN VALOR ENTRE 1 Y 5." WINDOW
      RETURN 0
   ENDIF
*!*	ENDFUNC

FUNCTION valTipoCambio
   IF m.tipocambio <= 0 THEN
      WAIT "EL TIPO DE CAMBIO DEBE SER MAYOR QUE CERO." WINDOW
      RETURN 0
   ENDIF
*!*	ENDFUNC

FUNCTION valStockCero
   IF !INLIST(m.stock_cero, "S", "N") THEN
      WAIT "EL VALOR DE ESTE CAMPO DEBE SER: (S)I o (N)O." WINDOW
      RETURN 0
   ENDIF
*!*	ENDFUNC

FUNCTION valImpuesto
   IF !INLIST(m.impuesto, "S", "N") THEN
      WAIT "EL VALOR DE ESTE CAMPO DEBE SER: (S)I o (N)O." WINDOW
      RETURN 0
   ENDIF
*!*	ENDFUNC

FUNCTION valMarca
   IF m.marca <= 0 THEN
      IF .NOT. WEXIST("brwmarca")
         DEFINE WINDOW brwmarca ;
            FROM 01,00 ;
            TO   23,60 ;
            TITLE "< MARCAS >" ;
            SYSTEM ;
            CLOSE ;
            FLOAT ;
            GROW ;
            MDI ;
            NOMINIMIZE ;
            SHADOW ;
            ZOOM ;
            COLOR SCHEME 7
      ENDIF

      MOVE WINDOW brwmarca CENTER

      SELECT marcas1
      SET ORDER TO 2

      ON KEY LABEL "ENTER" KEYBOARD "{CTRL+W}"

      BROWSE WINDOW brwmarca FIELDS ;
         nombre  :R:50:H = "Nombre",;
         codigo :R:06:H = "C¢digo";
         NOAPPEND NODELETE NOMODIFY

      ON KEY LABEL "ENTER"

      IF LASTKEY() = 27 THEN
         RETURN 0
      ENDIF

      m.marca = codigo
      @ 08,49 SAY ALLTRIM(nombre)
   ELSE
      SELECT marcas1
      SET ORDER TO 1
      IF SEEK(m.marca) THEN
         @ 08,49 SAY ALLTRIM(nombre)
      ELSE
         WAIT "LA MARCA NO EXISTE." WINDOW
      ENDIF
   ENDIF
*!*	ENDFUNC
