*:**************************************************************************
*:
*: Archivo de Procedimiento: CLIEPROV.PRG
*:
*:                  Sistema: Profesional de Contabilidad.
*:              Sub-Sistema: ABM de Clientes y/o Proveedores.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 07/05/2004
*:
*:**************************************************************************
PARAMETER cWhatToDo

*-- Variables de la Tabla.
PRIVATE m.codigo, m.nombre, m.direccion, m.telefono, m.ruc

*-- Variables para c lculos del programa.
PRIVATE plAdding, plEditing, plDeleting, pnChoice, pcAppend, pnSelect, pcOrder, pnRecNo



PRIVATE plAdding, plEditing, plDeleting, pcAppend, pcDelete, pnNextScreen, pnSaveWarn, pcTag, pcCurrWin

DO CASE
   CASE cWhatToDo = "Add"
      PUSH KEY CLEAR

      SELECT clieprov
      SCATTER MEMVAR MEMO BLANK
      m.estado_civ = "-"
      m.casa       = "S"
      m.hipoteca   = "N"
      
      plAdding     = .T.
      plEditing    = .F.
      plDeleting   = .F.
      pnNextScreen = 1
      pnSaveWarn   = 0
      
      DO WHILE  pnNextScreen # 0
         DO CASE
            CASE pnNextScreen = 1
               DO cliente1.spr
            CASE pnNextScreen = 2
               DO cliente2.spr
            CASE pnNextScreen = 3
               DO cliente3.spr
            CASE pnNextScreen = 4
               DO cliente4.spr
            CASE pnNextScreen = 5
               DO cliente5.spr
         ENDCASE
      ENDDO

      IF pnSaveWarn = 1     
         APPEND BLANK
         GATHER MEMVAR MEMO
      ENDIF

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      pnNextScreen = 0
      pnSaveWarn   = 0
      
      POP KEY
   CASE cWhatToDo = "Edit"
      PUSH KEY CLEAR

      SELECT clieprov
      
      IF DELETED()
         WAIT WINDOW "­ ESTE CLIENTE YA HA SIDO BORRADO !" + CHR(13) + ;
                     "NO SE PUEDE EFECTUAR MODIFICACIONES"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO clieprov.prg WITH "Add"
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
      
      plAdding     = .F.
      plEditing    = .T.
      plDeleting   = .F.
      pnNextScreen = 1
      pnSaveWarn   = 0
      
      DO WHILE  pnNextScreen # 0
         DO CASE
            CASE pnNextScreen = 1
               DO cliente1.spr
            CASE pnNextScreen = 2
               DO cliente2.spr
            CASE pnNextScreen = 3
               DO cliente3.spr
            CASE pnNextScreen = 4
               DO cliente4.spr
            CASE pnNextScreen = 5
               DO cliente5.spr
         ENDCASE
      ENDDO

      IF pnSaveWarn = 1     
         GATHER MEMVAR MEMO
      ENDIF

      UNLOCK IN clieprov
      
      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      pnNextScreen = 0
      pnSaveWarn   = 0

      POP KEY
   CASE cWhatToDo = "Delete"
      PUSH KEY CLEAR

      SELECT clieprov

      IF DELETED()
         WAIT WINDOW "­ ESTE CLIENTE YA HA SIDO BORRADO !" 
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO clieprov.prg WITH "Add"
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
     
      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .T.

      WAIT WINDOW "POR FAVOR, AGUARDE UN MOMENTO..." NOWAIT

      DO SaveWorkArea

      SELECT cabevent
      SET ORDER TO indice3 OF cabevent.cdx
      IF SEEK(clieprov.codigo)
         ?? CHR(7)             
         WAIT WINDOW "ESTE CLIENTE FIGURA EN LA TABLA DE VENTAS, IMPOSIBLE BORRARLO !"
         DO RestoreWorkArea       
      ELSE 
         SELECT ot
         SET ORDER TO TAG indice3 OF ot.cdx
         IF SEEK(clieprov.codigo)
            ?? CHR(7)
            WAIT WINDOW "ESTE CLIENTE FIGURA EN LA TABLA DE O.T., IMPOSIBLE BORRARLO !"
            DO RestoreWorkArea       
         ELSE 
            SELECT caberemi
            SET ORDER TO indice3 OF caberemi.cdx
            IF SEEK(clieprov.codigo)
               ?? CHR(7)
               WAIT WINDOW "ESTE CLIENTE FIGURA EN LA TABLA REMISIONES, IMPOSIBLE BORRARLO !"
               DO RestoreWorkArea       
            ELSE 
               SELECT cabepres
               SET ORDER TO indice3 OF cabepres.cdx
               IF SEEK(clieprov.codigo)
                  ?? CHR(7)
                  WAIT WINDOW "ESTE CLIENTE FIGURA EN LA TABLA PRESUPUESTOS, IMPOSIBLE BORRARLO !"
                  DO RestoreWorkArea       
               ELSE 
                  SELECT cabecob
                  SET ORDER TO indice3 OF cabecob.cdx
                  IF SEEK(clieprov.codigo) 
                     ?? CHR(7)
                     WAIT WINDOW "ESTE CLIENTE FIGURA EN LA TABLA COBROS, IMPOSIBLE BORRARLO !"
                     DO RestoreWorkArea       
                  ELSE
                     DO RestoreWorkArea
                     DO WHILE .T. 
                        WAIT WINDOW "¨ DESEA BORRARLO ? [S/N]" TO pcDelete
                        IF UPPER(pcDelete) = "S" 
                           DELETE
                           WAIT WINDOW "­ ESTE CLIENTE HA SIDO BORRADO !"
                           EXIT DO
                        ENDIF
                        IF UPPER(pcDelete) = "N" 
                           EXIT DO
                        ENDIF
                     ENDDO      
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF

      UNLOCK IN clieprov

      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .F.
      
      IF .NOT. EOF()
         SKIP 1
         IF EOF()
            SKIP -1
            IF BOF()
               PUSH KEY CLEAR
               DO WHILE .T.
                  WAIT WINDOW "    ESTE ERA EL ULTIMO REGISTRO" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
                  IF UPPER(pcAppend) = "S"
                     DO clieprov.prg WITH "Add"
                     EXIT DO
                  ENDIF
                  IF UPPER(pcAppend) = "N"
                     EXIT DO
                  ENDIF
               ENDDO    
               POP KEY
            ENDIF
         ELSE
            SKIP -1
         ENDIF
      ENDIF

      POP KEY
   CASE cWhatToDo = "Consult"
      PUSH KEY CLEAR
      
      SELECT clieprov

      IF DELETED()
         WAIT WINDOW "­ ESTE CLIENTE YA HA SIDO BORRADO !" + CHR(13) + ;
                     "      NO SE PUEDE  VISUALIZAR"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO clieprov.prg WITH "Add"
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
      
      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .T.
      pnNextScreen = 1
      
      IF SET("CURSOR") = "ON"
         SET CURSOR OFF
         m.CursorStatus = "ON"
      ELSE
         m.CursorStatus = "OFF"
      ENDIF

      DO WHILE  pnNextScreen # 0
         DO CASE
            CASE pnNextScreen = 1
               DO cliente1.spr
            CASE pnNextScreen = 2
               DO cliente2.spr
            CASE pnNextScreen = 3
               DO cliente3.spr
            CASE pnNextScreen = 4
               DO cliente4.spr
            CASE pnNextScreen = 5
               DO cliente5.spr
         ENDCASE
      ENDDO
      
      IF m.CursorStatus = "ON"
         SET CURSOR ON
      ENDIF
      
      UNLOCK IN clieprov

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .F.

      POP KEY
ENDCASE