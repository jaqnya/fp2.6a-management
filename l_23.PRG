*
* l_23.prg
*
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Informe de ultimo movimiento de compra y venta
*
* Historial de Modificacion:
* Enero 15, 2009	Jose Avilio Acuna Acosta	Creador del Programa
*

PRIVATE m.id_marca, m.dias, m.dias_venta, m.dias_compra

DEFINE WINDOW l_21;
   FROM 09,20;
   TO   14,62;
   TITLE " ULTIMO MOVIMIENTO DE COMPRA Y VENTA ";
   SHADOW

ACTIVATE WINDOW l_21

DO WHILE .T.
   STORE 0 TO m.id_marca, m.dias

   @ 01,16 SAY REPLICATE(CHR(32), 20) SIZE 1,20 COLOR W/N
   @ 01,01 SAY "Marca: " GET m.id_marca PICTURE "99999" DEFAULT 0 SIZE 1,5 VALID vldmarca()
   @ 02,01 SAY "D¡as.: " GET m.dias PICTURE "99999" DEFAULT 0 SIZE 1,5 VALID vlddias()

   READ

   IF LASTKEY() = 27 THEN
      EXIT
   ENDIF

   IF EMPTY(m.id_marca) THEN
      WAIT WINDOW "CODIGO DE MARCA NO PUEDE SER CERO !"
      LOOP
   ENDIF

   IF esta_correcto() THEN
      DO ult_mov WITH .F.

      SELECT tm_informe
      SCAN ALL
         m.dias_venta  = DATE() - fecuventa
         m.dias_compra = DATE() - fecucompra

         IF !EMPTY(fecuventa) OR !EMPTY(fecucompra) THEN
            DO CASE
               CASE !EMPTY(fecuventa) AND EMPTY(fecucompra)
                  IF m.dias_venta < m.dias THEN
                     DELETE
                  ENDIF
               CASE EMPTY(fecuventa) AND !EMPTY(fecucompra)
                  IF m.dias_compra < m.dias THEN
                     DELETE
                  ENDIF
               CASE m.dias_venta > m.dias AND m.dias_compra < m.dias
                  DELETE
               CASE m.dias_venta < m.dias AND m.dias_compra > m.dias
                  DELETE
               CASE m.dias_venta < m.dias AND m.dias_compra < m.dias
                  DELETE
            ENDCASE
         ENDIF
      ENDSCAN

      IF m.id_marca <> -1 THEN
         DELETE FOR id_marca <> m.id_marca
      ENDIF

      SELECT * FROM tm_informe INTO CURSOR tmp
      SELECT tmp
      IF RECCOUNT() = 0 THEN
         WAIT "NO HAY DATOS PARA EL INFORME !"
         LOOP
      ENDIF

      * BOC:

      IF .NOT. WEXIST("brwMaesprod")
         DEFINE WINDOW brwMaesprod ;
            FROM 01,00 ;
            TO   23,79 ;
            TITLE "< ULTIMO MOVIMIENTO DE COMPRA Y VENTA >" ;
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

      SELECT tm_informe
      GO TOP

      BROWSE WINDOW brwMaesprod FIELDS ;
         calc_f1 = LEFT(id_product, 10) :R:10:H = "C¢digo" ,;
         calc_f2 = LEFT(producto, 35)   :R:35:H = "Nombre" ,;
         calc_f3 = existencia           :R:07:H = " Stock ":P = "9999.99" ,;
         calc_f4 = fecuventa            :R:10:H = "F.Ult.Vta." :P = "@D" ,;
         calc_f5 = fecucompra           :R:10:H = "F.Ult.Com." :P = "@D" ,;
         calc_f6 = IIF(!EMPTY(fecuventa), DATE() - fecuventa, IIF(!EMPTY(fecucompra), DATE() - fecucompra, 0)) :R:06:H = " D¡as ":P = "999999" ;
         NOAPPEND NODELETE NOMODIFY

