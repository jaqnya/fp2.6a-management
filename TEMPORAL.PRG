
=FOX_ALERT("La tabla est  vac¡a, agregar un registro?")


**-----------------------------------------------------------****
* FOX_ALERT - Displiega una ventana con mensaje de advertencia. *
****-----------------------------------------------------------**
PROCEDURE fox_alert
PARAMETER cMessage

* Declaraci¢n de variables.
PRIVATE nalrtbtn
nalrtbtn = 2

* Definici¢n de ventana(s).
IF .NOT. WEXIST("dlgAlert")
   DEFINE WINDOW dlgAlert ;
      FROM INT((SROW()-12)/2),INT((SCOL()-52)/2) ;
      TO INT((SROW()-12)/2)+6,INT((SCOL()-52)/2)+51 ;
      TITLE WTITLE() ;
      DOUBLE ;
      NOCLOSE ;
      FLOAT ;
      NOGROW ;
      NOMINIMIZE ;
      NOSHADOW ;
      ZOOM ;
      COLOR &color3   
ENDIF

* Programa principal.
MOVE WINDOW dlgAlert CENTER
	
ACTIVATE WINDOW dlgAlert NOSHOW

@ 01,(50-LEN(cMessage))/2 SAY cMessage
@ 04,17 GET nalrtbtn ; 
   PICTURE "@*HT \<S¡;\?\!\<No" ;
   SIZE 1,06,4

ACTIVATE WINDOW dlgAlert
READ CYCLE MODAL
RELEASE WINDOW dlgAlert

RETURN nalrtbtn=1