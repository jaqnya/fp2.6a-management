*:**************************************************************************
*:
*: Archivo de Procedimiento: PROVEEDO.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: ABM de Proveedores.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/04/2004
*:
*:**************************************************************************
PARAMETER cWhatToDo

*-- Variables de la Tabla.
PRIVATE m.codigo, m.nombre, m.direc1, m.direc2, m.ciudad, m.telefono, m.fax, m.e_mail, m.ruc, m.dias_plazo, m.dueno, m.teldueno, m.gtegral, m.telgg, m.gteventas, m.telgv, m.gtemkg, m.telgm, m.stecnico, m.stdirec1, m.stdirec2, m.sttel, m.sthablar1, m.vendedor1, m.larti1, m.tvend1, m.vendedor2, m.larti2, m.tvend2, m.vendedor3, m.larti3, m.tvend3, m.vendedor4, m.larti4, m.tvend4, m.vendedor5, m.larti5, m.tvend5, m.saldo_actu, m.vigente, m.id_local

*-- Variables para c lculos del programa.
PRIVATE plAdding, plEditing, plDeleting, pnNextScreen, pnSaveWarn, pcAppend, pcAnswer, pnSelect, pcOrder, pnRecNo, plFound

DO CASE
   CASE cWhatToDo = "Add"
      IF .NOT. UserConfig("brwProve.prg", "Add", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT proveedo
      SCATTER MEMVAR MEMO BLANK

      plAdding     = .T.
      plEditing    = .F.
      plDeleting   = .F.
      pnNextScreen = 1
      pnSaveWarn   = 0
      
      DO WHILE pnNextScreen <> 0
         DO CASE
            CASE pnNextScreen = 1
               DO proveed1.spr
            CASE pnNextScreen = 2
               DO proveed2.spr
         ENDCASE
      ENDDO

      IF pnSaveWarn = 1     
         INSERT INTO proveedo (codigo, nombre, direc1, direc2, ciudad, telefono, fax, e_mail, ruc, dias_plazo, dueno, teldueno, gtegral, telgg, gteventas, telgv, gtemkg, telgm, stecnico, stdirec1, stdirec2, sttel, sthablar1, vendedor1, larti1, tvend1, vendedor2, larti2, tvend2, vendedor3, larti3, tvend3, vendedor4, larti4, tvend4, vendedor5, larti5, tvend5, saldo_actu, vigente, id_local) ;
            VALUES (m.codigo, m.nombre, m.direc1, m.direc2, m.ciudad, m.telefono, m.fax, m.e_mail, m.ruc, m.dias_plazo, m.dueno, m.teldueno, m.gtegral, m.telgg, m.gteventas, m.telgv, m.gtemkg, m.telgm, m.stecnico, m.stdirec1, m.stdirec2, m.sttel, m.sthablar1, m.vendedor1, m.larti1, m.tvend1, m.vendedor2, m.larti2, m.tvend2, m.vendedor3, m.larti3, m.tvend3, m.vendedor4, m.larti4, m.tvend4, m.vendedor5, m.larti5, m.tvend5, m.saldo_actu, m.vigente, control.id_local)
         DO _updProviderList
      ENDIF

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      pnNextScreen = 0
      pnSaveWarn   = 0
      
      POP KEY
   CASE cWhatToDo = "Edit"
      IF .NOT. UserConfig("brwProve.prg", "Edit", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR
      
      SELECT proveedo

      IF DELETED()
         WAIT WINDOW "ESTE PROVEEDOR YA HA SIDO BORRADO, NO SE PUEDE EFECTUAR MODIFICACIONES !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO proveedo.prg WITH "Add"
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

      DO WHILE pnNextScreen <> 0
         DO CASE
            CASE pnNextScreen = 1
               DO proveed1.spr
            CASE pnNextScreen = 2
               DO proveed2.spr
         ENDCASE
      ENDDO

      IF pnSaveWarn = 1     
         GATHER MEMVAR MEMO FIELDS codigo, nombre, direc1, direc2, ciudad, telefono, fax, e_mail, ruc, dias_plazo, dueno, teldueno, gtegral, telgg, gteventas, telgv, gtemkg, telgm, stecnico, stdirec1, stdirec2, sttel, sthablar1, vendedor1, larti1, tvend1, vendedor2, larti2, tvend2, vendedor3, larti3, tvend3, vendedor4, larti4, tvend4, vendedor5, larti5, tvend5, vigente, id_local
         DO _updProviderList
      ENDIF

      UNLOCK IN proveedo

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      pnNextScreen = 0
      pnSaveWarn   = 0

      POP KEY
   CASE cWhatToDo = "Delete"
      IF .NOT. UserConfig("brwProve.prg", "Delete", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT proveedo
      
      IF DELETED()
         WAIT WINDOW "­ ESTE PROVEEDOR YA HA SIDO BORRADO !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO proveedo.prg WITH "Add"
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

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .T.
      pnNextScreen = 0
      pnSaveWarn   = 0

      DO WHILE .T. 
         WAIT WINDOW "¨ DESEA BORRARLO ? [S/N]" TO pcAnswer
         IF UPPER(pcAnswer) = "S" 
            SCATTER MEMVAR MEMO

            WAIT WINDOW "POR FAVOR, AGUARDE UN MOMENTO..." NOWAIT

            pnSelect    = SELECT()
            pcOrder     = ORDER()
            pnRecNo     = IIF(EOF(), 0, RECNO())

            SELECT cabecomp
            LOCATE FOR cabecomp.proveedor = m.codigo   
            IF FOUND() 
               ?? CHR(7)             
               WAIT WINDOW "ESTE PROVEEDOR FIGURA EN LA TABLA DE COMPRAS, IMPOSIBLE BORRARLO !"
               plFound = .T.
            ELSE 
               SELECT cabenotp
               LOCATE FOR cabenotp.proveedor = m.codigo
               IF FOUND() 
                  ?? CHR(7)
                  WAIT WINDOW "ESTE PROVEEDOR FIGURA EN LA TABLA DE N.DEB/CRED (P), IMPOSIBLE BORRARLO !"
                  plFound = .T.
               ELSE 
                  SELECT cabepag 
                  LOCATE FOR cabepag.proveedor = m.codigo
                  IF FOUND() 
                     ?? CHR(7)
                     WAIT WINDOW "ESTE PROVEEDOR FIGURA EN LA TABLA DE PAGOS, IMPOSIBLE BORRARLO !"
                     plFound = .T.
                  ELSE 
                     SELECT cuotas_c
                     LOCATE FOR cuotas_c.proveedor = m.codigo
                     IF FOUND()
                        ?? CHR(7)
                        WAIT WINDOW "ESTE PROVEEDOR FIGURA EN LA TABLA CUOTAS_C (P), IMPOSIBLE BORRARLO !"
                        plFound = .T.
                     ELSE
                        SELECT cuotas_p
                        LOCATE FOR cuotas_p.proveedor = m.codigo
                        IF FOUND()
                           ?? CHR(7)
                           WAIT WINDOW "ESTE PROVEEDOR FIGURA EN LA TABLA CUOTAS_P (P), IMPOSIBLE BORRARLO !"
                           plFound = .T.
                        ELSE
                           SELECT detacomp
                           LOCATE FOR detacomp.proveedor = m.codigo
                           IF FOUND()
                              ?? CHR(7)
                              WAIT WINDOW "ESTE PROVEEDOR FIGURA EN LA TABLA DETACOMP, IMPOSIBLE BORRARLO !"
                              plFound = .T.
                           ELSE
                              SELECT detanotp
                              LOCATE FOR detanotp.proveedor = m.codigo
                              IF FOUND()
                                 ?? CHR(7)
                                 WAIT WINDOW "ESTE PROVEEDOR FIGURA EN LA TABLA DETANOTP, IMPOSIBLE BORRARLO !"
                                 plFound = .T.
                              ELSE
                                 SELECT detapag
                                 LOCATE FOR detapag.proveedor = m.codigo
                                 IF FOUND()
                                    ?? CHR(7)
                                    WAIT WINDOW "ESTE PROVEEDOR FIGURA EN LA TABLA DETAPAG, IMPOSIBLE BORRARLO !"
                                    plFound = .T.
                                 ELSE
                                    SELECT maesprod
                                    LOCATE FOR maesprod.proveedor = m.codigo
                                    IF FOUND()
                                       ?? CHR(7)
                                       WAIT WINDOW "ESTE PROVEEDOR FIGURA EN LA TABLA DE ARTICULOS, IMPOSIBLE BORRARLO !"
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

            SELECT (pnSelect)
            SET ORDER TO TAG (pcOrder) 
            IF pnRecNo <> 0 
               GOTO RECORD pnRecNo
            ENDIF

            IF .NOT. plFound
               DELETE 
               WAIT WINDOW "­ ESTE PROVEEDOR HA SIDO BORRADO !"
               DO _updProviderList
            ENDIF
      
            UNLOCK IN proveedo

            EXIT DO
         ELSE
            IF UPPER(pcAnswer) = "N"
               EXIT DO
            ENDIF
         ENDIF
      ENDDO

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      pnNextScreen = 0
      pnSaveWarn   = 0

      IF .NOT. EOF()
         SKIP 1
         IF EOF()
            SKIP -1
            IF BOF()
               DO WHILE .T.
                  WAIT WINDOW "    ESTE ERA EL ULTIMO REGISTRO" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
                  IF UPPER(pcAppend) = "S"
                     DO proveedo.prg WITH "Add"
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

      SELECT proveedo
      
      IF DELETED()
         WAIT WINDOW "­ ESTE PROVEEDOR YA HA SIDO BORRADO !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO proveedo.prg WITH "Add"
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

      pnNextScreen = 1
      
      DO WHILE pnNextScreen <> 0
         DO CASE
            CASE pnNextScreen = 1
               DO proveed3.spr
               IF INLIST(LASTKEY(), 13, 3)
                  pnNextScreen = 2
               ELSE
                  IF LASTKEY() <> 27
                     pnNextScreen = 1
                  ELSE
                     pnNextScreen = 0
                  ENDIF
               ENDIF
            CASE pnNextScreen = 2
               DO proveed4.spr
               IF INLIST(LASTKEY(), 27, 18)
                  pnNextScreen = 1
               ELSE
                  pnNextScreen = 2
               ENDIF
         ENDCASE
      ENDDO

      pnNextScreen = 0

      UNLOCK IN proveedo

      POP KEY
ENDCASE

*!**************************************************************************
*!
*!  Procedimiento: _updProviderList
*!
*!    Llamado por: PROVEEDO.PRG                 
*!
*!    Descripci¢n: Actualiza la visualizaci¢n del cuadro de lista.
*!
*!**************************************************************************
FUNCTION _updProviderList

IF TYPE("aProveedor") <> "U"
   PRIVATE pnCount
   COUNT TO pnCount FOR vigente = "S"

   IF EMPTY(pnCount)
      DIMENSION aProveedor[1, 2]
      aProveedor = ""
   ELSE
      DIMENSION aProveedor[pnCount, 2]
      COPY TO ARRAY aProveedor FIELDS codigo, nombre FOR vigente = "S"
      =ASORT(aProveedor, AELEMENT(aProveedor, 1, 2))
   ENDIF

   IF plAdding .OR. plEditing
      IF .NOT. EMPTY(m.nombre)
         IF ASCAN(aProveedor, m.nombre, 1) > 0
            lstProveedores = ASUBSCRIPT(aProveedor, ASCAN(aProveedor, m.nombre, 1), 1)
         ENDIF
      ENDIF
   ENDIF

   IF plDeleting
      IF lstProveedores > ALEN(aProveedor, 1)
         lstProveedores = ALEN(aProveedor, 1)
      ENDIF
   ENDIF

   IF pnCount = 0
      SHOW GET cmdDelete DISABLE
      SHOW GET cmdEdit   DISABLE
   ELSE
      SHOW GET cmdDelete ENABLE
      SHOW GET cmdEdit   ENABLE
   ENDIF
   SHOW GET lstProveedores
ENDIF