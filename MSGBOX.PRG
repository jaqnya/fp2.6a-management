*
* MSGBOX(<ExpC1>, <ExpC2>, <ExpN>, <ExpC3>, <ExpC4>)
*
* Returns:        Numeric
*                 One of the following:
*                 idok            1
*                 idcancel        2	
*                 idabort    3
*                 idretry    4
*                 idignore        5
*                 idyes           6
*                 idno            7
*
* Description:    Displays a modal dialog box centered in the desktop.
*                 <ExpC1> - Contents in dialog box.
*                 <ExpC2> - Title of dialog box window.
*                 <ExpN>  - Type of dialog box.
*                 <ExpC3> - Color of dialog box window.
*                 <ExpC4> - Contents' align.
*
* Lengths:        MB_OK          11
*                 MB_YESNO       16
*
PARAMETERS cMessage, cTitle, nMsgBoxType, cColor, cAlign

PUSH KEY CLEAR

* Declaraci¢n de constantes.
#DEFINE MB_OK                   0
#DEFINE MB_OKCANCEL             1
#DEFINE MB_ABORTRETRYIGNORE     2       
#DEFINE MB_YESNOCANCEL          3
#DEFINE MB_YESNO                4
#DEFINE MB_RETRYCANCEL          5
#DEFINE MB_MARGIN               6
#DEFINE MB_MINHEIGHT            6
#DEFINE MB_ALERT                "W+/R,W+/W,W+/R,W+/W,W/R,W+/G,GR+/W,N+/N,N/W,W/R,+"
#DEFINE MB_MESSAGE              "N/W,W+/BG,W+/W,W+/W,R+/B,W+/G,GR+/G,N+/N,N/G,R+/B,+"

* Declaraci¢n de variables.
PRIVATE nIdButton, MsgBoxColor, nOccurs, aString, nCounter, nLength, ;
        nMinLength, nHeight, nWidth

STORE 0 TO nIdButton, nOccurs, nCounter, nLength, nMinLength, nHeigth, ;
           nWidth
STORE "" TO MsgBoxColor, aString

MsgBoxColor = IIF(UPPER(cColor) = "ALERT", MB_ALERT, IIF(UPPER(cColor) = "MESSAGE", MB_MESSAGE, ""))

*-- Minimum Length of the dialog box.
DO CASE
   CASE nMsgBoxType = MB_OK
      nMinLength = 11 + MB_MARGIN
   CASE nMsgBoxType = MB_YESNO
      nMinLength = 20 + MB_MARGIN
   CASE nMsgBoxType = MB_YESNOCANCEL 
      nMinLength = 33 + MB_MARGIN
ENDCASE

*-- Determina la cantidad de l¡neas de mensajes.
nOccurs = OCCURS("›", cMessage)

IF nOccurs > 0
   DIMENSION aString[nOccurs + 1]

   FOR nCounter = 1 TO nOccurs + 1
      IF nCounter = 1
         aString[1] = ALLTRIM(SUBSTR(cMessage, 1, ATC("›", cMessage) - 1))
      ENDIF
   
      IF nCounter > 1 .AND. nCounter <> ALEN(aString, 1)
         aString[nCounter] = ALLTRIM(SUBSTR(cMessage, ATC("›", cMessage, nCounter - 1) + 1, (ATC("›", cMessage, nCounter) - 1) - ATC("›", cMessage, nCounter - 1) - 1))
      ENDIF
      
      IF nCounter = ALEN(aString, 1)
         aString[nCounter] = ALLTRIM(SUBSTR(cMessage, ATC("›", cMessage, nCounter - 1) + 1))
      ENDIF
   ENDFOR

   FOR nCounter = 1 TO nOccurs + 1
      IF LEN(aString[nCounter]) > nLength
         nLength = LEN(aString[nCounter])
      ENDIF
   ENDFOR

   *-- Length of the dialog box.
   IF nLength > nMinLength
      nWidth = nLength + MB_MARGIN
   ELSE
      nWidth = nMinLength
   ENDIF

   *-- Height of the dialog box.
   nHeight = ALEN(aString, 1) + MB_MINHEIGHT
ELSE
   nLength = LEN(ALLTRIM(cMessage)) + MB_MARGIN

   IF nLength > nMinLength
      nWidth = nLength
   ELSE
      nWidth = nMinLength
   ENDIF

   nHeight = MB_MINHEIGHT + 1
ENDIF

* Definici¢n de ventana(s).
IF .NOT. WEXIST("MsgBox")
   DEFINE WINDOW MsgBox ;
      FROM INT((SROW() - nHeight) / 2), INT((SCOL() - nWidth) / 2) ;
      TO INT((SROW() - nHeight) / 2) + nHeight - 1, INT((SCOL() - nWidth) / 2) + nWidth - 1 ;
      TITLE cTitle ;
      DOUBLE ;
      NOCLOSE ;
      FLOAT ;
      NOGROW ;
      NOMINIMIZE ;
      SHADOW ;
      ZOOM ;
      COLOR &MsgBoxColor
ENDIF

* Programa principal.
MOVE WINDOW MsgBox CENTER
	
