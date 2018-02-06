CLEAR ALL
CLEAR

SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON
SET EXACT   ON
SET TALK    OFF

* abrir archivos
IF !USED("cabevent") THEN
   USE cabevent IN 0 ORDER 0 AGAIN SHARED
ENDIF

IF !USED("cabecob") THEN
   USE cabecob IN 0 ORDER 0 AGAIN SHARED
ENDIF

IF !USED("cabenotc") THEN
   USE cabenotc IN 0 ORDER 0 AGAIN SHARED
ENDIF

IF !USED("cabepedc") THEN
   USE cabepedc IN 0 ORDER 0 AGAIN SHARED
ENDIF

IF !USED("cabepusd") THEN
   USE cabepusd IN 0 ORDER 0 AGAIN SHARED
ENDIF

IF !USED("cabepres") THEN
   USE cabepres IN 0 ORDER 0 AGAIN SHARED
ENDIF

IF !USED("caberemi") THEN
   USE caberemi IN 0 ORDER 0 AGAIN SHARED
ENDIF

IF !USED("clientes") THEN
   USE clientes IN 0 ORDER 0 AGAIN SHARED
ENDIF

IF !USED("lista_cl") THEN
   USE lista_cl IN 0 ORDER 0 AGAIN SHARED
ENDIF

IF !USED("ot") THEN
   USE ot IN 0 ORDER 0 AGAIN SHARED
ENDIF

IF !USED("ot2") THEN
   USE ot2 IN 0 ORDER 0 AGAIN SHARED
ENDIF

* ------------------------------------------------------------ *
WAIT "Asignando nuevos ID a la lista de clientes..." WINDOW NOWAIT

PRIVATE lnNew_ID
lnNew_ID = 20075

SELECT lista_cl
SET ORDER TO 1

SCAN ALL
   REPLACE new_id WITH lnNew_ID
   lnNew_ID = lnNew_ID + 1
ENDSCAN

WAIT CLEAR
* ------------------------------------------------------------ *
PRIVATE lnOld_ID, lnNew_ID

SELECT lista_cl
SCAN ALL
   lnOld_ID = id_cliente
   lnNew_ID = new_id

   WAIT "Procesando tabla de ventas..." WINDOW NOWAIT
   SELECT cabevent
   REPLACE cliente WITH lnNew_ID FOR cliente = lnOld_ID
   
   WAIT "Procesando tabla de cobros..." WINDOW NOWAIT
   SELECT cabecob
   REPLACE cliente WITH lnNew_ID FOR cliente = lnOld_ID
   
   WAIT "Procesando tabla de notas de cr‚ditos..." WINDOW NOWAIT
   SELECT cabenotc
   REPLACE cliente WITH lnNew_ID FOR cliente = lnOld_ID

   WAIT "Procesando tabla de pedidos en Guaran¡es..." WINDOW NOWAIT
   SELECT cabepedc
   REPLACE cliente WITH lnNew_ID FOR cliente = lnOld_ID

   WAIT "Procesando tabla de pedidos en D¢lares..." WINDOW NOWAIT
   SELECT cabepusd
   REPLACE cliente WITH lnNew_ID FOR cliente = lnOld_ID

   WAIT "Procesando tabla de presupuestos..." WINDOW NOWAIT
   SELECT cabepres
   REPLACE cliente WITH lnNew_ID FOR cliente = lnOld_ID

   WAIT "Procesando tabla de remisiones..." WINDOW NOWAIT
   SELECT caberemi
   REPLACE cliente WITH lnNew_ID FOR cliente = lnOld_ID

   WAIT "Procesando tabla de clientes..." WINDOW NOWAIT
   SELECT clientes
   REPLACE codigo WITH lnNew_ID FOR codigo = lnOld_ID

   WAIT "Procesando tabla de ordenes de trabajo..." WINDOW NOWAIT
   SELECT ot
   REPLACE cliente WITH lnNew_ID FOR cliente = lnOld_ID

   WAIT "Procesando tabla de ordenes de trabajo..." WINDOW NOWAIT
   SELECT ot2
   REPLACE cliente WITH lnNew_ID FOR cliente = lnOld_ID
ENDSCAN

WAIT "Proceso de cambio concluido exitosamente." WINDOW NOWAIT