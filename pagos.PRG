*:**************************************************************************
*:
*: Archivo de Procedimiento: PAGOS.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: ABM de Pagos a Proveedores.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/04/2004
*:
*:**************************************************************************
PARAMETER cWhatToDo

*-- Variables de la tabla.
PRIVATE m.tiporeci, m.nroreci, m.fechareci, m.proveedor, m.monto_pago, m.id_local

*-- Variables para c lculos del programa.
PRIVATE plAdding, plEditing, plDeleting, plConsulting, pcAppend, pcDeleteIt

DO CASE
   CASE cWhatToDo = "Add"
      PUSH KEY CLEAR

      SELECT cabepag
      SCATTER MEMVAR MEMO BLANK
      
      plAdding     = .T.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .F.
       
      DO pagos.spr

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .F.
            
      POP KEY
   CASE cWhatToDo = "Delete"
      PUSH KEY CLEAR

      SELECT cabepag

      IF cabepag.fechareci <> DATE() THEN
         WAIT "LOS REGISTROS DE ESTA TABLA NO PUEDEN SER BORRADOS !" WINDOW NOWAIT
         POP KEY
         RETURN
      ENDIF

      IF DELETED()
         WAIT WINDOW "­ ESTE PAGO YA HA SIDO BORRADO !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO pagos.prg WITH "Add"
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
      plConsulting = .F.

      DO _DeleteReceipt
      
      UNLOCK IN cabepag

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .F.
      
      IF .NOT. EOF()
         SKIP 1
         IF EOF()
            SKIP -1
            IF BOF()
               DO WHILE .T.
                  WAIT WINDOW "    ESTE ERA EL ULTIMO REGISTRO" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
                  IF UPPER(pcAppend) = "S"
                     DO pagos.prg WITH "Add"
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
      
      SELECT cabepag

      IF DELETED()
         WAIT WINDOW "! ESTE PAGO YA  HA SIDO BORRADO !" + CHR(13) + ;
                     "NO SE PUEDE VISUALIZAR EL DETALLE"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO pagos.prg WITH "Add"
               EXIT DO
            ENDIF
            IF UPPER(pcAppend) = "N"
               EXIT DO
            ENDIF
         ENDDO    
         POP KEY
         RETURN
      ENDIF

      IF NOT RLOCK()
         WAIT WINDOW "­ ESTE REGISTRO ESTA SIENDO UTILIZADO POR OTRO USUARIO !"
         POP KEY
         RETURN         
      ENDIF

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .T.

      DO _ViewDetail
     
      UNLOCK IN cabepag 

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .F.

      POP KEY
ENDCASE

*!*********************************************************************
*!
*!      Funci¢n: _ViewDetail
*!
*!  Llamado por: PAGOS.PRG                  
*!
*!  Descripci¢n: Carga y visualiza el detalle del pago.
*!
*!*********************************************************************
FUNCTION _ViewDetail     

SELECT tmpdetapag     &&   Vac¡a la  tabla  temporal  que  contiene  el
ZAP                   &&   detalle del recibo de pago.

SELECT detapag
SET ORDER TO 1
IF SEEK(STR(cabepag.tiporeci, 1) + STR(cabepag.nroreci, 7) + STR(cabepag.proveedor, 5))
   WAIT WINDOW "POR FAVOR, AGUARDE UN MOMENTO..." NOWAIT
   SCAN WHILE STR(cabepag.tiporeci, 1) + STR(cabepag.nroreci, 7) + STR(cabepag.proveedor, 5) = STR(detapag.tiporeci, 1) + STR(detapag.nroreci, 7) + STR(detapag.proveedor, 5)
      INSERT INTO tmpdetapag (tiporeci, nroreci, fechadocu, tipodocu, nrodocu, proveedor, nrocuota, monto) ;
         VALUES (detapag.tiporeci, detapag.nroreci, detapag.fechadocu, detapag.tipodocu, detapag.nrodocu, detapag.proveedor, detapag.nrocuota, detapag.monto)
   ENDSCAN
   WAIT CLEAR
ENDIF

SELECT tmpdetapag
GO TOP

IF RECCOUNT() = 0
   WAIT WINDOW "­ ESTE PAGO NO POSEE DETALLE O FALTA RE-INDEXAR !"
   SELECT cabepag
   RETURN
ENDIF

*-- Definiciones de ventanas.
IF .NOT. WEXIST("tmpdetapag")
   DEFINE WINDOW tmpdetapag ;
      FROM 01,00 ;
      TO   23,79 ;
      TITLE IIF(cabepag.tiporeci = 1, "R.P.", IIF(cabepag.tiporeci = 2, "CIP.", "    ")) + " N§: " + ALLTRIM(STR(cabepag.nroreci)) + " - " + LEFT(ALLTRIM(proveedo.nombre), 40) + " - " + DTOC(cabepag.fechareci) ;
      SYSTEM ;
      CLOSE ;
      NOFLOAT ;
      GROW ;
      MDI ;         
      NOMINIMIZE ;
      SHADOW ;
      ZOOM ;
      COLOR SCHEME 15
ENDIF

*-- Macros de teclado.
ON KEY LABEL "SPACEBAR"  DO _clcReceiptTotal
ON KEY LABEL "CTRL+HOME" GO TOP
ON KEY LABEL "CTRL+END"  GO BOTTOM

