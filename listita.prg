CLEAR

CLEAR ALL
CLOSE ALL

SET DELETED ON
SET EXACT ON
SET SAFETY OFF
SET CENTURY ON
SET DATE BRITISH
SET TALK OFF

STORE 0 TO m.codigo1, m.codigo2
@ 05,17 SAY "GENERADOR DE LISTA DE PRODUCTO EN FORMATO HTML"
@ 06,17 SAY "----------------------------------------------"
@ 10,20 SAY "C¢digo de Producto Inicial: " GET m.codigo1
@ 11,20 SAY "C¢digo de Producto Final..: " GET m.codigo2

READ

USE maesprod IN 0 ORDER 8 SHARED

SELECT;
   codigo,;
   codorig AS cod_origen,;
   codigo2 AS cod_altern,;
   ubicacion,;
   nombre AS descripcion,;
   stock_actu-stock_ot AS existencia;
FROM;
   maesprod;
WHERE;
   BETWEEN(VAL(codigo), m.codigo1, m.codigo2);
INTO TABLE;
   tmx86

SELECT tmx86
INDEX ON VAL(codigo) TAG indice1

SET TEXTMERGE ON
STORE FCREATE("z:\lista.html") TO _TEXT
IF _TEXT = -1
   WAIT WINDOW "No se pudo crear el archivo de salida. Presione cualquier tecla para salir."
   RETURN
ENDIF

TEXT
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
   <HEAD>
      <TITLE>:: www.ayaimportaciones.com.py ::</TITLE>
   </HEAD>
<BODY>
   <H3><CENTER>LISTA DE PRODUCTOS</CENTER></H3>
   <CENTER><<DATE()>>  <<TIME()>></CENTER>
   <TABLE ALIGN="CENTER" BORDER="1">
      <TR>
         <TH>C&oacute;digo</TH>
         <TH><B>C&oacute;digo Original</TH>
         <TH><B>C&oacute;digo Alternativo</TH>
         <TH><B>Ubicaci&oacute;n</TH>
         <TH><B>Descripci&oacute;n</TH>
         <TH><B>Existencia</TH>
      </TR>
ENDTEXT

SCAN ALL
   TEXT
      <TR>
         <TD><<codigo>></TD>
         <TD><<cod_origen>></TD>
         <TD><<cod_altern>></TD>
         <TD><<ubicacion>></TD>
         <TD><<descripcio>></TD>
         <TD ALIGN="RIGHT"><<existencia>></TD>
      </TR>
   ENDTEXT
ENDSCAN

TEXT
   </TABLE>
</BODY>
</HTML>
ENDTEXT

CLOSE ALL
CLEAR
WAIT "El archivo 'z:\lista.html' fue creado exitosamente." + chr(13) + "Presione una tecla para salir." WINDOW
QUIT
