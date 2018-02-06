PRIVATE m.fecha_desde, m.fecha_hasta, m.destino, m.archi_01, m.archi_02

STORE "P" TO m.destino
STORE DATE() TO m.fecha_desde, m.fecha_hasta
STORE " " TO m.archi_01, m.archi_02

DO load
DO init

IF !WVISIBLE("frameInfor") THEN
   ACTIVATE WINDOW frameInfor
ENDIF

IF !WEXIST("dlgParam") THEN
   DEFINE WINDOW dlgParam ;
      FROM INT((SROW()-5)/2),INT((SCOL()-40)/2) ;
      TO INT((SROW()-5)/2)+6,INT((SCOL()-40)/2)+39 ;
      TITLE "[ INFORME DE INGRESOS ]" ;
      NOCLOSE ;
      NOFLOAT ;
      NOGROW ;
      NOMDI ;
      NOMINIMIZE ;
      SHADOW ;
      NOZOOM
ENDIF

IF WVISIBLE("dlgParam") THEN
   ACTIVATE WINDOW dlgParam SAME
ELSE
   ACTIVATE WINDOW dlgParam NOSHOW
ENDIF

@ 01,02 SAY "DESDE..:" SIZE 1,8 COLOR BG+/B
@ 01,11 GET m.fecha_desde PICTURE "@D" DEFAULT CTOD("  /  /    ") SIZE 1,10 
@ 02,02 SAY "HASTA..:" SIZE 1,8 COLOR BG+/B
@ 02,11 GET m.fecha_hasta PICTURE "@D" DEFAULT CTOD("  /  /    ") SIZE 1,10 VALID vldfecha_hasta()
@ 03,02 SAY "DESTINO:" SIZE 1,8 COLOR BG+/B
@ 03,13 SAY "(P)antalla, (I)mpresora" SIZE 1,23 COLOR W+/B
@ 03,11 GET m.destino PICTURE "@!" DEFAULT " " SIZE 1,1 VALID vlddestino() 

IF !WVISIBLE("dlgParam") THEN
   ACTIVATE WINDOW dlgParam
ENDIF

READ CYCLE MODAL

RELEASE WINDOW dlgParam

DO unload

*--------------------------------------------------------------------------*
PROCEDURE load

SET CENTURY    ON
SET DATE       BRITISH
SET DELETED    ON
SET EXACT      OFF
SET NOTIFY     ON
SET SAFETY     OFF
SET STATUS BAR OFF
SET SYSMENU    OFF
SET TALK       OFF
=CAPSLOCK(.T.)
=INSMODE(.T.)

IF !USED("cabevent") THEN
   USE cabevent IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabeven2") THEN
   USE cabeven2 IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("cabecob") THEN
   USE cabecob IN 0 AGAIN ORDER 1 SHARED
ENDIF

IF !USED("form_cob") THEN
   USE form_cob IN 0 AGAIN ORDER 0 SHARED
ENDIF

IF !USED("clientes") THEN
   USE clientes IN 0 AGAIN ORDER 1 SHARED
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE unload

SET NOTIFY OFF

IF USED("cabevent") THEN
   SELECT cabevent
*   USE
ENDIF

IF USED("cabeven2") THEN
   SELECT cabeven2
*   USE
ENDIF

IF USED("cabecob") THEN
   SELECT cabecob
*   USE
ENDIF

IF USED("form_cob") THEN
   SELECT form_cob
*   USE
ENDIF

IF USED("clientes") THEN
   SELECT clientes
*   USE
ENDIF

SET COLOR OF SCHEME 1 TO W/N,N/W,W/N,N/W,W/N,W+/B,W/N,N+/N,W/N,W/N,-

DO borratemp WITH m.archi_01
DO borratemp WITH m.archi_02

RELEASE WINDOW frameInfor

*--------------------------------------------------------------------------*
PROCEDURE init

SET COLOR OF SCHEME 1 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,,R+/B,+

IF !WEXIST("frameInfor") THEN
   DEFINE WINDOW frameInfor ;
      FROM 00,00 ;
      TO 24,79 ;
      TITLE "" ;
      NONE ;
      NOCLOSE ;
      NOFLOAT ;
      NOGROW ;
      NOMDI ;
      NOMINIMIZE ;
      NOSHADOW ;
      NOZOOM ;
      COLOR W+/B
ENDIF

IF WVISIBLE("frameInfor") THEN
   ACTIVATE WINDOW frameInfor SAME
