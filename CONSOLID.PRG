CLOSE DATABASES

*----------------------------------------------------------------------*
*                     VACIA LAS TABLAS DEL SISTEMA                     *
*----------------------------------------------------------------------*

*-------------------------------*
*            COMPRAS            *
*-------------------------------*
*-- Tabla: CABECOMP.DBF
IF USED("cabecomp")
   SELECT cabecomp
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabecomp.dbf", "DBF", "¨ D¢nde est  CABECOMP.DBF ?")) ;
      AGAIN ALIAS cabecomp EXCLUSIVE ;
      ORDER TAG indice1
ENDIF  

IF USED("cabecomp")
   SELECT cabecomp
   ZAP
   USE
ENDIF

*-- Tabla: DETACOMP.DBF
IF USED("detacomp")
   SELECT detacomp
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detacomp.dbf", "DBF", "¨ D¢nde est  DETACOMP.DBF ?")) ;
      AGAIN ALIAS detacomp EXCLUSIVE ;
      ORDER TAG indice1
ENDIF  

IF USED("detacomp")
   SELECT detacomp
   ZAP
   USE
ENDIF

*-- Tabla: CUOTAS_C.DBF
IF USED("cuotas_c")
   SELECT cuotas_c
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cuotas_c.dbf", "DBF", "¨ D¢nde est  CUOTAS_C.DBF ?")) ;
      AGAIN ALIAS cuotas_c EXCLUSIVE ;
      ORDER TAG indice1
ENDIF  

IF USED("cuotas_c")
   SELECT cuotas_c
   ZAP
   USE
ENDIF

*--------------------------------*
*             PAGOS              *
*--------------------------------*
*-- Tabla: CABEPAG.DBF
IF USED("cabepag")
   SELECT cabepag
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabepag.dbf", "DBF", "¨ D¢nde est  CABEPAG.DBF ?")) ;
      AGAIN ALIAS cabepag EXCLUSIVE ;
      ORDER TAG indice1
ENDIF  

*-- Tabla: DETAPAG.DBF
IF USED("detapag")
   SELECT detapag
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detapag.dbf", "DBF", "¨ D¢nde est  DETAPAG.DBF ?")) ;
      AGAIN ALIAS detapag EXCLUSIVE ;
      ORDER TAG indice1
ENDIF  

SELECT cabepag
GO TOP

SCAN ALL
   IF cabepag.id_local <> 99
      SELECT detapag
      IF SEEK(STR(cabepag.tiporeci, 1) + STR(cabepag.nroreci, 7) + STR(cabepag.proveedor, 5))
         SCAN WHILE STR(cabepag.tiporeci, 1) + STR(cabepag.nroreci, 7) + STR(cabepag.proveedor, 5) = STR(detapag.tiporeci, 1) + STR(detapag.nroreci, 7) + STR(detapag.proveedor, 5)
            DELETE
         ENDSCAN
      ENDIF
      SELECT cabepag
   ENDIF
ENDSCAN
      
IF USED("cabepag")
   SELECT cabepag
   PACK
   USE
ENDIF

IF USED("detapag")
   SELECT detapag
   PACK
   USE
ENDIF

*-- Proceso principal de fusi¢n.
IF USED("locales")
   SELECT locales
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("locales.dbf", "DBF", "¨ D¢nde est  LOCALES.DBF ?")) ;
      AGAIN ALIAS locales SHARED ;
      ORDER TAG indice1
ENDIF
GO TOP

