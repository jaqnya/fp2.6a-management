*:**************************************************************************
*:
*: Archivo de Procedimiento: MAESPROD.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: ABM de Art¡culos.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/04/2004
*:
*:**************************************************************************
PARAMETER cWhatToDo

*-- Variables de la Tabla.
PRIVATE m.codigo, m.codigo2, m.codorig, m.nombre, m.aplicacion, m.lista3, m.lista4, m.lista5, m.familia, m.rubro, m.subrubro, m.marca, m.unidad, m.proveedor, m.procedenci, m.ubicacion, m.vigente, m.lprecio, m.impuesto, m.pimpuesto, m.pcostog, m.pcostod, m.pcostogr, m.pcostodr, m.pcostogre, m.pcostodre, m.pventag1, m.pventag2, m.pventag3, m.pventag4, m.pventag5, m.pventad1, m.pventad2, m.pventad3, m.pventad4, m.pventad5, m.paumento1, m.paumento2, m.paumento3, m.paumento4, m.paumento5, m.stock_min, m.stock_max, m.polinvsmin, m.polinvsmax, m.garantia, m.caracter1, m.caracter2, m.caracter3, m.otros1, m.otros2, m.fecucompra, m.fecrepo, m.stock_actu, m.stock_ot, m.id_local

*-- Variables para c lculos del programa.
PRIVATE plAdding, plEditing, plDeleting, pnNextScreen, pnSaveWarn, pnChoice, pcAppend, pcAnswer, pnSelect, pcOrder, pnRecNo, plFound

