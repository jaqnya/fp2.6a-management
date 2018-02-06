*:*********************************************************************
*:
*: Archivo de Procedimiento: MOTIVONO.PRG
*:
*:                  Sistema: ABM de Motivos de las Notas.
*:                    Autor: Jos‚ Avilio Acu¤a Acosta
*:                 Copyright (c) 2004, Alben S.R.L.             
*:            Last modified: 12/02/2004           
*:
*:            Procs & Fncts:
*:
*:*********************************************************************
PARAMETER cWhatToDo

*-- Variables de la Tabla.
PRIVATE m.codigo, m.nombre, m.vigente

*-- Variables para c lculos del programa.
PRIVATE plAdding, plEditing, plDeleting, pnChoice, pcAppend

DO CASE
   CASE cWhatToDo = "Add"
      IF .NOT. UserConfig("brwMotNo.prg", "Add", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT motivono
      SCATTER MEMVAR MEMO BLANK

      plAdding   = .T.
      plEditing  = .F.
      plDeleting = .F.

      DO motivono.spr

      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .F.

      POP KEY
   CASE cWhatToDo = "Edit"
      IF .NOT. UserConfig("brwMotNo.prg", "Edit", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT motivono

      IF DELETED()
         WAIT WINDOW "ESTE MOTIVO DE LA NOTA YA HA SIDO BORRADO, NO SE PUEDE EFECTUAR MODIFICACIONES !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO motivono.prg WITH "Add"
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
   
      DO motivono.spr

      UNLOCK IN motivono

      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .F.

      POP KEY
   CASE cWhatToDo = "Delete"
      IF .NOT. UserConfig("brwMotNo.prg", "Delete", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT motivono

      IF DELETED()
         WAIT WINDOW "­ ESTE MOTIVO DE LA NOTA YA HA SIDO BORRADO !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO motivono.prg WITH "Add"
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

      WAIT WINDOW "POR FAVOR, AGUARDE UN MOMENTO..." NOWAIT

      PRIVATE pcSelect, pcOrder, pnRecNo, m.codigo
      pcSelect = SELECT()
      pcOrder  = ORDER()
      pnRecNo  = IIF(EOF(), 0, RECNO())
      m.codigo = motivono.codigo

      SELECT cabenotc
      GO TOP
      LOCATE FOR cabenotc.motivonota = m.codigo
      IF FOUND() 
         ?? CHR(7)             
         WAIT WINDOW "­ ESTE REGISTRO FIGURA EN OTRA TABLA, IMPOSIBLE BORRARLO !"

         SELECT (pcSelect)
         SET ORDER TO TAG (pcOrder) 
         IF pnRecNo <> 0 
            GOTO RECORD pnRecNo
         ENDIF
      ELSE 
         SELECT cabenotp
         GO TOP 
         LOCATE FOR cabenotp.motivonota = m.codigo
         IF FOUND() 
            ?? CHR(7)             
            WAIT WINDOW "­ ESTE REGISTRO FIGURA EN OTRA TABLA, IMPOSIBLE BORRARLO !"
         
            SELECT (pcSelect)
            SET ORDER TO TAG (pcOrder) 
            IF pnRecNo <> 0 
               GOTO RECORD pnRecNo
            ENDIF
         ELSE
            SELECT (pcSelect)
            SET ORDER TO TAG (pcOrder) 
            IF pnRecNo <> 0 
               GOTO RECORD pnRecNo
            ENDIF

            WAIT CLEAR
      
            plAdding   = .F.
            plEditing  = .F.
            plDeleting = .T.

            SCATTER MEMVAR MEMO
            DO motivono.spr            

         ENDIF
      ENDIF
      
      UNLOCK IN motivono

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
                     DO motivono.prg WITH "Add"
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
ENDCASE
