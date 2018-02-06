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
PRIVATE m.codigo, m.nombre, m.direc1, m.direc2, m.direc3, m.direc4, m.direc5, m.direc6, m.direc7, m.direc8, m.direc9, m.departamen, m.ciudad, m.barrio, m.telefono, m.fax, m.e_mail, m.fechanac, m.contacto, m.ruc, m.dias_plazo, m.documento, m.limite_cre, m.calificac, m.fec_ioper, m.motivoclie, m.odatosclie, m.trabajo, m.teltrabajo, m.directraba, m.cargo, m.sueldo, m.antiguedad, m.oingresos, m.gastos, m.nombre_c, m.docconyuge, m.fechanacco, m.trabajocon, m.dirtracony, m.cargoconyu, m.teltracony, m.sueldoc, m.oingresosc, m.gastosc, m.antiguec, m.nombre_g, m.dir1garan, m.dir2garan, m.telgarante, m.tragarante, m.dirtragar, m.tetragaran, m.cargogaran, m.docgarante, m.fechanacg, m.relacion, m.sueldog, m.oingresosg, m.antigueg, m.gastosg, m.casa, m.hipoteca, m.estado_civ, m.saldo_actu, m.obs1, m.obs2, m.obs3, m.obs4, m.obs5, m.obs6, m.obs7, m.obs8, m.obs9, m.obs10, m.ref1, m.ref2, m.ref3, m.ref4, m.ref5, m.ctacatas, m.dequien, m.lista, m.plazo, m.vendedor, m.facturar, m.estado

*-- Variables para c lculos del programa.
PRIVATE plAdding, plEditing, plDeleting, pnChoice, pcAppend, pcDelete, pnNextScreen, pnSaveWarn, pcTag, pnSelect, pcOrder, pnRecNo, pcCursorStatus

DO CASE
   CASE cWhatToDo = "Add"
      IF .NOT. UserConfig("brwClien.prg", "Add", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT clientes
      SCATTER MEMVAR MEMO BLANK
      m.estado     = "I"
      m.facturar   = "N"
      m.estado_civ = "-"
      m.casa       = "S"
      m.hipoteca   = "N"
      m.lista      = 1
      m.plazo      = 0
      m.vendedor   = 0
      
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
         SELECT clientes
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
      IF .NOT. UserConfig("brwClien.prg", "Edit", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT clientes
      
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
               DO clientes.prg WITH "Add"
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
         SELECT clientes
         GATHER MEMVAR MEMO
      ENDIF

      UNLOCK IN clientes
      
      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      pnNextScreen = 0
      pnSaveWarn   = 0

      POP KEY
   CASE cWhatToDo = "Delete"
      IF .NOT. UserConfig("brwClien.prg", "Delete", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT clientes

      IF DELETED()
         WAIT WINDOW "­ ESTE CLIENTE YA HA SIDO BORRADO !" 
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO clientes.prg WITH "Add"
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
      IF SEEK(clientes.codigo)
         ?? CHR(7)             
         WAIT WINDOW "ESTE CLIENTE FIGURA EN LA TABLA DE VENTAS, IMPOSIBLE BORRARLO !"
         DO RestoreWorkArea       
      ELSE 
         SELECT ot
         SET ORDER TO TAG indice4 OF ot.cdx
         IF SEEK(clientes.codigo)
            ?? CHR(7)
            WAIT WINDOW "ESTE CLIENTE FIGURA EN LA TABLA DE O.T., IMPOSIBLE BORRARLO !"
            DO RestoreWorkArea       
         ELSE 
            SELECT caberemi
            SET ORDER TO indice3 OF caberemi.cdx
            IF SEEK(clientes.codigo)
               ?? CHR(7)
               WAIT WINDOW "ESTE CLIENTE FIGURA EN LA TABLA REMISIONES, IMPOSIBLE BORRARLO !"
               DO RestoreWorkArea       
            ELSE 
               SELECT cabepres
               SET ORDER TO indice3 OF cabepres.cdx
               IF SEEK(clientes.codigo)
                  ?? CHR(7)
                  WAIT WINDOW "ESTE CLIENTE FIGURA EN LA TABLA PRESUPUESTOS, IMPOSIBLE BORRARLO !"
                  DO RestoreWorkArea       
               ELSE 
                  SELECT cabecob
                  SET ORDER TO indice3 OF cabecob.cdx
                  IF SEEK(clientes.codigo) 
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

      UNLOCK IN clientes

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
                     DO clientes.prg WITH "Add"
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
      
      SELECT clientes

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
               DO clientes.prg WITH "Add"
               EXIT DO
            ENDIF
            IF UPPER(pcAppend) = "N"
               EXIT DO
            ENDIF
         ENDDO    
         POP KEY
         RETURN
      ENDIF

*     IF .NOT. RLOCK()
*        WAIT WINDOW "­ ESTE REGISTRO ESTA SIENDO UTILIZADO POR OTRO USUARIO !"
*        POP KEY
*        RETURN         
*     ENDIF

      SCATTER MEMVAR MEMO
      
      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .T.
      pnNextScreen = 1
      
      IF SET("CURSOR") = "ON"
         SET CURSOR OFF
         pcCursorStatus = "ON"
      ELSE
         pcCursorStatus = "OFF"
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
      
      IF pcCursorStatus = "ON"
         SET CURSOR ON
      ENDIF
      
      UNLOCK IN clientes

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .F.

      POP KEY
ENDCASE