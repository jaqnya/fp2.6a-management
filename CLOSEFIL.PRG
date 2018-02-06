*-- MS-DOS Cierre de Base de datos e ¡ndices.
IF USED("familias")
   SELECT familias
   USE
ENDIF

IF USED("rubros1")
   SELECT rubros1
   USE
ENDIF

IF USED("rubros2")
   SELECT rubros2
   USE
ENDIF

IF USED("marcas")
   SELECT marcas
   USE
ENDIF

IF USED("unidad")
   SELECT unidad
   USE
ENDIF

IF USED("proceden")
   SELECT proceden
   USE
ENDIF

IF USED("proveedo")
   SELECT proveedo
   USE
ENDIF

IF USED("maesprod")
   SELECT maesprod
   USE
ENDIF

IF USED("detacomp")
   SELECT detacomp
   USE 
ENDIF

IF USED("detavent")
   SELECT detavent
   USE 
ENDIF

IF USED("detanotc")
   SELECT detanotc
   USE
ENDIF

IF USED("detanotp")
   SELECT detanotp
   USE 
ENDIF

IF USED("detaremi")
   SELECT detaremi
   USE
ENDIF

IF USED("detapres")
   SELECT detapres
   USE 
ENDIF

IF USED("detamovi")
   SELECT detamovi
   USE
ENDIF

IF USED("detamot")
   SELECT detamot
   USE
ENDIF
