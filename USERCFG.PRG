PARAMETERS cProgram, cTask, lMessage

* Declaraci¢n de variables.
PRIVATE nSelect, cOrder, nRecNo, lReturn

STORE SELECT()               TO nSelect
STORE ORDER()                TO cOrder
STORE IIF(EOF(), 0, RECNO()) TO nRecNo
STORE .F.                    TO lReturn
         
* Declaraci¢n de constantes.
#DEFINE C_NOFEAT		"No est  disponible." 
* C¢digo de configuraci¢n.
=Setup()

* Programa principal.
IF SEEK(STR(gnUser, 4) + cProgram)
   DO CASE
      CASE cTask = "Access"
         IF usercfg.access
            lReturn = .T.
         ENDIF
      CASE cTask = "Add"
         IF usercfg.add    
            lReturn = .T.
         ENDIF
      CASE cTask = "Edit"
         IF usercfg.edit   
            lReturn = .T.
         ENDIF
      CASE cTask = "Delete"
         IF usercfg.delete 
            lReturn = .T.
         ENDIF
      CASE cTask = "Print"
         IF usercfg.print  
            lReturn = .T.
         ENDIF
   ENDCASE
ENDIF
   
IF .NOT. EMPTY(ALIAS(nSelect))
   SELECT (nSelect)
   SET ORDER TO TAG (cOrder)
   IF nRecNo <> 0
      GOTO RECORD nRecNo
   ENDIF
ENDIF

IF .NOT. lReturn  .AND. lMessage
   WAIT WINDOW C_NOFEAT NOWAIT
ENDIF

RETURN (lReturn)

* +-------------------------------------------------------------+
* |  MS-DOS© Procedimientos y funciones del soporte.            |
* +-------------------------------------------------------------+

**-----------------------------------------------------------****
* SETUP - C¢digo de configuraci¢n.                              *
****-----------------------------------------------------------**
PROCEDURE Setup

* Ordena tabla(s).
IF USED("usercfg")
   SELECT usercfg
   SET ORDER TO TAG indice1 OF usercfg.cdx
ELSE
   SELECT 0
   USE (LOCFILE("usercfg.dbf", "DBF", "¨ D¢nde est  USERCFG.DBF ?")) ;
      AGAIN ALIAS usercfg SHARED ;
      ORDER TAG indice1 OF usercfg.cdx
ENDIF