*!*	      SET DELETED OFF
*!*	      BROWSE WINDOW brwMaesprod FIELDS ;
*!*	         calc_f1 = LEFT(id_product, 10) :R:10:H = "C¢digo" ,;
*!*	         calc_f2 = LEFT(producto, 35)   :R:35:H = "Nombre" ,;
*!*	         calc_f3 = existencia           :R:07:H = " Stock ":P = "9999.99" ,;
*!*	         calc_f4 = fecuventa            :R:10:H = "F.Ult.Vta." :P = "@D" ,;
*!*	         calc_f5 = fecucompra           :R:10:H = "F.Ult.Com." :P = "@D" ,;
*!*	         calc_f6 = IIF(!EMPTY(fecuventa), DATE() - fecuventa, IIF(!EMPTY(fecucompra), DATE() - fecucompra, 0)) :R:06:H = " D¡as ":P = "999999" ;
*!*	         FOR DELETED() AND id_marca= m.id_marca ;
*!*	         NOAPPEND NODELETE NOMODIFY
*!*	      SET DELETED ON

      IF WEXIST("brwMaesprod")
         RELEASE WINDOW brwMaesprod
      ENDIF

      IF exportar() THEN
         IF estado_archivo("c:\excel.xls") = 0 THEN
            SELECT tm_informe
            EXPORT TO c:\excel TYPE XLS
            WAIT "NOMBRE DEL ARCHIVO: EXCEL.XLS, EN C:\" WINDOW
         ELSE
            WAIT "ERROR:" + CHR(13) + "EL ARCHIVO: C:\EXCEL.XLS, ESTA EN USO" + CHR(13) + "NO SE PUEDE EXPORTAR EL INFORME." WINDOW
         ENDIF
      ENDIF

      * EOC:
   ENDIF
ENDDO

DEACTIVATE WINDOW l_21
RELEASE WINDOW l_21
 
*--------------------------------------------------------------------------*
PROCEDURE esta_correcto
PRIVATE m.correcto, m.retorno
STORE SPACE(1) TO m.correcto

DO WHILE .T.
   WAIT "ESTA CORRECTO ? (S/N)" TO m.correcto WINDOW
   m.correcto = UPPER(m.correcto)
   IF INLIST(m.correcto, "S", "N") OR LASTKEY() = 27 THEN
      EXIT
   ENDIF
ENDDO

DO CASE
   CASE m.correcto = "S"
      m.retorno = .T.
   CASE m.correcto = "N" OR LASTKEY() = 27
      m.retorno = .F.
ENDCASE

RETURN (m.retorno)

*--------------------------------------------------------------------------*
PROCEDURE vlddias

IF m.dias <= 0 THEN
   WAIT "EL VALOR DEBE SER MAYOR QUE CERO !" WINDOW
   RETURN 0
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE vldmarca

@ 01,16 SAY REPLICATE(CHR(32), 20) SIZE 1,20 COLOR W/N

IF m.id_marca = 0 THEN
   PUSH KEY CLEAR

   ON KEY LABEL "ENTER" KEYBOARD "{CTRL+W}"

   * BOC:
   IF .NOT. WEXIST("brwMarcas1")
      DEFINE WINDOW brwMarcas1 ;
         FROM 02,16 ;
         TO   22,64 ;
         TITLE "< MARCAS >" ;
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

   SELECT marcas1
   SET ORDER TO TAG indice2 OF marcas1.cdx
   GO TOP
                
   *-- MS-DOS Macros de teclado.
   ON KEY LABEL "F4" DO orden01.spr
   ON KEY LABEL "F5" DO _Switch
   ON KEY LABEL "CTRL+HOME" GO TOP
   ON KEY LABEL "CTRL+END"  GO BOTTOM

   BROWSE WINDOW brwMarcas1 FIELDS ;
      codigo                                :R:06:H = "C¢digo"  :P = "999999" ,;
      calc_f1 = SUBSTR(nombre, 1, 30)       :R:30:H = "Nombre" ,;
      calc_f2 = IIF(vigente, "S¡     ", "") :R:07:H = "Vigente" :P = "@I" ,;
      id_local                              :R:02:H = "" ;
      NOAPPEND NODELETE NOMODIFY

   SET ORDER TO TAG indice1 OF marcas1.cdx

   *-- MS-DOS Restablece macros de teclado.
   ON KEY LABEL "F4"
   ON KEY LABEL "F5"
   ON KEY LABEL "CTRL+HOME" 
   ON KEY LABEL "CTRL+END"  

   RELEASE WINDOW brwMarcas1
   * EOC

   ON KEY LABEL "ENTER" 

   POP KEY

   IF LASTKEY() <> 27
      m.id_marca = codigo
   ELSE 
      m.id_marca = 0
   ENDIF