SCAN ALL
   WAIT WINDOW locales.nombre NOWAIT
   *-------------------------------------------------------------------*
   *                              COMPRAS                              *
   *-------------------------------------------------------------------*
   *-- Tabla: CABECOMP.DBF
   IF USED("cabecomp")
      SELECT cabecomp
      SET ORDER TO TAG indice1
   ELSE
      SELECT 0
      USE (LOCFILE("cabecomp.dbf", "DBF", "¨ D¢nde est  CABECOMP.DBF ?")) ;
         AGAIN ALIAS cabecomp EXCLUSIVE ;
         ORDER TAG indice1
   ENDIF  
   
   APPEND FROM ALLTRIM(locales.directory) + "cabecomp.dbf"
   
   IF USED("cabecomp")
      SELECT cabecomp
      USE
   ENDIF
   
   *-- Tabla: DETACOMP.DBF
   IF USED("detacomp")
      SELECT detacomp
      SET ORDER TO TAG indice1
   ELSE
      SELECT 0
      USE (LOCFILE("detacomp.dbf", "DBF", "¨ D¢nde est  DETACOMP.DBF ?")) ;
         AGAIN ALIAS detacomp EXCLUSIVE ;
         ORDER TAG indice1
   ENDIF  
   
   APPEND FROM ALLTRIM(locales.directory) + "detacomp.dbf"
   
   IF USED("detacomp")
      SELECT detacomp
      USE
   ENDIF

   *-- Tabla: CUOTAS_C.DBF
   IF USED("cuotas_c")
      SELECT cuotas_c
      SET ORDER TO TAG indice1
   ELSE
      SELECT 0
      USE (LOCFILE("cuotas_c.dbf", "DBF", "¨ D¢nde est  CUOTAS_C.DBF ?")) ;
         AGAIN ALIAS cuotas_c EXCLUSIVE ;
         ORDER TAG indice1
   ENDIF  
   
   APPEND FROM ALLTRIM(locales.directory) + "cuotas_c.dbf"
   
   IF USED("cuotas_c")
      SELECT cuotas_c
      USE
   ENDIF

   *-------------------------------------------------------------------*
   *                               PAGOS                               *
   *-------------------------------------------------------------------*
   *-- Tabla: CABEPAG.DBF
   IF USED("cabepag")
      SELECT cabepag
      SET ORDER TO TAG indice1
   ELSE
      SELECT 0
      USE (LOCFILE("cabepag.dbf", "DBF", "¨ D¢nde est  CABEPAG.DBF ?")) ;
         AGAIN ALIAS cabepag EXCLUSIVE ;
         ORDER TAG indice1
   ENDIF  

   *-- Tabla: DETAPAG.DBF
   IF USED("detapag")
      SELECT detapag
      SET ORDER TO TAG indice1
   ELSE
      SELECT 0
      USE (LOCFILE("detapag.dbf", "DBF", "¨ D¢nde est  DETAPAG.DBF ?")) ;
         AGAIN ALIAS detapag EXCLUSIVE ;
         ORDER TAG indice1
   ENDIF  

   *-- Tabla: CABEPAG2.DBF
   IF USED(ALLTRIM(locales.directory) + "cabepag2")
      SELECT cabepag2
      SET ORDER TO TAG indice1
   ELSE
      SELECT 0
      USE (LOCFILE(ALLTRIM(locales.directory) + "cabepag.dbf", "DBF", "¨ D¢nde est  CABEPAG.DBF ?")) ;
         AGAIN ALIAS cabepag2 SHARED ;
         ORDER TAG indice1
   ENDIF

   *-- Tabla: DETAPAG2.DBF
   IF USED(ALLTRIM(locales.directory) + "detapag2")
      SELECT detapag2
      SET ORDER TO TAG indice1
   ELSE
      SELECT 0
      USE (LOCFILE(ALLTRIM(locales.directory) + "detapag.dbf", "DBF", "¨ D¢nde est  DETAPAG.DBF ?")) ;
         AGAIN ALIAS detapag2 SHARED ;
         ORDER TAG indice1
   ENDIF

   SELECT cabepag2
   GO TOP
   
   SCAN ALL
      IF cabepag2.id_local <> 99
         SELECT cabepag2
            SCATTER MEMVAR MEMO
   
         SELECT cabepag
            APPEND BLANK
            GATHER MEMVAR MEMO
            
         SELECT detapag2
         IF SEEK(STR(cabepag2.tiporeci, 1) + STR(cabepag2.nroreci, 7) + STR(cabepag2.proveedor, 5))
            SCAN WHILE STR(cabepag2.tiporeci, 1) + STR(cabepag2.nroreci, 7) + STR(cabepag2.proveedor, 5) = STR(detapag2.tiporeci, 1) + STR(detapag2.nroreci, 7) + STR(detapag2.proveedor, 5)
               SELECT detapag2
                  SCATTER MEMVAR MEMO
               
               SELECT detapag
                  APPEND BLANK
                  GATHER MEMVAR MEMO
               
               SELECT detapag2
            ENDSCAN
         ENDIF

         SELECT cabepag2
      ENDIF
   ENDSCAN

   IF USED("cabepag")
      SELECT cabepag
      USE
   ENDIF

   IF USED("detapag")
      SELECT detapag
      USE
   ENDIF

   IF USED("cabepag2")
      SELECT cabepag2
      USE
   ENDIF

   IF USED("detapag2")
      SELECT detapag2
      USE
   ENDIF

   SELECT locales
ENDSCAN





*  *-- Tabla: BARRIOS.DBF
*  IF USED("barrios")
*     SELECT barrios
*     SET ORDER TO TAG indice1
*  ELSE
*     SELECT 0
*     USE (LOCFILE("barrios.dbf", "DBF", "¨ D¢nde est  BARRIOS.DBF ?")) ;
*        AGAIN ALIAS barrios SHARED ;
*        ORDER TAG indice1
*  ENDIF

*  IF USED(ALLTRIM(locales.directory) + "barrios2")
*     SELECT barrios2
*     SET ORDER TO TAG indice1
*  ELSE
*     SELECT 0
*     USE (LOCFILE(ALLTRIM(locales.directory) + "barrios.dbf", "DBF", "¨ D¢nde est  BARRIOS.DBF ?")) ;
*        AGAIN ALIAS barrios2 SHARED ;
*        ORDER TAG indice1
*  ENDIF
*  GO TOP
   
*  SCAN ALL
*     SELECT barrios 
*     IF .NOT. SEEK(barrios2.codigo)
*        INSERT INTO barrios (codigo, nombre, departamen, ciudad, vigente, id_local) ;
*           VALUES (barrios2.codigo, barrios2.nombre, barrios2.departamen, barrios2.ciudad, barrios2.vigente, barrios2.id_local)
*     ENDIF

*     SELECT barrios2
*  ENDSCAN
   
*  IF USED("barrios")
*     SELECT barrios
*     USE
*  ENDIF

*  IF USED("barrios2")
*     SELECT barrios2
*     USE
*  ENDIF