ELSE
   ACTIVATE WINDOW frameInfor NOSHOW
ENDIF

@ 00,00 TO 00,79 " " COLOR N/W
DO center WITH 0, " A & A IMPORTACIONES S.R.L. ", "N/W"
@ 01,00,23,79 BOX REPLICATE(CHR(178), 8) + CHR(178)
@ 01,00 FILL TO 23,79 COLOR BG/B
@ 24,00 TO 24,79 " " COLOR N/W

*--------------------------------------------------------------------------*
FUNCTION createmp
PRIVATE m.retorno

DO WHILE .T.
   m.retorno = "tm" + RIGHT(SYS(3), 6)
   IF !FILE(m.retorno + ".dbf") AND !FILE(m.retorno + ".cdx") AND !FILE(m.retorno + ".txt") THEN
      EXIT
   ENDIF
ENDDO

RETURN m.retorno

*--------------------------------------------------------------------------*
PROCEDURE borratemp
PARAMETER m.archivo

PRIVATE m.architm1, m.architm2, m.architm3

m.architm1 = m.archivo + ".dbf"
m.architm2 = m.archivo + ".cdx"
m.architm3 = m.archivo + ".txt"

IF FILE(m.architm1) THEN
   DELETE FILE (m.architm1)
ENDIF

IF FILE(m.architm2) THEN
   DELETE FILE (m.architm2)
ENDIF

IF FILE(m.architm3) THEN
   DELETE FILE (m.architm3)
ENDIF

*--------------------------------------------------------------------------*
PROCEDURE center
PARAMETERS m.row, m.text, m.color
m.column = 40 - (LEN(m.text) / 2)
@ m.row, m.column SAY m.text COLOR (m.color)

*--------------------------------------------------------------------------*
FUNCTION vldfecha_hasta

IF m.fecha_desde > m.fecha_hasta THEN
   WAIT "LA FECHA FINAL DEBE SER MAYOR O IGUAL A LA INICIAL !" WINDOW 
   RETURN 0
ENDIF

*--------------------------------------------------------------------------*
FUNCTION vlddestino

IF !INLIST(m.destino, "P", "I") THEN
   WAIT "EL DESTINO DEBE SER: (P)ANTALLA O (I)MPRESORA !" WINDOW
   RETURN 0
ENDIF

DO runQuery

*--------------------------------------------------------------------------*
FUNCTION messagebox
PARAMETER m.text, m.type

PRIVATE m.return

DO CASE
   CASE m.type = 48
      DO WHILE .T.
         WAIT m.text + " [S/N]" TO m.return WINDOW
         m.return = UPPER(m.return)
   
         IF INLIST(m.return, "S", "N") THEN
            EXIT
         ENDIF
      ENDDO
         
      IF m.return = "S" THEN
         m.return = 6
      ELSE
         m.return = 7
      ENDIF
      
      RETURN m.return
ENDCASE

*--------------------------------------------------------------------------*
PROCEDURE runQuery
IF messagebox("ESTA CORRECTO ?", 48) <> 6 THEN
   _CUROBJ = OBJNUM(m.fecha_desde)
   RETURN
ENDIF

WAIT "PROCESANDO..." WINDOW NOWAIT

* Procesa la tabla de ventas
STORE createmp() TO m.archi_01

SELECT cabevent.tipodocu, cabevent.nrodocu, cabevent.fechadocu, cabevent.monto_fact, ;
       cabevent.cliente, clientes.nombre AS nom_clie, cabevent.fechaanu, cabevent.anulado;
   FROM cabevent, clientes ;
   INTO TABLE m.archi_01 ;
   WHERE cabevent.cliente = clientes.codigo ;
     AND BETWEEN(cabevent.fechadocu, m.fecha_desde, m.fecha_hasta) ;
   ORDER BY cabevent.nrodocu

* Procesa la tabla de ventas (anulados)
STORE createmp() TO m.archi_02

SELECT cabevent.tipodocu, cabevent.nrodocu, cabevent.fechadocu, cabevent.monto_fact, ;
       cabevent.cliente, "A N U L A D O" AS nom_clie, cabevent.fechaanu, cabevent.anulado;
   FROM cabevent ;
   INTO TABLE m.archi_02 ;
   WHERE BETWEEN(cabevent.fechaanu, m.fecha_desde, m.fecha_hasta) ;
   ORDER BY cabevent.nrodocu


WAIT CLEAR
wait window dbf()
browse
