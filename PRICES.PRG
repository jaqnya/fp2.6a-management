*
* PRICES.PRG - Actualizador de precios.
*

* Definici¢n de constantes.
#DEFINE C_EXIT    		"¨ DESEA SALIR DE ESTE MENU ?"
#DEFINE C_AREYOUSURE    "¨ ESTA USTED SEGURO ?"
#DEFINE C_UPDATEPRICES  "¨ DESEA ACTUALIZAR LOS PRECIOS ?"
#DEFINE C_MESSA_01      "NO SE HAN ENCONTRADO VARIACIONES DE PRECIO."
#DEFINE C_MESSA_02      "PROCESO DE ACTUALIZACION CONCLUIDO."

* Definici¢n de variables.
PRIVATE cWindow01, gcCompany, cSetTalk, cSetNotify, cSetClock, cSetSafety, cSetCentury, cSetDate, cSetEscape, cSetDeleted, nOption

STORE LOWER(SYS(2015)) TO cWindow01
STORE "ALBEN S.R.L."   TO gcCompany
STORE ""               TO cSetTalk, cSetNotify, cSetClock, cSetSafety, cSetCentury, cSetDate, cSetEscape, cSetDeleted
STORE 0                TO nOption
* C¢digo de configuraci¢n.
=Setup()

DO WHILE .T.
   STORE 0 TO nOption
   
   @ 06,25 PROMPT " \<1. RECUPERACION DE DATOS   " COLOR W/N,W/B,W/N,N/W,   ,N/W,W+/B,  ,   ,- 
   @ 12,25 PROMPT " \<2.  ACTUALIZAR PRECIOS     " COLOR W/N,W/B,W/N,N/W,   ,N/W,W+/B,  ,   ,- 
   @ 18,25 PROMPT " \<0.  SALIR DE ESTE MENU     " COLOR W/N,W/B,W/N,N/W,   ,N/W,W+/B,  ,   ,- 

   MENU TO nOption
   
   DO CASE
      CASE INLIST(nOption, 0, 3)     && 0. SALIR DE ESTE MENU.
         IF MsgBox(C_EXIT, "", 4, "MESSAGE", "C") = 6
            EXIT DO 
         ENDIF         
      CASE nOption = 1     && 1. RECUPERACION DE DATOS.
         =Recover()
      CASE nOption = 2     && 1. RECUPERACION DE DATOS.
         =Actualizar()
   ENDCASE
ENDDO

* C¢digo de limpieza.
=Cleanup()


* +-------------------------------------------------------------+
* |  MS-DOS© Procedimientos y funciones del soporte.            |
* +-------------------------------------------------------------+

*
* SETUP - C¢digo de configuraci¢n.                             
*
PROCEDURE Setup

CLOSE DATABASES

* Establece el entorno de trabajo.
IF SET("TALK") = "ON"
   SET TALK OFF
   cSetTalk = "ON"
ELSE
   cSetTalk = "OFF"
ENDIF

IF SET("NOTIFY") = "ON"
   SET NOTIFY OFF
   cSetNotify = "ON"
ELSE
   cSetNotify = "OFF"
ENDIF

IF SET("CLOCK") = "OFF"
   SET CLOCK ON 
   cSetClock = "OFF"
ELSE
   cSetClock = "ON"
ENDIF

IF SET("SAFETY") = "ON"
   SET SAFETY OFF
   cSetSafety = "ON"
ELSE
   cSetSafety = "OFF"
ENDIF

IF SET("CENTURY") = "OFF"
   SET CENTURY ON
   cSetCentury = "OFF"
ELSE
   cSetCentury = "ON"
ENDIF

IF SET("DATE") <> "BRITISH"
   cSetDate = SET("DATE")
   SET DATE BRITISH
ELSE
   cSetDate = "BRITISH"
ENDIF

IF SET("ESCAPE") = "ON"
   SET ESCAPE OFF
   cSetEscape = "ON"
ELSE
   cSetEscape = "OFF"
ENDIF

IF SET("DELETED") = "OFF"
   SET DELETED ON
   cSetDeleted = "OFF"
ELSE
   cSetDeleted = "ON"
ENDIF

