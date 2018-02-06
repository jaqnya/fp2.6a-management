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
USE cabevent IN 0 SHARED
USE detavent IN 0 SHARED

STORE 0 TO m.marca, m.lista, m.tipocambio, m.dias
STORE "N" TO m.impuesto
STORE "N" TO m.stock_cero
STORE SYS(2015) TO lcFileName

@ 05,21 SAY "GENERADOR DE LISTA ULTIMA VENTA DE PRODUCTOS"
@ 06,21 SAY "--------------------------------------------"
@ 08,21 SAY "C¢digo de Marca....: " GET m.marca VALID valMarca() PICTURE "9999"
@ 10,21 SAY "D¡as de la Ultima Venta: " GET m.dias VALID valDias() PICTURE "99999"
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
   pventad1 AS lista_1d,;
   pventad2 AS lista_2d,;
   pventad3 AS lista_3d,;
   pventad4 AS lista_4d,;
   pventad5 AS lista_5d,;
   stock_actu-stock_ot AS existencia,;
   pcostog AS costo_gs,;
   pcostod AS costo_usd,;
   fecucompra;
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
   pventad1 AS lista_1d,;
   pventad2 AS lista_2d,;
   pventad3 AS lista_3d,;
   pventad4 AS lista_4d,;
   pventad5 AS lista_5d,;
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
   lista_1d N(9,2),;
   lista_2d N(9,2),;   
   lista_3d N(9,2),;
   lista_4d N(9,2),;
   lista_5d N(9,2),;
   precio N(9,2),;
   fecucompra D(8),;
   fecuventa D(8),;
   precio_usd N(9,2),;
   existencia N(6,2),;
   costo_gs N(9),;
   costo_usd N(9,2),;
   antiguedad C(30);
)
   
SELECT tmx86
SCAN ALL
   mcodigo = codigo
   mcod_origen = cod_origen
   mcod_altern = cod_altern
   mubicacion = ubicacion
   mdescripcio = descripcio
   mlista_1d = lista_1d
   mlista_2d = lista_2d
   mlista_3d = lista_3d
   mlista_4d = lista_4d
   mlista_5d = lista_5d
   mexistencia = existencia
   mfecucompra = fecucompra
   mcosto_gs = 0
   mcosto_usd = 0
   
   INSERT INTO tmx88 (codigo, cod_origen, cod_altern, ubicacion, descripcio, lista_1d, lista_2d, lista_3d, lista_4d, lista_5d, existencia, costo_gs, costo_usd, fecucompra);
      VALUES (mcodigo, mcod_origen, mcod_altern, mubicacion, mdescripcio, mlista_1d, mlista_2d, mlista_3d, mlista_4d, mlista_5d, mexistencia, mcosto_gs, mcosto_usd, mfecucompra)
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
   REPLACE lista_1d WITH ROUND(lista_1d * 1.1, 0),;
           lista_2d WITH ROUND(lista_2d * 1.1, 0),;
           lista_3d WITH ROUND(lista_3d * 1.1, 0),;
           lista_4d WITH ROUND(lista_4d * 1.1, 0),;
           lista_5d WITH ROUND(lista_5d * 1.1, 0) ALL
ENDIF

SELECT tmx88
SCAN ALL
   DO CASE
      CASE m.lista = 1
         REPLACE precio WITH lista_1d
      CASE m.lista = 2
         IF lista_2d = 0 THEN
            REPLACE precio WITH lista_1d
         ELSE
            REPLACE precio WITH lista_2d
         ENDIF
      CASE m.lista = 3
         IF lista_3d = 0 THEN
            IF lista_2d = 0 THEN
               REPLACE precio WITH lista_1d
            ELSE
               REPLACE precio WITH lista_2d
            ENDIF
         ELSE
            REPLACE precio WITH lista_3d
         ENDIF
      CASE m.lista = 4
         IF lista_4d = 0 THEN
            IF lista_3d = 0 THEN
               IF lista_2d = 0 THEN
                  REPLACE precio WITH lista_1d
               ELSE
                  REPLACE precio WITH lista_2d
               ENDIF
            ELSE
               REPLACE precio WITH lista_3d
            ENDIF
         ELSE
            REPLACE precio WITH lista_4d
         ENDIF
      CASE m.lista = 5
         IF lista_5d = 0 THEN
            IF lista_4d = 0 THEN
               IF lista_3d = 0 THEN
                  IF lista_2d = 0 THEN
                     REPLACE precio WITH lista_1d
                  ELSE
                     REPLACE precio WITH lista_2d
                  ENDIF
               ELSE
                  REPLACE precio WITH lista_3d
               ENDIF
            ELSE
               REPLACE precio WITH lista_4d
            ENDIF
         ELSE
            REPLACE precio WITH lista_5d
         ENDIF
   ENDCASE
