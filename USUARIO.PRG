PUSH KEY CLEAR

ON KEY LABEL "A"   DO _ChangeStatus WITH "acceso"
ON KEY LABEL "F2"  DO _ChangeStatus WITH "f2"
ON KEY LABEL "F3"  DO _ChangeStatus WITH "f3"
ON KEY LABEL "F8"  DO _ChangeStatus WITH "f8"
ON KEY LABEL "F12" DO _ChangeStatus WITH "f12"

IF .NOT. WEXIST("ConfigUser")
   DEFINE WINDOW ConfigUser ;
      FROM 01,00 ;
      TO   24,79 ;
      TITLE "OPCIONES DE:" ;
      FLOAT ;
      ZOOM ;
      GROW ;
      CLOSE ;
      SYSTEM ;
      COLOR SCHEME 10
ENDIF

USE opciones SHARED
BROWSE WINDOW ConfigUser FIELDS;
opcion :R:66:H = "Opci¢n" ,;
calc_f1 = IIF(acceso = "X", CHR(219), CHR(32)) :R:01:H = "A" ,;
calc_f2 = IIF(f2     = "X", CHR(219), CHR(32)) :R:01:H = "A" ,;
calc_f3 = IIF(f3     = "X", CHR(219), CHR(32)) :R:01:H = "M" ,;
calc_f4 = IIF(f8     = "X", CHR(219), CHR(32)) :R:01:H = "B" ,;
calc_f5 = IIF(f12    = "X", CHR(219), CHR(32)) :R:01:H = "I"


ON KEY LABEL "A" 
ON KEY LABEL "F2" 
ON KEY LABEL "F3" 
ON KEY LABEL "F8" 
ON KEY LABEL "F12" 
POP KEY

FUNCTION _ChangeStatus
PARAMETER pcField

IF &pcField = "X"
   REPLACE &pcField WITH " "
ELSE
   REPLACE &pcField WITH "X"
ENDIF