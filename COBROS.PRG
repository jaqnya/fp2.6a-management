*:*********************************************************************
*:
*: Archivo de Procedimiento: COBROS.PRG
*:
*:                  Sistema: Integrado de Gesti¢n Financiera.
*:              Sub-Sistema: ABM de Cobros a Clientes.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 29/02/2004
*:
*:            Procs & Fncts: _DeleteReceipt
*:                           _ViewDetail
*:                           _clcReceiptTotal
*:
*:*********************************************************************
PARAMETER cWhatToDo

*-- Variables de la tabla.
PRIVATE m.tiporeci, m.nroreci, m.fechareci, m.local, m.moneda, m.tipocambio, m.factura, m.cliente, m.cobrador, m.comision, m.monto_cobr, m.fechaanu, m.anulado

*-- Variables para c lculos del programa.
PRIVATE plAdding, plEditing, plDeleting, plConsulting, pcAppend, pcDeleteIt, pcAnnulIt

DO CASE
   CASE cWhatToDo = "Add"
      PUSH KEY CLEAR

      SELECT cabecob
      SCATTER MEMVAR MEMO BLANK
      
      plAdding     = .T.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .F.

      IF UserConfig("brwCobro.prg", "Add", .T.) THEN
         DO cobros.spr
      ENDIF

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .F.
            
      POP KEY
   CASE cWhatToDo = "Edit"
      PUSH KEY CLEAR

      SELECT cabecob

      IF cabecob.fechareci <> DATE() THEN
         WAIT "LOS REGISTROS DE ESTA TABLA NO PUEDEN SER MODIFICADOS !" WINDOW NOWAIT
         POP KEY
         RETURN
      ENDIF

      IF DELETED()
         WAIT WINDOW "­ ESTE COBRO HA SIDO BORRADO, IMPOSIBLE EFECTUAR MODIFICACIONES !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO cobros.prg WITH "Add"
               EXIT DO
            ENDIF
            IF UPPER(pcAppend) = "N"
               EXIT DO
            ENDIF
         ENDDO    
         POP KEY
         RETURN
      ENDIF
     
      IF factura = "S"
         WAIT WINDOW "­ DISCULPE, DEBE BORRAR LA COBRANZA Y CARGARLO DE NUEVO !"
         POP KEY
         RETURN
      ENDIF

      IF NOT RLOCK()
         WAIT WINDOW "­ ESTE REGISTRO ESTA SIENDO UTILIZADO POR OTRO USUARIO !"
         POP KEY
         RETURN         
      ENDIF

      SCATTER MEMVAR MEMO
      
      plAdding     = .F.
      plEditing    = .T.
      plDeleting   = .F.
      plConsulting = .F.
       
      DO cobros.spr

      UNLOCK IN cabecob

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .F.
            
      POP KEY
   CASE cWhatToDo = "Delete"
      PUSH KEY CLEAR

      IF UserConfig("brwCobro.prg", "Delete", .T.) THEN
         SELECT cabecob

         IF cabecob.fechareci <> DATE() THEN
            WAIT "LOS REGISTROS DE ESTA TABLA NO PUEDEN SER BORRADOS O ANULADOS !" WINDOW NOWAIT
            POP KEY
            RETURN
         ENDIF

         IF DELETED()
            WAIT WINDOW "­ ESTE COBRO YA HA SIDO BORRADO !"
            POP KEY
            RETURN
         ENDIF

         IF EOF()
            DO WHILE .T.
               WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
               IF UPPER(pcAppend) = "S"
                  DO cobros.prg WITH "Add"
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
         plDeleting   = .T.
         plConsulting = .F.

         DO _DeleteReceipt
      
         UNLOCK IN cabecob

         plAdding     = .F.
         plEditing    = .F.
         plDeleting   = .F.
         plConsulting = .F.
      
         IF NOT EOF()
            SKIP 1
            IF EOF()
               SKIP -1
               IF BOF()
                  PUSH KEY CLEAR
                  DO WHILE .T.
                     WAIT WINDOW "    ESTE ERA EL ULTIMO REGISTRO" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
                     IF UPPER(pcAppend) = "S"
                        DO cobros.prg WITH "Add"
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
      ENDIF
      POP KEY
   CASE cWhatToDo = "Consult"
      PUSH KEY CLEAR
      
      SELECT cabecob

      IF DELETED()
         WAIT WINDOW "! ESTE COBRO YA HA SIDO BORRADO !" + CHR(13) + ;
                     "NO SE PUEDE VISUALIZAR EL DETALLE"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO cobros.prg WITH "Add"
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
     
      UNLOCK IN cabecob 

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
*!  Llamado por: COBROS.PRG                  
*!
*!  Descripci¢n: Carga y visualiza el detalle del cobro.
*!
*!*********************************************************************
FUNCTION _ViewDetail     