ACTIVATE WINDOW MsgBox NOSHOW

   DO CASE
      CASE nMsgBoxType = MB_OK
         @ WROWS() - 2,(WCOLS() - 11) / 2 GET nIdButton ; 
            PICTURE "@*HT \?\!\<Aceptar" ;
            SIZE 1,11,1
         IF UPPER(cColor) = "ALERT"
            @ WROWS() - 2,((WCOLS() - 11) / 2) + 11 SAY "Ü" ;
               SIZE 1,1, 0 ;
               COLOR N/R               
            @ WROWS() - 1,((WCOLS() - 11) / 2) + 1 SAY "ßßßßßßßßßßß" ;
               SIZE 1,11, 0 ;
               COLOR N/R
         ELSE
            @ WROWS() - 2,((WCOLS() - 11) / 2) + 11 SAY "Ü" ;
               SIZE 1,1, 0
            @ WROWS() - 1,((WCOLS() - 11) / 2) + 1 SAY "ßßßßßßßßßßß" ;
               SIZE 1,11, 0
         ENDIF
      CASE nMsgBoxType = MB_YESNO
         @ WROWS() - 2,(WCOLS() - 20) / 2 GET nIdButton ; 
            PICTURE "@*HT \<S¡;\?\!\<No" ;
            SIZE 1,06,8

         IF UPPER(cColor) = "ALERT"
            @ WROWS() - 2,((WCOLS() - 20) / 2) + 6  SAY "Ü" ;
               SIZE 1,1, 0 ;
               COLOR N/R
               
            @ WROWS() - 1,((WCOLS() - 20) / 2) + 1 SAY "ßßßßßß" ;
               SIZE 1,11, 0 ;
               COLOR N/R
               
            @ WROWS() - 2,((WCOLS() - 20) / 2) + 20 SAY "Ü" ;
               SIZE 1,1, 0 ;
               COLOR N/R
               
            @ WROWS() - 1,((WCOLS() - 20) / 2) + 15 SAY "ßßßßßß" ;
               SIZE 1,11, 0 ;
               COLOR N/R
               
         ELSE
            @ WROWS() - 2,((WCOLS() - 20) / 2) + 6  SAY "Ü" ;
               SIZE 1,1, 0
            @ WROWS() - 1,((WCOLS() - 20) / 2) + 1 SAY "ßßßßßß" ;
               SIZE 1,11, 0

            @ WROWS() - 2,((WCOLS() - 20) / 2) + 20 SAY "Ü" ;
               SIZE 1,1, 0
            @ WROWS() - 1,((WCOLS() - 20) / 2) + 15 SAY "ßßßßßß" ;
               SIZE 1,11, 0
         ENDIF
      CASE nMsgBoxType = MB_YESNOCANCEL 
         @ WROWS() - 2,(WCOLS() - 32) / 2 GET nIdButton ; 
            PICTURE "@*HT \<S¡;\<No;\?\!\<Cancelar" ;
            SIZE 1,06,5

         IF UPPER(cColor) = "ALERT"
            @ WROWS() - 2,((WCOLS() - 20) / 2) + 6  SAY "Ü" ;
               SIZE 1,1, 0 ;
               COLOR N/R
               
            @ WROWS() - 1,((WCOLS() - 20) / 2) + 1 SAY "ßßßßßß" ;
               SIZE 1,11, 0 ;
               COLOR N/R
               
            @ WROWS() - 2,((WCOLS() - 20) / 2) + 20 SAY "Ü" ;
               SIZE 1,1, 0 ;
               COLOR N/R
               
            @ WROWS() - 1,((WCOLS() - 20) / 2) + 15 SAY "ßßßßßß" ;
               SIZE 1,11, 0 ;
               COLOR N/R
               
         ELSE
            @ WROWS() - 2,((WCOLS() - 32) / 2) + 6  SAY "Ü" ;
               SIZE 1,1, 0
            @ WROWS() - 1,((WCOLS() - 32) / 2) + 1 SAY "ßßßßßß" ;
               SIZE 1,11, 0

            @ WROWS() - 2,((WCOLS() - 32) / 2) + 17 SAY "Ü" ;
               SIZE 1,1, 0
            @ WROWS() - 1,((WCOLS() - 32) / 2) + 12 SAY "ßßßßßß" ;
               SIZE 1,11, 0

            @ WROWS() - 2,((WCOLS() - 32) / 2) + 32 SAY "Ü" ;
               SIZE 1,1, 0
            @ WROWS() - 1,((WCOLS() - 32) / 2) + 23 SAY "ßßßßßßßßßß" ;
               SIZE 1,11, 0
         ENDIF
   ENDCASE

IF nOccurs = 0
   @ 01,(WCOLS()-LEN(cMessage))/2 SAY cMessage
ELSE
   FOR nCounter = 1 To nOccurs + 1
      DO CASE
         CASE UPPER(cAlign) = "L"
            @ nCounter, 02 SAY aString[nCounter]         
         CASE UPPER(cAlign) = "C"
            @ nCounter, (WCOLS()-LEN(aString[nCounter]))/2 SAY aString[nCounter]
      ENDCASE
   ENDFOR
ENDIF

ACTIVATE WINDOW MsgBox
READ CYCLE MODAL
RELEASE WINDOW MsgBox

DO CASE
   CASE nMsgBoxType = MB_OK
      nIdButton = 1
   CASE nMsgBoxType = MB_YESNO
      IF nIdButton = 1
         nIdButton = 6
      ELSE
         nIdButton = 7
      ENDIF
   CASE nMsgBoxType = MB_YESNOCANCEL 
      IF nIdButton = 1
         nIdButton = 6
      ELSE
         IF nIdButton = 2
            nIdButton = 7
         ELSE
            IF nIdButton = 3
               nIdButton = 2
            ENDIF
         ENDIF
      ENDIF
ENDCASE

POP KEY

RETURN nIdButton