ENDSCAN

SELECT tmx88
REPLACE precio_usd WITH 0 ALL

IF m.stock_cero = "N" THEN
   DELETE FOR existencia = 0
ENDIF

SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.fechadocu,;
   a.tipocambio,;
   b.articulo,;
   b.cantidad,;
   b.precio;
FROM;
   cabevent a,;
   detavent b;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu;
ORDER BY;
   a.fechadocu DESC;
INTO TABLE;
   tm_detav

i = 1

SELECT tmx88
SCAN ALL
   WAIT "Procesando... " + ALLTRIM(TRANSFORM(i, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) WINDOW NOWAIT
   mid_product = codigo
   mfecuventa = {}
   mcantidad = 0
   mprecio_ven = 0
   
   SELECT tm_detav
   LOCATE FOR articulo = mid_product
   IF FOUND() THEN
      mfecuventa = fechadocu
      
      SELECT tmx88
      REPLACE fecuventa WITH mfecuventa
      IF !EMPTY(fecuventa) THEN
         REPLACE antiguedad WITH calcAntig(mfecuventa, DATE())
      ENDIF
   ENDIF
   i = i + 1
ENDSCAN

SELECT;
   codigo,;
   cod_origen,;
   cod_altern,;
   descripcio,;
   existencia,;
   fecucompra,;
   fecuventa,;
   antiguedad;
FROM;
   tmx88;
WHERE;
   ((DATE() - fecuventa) >= m.dias) OR EMPTY(fecuventa);
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
FUNCTION valDias
   IF m.dias < 0 THEN
      WAIT "LOS DIAS NO PUEDEN SER NEGATIVOS." WINDOW
      RETURN 0
   ENDIF
*!*	ENDFUNC

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


FUNCTION calcAntig
PARAMETERS tdFecha1, tdFecha2
   PRIVATE lnAnyo, lnMes, lnDia, lnMes1, lnMes2, lnDia1, lnDia2
   STORE 0 TO lnAnyo, lnMes, lnDia, lnMes1, lnMes2, lnDia1, lnDia2
   STORE "" TO lcReturn

   lnAnyo = YEAR(tdFecha2) - YEAR(tdFecha1)
   lnMes1 = MONTH(tdFecha1)
   lnMes2 = MONTH(tdFecha2)
   lnDia1 = DAY(tdFecha1)
   lnDia2 = DAY(tdFecha2)

   IF lnMes2 < lnMes1 THEN
      lnAnyo = lnAnyo - 1
   ENDIF

   IF lnAnyo > 0 THEN
      lcReturn = lcReturn + ALLTRIM(STR(lnAnyo)) + IIF(lnAnyo = 1, " año ", " años ")
   ENDIF

   DO CASE
      CASE lnMes2 = lnMes1
         lnMes = 0
      CASE lnMes2 > lnMes1
         lnMes = lnMes2 - lnMes1
     CASE lnMes2 < lnMes1
         lnMes = (12 - lnMes1) + lnMes2
   ENDCASE

   IF lnMes > 0 THEN
      lcReturn = lcReturn + ALLTRIM(STR(lnMes)) + IIF(lnMes = 1, " mes ", " meses ")
   ENDIF

   DO CASE
      CASE lnDia2 = lnDia1 AND lnMes2 = lnMes1
         lnDia = 0
      CASE lnDia2 > lnDia1
         lnDia = lnDia2 - lnDia1
      CASE lnDia2 < lnDia1
         lnDia = (30 - lnDia1) + lnDia2
   ENDCASE

   IF lnDia > 0 THEN
      lcReturn = lcReturn + ALLTRIM(STR(lnDia)) + IIF(lnDia = 1, " dia", " dias")
   ENDIF
RETURN lcReturn