SELECT tmpdetacob     &&   Vac¡a la  tabla  temporal  que  contiene  el
ZAP                   &&   detalle del recibo de cobro.

SELECT detacob
SET ORDER TO 1
IF SEEK(STR(cabecob.tiporeci, 1) + STR(cabecob.nroreci, 7))
   WAIT WINDOW "POR FAVOR, AGUARDE UN MOMENTO..." NOWAIT
   SCAN WHILE STR(cabecob.tiporeci, 1) + STR(cabecob.nroreci, 7) = STR(detacob.tiporeci, 1) + STR(detacob.nroreci, 7)
      INSERT INTO tmpdetacob (tiporeci, nroreci, tipodocu, nrodocu, nrocuota, fechadocu, monto) ;
         VALUES (detacob.tiporeci, detacob.nroreci, detacob.tipodocu, detacob.nrodocu, detacob.nrocuota, detacob.fechadocu, detacob.monto)
   ENDSCAN
   WAIT CLEAR
ENDIF

SELECT tmpdetacob
GO TOP

IF RECCOUNT() = 0
   WAIT WINDOW "­ ESTA COBRANZA NO POSEE DETALLE O FALTA RE-INDEXAR !"
   SELECT cabecob
   RETURN
ENDIF

*-- Definiciones de ventanas.
IF NOT WEXIST("tmpdetacob")
   DEFINE WINDOW tmpdetacob ;
      FROM 01,00 ;
      TO   23,79 ;
      TITLE IIF(cabecob.tiporeci = 1, "R.C.", IIF(cabecob.tiporeci = 2, "CIC.", "    ")) + " N§: " + ALLTRIM(STR(cabecob.nroreci)) + " - " + LEFT(ALLTRIM(clientes.nombre), 40) + " - " + DTOC(cabecob.fechareci) ;
      NOFLOAT ;
      CLOSE ;
      NOSHADOW ;
      ZOOM ;
      NOMINIMIZE ;
      SYSTEM ;
      COLOR SCHEME 15
ENDIF

*-- Macros de teclado.
ON KEY LABEL "SPACEBAR"  DO _clcReceiptTotal
ON KEY LABEL "CTRL+HOME" GO TOP
ON KEY LABEL "CTRL+END"  GO BOTTOM

BROWSE WINDOW tmpdetacob FIELDS ;
   calc_f1 = IIF(INLIST(tipodocu, 2, 6, 8), "VCRE", "    ") :R:04:H = "" ,;
   nrodocu   :R:07:H = "N§ Doc."    :P = "9999999" ,;
   nrocuota  :R:05:H = "Cuota"      :P = "99999" ,;
   fechadocu :R:10:H = "Fecha Vto." :P = "@D" ,;
   monto     :R:11:H = "Este Cobro" :P = "999,999,999" ;
   NOAPPEND NODELETE NOMODIFY

*-- Restablece macros de teclado.
ON KEY LABEL "SPACEBAR"
ON KEY LABEL "CTRL+HOME"
ON KEY LABEL "CTRL+END"  

SELECT cabecob

IF WEXIST("tmpdetacob")
   RELEASE WINDOW tmpdetacob  
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _clcReceiptTotal
*!
*!  Llamado por: COBROS.PRG \ _ViewDetail                  
*!
*!  Descripci¢n: Visualiza el importe total del cobro.
*!
*!*********************************************************************
FUNCTION _clcReceiptTotal

PRIVATE pnRecord, pnReceiptTotal
pnRecord = IIF(EOF(), 0, RECNO())

SUM monto TO pnReceiptTotal

IF pnRecord <> 0
   GOTO RECORD pnRecord
ENDIF

WAIT WINDOW "IMPORTE TOTAL DEL RECIBO: " + ALLTRIM(TRANSFORM(pnReceiptTotal, "999,999,999"))

*!*********************************************************************
*!
*!      Funci¢n: _DeleteReceipt
*!
*!  Llamado por: COBROS.PRG       
*!
*!  Descripci¢n: Borra o anula el cobro.
*!
*!*********************************************************************
FUNCTION _DeleteReceipt

DO WHILE .T.
   WAIT WINDOW "¨ DESEA BORRARLO ? [S/N]" TO pcDeleteIt
   IF INLIST(UPPER(pcDeleteIt), "S", "N")
      EXIT DO
   ENDIF
