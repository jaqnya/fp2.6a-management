*--       Derechos Reservados por Turtle Software Paraguay 
*--     Diciembre 2003, escrito por Jos‚ Avilio Acu¤a Acosta.
*--   Biblioteca de procedimientos para FoxPro 2.6a para MS-DOS

                            
*            ÛÛßßß   ÜÛßÛÜ   ÛÛ   ÛÛ  ÛÛ     ÛÛ  ÛÛßßÛÜ
*            ÛÛÜÜ   ÛÛ   ÛÛ   ßÛÜÛß   ÛÛ     ÛÛ  ÛÛÜÜÛß     
*            ÛÛ     ÛÛ   ÛÛ   ÜÛßÛÜ   ÛÛ     ÛÛ  ÛÛ  ÛÛ
*            ÛÛ      ßÛÜÛß   ÛÛ   ÛÛ  ÛÛÜÜÜ  ÛÛ  ÛÛÜÜÛß

                            
**------------------------------------------------------------------------**
FUNCTION _Monochrome     &&   Monocrom tico.
SET COLOR OF SCHEME  1 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME  2 TO W/N,W+/N,W+/N,W+/N,W/N,N+/W,B+/W,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME  3 TO N/W,N/W,N/W,W+/N,N+/W,W+/N,N+/W,N+/N,W+/N,N+/W,-      
SET COLOR OF SCHEME  4 TO W/N,W+/N,W+/N,W+/N,W/N,N+/W,B+/W,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME  5 TO W/N,W+/N,W+/N,W+/N,W+/N,N+/W,B+/W,N+/N,W+/N,W/N,-     
SET COLOR OF SCHEME  6 TO W/N,W+/N,W+/N,W+/N,W+/N,N+/W,B+/W,N+/N,W+/N,W/N,-     
SET COLOR OF SCHEME  7 TO N+/W,N/W,N/W,N+/W,N/W,W+/N,B+/W,N+/N,N+/W,N/W,-       
SET COLOR OF SCHEME  8 TO W/N,B+/N,N/W,N+/W,N/W,N/W,B+/N,N+/N,W+/N,W/N,-        
SET COLOR OF SCHEME  9 TO W/N,W+/N,W+/N,N+/W,N/W,N/W,N/W,N+/N,N+/W,N/W,-        
SET COLOR OF SCHEME 10 TO W/N,N+/W,N/W,N+/W,N/W,B+/N,N/W,N+/N,N+/W,N/W,-        
SET COLOR OF SCHEME 11 TO W+/N,B+/N,N/W,N+/W,N/W,N/W,W/N,N+/N,N/W,W/N,-         
SET COLOR OF SCHEME 12 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 13 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 14 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 15 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 16 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 17 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 18 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 19 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 20 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 21 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 22 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 23 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 24 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-


**------------------------------------------------------------------------**
FUNCTION _Color     &&   Color.
SET COLOR OF SCHEME  1 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+                
SET COLOR OF SCHEME  2 TO BG/W,N/W,N/W,B/W,W/N,N/BG,W+/W,N+/N,B/W,W/N,+                             
SET COLOR OF SCHEME  3 TO BG/W,N/W,BG/N,BG/N,BG/N,N/BG,W+/W,N+/N,BG/N,BG/N,-                        
SET COLOR OF SCHEME  4 TO BG/W,N/W,N/W,B/W,W/N,N/BG,W+/W,N+/N,B/W,W/N,+                             
SET COLOR OF SCHEME  5 TO W+/RB,W+/BG,W+/RB,W+/RB,W/RB,W+/B,GR+/RB,N+/N,W+/RB,W/RB,+                
SET COLOR OF SCHEME  6 TO W/BG,W+/BG,W+/RB,W+/RB,W/RB,W+/B,GR+/RB,N+/N,W+/RB,W/RB,+                 
SET COLOR OF SCHEME  7 TO GR+/R,W+/W,GR+/R,W+/R,W/R,W+/N,GR+/R,N+/N,W+/R,W/R,+                      
SET COLOR OF SCHEME  8 TO W+/BG,W+/W,GR+/W,GR+/W,N+/W,W+/GR,BG+/BG,N+/N,B/BG,W/BG,+                 
SET COLOR OF SCHEME  9 TO W/BG,W+/BG,B/BG,GR+/W,N+/W,W+/GR,W+/B,N+/N,GR+/W,N+/W,+                   
SET COLOR OF SCHEME 10 TO W+/BG,GR+/B,GR+/W,GR+/W,N+/W,GR+/GR,W+/B,N+/N,GR+/W,N+/W,+                
SET COLOR OF SCHEME 11 TO W+/BG,W+/W,GR+/W,GR+/W,N+/W,W+/GR,W/B,N+/N,W+/B,W/BG,+                    
SET COLOR OF SCHEME 12 TO GR+/R,W+/W,GR+/R,W+/R,W/R,W+/N,GR+/R,N+/N,W+/R,W/R,+                      
SET COLOR OF SCHEME 13 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+                
SET COLOR OF SCHEME 14 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+                
SET COLOR OF SCHEME 15 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+                
SET COLOR OF SCHEME 16 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+                
SET COLOR OF SCHEME 17 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+                
SET COLOR OF SCHEME 18 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+                
SET COLOR OF SCHEME 19 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+                
SET COLOR OF SCHEME 20 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+                
SET COLOR OF SCHEME 21 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+                
SET COLOR OF SCHEME 22 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+                
SET COLOR OF SCHEME 23 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+                
SET COLOR OF SCHEME 24 TO W+/B,W+/BG,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,N+/N,GR+/B,R+/B,+


**------------------------------------------------------------------------**
FUNCTION _Center     &&   Impresi¢n centrada de cadenas de texto.
PARAMETERS pnRow, pcText, pcColor
pnColumn = 40 - (LEN(pcText) / 2)
@ pnRow, pnColumn SAY pcText COLOR (pcColor)


**------------------------------------------------------------------------**
FUNCTION _ErrorHandling     &&   Procedimiento de control de errores.
PARAMETER merror, mess, mess1, mprog, mlineno

* ÚÄ Ejemplo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
* ³   ON ERROR DO _ErrorHandling WITH ;                                    ³
* ³        ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()             ³
* ³                                                                        ³
* ³   *** La siguiente l¡nea deber¡a provocar un error ***                 ³
* ³                                                                        ³
* ³   USE nodatabase                                                       ³
* ³   ON ERROR        && restaura el controlador de errores del sistema.   ³
* ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


IF SET("TALK") = "ON"
   SET TALK OFF
   m.talkstat = "ON"
ELSE
   m.talkstat = "OFF"
ENDIF
IF SET("CURSOR") = "ON"
   SET CURSOR OFF
   m.cursorstat = "ON"
ELSE
   m.cursorstat = "OFF"
ENDIF

IF NOT WEXIST("dlgErrorWindow")
   DEFINE WINDOW dlgErrorWindow ;
      FROM 00,00 ;
      TO   14,68 ;
      DOUBLE ;
      CLOSE ;
      FLOAT ;
      GROW ;
      MDI ;
      MINIMIZE ;
      SHADOW ;
      ZOOM ;
      COLOR GR+/R, GR+/R
ENDIF

ACTIVATE WINDOW dlgErrorWindow TOP
MOVE WINDOW dlgErrorWindow CENTER

*-- Imprime etiquetas.
@ 00,00 SAY PADC("­ UN ERROR HA OCURRIDO !", WCOLS("dlgErrorWindow") , CHR(32)) ;
   SIZE 1,WCOLS("dlgErrorWindow") ;
   PICTURE "@!" ;
   COLOR GR+/R

@ 03,03 SAY "N£mero de error..........:" ;
   SIZE 1,26 ;
   COLOR GR+/R

@ 05,03 SAY "Mensaje de error.........:" ;
   SIZE 1,26 ;
   COLOR GR+/R

@ 07,03 SAY "L¡nea de c¢digo con error: " ;
   SIZE 1,26 ;
   COLOR GR+/R

@ 09,03 SAY "N£mero de l¡nea del error: " ;
   SIZE 1,26 ;
   COLOR GR+/R

@ 11,03 SAY "Programa con error.......: " ;
   SIZE 1,26 ;
   COLOR GR+/R


*-- Imprime el detalle del error.
@ 03,30 SAY LTRIM(STR(merror));
   SIZE 1,34 ;
   COLOR W+/R

@ 05,30 SAY SUBSTR(mess, 1, 34) ;
   SIZE 1,34 ;
   COLOR W+/R

@ 07,30 SAY SUBSTR(mess1, 1, 34) ;
   SIZE 1,34 ;
   COLOR W+/R

@ 09,30 SAY LTRIM(STR(mlineno)) ;
   SIZE 1,34 ;
   COLOR W+/R

@ 11,30 SAY mprog ;
   SIZE 1,34 ;
   COLOR W+/R

READ CYCLE ;
   TIMEOUT 0
   
IF m.cursorstat = "ON"
   SET CURSOR ON
ENDIF
IF m.talkstat = "ON"
   SET TALK ON
ENDIF

RELEASE WINDOW dlgErrorWindow

WAIT WINDOW "­ EJECUCION DEL SISTEMA CANCELADO !"
DO _SetOut
ON ERROR        && restaura el controlador de errores del sistema.
SET PROCEDURE TO
CANCEL


**------------------------------------------------------------------------**
FUNCTION _HDDSerie     && Comprueba derecho de utilizaci¢n del sistema.
PRIVATE pcDriveC, llReturn
pcDriveC = _DskSerie("C:")
llReturn = .T.

DO CASE
   CASE pcDriveC = "1093-9EC1"   && Jose's Home Development Machine [DESARROLLADOR]  tortugas
   CASE pcDriveC = "C4E8-9B50"   && Central House WinXP Server      [CASA CENTRAL]   servidor
   CASE pcDriveC = "1311-13D9"   && Printer Server                  [CASA CENTRAL]   computador6
   CASE pcDriveC = "3088-BFDA"   && Show Room Left PC               [CASA CENTRAL]   computador1
   CASE pcDriveC = "26B2-5ACD"   && Show Room Right PC              [CASA CENTRAL]   computador3
   CASE pcDriveC = "0E60-10F3"   && Repair Shop PC                  [CASA CENTRAL]   computador4
   CASE pcDriveC = "54AC-C238"   && Development PC                  [CASA CENTRAL]   computador2
   CASE pcDriveC = "5C2A-AC24"   && Development PC                  [CASA CENTRAL]   computador2
   CASE pcDriveC = "26AC-D826"   && Felipe LT                       [CASA CENTRAL]   computador5
   CASE pcDriveC = "1659-57DA"   && Jose LT Dell                    [CASA CENTRAL]   dell-pc
   CASE pcDriveC = "C8FE-D52A"   && Ricardo LT Toshiba              [CASA CENTRAL]   computador8
   CASE pcDriveC = "0003-4F34"   && Branch House WinXP Server       [SUCURSAL Nº 1]  servidor
   CASE pcDriveC = "08BD-9B33"   && Show Room LT Acer Traveler 2420 [SUCURSAL Nº 1]  computador1
   CASE pcDriveC = "DC3A-6E00"   && Ricardo LT                      [SUCURSAL Nº 1]  computador2
   CASE pcDriveC = "3484-F031"   && Lenovo IdeaPad S10              [CASA CENTRAL]   computador8
   CASE pcDriveC = "3A8C-9C0B"   && Lenovo IdeaPad S10              [CASA CENTRAL]   computador8
   CASE pcDriveC = "728D-F305"   && All Parts S.R.L. Dell           [CASA CENTRAL]   computador8
   CASE pcDriveC = "384E-7B0C"   && Development PC                  [CASA CENTRAL]   computador2
   CASE pcDriveC = "28B5-62BE"   && Desktop Computer                [SUCURSAL AVDA. EUSEBIO AYALA]
   CASE pcDriveC = "368E-DA90"   && Notebook Computer               [SUCURSAL AVDA. EUSEBIO AYALA]   
   CASE pcDriveC = "6AD7-3F36"   && Mini Computer ¦ Intel NUC Processor     [CASA CENTRAL]
   CASE pcDriveC = "203D-A118"   && Notebook Acer Aspire            [CASA CENTRAL]
   CASE pcDriveC = "6A8A-449E"   && Notebook Acer Aspire E15        [CASA CENTRAL]
   CASE pcDriveC = "B039-B8E6"   && Notebook Acer Aspire E11        [DON OSCAR]
   OTHERWISE
      llReturn = .F.
ENDCASE

RETURN (llReturn)
**------------------------------------------------------------------------**
FUNCTION _DskSerie     &&   Devuelve el n£mero de serie del vol£men de la unidad especificada.
PARAMETER pcDrive

IF EMPTY(pcDrive)
   RETURN ""
ENDIF

PRIVATE pcFileName, pnFile, pcLinea, pcDskSerial

pcFileName = SYS(3) + ".tmp"

! VOL &pcDrive > &pcFileName

pnFile = FOPEN(pcFileName)

IF pnFile = -1
   ? CHR(7)
   WAIT WINDOW "Error. No se pudo verificar la serie" TIMEOUT 5
   RETURN
ELSE
   DO WHILE .NOT. FEOF(pnFile)
      pcLinea = UPPER(TRIM(FGETS(pnFile)))
      DO CASE
         CASE "SERIAL NUMBER" $ pcLinea
            pcDskSerial = RIGHT(pcLinea, 9)
         CASE "SERIE DEL VOLUMEN" $ pcLinea
            pcDskSerial = RIGHT(pcLinea, 9)
      ENDCASE
   ENDDO
   = FCLOSE(pnFile)
   DELETE FILE (pcFileName)
ENDIF

RETURN pcDskSerial


**------------------------------------------------------------------------**
FUNCTION _Security     &&   Comprueba: a) El directorio de trabajo actual y
                       &&                 el nombre del programa en ejecuci¢n
                       &&              b) Derecho de utilizaci¢n del sistema.
IF SET("TALK") = "ON"
   SET TALK OFF
   m.talkstat = "ON"
ELSE
   m.talkstat = "OFF"
ENDIF
IF SET("CURSOR") = "ON"
   SET CURSOR OFF
   m.cursorstat = "ON"
ELSE
   m.cursorstat = "OFF"
ENDIF

IF USED("control")
   SELECT control
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("control.dbf","DBF","¨ D¢nde est  CONTROL.DBF ?"));
      AGAIN ALIAS control SHARED ;
      ORDER 0
ENDIF

