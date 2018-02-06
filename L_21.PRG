*
* l_21.prg
*
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Liquidacion Caja Diaria
*
* Historial de Modificacion:
* Agosto 24, 2008	Jose Avilio Acuna Acosta	Creador del Programa
*

PRIVATE mfecha

DEFINE WINDOW l_21;
   FROM 09,24;
   TO   13,57;
   TITLE " LIQUIDACION DE CAJA DIARIA ";
   SHADOW

ACTIVATE WINDOW l_21

DO WHILE .T.
   mfecha = DATE()
   
   @ 01,07 SAY "FECHA:" GET mfecha PICTURE "@D"

   READ

   IF LASTKEY() = 27 THEN
      EXIT
   ENDIF

   IF EMPTY(mfecha) THEN
      WAIT WINDOW "LA FECHA NO PUEDE QUEDAR EN BLANCO !"
      LOOP
   ENDIF

   IF esta_correcto() THEN
      DO inf_03 WITH mfecha

      DO helpbar.spr
      @ 00,00 SAY " Presione la letra 'D' para ver el detalle" SIZE 1,80 COLOR N/W

      DEFINE WINDOW brwl_21;
         FROM 04,15;
         TO   20,63;
         TITLE "< LIQUIDACION DEL " + ALLTRIM(DTOC(mfecha)) + " >";
         SYSTEM;
         CLOSE;
         FLOAT;
         GROW;
         MDI;
         NOMINIMIZE;
         SHADOW;
         ZOOM;
         COLOR SCHEME 15

      SELECT tm_inform2
      GOTO TOP

      ON KEY LABEL "D" DO ver_detalle
      
      BROWSE WINDOW brwl_21 FIELDS;
         descripcio :R:30:H = "Descripcion",;
         monto :R:14:H = "       Importe";
         NOAPPEND NODELETE NOMODIFY

      ON KEY LABEL "D"

      RELEASE WINDOW
      RELEASE WINDOW brwl_21
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
PROCEDURE ver_detalle
PUSH KEY CLEAR

PRIVATE m.condicion
m.condicion = ""

DEFINE WINDOW brwl_21a;
   FROM 01,00;
   TO   23,79;
   TITLE "< DETALLE >";
   SYSTEM;
   CLOSE;
   FLOAT;
   GROW;
   MDI;
   NOMINIMIZE;
   SHADOW;
   ZOOM;
   COLOR SCHEME 15

DO CASE
   CASE "Venta" $ tm_inform2.descripcio
      m.condicion = ["FACTURA" $ documento]
   CASE "Cobranza" $ tm_inform2.descripcio
      m.condicion = ["RECIBO DE DINERO" $ documento]
   CASE "Nota de Cr‚dito" $ tm_inform2.descripcio
      m.condicion = ["NOTA DE CREDITO" $ documento]
   CASE "Otras Deducciones" $ tm_inform2.descripcio
      m.condicion = [!INLIST(documento, "FACTURA CONTADO", "FACTURA CREDITO", "NOTA DE CREDITO", "RECIBO DE DINERO")]
ENDCASE

SELECT tm_informe
IF !EMPTY(m.condicion) THEN
   @ 00,00 SAY " ESC=Salir" SIZE 1,80 COLOR N/W

   BROWSE WINDOW brwl_21a FIELDS;
      b1 = LEFT(documento, 15) :R:15:H = "Documento",;
      nrodocu :R:07:H = " N£mero" :P = "9999999",;
      fechadocu :R:10:H = "  Fecha" :P = "@D",;
      monto :R:11:H = "Importe" :P = "999,999,999",;
      b2 = LEFT(cliente, 29) :R:29:H = "Cliente",;
      id_cliente :R:07:H = "Cod.Cli";
      NOAPPEND NODELETE NOMODIFY FOR &condicion

   @ 00,00 SAY " Presione la letra 'D' para ver el detalle" SIZE 1,80 COLOR N/W
ENDIF

RELEASE WINDOW brwl_21a
POP KEY