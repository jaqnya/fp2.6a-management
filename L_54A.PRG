SELECT temporal
ZAP

SELECT vendedor
SET ORDER TO TAG indice1

SELECT cabenotc
SET ORDER TO TAG indice3

SELECT detavent
SET ORDER TO TAG indice1

STORE 0 TO mmonto

SELECT cabevent
SET RELATION TO vendedor INTO vendedor
SET ORDER TO TAG indice2
GOTO TOP

nCounter = 0

DO WHILE (fechadocu <= mfecha2 .AND. .NOT. EOF())
   nCounter = nCounter + 1
   WAIT WINDOW NOWAIT "1/2 - PROCESANDO EL ARCH. DE VENTAS: " + ;
      ALLTRIM(TRANSFORM(nCounter, "999,999,999")) + "/" + ;
      ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999"))
   
   auxicar = vendedor.nombre
   
   IF (fechadocu > = mfecha1 .AND. (.NOT. anulado) .AND. mnombre1 <= ;
      auxicar .AND. auxicar <= mnombre2)
      mporcdesc2 = calcdesc2()
      IF mopcion1 = "N"
         DO l_54aa
      ELSE
         DO l_54ab
      ENDIF
      SELECT cabevent
   ENDIF
   SKIP 1
ENDDO

SET ORDER TO TAG indice1
SET RELATION TO

KEYBOARD "{SPACEBAR}"

WAIR WINDOW ""

IF (mopcion1 = "S")
   SELECT temporal
   GOTO TOP
   DO WHILE .NOT. EOF()
      mtipodocu = tipodocu
      mnrodocu  = nrodocu
      SKIP 1
      DO WHILE (mtipodocu = tipodocu .AND. mnrodocu = nrodocu .AND. .NOT. EOF())
         REPLACE monto_fact WITH 0
         REPLACE monto_ndeb WITH 0
         REPLACE monto_ncre WITH 0
         SKIP 1
      ENDDO
   ENDDO
ENDIF

RETURN
*
PROCEDURE l_54aa

SELECT detavent
SEEK STR(cabevent.tipodocu, 1) + STR(nrodocu, 7)
DO WHILE (cabevent.tipodocu = tipodocu .AND. cabevent.nrodocu = nrodocu .AND. .NOT. EOF())
   SELECT temporal
   SET ORDER TO TAG indice1
   SEEK STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)
   IF .NOT. FOUND()
      APPEND BLANK
      REPLACE cliente WITH cabevent.cliente
      REPLACE vendedor WITH cabevent.vendedor
      REPLACE comision WITH cabevent.comision_v
      REPLACE nombre WITH ALLTRIM(vendedor.nombre)
      REPLACE tipodocu WITH cabevent.tipodocu
      REPLACE nrodocu WITH cabecent.nrodocu
      REPLACE fechadocu WITH cabevent.fechadocu
      REPLACE dias_plazo WITH cabevent.dias_plazo
   ENDIF
   
   DO CASE
      CASE (cabevent.tipodocu = 1 .OR. cabevent.tipodocu = 3 .OR. ;
            cabevent.tipodocu = 4)
            REPLACE monto1 WITH monto1 + (ROUND((detavent.cantidad
            exit
            