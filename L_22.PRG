*
* l_22.prg
*
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Informe de articulos vendidos a un cliente
*
* Historial de Modificacion:
* Agosto 24, 2008	Jose Avilio Acuna Acosta	Creador del Programa
*

PRIVATE m.cliente

DEFINE WINDOW l_21;
   FROM 09,14;
   TO   13,67;
   TITLE " ARTICULOS VENDIDOS A UN CLIENTE ";
   SHADOW

ACTIVATE WINDOW l_21

DO WHILE .T.
   m.cliente = 0

   @ 01,18 SAY REPLICATE(CHR(32), 32) SIZE 1,32 COLOR W/N   
   @ 01,01 SAY "Cliente: " GET m.cliente PICTURE "99999" DEFAULT 0 SIZE 1,5 VALID vldcliente()

   READ

   IF LASTKEY() = 27 THEN
      EXIT
   ENDIF

   IF EMPTY(m.cliente) THEN
      WAIT WINDOW "LA FECHA NO PUEDE QUEDAR EN BLANCO !"
      LOOP
   ENDIF

   IF esta_correcto() THEN
      DO inf_05 WITH m.cliente
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
PROCEDURE vldcliente

@ 01,18 SAY REPLICATE(CHR(32), 32) SIZE 1,32 COLOR W/N

IF m.cliente <= 0 THEN
   DO buscclie WITH "m.cliente"
   SET COLOR OF SCHEME 1 TO W/N,N/W,W/N,N/W,W/N,W+/B,W/N,N+/N,W/N,W/N,-
ENDIF

IF m.cliente = 0
   RETURN 0
ENDIF

SELECT clientes
SET ORDER TO 1
IF SEEK(m.cliente) THEN
   @ 01,18 SAY LEFT(look_up("nombre", "clientes", m.cliente), 32) SIZE 1,32 COLOR W/N
ELSE
   WAIT "CODIGO DE CLIENTE INEXISTENTE !" WINDOW
   RETURN 0
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