ENDDO   

IF UPPER(pcDeleteIt) = "S" THEN
   DO WHILE .T.
      WAIT WINDOW "¨ DESEA: (B)ORRARLO o (A)NULARLO ?" TO pcAnnulIt
      IF INLIST(UPPER(pcAnnulIt), "B", "A")
         EXIT DO
      ENDIF
      IF LASTKEY() = 27
         pcDeleteIt = "N"
         EXIT DO
      ENDIF
   ENDDO
ENDIF
  
IF UPPER(pcDeleteIt) = "S" 
   *-- Borra el detalle del recibo de cobro y actualiza el saldo en el: encabezado de la venta y en la cuota de venta.
   SELECT detacob
   SET ORDER TO TAG indice1

   IF SEEK(STR(cabecob.tiporeci, 1) + STR(cabecob.nroreci, 7))  
      SCAN WHILE STR(detacob.tiporeci, 1) + STR(detacob.nroreci, 7) = STR(cabecob.tiporeci, 1) + STR(cabecob.nroreci, 7)
         *-- Actualiza el saldo del encabezado de la venta.
         SELECT cabevent
         SET ORDER TO TAG indice1 OF cabevent.cdx
         
         IF SEEK(STR(detacob.tipodocu, 1) + STR(detacob.nrodocu, 7))
            REPLACE cabevent.monto_cobr WITH (cabevent.monto_cobr - detacob.monto)
         ELSE
            WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DE LA VENTA: " + ALLTRIM(STR(detacob.tipodocu, 1)) + "/" + ALLTRIM(STR(detacob.nrodocu, 7)) + " !" 
         ENDIF

         *-- Actualiza el saldo de la cuota de venta.
         SELECT cuotas_v
         SET ORDER TO TAG indice1 OF cuotas_v
         
         IF SEEK(STR(detacob.tipodocu, 1) + STR(detacob.nrodocu, 7) + STR(detacob.nrocuota, 3))
            REPLACE cuotas_v.abonado WITH (cuotas_v.abonado - detacob.monto)
         ELSE
            WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR LA CUOTA N§: " + ALLTRIM(STR(detacob.nrocuota, 3)) + " DE LA VENTA: " + ALLTRIM(STR(detacob.tipodocu, 1)) + "/" + ALLTRIM(STR(detacob.nrodocu, 7)) + " !"
         ENDIF
         
         SELECT detacob
         DELETE
      ENDSCAN
   ELSE
      IF NOT cabecob.anulado
         WAIT WINDOW "­ EL COBRO N§: " + ALLTRIM(STR(cabecob.tiporeci, 1)) + "/" + ALLTRIM(STR(cabecob.nroreci, 7)) + " NO POSEE DETALLE !"
      ENDIF
   ENDIF

   *-- Actualiza el saldo del cliente.
   SELECT clientes
   SET ORDER TO TAG indice1 OF clientes.cdx

   IF SEEK(cabecob.cliente)
      IF cabecob.moneda = 1   && Guaranies
         REPLACE clientes.saldo_actu WITH (clientes.saldo_actu + cabecob.monto_cobr)
      ELSE
         REPLACE clientes.saldo_usd  WITH (clientes.saldo_usd  + cabecob.monto_cobr)
      ENDIF
   ELSE
      IF NOT cabecob.anulado
         WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DEL CLIENTE: " + ALLTRIM(STR(cabecob.cliente, 5)) + " !"
      ENDIF
   ENDIF  
   
   *-- Borra o anula el encabezado del recibo de cobro.
   SELECT cabecob
   IF UPPER(pcAnnulIt) = "B"
      DELETE
      WAIT WINDOW "­ ESTE DE COBRO HA SIDO BORRADO !"
   ELSE  
      IF UPPER(pcAnnulIt) = "A"
         IF NOT cabecob.anulado
            REPLACE fechareci  WITH {}
            REPLACE id_local   WITH 0
            REPLACE moneda     WITH 0
            REPLACE tipocambio WITH 0
            REPLACE factura    WITH ""
            REPLACE cliente    WITH 0
            REPLACE cobrador   WITH 0
            REPLACE comision   WITH 0
            REPLACE monto_cobr WITH 0
            REPLACE fechaanu   WITH DATE()
            REPLACE anulado    WITH .T.
            WAIT WINDOW "­ ESTE COBRO HA SIDO ANULADO !"
         ELSE
            WAIT WINDOW "­ ESTE COBRO YA HA SIDO ANULADO !"
         ENDIF
      ENDIF      
   ENDIF
ENDIF