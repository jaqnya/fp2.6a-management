PRIVATE pcCursor

IF SET("CURSOR") = "ON"
   pcCursor = "ON"
   SET CURSOR OFF
ELSE
   pcCursor = "OFF"
ENDIF

CLOSE DATABASES

*----------------------------------------------------------------------*
*                     VACIA LAS TABLAS DEL SISTEMA                     *
*----------------------------------------------------------------------*

*---------------------------------*
*             COMPRAS             *
*---------------------------------*
=CurrentTask("Borrando...")
=Local("CONSOLIDADO")

*-- Tabla: CABECOMP.DBF

=Directory(UPPER(SYS(5) + SYS(2003) + "\" + "cabecomp.dbf"))

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

DO _progress WITH (1 * 100 / 6), ""

*-- Tabla: DETACOMP.DBF

=Directory(UPPER(SYS(5) + SYS(2003) + "\" + "detacomp.dbf"))

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

DO _progress WITH (2 * 100 / 6), ""

*-- Tabla: CUOTAS_C.DBF

=Directory(UPPER(SYS(5) + SYS(2003) + "\" + "cuotas_c.dbf"))

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

DO _progress WITH (3 * 100 / 6), ""

*----------------------------------*
*              PAGOS               *
*----------------------------------*
*-- Tabla: CABEPAG.DBF

=Directory(UPPER(SYS(5) + SYS(2003) + "\" + "cabepag.dbf"))

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

=Directory(UPPER(SYS(5) + SYS(2003) + "\" + "detapag.dbf"))

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

   =Directory(UPPER(SYS(5) + SYS(2003) + "\" + "cabepag.dbf"))

   IF cabepag.id_local <> 99
      SELECT detapag

      =Directory(UPPER(SYS(5) + SYS(2003) + "\" + "detapag.dbf"))

      IF SEEK(STR(cabepag.tiporeci, 1) + STR(cabepag.nroreci, 7) + STR(cabepag.proveedor, 5))
         SCAN WHILE STR(cabepag.tiporeci, 1) + STR(cabepag.nroreci, 7) + STR(cabepag.proveedor, 5) = STR(detapag.tiporeci, 1) + STR(detapag.nroreci, 7) + STR(detapag.proveedor, 5)
            DELETE
         ENDSCAN
      ENDIF
      SELECT cabepag
      DELETE
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

DO _progress WITH (4 * 100 / 6), ""

*----------------------------------*
* NOTA DE DEB./CRED. - PROVEEDORES *
*----------------------------------*
*-- Tabla: CABENOTP.DBF

=Directory(UPPER(SYS(5) + SYS(2003) + "\" + "cabenotp.dbf"))

IF USED("cabenotp")
   SELECT cabenotp
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabenotp.dbf", "DBF", "¨ D¢nde est  CABENOTP.DBF ?")) ;
      AGAIN ALIAS cabenotp EXCLUSIVE ;
      ORDER TAG indice1
ENDIF  

*-- Tabla: DETANOTP.DBF

=Directory(UPPER(SYS(5) + SYS(2003) + "\" + "detanotp.dbf"))

IF USED("detanotp")
   SELECT detanotp
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detanotp.dbf", "DBF", "¨ D¢nde est  DETANOTP.DBF ?")) ;
      AGAIN ALIAS detanotp EXCLUSIVE ;
      ORDER TAG indice1
ENDIF  

*-- Tabla: CUOTAS_P.DBF

=Directory(UPPER(SYS(5) + SYS(2003) + "\" + "cuotas_p.dbf"))

IF USED("cuotas_p")
   SELECT cuotas_p
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cuotas_p.dbf", "DBF", "¨ D¢nde est  CUOTAS_P.DBF ?")) ;
      AGAIN ALIAS cuotas_p EXCLUSIVE ;
      ORDER TAG indice1
ENDIF  

SELECT cabenotp
GO TOP

SCAN ALL

   =Directory(UPPER(SYS(5) + SYS(2003) + "\" + "cabenotp.dbf"))

   IF cabenotp.id_local <> 99
      SELECT detanotp

      =Directory(UPPER(SYS(5) + SYS(2003) + "\" + "detanotp.dbf"))

      IF SEEK(STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5))
         SCAN WHILE STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5) = STR(detanotp.tiponota, 1) + STR(detanotp.nronota, 9) + STR(detanotp.proveedor, 5)
            DELETE
         ENDSCAN
      ENDIF

      SELECT cuotas_p

      =Directory(UPPER(SYS(5) + SYS(2003) + "\" + "cuotas_p.dbf"))

      IF SEEK(STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5))
         SCAN WHILE STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5) = STR(cuotas_p.tiponota, 1) + STR(cuotas_p.nronota, 9) + STR(cuotas_p.proveedor, 5)
            DELETE
         ENDSCAN
      ENDIF

      SELECT cabenotp
      DELETE
   ENDIF
ENDSCAN
      
IF USED("cabenotp")
   SELECT cabenotp
   PACK
   USE
ENDIF

IF USED("detanotp")
   SELECT detanotp
   PACK
   USE
ENDIF

IF USED("cuotas_p")
   SELECT cuotas_p
   PACK
   USE
ENDIF

DO _progress WITH (5 * 100 / 6), ""

*-- Tabla: MAESPROD.DBF

=Directory(UPPER(SYS(5) + SYS(2003) + "\" + "maesprod.dbf"))

IF USED("maesprod")
   SELECT maesprod
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("maesprod.dbf", "DBF", "¨ D¢nde est  MAESPROD.DBF ?")) ;
      AGAIN ALIAS maesprod EXCLUSIVE ;
      ORDER TAG indice1
ENDIF  

IF USED("maesprod")
   SELECT maesprod
   ZAP
   USE
ENDIF

DO _progress WITH (6 * 100 / 6), ""

*-- Proceso de fusi¢n.
=CurrentTask("Copiando...")

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

SCAN WHILE locales.codigo <> 99
   =Local(locales.nombre)
   *-------------------------------------------------------------------*
   *                              COMPRAS                              *
   *-------------------------------------------------------------------*
   *-- Tabla: CABECOMP.DBF

   =Directory(UPPER(ALLTRIM(locales.directory) + "cabecomp.dbf"))

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

   DO _progress WITH (1 * 100 / 6), ""
   
   *-- Tabla: DETACOMP.DBF

   =Directory(UPPER(ALLTRIM(locales.directory) + "detacomp.dbf"))

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

   DO _progress WITH (2 * 100 / 6), ""

   *-- Tabla: CUOTAS_C.DBF

   =Directory(UPPER(ALLTRIM(locales.directory) + "cuotas_c.dbf"))
   
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

   DO _progress WITH (3 * 100 / 6), ""

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

      =Directory(UPPER(ALLTRIM(locales.directory) + "cabepag.dbf"))

      IF cabepag2.id_local <> 99
         SELECT cabepag2
            SCATTER MEMVAR MEMO
   
         SELECT cabepag
            APPEND BLANK
            GATHER MEMVAR MEMO
            
         SELECT detapag2

         =Directory(UPPER(ALLTRIM(locales.directory) + "detapag.dbf"))         

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

   DO _progress WITH (4 * 100 / 6), ""


   *-------------------------------------------------------------------*
   *                 NOTA DE DEB./CRED. - PROVEEDORES                  *
   *-------------------------------------------------------------------*
   *-- Tabla: CABENOTP.DBF
   IF USED("cabenotp")
      SELECT cabenotp
      SET ORDER TO TAG indice1
   ELSE
      SELECT 0
      USE (LOCFILE("cabenotp.dbf", "DBF", "¨ D¢nde est  CABENOTP.DBF ?")) ;
         AGAIN ALIAS cabenotp EXCLUSIVE ;
         ORDER TAG indice1
   ENDIF  

   *-- Tabla: DETANOTP.DBF
   IF USED("detanotp")
      SELECT detanotp
      SET ORDER TO TAG indice1
   ELSE
      SELECT 0
      USE (LOCFILE("detanotp.dbf", "DBF", "¨ D¢nde est  DETANOTP.DBF ?")) ;
         AGAIN ALIAS detanotp EXCLUSIVE ;
         ORDER TAG indice1
   ENDIF  

   *-- Tabla: CUOTAS_P.DBF
   IF USED("cuotas_p")
      SELECT cuotas_p
      SET ORDER TO TAG indice1
   ELSE
      SELECT 0
      USE (LOCFILE("cuotas_p.dbf", "DBF", "¨ D¢nde est  CUOTAS_P.DBF ?")) ;
         AGAIN ALIAS cuotas_p EXCLUSIVE ;
         ORDER TAG indice1
   ENDIF  

   *-- Tabla: CABENOTP2.DBF
   IF USED(ALLTRIM(locales.directory) + "cabenotp2")
      SELECT cabenotp2
      SET ORDER TO TAG indice1
   ELSE
      SELECT 0
      USE (LOCFILE(ALLTRIM(locales.directory) + "cabenotp.dbf", "DBF", "¨ D¢nde est  CABENOTP.DBF ?")) ;
         AGAIN ALIAS cabenotp2 SHARED ;
         ORDER TAG indice1
   ENDIF

   *-- Tabla: DETANOTP2.DBF
   IF USED(ALLTRIM(locales.directory) + "detanotp2")
      SELECT detanotp2
      SET ORDER TO TAG indice1
   ELSE
      SELECT 0
      USE (LOCFILE(ALLTRIM(locales.directory) + "detanotp.dbf", "DBF", "¨ D¢nde est  DETANOTP.DBF ?")) ;
         AGAIN ALIAS detanotp2 SHARED ;
         ORDER TAG indice1
   ENDIF

   *-- Tabla: CUOTAS_P2.DBF
   IF USED(ALLTRIM(locales.directory) + "cuotas_p2")
      SELECT cuotas_p2
      SET ORDER TO TAG indice1
   ELSE
      SELECT 0
      USE (LOCFILE(ALLTRIM(locales.directory) + "cuotas_p.dbf", "DBF", "¨ D¢nde est  CUOTAS_P.DBF ?")) ;
         AGAIN ALIAS cuotas_p2 SHARED ;
         ORDER TAG indice1
   ENDIF

   SELECT cabenotp2
   GO TOP
   
   SCAN ALL

      =Directory(UPPER(ALLTRIM(locales.directory) + "cabenotp.dbf"))

      IF cabenotp2.id_local <> 99
         SELECT cabenotp2
            SCATTER MEMVAR MEMO
   
         SELECT cabenotp
            APPEND BLANK
            GATHER MEMVAR MEMO
            
         SELECT detanotp2

         =Directory(UPPER(ALLTRIM(locales.directory) + "detanotp.dbf"))         

         IF SEEK(STR(cabenotp2.tiponota, 1) + STR(cabenotp2.nronota, 9) + STR(cabenotp2.proveedor, 5))
            SCAN WHILE STR(cabenotp2.tiponota, 1) + STR(cabenotp2.nronota, 9) + STR(cabenotp2.proveedor, 5) = STR(detanotp2.tiponota, 1) + STR(detanotp2.nronota, 9) + STR(detanotp2.proveedor, 5)
               SELECT detanotp2
                  SCATTER MEMVAR MEMO
               
               SELECT detanotp
                  APPEND BLANK
                  GATHER MEMVAR MEMO
               
               SELECT detanotp2
            ENDSCAN
         ENDIF

         SELECT cuotas_p2

         =Directory(UPPER(ALLTRIM(locales.directory) + "cuotas_p.dbf"))         

         IF SEEK(STR(cabenotp2.tiponota, 1) + STR(cabenotp2.nronota, 9) + STR(cabenotp2.proveedor, 5))
            SCAN WHILE STR(cabenotp2.tiponota, 1) + STR(cabenotp2.nronota, 9) + STR(cabenotp2.proveedor, 5) = STR(cuotas_p2.tiponota, 1) + STR(cuotas_p2.nronota, 9) + STR(cuotas_p2.proveedor, 5)
               SELECT cuotas_p2
                  SCATTER MEMVAR MEMO
               
               SELECT cuotas_p
                  APPEND BLANK
                  GATHER MEMVAR MEMO
               
               SELECT cuotas_p2
            ENDSCAN
         ENDIF

         SELECT cabenotp2
      ENDIF
   ENDSCAN

   IF USED("cabenotp")
      SELECT cabenotp
      USE
   ENDIF

   IF USED("detanotp")
      SELECT detanotp
      USE
   ENDIF

   IF USED("cuotas_p")
      SELECT cuotas_p
      USE
   ENDIF

   IF USED("cabenotp2")
      SELECT cabenotp2
      USE
   ENDIF

   IF USED("detanotp2")
      SELECT detanotp2
      USE
   ENDIF

   IF USED("cuotas_p2")
      SELECT cuotas_p2
      USE
   ENDIF

   DO _progress WITH (5 * 100 / 6), ""

   *-- Tabla: MAESPROD.DBF
   IF USED("maesprod")
      SELECT maesprod
      SET ORDER TO TAG indice1
   ELSE
      SELECT 0
      USE (LOCFILE("maesprod.dbf", "DBF", "¨ D¢nde est  MAESPROD.DBF ?")) ;
         AGAIN ALIAS maesprod SHARED ;
         ORDER TAG indice1
   ENDIF

   IF USED(ALLTRIM(locales.directory) + "maesprod2")
      SELECT maesprod2
      SET ORDER TO TAG indice1
   ELSE
      SELECT 0
      USE (LOCFILE(ALLTRIM(locales.directory) + "maesprod.dbf", "DBF", "¨ D¢nde est  MAESPROD.DBF ?")) ;
         AGAIN ALIAS maesprod2 SHARED ;
         ORDER TAG indice1
   ENDIF
   GO TOP
   
   SCAN ALL

      =Directory(UPPER(ALLTRIM(locales.directory) + "maesprod.dbf"))

      SELECT maesprod
      IF .NOT. SEEK(maesprod2.codigo)
         SELECT maesprod2
            SCATTER MEMVAR MEMO
               
         SELECT maesprod
            APPEND BLANK
            GATHER MEMVAR MEMO
      ENDIF
      SELECT maesprod2
   ENDSCAN
   
   IF USED("maesprod")
      SELECT maesprod
      USE
   ENDIF

   IF USED("maesprod2")
      SELECT maesprod2
      USE
   ENDIF

   DO _progress WITH (6 * 100 / 6), ""

   SELECT locales
ENDSCAN

@ 02,04 SAY REPLICATE(CHR(32), 31) ;
   SIZE 1,31 ;
   PICTURE "@!" ;
   COLOR W/N

@ 02,42 SAY REPLICATE(CHR(32), 17) ;
   SIZE 1,17 ;
   PICTURE "@!" ;
   COLOR W/N

@ 05,04 SAY REPLICATE(CHR(32), 55) ;
   SIZE 1,55 ;
   PICTURE "@!" ;
   COLOR W/N

@ 08,04 SAY "  0% " + REPLICATE("-", 50) ;
   SIZE 1,55 ;
   PICTURE "@!" ;
   COLOR W/N

IF pcCursor = "ON"
   SET CURSOR ON
ENDIF

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

*!**************************************************************************
*!
*!  PROCEDIMIENTO: _CurrentTask   
*!
*!    DESCRIPCION: Imprime el tarea actual.
*!
*!**************************************************************************
FUNCTION CurrentTask
PARAMETER pcCurrentTask
@ 02,04 SAY PADR(pcCurrentTask, 31, CHR(32)) ;
   SIZE 1,31 ;
   COLOR W/N

*!**************************************************************************
*!
*!  PROCEDIMIENTO: _Local         
*!
*!    DESCRIPCION: Imprime el nombre del local.
*!
*!**************************************************************************
FUNCTION Local        
PARAMETER pcLocal         
@ 02,42 SAY PADR(pcLocal, 17, CHR(32)) ;
   SIZE 1,17 ;
   COLOR W/N

*!**************************************************************************
*!
*!  PROCEDIMIENTO: _Directory     
*!
*!    DESCRIPCION: Imprime el directorio del cual se est n importando los
*!                 datos.
*!
*!**************************************************************************
FUNCTION Directory  
PARAMETER pcDirectory   
@ 05,04 SAY PADR(pcDirectory, 55, CHR(32)) ;
   SIZE 1,55 ;
   COLOR W/N
   
*!**************************************************************************
*!
*!  PROCEDIMIENTO: _Progress     
*!
*!    DESCRIPCION: Barra de progreso.
*!
*!**************************************************************************
PROCEDURE _Progress
PARAMETERS m.prcnt, m.message

IF EMPTY(m.message)                              && Default message
   m.message = ""
ENDIF

m.message = LEFT(ALLTRIM(m.message), 58)         && Truncate extra characters.

IF EMPTY(m.prcnt)                                && Default Percent complete to 0
   m.prcnt = 0
ENDIF

IF m.prcnt < 0                                   && Release & clear progress window when done.
   RETURN
ENDIF

IF m.prcnt > 100                                 && Prevent >100% thermometer.
   m.prcnt = 100
ENDIF

m.prcnt = ROUND(m.prcnt, 0)                      && Round off any decimal places

* @ 00,01 SAY PADC(m.message, 58)                && Activate, if you want to print the message.

@ 08,04 SAY TRANSFORM(m.prcnt,"999")+"% " + ;
   REPLICATE("Û",INT(m.prcnt/2))+REPLICATE("-",50-INT(m.prcnt/2))