*:**************************************************************************
*:
*: Archivo de Procedimiento: FAMILIAS.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: ABM de Familias.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/04/2004
*:
*:**************************************************************************
PARAMETER cWhatToDo

*-- Variables de la Tabla.
PRIVATE m.tipobole, m.nrobole, m.fecha, m.local, m.id_local

*-- Variables para c lculos del programa.
PRIVATE plAdding, plEditing, plDeleting, pnChoice, pcAppend, pcDelete, pnSelect, pcOrder, pnRecNo

DO CASE
   CASE cWhatToDo = "Add"
      IF .NOT. UserConfig("brwAjust.prg", "Add", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT cabemovi
      SCATTER MEMVAR MEMO BLANK
      
      plAdding   = .T.
      plEditing  = .F.
      plDeleting = .F.

      DO ajustes.spr

      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .F.
      
      POP KEY
   CASE cWhatToDo = "Edit"
      IF cabemovi.fecha <> DATE() THEN
         WAIT "LOS REGISTROS DE ESTA TABLA NO PUEDEN SER MODIFICADOS !" WINDOW NOWAIT
         RETURN
      ENDIF

      IF .NOT. UserConfig("brwAjust.prg", "Edit", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT cabemovi
      
      IF DELETED()
         WAIT WINDOW "­ ESTA NOTA DE ENVIO / AJUSTE YA HA SIDO BORRADO !" + CHR(13) + ;
                     "        NO SE PUEDE EFECTUAR MODIFICACIONES"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO ajustes.prg WITH "Add"
               EXIT DO
            ENDIF
            IF UPPER(pcAppend) = "N"
               EXIT DO
            ENDIF
         ENDDO    
         POP KEY
         RETURN
      ENDIF

      IF .NOT. RLOCK()
         WAIT WINDOW "­ ESTE REGISTRO ESTA SIENDO UTILIZADO POR OTRO USUARIO !"
         POP KEY
         RETURN         
      ENDIF

      SCATTER MEMVAR MEMO
      
      plAdding   = .F.
      plEditing  = .T.
      plDeleting = .F.
         
      DO _LoadDetail
      DO ajustes.spr

      UNLOCK IN cabemovi

      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .F.

      POP KEY
   CASE cWhatToDo = "Delete"
      IF cabemovi.fecha <> DATE() THEN
         WAIT "LOS REGISTROS DE ESTA TABLA NO PUEDEN SER BORRADOS !" WINDOW NOWAIT
         RETURN
      ENDIF

      IF .NOT. UserConfig("brwAjust.prg", "Delete", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT cabemovi

      IF DELETED()
         WAIT WINDOW "­ ESTA NOTA DE ENVIO / AJUSTE YA HA SIDO BORRADO !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO ajustes.prg WITH "Add"
               EXIT DO
            ENDIF
            IF UPPER(pcAppend) = "N"
               EXIT DO
            ENDIF
         ENDDO    
         POP KEY
         RETURN
      ENDIF
     
      IF .NOT. RLOCK()
         WAIT WINDOW "­ ESTE REGISTRO ESTA SIENDO UTILIZADO POR OTRO USUARIO !"
         POP KEY
         RETURN         
      ENDIF

      DO WHILE .T. 
         WAIT WINDOW "¨ DESEA BORRARLO ? [S/N]" TO pcDelete
         IF UPPER(pcDelete) = "S" 

            SELECT detamovi

            IF SEEK(STR(cabemovi.tipobole, 1) + STR(cabemovi.nrobole, 7))
               WAIT WINDOW "BORRANDO..." NOWAIT

               SCAN WHILE STR(cabemovi.tipobole, 1) + STR(cabemovi.nrobole, 7) = STR(detamovi.tipobole, 1) + STR(detamovi.nrobole, 7)
                  SELECT maesprod
                  SET ORDER TO TAG indice1 OF maesprod.cdx

                  IF SEEK(detamovi.articulo)
                     IF INLIST(detamovi.tipobole, 1, 3)
                        REPLACE maesprod.stock_actu WITH (maesprod.stock_actu - detamovi.cantidad)
                     ELSE
                        IF INLIST(detamovi.tipobole, 2, 4)
                           REPLACE maesprod.stock_actu WITH (maesprod.stock_actu + detamovi.cantidad)
                        ENDIF
                     ENDIF
                  ELSE
                     WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL ARTICULO: " + ALLTRIM(detamovi.articulo) + " !"
                  ENDIF
                  
                  SELECT detamovi
                  DELETE

               ENDSCAN

               WAIT CLEAR
            ELSE
               WAIT WINDOW "­ NO SE HA ENCONTRADO DETALLE A BORRAR !"
            ENDIF

            SELECT cabemovi
            DELETE

            WAIT WINDOW "­ ESTA NOTA DE ENVIO / AJUSTE HA SIDO BORRADO !"
            EXIT DO
         ELSE
            IF UPPER(pcDelete) = "N" 
               EXIT DO
            ENDIF
         ENDIF
      ENDDO      
      
      UNLOCK IN cabemovi

      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .F.
      
      IF .NOT. EOF()
         SKIP 1
         IF EOF()
            SKIP -1
            IF BOF()
               DO WHILE .T.
                  WAIT WINDOW "    ESTE ERA EL ULTIMO REGISTRO" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
                  IF UPPER(pcAppend) = "S"
                     DO ajustes.prg WITH "Add"
                     EXIT DO
                  ENDIF
                  IF UPPER(pcAppend) = "N"
                     EXIT DO
                  ENDIF
               ENDDO    
            ENDIF
         ELSE
            SKIP -1
         ENDIF
      ENDIF

      POP KEY
   CASE cWhatToDo = "Consult"
      PUSH KEY CLEAR
      
      SELECT cabemovi

      IF DELETED()
         WAIT WINDOW "­ ESTA NOTA DE ENVIO / AJUSTE YA HA SIDO BORRADO !" + CHR(13) + ;
                     "              NO SE PUEDE VISUALIZAR"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO ajustes.prg WITH "Add"
               EXIT DO
            ENDIF
            IF UPPER(pcAppend) = "N"
               EXIT DO
            ENDIF
         ENDDO    
         POP KEY
         RETURN
      ENDIF

      IF .NOT. RLOCK()
         WAIT WINDOW "­ ESTE REGISTRO ESTA SIENDO UTILIZADO POR OTRO USUARIO !"
         POP KEY
         RETURN         
      ENDIF

      SCATTER MEMVAR MEMO
      
      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .F.
         
      DO _LoadDetail
      DO ajustes2.spr
      DO _brwDetail

      RELEASE WINDOW
      
      UNLOCK IN cabemovi

      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .F.

      POP KEY
ENDCASE

*!*********************************************************************
*!
*!      Funci¢n: _LoadDetail
*!
*!  Llamado por: AJUSTES.PRG                  
*!
*!  Descripci¢n: Carga el detalle de la  nota de env¡o o  ajuste de in-
*!               ventario.
*!
*!*********************************************************************
FUNCTION _LoadDetail     

PRIVATE pnSelect, pcOrder, pnRecNo

pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT tmpdetmovi
ZAP

SELECT detamovi

IF SEEK(STR(cabemovi.tipobole, 1) + STR(cabemovi.nrobole, 7))
   WAIT WINDOW "POR FAVOR, AGUARDE UN MOMENTO..." NOWAIT

   SCAN WHILE STR(cabemovi.tipobole, 1) + STR(cabemovi.nrobole, 7) = STR(detamovi.tipobole, 1) + STR(detamovi.nrobole, 7)
      INSERT INTO tmpdetmovi (tipobole, nrobole, articulo, cantidad) ;
         VALUES (detamovi.tipobole, detamovi.nrobole, detamovi.articulo, detamovi.cantidad)
   ENDSCAN

   WAIT CLEAR
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _brwDetail 
*!
*!  Llamado por: AJUSTES.PRG                  
*!
*!  Descripci¢n: Abre una ventana de  inspecci¢n para visualizar el de-
*!               talle de la nota de env¡o o ajuste de inventario.
*!               Se  pueden  utilizar  las  combinaciones   de   teclas
*!               CTRL+HOME  para ir al principio de la tabla o CTRL+END
*!               para ir al final.
*!
*!*********************************************************************
FUNCTION _brwDetail

PRIVATE pnSelect, pcOrder, pnRecNo

pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT tmpdetmovi
GO TOP

ON KEY LABEL "CTRL+HOME" GO TOP
ON KEY LABEL "CTRL+END"  GO BOTTOM

BROWSE WINDOW dtlAjustes FIELDS ;
   calc_f1 = RECNO()                        :R:04:H = "N§" :W = .F. :P = "9999" ,;
   articulo                                 :R:15:H = "C¢digo" ,;
   calc_f2 = SUBSTR(maesprod.nombre, 1, 40) :R:44:H = "Descripci¢n" :W = .F. ,;
   cantidad                                 :R:10:H = "Cantidad" :P= "9999999.99" ;
   NODELETE NOAPPEND NOMODIFY

ON KEY LABEL "CTRL+HOME" 
ON KEY LABEL "CTRL+END"  

ZAP

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF