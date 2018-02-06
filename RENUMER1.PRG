SET EXACT ON
*-- MS-DOS Apertura de bases de datos, ¡ndices, relaciones.
IF USED("maesprod")
   SELECT maesprod
   SET ORDER TO TAG indice8
ELSE
   SELECT 0
   USE (LOCFILE("maesprod.dbf","DBF","¨ D¢nde est  MAESPROD.DBF ?"));
      AGAIN ALIAS maesprod SHARED ;
      ORDER TAG indice8
ENDIF

IF USED("detamovi")
   SELECT detamovi
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("detamovi.dbf","DBF","¨ D¢nde est  DETAMOVI.DBF ?"));
      AGAIN ALIAS detamovi SHARED ;
      ORDER 0
ENDIF

IF USED("detacomp")
   SELECT detacomp
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("detacomp.dbf","DBF","¨ D¢nde est  DETACOMP.DBF ?"));
      AGAIN ALIAS detacomp SHARED ;
      ORDER 0
ENDIF

IF USED("detanotp")
   SELECT detanotp
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("detanotp.dbf","DBF","¨ D¢nde est  DETANOTP.DBF ?"));
      AGAIN ALIAS detanotp SHARED ;
      ORDER 0
ENDIF

IF USED("detavent")
   SELECT detavent
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("detavent.dbf","DBF","¨ D¢nde est  DETAVENT.DBF ?"));
      AGAIN ALIAS detavent SHARED ; 
      ORDER 0
ENDIF

IF USED("detanotc")
   SELECT detanotc
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("detanotc.dbf","DBF","¨ D¢nde est  DETANOTC.DBF ?"));
      AGAIN ALIAS detanotc SHARED ;
      ORDER 0
ENDIF

IF USED("detamot")
   SELECT detamot
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("detamot.dbf","DBF","¨ D¢nde est  DETAMOT.DBF ?"));
      AGAIN ALIAS detamot SHARED ;
      ORDER 0
ENDIF

IF USED("detapres")
   SELECT detapres
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("detapres.dbf","DBF","¨ D¢nde est  DETAPRES.DBF ?"));
      AGAIN ALIAS detapres SHARED ;
      ORDER 0
ENDIF

IF USED("detaremi")
   SELECT detaremi
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("detaremi.dbf","DBF","¨ D¢nde est  DETAREMI.DBF ?"));
      AGAIN ALIAS detaremi SHARED ;
      ORDER 0
ENDIF

IF USED("maestemp")
   SELECT maestemp
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("maestemp.dbf","DBF","¨ D¢nde est  MAESTEMP.DBF ?"));
      AGAIN ALIAS maestemp EXCLUSIVE ;
      ORDER 0
ENDIF
SET SAFETY OFF
ZAP     && Vac¡a la tabla temporal.
SET SAFETY ON
INDEX ON codigo TAG indice1 OF maestemp.cdx


SELECT maesprod 
GO TOP

PRIVATE pnCounter
pnCounter = 1

SCAN ALL
   WAIT WINDOW "PROCESANDO LA TABLA DE ARTICULOS: " + ALLTRIM(TRANSFORM(pnCounter, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) NOWAIT
   IF VAL(codigo) => 300000 .AND. VAL(codigo) <= 349999 .AND. familia = 11
      SCATTER MEMVAR MEMO
      SELECT maestemp
      APPEND BLANK
      GATHER MEMVAR MEMO
      SELECT maesprod
   ENDIF
   pnCounter = pnCounter + 1
ENDSCAN
WAIT CLEAR

SELECT maestemp
GO TOP

pnCounter      = 1
pnCodeCriteria = 100000

SCAN ALL
   WAIT WINDOW "PROCESANDO LA TABLA TEMPORAL DE ARTICULOS : " + ALLTRIM(TRANSFORM(pnCounter, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) NOWAIT
   REPLACE new_code WITH ALLTRIM(STR(pnCodeCriteria, 15))
   pnCounter      = pnCounter + 1
   pnCodeCriteria = pnCodeCriteria + 1
ENDSCAN
WAIT CLEAR

SELECT maestemp
GO TOP

pnCounter = 1

SCAN ALL
   WAIT WINDOW "PROCESANDO LA TABLA TEMPORAL DE ARTICULOS : " + ALLTRIM(TRANSFORM(pnCounter, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT("maestemp"), "999,999,999")) NOWAIT
   *-- Remplaza en la lista de art¡culos.
   SELECT maesprod
   SET ORDER TO TAG indice1
   
   IF SEEK(maestemp.codigo)
      REPLACE maesprod.codigo WITH maestemp.new_code
   ELSE
      WAIT WINDOW "­ EL ARTICULO: " + ALLTRIM(maestemp.codigo) + " NO HA SIDO ENCONTRADO !"
   ENDIF
   
   *-- Remplaza en el detalle de mov. de deposito / ajustes.
   SELECT detamovi
   GO TOP
   
   SCAN ALL
      WAIT WINDOW "PROCESANDO LA TABLA TEMPORAL DE ARTICULOS : " + ALLTRIM(TRANSFORM(pnCounter, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT("maestemp"), "999,999,999")) NOWAIT
      IF detamovi.articulo = maestemp.codigo 
         REPLACE detamovi.articulo WITH maestemp.new_code
      ENDIF
   ENDSCAN
   
   *-- Remplaza en el detalle de compras.
   SELECT detacomp
   GO TOP
   
   SCAN ALL
      WAIT WINDOW "PROCESANDO LA TABLA TEMPORAL DE ARTICULOS : " + ALLTRIM(TRANSFORM(pnCounter, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT("maestemp"), "999,999,999")) NOWAIT
      IF detacomp.articulo = maestemp.codigo 
         REPLACE detacomp.articulo WITH maestemp.new_code
      ENDIF
   ENDSCAN
   
   *-- Remplaza en el detalle de notas de deb./cred. de compras.
   SELECT detanotp
   GO TOP
   
   SCAN ALL
      WAIT WINDOW "PROCESANDO LA TABLA TEMPORAL DE ARTICULOS : " + ALLTRIM(TRANSFORM(pnCounter, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT("maestemp"), "999,999,999")) NOWAIT
      IF detanotp.articulo = maestemp.codigo 
         REPLACE detanotp.articulo WITH maestemp.new_code
      ENDIF
   ENDSCAN
      
   *-- Remplaza en el detalle de ventas.
   SELECT detavent
   GO TOP
   
   SCAN ALL
      WAIT WINDOW "PROCESANDO LA TABLA TEMPORAL DE ARTICULOS : " + ALLTRIM(TRANSFORM(pnCounter, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT("maestemp"), "999,999,999")) NOWAIT
      IF detavent.articulo = maestemp.codigo 
         REPLACE detavent.articulo WITH maestemp.new_code
      ENDIF
   ENDSCAN
   
   *-- Remplaza en el detalle de notas de deb./cred. de compras.
   SELECT detanotc
   GO TOP
   
   SCAN ALL
      WAIT WINDOW "PROCESANDO LA TABLA TEMPORAL DE ARTICULOS : " + ALLTRIM(TRANSFORM(pnCounter, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT("maestemp"), "999,999,999")) NOWAIT
      IF detanotc.articulo = maestemp.codigo 
         REPLACE detanotc.articulo WITH maestemp.new_code
      ENDIF
   ENDSCAN
  
   *-- Remplaza en el detalle de movimiento de ot.
   SELECT detamot
   GO TOP
   
   SCAN ALL
      WAIT WINDOW "PROCESANDO LA TABLA TEMPORAL DE ARTICULOS : " + ALLTRIM(TRANSFORM(pnCounter, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT("maestemp"), "999,999,999")) NOWAIT
      IF detamot.articulo = maestemp.codigo 
         REPLACE detamot.articulo WITH maestemp.new_code
      ENDIF
   ENDSCAN

   *-- Remplaza en el detalle de presupuestos.
   SELECT detapres
   GO TOP
   
   SCAN ALL
      WAIT WINDOW "PROCESANDO LA TABLA TEMPORAL DE ARTICULOS : " + ALLTRIM(TRANSFORM(pnCounter, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT("maestemp"), "999,999,999")) NOWAIT
      IF detapres.articulo = maestemp.codigo 
         REPLACE detapres.articulo WITH maestemp.new_code
      ENDIF
   ENDSCAN
   
   *-- Remplaza en el detalle de remisiones.
   SELECT detaremi
   GO TOP
   
   SCAN ALL
      WAIT WINDOW "PROCESANDO LA TABLA TEMPORAL DE ARTICULOS : " + ALLTRIM(TRANSFORM(pnCounter, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT("maestemp"), "999,999,999")) NOWAIT
      IF detaremi.articulo = maestemp.codigo 
         REPLACE detaremi.articulo WITH maestemp.new_code
      ENDIF
   ENDSCAN
   pnCounter = pnCounter + 1
ENDSCAN
WAIT CLEAR

*-- MS-DOS Cierre de bases de datos, ¡ndices, relaciones.
IF USED("maesprod")
   SELECT maesprod
   USE
ENDIF

IF USED("detamovi")
   SELECT detamovi
   USE
ENDIF

IF USED("detacomp")
   SELECT detacomp
   USE
ENDIF

IF USED("detanotp")
   SELECT detanotp
   USE
ENDIF

IF USED("detavent")
   SELECT detavent
   USE
ENDIF

IF USED("detanotc")
   SELECT detanotc
   USE
ENDIF

IF USED("detamot")
   SELECT detamot
   USE
ENDIF

IF USED("detapres")
   SELECT detapres
   USE
ENDIF

IF USED("detaremi")
   SELECT detaremi
   USE
ENDIF

IF USED("maestemp")
   SELECT maestemp
   USE
ENDIF