ENDIF

IF m.id_marca = 0
   RETURN 0
ENDIF

IF m.id_marca <> -1 THEN
   SELECT marcas1
   SET ORDER TO 1
   IF SEEK(m.id_marca) THEN
      @ 01,16 SAY LEFT(look_up("nombre", "marcas1", m.id_marca), 20) SIZE 1,20 COLOR W/N
   ELSE
      WAIT "CODIGO DE MARCA INEXISTENTE !" WINDOW
      RETURN 0
   ENDIF
ELSE
   @ 01,16 SAY "TODAS" SIZE 1,20 COLOR W/N
ENDIF

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

*!**************************************************************************
*!
*!  Procedimiento: _Switch        
*!
*!    Llamado por: BRWMARC1.PRG                  
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
         DO marcas1.prg WITH "Add"
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
   CASE LOWER(TAG()) = "indice1"
      DO buscar01.spr
   CASE LOWER(TAG()) = "indice2"
      DO buscar02.spr
ENDCASE

POP KEY

*--------------------------------------------------------------------------*
PROCEDURE exportar
PRIVATE m.correcto, m.retorno
STORE SPACE(1) TO m.correcto

DO WHILE .T.
   WAIT "EXPORTAR LISTA A MS-EXCEL ? (S/N)" TO m.correcto WINDOW
   m.correcto = UPPER(m.correcto)
   IF INLIST(m.correcto, "S", "N") OR LASTKEY() = 27 THEN
      EXIT
   ENDIF
ENDDO

DO CASE
   CASE m.correcto = "S"
      m.retorno = .T.
   CASE m.correcto = "N" OR LASTKEY() = 27
      m.retorno = .F.
ENDCASE

RETURN (m.retorno)

*
* estado_archivo
*
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Verifica si el archivo especificado se encuentra en uso
*
* Valores Devueltos:
* 0 = El archivo no esta en uso
* 1 = El archivo esta en uso
* 2 = Error
*
* Historial de Modificacion:
* Agosto 24, 2008	Jose Avilio Acuna Acosta	Creador del Programa
*

FUNCTION estado_archivo
PARAMETER m.archivo

IF PARAMETERS() < 1 THEN
   WAIT "PROGRAMA: ESTADO_ARCHIVO" + CHR(13) + "NO SE HAN PASADO SUFICIENTES PARAMETROS." WINDOW
   RETURN 2
ENDIF

IF TYPE("m.archivo") <> "C" THEN
   WAIT "PROGRAMA: ESTADO_ARCHIVO" + CHR(13) + "EL PARAMETRO DEBE SER DE TIPO CARACTER." WINDOW
   RETURN 2
ENDIF

IF !FILE(m.archivo) THEN
   RETURN 0
ENDIF

PRIVATE m.estado, m.handle
STORE 0 TO m.estado

m.handle = FOPEN(m.archivo, 12)
=FCLOSE(m.handle)
m.estado = IIF(m.handle <> -1, 0, 1)

RETURN (m.estado)