pcSys16    = SYS(16, 0)
pcProgram  = SUBSTR(pcSys16, RAT("\", pcSys16) + 1)
pcPriorDir = SUBSTR(pcSys16, RAT("\", pcSys16, 2) + 1, RAT("\", pcSys16) - RAT("\", pcSys16, 2) - 1)

IF INLIST(pcProgram, "MAIN.FXP", "MAIN.APP", "MAIN.EXE", "MAINXP.FXP", "MAINXP.APP", "MAINXP.EXE") .AND. pcPriorDir = "INTEGRAD.000" .AND. _HDDSerie()
   *-- Casa Central.
   PUBLIC gcLocal
   gcLocal = CHR(15) + CHR(32) + ALLTRIM(control.empresa) + CHR(32) + CHR(15)
ELSE
   IF INLIST(pcProgram, "MAIN.FXP", "MAIN.APP", "MAIN.EXE", "MAINXP.FXP", "MAINXP.APP", "MAINXP.EXE") .AND. pcPriorDir = "INTEGRAD.CON" .AND. _HDDSerie()
      *-- Consolidado.
      PUBLIC gcLocal
      gcLocal = CHR(15) + CHR(32) + ALLTRIM(control.empresa)  + " - CONSOLIDADO" + CHR(32) + CHR(15)
   ELSE
      IF INLIST(pcProgram, "MAIN.FXP", "MAIN.APP", "MAIN.EXE", "MAINXP.FXP", "MAINXP.APP", "MAINXP.EXE") .AND. LEFT(pcPriorDir, AT(".", pcPriorDir, 1) - 1) = "INTEGRAD" .AND. _HDDSerie()
         *-- Sucursal
         PUBLIC gcLocal
         gcLocal = CHR(15) + CHR(32) + ALLTRIM(control.empresa) + " (SUC. " + RIGHT(pcPriorDir, LEN(pcPriorDir) - AT(".", pcPriorDir) - 1) + ")" + CHR(32) + CHR(15)
      ELSE
         WAIT WINDOW "    ­ ERROR DE PROTECCION !    " + CHR(13) + ;
                  "EJECUCION DEL SISTEMA CANCELADO"   TIMEOUT 5
         PUBLIC gcLocal
         gcLocal = CHR(15) + CHR(32) + "EMPRESA PIRATA" + " (SUC. " + RIGHT(pcPriorDir, LEN(pcPriorDir) - AT(".", pcPriorDir) - 1) + ")" + CHR(32) + CHR(15)
         CANCEL
      ENDIF
   ENDIF
ENDIF

IF m.talkstat = "ON"
   SET TALK ON
ENDIF
IF m.cursorstat = "ON"
   SET CURSOR ON
ENDIF


**------------------------------------------------------------------------**
FUNCTION _SetIn
SET ALTERNATE   TO
SET ALTERNATE   OFF
SET ANSI        OFF
SET AUTOSAVE    OFF
SET BELL        OFF     &&   Default: ON
SET BELL        TO 512, 2
SET BLINK       OFF     &&   Default: ON
SET BLOCKSIZE   TO 64
SET BORDER      TO SINGLE
SET BRSTATUS    OFF
SET CARRY       OFF
SET CENTURY     ON      &&   Default: OFF
SET CLEAR       ON
SET CLOCK       OFF
SET CLOCK       TO 0,69
SET COMPATIBLE  OFF
SET CONFIRM     OFF
*SET CONSOLE     OFF     &&   Default: ON
SET CURRENCY    TO "$"
SET CURRENCY    LEFT
SET CURSOR      ON
SET DATE        BRITISH &&   Default: AMERICAN
SET DEBUG       ON
SET DECIMALS    TO 2
SET DELETED     ON      &&   Default: OFF
SET DELIMITERS  OFF
SET DELIMITERS  TO DEFAULT
SET DEVELOPMENT ON
SET DEVICE      TO SCREEN
SET ECHO        OFF
SET ESCAPE      OFF    &&   Default: ON
SET EXACT       OFF
SET EXCLUSIVE   ON
SET FUNCTION "F1"  TO CHR(32) + CHR(127)
SET FUNCTION "F2"  TO CHR(32) + CHR(127)
SET FUNCTION "F3"  TO CHR(32) + CHR(127)
SET FUNCTION "F4"  TO CHR(32) + CHR(127)
SET FUNCTION "F5"  TO CHR(32) + CHR(127)
SET FUNCTION "F6"  TO CHR(32) + CHR(127)
SET FUNCTION "F7"  TO CHR(32) + CHR(127)
SET FUNCTION "F8"  TO CHR(32) + CHR(127)
SET FUNCTION "F9"  TO CHR(32) + CHR(127)
SET FUNCTION "F10" TO CHR(32) + CHR(127)
SET FUNCTION "F11" TO CHR(32) + CHR(127)
SET FUNCTION "F12" TO CHR(32) + CHR(127)
SET FULLPATH    ON
SET HEADING     ON
*SET HELP        ON
*SET HELP        TO FOXHELP
SET HOURS       TO 12
SET INTENSITY   ON
SET LOGERROR    ON
SET MACKEY      TO "SHIFT+F10"
SET MARGIN      TO 0
*SET MARK        TO "/"
SET MEMOWIDTH   TO 50
SET MOUSE       TO 5
SET MOUSE       ON
SET NEAR        OFF
SET NOTIFY      OFF    &&   Default: ON
SET ODOMETER    TO 100
SET OPTIMIZE    ON
SET POINT       TO "."
SET PRINT       OFF
SET REPROCESS   TO AUTOMATIC
*SET REPROCESS   TO 0
*SET RESOURCE    ON
SET SAFETY      OFF    &&   Default: ON
SET SCOREBOARD  OFF
SET SEPARATOR   TO ","
SET SPACE       ON
SET STATUS      OFF
SET STEP        OFF
SET STICKY      ON
SET SYSMENU     OFF    &&   Default: ON
SET TALK        OFF    &&   Default: ON
SET TEXTMERGE   OFF
SET TRBETWEEN   ON
*SET TYPEAHEAD   TO 20
SET UDFPARMS    VALUE
SET UNIQUE      OFF

**------------------------------------------------------------------------**
FUNCTION _SetOut
SET ALTERNATE   OFF
SET ANSI        OFF
SET AUTOSAVE    OFF
SET BELL        ON
SET BELL        TO 512, 2
SET BLINK       ON
SET BLOCKSIZE   TO 64
SET BORDER      TO SINGLE
SET BRSTATUS    OFF
SET CARRY       OFF
SET CENTURY     OFF
SET CLEAR       ON
SET CLOCK       OFF
SET CLOCK       TO 0,69
SET COMPATIBLE  OFF
SET CONFIRM     OFF
SET CONSOLE     ON
SET CURRENCY    TO "$"
SET CURRENCY    LEFT
SET CURSOR      ON
SET DATE        AMERICAN
SET DEBUG       ON
SET DECIMALS    TO 2
SET DELETED     OFF
SET DELIMITERS  OFF
SET DELIMITERS  TO DEFAULT
SET DEVELOPMENT ON
SET DEVICE      TO SCREEN
SET ECHO        OFF
SET ESCAPE      ON
SET EXACT       OFF
SET EXCLUSIVE   ON
SET FULLPATH    ON
SET HEADING     ON
*SET HELP        ON
*SET HELP        TO FOXHELP
SET HOURS       TO 12
SET INTENSITY   ON
SET LOGERROR    ON
SET MACKEY      TO "SHIFT+F10"
SET MARGIN      TO 0
*SET MARK        TO "/"
SET MEMOWIDTH   TO 50
SET MOUSE       TO 5
SET MOUSE       ON
SET NEAR        OFF
SET NOTIFY      ON
SET ODOMETER    TO 100
SET OPTIMIZE    ON
SET POINT       TO "."
SET PRINT       OFF
SET REPROCESS   TO 0
*SET RESOURCE    ON
SET SAFETY      ON
SET SCOREBOARD  OFF
SET SEPARATOR   TO ","
SET SPACE       ON
SET STATUS      OFF
SET STEP        OFF
SET STICKY      ON
SET SYSMENU     ON
SET TALK        ON
SET TEXTMERGE   OFF
SET TRBETWEEN   ON
*SET TYPEAHEAD   TO 20
SET UDFPARMS    VALUE
SET UNIQUE      OFF


**------------------------------------------------------------------------**
FUNCTION _BackGround
PARAMETER pnWhat
DO CASE
   CASE pnWhat = 1
      @ 01,00,23,79 BOX REPLICATE(CHR(177), 8) + CHR(177)
      @ 00,00 TO 00,79 CHR(219)
      @ 24,00 TO 24,79 CHR(219)
   CASE pnWhat = 2
      @ 01,00,23,79 BOX REPLICATE(CHR(177), 8) + CHR(177)
      @ 00,00 TO 00,79 CHR(32)
      @ 24,00 TO 24,79 CHR(32)
ENDCASE


**------------------------------------------------------------------------**
FUNCTION _CustomMono     &&   Monocrom tico personalizado.
SET COLOR OF SCHEME  1 TO W/N,N/W,W/N,N/W,W/N,N/W,W/N,N+/N,W/N,W/N,-      
SET COLOR OF SCHEME  2 TO W/N,W+/N,W+/N,W+/N,W/N,N+/W,B+/W,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME  3 TO N/W,N/W,N/W,W+/N,N+/W,W+/N,N+/W,N+/N,W+/N,N+/W,-      
SET COLOR OF SCHEME  4 TO W/N,W+/N,W+/N,W+/N,W/N,N+/W,B+/W,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME  5 TO W+/RB,W+/BG,W+/RB,W+/RB,W/RB,W+/B,GR+/RB,N+/N,W+/RB,W/RB,-                
SET COLOR OF SCHEME  6 TO W/N,W+/N,W+/N,W+/N,W+/N,N+/W,B+/W,N+/N,W+/N,W/N,-     
SET COLOR OF SCHEME  7 TO N+/W,N/W,N/W,N+/W,N/W,W+/N,B+/W,N+/N,N+/W,N/W,-       
SET COLOR OF SCHEME  8 TO W/N,B+/N,GR+/GR,N+/W,N/W,N/W,B+/N,N+/N,W+/N,W/N,-
SET COLOR OF SCHEME  9 TO W/N,W+/N,W+/N,N+/W,N/W,N/W,N/W,N+/N,N+/W,N/W,-        
SET COLOR OF SCHEME 10 TO W/N,N+/W,N/W,N+/W,N/W,B+/N,N/W,N+/N,N+/W,N/W,-        
SET COLOR OF SCHEME 11 TO W+/N,B+/N,N/W,N+/W,N/W,N/W,W/N,N+/N,N/W,W/N,-         
SET COLOR OF SCHEME 12 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 13 TO N/W,W/N,N/W,W/N,N/W,W/N,N/W,N+/N,N/W,N+/W,-      
SET COLOR OF SCHEME 14 TO N/W,N/W,N/W,W/N,N/W,W/N,W+/N,N+/N,W/N,W/N,-      
SET COLOR OF SCHEME 15 TO W/N,W+/BG,N/W,N/W,W/N,W+/B,N/W,W/N,W/N,W/N,-      


SET COLOR OF SCHEME 15 TO W/N,W+/BG,GR+/GR,GR+/GR,GR/GR+,W+/B,N/W,W/N,W/N,W/N,-      


SET COLOR OF SCHEME 16 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 17 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 18 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 19 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 20 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 21 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 22 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 23 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-      
SET COLOR OF SCHEME 24 TO W/N,N+/W,W+/N,W+/N,W/N,B+/N,W+/N,N+/N,W+/N,W/N,-


**------------------------------------------------------------------------**
FUNCTION SaveWorkArea      && Guarda informaci¢n sobre el  rea de trabajo 
                           && actual.
IF NOT EMPTY(gaWorkAreaStack[1, 1])
   gnWkAreaLevel = gnWkAreaLevel + 1
   DIMENSION gaWorkAreaStack[gnWkAreaLevel, 3]
ENDIF

gaWorkAreaStack[gnWkAreaLevel, 1] = SELECT()
gaWorkAreaStack[gnWkAreaLevel, 2] = TAG()
gaWorkAreaStack[gnWkAreaLevel, 3] = IIF(EOF(), 0, RECNO())

**------------------------------------------------------------------------**
FUNCTION RestoreWorkArea     && Restaura la £ltima  rea de trabajo guardada.

IF EMPTY(gaWorkAreaStack)
   WAIT WINDOW "­ NO EXISTE AREA DE TRABAJO A RESTAURAR !"
   RETURN
ENDIF

SELECT gaWorkAreaStack[gnWkAreaLevel, 1]
IF NOT EMPTY(gaWorkAreaStack[gnWkAreaLevel, 2])
   SET ORDER TO TAG gaWorkAreaStack[gnWkAreaLevel, 2] ASCENDING
ENDIF
IF gaWorkAreaStack[gnWkAreaLevel, 3] <> 0
   GOTO RECORD gaWorkAreaStack[gnWkAreaLevel, 3]
ENDIF

IF ALEN(gaWorkAreaStack, 1) > 1
   gnWkAreaLevel = gnWkAreaLevel - 1
   DIMENSION gaWorkAreaStack[gnWkAreaLevel, 3]
ELSE
   gaWorkAreaStack = ""   
ENDIF

**------------------------------------------------------------------------**
FUNCTION SaveScreen      && Guarda la pantalla actual.

gnScreenLevel = gnScreenLevel + 1
DIMENSION gaScreenStack[gnScreenLevel]
SAVE SCREEN TO gaScreenStack[gnScreenLevel]

**------------------------------------------------------------------------**
FUNCTION RestoreScreen     && Restaura la £ltima pantalla guardada.

RESTORE SCREEN FROM gaScreenStack[gnScreenLevel]

IF ALEN(gaScreenStack, 1) > 1
   gnScreenLevel = gnScreenLevel - 1
   DIMENSION gaScreenStack[gnScreenLevel, 1]
ENDIF

**------------------------------------------------------------------------**
FUNCTION UserConfig
PARAMETER pcProgram, pcTask, plMessage

PRIVATE pnSelect, pcOrder, pnRecNo, plReturnedValue
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

IF USED("usercfg")
   SELECT usercfg
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("usercfg.dbf", "DBF", "¨ D¢nde est  USERCFG.DBF ?")) ;
      AGAIN ALIAS usercfg SHARED ;
      ORDER TAG indice1
ENDIF

IF SEEK(STR(gnUser, 4) + pcProgram)
   DO CASE
      CASE pcTask = "Access"
         IF usercfg.access
            plReturnedValue = .T.
         ELSE
            plReturnedValue = .F.
         ENDIF
      CASE pcTask = "Add"
         IF usercfg.add    
            plReturnedValue = .T.
         ELSE
            plReturnedValue = .F.
         ENDIF
      CASE pcTask = "Edit"
         IF usercfg.edit   
            plReturnedValue = .T.
         ELSE
            plReturnedValue = .F.
         ENDIF
      CASE pcTask = "Delete"
         IF usercfg.delete 
            plReturnedValue = .T.
         ELSE
            plReturnedValue = .F.
         ENDIF
      CASE pcTask = "Print"
         IF usercfg.print  
            plReturnedValue = .T.
         ELSE
            plReturnedValue = .F.
         ENDIF
      OTHERWISE
         plReturnedValue = .F.
   ENDCASE
ELSE
   plReturnedValue = .F.
ENDIF
   
SELECT (pnSelect)
IF .NOT. EMPTY(pcOrder)
   SET ORDER TO TAG (pcOrder) 
ENDIF
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

IF .NOT. plReturnedValue .AND. plMessage
   WAIT WINDOW msgNotAvailable NOWAIT
ENDIF

RETURN (plReturnedValue)
**------------------------------------------------------------------------**
FUNCTION esta_corre
PRIVATE cCorrecto, retorno
DO WHILE .T.
   WAIT WINDOW "ESTA CORRECTO ? (S/N)" TO cCorrecto
   IF (INLIST(UPPER(cCorrecto), "S", "N") .OR. LASTKEY() = 27)
      EXIT
   ENDIF
ENDDO

DO CASE
   CASE (UPPER(cCorrecto) = "S")
      retorno = .T.
   CASE (UPPER(cCorrecto) = "N" .OR. LASTKEY() = 27)
      retorno = .F.
ENDCASE

RETURN (retorno)
**------------------------------------------------------------------------**
PROCEDURE borratm
PARAMETER cFileName

PRIVATE architm1, architm2, architm3, architm4
architm1 = cFileName + ".DBF"
architm2 = cFileName + ".IDX"
architm3 = cFileName + ".VUE"
architm4 = cFileName + ".CDX"

IF FILE(architm1)
   DELETE FILE &architm1
ENDIF

IF FILE(architm2)
   DELETE FILE &architm2
ENDIF

IF FILE(architm3)
   DELETE FILE &architm3
ENDIF

IF FILE(architm4)
   DELETE FILE &architm4
ENDIF

RETURN



**************************************************************************
**********

*
*!*	PROCEDURE deFinicion
*!*	 DEFINE POPUP vaRios PROMPT FIELDS noMbre MARGIN SCROLL
*!*	 RETURN
*!*	*
*!*	PROCEDURE elIge_arch
*!*	 arChivo_vi = arChivo
*!*	 DO WHILE .T.
*!*	      SELECT vaRios
*!*	      SET FILTER TO tiPo='A'
*!*	      GOTO TOP
*!*	      mnOmbre = noMbre
*!*	      DEFINE WINDOW arChivos FROM 01, 14 TO 22, 66 FLOAT CLOSE TITLE  ;
*!*	             'MODULOS DEL SISTEMA' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
*!*	      ACTIVATE WINDOW arChivos
*!*	      @ 00,00 get mnombre popup varios size 20,51 picture "@&T" color &color_05
*!*	      READ
*!*	      DEACTIVATE WINDOW arChivos
*!*	      RELEASE WINDOW arChivos
*!*	      IF LASTKEY()=27
*!*	           arChivo = arChivo_vi
*!*	      ELSE
*!*	           arChivo = ALLTRIM(SUBSTR(mnOmbre, 1, 11))
*!*	           IF arChivo='MOVIMIENTOS'
*!*	                arChivo = 'CABEMOT'
*!*	           ENDIF
*!*	           IF LEFT(arChivo, 1)='Ä'
*!*	                arChivo = arChivo_vi
*!*	                RETURN
*!*	           ENDIF
*!*	           IF arChivo='TABLAS'
*!*	                IF muSop(6,1)<>'X'
*!*	                     RETURN
*!*	                ENDIF
*!*	                SET FILTER TO tiPo='B'
*!*	                GOTO TOP
*!*	                mnOmbre = noMbre
*!*	                DEFINE WINDOW arChivos FROM 03, 27 TO 21, 54 FLOAT CLOSE  ;
*!*	                       SHADOW TITLE 'TABLAS DEL SISTEMA' SYSTEM COLOR GR+/ ;
*!*	                       BG,GR+/W,N/W,N/W 
*!*	                ACTIVATE WINDOW arChivos
*!*	                @ 00,00 get mnombre popup varios size 17,26 picture "@&T" color &color_05
*!*	                READ
*!*	                DEACTIVATE WINDOW arChivos
*!*	                RELEASE WINDOW arChivos
*!*	                IF LASTKEY()=27
*!*	                     LOOP
*!*	                ENDIF
*!*	                IF ALLTRIM(mnOmbre)='MOTIVOS DE LAS NOTAS'
*!*	                     arChivo = 'MOTIVONOTA'
*!*	                ELSE
*!*	                     arChivo = ALLTRIM(SUBSTR(mnOmbre, 1, 11))
*!*	                ENDIF
*!*	           ENDIF
*!*	           DO CASE
*!*	                CASE arChivo='UNIDADES DE'
*!*	                     arChivo = 'UNIDADES'
*!*	                CASE arChivo='NOTAS DE EN'
*!*	                     arChivo = 'CABEMOVI'
*!*	                CASE arChivo='CLIENTES y'
*!*	                     arChivo = 'CLIENTES'
*!*	                CASE arChivo='PRESUPUESTO'
*!*	                     arChivo = 'CABEPRES'
*!*	                CASE arChivo='VENTAS'
*!*	                     arChivo = 'CABEVENT'
*!*	                CASE arChivo='REMISIONES'
*!*	                     arChivo = 'CABEREMI'
*!*	                CASE arChivo='COBROS A CL'
*!*	                     arChivo = 'CABECOB'
*!*	                CASE arChivo='NOTAS DE DE' .AND. vaRios.noMbre= ;
*!*	                     'NOTAS DE DEBITOS Y CREDITOS - CLIENTES'
*!*	                     arChivo = 'CABENOTC'
*!*	                CASE arChivo='NOTAS DE DE' .AND. vaRios.noMbre= ;
*!*	                     'NOTAS DE DEBITOS Y CREDITOS - PROVEEDORES'
*!*	                     arChivo = 'CABENOTP'
*!*	                CASE arChivo='COMPRAS'
*!*	                     arChivo = 'CABECOMP'
*!*	                CASE arChivo='PAGOS A PRO'
*!*	                     arChivo = 'CABEPAG'
*!*	                CASE arChivo='DEPARTAMENT'
*!*	                     arChivo = 'DEPARTAMENTOS'
*!*	                CASE arChivo='RUBROS 1'
*!*	                     arChivo = 'RUBROS'
*!*	                CASE arChivo='SUB-RUBROS'
*!*	                     arChivo = 'SUBRUBROS'
*!*	                CASE arChivo='MOTIVOS DE'
*!*	                     arChivo = 'MOTIVOCL'
*!*	                CASE arChivo='ORDENES DE'
*!*	                     arChivo = 'OT'
*!*	                CASE arChivo='ESTADO DE L'
*!*	                     arChivo = 'ESTADOOT'
*!*	           ENDCASE
*!*	      ENDIF
*!*	      select &archivo
*!*	      IF EOF()
*!*	           GOTO TOP
*!*	      ENDIF
*!*	      EXIT
*!*	 ENDDO
*!*	 RETURN
*
*!*	PROCEDURE elIge_cons
*!*	 RESTORE SCREEN FROM paNtabase
*!*	 SELECT vaRios
*!*	 SET FILTER TO tiPo='C'
*!*	 GOTO TOP
*!*	 mxConsulta = noMbre
*!*	 DEFINE WINDOW coNsultas FROM 05, 05 TO 17, 73 FLOAT CLOSE SHADOW TITLE  ;
*!*	        'CONSULTAS' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
*!*	 ACTIVATE WINDOW coNsultas
*!*	 @ 00,00 get mxconsulta popup varios size 14,67 picture "@&T" color &color_05
*!*	 READ
*!*	 DEACTIVATE WINDOW coNsultas
*!*	 RELEASE WINDOW coNsultas
*!*	 RETURN
*!*	*
*!*	PROCEDURE elIge_list
*!*	 RESTORE SCREEN FROM paNtabase
*!*	 PRIVATE ciClo1, ciClo2
*!*	 ciClo1 = .T.
*!*	 DO WHILE ciClo1
*!*	      SELECT vaRios
*!*	      SET FILTER TO tiPo='F'
*!*	      GOTO TOP
*!*	      mlIstado = noMbre
*!*	      DEFINE WINDOW liStados FROM 06, 30 TO 16, 49 FLOAT CLOSE SHADOW  ;
*!*	             TITLE 'LISTADOS' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
*!*	      ACTIVATE WINDOW liStados
*!*	      @ 00,00 get mlistado popup varios size 09,18 picture "@&T" color &color_05
*!*	      READ
*!*	      DEACTIVATE WINDOW liStados
*!*	      RELEASE WINDOW liStados
*!*	      IF LASTKEY()=27
*!*	           EXIT
*!*	      ELSE
*!*	           IF (ALLTRIM(mlIstado)='ARTICULOS' .AND. muSop(43,1)<>'X') .OR.  ;
*!*	              (ALLTRIM(mlIstado)='CLIENTES' .AND. muSop(54,1)<>'X') .OR.  ;
*!*	              (ALLTRIM(mlIstado)='VENTAS' .AND. muSop(61,1)<>'X') .OR.  ;
*!*	              (ALLTRIM(mlIstado)='COBROS' .AND. muSop(76,1)<>'X') .OR.  ;
*!*	              (ALLTRIM(mlIstado)='PROVEEDORES' .AND. muSop(80,1)<>'X')  ;
*!*	              .OR. (ALLTRIM(mlIstado)='COMPRAS' .AND. muSop(84,1)<>'X')  ;
*!*	              .OR. (ALLTRIM(mlIstado)='PAGOS' .AND. muSop(93,1)<>'X')
*!*	                EXIT
*!*	           ENDIF
*!*	           xk = ALLTRIM(vaRios.noMbprog)
*!*	           ciClo2 = .T.
*!*	           DO WHILE ciClo2
*!*	                SELECT vaRios
*!*	                SET FILTER TO tiPo=xk
*!*	                GOTO TOP
*!*	                mlIstado = noMbre
*!*	                DO CASE
*!*	                     CASE xk='1'
*!*	                          DEFINE WINDOW liStados FROM 04, 07 TO 19, 71  ;
*!*	                                 FLOAT CLOSE SHADOW TITLE  ;
*!*	                                 'LISTADOS E INFORMES' SYSTEM COLOR GR+/ ;
*!*	                                 BG,GR+/W,N/W,N/W 
*!*	                          ACTIVATE WINDOW liStados
*!*	                          @ 00,00 get mlistado popup varios size 14,63 picture "@&T" color &color_05
*!*	                          READ
*!*	                     CASE xk='3'
*!*	                          DEFINE WINDOW liStados FROM 03, 06 TO 19, 72  ;
*!*	                                 FLOAT CLOSE SHADOW TITLE  ;
*!*	                                 'LISTADOS E INFORMES' SYSTEM COLOR GR+/ ;
*!*	                                 BG,GR+/W,N/W,N/W 
*!*	                          ACTIVATE WINDOW liStados
*!*	                          @ 00,00 get mlistado popup varios size 15,65 picture "@&T" color &color_05
*!*	                          READ
*!*	                     OTHERWISE
*!*	                          DEFINE WINDOW liStados FROM 05, 07 TO 17, 71  ;
*!*	                                 FLOAT CLOSE SHADOW TITLE  ;
*!*	                                 'LISTADOS E INFORMES' SYSTEM COLOR GR+/ ;
*!*	                                 BG,GR+/W,N/W,N/W 
*!*	                          ACTIVATE WINDOW liStados
*!*	                          @ 00,00 get mlistado popup varios size 13,63 picture "@&T" color &color_05
*!*	                          READ
*!*	                ENDCASE
*!*	                DEACTIVATE WINDOW liStados
*!*	                RELEASE WINDOW liStados
*!*	                IF LASTKEY()=27
*!*	                     EXIT
*!*	                ELSE
*!*	                     DO meNulis
*!*	                ENDIF
*!*	           ENDDO
*!*	      ENDIF
*!*	 ENDDO
*!*	 RETURN
*
PROCEDURE elIge_otro
 RESTORE SCREEN FROM paNtabase
 SELECT vaRios
 SET FILTER TO tiPo='O'
 GOTO TOP
 moTros = noMbre
 DEFINE WINDOW otRos FROM 02, 05 TO 22, 73 FLOAT CLOSE SHADOW TITLE  ;
        '< OTRAS OPCIONES >' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
 ACTIVATE WINDOW otRos
 @ 00,00 get motros popup varios size 19,67 picture "@&T" color &color_05
 READ
 DEACTIVATE WINDOW otRos
 RELEASE WINDOW otRos
 RETURN
*
PROCEDURE cuAdrito
 PARAMETER f1, c1, meNsaje
 c2 = LEN(meNsaje)
 @ f1, c1 TO f1+2, (c1+c2+1)
 @ f1+1,(c1+c2+2) to f1+2,(c1+c2+2) "±" color &color_02
 @ f1+3,c1+1 to f1+3,(c1+c2+2) "±"      color &color_02
 @ f1+1, c1+1 SAY meNsaje COLOR GR+/B 
 RETURN
*
PROCEDURE diBuja_fon
 PARAMETER poNe_el_me
 nv = ' '+npEso+' '
 ceNtro = 40-INT(LEN(nv)/2)
 CLEAR
 DO CASE
      CASE poNe_el_me=0
           IF ISCOLOR()
                @ 00, 00 TO 00, 79 ' ' COLOR N/B 
                @ 00, ceNtro SAY nv COLOR GR+/B 
           ELSE
                @ 00, 00 TO 00, 79 ' ' COLOR N/W 
                @ 00, ceNtro SAY nv COLOR N/W 
           ENDIF
           @ 24, 00 TO 24, 79 ' ' COLOR N/B 
      CASE poNe_el_me=1
           @ 00, 00 TO 00, 79 ' ' COLOR N/W 
           @ 00, ceNtro SAY nv COLOR N/W 
           @ 24, 00 TO 24, 79 ' ' COLOR N/W 
           @ 24, 01 SAY  ;
             '[F1] Ayuda [F2] Agrega [F3] Modifica [F8] Borra [ESP] Elige Archivo [ESC] Sale'  ;
             COLOR N/W 
           @ 24,01 say "[F1]"   color &color_09
           @ 24,12 say "[F2]"   color &color_09
           @ 24,24 say "[F3]"   color &color_09
           @ 24,38 say "[F8]"   color &color_09
           @ 24,49 say "[ESP]"  color &color_09
           @ 24,69 say "[ESC]"  color &color_09
      CASE poNe_el_me=2
           @ 00, 00 TO 00, 79 ' ' COLOR W/W 
           @ 00, ceNtro SAY nv COLOR N/W 
           @ 24, 00 TO 24, 79 ' ' COLOR W/W 
 ENDCASE
 c = 0
 FOR a = 1 TO 10
      FOR b = c TO c+3
           DO reTardar WITH 0.01
           @ a,b to 24-a,79-b "²" color &color_01
      ENDFOR
      c = b
 ENDFOR
 DO CASE
      CASE poNe_el_me=0
           SAVE SCREEN TO paNtabase
      CASE poNe_el_me=1
           SAVE SCREEN TO paNtamante
           prImera_ve = .F.
      CASE poNe_el_me=2
           SAVE SCREEN TO paNtaconsu
           coNs_p_vez = .F.
 ENDCASE
 RETURN
*
*!*	PROCEDURE paNtasis
*!*	 KEYBOARD '{spacebar}'
*!*	 WAIT WINDOW ''
*!*	 DO diBuja_fon WITH 0
*!*	 IF  .NOT. acCeso_s()
*!*	      CLEAR
*!*	      QUIT
*!*	 ENDIF
*!*	 IF muSuario<>1 .AND. muSop(1,1)<>'X'
*!*	      QUIT
*!*	 ENDIF
*!*	 IF apP
*!*	      DO cuAdro
*!*	 ENDIF
*!*	 PUBLIC paNtasis, paNtasis2
*!*	 SAVE SCREEN TO paNtasis2
*!*	 DO cuAdrito WITH 05, 05, ' 1.   SISTEMA INTEGRADO     '
*!*	 DO cuAdrito WITH 11, 05, ' 2.    RE-ORGANIZACION      '
*!*	 DO cuAdrito WITH 17, 05, ' 3.  COPIA DE SEGURIDAD     '
*!*	 DO cuAdrito WITH 05, 46, ' 4. RECUPERACION DE DATOS  '
*!*	 DO cuAdrito WITH 11, 46, ' 0.  SALIR DE ESTE MENU    '
*!*	 SAVE SCREEN TO paNtasis
*!*	 RETURN
*
FUNCTION deSea_cie
 STORE SPACE(1) TO mbOrrar
 DO WHILE .T.
      WAIT TO mbOrrar WINDOW  ;
           'DESEA UTILIZAR CODIGOS DEL (P)RODUCTO O (C)ODIGO ORIGINAL'
      mbOrrar = UPPER(mbOrrar)
      IF mbOrrar='P' .OR. mbOrrar='C'
           EXIT
      ENDIF
 ENDDO
 DO CASE
      CASE mbOrrar='P'
           reTorno = .T.
      CASE mbOrrar='C'
           reTorno = .F.
 ENDCASE
 RETURN reTorno
*
FUNCTION deSea_borr
 STORE SPACE(1) TO mbOrrar
 DO WHILE .T.
      WAIT TO mbOrrar WINDOW 'DESEA BORRARLO (S/N)'
      mbOrrar = UPPER(mbOrrar)
      IF mbOrrar='S' .OR. mbOrrar='N'
           EXIT
      ENDIF
 ENDDO
 DO CASE
      CASE mbOrrar='S'
           reTorno = .T.
      CASE mbOrrar='N'
           reTorno = .F.
 ENDCASE
 RETURN reTorno
*
FUNCTION deSea_ba
 STORE SPACE(1) TO mbOrrar
 DO WHILE .T.
      WAIT TO mbOrrar WINDOW 'DESEA: (B)ORRARLO o (A)NULARLO ?'
      mbOrrar = UPPER(mbOrrar)
      IF mbOrrar='B' .OR. mbOrrar='A' .OR. LASTKEY()=27
           EXIT
      ENDIF
 ENDDO
 IF mbOrrar='B' .OR. mbOrrar='A'
      reTorno = .T.
 ELSE
      reTorno = .F.
 ENDIF
 RETURN reTorno
*
FUNCTION esTa_ud_se
 STORE SPACE(1) TO msEguro
 DO WHILE .T.
      WAIT TO msEguro WINDOW 'ESTA UD. SEGURO ? (S/N)'
      msEguro = UPPER(msEguro)
      IF msEguro='S' .OR. msEguro='N'
           EXIT
      ENDIF
 ENDDO
 DO CASE
      CASE msEguro='S'
           reTorno = .T.
      CASE msEguro='N'
           reTorno = .F.
 ENDCASE
 RETURN reTorno
*
FUNCTION esTa_corre
 STORE SPACE(1) TO mcOrrecto
 DO WHILE .T.
      WAIT TO mcOrrecto WINDOW 'ESTA CORRECTO ? (S/N)'
      mcOrrecto = UPPER(mcOrrecto)
      IF mcOrrecto='S' .OR. mcOrrecto='N' .OR. LASTKEY()=27
           EXIT
      ENDIF
 ENDDO
 DO CASE
      CASE mcOrrecto='S'
           reTorno = .T.
      CASE mcOrrecto='N' .OR. LASTKEY()=27
           reTorno = .F.
 ENDCASE
 RETURN reTorno
*
FUNCTION deSea_sali
 PARAMETER pnRomensaj
 PUBLIC msAlir
 STORE SPACE(1) TO msAlir
 DO WHILE .T.
      DO CASE
           CASE pnRomensaj=1
                WAIT TO msAlir WINDOW 'DESEA SALIR DEL SISTEMA (S/N) ?'
           CASE pnRomensaj=2
                WAIT TO msAlir WINDOW  ;
                     'DESEA RETORNAR AL MENU PRINCIPAL (S/N) ?'
      ENDCASE
      msAlir = UPPER(msAlir)
      IF msAlir='S' .OR. msAlir='N'
           EXIT
      ENDIF
 ENDDO
 DO CASE
      CASE msAlir='S'
           reTorno = .T.
      CASE msAlir='N'
           reTorno = .F.
 ENDCASE
 RETURN reTorno
*
FUNCTION deSea_grab
 PUBLIC mgRabar
 STORE SPACE(1) TO mgRabar
 DO WHILE .T.
      WAIT TO mgRabar WINDOW 'DESEA GRABARLO ? (S/N)'
      mgRabar = UPPER(mgRabar)
      IF mgRabar='S' .OR. mgRabar='N' .OR. LASTKEY()=27
           EXIT
      ENDIF
 ENDDO
 IF mgRabar='S'
      reTorno = .T.
 ELSE
      reTorno = .F.
 ENDIF
 RETURN reTorno
*
FUNCTION deSea_cmot
 PUBLIC mcOpia
 STORE SPACE(1) TO mcOpia
 DO WHILE .T.
      WAIT TO mcOpia WINDOW  ;
           'DESEA COPIAR LOS DATOS DE MOVIMIENTOS DE OT ? (S/N)'
      mcOpia = UPPER(mcOpia)
      IF mcOpia='S' .OR. mcOpia='N' .OR. LASTKEY()=27
           EXIT
      ENDIF
 ENDDO
 IF mcOpia='S'
      reTorno = .T.
 ELSE
      reTorno = .F.
 ENDIF
 RETURN reTorno
*
FUNCTION deSea_ceot
 PUBLIC mcOpia
 STORE SPACE(1) TO mcOpia
 DO WHILE .T.
      WAIT TO mcOpia WINDOW 'DESEA CAMBIAR EL ESTADO DE LA OT ? (S/N)'
      mcOpia = UPPER(mcOpia)
      IF mcOpia='S' .OR. mcOpia='N' .OR. LASTKEY()=27
           EXIT
      ENDIF
 ENDDO
 IF mcOpia='S'
      reTorno = .T.
 ELSE
      reTorno = .F.
 ENDIF
 RETURN reTorno
*
FUNCTION deSea_act
 PUBLIC mgRabar
 STORE SPACE(1) TO mgRabar
 DO WHILE .T.
      WAIT TO mgRabar WINDOW 'DESEA ACTUALIZAR LOS PRECIOS ? (S/N)'
      mgRabar = UPPER(mgRabar)
      IF mgRabar='S' .OR. mgRabar='N' .OR. LASTKEY()=27
           EXIT
      ENDIF
 ENDDO
 IF mgRabar='S'
      reTorno = .T.
 ELSE
      reTorno = .F.
 ENDIF
 RETURN reTorno
*
FUNCTION deSea_impr
 PUBLIC miMprimir
 STORE SPACE(1) TO miMprimir
 DO WHILE .T.
      WAIT TO miMprimir WINDOW 'DESEA IMPRIMIR ? (S/N)'
      miMprimir = UPPER(miMprimir)
      IF miMprimir='S' .OR. miMprimir='N' .OR. LASTKEY()=27
           EXIT
      ENDIF
 ENDDO
 IF miMprimir='S'
      reTorno = .T.
 ELSE
      reTorno = .F.
 ENDIF
 RETURN reTorno
*
FUNCTION deSea_vfr
 PUBLIC mdEsea
 STORE SPACE(1) TO mdEsea_vfr
 DO WHILE .T.
      WAIT TO mdEsea_vfr WINDOW 'DESEA VISUALIZAR EN FORMA REDUCIDA ? (S/N)'
      mdEsea_vfr = UPPER(mdEsea_vfr)
      IF mdEsea_vfr='S' .OR. mdEsea_vfr='N' .OR. LASTKEY()=27
           EXIT
      ENDIF
 ENDDO
 IF mdEsea_vfr='S'
      reTorno = .T.
 ELSE
      reTorno = .F.
 ENDIF
 RETURN reTorno
*
PROCEDURE deSea_cls
 PUBLIC mcLs
 STORE SPACE(1) TO mcLs
 DO WHILE .T.
      WAIT TO mcLs WINDOW  ;
           'DESEA REALIZAR: (C)onsultas, (L)istados, (O)tros o (F)inalizar tareas ?'
      mcLs = UPPER(mcLs)
      IF mcLs='C' .OR. mcLs='L' .OR. mcLs='F' .OR. mcLs='O' .OR. LASTKEY()=27
           EXIT
      ENDIF
 ENDDO
 RETURN
*
PROCEDURE deStino
 STORE SPACE(1) TO mdEstino
 DO WHILE .T.
      WAIT TO mdEstino WINDOW 'DESTINO: (P)ANTALLA o (I)MPRESORA'
      mdEstino = UPPER(mdEstino)
      IF mdEstino='P' .OR. mdEstino='I' .OR. LASTKEY()=27
           EXIT
      ENDIF
 ENDDO
 RETURN
*
PROCEDURE coD_o_nom
 STORE SPACE(1) TO mcOdonom
 DO WHILE .T.
      WAIT TO mcOdonom WINDOW 'ORDENADO POR: (C)ODIGO o (N)OMBRE'
      mcOdonom = UPPER(mcOdonom)
      IF mcOdonom='C' .OR. mcOdonom='N' .OR. LASTKEY()=27
           EXIT
      ENDIF
 ENDDO
 RETURN
*
PROCEDURE alCance
 STORE SPACE(1) TO maLcance
 DO WHILE .T.
      WAIT TO maLcance WINDOW 'ALCANCE: (T)OTAL o (P)ARCIAL'
      maLcance = UPPER(maLcance)
      IF maLcance='T' .OR. maLcance='P' .OR. LASTKEY()=27
           EXIT
      ENDIF
 ENDDO
 RETURN
*
FUNCTION miLookup
 PARAMETER _dEscripci, _cLave, _aRchivo, _iNdice
 select &_archivo
 _iNdiviejo = SYS(21)
 SET ORDER TO _indice
 SEEK _cLave
 IF FOUND()
      _descripcion = &_descripcion
 ELSE
      _dEscripci = ''
 ENDIF
 set order to &_indiviejo
 select &archivo
 RETURN _dEscripci
*
FUNCTION geNnumer
 select &archivo
 PRIVATE k
 DO CASE
      CASE arChivo='CLIENTES' .OR. arChivo='PROVEEDORES'
           IF RECCOUNT()=0
                mcOdigon = 1
           ELSE
                SET ORDER TO 1
                GOTO BOTTOM
                mcOdigon = coDigo+1
           ENDIF
      CASE arChivo='CABEVENT' .OR. arChivo='CABECOMP'
           mcOdigon = 0
           IF mtIpodocu>=1 .AND. mtIpodocu<=5
                SET ORDER TO 1
                SET EXACT OFF
                SEEK STR(mtIpodocu, 1)
                SET EXACT ON
                IF FOUND()
                     FOR k = mtIpodocu+1 TO 6
                          SET EXACT OFF
                          SEEK STR(k, 1)
                          SET EXACT ON
                          IF k=6 .OR. FOUND()
                               SKIP -1
                               mcOdigon = nrOdocu+1
                               k = 6
                          ENDIF
                     ENDFOR
                ELSE
                     mcOdigon = 1
                ENDIF
           ENDIF
      CASE arChivo='CABENOTC' .OR. arChivo='CABENOTP'
           mcOdigon = 0
           IF mtIponota>=1 .AND. mtIponota<=4
                SET ORDER TO 1
                SET EXACT OFF
                SEEK STR(mtIponota, 1)
                SET EXACT ON
                IF FOUND()
                     FOR k = mtIponota+1 TO 5
                          SET EXACT OFF
                          SEEK STR(k, 1)
                          SET EXACT ON
                          IF k=5 .OR. FOUND()
                               SKIP -1
                               mcOdigon = nrOnota+1
                               k = 5
                          ENDIF
                     ENDFOR
                ELSE
                     mcOdigon = 1
                ENDIF
           ENDIF
      CASE arChivo='CABECOB' .OR. arChivo='CABEPAG'
           IF RECCOUNT()=0
                mcOdigon = 1
           ELSE
                IF mtIporeci>=1 .AND. mtIporeci<=2
                     SET ORDER TO 1
                     SET EXACT OFF
                     SEEK STR(mtIporeci+1, 1)
                     SET EXACT ON
                     SKIP -1
                     IF mtIporeci=tiPoreci
                          mcOdigon = nrOreci+1
                     ELSE
                          mcOdigon = 1
                     ENDIF
                ELSE
                     mcOdigon = 0
                ENDIF
           ENDIF
      CASE arChivo='CABEMOVI' .OR. arChivo='CABEMOT'
           SET EXACT OFF
           SEEK STR((mtIpobole+1), 1)
           IF FOUND()
                SKIP -1
                IF tiPobole=1
                     mcOdigon = nrObole+1
                ELSE
                     SEEK STR(mtIpobole, 1)
                     IF FOUND()
                          DO WHILE mtIpobole=tiPobole .AND.  .NOT. EOF()
                               mcOdigon = nrObole+1
                               SKIP 1
                          ENDDO
                     ELSE
                          mcOdigon = 1
                     ENDIF
                ENDIF
           ELSE
                SEEK STR(mtIpobole, 1)
                IF FOUND()
                     DO WHILE mtIpobole=tiPobole .AND.  .NOT. EOF()
                          mcOdigon = nrObole+1
                          SKIP 1
                     ENDDO
                ELSE
                     mcOdigon = 1
                ENDIF
           ENDIF
           SET EXACT ON
      CASE arChivo='CABEREMI'
           SET EXACT OFF
           SEEK STR((mtIporemi), 1)+msErie
           IF  .NOT. FOUND()
                mcOdigon = 1
           ELSE
                DO WHILE mtIporemi=tiPoremi .AND. msErie=seRie .AND.   ;
                   .NOT. EOF()
                     mcOdigon = nrOremi+1
                     SKIP 1
                ENDDO
           ENDIF
      CASE arChivo='CABEPRES'
           IF RECCOUNT()=0
                mcOdigon = 1
           ELSE
                IF mtIpodocu>=1 .AND. mtIpodocu<=2
                     SET ORDER TO 1
                     SET EXACT OFF
                     SEEK STR(mtIpodocu+1, 1)
                     SET EXACT ON
                     SKIP -1
                     IF mtIpodocu=tiPodocu
                          mcOdigon = nrOdocu+1
                     ELSE
                          mcOdigon = 1
                     ENDIF
                ELSE
                     mcOdigon = 0
                ENDIF
           ENDIF
 ENDCASE
 SET EXACT ON
 RETURN mcOdigon
*
FUNCTION nuMletra
 PARAMETER nuMero
 PRIVATE s, i, leTra, x, y
 SET TALK OFF
 IF nuMero<>0
      leTra = STR(nuMero, 9)
      s = ''
      a = SUBSTR(leTra, 1, 3)
      b = SUBSTR(leTra, 4, 3)
      c = SUBSTR(leTra, 7, 3)
      IF VAL(leTra)=0
           s = s+'CERO'
      ELSE
           IF VAL(a)<>0
                s = s+coNvierte(a)
                IF VAL(RIGHT(a, 1))=1 .AND. SUBSTR(a, 2, 2)<>'11'
                     s = LEFT(s, LEN(s)-2)+' '
                ENDIF
                IF nuMero>=2000000
                     s = s+'MILLONES '
                ELSE
                     s = s+'MILLON '
                ENDIF
           ENDIF
           IF VAL(b)<>0
                s = s+coNvierte(b)
                IF nuMero>=1000 .AND. nuMero<2000
                     s = RIGHT(s, LEN(s)-4)
                ELSE
                     IF VAL(RIGHT(b, 1))=1 .AND. SUBSTR(b, 2, 2)<>'11'
                          s = LEFT(s, LEN(s)-2)+' '
                     ENDIF
                ENDIF
                s = s+'MIL '
           ENDIF
           IF VAL(c)<>0
                s = s+coNvierte(c)
                IF RIGHT(s, 2)='Y '
                     s = LEFT(s, LEN(s)-2)
                ENDIF
           ENDIF
      ENDIF
      enLetra = s
 ELSE
      enLetra = 'CERO'
 ENDIF
 RETURN enLetra
*
FUNCTION coNvierte
 PARAMETER w
 PRIVATE x, z, y
 STORE '' TO x, y, z
 x = SUBSTR(w, 1, 1)
 IF VAL(x)<>0
      IF x='1'
           IF VAL(RIGHT(w, 2))=0
                y = y+'CIEN '
           ELSE
                y = y+'CIENTO '
           ENDIF
      ELSE
           DO CASE
                CASE x='2'
                     y = y+'DOSCI'
                CASE x='3'
                     y = y+'TRESCI'
                CASE x='4'
                     y = y+'CUATROCI'
                CASE x='5'
                     y = y+'QUINI'
                CASE x='6'
                     y = y+'SEISCI'
                CASE x='7'
                     y = y+'SETECI'
                CASE x='8'
                     y = y+'OCHOCI'
                CASE x='9'
                     y = y+'NOVECI'
           ENDCASE
           y = y+'ENTOS '
      ENDIF
 ENDIF
 x = SUBSTR(w, 2, 1)
 z = SUBSTR(w, 3, 1)
 IF VAL(x)<>0
      IF x='1'
           DO CASE
                CASE z='0'
                     y = y+'DIEZ '
                CASE z='1'
                     y = y+'ONCE '
                CASE z='2'
                     y = y+'DOCE '
                CASE z='3'
                     y = y+'TRECE '
                CASE z='4'
                     y = y+'CATORCE '
                CASE z='5'
                     y = y+'QUINCE '
                CASE z='6'
                     y = y+'DIECISEIS '
                CASE z='7'
                     y = y+'DIECISIETE '
                CASE z='8'
                     y = y+'DIECIOCHO '
                CASE z='9'
                     y = y+'DIECINUEVE '
           ENDCASE
      ELSE
           DO CASE
                CASE x='2'
                     IF z='0'
                          y = y+'VEINTE '
                     ELSE
                          y = y+'VEINTI'
                     ENDIF
                CASE x='3'
                     y = y+'TREINTA Y '
                CASE x='4'
                     y = y+'CUARENTA Y '
                CASE x='5'
                     y = y+'CINCUENTA Y '
                CASE x='6'
                     y = y+'SESENTA Y '
                CASE x='7'
                     y = y+'SETENTA Y '
                CASE x='8'
                     y = y+'OCHENTA Y '
                CASE x='9'
                     y = y+'NOVENTA Y '
           ENDCASE
           IF VAL(x)>3 .AND. VAL(z)=0
                y = LEFT(y, LEN(y)-2)
           ENDIF
      ENDIF
 ENDIF
 IF x<>'1'
      DO CASE
           CASE z='1'
                y = y+'UNO '
           CASE z='2'
                y = y+'DOS '
           CASE z='3'
                y = y+'TRES '
           CASE z='4'
                y = y+'CUATRO '
           CASE z='5'
                y = y+'CINCO '
           CASE z='6'
                y = y+'SEIS '
           CASE z='7'
                y = y+'SIETE '
           CASE z='8'
                y = y+'OCHO '
           CASE z='9'
                y = y+'NUEVE '
      ENDCASE
 ENDIF
 RETURN y
*
FUNCTION deScmes
 PARAMETER mmEs, fiLa, coLumna, imPrime_li
 DO CASE
      CASE mmEs=1
           auXicar = 'ENERO    '
      CASE mmEs=2
           auXicar = 'FEBRERO  '
      CASE mmEs=3
           auXicar = 'MARZO    '
      CASE mmEs=4
           auXicar = 'ABRIL    '
      CASE mmEs=5
           auXicar = 'MAYO     '
      CASE mmEs=6
           auXicar = 'JUNIO    '
      CASE mmEs=7
           auXicar = 'JULIO    '
      CASE mmEs=8
           auXicar = 'AGOSTO   '
      CASE mmEs=9
           auXicar = 'SETIEMBRE'
      CASE mmEs=10
           auXicar = 'OCTUBRE  '
      CASE mmEs=11
           auXicar = 'NOVIEMBRE'
      CASE mmEs=12
           auXicar = 'DICIEMBRE'
      OTHERWISE
           auXicar = '         '
 ENDCASE
 IF imPrime_li
      @ fiLa, coLumna SAY auXicar
 ELSE
      RETURN auXicar
 ENDIF
 RETURN
*
PROCEDURE liMpia
 DEACTIVATE WINDOW ALL
 RELEASE WINDOW alL
 DEACTIVATE MENU maInmenu
 RELEASE MENU maInmenu
 RETURN
*
PROCEDURE reTardar
 PARAMETER reTardo
 tiEmpo = SECONDS()+reTardo
 DO WHILE SECONDS()<=tiEmpo
 ENDDO
 RETURN
*
PROCEDURE reLoj
 IF reLoj
      SET CLOCK OFF
      reLoj = .F.
 ELSE
      SET CLOCK ON
      reLoj = .T.
 ENDIF
 RETURN
*
FUNCTION crEatemp
 DO WHILE .T.
      vaR = 'TM'+SUBSTR(TIME(), 1, 2)+SUBSTR(TIME(), 4, 2)+SUBSTR(TIME(), 7, 2)
      IF  .NOT. FILE(vaR+'.DBF') .AND.  .NOT. FILE(vaR+'.NTX')
           vaR1 = 'VAR'
           VARI = &VAR1
           EXIT
      ENDIF
 ENDDO
 RETURN vaRi
*
PROCEDURE boRratm
 PARAMETER abOrrar
 PRIVATE arChitm1, arChitm2, arChitm3, arChitm4
 arChitm1 = abOrrar+'.DBF'
 arChitm2 = abOrrar+'.IDX'
 arChitm3 = abOrrar+'.VUE'
 arChitm4 = abOrrar+'.CDX'
 IF FILE(arChitm1)
      delete file &architm1
 ENDIF
 IF FILE(arChitm2)
      delete file &architm2
 ENDIF
 IF FILE(arChitm3)
      delete file &architm3
 ENDIF
 IF FILE(arChitm4)
      delete file &architm4
 ENDIF
 RETURN
*
PROCEDURE acTiva_set
 SET CONSOLE OFF
 SET DEVICE TO PRINTER
 SET PRINTER ON
 RETURN
*
PROCEDURE deSactiva_
 SET PRINTER OFF
 SET DEVICE TO SCREEN
 SET CONSOLE ON
 RETURN
*
PROCEDURE prEsione
 SET CURSOR OFF
 CLEAR TYPEAHEAD
 DO WHILE INKEY()=0
 ENDDO
 SET CURSOR ON
 RETURN
*
FUNCTION meS_y_ano
 DEFINE WINDOW feCha FROM 10, 23 TO 12, 56 SHADOW
 ACTIVATE WINDOW feCha
 @ 00, 01 SAY 'MES y A¥O:'
 DO WHILE .T.
      STORE MONTH(DATE()) TO mmEs
      STORE YEAR(DATE()) TO maNo
      @ 00, 12 GET mmEs PICTURE '99' VALID deScmes(mmEs,00,21,.T.)
      @ 00, 15 GET maNo PICTURE '9999'
      READ
      IF LASTKEY()=27 .OR. ((mmEs>=1 .AND. mmEs<=12) .AND. maNo>=1994)
           EXIT
      ENDIF
 ENDDO
 DEACTIVATE WINDOW feCha
 RELEASE WINDOW feCha
 IF LASTKEY()=27
      reTorno = .F.
 ELSE
      reTorno = .T.
 ENDIF
 RETURN reTorno
*
FUNCTION piDe_mes
 DEFINE WINDOW pmEs FROM 10, 26 TO 12, 53 SHADOW
 ACTIVATE WINDOW pmEs
 @ 00, 01 SAY 'MES:'
 DO WHILE .T.
      STORE MONTH(DATE()) TO mmEs
      @ 00, 12 GET mmEs PICTURE '99' VALID deScmes(mmEs,00,18,.T.)
      READ
      IF LASTKEY()=27 .OR. (mmEs>=1 .AND. mmEs<=12)
           EXIT
      ENDIF
 ENDDO
 DEACTIVATE WINDOW pmEs
 RELEASE WINDOW pmEs
 reTorno = .T.
 IF LASTKEY()=27
      reTorno = .F.
 ENDIF
 RETURN reTorno
*
FUNCTION piDe_mes_y
 DEFINE WINDOW meSano FROM 10, 23 TO 12, 56 SHADOW
 ACTIVATE WINDOW meSano
 @ 00, 01 SAY 'MES y A¥O:'
 DO WHILE .T.
      STORE MONTH(DATE()) TO mmEs
      STORE YEAR(DATE()) TO maNo
      @ 00, 12 GET mmEs PICTURE '99' VALID deScmes(mmEs,00,21,.T.)
      @ 00, 15 GET maNo PICTURE '9999'
      READ
      IF LASTKEY()=27 .OR. (mmEs>=1 .AND. mmEs<=12)
           EXIT
      ENDIF
 ENDDO
 DEACTIVATE WINDOW meSano
 RELEASE WINDOW meSano
 reTorno = .T.
 IF LASTKEY()=27
      reTorno = .F.
 ENDIF
 RETURN reTorno
*
FUNCTION piDe_ano
 DEFINE WINDOW anO FROM 10, 34 TO 12, 46 SHADOW
 ACTIVATE WINDOW anO
 @ 00, 01 SAY 'A¥O:'
 DO WHILE .T.
      STORE YEAR(DATE()) TO maNo
      @ 00, 06 GET maNo PICTURE '9999'
      READ
      IF LASTKEY()=27 .OR. maNo>=1992
           EXIT
      ENDIF
 ENDDO
 DEACTIVATE WINDOW anO
 RELEASE WINDOW anO
 reTorno = .T.
 IF LASTKEY()=27
      reTorno = .F.
 ENDIF
 RETURN reTorno
*
FUNCTION ptDmov
 PARAMETER imPrime_de, ffIla, fcOlumna
 IF mtIpobole=0
      DEFINE WINDOW moVim01 FROM 08, 29 TO 15, 51 FLOAT SHADOW TITLE  ;
             'TIPO DOC.' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
      ACTIVATE WINDOW moVim01
      SET COLOR TO W+/BG, BG+/B
      @ 00, 00 TO 05, 20 COLOR W+/BG 
      @ 01, 01 PROMPT ' 1. ENTRADA        '
      @ 02, 01 PROMPT ' 2. SALIDA         '
      @ 03, 01 PROMPT ' 3. AJUSTE-ENTRADA '
      @ 04, 01 PROMPT ' 4. AJUSTE-SALIDA  '
      MENU TO mtIpobole
      SET COLOR TO
      DEACTIVATE WINDOW moVim01
      RELEASE WINDOW moVim01
      IF LASTKEY()=27
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say movim02(mtipobole) color &color_06
           ENDIF
      ENDIF
 ELSE
      IF mtIpobole<1 .OR. mtIpobole>4
           WAIT WINDOW 'EL TIPO DE BOLETA DEBE SER DEL 1 AL 4 !'
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say movim02(mtipobole) color &color_06
           ENDIF
      ENDIF
 ENDIF
 RETURN
*
FUNCTION ptDmot
 PARAMETER imPrime_de, ffIla, fcOlumna
 IF mtIpobole=0
      DEFINE WINDOW moVim01 FROM 09, 31 TO 14, 49 FLOAT SHADOW TITLE  ;
             'TIPO DOC.' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
      ACTIVATE WINDOW moVim01
      SET COLOR TO W+/BG, BG+/B
      @ 00, 00 TO 03, 16 COLOR W+/BG 
      @ 01, 01 PROMPT ' 1. ENTRADA    '
      @ 02, 01 PROMPT ' 2. SALIDA     '
      MENU TO mtIpobole
      SET COLOR TO
      DEACTIVATE WINDOW moVim01
      RELEASE WINDOW moVim01
      IF LASTKEY()=27
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say movim02(mtipobole) color &color_06
           ENDIF
      ENDIF
 ELSE
      IF mtIpobole<1 .OR. mtIpobole>2
           WAIT WINDOW 'EL TIPO DE BOLETA DEBE SER DEL 1 AL 2 !'
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say movim02(mtipobole) color &color_06
           ENDIF
      ENDIF
 ENDIF
 RETURN
*
FUNCTION moVim02
 PARAMETER mtIpobolet
 DO CASE
      CASE mtIpobolet=0
           RETURN '          '
      CASE mtIpobolet=1
           RETURN 'ENTRADA   '
      CASE mtIpobolet=2
           RETURN 'SALIDA    '
      CASE mtIpobolet=3
           RETURN 'AJUSTE (E)'
      CASE mtIpobolet=4
           RETURN 'AJUSTE (S)'
 ENDCASE
 RETURN
*
FUNCTION ptAcontra
 PARAMETER imPrime_de, ffIla, fcOlumna
 IF maPlicontr=0
      DEFINE WINDOW moVim01 FROM 09, 31 TO 14, 49 FLOAT SHADOW TITLE  ;
             'APL. CONTRA' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
      ACTIVATE WINDOW moVim01
      SET COLOR TO W+/BG, BG+/B
      @ 00, 00 TO 03, 16 COLOR W+/BG 
      @ 01, 01 PROMPT ' 1. CTA. CTE. '
      @ 02, 01 PROMPT ' 2. CAJA      '
      MENU TO maPlicontr
      SET COLOR TO
      DEACTIVATE WINDOW moVim01
      RELEASE WINDOW moVim01
      IF LASTKEY()=27
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say acontra(maplicontra) color &color_06
           ENDIF
      ENDIF
 ELSE
      IF mtIponota=2 .OR. mtIponota=4
           IF maPlicontr<1 .OR. maPlicontr>2
                WAIT WINDOW  ;
                     'APLICADO CONTRA DEBE SER: (1) CTA. CTE. o (2) CAJA !'
                RETURN 0
           ENDIF
      ELSE
           IF  .NOT. maPlicontr=0
                WAIT WINDOW 'APLICADO CONTRA DEBE SER CERO !'
                RETURN 0
           ENDIF
      ENDIF
      IF imPrime_de
           @ ffila,fcolumna say acontra(maplicontra) color &color_06
      ENDIF
 ENDIF
 RETURN
*
FUNCTION acOntra
 PARAMETER maPlicontr
 DO CASE
      CASE maPlicontr=0
           RETURN '          '
      CASE maPlicontr=1
           RETURN 'CTA. CTE  '
      CASE maPlicontr=2
           RETURN 'CAJA      '
 ENDCASE
 RETURN
*
FUNCTION loCalpago
 PARAMETER imPrime_de, ffIla, fcOlumna
 IF mlOcalpago=0
      DEFINE WINDOW moVim01 FROM 09, 30 TO 14, 50 FLOAT SHADOW TITLE  ;
             'APL. CONTRA' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
      ACTIVATE WINDOW moVim01
      SET COLOR TO W+/BG, BG+/B
      @ 00, 00 TO 03, 18 COLOR W+/BG 
      @ 01, 01 PROMPT ' 1. LOCAL       '
      @ 02, 01 PROMPT ' 2. CONSOLIDADO '
      MENU TO mlOcalpago
      SET COLOR TO
      DEACTIVATE WINDOW moVim01
      RELEASE WINDOW moVim01
      IF LASTKEY()=27
           RETURN 0
      ENDIF
 ELSE
      IF mlOcalpago<1 .OR. mlOcalpago>2
           WAIT WINDOW  ;
                'EL LOCAL DE PAGO DEBE SER: (1) LOCAL o (2) CONSOLIDADO !'
           RETURN 0
      ENDIF
 ENDIF
 IF imPrime_de
      @ ffila,fcolumna say localpago2(mlocalpago) color &color_06
 ENDIF
 RETURN
*
FUNCTION loCalpago2
 PARAMETER mlOcalpago
 DO CASE
      CASE mlOcalpago=0
           RETURN '           '
      CASE mlOcalpago=1
           RETURN 'LOCAL      '
      CASE mlOcalpago=2
           RETURN 'CONSOLIDADO'
 ENDCASE
 RETURN
*
FUNCTION ptIpodocvt
 PARAMETER imPrime_de, ffIla, fcOlumna
 IF mtIpodocu=0
      DEFINE WINDOW coMpras03 FROM 07, 27 TO 15, 53 FLOAT CLOSE ZOOM  ;
             SHADOW TITLE 'TIPO DE DOCUMENTO' SYSTEM COLOR GR+/BG,GR+/W,N/ ;
             W,N/W 
      ACTIVATE WINDOW coMpras03
      SET COLOR TO W+/BG, BG+/B
      @ 00, 00 TO 06, 24 COLOR W+/BG 
      @ 01, 01 PROMPT ' 1. FACTURA CONTADO    '
      @ 02, 01 PROMPT ' 2. FACTURA CREDITO    '
      @ 03, 01 PROMPT ' 3. IVA INCLUIDO       '
      @ 04, 01 PROMPT ' 4. C.I. VTA. CONTADO  '
      @ 05, 01 PROMPT ' 5. C.I. VTA. CREDITO  '
      MENU TO mtIpodocu
      SET COLOR TO
      DEACTIVATE WINDOW coMpras03
      RELEASE WINDOW coMpras03
      IF LASTKEY()=27
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say compras04(mtipodocu) color &color_06
           ENDIF
      ENDIF
 ELSE
      IF mtIpodocu<1 .OR. mtIpodocu>5
           WAIT WINDOW 'EL TIPO DE DOCUMENTO DEBE SER DEL 1 AL 5 !'
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say compras04(mtipodocu) color &color_06
           ENDIF
      ENDIF
 ENDIF
 RETURN
*
FUNCTION coMpras04
 PARAMETER mtIpodocu
 DO CASE
      CASE mtIpodocu=0
           RETURN '                  '
      CASE mtIpodocu=1
           RETURN 'FACTURA CONTADO   '
      CASE mtIpodocu=2
           RETURN 'FACTURA CREDITO   '
      CASE mtIpodocu=3
           RETURN 'IVA INCLUIDO      '
      CASE mtIpodocu=4
           RETURN 'C.I. VTA. CONTADO '
      CASE mtIpodocu=5
           RETURN 'C.I. VTA. CREDITO '
 ENDCASE
 RETURN
*
FUNCTION piDe_local
 PARAMETER imPrime_de, ffIla, fcOlumna
 IF mlOcal=0
      DEFINE WINDOW coMpras03 FROM 07, 32 TO 15, 49 FLOAT CLOSE ZOOM  ;
             SHADOW TITLE 'LOCAL' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
      ACTIVATE WINDOW coMpras03
      SET COLOR TO W+/BG, BG+/B
      @ 00, 00 TO 06, 24 COLOR W+/BG 
      @ 01, 01 PROMPT ' 1. -         '
      @ 02, 01 PROMPT ' 2. CENTRAL   '
      @ 03, 01 PROMPT ' 3. MECANICOS '
      @ 04, 01 PROMPT ' 4. CHACOMER  '
      @ 05, 01 PROMPT ' 5. BRASIL    '
      MENU TO mlOcal
      SET COLOR TO
      DEACTIVATE WINDOW coMpras03
      RELEASE WINDOW coMpras03
      IF LASTKEY()=27
           RETURN 0
      ENDIF
 ELSE
      IF mlOcal<1 .OR. mlOcal>5
           WAIT WINDOW 'EL CODIGO DEL LOCAL DEBE SER DEL 1 AL 5 !'
           RETURN 0
      ENDIF
 ENDIF
 IF imPrime_de
      @ ffila,fcolumna say local2(mlocal) color &color_06
 ENDIF
 RETURN
*
FUNCTION loCal2
 PARAMETER mlOcal
 DO CASE
      CASE mlOcal=0 .OR. mlOcal=1
           RETURN '         '
      CASE mlOcal=2
           RETURN 'CENTRAL  '
      CASE mlOcal=3
           RETURN 'MECANICOS'
      CASE mlOcal=4
           RETURN 'CHACOMER '
      CASE mlOcal=5
           RETURN 'BRASIL   '
 ENDCASE
 RETURN
*
FUNCTION ptIpodocpr
 PARAMETER imPrime_de, ffIla, fcOlumna
 IF mtIpodocu=0
      DEFINE WINDOW coMpras03 FROM 09, 28 TO 14, 52 FLOAT CLOSE ZOOM  ;
             SHADOW TITLE 'TIPO DE PRESUPUESTO' SYSTEM COLOR GR+/BG,GR+/W, ;
             N/W,N/W 
      ACTIVATE WINDOW coMpras03
      SET COLOR TO W+/BG, BG+/B
      @ 00, 00 TO 03, 22 COLOR W+/BG 
      @ 01, 01 PROMPT ' 1. PRESUPUESTO      '
      @ 02, 01 PROMPT ' 2. C.I. PRESUPUESTO '
      MENU TO mtIpodocu
      SET COLOR TO
      DEACTIVATE WINDOW coMpras03
      RELEASE WINDOW coMpras03
      IF LASTKEY()=27
           RETURN 0
      ENDIF
 ELSE
      IF mtIpodocu<1 .OR. mtIpodocu>2
           WAIT WINDOW 'EL TIPO DE PRESUPUESTO DEBE SER: 1 o 2 !'
           RETURN 0
      ENDIF
 ENDIF
 IF imPrime_de
      @ ffila,fcolumna say ptdocpre(mtipodocu) color &color_06
 ENDIF
 RETURN
*
FUNCTION ptDocpre
 PARAMETER mtIpodocu
 DO CASE
      CASE mtIpodocu=0
           RETURN '                '
      CASE mtIpodocu=1
           RETURN 'PRESUPUESTO     '
      CASE mtIpodocu=2
           RETURN 'C.I. PRESUPUESTO'
 ENDCASE
 RETURN
*
FUNCTION ptIpodocco
 PARAMETER imPrime_de, ffIla, fcOlumna
 IF mtIpodocu=0
      DEFINE WINDOW coMpras03 FROM 07, 26 TO 15, 53 FLOAT CLOSE ZOOM  ;
             SHADOW TITLE 'TIPO DE DOCUMENTO' SYSTEM COLOR GR+/BG,GR+/W,N/ ;
             W,N/W 
      ACTIVATE WINDOW coMpras03
      SET COLOR TO W+/BG, BG+/B
      @ 00, 00 TO 06, 25 COLOR W+/BG 
      @ 01, 01 PROMPT ' 1. COMPRA CONTADO      '
      @ 02, 01 PROMPT ' 2. COMPRA CREDITO      '
      @ 03, 01 PROMPT ' 3. COMPRA IVA INCLUIDO '
      @ 04, 01 PROMPT ' 4. C.I. COMPRA CONTADO '
      @ 05, 01 PROMPT ' 5. C.I. COMPRA CREDITO '
      MENU TO mtIpodocu
      SET COLOR TO
      DEACTIVATE WINDOW coMpras03
      RELEASE WINDOW coMpras03
      IF LASTKEY()=27
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say compras04(mtipodocu) color &color_06
           ENDIF
      ENDIF
 ELSE
      IF mtIpodocu<1 .OR. mtIpodocu>5
           WAIT WINDOW 'EL TIPO DE DOCUMENTO DEBE SER DEL 1 AL 5 !'
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say compras04a(mtipodocu) color &color_06
           ENDIF
      ENDIF
 ENDIF
 RETURN
*
FUNCTION coMpras04a
 PARAMETER mtIpodocu
 DO CASE
      CASE mtIpodocu=0
           RETURN '                    '
      CASE mtIpodocu=1
           RETURN 'COMPRA CONTADO      '
      CASE mtIpodocu=2
           RETURN 'COMPRA CREDITO      '
      CASE mtIpodocu=3
           RETURN 'COMPRA IVA INCLUIDO '
      CASE mtIpodocu=4
           RETURN 'C.I. COMPRA CONTADO '
      CASE mtIpodocu=5
           RETURN 'C.I. COMPRA CREDITO '
 ENDCASE
 RETURN
*
FUNCTION ptDcobro
 PARAMETER imPrime_de, ffIla, fcOlumna
 IF mtIporeci=0
      DEFINE WINDOW coBros04 FROM 07, 28 TO 12, 51 FLOAT CLOSE ZOOM  ;
             SHADOW TITLE 'TIPO RECIBO' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
      ACTIVATE WINDOW coBros04
      SET COLOR TO W+/BG, BG+/B
      @ 00, 00 TO 03, 21 COLOR W+/BG 
      @ 01, 01 PROMPT ' 1. RECIBO DE COBRO '
      @ 02, 01 PROMPT ' 2. C.I. DE COBRO   '
      MENU TO mtIporeci
      SET COLOR TO
      DEACTIVATE WINDOW coBros04
      RELEASE WINDOW coBros04
      IF LASTKEY()=27
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say cobros05(mtiporeci) color &color_06
           ENDIF
      ENDIF
 ELSE
      IF mtIporeci<1 .OR. mtIporeci>2
           WAIT WINDOW 'EL TIPO DE RECIBO DEBE SER: 1 o 2 !'
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say cobros05(mtiporeci) color &color_06
           ENDIF
      ENDIF
 ENDIF
 RETURN
*
FUNCTION coBros05
 PARAMETER mtIporeci
 DO CASE
      CASE mtIporeci=0
           RETURN '               '
      CASE mtIporeci=1
           RETURN 'RECIBO DE COBRO'
      CASE mtIporeci=2
           RETURN 'C.I. DE COBRO  '
 ENDCASE
 RETURN
*
FUNCTION ptDremi
 PARAMETER imPrime_de, ffIla, fcOlumna
 IF mtIporemi=0
      DEFINE WINDOW coBros04 FROM 07, 29 TO 12, 50 FLOAT CLOSE ZOOM  ;
             SHADOW TITLE 'TIPO REMISION' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
      ACTIVATE WINDOW coBros04
      SET COLOR TO W+/BG, BG+/B
      @ 00, 00 TO 03, 19 COLOR W+/BG 
      @ 01, 01 PROMPT ' 1. REMISION      '
      @ 02, 01 PROMPT ' 2. C.I. REMISION '
      MENU TO mtIporemi
      SET COLOR TO
      DEACTIVATE WINDOW coBros04
      RELEASE WINDOW coBros04
      IF LASTKEY()=27
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say remis01(mtiporemi) color &color_06
           ENDIF
      ENDIF
 ELSE
      IF mtIporemi<1 .OR. mtIporemi>2
           WAIT WINDOW 'EL TIPO DE REMISION DEBE SER: 1 o 2 !'
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say remis01(mtiporemi) color &color_06
           ENDIF
      ENDIF
 ENDIF
 RETURN
*
FUNCTION reMis01
 PARAMETER mtIporemi
 DO CASE
      CASE mtIporemi=0
           RETURN '             '
      CASE mtIporemi=1
           RETURN 'REMISION'
      CASE mtIporemi=2
           RETURN 'C.I. REMISION'
 ENDCASE
 RETURN
*
FUNCTION ptDnota
 PARAMETER imPrime_de, ffIla, fcOlumna
 IF mtIponota=0
      DEFINE WINDOW noTa01 FROM 07, 27 TO 14, 52 FLOAT CLOSE ZOOM SHADOW  ;
             TITLE 'TIPO DE DOCUMENTO' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
      ACTIVATE WINDOW noTa01
      SET COLOR TO W+/BG, BG+/B
      @ 00, 00 TO 05, 25 COLOR W+/BG 
      @ 01, 01 PROMPT ' 1. NOTA DE DEBITO    '
      @ 02, 01 PROMPT ' 2. NOTA DE CREDITO   '
      @ 03, 01 PROMPT ' 3. C.I. NOTA DEBITO  '
      @ 04, 01 PROMPT ' 4. C.I. NOTA CREDITO '
      MENU TO mtIponota
      SET COLOR TO
      DEACTIVATE WINDOW noTa01
      RELEASE WINDOW noTa01
      IF LASTKEY()=27
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say nota02(mtiponota) color &color_06
           ENDIF
      ENDIF
 ELSE
      IF mtIponota<1 .OR. mtIponota>4
           WAIT WINDOW 'EL TIPO DE DOCUMENTO DEBE SER DEL 1 AL 4 !'
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say nota02(mtiponota) color &color_06
           ENDIF
      ENDIF
 ENDIF
 RETURN
*
FUNCTION noTa02
 PARAMETER mtIponota
 DO CASE
      CASE mtIponota=0
           RETURN '                 '
      CASE mtIponota=1
           RETURN 'NOTA DE DEBITO   '
      CASE mtIponota=2
           RETURN 'NOTA DE CREDITO  '
      CASE mtIponota=3
           RETURN 'C.I. NOTA DEBITO '
      CASE mtIponota=4
           RETURN 'C.I. NOTA CREDITO'
 ENDCASE
 RETURN
*
FUNCTION ptDpago
 PARAMETER imPrime_de, ffIla, fcOlumna
 IF mtIporeci=0
      DEFINE WINDOW paGos01 FROM 07, 28 TO 12, 50 FLOAT CLOSE ZOOM SHADOW  ;
             TITLE 'TIPO RECIBO' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
      ACTIVATE WINDOW paGos01
      SET COLOR TO W+/BG, BG+/B
      @ 00, 00 TO 03, 20 COLOR W+/BG 
      @ 01, 01 PROMPT ' 1. RECIBO DE PAGO '
      @ 02, 01 PROMPT ' 2. C.I. DE PAGO   '
      MENU TO mtIporeci
      SET COLOR TO
      DEACTIVATE WINDOW paGos01
      RELEASE WINDOW paGos01
      IF LASTKEY()=27
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say pagos02(mtiporeci) color &color_06
           ENDIF
      ENDIF
 ELSE
      IF mtIporeci<1 .OR. mtIporeci>2
           WAIT WINDOW 'EL TIPO DE RECIBO DEBE SER 1 o 2 !'
           RETURN 0
      ELSE
           IF imPrime_de
                @ ffila,fcolumna say pagos02(mtiporeci) color &color_06
           ENDIF
      ENDIF
 ENDIF
 RETURN
*
FUNCTION paGos02
 PARAMETER mtIporeci
 DO CASE
      CASE mtIporeci=0
           RETURN '              '
      CASE mtIporeci=1
           RETURN 'RECIBO DE PAGO'
      CASE mtIporeci=2
           RETURN 'C.I. DE PAGO  '
 ENDCASE
 RETURN
*
*!*	PROCEDURE on_error
*!*	 PARAMETER paD
*!*	 IF paD
*!*	      ON ERROR do errhand with error(),message(),message(1),program(),lineno()
*!*	 ELSE
*!*	      ON ERROR
*!*	 ENDIF
*!*	 RETURN
*
FUNCTION fvEnc
 PARAMETER pfEcha, pdIas_plaz
 PRIVATE x, y, p2Fecha, c
 IF pdIas_plaz=30 .OR. pdIas_plaz=60 .OR. pdIas_plaz=90 .OR. pdIas_plaz=120
      p2Fecha = pfEcha
      x = pdIas_plaz/30
      y = 0
      IF DAY(pfEcha)<=28
           DO WHILE .T.
                pfEcha = pfEcha+1
                IF DAY(pfEcha)=DAY(p2Fecha)
                     y = y+1
                     IF y=x
                          EXIT
                     ENDIF
                ENDIF
           ENDDO
      ELSE
           c = MONTH(pfEcha)
           DO WHILE .T.
                pfEcha = pfEcha+1
                IF c<>MONTH(pfEcha)
                     c = MONTH(pfEcha)
                     y = y+1
                     IF y=x
                          c = MONTH(pfEcha)
                          DO CASE
                               CASE c=1 .OR. c=3 .OR. c=5 .OR. c=7 .OR. c= ;
                                    8 .OR. c=10 .OR. c=12
                                    pfEcha = CTOD(STR(DAY(p2Fecha), 2)+ ;
                                     '/'+STR(MONTH(pfEcha), 2)+'/'+ ;
                                     STR(YEAR(pfEcha), 4))
                               CASE c=2
                                    IF YEAR(pfEcha)/4=INT(YEAR(pfEcha)/4)
                                         pfEcha = CTOD('29/'+ ;
                                          STR(MONTH(pfEcha), 2)+'/'+ ;
                                          STR(YEAR(pfEcha), 4))
                                    ELSE
                                         pfEcha = CTOD('28/'+ ;
                                          STR(MONTH(pfEcha), 2)+'/'+ ;
                                          STR(YEAR(pfEcha), 4))
                                    ENDIF
                               OTHERWISE
                                    IF DAY(p2Fecha)=31
                                         pfEcha = CTOD('30/'+ ;
                                          STR(MONTH(pfEcha), 2)+'/'+ ;
                                          STR(YEAR(pfEcha), 4))
                                    ELSE
                                         pfEcha = CTOD(STR(DAY(p2Fecha),  ;
                                          2)+'/'+STR(MONTH(pfEcha), 2)+ ;
                                          '/'+STR(YEAR(pfEcha), 4))
                                    ENDIF
                          ENDCASE
                          EXIT
                     ENDIF
                ENDIF
           ENDDO
      ENDIF
 ELSE
      pfEcha = pfEcha+pdIas_plaz
 ENDIF
 RETURN pfEcha
*
PROCEDURE soNido
 @ 00, 00 SAY ''
 ? CHR(7)
 RETURN
*
*!*	FUNCTION pcLie
*!*	 PARAMETER pp1, pp2, pp3, pp4, pp5
*!*	 = pcLiente(pp1,pp2,pp3,pp4,pp5)
*!*	 if &pp5 =0
*!*	      WAIT WINDOW 'EL CODIGO DEL CLIENTE DEBE SER MAYOR QUE CERO !'
*!*	      RETURN 0
*!*	 ENDIF
*!*	 KEYBOARD '{enter}'
*!*	 WAIT WINDOW ''
*!*	 RETURN
*
*!*	FUNCTION pcLiente
*!*	 PARAMETER imPrime_de, ffIla, fcOlumna, loNg, ppAram1
*!*	 if &pparam1<=0
*!*	      DEFINE WINDOW meNsaje FROM 22, 00 TO 24, 79 FLOAT SHADOW IN scReen  ;
*!*	             COLOR ,,W/N,W/N,W/N 
*!*	      ACTIVATE WINDOW meNsaje
*!*	      @ 00, 00 SAY  ;
*!*	        ' [F4] Cambiar el orden [F5] Buscar [ENTER] Mostrar mas datos [ESC] Salir      '  ;
*!*	        COLOR N/W 
*!*	      @ 00, 01 SAY '[F4]' COLOR W+/B 
*!*	      @ 00, 23 SAY '[F5]' COLOR W+/B 
*!*	      @ 00, 35 SAY '[ENTER]' COLOR W+/B 
*!*	      @ 00, 61 SAY '[ESC]' COLOR W+/B 
*!*	      SELECT clIentes
*!*	      SET ORDER TO 2
*!*	      GOTO TOP
*!*	      ON KEY LABEL 'F4' do pcliente1
*!*	      ON KEY LABEL 'F5' do pcliente1
*!*	      ON KEY LABEL 'ENTER' do pcliente1
*!*	      define window b_cliente from 01,00 to 21,79 title "< CLIENTES >" float zoom grow close SYSTEM color &color_07
*!*	      BROWSE FIELDS b1 = TRANSFORM(coDigo, '9,999,999') :H = 'Codigo', b2 =  ;
*!*	             LEFT(noMbre, 24) :H = 'Nombre', b3 = LEFT(apEllido, 28) :H =  ;
*!*	             'Apellido', b4 = ' '+TRANSFORM(saLdo_actu, '999,999,999') :H =  ;
*!*	             'Saldo Actual', b5 = ruC :H = 'Ruc', b6 = teLefono :H =  ;
*!*	             'Telefono', b7 = doCumento :H = 'Documento Clie', b8 =  ;
*!*	             noMbre_c :H = 'Nombre del Conyuge', b9 = apEllido_c :H =  ;
*!*	             'Apellido del Conyuge', b10 = doCconyuge :H =  ;
*!*	             'Documento Cony', b11 = noMbre_g :H = 'Nombre del Garante',  ;
*!*	             b12 = apEllido_g :H = 'Apellido del Garante', b13 =  ;
*!*	             doCgarante :H = 'Documento Garan' NOEDIT WINDOW b_Cliente
*!*	      ON KEY LABEL 'F4'
*!*	      ON KEY LABEL 'F5'
*!*	      ON KEY LABEL 'ENTER'
*!*	      DEACTIVATE WINDOW meNsaje
*!*	      RELEASE WINDOW meNsaje
*!*	      RELEASE WINDOW b_Cliente
*!*	      SELECT clIentes
*!*	      SET ORDER TO 1
*!*	      &pparam1 = codigo
*!*	      IF imPrime_de
*!*	           @ ffIla, fcOlumna SAY SPACE(40)
*!*	           @ ffila, fcolumna say left(alltrim(nombre)+" "+alltrim(apellido),long) color &color_06
*!*	      ENDIF
*!*	 ELSE
*!*	      SELECT clIentes
*!*	      SET ORDER TO 1
*!*	      seek &pparam1
*!*	      IF FOUND()
*!*	           IF imPrime_de
*!*	                @ ffIla, fcOlumna SAY SPACE(40)
*!*	                @ ffila, fcolumna say left(alltrim(nombre)+" "+alltrim(apellido),long) color &color_06
*!*	           ENDIF
*!*	      ELSE
*!*	           WAIT WINDOW 'CODIGO DE CLIENTE INEXISTENTE !'
*!*	           RETURN 0
*!*	      ENDIF
*!*	 ENDIF
*!*	 select &archivo
*!*	 RETURN
*
*!*	PROCEDURE pcLiente1
*!*	 ON KEY LABEL 'F4'
*!*	 ON KEY LABEL 'F5'
*!*	 ON KEY LABEL 'ENTER'
*!*	 DO CASE
*!*	      CASE LASTKEY()=k_F4
*!*	           DO clIent12
*!*	      CASE LASTKEY()=k_F5
*!*	           DO clIent13
*!*	      CASE LASTKEY()=k_Enter
*!*	           KEYBOARD '{ESCAPE}'
*!*	 ENDCASE
*!*	 ON KEY LABEL 'F4' do pcliente1
*!*	 ON KEY LABEL 'F5' do pcliente1
*!*	 ON KEY LABEL 'ENTER' do pcliente1
*!*	 RETURN
*
FUNCTION peStadociv
 PARAMETER imPrime_de, ffIla, fcOlumna
 IF EMPTY(meStado_ci)
      DEFINE WINDOW esTadocivi FROM 06, 29 TO 16, 51 FLOAT CLOSE ZOOM  ;
             SHADOW TITLE ' ESTADO CIVIL ' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
      ACTIVATE WINDOW esTadocivi
      SET COLOR TO W+/BG, BG+/B
      PRIVATE opCion
      opCion = 0
      @ 00, 00 TO 08, 20 COLOR W+/BG 
      @ 01, 01 PROMPT ' 1. SOLTERO / A    '
      @ 02, 01 PROMPT ' 2. CASADO / A     '
      @ 03, 01 PROMPT ' 3. DIVORCIADO / A '
      @ 04, 01 PROMPT ' 4. VIUDO / A      '
      @ 05, 01 PROMPT ' 5. CONCUBINO / A  '
      @ 06, 01 PROMPT ' 6. SEPARADO / A   '
      @ 07, 01 PROMPT ' 7. - NO DEFINIDO  '
      MENU TO opCion
      SET COLOR TO
      DEACTIVATE WINDOW esTadocivi
      RELEASE WINDOW esTadocivi
      IF LASTKEY()=27
           RETURN 0
      ENDIF
      meStado_ci = IIF(opCion=1, 'S', IIF(opCion=2, 'C', IIF(opCion=3,  ;
                   'D', IIF(opCion=4, 'V', IIF(opCion=5, 'K', IIF(opCion= ;
                   6, 'Z', IIF(opCion=7, '-', ' ')))))))
 ELSE
      IF  .NOT. (meStado_ci='C' .OR. meStado_ci='S' .OR. meStado_ci='D'  ;
          .OR. meStado_ci='K' .OR. meStado_ci='V' .OR. meStado_ci='Z'  ;
          .OR. meStado_ci='-')
           WAIT WINDOW  ;
                'EL CODIGO DE ESTADO CIVIL NO ES VALIDO (S, C, D, V, K, Z, -) !'
           RETURN 0
      ENDIF
 ENDIF
 IF imPrime_de
      @ ffila,fcolumna say testadocivil(mestado_civ) color &color_06
 ENDIF
 RETURN
*
FUNCTION teStadociv
 PARAMETER pfEstado
 DO CASE
      CASE pfEstado='S'
           RETURN 'SOLTERO / A   '
      CASE pfEstado='C'
           RETURN 'CASADO /A     '
      CASE pfEstado='D'
           RETURN 'DIVORCIADO / A'
      CASE pfEstado='V'
           RETURN 'VIUDO / A     '
      CASE pfEstado='K'
           RETURN 'CONCUBINO / A '
      CASE pfEstado='Z'
           RETURN 'SEPARADO / A  '
      CASE pfEstado='-'
           RETURN '-             '
      OTHERWISE
           RETURN '-             '
 ENDCASE
 RETURN
*
FUNCTION piDe_cobra
 PARAMETER imPrime_de, ffIla, fcOlumna, loNg, ppAram1, ppAram2
 if &pparam1 = 0
      DEFINE WINDOW p_Cobrador FROM 06, 24 TO 21, 57 GROW FLOAT CLOSE  ;
             SHADOW TITLE '< COBRADORES >' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
      SELECT coBradores
      SET ORDER TO 2
      GOTO TOP
      ACTIVATE WINDOW p_Cobrador
      PRIVATE mnOmbre
      mnOmbre = noMbre
      DEFINE POPUP p_Cobrador PROMPT FIELDS noMbre MARGIN SCROLL
      @ 00,00 get mnombre popup p_cobrador size 16,32 picture "@&T" color &color_05
      READ
      RELEASE POPUP p_Cobrador
      DEACTIVATE WINDOW p_Cobrador
      RELEASE WINDOW p_Cobrador
      SET ORDER TO 1
      IF LASTKEY()=27
           RETURN 0
      ENDIF
      &pparam1 = CODIGO
      if &pparam2=0
           &pparam2 = comision
      ENDIF
      IF imPrime_de
           @ ffila, fcolumna say left(nombre,long) color &color_06
      ENDIF
 ELSE
      SELECT coBradores
      SET ORDER TO 1
      seek &pparam1
      IF FOUND()
           if &pparam2=0
                &pparam2 = comision
           ENDIF
           IF imPrime_de
                @ ffila, fcolumna say left(nombre,long) color &color_06
           ENDIF
      ELSE
           WAIT WINDOW 'COBRADOR INEXISTENTE !'
           RETURN 0
      ENDIF
 ENDIF
 RETURN
*
FUNCTION pvEndedor
 PARAMETER imPrime_de, ffIla, fcOlumna, loNg, ppAram1, ppAram2,  ;
           imP_comisi, fc, cc
 if &pparam1<=0
      DEFINE WINDOW pvEndedor FROM 04, 21 TO 20, 56 GROW FLOAT CLOSE ZOOM  ;
             SHADOW TITLE '< VENDEDORES >' SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
      SELECT veNdedores
      SET ORDER TO 2
      GOTO TOP
      ACTIVATE WINDOW pvEndedor
      mpNombre = noMbre
      DEFINE POPUP maRca PROMPT FIELDS noMbre MARGIN SCROLL
      @ 00,00 get mpnombre popup marca size 15,34 picture "@&T" color &color_05
      READ
      DEACTIVATE WINDOW pvEndedor
      RELEASE WINDOW pvEndedor
      RELEASE POPUP maRca
      SET ORDER TO 1
      IF LASTKEY()<>27
           &pparam1 = CODIGO
           &pparam2 = COMISION
           IF imPrime_de
                @ ffila, fcolumna say left(nombre,long) color &color_06
           ENDIF
           IF imP_comisi
                @ fc,cc get &pparam2 pict "999.99"
                CLEAR GETS
           ENDIF
      ENDIF
 ELSE
      SELECT veNdedores
      SET ORDER TO 1
      seek &pparam1
      IF FOUND()
           &pparam2 = COMISION
           IF imPrime_de
                @ ffila, fcolumna say left(nombre,long) color &color_06
           ENDIF
           IF imP_comisi
                @ fc,cc get &pparam2 pict "999.99"
                CLEAR GETS
           ENDIF
      ELSE
           WAIT WINDOW 'VENDEDOR INEXISTENTE !'
           RETURN 0
      ENDIF
 ENDIF
 select &archivo
 RETURN
*
FUNCTION piDe_datos
 PARAMETER imPrime_de, ffIla, fcOlumna, loNg, pcOdigo, pnA, paGregar
 PRIVATE mtAmano, msElect, mtItulo, mlD, mlI
 msElect = IIF(pnA='RU', 'RUBROS', IIF(pnA='SU', 'SUBRUBROS', IIF(pnA= ;
           'MA', 'MARCAS', IIF(pnA='ML', 'MOTIVOCL', IIF(pnA='ME',  ;
           'MECANICOS', IIF(pnA='MO', 'MOTIVONOTA', IIF(pnA='MD',  ;
           'MODELOS', IIF(pnA='EO', 'ESTADOOT', IIF(pnA='DE',  ;
           'DEPARTAMENTOS', IIF(pnA='CI', 'CIUDADES', IIF(pnA='BA',  ;
           'BARRIOS', IIF(pnA='UN', 'UNIDADES', IIF(pnA='PR',  ;
           'PROVEEDORES', IIF(pnA='FA', 'FAMILIAS', ''))))))))))))))
 if &pcodigo<=0
      mtItulo = '< '+IIF(pnA='SU', 'SUB-RUBROS', IIF(pnA='UN',  ;
                'UNIDADES DE MEDIDA', IIF(pnA='EO', 'ESTADOS DE LAS OT',  ;
                IIF(pnA='MO', 'MOTIVOS DE LAS NOTAS', IIF(pnA='ML',  ;
                'MOTIVOS DE SER CLIENTE', msElect)))))+' >'
      select &mselect
      SET ORDER TO 2
      GOTO TOP
      mtAmano = LEN(noMbre)
      mlI = 40-INT((mtAmano/2)+2)
      mlD = 40+INT((mtAmano/2)+1)
      DEFINE WINDOW piDe_datos FROM 04, mlI TO 20, mlD GROW FLOAT CLOSE  ;
             ZOOM SHADOW TITLE mtItulo SYSTEM COLOR GR+/BG,GR+/W,N/W,N/W 
      ACTIVATE WINDOW piDe_datos
      mpNombre = noMbre
      DEFINE POPUP piDe_datos PROMPT FIELDS noMbre MARGIN SCROLL
      IF paGregar
           ON KEY LABEL 'F2' do PDATOS2
      ENDIF
      @ 00,00 get mpnombre popup pide_datos size 15,mtamano+2 picture "@&T" color &color_05
      READ
      ON KEY LABEL 'F2'
      DEACTIVATE WINDOW piDe_datos
      RELEASE WINDOW piDe_datos
      RELEASE POPUP piDe_datos
      SET ORDER TO 1
      IF LASTKEY()<>27
           &pcodigo = CODIGO
           IF imPrime_de
                @ ffila, fcolumna say left(nombre,long) color &color_06
           ENDIF
      ENDIF
 ELSE
      select &mselect
      SET ORDER TO 1
      seek &pcodigo
      IF FOUND()
           IF imPrime_de
                @ ffila, fcolumna say left(nombre,long) color &color_06
           ENDIF
      ELSE
           WAIT WINDOW IIF(pnA='RU', 'RUBRO', IIF(pnA='SU', 'SUBRUBRO',  ;
                IIF(pnA='MA', 'MARCA', IIF(pnA='ML',  ;
                'MOTIVO DE SER CLIENTE', IIF(pnA='MO',  ;
                'MOTIVO DE LA NOTA', IIF(pnA='DE', 'DEPARTAMENTO',  ;
                IIF(pnA='CI', 'CIUDAD', IIF(pnA='MD', 'MODELO', IIF(pnA= ;
                'EO', 'ESTADO DE LA OT', IIF(pnA='ME', 'MECANICOS',  ;
                IIF(pnA='BA', 'BARRIO', IIF(pnA='UN', 'UNIDAD DE MEDIDA',  ;
                IIF(pnA='FA', 'FAMILIA', IIF(pnA='PR', 'PROVEEDOR',  ;
                ''))))))))))))))+' INEXISTENTE !'
           RETURN 0
      ENDIF
 ENDIF
 select &archivo
 RETURN
*
PROCEDURE pdAtos2
 ON KEY LABEL 'F2'
 PRIVATE mcOdigon, mnOmbre
 IF arChivo='OT'
      SELECT moDelos
      SET FILTER TO
 ENDIF
 select &mselect
 SET ORDER TO 1
 GOTO BOTTOM
 mcOdigon = coDigo+1
 mnOmbre = SPACE(mtAmano)
 DEFINE WINDOW pdAtos2 FROM 07, mlI-5 TO 12, mlD+5 FLOAT SHADOW TITLE mtItulo
 ACTIVATE WINDOW pdAtos2
 DO WHILE .T.
      DO CASE
           CASE pnA='ML'
                @ 01, 02 SAY 'CODIGO:' GET mcOdigon PICTURE '9999'
                @ 02, 02 SAY 'MOTIVO:' GET mnOmbre
           CASE pnA='ML' .OR. pnA='EO'
                @ 01, 02 SAY 'CODIGO:' GET mcOdigon PICTURE '999'
                @ 02, 02 SAY 'MOTIVO:' GET mnOmbre
           OTHERWISE
                @ 01, 02 SAY 'CODIGO:' GET mcOdigon PICTURE '99999'
                @ 02, 02 SAY 'NOMBRE:' GET mnOmbre
      ENDCASE
      READ
      IF LASTKEY()=27
           EXIT
      ENDIF
      IF mcOdigon<=0
           WAIT WINDOW 'EL CODIGO DEBE SER MAYOR QUE CERO !'
           LOOP
      ENDIF
      IF EMPTY(mnOmbre)
           DO CASE
                CASE pnA='ML'
                     WAIT WINDOW  ;
                          'EL MOTIVO DEL CLIENTE NO PUEDE QUEDAR EN BLANCO'
                CASE pnA='MO'
                     WAIT WINDOW  ;
                          'EL MOTIVO DE LA NOTA NO PUEDE QUEDAR EN BLANCO'
                CASE pnA='EO'
                     WAIT WINDOW  ;
                          'EL ESTADO DE LA NOTA NO PUEDE QUEDAR EN BLANCO'
                OTHERWISE
                     WAIT WINDOW 'EL NOMBRE NO PUEDE QUEDAR EN BLANCO !'
           ENDCASE
           LOOP
      ENDIF
      PRIVATE x
      x = FSIZE('codigo')
      x = IIF(x=1, 9, IIF(x=2, 99, IIF(x=3, 999, IIF(x=4, 9999, IIF(x=5,  ;
          99999, IIF(x=6, 999999, 0))))))
      IF mcOdigon>x
           WAIT WINDOW 'EL CODIGO NO PUEDE SER MAYOR QUE '+ ;
                ALLTRIM(TRANSFORM(x, '999,999'))+' !'
           LOOP
      ENDIF
      SEEK mcOdigon
      IF FOUND()
           WAIT WINDOW 'EL CODIGO INGRESADO YA EXISTE !'
           LOOP
      ENDIF
      IF pnA='MA'
           SELECT maRcas
           GOTO TOP
           LOCATE FOR ALLTRIM(mnOmbre)=ALLTRIM(noMbre)
           IF FOUND()
                WAIT WINDOW 'ESTA MARCA YA FUE CARGADA ANTERIORMENTE !'
                LOOP
           ENDIF
      ENDIF
      APPEND BLANK
      REPLACE coDigo WITH mcOdigon
      REPLACE noMbre WITH mnOmbre
      IF pnA='MD' .AND. arChivo='OT'
           REPLACE maRca WITH mmArca
      ENDIF
      WAIT WINDOW NOWAIT  ;
           'REGISTRO FUE GRABADO, DIGITE LAS INICIALES P/BUSCARLO...'
      EXIT
 ENDDO
 DEACTIVATE WINDOW pdAtos2
 RELEASE WINDOW pdAtos2
 IF arChivo='OT'
      SELECT moDelos
      SET FILTER TO mmArca=maRca
 ENDIF
 SET ORDER TO 2
 ON KEY LABEL 'F2' do PDATOS2
 RETURN
*
*!*	FUNCTION piDe_arti
*!*	 PARAMETER imPrime_de, ffIla, fcOlumna, loNg, pcOdigo
*!*	 if empty(&pcodigo)
*!*	      DO paRti
*!*	      SELECT auXidet
*!*	      IF LASTKEY()=27
*!*	           RETURN 0
*!*	      ENDIF
*!*	      &pcodigo = articulos.codigo
*!*	 ELSE
*!*	      SELECT arTiculos
*!*	      SET ORDER TO 1
*!*	      seek &pcodigo
*!*	      IF  .NOT. FOUND()
*!*	           WAIT WINDOW 'ARTICULO INEXISTENTE !'
*!*	           RETURN 0
*!*	      ENDIF
*!*	 ENDIF
*!*	 IF imPrime_de
*!*	      @ ffila, fcolumna say left(articulos.nombre,long) color &color_06
*!*	 ENDIF
*!*	 RETURN
*
FUNCTION l_51xa
 RETURN arTiculo+'  '+arTiculos.noMbre+'  '+TRANSFORM(caNtidad,  ;
        '999,999.99')+'  '+TRANSFORM(prEcio, '99,999,999.99')+'  '+ ;
        TRANSFORM(caNtidad*prEcio, '999,999,999.99')+'  '+IIF(imPuesto,  ;
        'Si', '')
*
FUNCTION l_51xb
 RETURN SPACE(17)+TRANSFORM(nrOcuota, '999')+'   '+DTOC(feChavcto)+'   '+ ;
        TRANSFORM(imPorte, '999,999,999')+'  '+TRANSFORM(saLdo, '999,999,999')
*
PROCEDURE abReexclu
 PARAMETER paRchivo, paLias
 select &palias
 use &parchivo index &parchivo alias &palias exclusive
 SET ORDER TO 1
 RETURN
*
PROCEDURE abRecomp
 PARAMETER paRchivo, paLias
 select &palias
 use &parchivo index &parchivo alias &palias shared
 SET ORDER TO 1
 RETURN
*
PROCEDURE abRecomp2
 PARAMETER paRchivo, paLias
 SELECT 0
 use &parchivo index &parchivo alias &palias shared
 SET ORDER TO 1
 RETURN
*
FUNCTION caLcdesc2
 IF caBevent.poRcdesc=0 .AND. caBevent.imPortdesc=0
      RETURN 0
 ENDIF
 IF caBevent.poRcdesc>0
      RETURN caBevent.poRcdesc
 ELSE
      PRIVATE msUma
      msUma = 0
      SELECT deTavent
      SET ORDER TO 1
      SEEK STR(caBevent.tiPodocu, 1)+STR(caBevent.nrOdocu, 7)
      DO WHILE caBevent.tiPodocu=tiPodocu .AND. caBevent.nrOdocu=nrOdocu  ;
         .AND.  .NOT. EOF()
           msUma = msUma+ROUND((caNtidad*prEcio), 0)
           SKIP 1
      ENDDO
      RETURN (caBevent.imPortdesc*100)/msUma
 ENDIF
 RETURN
*
