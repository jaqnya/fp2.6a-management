*:*********************************************************************
*:
*: Archivo de Procedimiento: MOTIVOCL.PRG
*:
*:                  Sistema: ABM de Motivos de Ser Cliente
*:                    Autor: Jos‚ Avilio Acu¤a Acosta
*:                 Copyright (c) 2004, Alben S.R.L.             
*:            Last modified: 12/02/2004           
*:
*:            Procs & Fncts:               
*:
*:*********************************************************************
PARAMETER cWhatToDo
PRIVATE plAdding, plEditing, plDeleting, pnChoice, pcAppend, m.codigo, m.nombre, m.vigente

DO CASE
   CASE cWhatToDo = "Add"
      IF .NOT. UserConfig("brwMotCl.prg", "Add", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT motivocl
      SCATTER MEMVAR MEMO BLANK
      
      plAdding   = .T.
      plEditing  = .F.
      plDeleting = .F.

      DO motivocl.spr

      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .F.
      
      POP KEY
   CASE cWhatToDo = "Edit"
      IF .NOT. UserConfig("brwMotCl.prg", "Edit", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT motivocl
      
      IF DELETED()
         WAIT WINDOW "­ ESTE MOTIVO DE SER CLIENTE YA HA SIDO BORRADO !" + CHR(13) + ;
                     "       NO SE PUEDE EFECTUAR MODIFICACIONES"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO motivocl.prg WITH "Add"
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
         
      DO motivocl.spr

      UNLOCK IN motivocl

      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .F.

      POP KEY
   CASE cWhatToDo = "Delete"
      IF .NOT. UserConfig("brwMotCl.prg", "Delete", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT motivocl

      IF DELETED()
         WAIT WINDOW "­ ESTE MOTIVO DE SER CLIENTE YA HA SIDO BORRADO !" 
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO motivocl.prg WITH "Add"
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

      SELECT clientes
      LOCATE FOR clientes.motivoclie = motivocl.codigo
      IF FOUND() 
         ?? CHR(7)             
         WAIT WINDOW "ESTE MOTIVO FIGURA EN LA TABLA DE CLIENTES, IMPOSIBLE BORRARLO !"
         DO RestoreWorkArea       
      ELSE 
         WAIT CLEAR
         DO RestoreWorkArea
         SCATTER MEMVAR MEMO         
         DO motivocl.spr
      ENDIF

      UNLOCK IN motivocl

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
                     DO motivocl.prg WITH "Add"
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
