PARAMETERS tcSerie, tnNroOT

* {begin: validaci¢n de par metros }
IF PARAMETERS() < 2 THEN
   WAIT 'No se han pasado suficientes parámetros.' WINDOW NOWAIT
   RETURN .F.
ENDIF

IF TYPE('tcSerie') <> 'C' THEN
   WAIT [El parámetro 'tcSerie' debe ser de tipo caracter.] WINDOW NOWAIT
   RETURN .F.
ENDIF

IF TYPE('tnNroOT') <> 'N' THEN
   WAIT [El parámetro 'tnNroOT' debe ser de tipo numérico.] WINDOW NOWAIT
   RETURN .F.
ENDIF
* {end: validaci¢n de par metros }

PRIVATE pcObservacio, pdFechaAlta, pdFechaModificacion, pcHoraAlta, pcHoraModificacion, pnSeleccion, plModificar
STORE '' TO pcObservacio, pcHoraAlta, pcHoraModificacion
STORE .F. TO plModificar
STORE 1 TO pnSeleccion
STORE  {} TO pdFechaAlta, pdFechaModificacion

IF !WEXIST('wndObserva') THEN
   DEFINE WINDOW wndObserva ;
   FROM INT((SROWS() - 16) / 2), INT((SCOLS() - 71) / 2) ;
   TO INT((SROWS() - 16) / 2) + 17, INT((SCOLS() - 71) / 2) + 70 ;
   TITLE '[ OBSERVACION ]' ;
   NOCLOSE ;
   NOFLOAT ;
   NOGROW ;
   NOMDI ;
   NOMINIMIZE ;
   SHADOW ;
   NOZOOM
ENDIF

IF WVISIBLE('wndObserva') THEN
   ACTIVATE WINDOW wndObserva SAME
ELSE
   ACTIVATE WINDOW wndObserva NOSHOW
ENDIF

IF !USED('mot2obs') THEN
   USE mot2obs IN 0 SHARED
ENDIF

SELECT mot2obs
LOCATE FOR serie = tcSerie AND nroot = tnNroOT
IF FOUND() THEN
   pcObservacio = observacio
   pdFechaAlta = fecha_alta
   pcHoraAlta = hora_alta
   pdFechaModificacion = ult_modif
   pcHoraModificacion = hora_ultmo
ENDIF
@ 11,02 SAY 'Fecha Alta..:' SIZE 1,13 COLOR W/N &&BG+/B
@ 11,16 SAY pdFechaAlta SIZE 1,10 COLOR N/W &&W/BG+
@ 11,27 SAY pcHoraAlta SIZE 1,8 COLOR N/W && W/BG+

@ 12,02 SAY 'Fecha Modif.:' SIZE 1,13 COLOR W/N  &&BG+/B
@ 12,16 SAY pdFechaModificacion SIZE 1,10 COLOR N/W &&W/BG+
@ 12,27 SAY pcHoraModificacion SIZE 1,8 COLOR N/W &&W/BG+

@ 01,02 EDIT pcObservacio PICTURE '@!' SIZE 10,65 WHEN plModificar
@ 14,21 GET pnSeleccion PICTURE '@*HN \!\<Grabar;\?\<Cancelar' SIZE 1,12,3 DEFAULT 1 VALID vldSeleccion()

IF !WVISIBLE('wndObserva') THEN
   ACTIVATE WINDOW wndObserva
ENDIF

READ CYCLE ACTIVATE actread() MODAL COLOR , N/W &&COLOR ,W+/G

RELEASE WINDOWS wndObserva

*--------------------------------------------------------------*
PROCEDURE actread

SHOW GET pnSeleccion, 1 PROMPT '\!\<Modif.'
SHOW GET pnSeleccion, 2 PROMPT '\<Salir'

*--------------------------------------------------------------*
PROCEDURE vldSeleccion

SELECT ot
SET ORDER TO 1
IF SEEK(tcSerie + STR(tnNroOT, 7)) THEN
   IF INLIST(estadoot, 3, 4, 5, 6) THEN
      WAIT 'NO SE PUEDE MODIFICAR !' WINDOW
      RETURN 0
   ENDIF
ELSE
   WAIT 'NO EXISTE LA OT !' WINDOW
   RETURN 0
ENDIF      
      
IF plModificar THEN
   IF pnSeleccion = 1 THEN
      SELECT mot2obs
      LOCATE FOR serie = tcSerie AND nroot = tnNroOT
      IF FOUND() THEN
         IF ALLTRIM(pcObservacio) <> ALLTRIM(observacio) THEN
            pdFechaModificacion = DATE()
            pcHoraModificacion = TIME()
         ENDIF

         DELETE
      ELSE
         pdFechaAlta = DATE()
         pcHoraAlta = TIME()
      ENDIF

      INSERT INTO mot2obs (serie, nroot, observacio, fecha_alta, hora_alta, ult_modif, hora_ultmo) ;
         VALUES (tcSerie, tnNroOT, UPPER(pcObservacio), pdFechaAlta, pcHoraAlta, pdFechaModificacion, pcHoraModificacion)
      
      FLUSH
      CLEAR READ
   ELSE
      CLEAR READ
   ENDIF
ELSE
   IF pnSeleccion = 1 THEN
      plModificar = .T.

      @ 00,02 SAY 'CTRL+ENTER para Grabar ³ ESC para Salir' SIZE 1,50 COLOR W+/N &&BG+/B

      SHOW GET pnSeleccion, 1 PROMPT '\!\<Grabar'
      SHOW GET pnSeleccion, 2 PROMPT '\<Cancelar'
      _CUROBJ = OBJNUM(pcObservacio)
   ELSE
      CLEAR READ
   ENDIF
ENDIF