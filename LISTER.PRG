*
* LISTER.PRG - Visualizador de texto en formato ASCII.
*
PARAMETER cFileName

* Declaraci¢n de constantes.
*-- Teclas de funci¢n.

#DEFINE K_F1           28   &&   F1, Ctrl-\
#DEFINE K_F2           -1   &&   F2
#DEFINE K_F3           -2   &&   F3
#DEFINE K_F4           -3   &&   F4
#DEFINE K_F5           -4   &&   F5
#DEFINE K_F6           -5   &&   F6
#DEFINE K_F7           -6   &&   F7
#DEFINE K_F8           -7   &&   F8
#DEFINE K_F9           -8   &&   F9
#DEFINE K_F10          -9   &&   F10
#DEFINE K_F11         -40   && * F11
#DEFINE K_F12         -41   && * F12

*-- Teclas de movimiento del cursor.

#DEFINE K_UP            5   &&   Up arrow, Ctrl-E
#DEFINE K_DOWN         24   &&   Down arrow, Ctrl-X
#DEFINE K_LEFT         19   &&   Left arrow, Ctrl-S
#DEFINE K_RIGHT         4   &&   Right arrow, Ctrl-D
#DEFINE K_HOME          1   &&   Home, Ctrl-A
#DEFINE K_END           6   &&   End, Ctrl-F
#DEFINE K_PGUP         18   &&   PgUp, Ctrl-R
#DEFINE K_PGDN          3   &&   PgDn, Ctrl-C

*-- Miscel nea de teclas.

#DEFINE K_ENTER        13   &&   Enter, Ctrl-M
#DEFINE K_RETURN       13   &&   Return, Ctrl-M
#DEFINE K_SPACE        32   &&   Space bar
#DEFINE K_ESC          27   &&   Esc, Ctrl-[

*-- Mensajes del sistema.

#DEFINE C_MESSA_01     "ERROR, NO SE PUDO ABRIR EL ARCHIVO."

* Declaraci¢n de variables.
PRIVATE temp01, nRows, nHeight, nWidth, nRowPointer, nColPointer, ;
        cPath, nKey, cClock, cTalk

temp01      = ""
nRows       = 0
nHeight     = 24
nWidth      = 80
nRowPointer = 1
nColPointer = 1
cPath       = SYS(5) + SYS(2003) + "\" + cFileName

IF LEN(cPath) > 25
   cPath = SYS(5) + "\..." + RIGHT(cPath, 19)
ENDIF

IF SET("CLOCK") = "ON"
   SET CLOCK OFF
   cClock = "ON"
ELSE
   cClock = "OFF"
ENDIF

IF SET("TALK") = "ON"
   SET TALK OFF
   cTalk = "ON"
ELSE
   cTalk = "OFF"
ENDIF

=CreateByteIndex()

* Programa principal.
DO WHILE .T.
   =Refresh()

   nKey = INKEY(0, "HM")

   IF INLIST(nKey, 0, 151)
      LOOP
   ENDIF

   IF nKey = K_ESC
      EXIT
   ENDIF

   DO CASE
      CASE nKey = K_UP
         IF nRowPointer > 1
            nRowPointer = nRowPointer - 1
         ENDIF
      CASE nKey = K_DOWN
         IF nRowPointer < nRows
            nRowPointer = nRowPointer + 1
         ENDIF
      CASE nKey = K_LEFT
         IF nColPointer > 1
            nColPointer = nColPointer - 1
         ENDIF
      CASE nKey = K_RIGHT
         IF nColPointer < 176
            nColPointer = nColPointer + 1
         ENDIF
      CASE nKey = K_PGUP
         IF nRowPointer < nRows
            nRowPointer = nRowPointer - 23
            IF nRowPointer < 0
               nRowPointer = 1
            ENDIF
         ENDIF
      CASE nKey = K_PGDN
         IF (nRowPointer < nRows) .AND. (nRows - nRowPointer >= 23)
            nRowPointer = nRowPointer + 23
         ENDIF
      CASE nKey = K_HOME
         nRowPointer = 1
      CASE nKey = K_END
         IF (nRows - 22) > 0
            nRowPointer = nRows - 22
         ELSE
            nRowPointer = nRows
         ENDIF
   ENDCASE
ENDDO

IF WEXIST("DskLister")
   RELEASE WINDOW DskLister
ENDIF

IF USED("DOS_TEMP")
   SELECT DOS_TEMP
   USE
ENDIF

DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"

IF cClock = "ON"
   SET CLOCK ON
ENDIF

IF cTalk = "ON"
   SET TALK ON
ENDIF