* Definici¢n de ventana(s).
IF .NOT. WEXIST(cWindow01)
   DEFINE WINDOW (cWindow01) ;
      FROM INT((SROW()-25)/2),INT((SCOL()-80)/2) ;
      TO INT((SROW()-25)/2)+24,INT((SCOL()-80)/2)+79 ;
      NONE ;
      NOCLOSE ;
      NOFLOAT ;
      NOGROW ;
      NOMDI ;
      NOMINIMIZE ;
      NOSHADOW ;
      NOZOOM ;
      COLOR "W/B,B/W,W/B,B/W,R/W,B/W,GR+/B,,W/B,R+/B,+"
ENDIF

*IF WVISIBLE(cWindow01)
*   ACTIVATE WINDOW (cWindow01) SAME
*ELSE
*   ACTIVATE WINDOW (cWindow01) NOSHOW
*ENDIF

* Limpia la pantalla.
CLEAR

* Dibuja el fondo.
@ 01,00,23,79 BOX REPLICATE(CHR(178), 8) + CHR(178)
@ 01,00 FILL TO 23,79 ;
   COLOR BG/B    

* Imprime el encabezado y el pie de la pantalla.
@ 00,00 FILL TO 00,79 ;
   COLOR N/BG   
 
=GetDate()

IF TYPE("gcCompany") <> "U"
   =Center(00, gcCompany, "N/BG")
ENDIF

@ 24,00 FILL TO 24,79 ;
   COLOR N/BG   

* F1
@ 24,00 SAY "1" ;
   SIZE 1,1 ;
   COLOR W/N

* F2
@ 24,07 SAY " 2" ;
   SIZE 1,2 ;
   COLOR W/N

* F3
@ 24,15 SAY " 3" ;
   SIZE 1,2 ;
   COLOR W/N

* F4
@ 24,23 SAY " 4" ;
   SIZE 1,2 ;
   COLOR W/N

* F5
@ 24,31 SAY " 5" ;
   SIZE 1,2 ;
   COLOR W/N

* F6
@ 24,39 SAY " 6" ;
   SIZE 1,2 ;
   COLOR W/N

* F7
@ 24,47 SAY " 7" ;
   SIZE 1,2 ;
   COLOR W/N

* F8
@ 24,55 SAY " 8" ;
   SIZE 1,2 ;
   COLOR W/N

* F9
@ 24,63 SAY " 9" ;
   SIZE 1,2 ;
   COLOR W/N

* F10
@ 24,71 SAY " 10" ;
   SIZE 1,3 ;
   COLOR W/N

* Dibuja las cajas que contendr n las opciones del men£.
@ 06,26 FILL TO 08,55 ;
   COLOR N/N+

@ 12,26 FILL TO 14,55 ;
   COLOR N/N+

@ 18,26 FILL TO 20,55 ;
   COLOR N/N+

@ 05,24 TO 07,53  COLOR W/B && Cuadro N§ 1
@ 11,24 TO 13,53  COLOR W/B && Cuadro N§ 2
@ 17,24 TO 19,53  COLOR W/B && Cuadro N§ 3

*IF .NOT. WVISIBLE(cWindow01)
*   ACTIVATE WINDOW (cWindow01)
*ENDIF

*
* CLEANUP - C¢digo de limpieza.
*
PROCEDURE Cleanup

* Libera la(s) ventana(s) de la memoria.

IF WEXIST(cWindow01)
   RELEASE WINDOW (cWindow01)
ENDIF

* Restablece el entorno de trabajo.
IF cSetTalk = "ON"
	SET TALK ON
ENDIF

IF cSetNotify = "ON"
	SET NOTIFY ON
ENDIF

IF cSetClock = "OFF"
	SET NOTIFY OFF
ENDIF

IF cSetSafety = "ON"
	SET SAFETY ON
ENDIF

IF cSetCentury = "OFF"
	SET CENTURY OFF
ENDIF

IF cSetDate <> "BRITISH"
	SET DATE (cSetDate)
ENDIF

IF cSetEscape = "ON"
	SET ESCAPE ON
ENDIF

IF cSetDeleted = "OFF"
	SET DELETED OFF
ENDIF

*
* CENTER - Impresi¢n centrada de cadenas de texto.        
*
PROCEDURE Center
PARAMETERS nRow, cText, cColor
nColumn = 40 - (LEN(cText) / 2)
@ nRow, nColumn SAY cText COLOR (cColor)

