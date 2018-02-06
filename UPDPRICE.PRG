*
* PRICES.PRG - Actualizador de precios.
*

* Definici¢n de variables.
PRIVATE cWindow01, gcCompany, cSetTalk, cSetNotify, cSetClock, cSetSafety

STORE LOWER(SYS(2015)) TO cWindow01
STORE "ALBEN S.R.L."   TO gcCompany
STORE ""               TO cSetTalk, cSetNotify, cSetClock, cSetSafety

* C¢digo de configuraci¢n.
=Setup()

wait window ""

* C¢digo de limpieza.
=Cleanup()


* +-------------------------------------------------------------+
* |  MS-DOS© Procedimientos y funciones del soporte.            |
* +-------------------------------------------------------------+

*
* SETUP - C¢digo de configuraci¢n.                             
*
PROCEDURE Setup

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

IF WVISIBLE(cWindow01)
   ACTIVATE WINDOW (cWindow01) SAME
ELSE
   ACTIVATE WINDOW (cWindow01) NOSHOW
ENDIF

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

IF .NOT. WVISIBLE(cWindow01)
   ACTIVATE WINDOW (cWindow01)
ENDIF

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

*
* CENTER - Impresi¢n centrada de cadenas de texto.        
*
PROCEDURE Center
PARAMETERS nRow, cText, cColor
nColumn = 40 - (LEN(cText) / 2)
@ nRow, nColumn SAY cText COLOR (cColor)