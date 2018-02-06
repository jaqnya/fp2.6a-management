*--   Derechos Reservados por Turtle Software Paraguay
*-- Diciembre 2003, escrito por Jos‚ Avilio Acu¤a Acosta.

*!*********************************************************************
*!  C¢digo de Configuraci¢n
*!*********************************************************************
CLEAR ALL
CLEAR

IF SET("TALK") = "ON"
	SET TALK OFF
	m.talkstat = "ON"
ELSE
	m.talkstat = "OFF"
ENDIF

DIMENSION gaWorkAreaStack[1, 3]
gnWkAreaLevel   = 1
gaWorkAreaStack = ""

PUBLIC gaScreenStack, glLegal
gnScreenLevel = 0
glLegal = .F.
*-- Listado de teclas de funci¢n b sicas.
K_F1  =  28
K_F2  =  -1
K_F3  =  -2
K_F4  =  -3
K_F5  =  -4
K_F6  =  -5
K_F7  =  -6
K_F8  =  -7
K_F9  =  -8
K_F10 =  -9
K_F11 = 133
K_F12 = 134

K_INS    =  22
K_HOME   =   1
K_DEL    =   7
K_END    =   6
K_PGUP   =  18
K_PGDN   =   3
K_UP     =   5
K_RIGHT  =   4
K_LEFT   =  19
K_DOWN   =  24
K_ESCAPE =  27
K_ENTER  =  13
K_BSPACE = 127
K_TAB    =   9

K_SPACEB =  32

*-- Establece el entorno de trabajo.
SET PROCEDURE TO flibrary.prg

*ON ERROR DO _ErrorHandling WITH ;                                  
*   ERROR(), MESSAGE(), MESSAGE(1), PROGRAM(), LINENO()             

DO _Security
*SET DEFAULT TO SYS(5) + "\turtle\aya\fuentes\sysges"
*USE control
*STORE control.empresa TO gcLocal, pcLocal

DO _SetIn
DO _CustomMono
DO _BackGround WITH 1
DO _Center WITH 00, CHR(15) + " Turtle Software Paraguay " + CHR(15), "N/W"
DO _Center WITH 24, "Copyright(C) Derechos Reservados - V. 1.00  " + ALLTRIM(control.empresa), "N/W"
CLEAR MACROS
DO COLORS.PRG	

*-- Solicita contrase¤a para ingresar al sistema.
PRIVATE plAcceso, gnUser, gcCompany
plAcceso = .F.
gnUser   = 0
msgNotAvailable = "No est  disponible."
msgNotServer    = "Esta opci¢n solo funciona en el servidor."
gcCompany = gcLocal
mdemo = .F.


SET COLOR OF SCHEME 1 TO W/N,W/W,W/N,N/W,W/N,W+/B,W/N,N+/N,W/N,W/N,-      
IF mdemo THEN
   DO permiso3.spr
ELSE
   DO permiso.spr
ENDIF

SET COLOR OF SCHEME 1 TO W/N,N/W,W/N,N/W,W/N,W+/B,W/N,N+/N,W/N,W/N,-      

IF plAcceso 
   DO _BackGround WITH 1
   DO _Center WITH 00, gcLocal, "N/W"
   
   *-- Imprime la fecha del sistema.
   DO CASE
      CASE DOW(DATE()) = 1
         pcDate = "Domingo"
      CASE DOW(DATE()) = 2
         pcDate = "Lunes"
      CASE DOW(DATE()) = 3
         pcDate = "Martes"
      CASE DOW(DATE()) = 4
         pcDate = "Mi‚rcoles"
      CASE DOW(DATE()) = 5
         pcDate = "Jueves"
      CASE DOW(DATE()) = 6
         pcDate = "Viernes"
      CASE DOW(DATE()) = 7
         pcDate = "S bado"
   ENDCASE

   @ 00,00 SAY pcDate + ", " + DTOC(DATE()) ;
      SIZE 1,21 ;
      COLOR N/W
   
   DO menu01.prg
ENDIF

app = .T.

IF app THEN
   CLEAR
   QUIT
ENDIF

*!*********************************************************************
*!  C¢digo de Limpieza
*!*********************************************************************
DO _SetOut
*ON ERROR        && restaura el controlador de errores del sistema.
SET PROCEDURE TO

IF m.talkstat = "ON"
	SET TALK ON
ENDIF
