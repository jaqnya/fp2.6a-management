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
PRIVATE m.codigo, m.nombre, m.p1, m.p2, m.p3, m.p4, m.p5, m.vigente, id_local

*-- Variables para c lculos del programa.
PRIVATE plAdding, plEditing, plDeleting, pnChoice, pcAppend, pnSelect, pcOrder, pnRecNo

DO CASE
   CASE cWhatToDo = "Add"
      IF .NOT. UserConfig("brwFamil.prg", "Add", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT familias
      SCATTER MEMVAR MEMO BLANK

      plAdding   = .T.
      plEditing  = .F.
      plDeleting = .F.

      DO familias.spr

      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .F.

      POP KEY
   CASE cWhatToDo = "Edit"
      IF .NOT. UserConfig("brwFamil.prg", "Edit", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT familias

      IF DELETED()
         WAIT WINDOW "ESTA FAMILIA YA HA SIDO BORRADA, NO SE PUEDE EFECTUAR MODIFICACIONES !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO familias.prg WITH "Add"
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
   
      DO familias.spr

      UNLOCK IN familias

      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .F.

      POP KEY
   CASE cWhatToDo = "Delete"
      IF .NOT. UserConfig("brwFamil.prg", "Delete", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT familias

      IF DELETED()
         WAIT WINDOW "­ ESTA FAMILIA YA HA SIDO BORRADA !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO familias.prg WITH "Add"
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

      pnSelect = SELECT()
      pcOrder  = ORDER()
      pnRecNo  = IIF(EOF(), 0, RECNO())

      SELECT maesprod
      SET ORDER TO TAG indice9 OF maesprod.cdx
      
      IF SEEK(familias.codigo)
         ?? CHR(7)
         WAIT WINDOW "ESTA FAMILIA FIGURA EN LA TABLA DE ARTICULOS, IMPOSIBLE BORRARLA !"

         SET ORDER TO TAG indice1 OF maesprod.cdx
         
         SELECT (pnSelect)
         SET ORDER TO TAG (pcOrder)
         IF pnRecNo <> 0
            GOTO RECORD pnRecNo
         ENDIF

         POP KEY
         RETURN         
      ELSE
         SET ORDER TO TAG indice1 OF maesprod.cdx

         SELECT (pnSelect)
         SET ORDER TO TAG (pcOrder)
         IF pnRecNo <> 0
            GOTO RECORD pnRecNo
         ENDIF
      ENDIF
      
      SCATTER MEMVAR MEMO

      plAdding   = .F.
      plEditing  = .F.
      plDeleting = .T.

      DO familias.spr
  
      UNLOCK IN familias

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
                     DO familias.prg WITH "Add"
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