BROWSE WINDOW tmpdetapag FIELDS ;
   calc_f1 = IIF(tipodocu = 2, "CCRE", "    ") :R:04:H = "" ,;
   nrodocu   :R:07:H = "N§ Doc."    :P = "9999999" ,;
   nrocuota  :R:05:H = "Cuota"      :P = "99999" ,;
   fechadocu :R:10:H = "Fecha Vto." :P = "@D" ,;
   monto     :R:14:H = "Este Pago" :P = "999,999,999.99" ;
   NOAPPEND NODELETE NOMODIFY

*-- Restablece macros de teclado.
ON KEY LABEL "SPACEBAR"
ON KEY LABEL "CTRL+HOME"
ON KEY LABEL "CTRL+END"  

SELECT cabepag

IF WEXIST("tmpdetapag")
   RELEASE WINDOW tmpdetapag  
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _clcReceiptTotal
*!
*!  Llamado por: PAGOS.PRG \ _ViewDetail                  
*!
*!  Descripci¢n: Visualiza el importe total del pago.
*!
*!*********************************************************************
FUNCTION _clcReceiptTotal

PRIVATE pnRecord, pnReceiptTotal
pnRecord = IIF(EOF(), 0, RECNO())

SUM monto TO pnReceiptTotal

IF pnRecord <> 0
   GOTO RECORD pnRecord
ENDIF

WAIT WINDOW "IMPORTE TOTAL DEL RECIBO: " + ALLTRIM(TRANSFORM(pnReceiptTotal, "999,999,999.99"))

*!*********************************************************************
*!
*!      Funci¢n: _DeleteReceipt
*!
*!  Llamado por: PAGOS.PRG       
*!
*!  Descripci¢n: Borra el pago.
*!
*!*********************************************************************
FUNCTION _DeleteReceipt

DO WHILE .T.
   WAIT WINDOW "¨ DESEA BORRARLO ? [S/N]" TO pcDeleteIt
   IF INLIST(UPPER(pcDeleteIt), "S", "N")
      EXIT DO
   ENDIF
ENDDO   

IF UPPER(pcDeleteIt) = "S" 
   *-- Borra el detalle del recibo de pago y actualiza el saldo en el: encabezado de la compra y en la cuota de compra.
   SELECT detapag
   SET ORDER TO TAG indice1 OF detapag.cdx

   IF SEEK(STR(cabepag.tiporeci, 1) + STR(cabepag.nroreci, 7)  + STR(cabepag.proveedor, 5))  
      SCAN WHILE STR(detapag.tiporeci, 1) + STR(detapag.nroreci, 7) + STR(detapag.proveedor, 5) = STR(cabepag.tiporeci, 1) + STR(cabepag.nroreci, 7) + STR(cabepag.proveedor, 5)
         *-- Actualiza el saldo del encabezado de la compra.
         SELECT cabecomp
         SET ORDER TO TAG indice1 OF cabecomp.cdx
         
         IF SEEK(STR(detapag.tipodocu, 1) + STR(detapag.nrodocu, 9) + STR(cabepag.proveedor, 5))
            REPLACE cabecomp.monto_pago WITH (cabecomp.monto_pago - detapag.monto)
         ELSE
            WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DE LA COMPRA: " + ALLTRIM(STR(detapag.tipodocu, 1)) + "/" + ALLTRIM(STR(detapag.nrodocu, 9)) + " !" 
         ENDIF

         *-- Actualiza el saldo de la cuota de compra.
         SELECT cuotas_c
         SET ORDER TO TAG indice1 OF cuotas_c.cdx
         
         IF SEEK(STR(detapag.tipodocu, 1) + STR(detapag.nrodocu, 9) + STR(detapag.proveedor, 5) + STR(detapag.nrocuota, 3))
            REPLACE cuotas_c.abonado WITH (cuotas_c.abonado - detapag.monto)
         ELSE
            WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR LA CUOTA N§: " + ALLTRIM(STR(detapag.nrocuota, 3)) + " DE LA COMPRA: " + ALLTRIM(STR(detapag.tipodocu, 1)) + "/" + ALLTRIM(STR(detapag.nrodocu, 9)) + " !"
         ENDIF
         
         SELECT detapag
         DELETE
      ENDSCAN
   ELSE
      WAIT WINDOW "­ EL PAGO N§: " + ALLTRIM(STR(cabepag.tiporeci, 1)) + "/" + ALLTRIM(STR(cabepag.nroreci, 7)) + " NO POSEE DETALLE !"
   ENDIF

   *-- Actualiza el saldo del proveedor.
   SELECT proveedo
   SET ORDER TO TAG indice1 OF proveedo.cdx

   IF SEEK(cabepag.proveedor)
      IF cabepag.moneda = 1 THEN
         REPLACE saldo_actu WITH (saldo_actu + cabepag.monto_pago)
      ELSE
         REPLACE saldo_usd  WITH (saldo_usd  + cabepag.monto_pago)
      ENDIF
   ELSE
      WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DEL PROVEEDOR: " + ALLTRIM(STR(cabepag.proveedor, 5)) + " !"
   ENDIF  
   
   *-- Borra el encabezado del recibo de pago.
   SELECT cabepag
   DELETE
   WAIT WINDOW "­ ESTE DE PAGO HA SIDO BORRADO !"
ENDIF