*
* RECOVER - Recupera los datos.
*
PROCEDURE Recover

SAVE SCREEN TO Restore

SET COLOR TO W/N
         
CLEAR

SET CONSOLE ON

? [INGRESE EL DISQUETTE QUE CONTIENE LOS DATOS EN A:]
?
? [SI APARECE UN MENSAJE EN INGLES QUE DICE: "INSERT THE LAST DISK OF THE]
? [BACKUP SET - PRESS ANY KEY WHEN READY", SIGNIFICA QUE LOS DATOS FUERON]
? [COPIADOS EN VARIOS DISQUETTES Y SE DEBE INGRESAR EL ULTIMO DISQUETTE DEL]
? [JUEGO. LUEGO IRA PIDIENDO EL 1ro., EL 2do. Y ASI SUCESIVAMENTE.]
?
? "PULSE UNA TECLA PARA CONTINUAR..."
nKey = INKEY(0, "H")
      
CLEAR 

? "DESCOMPACTANDO LOS DATOS..."
?

CLOSE DATABASES
         
RUN pkunzip a:datos.zip c:\turtle\update -o
         
USE c:\turtle\update\maesprod.dbf EXCLUSIVE
DELETE TAG ALL OF maesprod.cdx

INDEX ON codigo      TAG indice1 OF c:\turtle\update\maesprod.cdx
INDEX ON nombre      TAG indice2 OF c:\turtle\update\maesprod.cdx
INDEX ON rubro       TAG indice3 OF c:\turtle\update\maesprod.cdx
INDEX ON subrubro    TAG indice4 OF c:\turtle\update\maesprod.cdx
INDEX ON marca       TAG indice5 OF c:\turtle\update\maesprod.cdx
INDEX ON codigo2     TAG indice6 OF c:\turtle\update\maesprod.cdx
INDEX ON codorig     TAG indice7 OF c:\turtle\update\maesprod.cdx
INDEX ON val(codigo) TAG indice8 OF c:\turtle\update\maesprod.cdx
INDEX ON familia     TAG indice9 OF c:\turtle\update\maesprod.cdx
INDEX ON nombre      TAG indice10 OF c:\turtle\update\maesprod.cdx for vigente 
INDEX ON codigo      TAG indice11 OF c:\turtle\update\maesprod.cdx for vigente 
INDEX ON codigo2     TAG indice12 OF c:\turtle\update\maesprod.cdx for vigente 
INDEX ON codorig     TAG indice13 OF c:\turtle\update\maesprod.cdx for vigente

USE

? "RECUPERACION DE DATOS REALIZADA !, SE PROCEDERA A RE-ORZANIZAR LOS DATOS."
? "PULSE UNA TECLA PARA CONTINUAR..."
nKey = INKEY(0, "H")
   
SET CONSOLE OFF
   
SET COLOR TO
    
RESTORE SCREEN FROM Restore


*
* ACTUALIZAR - Actualiza la lista de precios.
*
PROCEDURE Actualizar
PRIVATE temp01, nCounter

IF MsgBox(C_AREYOUSURE, "", 4, "MESSAGE", "C") = 7
   RETURN
ENDIF

WAIT WINDOW "CREANDO TABLA TEMPORAL..." NOWAIT

*-- Base de datos, ¡ndices, relaciones.
SELECT 0
temp02 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp02 (codigo     C(15) ,;
                      codigo2    C(15) ,;
                      codorig    C(15) ,;
                      nombre     C(40) ,;
                      aplicacion M ,;
                      lista3     L(01) ,;
                      lista4     L(01) ,;
                      lista5     L(01) ,;
                      familia    N(04) ,;
                      rubro      N(04) ,;
                      subrubro   N(04) ,;
                      marca      N(04) ,;
                      unidad     N(03) ,;
                      proveedor  N(05) ,;
                      procedenci N(04) ,;                           
                      vigente    L(01) ,;
                      lprecio    L(01) ,;
                      impuesto   L(01) ,;
                      pimpuesto  N(06,2) ,;                                                                                 
                      pcostog    N(13,4) ,;
                      pcostog2   N(13,4) ,;
                      updprices  L(01) ,;
                      pcostod    N(13,4) ,;
                      pcostod2   N(13,4) ,;
                      pventag1   N(13,4) ,;
                      pventag2   N(13,4) ,;
                      pventag3   N(13,4) ,;
                      pventag4   N(13,4) ,;
                      pventag5   N(13,4) ,;
                      pventad1   N(13,4) ,;
                      pventad2   N(13,4) ,;
                      pventad3   N(13,4) ,;
                      pventad4   N(13,4) ,;
                      pventad5   N(13,4) ,;
                      stock_min  N(11,2) ,;
                      stock_max  N(11,2) ,;
                      polinvsmin L(01) ,;
                      polinvsmax L(01) ,;
                      caracter1  C(60) ,;
                      caracter2  C(60) ,;
                      caracter3  C(60) ,;
                      otros1     C(60) ,;
                      otros2     C(60) ,;
                      fecucompra D(08) ,;
                      fecrepo    D(08) ,;
                      id_local   N(02) ,;
                      nuevo      L(01) ,;
                      rec_type   N(01))

USE &temp02 ALIAS tmperror EXCLUSIVE

SELECT 0
temp01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp01 (codigo     C(15) ,;
                      codigo2    C(15) ,;
                      codorig    C(15) ,;
                      nombre     C(40) ,;
                      aplicacion M ,;
                      lista3     L(01) ,;
                      lista4     L(01) ,;
                      lista5     L(01) ,;
                      familia    N(04) ,;
                      rubro      N(04) ,;
                      subrubro   N(04) ,;
                      marca      N(04) ,;
                      unidad     N(03) ,;
                      proveedor  N(05) ,;
                      procedenci N(04) ,;                           
                      vigente    L(01) ,;
                      lprecio    L(01) ,;
                      impuesto   L(01) ,;
                      pimpuesto  N(06,2) ,;                                                                                 
                      pcostog    N(13,4) ,;
                      pcostog2   N(13,4) ,;
                      updprices  L(01) ,;
                      pcostod    N(13,4) ,;
                      pcostod2   N(13,4) ,;
                      pventag1   N(13,4) ,;
                      pventag2   N(13,4) ,;
                      pventag3   N(13,4) ,;
                      pventag4   N(13,4) ,;
                      pventag5   N(13,4) ,;
                      pventad1   N(13,4) ,;
                      pventad2   N(13,4) ,;
                      pventad3   N(13,4) ,;
                      pventad4   N(13,4) ,;
                      pventad5   N(13,4) ,;
                      stock_min  N(11,2) ,;
                      stock_max  N(11,2) ,;
                      polinvsmin L(01) ,;
                      polinvsmax L(01) ,;
                      caracter1  C(60) ,;
                      caracter2  C(60) ,;
                      caracter3  C(60) ,;
                      otros1     C(60) ,;
                      otros2     C(60) ,;
                      fecucompra D(08) ,;
                      fecrepo    D(08) ,;
                      id_local   N(02) ,;
                      nuevo      L(01) ,;
                      rec_type   N(01))

* Nomenclatura del campo REC_TYPE
* ------------------------------- 
* 1. Registro con fecha de £ltima compra m s reciente.
* 2. Registro nuevo.
* 3. Registro con fecha de modificaci¢n m s reciente.

USE &temp01 ALIAS tmpmaesprod EXCLUSIVE

INDEX ON codigo      TAG indice1
INDEX ON nombre      TAG indice2
INDEX ON rubro       TAG indice3
INDEX ON subrubro    TAG indice4
INDEX ON marca       TAG indice5
INDEX ON codigo2     TAG indice6
INDEX ON codorig     TAG indice7
INDEX ON val(codigo) TAG indice8
INDEX ON familia     TAG indice9
INDEX ON nombre      TAG indice10 for vigente
INDEX ON codigo      TAG indice11 for vigente
INDEX ON codigo2     TAG indice12 for vigente
INDEX ON codorig     TAG indice13 for vigente

* Lista de art¡culos del local destino.
SELECT 0 
USE maesprod.dbf ALIAS maesprod EXCLUSIVE
SET ORDER TO TAG indice7 OF maesprod.cdx

* Lista de art¡culos del local origen.
SELECT 0 
USE c:\turtle\update\maesprod.dbf ALIAS maesprod2 EXCLUSIVE 
SET ORDER TO TAG indice7 OF c:\turtle\update\maesprod.cdx
GO TOP

nCounter = 1

SCAN ALL
   WAIT WINDOW "PROCESANDO LA TABLA DE ARTICULOS: " + ALLTRIM(TRANSFORM(nCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT
IF .NOT. EMPTY(maesprod2.codorig)
   SELECT maesprod
   SET ORDER TO TAG indice7 OF maesprod.cdx
   
   IF SEEK(maesprod2.codorig)
*     SCAN WHILE maesprod.codorig = maesprod2.codorig
         IF maesprod.codigo <> maesprod2.codigo
            SELECT maesprod
               SCATTER MEMVAR MEMO
            SELECT tmperror
               APPEND BLANK
               GATHER MEMVAR MEMO
            SELECT maesprod2
               SCATTER MEMVAR MEMO
            SELECT tmperror
               APPEND BLANK
               GATHER MEMVAR MEMO
         ENDIF
*     ENDSCAN
   ENDIF

   SELECT maesprod2
ENDIF
   nCounter = nCounter + 1   
ENDSCAN

SELECT tmperror
BROWSE NOMODI

ZAP

* Lista de art¡culos del local destino.
SELECT maesprod
SET ORDER TO TAG indice6 OF maesprod.cdx

* Lista de art¡culos del local origen.
SELECT maesprod2 
SET ORDER TO TAG indice6 OF c:\turtle\update\maesprod.cdx
GO TOP

nCounter = 1

SCAN ALL
   WAIT WINDOW "PROCESANDO LA TABLA DE ARTICULOS: " + ALLTRIM(TRANSFORM(nCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT
IF .NOT. EMPTY(maesprod2.codigo2)
   SELECT maesprod
   SET ORDER TO TAG indice6 OF maesprod.cdx
   
   IF SEEK(maesprod2.codigo2)
*     SCAN WHILE maesprod.codigo2 = maesprod2.codigo2
         IF maesprod.codigo <> maesprod2.codigo
            SELECT maesprod
               SCATTER MEMVAR MEMO
            SELECT tmperror
               APPEND BLANK
               GATHER MEMVAR MEMO
            SELECT maesprod2
               SCATTER MEMVAR MEMO
            SELECT tmperror
               APPEND BLANK
               GATHER MEMVAR MEMO
         ENDIF
*     ENDSCAN
   ENDIF

   SELECT maesprod2
ENDIF
   nCounter = nCounter + 1   
ENDSCAN

SELECT tmperror
BROWSE NOMODI

* Lista de art¡culos del local destino.
SELECT maesprod
SET ORDER TO TAG indice1 OF maesprod.cdx

* Lista de art¡culos del local origen.
SELECT maesprod2 
SET ORDER TO TAG indice1 OF c:\turtle\update\maesprod.cdx
GO TOP


nCounter = 1

SCAN ALL
   WAIT WINDOW "PROCESANDO LA TABLA DE ARTICULOS: " + ALLTRIM(TRANSFORM(nCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT

   SELECT maesprod
   SET ORDER TO TAG indice1 OF maesprod.cdx
   
   IF SEEK(maesprod2.codigo)
     
      *-- Registro con fecha de £ltima compra m s reciente.
      IF maesprod2.fecucompra > maesprod.fecucompra
         SELECT maesprod2
            SCATTER MEMVAR MEMO
         SELECT tmpmaesprod
            APPEND BLANK
            GATHER MEMVAR MEMO
            REPLACE rec_type WITH 1
      ELSE
         *-- Registro con fecha de modificaci¢n m s reciente.
         IF maesprod2.fecrepo > maesprod.fecrepo
            SELECT maesprod2
               SCATTER MEMVAR MEMO
            SELECT tmpmaesprod
               APPEND BLANK
               GATHER MEMVAR MEMO
               REPLACE rec_type WITH 3
         ENDIF
      ENDIF
   ELSE
      *-- Registro nuevo.
      SELECT maesprod2
         SCATTER MEMVAR MEMO
      SELECT tmpmaesprod
         APPEND BLANK
         GATHER MEMVAR MEMO
            
         REPLACE nuevo      WITH .T.
         REPLACE rec_type   WITH 2
   ENDIF
   
   SELECT maesprod2
   nCounter = nCounter + 1   
ENDSCAN

WAIT CLEAR

SELECT tmpmaesprod
SET ORDER TO TAG indice1

IF RECCOUNT() > 0
   
   IF MsgBox("ARTICULOS CON VARIACION DE PRECIO: " + ALLTRIM(STR(RECCOUNT(), 5)) + "››" + C_UPDATEPRICES, "", 4, "MESSAGE", "C") = 6
      pcUpdate = "S"
   ELSE
      pcUpdate = "N"
   ENDIF         

   IF UPPER(pcUpdate) = "S"
      SELECT tmpmaesprod
      GO TOP
      
      nCounter = 1

      SCAN ALL
         WAIT WINDOW "PROCESANDO LA TABLA TEMPORAL: " + ALLTRIM(TRANSFORM(nCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT

         SELECT maesprod
         SET ORDER TO TAG indice1 OF maesprod
         
         IF SEEK(tmpmaesprod.codigo)
            IF tmpmaesprod.rec_type = 1      &&  Registro con fecha de £ltima compra m s reciente.
               SELECT tmpmaesprod
                  SCATTER MEMVAR MEMO
               SELECT maesprod
                  GATHER MEMVAR MEMO FIELDS codigo, codigo2, codorig, nombre, aplicacion, lista3, lista4, lista5, familia, rubro, subrubro, marca, unidad, proveedor, procedenci, vigente, lprecio, impuesto, pimpuesto, pcostog, pcostod, pventag1, pventag2, pventag3, pventag4, pventag5, pventad1, pventad2, pventad3, pventad4, pventad5, stock_min, stock_max, polinvsmin, polinvsmax, caracter1, caracter2, caracter3, otros1, otros2, fecucompra, fecrepo
            ELSE
               IF tmpmaesprod.rec_type = 3    &&  Registro con fecha de modificaci¢n m s reciente.
                  SELECT tmpmaesprod
                     SCATTER MEMVAR MEMO
                  SELECT maesprod
                     GATHER MEMVAR MEMO FIELDS codigo, codigo2, codorig, nombre, aplicacion, lista3, lista4, lista5, familia, rubro, subrubro, marca, unidad, proveedor, procedenci, vigente, lprecio, impuesto, pimpuesto, pcostog, pcostod, pventag1, pventag2, pventag3, pventag4, pventag5, pventad1, pventad2, pventad3, pventad4, pventad5, stock_min, stock_max, polinvsmin, polinvsmax, caracter1, caracter2, caracter3, otros1, otros2, fecrepo
               ENDIF
            ENDIF
         ELSE
            *-- Agrega nuevo registro.
            SELECT tmpmaesprod
               SCATTER MEMVAR MEMO
            SELECT maesprod
               APPEND BLANK
               GATHER MEMVAR MEMO
               
               REPLACE stock_actu WITH 0
               REPLACE stock_ot   WITH 0
         ENDIF
         
         SELECT tmpmaesprod
         nCounter = nCounter + 1   

         WAIT CLEAR
      ENDSCAN

      ?? CHR(7)
      ?? CHR(7)
      ?? CHR(7)
      =MsgBox(C_MESSA_02, "", 0, "MESSAGE", "C") 
   ENDIF
ELSE
   =MsgBox(C_MESSA_01, "", 0, "MESSAGE", "C") 
ENDIF

*-- MS-DOS Cierre de Bases de Datos.
IF USED("maesprod2")
   SELECT maesprod2
   USE
ENDIF

IF USED("tmpmaespro")
   SELECT tmpmaespro
   USE
ENDIF

IF USED("maesprod")
   SELECT maesprod
   USE
ENDIF

IF USED("tmperror")
   SELECT tmperror
   USE
ENDIF

DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "FPT"

*DELETE FILE &temp02
*DELETE FILE SUBSTR(temp02, 1, ATC(".", temp02)) + "CDX"
*DELETE FILE SUBSTR(temp02, 1, ATC(".", temp02)) + "FPT"

*-- Elimina ventanas.
IF WEXIST("tmpmaesprod")
   RELEASE WINDOW tmpmaesprod
ENDIF