**-----------------------------------------------------------****
* REFRESH - Actualiza la visualizaci¢n del archivo ASCII.       *
****-----------------------------------------------------------**
PROCEDURE Refresh

=ScreenLayout()

* Declaraci¢n de variables.
PRIVATE nCounter, nFileHandle, cLine

nCounter    = 1
nFileHandle = FOPEN(cFileName)

IF nFileHandle < 0
   =MsgBox(C_MESSA_01, "", 0, "MESSAGE", "C")
   RETURN
ELSE
   SELECT DOS_TEMP
   SEEK (nRowPointer)
   =FSEEK(nFileHandle, DOS_TEMP.byte)

   DO WHILE .NOT. FEOF(nFileHandle) .AND. nCounter <> nHeight
      cLine = TRIM(FGETS(nFileHandle))
      cLine = STRTRAN(cLine, CHR(9), SPACE(8))

      @ nCounter,00 SAY SUBSTR(cLine, nColPointer, nWidth) ;
         SIZE 1,nWidth ;
         COLOR W/B

      *-- Indicador izquierdo.
      IF nColPointer > 1
         @ nCounter,00 SAY CHR(174) ;
            SIZE 1,1 ;
            COLOR G+/B
      ENDIF

      *-- Indicador derecho.
      IF LEN(SUBSTR(cLine, nColPointer)) > nWidth
         @ nCounter, nWidth - 1 SAY CHR(175) ;
            SIZE 1,1 ;
            COLOR G+/B
      ENDIF

      nCounter = nCounter + 1
   ENDDO
   =FCLOSE(nFileHandle)
ENDIF

**-----------------------------------------------------------****
* CREATEBYTEINDEX - Crea un ¡ndice con el byte de incio de cada *
*                   l¡nea.                                      *
****-----------------------------------------------------------**
PROCEDURE CreateByteIndex

WAIT WINDOW "CARGANDO EL VISUALIZADOR..." NOWAIT

* Definici¢n de ventana.
IF .NOT. WEXIST("DskLister")
   DEFINE WINDOW DskLister ;
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

* Creaci¢n de la tabla ¡ndice DOS_TEMP.
SELECT 0
temp01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp01 (line N(09) ,;
                      byte N(09))

USE &temp01 ALIAS DOS_TEMP EXCLUSIVE
INDEX ON line TAG indice1

* Declaraci¢n de variables.
PRIVATE nCounter, nFileHandle, cLine

nCounter    = 1
nFileHandle = FOPEN(cFileName)

IF nFileHandle < 0
   =MsgBox(C_MESSA_01, "", 0, "MESSAGE", "C")
   RETURN
ELSE
   DO WHILE .NOT. FEOF(nFileHandle)
      INSERT INTO DOS_TEMP (line, byte) ;
         VALUES (nCounter, FSEEK(nFileHandle, 0, 1))
      cLine = TRIM(FGETS(nFileHandle))
      nCounter = nCounter + 1
   ENDDO
   =FCLOSE(nFileHandle)
ENDIF

nRows = RECCOUNT("DOS_TEMP")

WAIT CLEAR

IF .NOT. WVISIBLE("DskLister")
   ACTIVATE WINDOW DskLister
ENDIF

**-----------------------------------------------------------****
* SCREENLAYOUT - Dise¤o de pantalla.                            *
****-----------------------------------------------------------**
PROCEDURE ScreenLayout

* Limpiar pantalla.
CLEAR

* Dibuja el fondo.
@ 01,00,23,79 BOX REPLICATE(CHR(32), 8) + CHR(32)
@ 01,00 FILL TO 23,79 ;
   COLOR W/B

* Imprime el encabezado y el pie de la pantalla.
@ 00,00 FILL TO 00,79 ;
   COLOR N/BG

@ 24,00 FILL TO 24,79 ;
   COLOR N/BG

@ 00,02 SAY "L¡nea: " + ALLTRIM(STR(nRowPointer, 5)) + " de " + ;
   ALLTRIM(STR(nRows, 5)) + "   Columna: " + ALLTRIM(STR(nColPointer, 5)) ;
   SIZE 1,37 ;
   COLOR N/BG

@ 00,53 SAY cPath ;
   SIZE 1,25 ;
   COLOR N/BG

@ 24,02 SAY "Visor de Texto V1.0" ;
   SIZE 1,19 ;
   COLOR N/BG
   
@ 24,35 SAY "Teclas: " + CHR(24) + CHR(25) + CHR(26) + CHR(27) + " ReP g AvP g ESC=Salir F1=Ayuda" ;
   SIZE 1,43 ;
   COLOR N/BG