DO CASE
   CASE cWhatToDo = "Add"
      IF .NOT. UserConfig("brwMaesp.prg", "Add", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT maesprod
      SCATTER MEMVAR MEMO BLANK

      plAdding     = .T.
      plEditing    = .F.
      plDeleting   = .F.
      pnNextScreen = 1
      pnSaveWarn   = 0

      DO WHILE  pnNextScreen <> 0
         DO CASE
            CASE pnNextScreen = 1
               DO maespro1.spr
            CASE pnNextScreen = 2
               DO maespro2.spr
         ENDCASE
      ENDDO

      IF pnSaveWarn = 1     
         INSERT INTO maesprod (codigo, codigo2, codorig, nombre, aplicacion, lista3, lista4, lista5, familia, rubro, subrubro, marca, unidad, proveedor, procedenci, ubicacion, vigente, lprecio, impuesto, pimpuesto, pcostog, pcostod, pcostogr, pcostodr, pcostogre, pcostodre, pventag1, pventag2, pventag3, pventag4, pventag5, pventad1, pventad2, pventad3, pventad4, pventad5, paumento1, paumento2, paumento3, paumento4, paumento5, stock_min, stock_max, polinvsmin, polinvsmax, garantia, caracter1, caracter2, caracter3, otros1, otros2, fecucompra, fecrepo, stock_actu, stock_ot, id_local) ;
            VALUES (m.codigo, m.codigo2, m.codorig, m.nombre, m.aplicacion, m.lista3, m.lista4, m.lista5, m.familia, m.rubro, m.subrubro, m.marca, m.unidad, m.proveedor, m.procedenci, m.ubicacion, m.vigente, m.lprecio, m.impuesto, m.pimpuesto, m.pcostog, m.pcostod, m.pcostogr, m.pcostodr, m.pcostogre, m.pcostodre, m.pventag1, m.pventag2, m.pventag3, m.pventag4, m.pventag5, m.pventad1, m.pventad2, m.pventad3, m.pventad4, m.pventad5, m.paumento1, m.paumento2, m.paumento3, m.paumento4, m.paumento5, m.stock_min, m.stock_max, m.polinvsmin, m.polinvsmax, m.garantia, m.caracter1, m.caracter2, m.caracter3, m.otros1, m.otros2, m.fecucompra, m.fecrepo, m.stock_actu, m.stock_ot, control.id_local)
      ENDIF

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      pnNextScreen = 0
      pnSaveWarn   = 0

      POP KEY
   CASE cWhatToDo = "Edit"
      IF .NOT. UserConfig("brwMaesp.prg", "Edit", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR
      
      SELECT maesprod

      IF DELETED()
         WAIT WINDOW "ESTE ARTICULO YA HA SIDO BORRADO, NO SE PUEDE EFECTUAR MODIFICACIONES !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO maesprod.prg WITH "Add"
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

      DO WHILE  pnNextScreen <> 0
         DO CASE
            CASE pnNextScreen = 1
               DO maespro1.spr
            CASE pnNextScreen = 2
               DO maespro2.spr
         ENDCASE
      ENDDO

      IF pnSaveWarn = 1     
         GATHER MEMVAR MEMO FIELDS codigo, codigo2, codorig, nombre, aplicacion, lista3, lista4, lista5, familia, rubro, subrubro, marca, unidad, proveedor, procedenci, ubicacion, vigente, lprecio, impuesto, pimpuesto, pcostog, pcostod, pcostogr, pcostodr, pcostogre, pcostodre, pventag1, pventag2, pventag3, pventag4, pventag5, pventad1, pventad2, pventad3, pventad4, pventad5, paumento1, paumento2, paumento3, paumento4, paumento5, stock_min, stock_max, polinvsmin, polinvsmax, garantia, caracter1, caracter2, caracter3, otros1, otros2, fecucompra, fecrepo
         REPLACE fecrepo WITH DATE()
      ENDIF

      UNLOCK IN maesprod

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      pnNextScreen = 0
      pnSaveWarn   = 0

      POP KEY
   CASE cWhatToDo = "Delete"
      IF .NOT. UserConfig("brwMaesp.prg", "Delete", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT maesprod
      
      IF DELETED()
         WAIT WINDOW "­ ESTE ARTICULO YA HA SIDO BORRADO !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO maesprod.prg WITH "Add"
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
         WAIT WINDOW "¨ DESEA BORRARLO ? [S/N]" TO pcAnswer
         IF UPPER(pcAnswer) = "S" 
            SCATTER MEMVAR MEMO

            WAIT WINDOW "POR FAVOR, AGUARDE UN MOMENTO..." NOWAIT

            pnSelect    = SELECT()
            pcOrder     = ORDER()
            pnRecNo     = IIF(EOF(), 0, RECNO())

            SELECT detacomp
            LOCATE FOR detacomp.articulo = m.codigo   
            IF FOUND() 
               ?? CHR(7)             
               WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE COMPRAS, IMPOSIBLE BORRARLO !"
               plFound = .T.
            ELSE 
               SELECT detamot
               LOCATE FOR detamot.articulo = m.codigo
               IF FOUND() 
                  ?? CHR(7)
                  WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE MOV. DE OT, IMPOSIBLE BORRARLO !"
                  plFound = .T.
               ELSE 
                  SELECT detamovi
                  LOCATE FOR detamovi.articulo = m.codigo
                  IF FOUND() 
                     ?? CHR(7)
                     WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE AJUSTES, IMPOSIBLE BORRARLO !"
                     plFound = .T.
                  ELSE 
                     SELECT detanotc
                     LOCATE FOR detanotc.articulo = m.codigo
                     IF FOUND()
                        ?? CHR(7)
                        WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE N.DEB/CRED (C), IMPOSIBLE BORRARLO !"
                        plFound = .T.
                     ELSE
                        SELECT detanotp
                        LOCATE FOR detanotp.articulo = m.codigo
                        IF FOUND()
                           ?? CHR(7)
                           WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE N.DEB/CRED (P), IMPOSIBLE BORRARLO !"
                           plFound = .T.
                        ELSE
                           SELECT detapres
                           LOCATE FOR detapres.articulo = m.codigo
                           IF FOUND()
                              ?? CHR(7)
                              WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE PRESUPUESTOS, IMPOSIBLE BORRARLO !"
                              plFound = .T.
                           ELSE
                              SELECT detaremi
                              LOCATE FOR detaremi.articulo = m.codigo
                              IF FOUND()
                                 ?? CHR(7)
                                 WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE REMISIONES, IMPOSIBLE BORRARLO !"
                                 plFound = .T.
                              ELSE
                                 SELECT detavent
                                 LOCATE FOR detavent.articulo = m.codigo
                                 IF FOUND()
                                    ?? CHR(7)
                                    WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE VENTAS, IMPOSIBLE BORRARLO !"
                                    plFound = .T.
                                 ELSE
                                    SELECT mecancfg
                                    LOCATE FOR mecancfg.articulo = m.codigo
                                    IF FOUND()
                                       ?? CHR(7)
                                       WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE MECANICOS, IMPOSIBLE BORRARLO !"
                                       plFound = .T.
                                    ELSE
                                       SELECT servicio
                                       LOCATE FOR servicio.articulo = m.codigo
                                       IF FOUND()
                                          ?? CHR(7)
                                          WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE MANO DE OBRA, IMPOSIBLE BORRARLO !"
                                          plFound = .T.
                                       ELSE 
                                          plFound = .F.
                                       ENDIF
                                    ENDIF
                                 ENDIF
                              ENDIF
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF

            SELECT (pnSelect)
            SET ORDER TO TAG (pcOrder) 
            IF pnRecNo <> 0 
               GOTO RECORD pnRecNo
            ENDIF

            IF .NOT. plFound
               DELETE 
               WAIT WINDOW "­ ESTE ARTICULO HA SIDO BORRADO !"
            ENDIF
      
            UNLOCK IN maesprod

            EXIT DO
         ELSE
            IF UPPER(pcAnswer) = "N"
               EXIT DO
            ENDIF
         ENDIF
      ENDDO

      IF .NOT. EOF()
         SKIP 1
         IF EOF()
            SKIP -1
            IF BOF()
               DO WHILE .T.
                  WAIT WINDOW "    ESTE ERA EL ULTIMO REGISTRO" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
                  IF UPPER(pcAppend) = "S"
                     DO maesprod.prg WITH "Add"
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
