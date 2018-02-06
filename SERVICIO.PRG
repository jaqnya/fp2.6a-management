*:**************************************************************************
*:
*: Archivo de Procedimiento: SERVICIO.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: ABM de Servicios.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/04/2004
*:
*:**************************************************************************
PARAMETER cWhatToDo

*-- Variables de la Tabla.
PRIVATE m.articulo, m.pcomision, id_local

*-- Variables para c lculos del programa.
PRIVATE plAdding, plEditing, plDeleting, pnChoice, pcAppend, pnSelect, pcOrder, pnRecNo

DO CASE
   CASE cWhatToDo = "Add"
      IF .NOT. UserConfig("brwServi.prg", "Add", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT servicio
      SCATTER MEMVAR MEMO BLANK

      plAdding   = .T.
      plEditing  = .F.
      plDeleting = .F.

      DO servicio.spr

      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .F.

      POP KEY
   CASE cWhatToDo = "Edit"
      IF .NOT. UserConfig("brwServi.prg", "Edit", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT servicio

      IF DELETED()
         WAIT WINDOW "ESTA MANO DE OBRA YA HA SIDO BORRADA, NO SE PUEDE EFECTUAR MODIFICACIONES !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO servicio.prg WITH "Add"
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
   
      DO servicio.spr

      UNLOCK IN servicio

      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .F.

      POP KEY
   CASE cWhatToDo = "Delete"
      IF .NOT. UserConfig("brwServi.prg", "Delete", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT servicio

      IF DELETED()
         WAIT WINDOW "­ ESTA MANO DE OBRA YA HA SIDO BORRADA !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO servicio.prg WITH "Add"
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

      WAIT WINDOW "POR FAVOR, AGUARDE UN MOMENTO..." NOWAIT

      pnSelect = SELECT()
      pcOrder  = ORDER()
      pnRecNo  = IIF(EOF(), 0, RECNO())

      SELECT mecancfg
      LOCATE FOR servicio.articulo = m.articulo
      IF FOUND() 
         ?? CHR(7)             
         WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE MECANICOS, IMPOSIBLE BORRARLO !"
         plFound = .T.
      ELSE 
         plFound = .F.
      ENDIF

      SELECT (pnSelect)
      SET ORDER TO TAG (pcOrder) 
      IF pnRecNo <> 0 
         GOTO RECORD pnRecNo
      ENDIF

      WAIT CLEAR
      
      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .T.

      IF .NOT. plFound
         DO servicio.spr            
      ENDIF
      
      UNLOCK IN servicio

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
                     DO servicio.prg WITH "Add"
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
ENDCASE