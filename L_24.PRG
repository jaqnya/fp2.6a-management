*
* l_24.prg
*
* Derechos Reservados (c) 2000 - 2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Informe de pedidos de clientes pendientes de facturaci¢n.
*
* Historial de Modificacion:
* Agosto 24, 2008	Jose Avilio Acuna Acosta	Creador del Programa
*

PRIVATE m.criterio

DEFINE WINDOW l_24;
   FROM 09,14;
   TO   13,67;
   TITLE " PEDIDOS DE CLIENTES PENDIENTES DE FACTURACION ";
   SHADOW

ACTIVATE WINDOW l_24

DO WHILE .T.
   m.criterio = "H"

   @ 01,14 SAY REPLICATE(CHR(32), 5) SIZE 1,5 COLOR W/N   
   @ 01,01 SAY "Criterio:" GET m.criterio PICTURE "@!" DEFAULT 0 SIZE 1,1 VALID vldcriterio()

   READ

   IF LASTKEY() = 27 THEN
      EXIT
   ENDIF

   IF !INLIST(m.criterio, "H", "M", "T") THEN
      WAIT WINDOW "EL CRITERIO DEBE SER: (H)OY, (M)ES O (T)ODOS !"
      LOOP
   ENDIF

   IF esta_correcto() THEN
      DO inf_06 WITH m.criterio
   ENDIF
ENDDO

DEACTIVATE WINDOW l_24
RELEASE WINDOW l_24
 
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
PROCEDURE vldcriterio

@ 01,14 SAY REPLICATE(CHR(32), 5) SIZE 1,5 COLOR W/N

IF !INLIST(m.criterio, "H", "M", "T") THEN
   WAIT WINDOW "EL CRITERIO DEBE SER: (H)OY, (M)ES O (T)ODOS !"
   RETURN 0
ELSE
   @ 01,14 SAY IIF(m.criterio = "H", "HOY  ", IIF(m.criterio = "M", "MES  ", IIF(m.criterio = "T", "TODOS", "")))
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