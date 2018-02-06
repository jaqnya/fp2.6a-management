*:*********************************************************************
*:
*: Archivo de Procedimiento: MKNOTA_C.PRG
*:
*:                  Sistema: Agrega o Modifica una Nota de D‚b./Cr‚d.
*:                    Autor: Jos‚ Avilio Acu¤a Acosta
*:                 Copyright (c) 2004, Alben S.R.L.             
*:            Last modified: 12/02/2004           
*:
*:            Procs & Fncts:
*:
*:*********************************************************************
PARAMETER pcWhatToDo

PUSH KEY CLEAR

*-- Variables de la Tabla de Cabecera.
PRIVATE m.tiponota, m.nronota, m.tipodocu, m.nrodocu, m.fechanota, m.cliente, m.motivonota, m.aplicontra, m.fechaanu, m.anulado, m.monto_nota

*-- Variables para c lculos del programa.
PRIVATE pnGravada, pnExenta, pnImpuesto, pnSubTotal
                                                                                    
IF pcWhatToDo = "Add"
   SELECT cabenotc
   SCATTER MEMVAR MEMO BLANK
   
ELSE
   IF pcWhatToDo = "Edit"
      	IF cabenotc.anulado
      	   WAIT WINDOW "­ ESTA NOTA SE ENCUENTRA ANULADA, IMPOSIBLE MODIFICARLA !"
      	   POP KEY
      	   RETURN
      	ENDIF

        IF cabenotc.fechanota <> DATE() THEN
           WAIT "LOS REGISTROS DE ESTA TABLA NO PUEDEN SER MODIFICADOS !" WINDOW NOWAIT
           POP KEY 
           RETURN
        ENDIF

        SELECT cabenotc
      	SCATTER MEMVAR MEMO
   ENDIF
ENDIF

*-- Inicializaci¢n de variables.
STORE 0 TO pnGravada, pnExenta, pnImpuesto, pnSubTotal

IF pcWhatToDo = "Add"
   plAdding    = .T.
   plEditing   = .F.
   plDeleting  = .F.
   m.fechanota = DTOC(DATE()) 

   SELECT tmpdetnota
   ZAP
   SELECT tmpcuonota
   ZAP
ELSE
   IF pcWhatToDo = "Edit"
      plAdding    = .F.
      plEditing   = .T.
      plDeleting  = .F.
      m.fechanota = DTOC(m.fechanota)
      DO _LoadMaestemp 
   ENDIF
ENDIF  

SELECT cabenotc

DO _fmtInvoice

IF pcWhatToDo = "Edit"
   DO _RefreshInvoice
ENDIF

@ 02,14 GET m.tiponota ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN plAdding ;
   VALID _vldTipoNota() ;
   COLOR SCHEME 1

@ 02,44 GET m.nronota ;
   SIZE 1,7 ;
   DEFAULT 0 ;
   PICTURE "9999999" ;
   WHEN plAdding ;
   VALID _vldNroNota() ;
   COLOR SCHEME 1

@ 02,69 GET m.fechanota ;
   SIZE 1,10 ;
   DEFAULT DTOC(DATE()) ;
   PICTURE "99/99/9999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldFechaNota() ;
   COLOR SCHEME 1

@ 03,14 GET m.tipodocu ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN plAdding ;
   VALID _vldTipoDocu() ;
   COLOR SCHEME 1

@ 03,44 GET m.nrodocu ;
   SIZE 1,7 ;
   DEFAULT 0 ;
   PICTURE "9999999" ;
   WHEN plAdding ;
   VALID _vldNroDocu() ;
   COLOR SCHEME 1

IF plAdding 
   @ 03,69 SAY {} ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W
ENDIF

@ 04,14 SAY m.cliente  ;
   SIZE 1,5 ;
   PICTURE "99999" ;
   COLOR N/W

@ 05,14 GET m.motivonota ;
   SIZE 1,3 ;
   DEFAULT 0 ;
   PICTURE "999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldMotivoNota() ;
   COLOR SCHEME 1
   
@ 05,67 GET m.aplicontra ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN .F. ;
   VALID _vldAplicontra() ;
   COLOR SCHEME 1

@ 20,68 SAY pnSubTotal ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

@ 21,68 SAY pnImpuesto ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W     

@ 22,68 SAY m.monto_nota ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

READ CYCLE ;
   MODAL ;
   VALID _vldReadCycle() ;
   COLOR , W+/BG 

*!*********************************************************************
*!
*!      Funci¢n: _vldReadCycle
*!
*!  Llamado por: MKSELL.PRG      
*!
*!  Descripci¢n: Valida la terminaci¢n del comando READ.
*!
*!*********************************************************************
FUNCTION _vldReadCycle
IF LASTKEY() = 27 
*  IF LOWER(SYS(18)) = "pnImpues" .OR. LOWER(SYS(18)) = "importdesc"
*     _CUROBJ = OBJNUM(m.porcdesc)      
*     RETURN .F.
*  ENDIF
ENDIF

**-------------------------------------------------------------------**
**                            ENCABEZADO                             **
**-------------------------------------------------------------------**

*!*********************************************************************
*!
*!      Funci¢n: _vldTipoNota
*!
*!  Llamado por: MKCUOTA_C.PRG  
*!
*!  Descripci¢n: Validaci¢n del campo tipo de documento.
*!
*!*********************************************************************
FUNCTION _vldTipoNota
IF INLIST(LASTKEY(), 5, 19, 28, 127)
   RETURN .F.
ENDIF

IF m.tiponota > 2 
   @ 02,17 SAY REPLICATE(CHR(32), 21) ;
      SIZE 1,21 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ EL TIPO DE DOCUMENTO DEBE SER: 1 à 2 !"
   RETURN .F.
ENDIF   

IF m.tiponota <= 0
   @ 02,17 SAY REPLICATE(CHR(32), 21) ;
      SIZE 1,21 ;
      PICTURE "@!" ;
      COLOR W/N
   DO ncctipod.spr WITH "m.tiponota", 0, .F.
ENDIF

IF m.tiponota = 0
   RETURN .F.
ENDIF

DO CASE
   CASE m.tiponota = 1
      @ 02,17 SAY "NOTA DE DEBITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
      m.nronota = NextNumber()
   CASE m.tiponota = 2
      @ 02,17 SAY "NOTA DE CREDITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
      m.nronota = NextNumber()
   CASE m.tipodocu = 3
      @ 02,17 SAY "C.I. NOTA DE DEBITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
      m.nronota = NextNumber()
   CASE m.tipodocu = 4
      @ 02,17 SAY "C.I. NOTA DE CREDITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
      m.nronota = NextNumber()
   OTHERWISE
      @ 02,17 SAY REPLICATE(CHR(32), 21) ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
      m.nronota = 0
ENDCASE

*!*********************************************************************
*!
*!      Funci¢n: _vldNroNota
*!
*!  Llamado por: MKCUOTA_C.PRG          
*!
*!  Descripci¢n: Validaci¢n del campo n£mero de documento.    
*!
*!*********************************************************************
FUNCTION _vldNroNota
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

IF m.nronota <= 0
   WAIT WINDOW "­ EL N§ DEL DOCUMENTO DEBE SER MAYOR QUE CERO !"
   RETURN .F.
ENDIF

SELECT cabenotc
SET ORDER TO TAG indice1 OF cabenotc.cdx

IF SEEK(STR(m.tiponota, 1) + STR(m.nronota, 7))
   IF m.tiponota = 1
      WAIT WINDOW "­ ESTA NOTA DE DEBITO YA HA SIDO CARGADA !"
   ELSE
      IF m.tiponota = 2
         WAIT WINDOW "­ ESTA NOTA DE CREDITO YA HA SIDO CARGADA !"
      ELSE
         WAIT WINDOW "­ ESTE N§ DE DOCUMENTO YA HA SIDO CARGADO !"
      ENDIF
   ENDIF

   SELECT (pnSelect)
   SET ORDER TO TAG (pcOrder)
   IF pnRecNo <> 0
      GOTO RECORD pnRecNo
   ENDIF

   RETURN .F.
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: NextNumber 
*!
*!  Llamado por: MKNOTA_C.PRG                  
*!
*!  Descripci¢n: Obtiene el  pr¢ximo  n£mero  de  nota  de  deb./cred.,
*!               disponible,  teniendo en cuenta el tipo  de documento.
*!
*!*********************************************************************
FUNCTION NextNumber

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT cabenotc
SET ORDER TO TAG indice1 OF cabenotc.cdx DESCENDING

IF SEEK(STR(m.tiponota, 1))
   NextCode = cabenotc.nronota + 1
ELSE
   NextCode = 1
ENDIF

SET ORDER TO TAG indice1 OF cabenotc.cdx ASCENDING

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

RETURN (NextCode)

*!*********************************************************************
*!
*!      Funci¢n: _vldFechaNota
*!
*!  Llamado por: MKNOTA_C.PRG                
*!
*!  Descripci¢n: Validaci¢n del campo fecha de documento.
*!
*!*********************************************************************
FUNCTION _vldFechaNota
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

PRIVATE pnDia, pnMes, pnAnyo

IF m.fechanota = "00/00/0000" .OR. m.fechanota = "  /  /    "
   WAIT WINDOW "­ FECHA INVALIDA !"
   RETURN .F.
ELSE
   STORE VAL(SUBSTR(m.fechanota,1,2)) TO pnDia
   STORE VAL(SUBSTR(m.fechanota,4,2)) TO pnMes

   IF VAL(SUBSTR(m.fechanota,7,4)) < 1000
      pnAnyo = YEAR(DATE())
   ELSE
      pnAnyo = VAL(SUBSTR(m.fechanota,7,4))
   ENDIF

   m.fechanota = IIF(pnDia > 0 .AND. pnDia < 10, "0"+STR(pnDia,1), STR(pnDia,2)) +  "/"+ IIF(pnMes > 0 .AND. pnMes < 10, "0"+STR(pnMes,1), STR(pnMes,2)) + "/"+ STR(pnAnyo,4)

   IF pnDia  < 1    .OR. pnDia  > 31 .OR.;
      pnMes  < 1    .OR. pnMes  > 12 .OR.;
      pnAnyo < 1900 .OR. pnAnyo > 2500
      WAIT WINDOW "­ FECHA INVALIDA !"
      RETURN .F.
   ELSE
      DO CASE
         CASE INLIST(pnMes, 1, 3, 5, 7, 8, 10, 12)
            IF pnDia <= 31
               RETURN .T.
            ELSE
               WAIT WINDOW "­ FECHA INVALIDA !"
               RETURN .F.
            ENDIF 
         CASE pnMes = 2
            IF MOD(pnAnyo,4) # 0
               IF pnDia <= 28
                  RETURN .T.
               ELSE
                  WAIT WINDOW "­ FECHA INVALIDA !"
                  RETURN .F.
               ENDIF
            ELSE
               IF MOD(pnAnyo,100) = 0 .AND. MOD(pnAnyo,400) # 0
                  IF pnDia <= 28
                     RETURN .T.
                  ENDIF
               ELSE
                  IF pnDia <= 29
                     RETURN .T.
                  ELSE
                     WAIT WINDOW "­ FECHA INVALIDA !"
                     RETURN .F.
                  ENDIF
               ENDIF 
            ENDIF
         CASE INLIST(pnMes, 4, 6, 9, 11)
            IF pnDia <= 30
               RETURN .T.
            ELSE
               WAIT WINDOW "­ FECHA INVALIDA !"
               RETURN .F.
            ENDIF
            RETURN .T.
      ENDCASE
   ENDIF
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldTipoDocu
*!
*!  Llamado por: MKNOTA_C.PRG    
*!
*!  Descripci¢n: Validaci¢n del campo tipo de documento.
*!
*!*********************************************************************
FUNCTION _vldTipoDocu
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

IF m.tipodocu > 8 
   @ 03,17 SAY REPLICATE(CHR(32), 21) ;
      SIZE 1,23 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ EL TIPO DE DOCUMENTO DE VENTA DEBE SER: 1, 2, 3 à 4 !"
   RETURN .F.
ENDIF   

IF m.tipodocu <= 0
   @ 03,17 SAY REPLICATE(CHR(32), 21) ;
      SIZE 1,23 ;
      PICTURE "@!" ;
      COLOR W/N
   DO vttipodo.spr WITH "m.tipodocu", 0, .F.
ENDIF

IF m.tipodocu = 0
   RETURN .F.
ENDIF

DO CASE
   CASE m.tipodocu = 1
      @ 03,17 SAY "VENTA CONTADO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 2
      @ 03,17 SAY "VENTA CREDITO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 3
      @ 03,17 SAY "VENTA I.V.A. INCLUIDO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 4
      @ 03,17 SAY "VENTA TRIBUTO UNICO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 7
      @ 03,17 SAY "CONTADO IVA INCLUIDO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 8
      @ 03,17 SAY "CREDITO IVA INCLUIDO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   OTHERWISE
      @ 03,17 SAY REPLICATE(CHR(32), 21) ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
ENDCASE

*!*********************************************************************
*!
*!      Funci¢n: _vldNroDocu
*!
*!  Llamado por: MKCUOTA_C.PRG              
*!
*!  Descripci¢n: Validaci¢n del campo n£mero de documento.    
*!
*!*********************************************************************
FUNCTION _vldNroDocu
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

IF m.nrodocu <= 0

   m.fechadocu = {}
   m.cliente   = 0

   @ 03,69 SAY m.fechadocu ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W

   @ 04,14 SAY m.cliente  ;
      SIZE 1,5 ;
      PICTURE "99999" ;
      COLOR N/W

   @ 04,21 SAY REPLICATE(CHR(32), 56) ;
      SIZE 1,56 ;
      PICTURE "@!" ;
      COLOR W/N

   WAIT WINDOW "­ EL N§ DEL DOCUMENTO DE VENTA DEBE SER MAYOR QUE CERO !"
   RETURN .F.
ENDIF

SELECT cabevent
SET ORDER TO TAG indice1 OF cabevent.cdx

IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7))
   *-- Imprime la fecha del documento de venta.
   
   m.fechadocu = cabevent.fechadocu
   m.cliente   = cabevent.cliente

   @ 03,69 SAY m.fechadocu ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W

   @ 04,14 SAY m.cliente  ;
      SIZE 1,5 ;
      PICTURE "99999" ;
      COLOR N/W

   *-- Imprime el nombre del cliente.
   SELECT clientes
   SET ORDER TO TAG indice1 OF clientes.cdx

   IF SEEK(m.cliente)
      @ 04,21 SAY PADR(ALLTRIM(clientes.nombre), 56, CHR(32)) ;
         SIZE 1,56 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 04,21 SAY REPLICATE(CHR(32), 56) ;
         SIZE 1,56 ;
         PICTURE "@!" ;
         COLOR W/N
   ENDIF
ELSE
   SELECT (pnSelect)
   SET ORDER TO TAG (pcOrder)
   IF pnRecNo <> 0
      GOTO RECORD pnRecNo
   ENDIF

   m.fechadocu = {}
   m.cliente   = 0

   @ 03,69 SAY m.fechadocu ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W

   @ 04,14 SAY m.cliente  ;
      SIZE 1,5 ;
      PICTURE "99999" ;
      COLOR N/W

   @ 04,21 SAY REPLICATE(CHR(32), 56) ;
      SIZE 1,56 ;
      PICTURE "@!" ;
      COLOR W/N

   WAIT WINDOW "­ EL DOCUMENTO DE VENTA INGRESADO NO EXISTE !"

   RETURN .F.
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

DO _LoadMaestemp 

IF INLIST(m.tipodocu, 1, 3, 4, 7)
   m.aplicontra = 1
ELSE
   IF INLIST(m.tipodocu, 2, 6, 8)
      IF ((cabevent.monto_fact + cabevent.monto_ndeb) - (cabevent.monto_cobr + cabevent.monto_ncre)) > 0 .AND. ;
         ((cabevent.monto_fact + cabevent.monto_ndeb) - (cabevent.monto_cobr + cabevent.monto_ncre)) >= m.monto_nota
         m.aplicontra = 2
      ELSE
         m.aplicontra = 1
      ENDIF
   ENDIF
ENDIF

*-- Imprime el nombre de aplicado contra.
IF m.aplicontra = 1
   @ 05,69 SAY PADR(ALLTRIM("CAJA"), 10, CHR(32)) ;
      SIZE 1,10 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   IF m.aplicontra = 2
      @ 05,69 SAY PADR(ALLTRIM("CTA. CTE."), 10, CHR(32)) ;
         SIZE 1,10 ;
         PICTURE "@!" ;
         COLOR W/N
   ENDIF
ENDIF

SHOW GETS

*!*********************************************************************
*!
*!      Funci¢n: _vldMotivoNota
*!
*!  Llamado por: MKNOTA_C.PRG               
*!
*!  Descripci¢n: Validaci¢n del campo motivo de la nota.
*!
*!*********************************************************************
FUNCTION _vldMotivoNota
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

IF m.motivonota <= 0
   @ 05,19 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
   DO mono_pop.spr WITH "m.motivonota", 0, .F.
ENDIF

IF m.motivonota = 0
   RETURN .F.
ENDIF

DO SaveWorkArea

SELECT motivono
SET ORDER TO TAG indice1 OF motivono.cdx

IF SEEK(m.motivonota)
   IF motivono.vigente
      @ 05,19 SAY PADR(ALLTRIM(motivono.nombre), 30, CHR(32)) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 05,19 SAY REPLICATE(CHR(32), 30) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR W/N
      WAIT WINDOW "­ CODIGO DE MOTIVO DE LA NOTA NO VIGENTE !"
      DO RestoreWorkArea
      RETURN .F.
   ENDIF
ELSE
   @ 05,19 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE MOTIVO DE LA NOTA INEXISTENTE !"
   DO mono_pop.spr WITH "m.motivonota", 0, .F.
   SHOW GET m.motivonota

   SELECT motivono
   SET ORDER TO TAG indice1 OF motivono.cdx
 
   IF SEEK(m.motivonota)
      IF motivno.vigente
         @ 05,19 SAY PADR(ALLTRIM(monedas.nombre), 30, CHR(32)) ;
            SIZE 1,30 ;
            PICTURE "@!" ;
            COLOR W/N
      ELSE
         @ 05,19 SAY REPLICATE(CHR(32), 30) ;
            SIZE 1,30 ;
            PICTURE "@!" ;
            COLOR W/N
         WAIT WINDOW "­ CODIGO DE MOTIVO DE LA NOTA NO VIGENTE !"
         DO RestoreWorkArea
         RETURN .F.
      ENDIF
   ELSE
      @ 05,19 SAY REPLICATE(CHR(32), 28) ;
         SIZE 1,28 ;
         PICTURE "@!" ;
         COLOR W/N
      DO RestoreWorkArea
      RETURN .F.
   ENDIF
ENDIF

DO RestoreWorkArea

IF plAdding .OR. plEditing
   SHOW GETS
   DO _brwLoadDetail

   DO WHILE .T.
      WAIT WINDOW "[ENTER] CONFIRMA, [PGDN] IR A LA CABECERA o [PGUP] IR AL DETALLE"
      IF INLIST(LASTKEY(), K_ENTER, K_PGDN, K_PGUP)
         EXIT DO
      ENDIF
   ENDDO

   DO CASE
      CASE LASTKEY() = K_ENTER
         IF m.aplicontra = 1
            DO _SaveInvoice
            CLEAR READ
            IF INLIST(cabenotc.tiponota, 1, 3)
               WAIT WINDOW "­ LA NOTA DE DEBITO FUE GRABADA !" TIMEOUT 0.75
            ELSE
               IF INLIST(cabenotc.tiponota, 2, 4)
                  WAIT WINDOW "­ LA NOTA DE CREDITO FUE GRABADA !" TIMEOUT 0.75
               ENDIF
            ENDIF
         ELSE
            IF m.aplicontra = 2     
               DO WHILE .T.
                  DO _brwQuota
         
                  SELECT tmpcuonota
                  PRIVATE pnTotalNota
                  pnTotalNota = 0
         
                  GO TOP
                  SCAN ALL
                     IF INLIST(m.tiponota, 1, 3)
                        pnTotalNota = pnTotalNota + (tmpcuonota.monto_ndeb - tmpcuonota.monto)
                     ELSE
                        IF INLIST(m.tiponota, 2, 4)
                           pnTotalNota = pnTotalNota + (tmpcuonota.monto_ncre - tmpcuonota.monto)
                        ENDIF
                     ENDIF
                  ENDSCAN
          
                  IF pnTotalNota > m.monto_nota
                     IF INLIST(m.tiponota, 1, 3)
                        WAIT WINDOW "­ LAS IMPUTACIONES SUPERAN EL VALOR DE LA NOTA DE DEBITO !"
                     ENDIF

                     IF INLIST(m.tiponota, 2, 4)
                        WAIT WINDOW "­ LAS IMPUTACIONES SUPERAN EL VALOR DE LA NOTA DE CREDITO !"
                     ENDIF
                  ENDIF
         
                  IF pnTotalNota < m.monto_nota
                     IF INLIST(m.tiponota, 1, 3)
                        WAIT WINDOW "LA(S) IMPUTACION(ES) ES(SON) MENOR(ES) AL VALOR DE LA NOTA DE DEBITO !"
                     ENDIF
   
                     IF INLIST(m.tiponota, 2, 4)
                        WAIT WINDOW "LA(S) IMPUTACION(ES) ES(SON) MENOR(ES) AL VALOR DE LA NOTA DE CREDITO !"
                     ENDIF
                  ENDIF

                  IF pnTotalNota = m.monto_nota
                     DO _SaveInvoice
                     CLEAR READ
                     IF INLIST(cabenotc.tiponota, 1, 3)
                        WAIT WINDOW "­ LA NOTA DE DEBITO FUE GRABADA !" TIMEOUT 0.75
                     ELSE
                        IF INLIST(cabenotc.tiponota, 2, 4)
                           WAIT WINDOW "­ LA NOTA DE CREDITO FUE GRABADA !" TIMEOUT 0.75
                        ENDIF
                     ENDIF
                     EXIT DO
                  ENDIF
 
               ENDDO
            ENDIF
         ENDIF
      CASE LASTKEY() = K_PGUP
         _CUROBJ = OBJNUM(m.motivonota)
      	  KEYBOARD "{DNARROW}"
      CASE LASTKEY() = K_PGDN
         IF plAdding 
            _CUROBJ = OBJNUM(m.tiponota)
         ELSE
            IF plEditing
               _CUROBJ = OBJNUM(m.fechanota)
            ENDIF
         ENDIF
   ENDCASE   
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldApliContra
*!
*!  Llamado por: MKNOTA_C.PRG               
*!
*!  Descripci¢n: Validaci¢n del campo aplicado contra.  
*!
*!*********************************************************************
FUNCTION _vldApliContra
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

IF EMPTY(m.aplicontra)
   @ 05,69 SAY REPLICATE(CHR(32), 10) ;
      SIZE 1,10 ;
      PICTURE "@!" ;
      COLOR W/N
   DO aplicont.spr WITH "m.aplicontra", "", .F.
   IF EMPTY(m.aplicontra)
      RETURN .F.
   ENDIF
ENDIF

*-- Imprime el nombre de aplicado contra.
IF m.aplicontra = 1
   @ 05,69 SAY PADR(ALLTRIM("CAJA"), 10, CHR(32)) ;
      SIZE 1,10 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   IF m.aplicontra = 2
      @ 05,69 SAY PADR(ALLTRIM("CTA. CTE."), 10, CHR(32)) ;
         SIZE 1,10 ;
         PICTURE "@!" ;
         COLOR W/N
         
      IF INLIST(m.tiponota, 2, 4) .AND. INLIST(m.tipodocu, 2, 6, 8)
         IF ((cabevent.monto_fact + cabevent.monto_ndeb) - (cabevent.monto_cobr + cabevent.monto_ncre)) <= 0
            SHOW GETS
            WAIT WINDOW "­ LA VENTA INGRESADA TIENE SALDO CERO !"
            RETURN .F.
         ENDIF
      ENDIF
   ELSE
      @ 05,69 SAY REPLICATE(CHR(32), 09) ;
         SIZE 1,09 ;
         PICTURE "@!" ;
         COLOR W/N
      WAIT WINDOW "­ APLICADO CONTRA DEBE SER: (1) CAJA o (2) CTA. CTE. !"
      RETURN .F.
   ENDIF
ENDIF

SHOW GETS

DO _brwLoadDetail

DO WHILE .T.
   WAIT WINDOW "[ENTER] CONFIRMA, [PGDN] IR A LA CABECERA o [PGUP] IR AL DETALLE"
   IF INLIST(LASTKEY(), K_ENTER, K_PGDN, K_PGUP)
      EXIT DO
   ENDIF
ENDDO

DO CASE
   CASE LASTKEY() = K_ENTER
      IF m.aplicontra = 1
         DO _SaveInvoice
         CLEAR READ
         IF INLIST(cabenotc.tiponota, 1, 3)
            WAIT WINDOW "­ LA NOTA DE DEBITO FUE GRABADA !" TIMEOUT 0.75
         ELSE
            IF INLIST(cabenotc.tiponota, 2, 4)
               WAIT WINDOW "­ LA NOTA DE CREDITO FUE GRABADA !" TIMEOUT 0.75
            ENDIF
         ENDIF
      ELSE
         IF m.aplicontra = 2     
            DO WHILE .T.
               DO _brwQuota
         
               SELECT tmpcuonota
               PRIVATE pnTotalNota
               pnTotalNota = 0
         
               GO TOP
               SCAN ALL
                  IF INLIST(m.tiponota, 1, 3)
                     pnTotalNota = pnTotalNota + (tmpcuonota.monto_ndeb - tmpcuonota.monto)
                  ELSE
                     IF INLIST(m.tiponota, 2, 4)
                        pnTotalNota = pnTotalNota + (tmpcuonota.monto_ncre - tmpcuonota.monto)
                     ENDIF
                  ENDIF
               ENDSCAN
          
               IF pnTotalNota > m.monto_nota
                  IF INLIST(m.tiponota, 1, 3)
                     WAIT WINDOW "­ LAS IMPUTACIONES SUPERAN EL VALOR DE LA NOTA DE DEBITO !"
                  ENDIF

                  IF INLIST(m.tiponota, 2, 4)
                     WAIT WINDOW "­ LAS IMPUTACIONES SUPERAN EL VALOR DE LA NOTA DE CREDITO !"
                  ENDIF
               ENDIF
         
               IF pnTotalNota < m.monto_nota
                  IF INLIST(m.tiponota, 1, 3)
                     WAIT WINDOW "LA(S) IMPUTACION(ES) ES(SON) MENOR(ES) AL VALOR DE LA NOTA DE DEBITO !"
                  ENDIF

                  IF INLIST(m.tiponota, 2, 4)
                     WAIT WINDOW "LA(S) IMPUTACION(ES) ES(SON) MENOR(ES) AL VALOR DE LA NOTA DE CREDITO !"
                  ENDIF
               ENDIF

               IF pnTotalNota = m.monto_nota
                  DO _SaveInvoice
                  CLEAR READ
                  IF INLIST(cabenotc.tiponota, 1, 3)
                     WAIT WINDOW "­ LA NOTA DE DEBITO FUE GRABADA !" TIMEOUT 0.75
                  ELSE
                     IF INLIST(cabenotc.tiponota, 2, 4)
                        WAIT WINDOW "­ LA NOTA DE CREDITO FUE GRABADA !" TIMEOUT 0.75
                     ENDIF
                  ENDIF
                  EXIT DO
               ENDIF

            ENDDO
         ENDIF
      ENDIF
   CASE LASTKEY() = K_PGUP
      _CUROBJ = OBJNUM(m.aplicontra)
   	  KEYBOARD "{DNARROW}"
   CASE LASTKEY() = K_PGDN
      IF plAdding 
         _CUROBJ = OBJNUM(m.tiponota)
      ELSE
         IF plEditing
            _CUROBJ = OBJNUM(m.fechanota)
         ENDIF
      ENDIF
ENDCASE   

**-------------------------------------------------------------------**
**                              DETALLE                              **
**-------------------------------------------------------------------**

*!*********************************************************************
*!
*!      Funci¢n: _brwLoadDetail
*!
*!  Llamado por: _vldApliContra
*!
*!  Descripci¢n: Abre una ventana de inspecci¢n para la cargar el deta-
*!               lle del comprobante de venta.
*!
*!*********************************************************************
FUNCTION _brwLoadDetail

DO SaveWorkArea

SELECT tmpdetnota
SET ORDER TO 0

IF RECCOUNT() = 0
   INSERT INTO tmpdetnota (tiponota, nronota, tipo, articulo, cantidad, precio, impuesto, pimpuesto, serie) ;
      VALUES (0, 0, "", "", 0, 0, .F., 0, "")
ENDIF

ON KEY LABEL "F8" DO _DeleteLine

DO WHILE LASTKEY() <> 27
   @ 20,12 CLEAR TO 22,41
   
   @ 09,01 CLEAR TO 18,01     && Tipo.
   @ 09,03 CLEAR TO 18,42     && Descripci¢n.
   @ 09,44 CLEAR TO 18,53     && Cantidad.
   @ 09,55 CLEAR TO 18,67     && Precio Unit.
   @ 09,69 CLEAR TO 18,78     && Importe.

   GO BOTTOM
   BROWSE WINDOW tmpdetnota FIELDS ;
      tipo                                       :01:H = ""             :P = "@A!"                :V = _vldTipo():F ,;
      articulo                                   :13:H = "C¢digo"                                 :V = _vldCodigo():F ,;
      calc_f1 = SUBSTR(maesprod.nombre, 1, 35) :R:35:H = "Descripci¢n"  :W = .F. ,;
      cantidad                                   :08:H = "Cantidad"     :P = "99999.99"           :W = (tipo = "S") :V = _vldCantidad():F ,;
      precio                                     :15:H = "Precio Unit." :P = "@K 99,999,999.9999"   :W = (tipo = "P") :V = _vldPrecio():F  ,;
      calc_f2 = ROUND(precio * cantidad, 0)      :11:H = " Sub-Total"   :P = "999,999,999" :W = _whenSubTotal(articulo) :V = _vldAddNewLine() :F ;
      NODELETE NOAPPEND 
ENDDO

ON KEY LABEL "F8"

DO RestoreWorkArea
DO _PrintDetail
DO _InvoiceFoot


*!*********************************************************************
*!
*!      Funci¢n: _vldTipo    
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Validaci¢n del campo tipo de detalle.
*!
*!*********************************************************************
FUNCTION _vldTipo

IF INLIST(LASTKEY(), 19, 127)
   RETURN .F.
ENDIF

IF NOT INLIST(tipo, "P", "S")
   WAIT WINDOW "­ EL TIPO DEBE SER: DIFERENCIA DE (S)TOCK o (P)RECIO !"
   RETURN .F.
ENDIF

IF tipo = "P"
   REPLACE cantidad WITH 1
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldCodigo     
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Validaci¢n   del   campo   c¢digo  en  el detalle  del   
*!               comprobante de venta.
*!
*!*********************************************************************
FUNCTION _vldCodigo
IF INLIST(LASTKEY(), 19, 127)
   RETURN 
ENDIF

IF INLIST(LASTKEY(), K_DOWN, K_F8)
   RETURN 
ENDIF  

IF EMPTY(articulo)
   PUSH KEY CLEAR

   *-- Procedimiento de inspecci¢n de art¡culos.
   ON KEY LABEL "ENTER" KEYBOARD "{CTRL+W}"
   DO _brwMaesTemp
   ON KEY LABEL "ENTER" 

   POP KEY

   IF LASTKEY() <> K_ESCAPE
      REPLACE tmpdetnota.articulo WITH maestemp.codigo
   ELSE 
      RETURN .F.
   ENDIF
ENDIF

SELECT maestemp
SET ORDER TO TAG indice1 

IF NOT SEEK(tmpdetnota.articulo)
   WAIT WINDOW "­ CODIGO DE ARTICULO INEXISTENTE !"
   RETURN .F.
ENDIF

REPLACE tmpdetnota.articulo  WITH maestemp.codigo
REPLACE tmpdetnota.impuesto  WITH maestemp.impuesto
REPLACE tmpdetnota.pimpuesto WITH maestemp.pimpuesto
REPLACE tmpdetnota.precio    WITH maestemp.pventag1

SELECT tmpdetnota

*!*********************************************************************
*!
*!      Funci¢n: _vldCantidad   
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Validaci¢n   del   campo cantidad  en  el detalle  del   
*!               comprobante de la nota.
*!
*!*********************************************************************
FUNCTION _vldCantidad
  
IF cantidad <= 0
   WAIT WINDOW "­ LA CANTIDAD DEBE SER MAYOR QUE CERO !"
   IF INLIST(LASTKEY(), 5, 19, 127)
      RETURN 
   ELSE
      RETURN .F.
   ENDIF
ENDIF 

IF pimpuesto < 0 .OR. pimpuesto > control.pimpuesto
   WAIT WINDOW "­ PORCENTAJE DE IMPUESTO INVALIDO !"
   RETURN .F.
ENDIF

PRIVATE pnRecNo, pcCodigo, pnCantidad

pcCodigo   = tmpdetnota.articulo
pnRecNo    = IIF(EOF(), 0, RECNO())
pnCantidad = 0

GO TOP
SCAN ALL
   IF articulo = pcCodigo
      pnCantidad = pnCantidad + cantidad
   ENDIF
ENDSCAN

IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

IF maestemp.cantidad - pnCantidad < 0
   WAIT WINDOW "­ LA CANTIDAD INGRESADA SOBREPASA AL SALDO DE LA VENTA !"
   RETURN .F.
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldPrecio   
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Validaci¢n del campo precio unitario en el detalle del   
*!               comprobante de venta.
*!
*!*********************************************************************
FUNCTION _vldPrecio
IF INLIST(LASTKEY(), 19, 127)
   RETURN 
ENDIF

IF precio <= 0
   WAIT WINDOW "­ EL PRECIO DEBE SER MAYOR QUE CERO !"
   RETURN .F.
ENDIF         

*!*********************************************************************
*!
*!      Funci¢n: _vldAddNewLine
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Agrega una nueva linea  al  detalle  del  comprobante, 
*!               siempre y cuando al £ltima tecla presionada sea ENTER.
*!
*!*********************************************************************
FUNCTION _vldAddNewLine 
IF LASTKEY() = 13  
   IF RECNO() = RECCOUNT()
      KEYBOARD "{CTRL+W}"      
      INSERT INTO tmpdetnota (tiponota, nronota, tipo, articulo, cantidad, precio, impuesto, pimpuesto, serie) ;
         VALUES (0, 0, "", "", 0, 0, .F., 0, "")
   ENDIF
ENDIF
DO _InvoiceFoot   

*!*********************************************************************
*!
*!      Funci¢n: _DeleteLine  
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Borra una l¡nea de detalle del comprobante de venta.
*!
*!*********************************************************************
FUNCTION _DeleteLine

PRIVATE pnSelect, pcOrder
pnSelect = SELECT()
pcOrder  = ORDER()

SELECT tmpdetnota
DELETE 
PACK

IF RECCOUNT() = 0
   INSERT INTO tmpdetnota (tiponota, nronota, tipo, articulo, cantidad, precio, impuesto, pimpuesto, serie) ;
      VALUES (0, 0, "", "", 0, 0, .F., 0, "")
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)

DO _InvoiceFoot

*!*********************************************************************
*!
*!      Funci¢n: _PrintDetail
*!
*!  Llamado por: _ShowDetail                 
*!
*!  Descripci¢n: Imprime  el  detalle  de  art¡culos del comprobante de         
*!               venta.
*!
*!*********************************************************************
FUNCTION _PrintDetail

DO SaveWorkArea

#DEFINE pnRow    8
#DEFINE pnColumn 1

SELECT tmpdetnota
GO TOP

SCAN WHILE RECNO() <= 9 .AND. .NOT. (EMPTY(articulo) .OR. EMPTY(cantidad) .OR. EMPTY(precio))
   @ pnRow + RECNO(), pnColumn      SAY SUBSTR(maesprod.nombre, 1, 39)                           COLOR N/W
   @ pnRow + RECNO(), pnColumn + 40 SAY cantidad                       PICTURE "999,999.99"      COLOR N/W
   @ pnRow + RECNO(), pnColumn + 51 SAY precio                         PICTURE "99,999,999.9999" COLOR N/W
   @ pnRow + RECNO(), pnColumn + 67 SAY ROUND(precio * cantidad, 0)    PICTURE "99,999,999"      COLOR N/W
ENDSCAN

DO RestoreWorkArea

*!*********************************************************************
*!
*!      Funci¢n: _whenPrecioUnit
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: When del campo precio unitario.            
*!
*!*********************************************************************
FUNCTION _whenPrecioUnit
PARAMETER pcArticulo

DO SaveWorkArea

SELECT servicio
SET ORDER TO indice1 OF servicio.cdx

IF SEEK(pcArticulo)
   RETURN 
ELSE
   RETURN .F.
ENDIF

DO RestoreWorkArea

*!*********************************************************************
*!
*!      Funci¢n: _whenSubTotal
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: When del campo sub-total.            
*!
*!*********************************************************************
FUNCTION _whenSubTotal
PARAMETER pcArticulo

DO SaveWorkArea

SELECT servicio
SET ORDER TO indice1 OF servicio.cdx

IF SEEK(pcArticulo)
   RETURN .F.
ELSE
   RETURN 
ENDIF

DO RestoreWorkArea

**-------------------------------------------------------------------**
**                                PIE                                **
**-------------------------------------------------------------------**

*!*********************************************************************
*!
*!      Funci¢n: _InvoiceFoot   
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Calcula e imprime el pie del comprobante de venta.
*!
*!*********************************************************************
FUNCTION _InvoiceFoot

DO SaveWorkArea

SELECT tmpdetnota
GO TOP

STORE 0 TO m.monto_nota, pnGravada, pnExenta, pnImpuesto, pnSubTotal

SCAN ALL
   DO CASE
      CASE impuesto .AND. pimpuesto > 0 .AND. pimpuesto < 10
         pnGravada = pnGravada + ROUND(precio * cantidad, 0) * (pimpuesto * (control.pimpuesto / 100))
         pnExenta  = pnExenta  + ROUND(precio * cantidad, 0) * (1 - (pimpuesto * (control.pimpuesto / 100)))
      CASE impuesto .AND. pimpuesto = control.pimpuesto
         pnGravada = pnGravada + ROUND(precio * cantidad, 0)            
      CASE .NOT. impuesto .AND. pimpuesto = 0
         pnExenta  = pnExenta  + ROUND(precio * cantidad, 0)
   ENDCASE
ENDSCAN

pnSubTotal   = pnGravada + pnExenta
pnImpuesto   = ROUND(pnGravada * (control.pimpuesto / 100), 0)
m.monto_nota = pnSubTotal + pnImpuesto

@ 20,68 SAY pnSubTotal ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

@ 21,68 SAY pnImpuesto ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

@ 22,68 SAY m.monto_nota ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

DO RestoreWorkArea

*!*********************************************************************
*!
*!      Funci¢n: _RefreshInvoice
*!
*!  Llamado por: VENTAS.PRG                  
*!
*!  Descripci¢n: Actualiza  la  visualizaci¢n  del  formato,  cabecera, 
*!               detalle, pie y cuota de la factura.
*!
*!*********************************************************************
FUNCTION _RefreshInvoice

DO _ShowHeader
DO _ShowDetail
DO _InvoiceFoot

IF cabevent.anulado
   WAIT WINDOW "­ FACTURA ANULADA !" NOWAIT
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _ShowHeader
*!
*!  Llamado por: _RefreshInvoice
*!
*!  Descripci¢n: Visualiza el encabezado de la venta.
*!
*!*********************************************************************
FUNCTION _ShowHeader 

SELECT cabenotc
SCATTER MEMVAR

@ 02,14 SAY m.tiponota ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W

*-- Imprime la etiqueta del tipo de documento.
DO CASE
   CASE m.tiponota = 1
      @ 02,17 SAY "NOTA DE DEBITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tiponota = 2
      @ 02,17 SAY "NOTA DE CREDITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tiponota = 3
      @ 02,17 SAY "C.I. NOTA DE DEBITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tiponota = 4
      @ 02,17 SAY "C.I. NOTA DE CREDITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   OTHERWISE
      @ 02,17 SAY REPLICATE(CHR(32), 21) ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
ENDCASE

@ 02,44 SAY m.nronota ;
   SIZE 1,7 ;
   PICTURE "9999999" ;
   COLOR N/W

m.fechanota = DTOC(m.fechanota)

@ 02,69 SAY m.fechanota ;
   SIZE 1,10 ;
   PICTURE "99/99/9999" ;
   COLOR N/W

@ 03,14 SAY m.tipodocu ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W

*-- Imprime la etiqueta del tipo de documento.
DO CASE
   CASE m.tipodocu = 1
      @ 03,17 SAY "VENTA CONTADO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 2
      @ 03,17 SAY "VENTA CREDITO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 3
      @ 03,17 SAY "VENTA I.V.A. INCLUIDO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 4
      @ 03,17 SAY "VENTA TRIBUTO UNICO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 7
      @ 03,17 SAY "CONTADO IVA INCLUIDO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 8
      @ 03,17 SAY "CREDITO IVA INCLUIDO" ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N

   OTHERWISE
      @ 03,17 SAY REPLICATE(CHR(32), 21) ;
         SIZE 1,23 ;
         PICTURE "@!" ;
         COLOR W/N
ENDCASE

@ 03,44 SAY m.nrodocu ;
   SIZE 1,7 ;
   PICTURE "9999999" ;
   COLOR N/W

*-- Imprime la fecha del documento de venta.
SELECT cabevent
SET ORDER TO TAG indice1 OF cabevent.cdx


IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7))
   m.fechadocu = cabevent.fechadocu
   m.cliente   = cabevent.cliente

   @ 03,69 SAY m.fechadocu ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W
ELSE
   @ 03,69 SAY {} ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W
ENDIF

SELECT cabenotc

@ 04,14 SAY m.cliente  ;
   SIZE 1,5 ;
   PICTURE "99999" ;
   COLOR N/W

*-- Imprime el nombre del cliente selecionado.
SELECT clientes
SET ORDER TO TAG indice1 OF clientes.cdx

IF SEEK(m.cliente)
   @ 04,21 SAY PADR(ALLTRIM(clientes.nombre), 56, CHR(32)) ;
      SIZE 1,56 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 04,21 SAY REPLICATE(CHR(32), 56) ;
      SIZE 1,56 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

SELECT cabenotc

@ 05,14 SAY m.motivonota ;
   SIZE 1,3 ;
   PICTURE "999" ;
   COLOR N/W
   
*-- Imprime el nombre del motivo de la nota.
SELECT motivono
SET ORDER TO TAG indice1 OF motivono.cdx

IF SEEK(m.motivonota)
   @ 05,19 SAY PADR(ALLTRIM(motivono.nombre), 30, CHR(32)) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 05,19 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

SELECT cabenotc
   
@ 05,67 SAY m.aplicontra ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W
   
*-- Imprime el nombre de aplicado contra.
IF m.aplicontra = 1
   @ 05,69 SAY PADR(ALLTRIM("CAJA"), 10, CHR(32)) ;
      SIZE 1,10 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   IF m.aplicontra = 2
      @ 05,69 SAY PADR(ALLTRIM("CTA. CTE."), 10, CHR(32)) ;
         SIZE 1,10 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 05,69 SAY REPLICATE(CHR(32), 10) ;
         SIZE 1,10 ;
         PICTURE "@!" ;
         COLOR W/N
   ENDIF
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _PrintDetail
*!
*!  Llamado por: _ShowDetail                 
*!
*!  Descripci¢n: Imprime el detalle de art¡culos del documento.             
*!
*!*********************************************************************
FUNCTION _PrintDetail

DO SaveWorkArea

#DEFINE pnRow    8
#DEFINE pnColumn 1

SELECT tmpdetnota
GO TOP

SCAN WHILE RECNO() <= 10 .AND. .NOT. (EMPTY(articulo) .OR. EMPTY(cantidad) .OR. EMPTY(precio))
   @ pnRow + RECNO(), pnColumn      SAY tipo                                                   COLOR N/W
   @ pnRow + RECNO(), pnColumn + 2  SAY SUBSTR(maesprod.nombre, 1, 40)                         COLOR N/W
   @ pnRow + RECNO(), pnColumn + 43 SAY cantidad                       PICTURE "999,999.99"    COLOR N/W
   @ pnRow + RECNO(), pnColumn + 54 SAY precio                         PICTURE "99,999,999.99" COLOR N/W
   @ pnRow + RECNO(), pnColumn + 68 SAY ROUND(precio * cantidad, 0)    PICTURE "99,999,999"    COLOR N/W
ENDSCAN

DO RestoreWorkArea

*!*********************************************************************
*!
*!      Funci¢n: _brwMaesTemp
*!
*!  Llamado por: _ShowDetail                 
*!
*!  Descripci¢n: Imprime el detalle de art¡culos del documento.             
*!
*!*********************************************************************
FUNCTION _brwMaesTemp
*-- MS-DOS Definiciones de ventanas.
IF NOT WEXIST("brwMaesTemp")
   DEFINE WINDOW brwMaesTemp ;
      FROM 01,00 ;
      TO   23,79 ;
      TITLE "< ARTICULOS >" ;
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

SELECT maestemp
SET ORDER TO indice2
GO TOP
                
*-- MS-DOS Macros de teclado.
*ON KEY LABEL "F4" DO mporden.spr
*ON KEY LABEL "F5" DO mpswitch.prg
ON KEY LABEL "CTRL+HOME" GO TOP
ON KEY LABEL "CTRL+END"  GO BOTTOM
ON KEY LABEL "SPACEBAR"  WAIT WINDOW "STOCK ACTUAL: " + TRANSFORM(stock_actu, "9,999.99")

BROWSE WINDOW brwMaesTemp FIELDS ;
   calc_f1 = SUBSTR(codigo, 1, 15)                      :R:15:H = "C¢digo" ,;
   calc_f2 = SUBSTR(nombre, 1, 43)                      :R:43:H = "Nombre" ,;
   calc_f3 = IIF(impuesto, "S¡", "  ")                  :R:02:H = "",;
   pventag1                                             :R:13:H = "P.Vta 1 s/Iva":P = "99,999,999.99" ,;
   pventag2                                             :R:10:H = "P.Vta 2":P = "99,999,999" ,;
   calc_f5 = ROUND(pventag2 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 2 c/Iva":P = "9,999,999,999" ,;
   pventag3                                             :R:10:H = "P.Vta 3":P = "99,999,999" ,;
   calc_f6 = ROUND(pventag3 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 3 c/Iva":P = "9,999,999,999" ,;
   calc_f7 = IIF(impuesto, "   S¡   ", "")              :R:08:H = "Impuesto" ,;
   stock_actu                                           :R:13:H = "Stock Actual":P = "99,999,999.99" ,;  
   calc_f8  = SUBSTR(rubros1.nombre, 1, 30)             :R:30:H = "Rubro" ,;
   calc_f9  = SUBSTR(rubros2.nombre, 1, 30)             :R:30:H = "Sub-Rubro",;   
   calc_f10 = SUBSTR(marcas1.nombre, 1, 30)             :R:30:H = "Marcas",;      
   calc_f11 = SUBSTR(nombre, 1, 40)                     :R:40:H = "Nombre" ,;
   calc_f12 = SUBSTR(codigo2, 1, 15)                    :R:15:H = "C¢d.Alternativo" ,;
   calc_f13 = SUBSTR(codorig, 1, 15)                    :R:15:H = "C¢d. Origen" ;
   NOAPPEND NODELETE NOMODIFY

SET ORDER TO indice1 
   
*-- MS-DOS Restablece macros de teclado.
ON KEY LABEL "F4"
ON KEY LABEL "F5"
ON KEY LABEL "CTRL+HOME" 
ON KEY LABEL "CTRL+END"  
ON KEY LABEL "SPACEBAR" 

RELEASE WINDOW brwMaesTemp 

*!*********************************************************************
*!
*!      Funci¢n: _brwQuota      
*!
*!  Llamado por: VENTAS.PRG       
*!
*!  Descripci¢n: Examina las cuotas del documento.
*!
*!*********************************************************************
FUNCTION _brwQuota

ACTIVATE WINDOW tmpmarcuot 

SELECT tmpcuonota
GO TOP

*-- MS-DOS Macros de teclado.
ON KEY LABEL "F3" DO impnotac.spr

BROWSE WINDOW tmpformapl FIELDS ;
   calc_f1 = IIF(tipo = 1,"Entr",IIF(tipo = 2,"Cuot",""))     :R:04:H="Tipo" ,;
   nrocuota                                                    :R:03:H="N§"         :P="999",;
   fecha                                                       :R:10:H="Fecha Vcto" ,;
   importe                                                     :R:10:H="Importe"    :P="99,999,999" ,;
   calc_f2 = ((importe + monto_ndeb) - (monto_ncre + abonado)) :R:10:H="Saldo"      :P="99,999,999" ,;
   abonado                                                     :R:10:H="Abonado"    :P="99,999,999" ,;
   monto_ndeb                                                  :R:10:H="Monto Ndeb" :P="99,999,999" ,;
   monto_ncre                                                  :R:10:H="Monto Ncre" :P="99,999,999"  ;
   NOAPPEND NODELETE NOMODIFY

*-- MS-DOS Restablece macros de teclado.
ON KEY LABEL "F3"

DEACTIVATE WINDOW tmpmarcuot 

SELECT cabenotc

*!*********************************************************************
*!
*!      Funci¢n: _LoadQuota     
*!
*!  Llamado por: _RefreshInvoice
*!
*!  Descripci¢n: Carga las cuotas del documento.
*!
*!*********************************************************************
FUNCTION _LoadQuota

SELECT tmpcuonota     &&   Vac¡a la  tabla  temporal  que  contiene las
ZAP                   &&   cuotas del documento.

SELECT cuotas_v

IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7))
   SCAN WHILE STR(m.tipodocu, 1) + STR(m.nrodocu, 7) = STR(cuotas_v.tipodocu, 1) + STR(cuotas_v.nrodocu, 7)
      INSERT INTO tmpcuonota (tipodocu, nrodocu, tipo, nrocuota, fecha, importe, abonado, monto_ndeb, monto_ncre, monto) ;
         VALUES (cuotas_v.tipodocu, cuotas_v.nrodocu, cuotas_v.tipo, cuotas_v.nrocuota, cuotas_v.fecha, cuotas_v.importe, cuotas_v.abonado, cuotas_v.monto_ndeb, cuotas_v.monto_ncre, IIF(INLIST(m.tiponota, 1, 3), cuotas_v.monto_ndeb, IIF(INLIST(m.tiponota, 2, 4), cuotas_v.monto_ncre, 0)))
   ENDSCAN
ELSE
   IF .NOT. cabevent.anulado .AND. INLIST(cabevent.tipodocu, 2, 6, 8)
      WAIT WINDOW "     ­ ESTE DOCUMENTO NO POSEE CUOTAS !" + CHR(13) + ;
                 "MODIFIQUELO PARA VOLVER A GENERAR LAS CUOTAS"
   ENDIF
ENDIF

IF plEditing
   SELECT cuotas_n
   SET ORDER TO TAG indice1 OF cuotas_n.cdx

   IF SEEK("V" + STR(m.tiponota, 1) + STR(m.nronota, 7))
      SCAN WHILE ("V" + STR(m.tiponota, 1) + STR(m.nronota, 7)) = ("V" + STR(cuotas_n.tiponota, 1) + STR(cuotas_n.nronota, 7))
         SELECT tmpcuonota
         SET ORDER TO TAG indice1 
         
         IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7) + STR(cuotas_n.nrocuota, 3))
            IF INLIST(m.tiponota, 1, 3)
               REPLACE tmpcuonota.monto_ndeb WITH (tmpcuonota.monto_ndeb - cuotas_n.importe)
               REPLACE tmpcuonota.monto      WITH (tmpcuonota.monto - cuotas_n.importe)
            ELSE
               IF INLIST(m.tiponota, 2, 4)
                  REPLACE tmpcuonota.monto_ncre WITH (tmpcuonota.monto_ncre - cuotas_n.importe)
                  REPLACE tmpcuonota.monto      WITH (tmpcuonota.monto - cuotas_n.importe)
               ENDIF
            ENDIF
         ENDIF
         SELECT cuotas_n
      ENDSCAN
   ENDIF
ENDIF
         
SELECT cabenotc

*!*********************************************************************
*!
*!      Funci¢n: _SaveInvoice
*!
*!  Llamado por: MKNOTA_C.PRG                 
*!
*!  Descripci¢n: Graba la nota debito o credito - clientes.
*!
*!*********************************************************************
FUNCTION _SaveInvoice

PUSH KEY CLEAR

IF plEditing
   DO _DeleteInvoice
ENDIF

*-- Graba el encabezado de la nota de debito o credito.
SELECT cabenotc

INSERT INTO cabenotc (tiponota, nronota, tipodocu, nrodocu, fechanota, cliente, motivonota, aplicontra, fechaanu, anulado, monto_nota) ;
   VALUES (m.tiponota, m.nronota, m.tipodocu, m.nrodocu, CTOD(m.fechanota), m.cliente, m.motivonota, m.aplicontra, m.fechaanu, m.anulado, m.monto_nota)
   
IF INLIST(cabenotc.tipodocu, 2, 6, 8) .AND. cabenotc.aplicontra = 2
   SELECT cabevent
   SET ORDER TO TAG "indice1"
   SEEK STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7)

   SELECT clientes
   SET ORDER TO TAG indice1 OF clientes.cdx
         
   IF SEEK(cabenotc.cliente)
      IF INLIST(cabenotc.tiponota, 1, 3)
         IF cabevent.moneda = 1
            REPLACE clientes.saldo_actu WITH (clientes.saldo_actu + cabenotc.monto_nota)
         ELSE
            REPLACE clientes.saldo_usd  WITH (clientes.saldo_usd  + cabenotc.monto_nota)
         ENDIF
      ELSE
         IF INLIST(cabenotc.tiponota, 2, 4)
            IF cabevent.moneda = 1
               REPLACE clientes.saldo_actu WITH (clientes.saldo_actu - cabenotc.monto_nota)
            ELSE
               REPLACE clientes.saldo_usd  WITH (clientes.saldo_usd  - cabenotc.monto_nota)
            ENDIF
         ENDIF
      ENDIF
   ELSE
      IF .NOT. cabenotc.anulado .AND. cabenotc.tiponota <> 0 .AND. cabenotc.nronota <> 0
         WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DEL CLIENTE: " + ALLTRIM(STR(cabenotc.cliente, 5)) + " !"
      ENDIF
   ENDIF
ENDIF

SELECT cabevent
SET ORDER TO TAG indice1 OF cabevent.cdx

IF SEEK(STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7))
   IF INLIST(cabenotc.tiponota, 1, 3)
      REPLACE cabevent.monto_ndeb WITH (cabevent.monto_ndeb + cabenotc.monto_nota)
   ELSE
      IF INLIST(cabenotc.tiponota, 2, 4)
         REPLACE cabevent.monto_ncre WITH (cabevent.monto_ncre + cabenotc.monto_nota)
      ENDIF
   ENDIF
ELSE
   IF .NOT. cabenotc.anulado .AND. cabenotc.tiponota <> 0 .AND. cabenotc.nronota <> 0
      WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DEL CLIENTE: " + ALLTRIM(STR(cabenotc.cliente, 5)) + " !"
   ENDIF
ENDIF

*-- Graba el detalle de la nota de debito o credito y actualiza la existencia de mercaderias, si detanotc.tipo = "S".
SELECT tmpdetnota
GO TOP

SCAN ALL
   IF .NOT. (EMPTY(tmpdetnota.articulo) .OR. EMPTY(tmpdetnota.cantidad) .OR. EMPTY(tmpdetnota.precio))
      INSERT INTO detanotc (tiponota, nronota, tipo, articulo, cantidad, precio, impuesto, pimpuesto, serie) ;
         VALUES (cabenotc.tiponota, cabenotc.nronota, tmpdetnota.tipo, tmpdetnota.articulo, tmpdetnota.cantidad, tmpdetnota.precio, tmpdetnota.impuesto, tmpdetnota.pimpuesto, tmpdetnota.serie)
      IF detanotc.tipo = "S"
         SELECT maesprod
         SET ORDER TO TAG indice1 OF maesprod.cdx
         
         IF SEEK(detanotc.articulo)
            IF INLIST(cabenotc.tiponota, 1, 3)
               REPLACE maesprod.stock_actu WITH (maesprod.stock_actu - detanotc.cantidad)
            ELSE
               IF INLIST(cabenotc.tiponota, 2, 4)
                  REPLACE maesprod.stock_actu WITH (maesprod.stock_actu + detanotc.cantidad)
               ENDIF
            ENDIF
         ELSE
            WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL ARTICULO: " + ALLTRIM(detanotc.articulo) + " !"
         ENDIF
      ENDIF
      SELECT tmpdetnota
   ENDIF
ENDSCAN
   
*-- Graba la(s) cuota(s) de la nota de debito o credito.
SELECT tmpcuonota
GO TOP
   
IF RECCOUNT() > 0 .AND. INLIST(cabenotc.tipodocu, 2, 6, 8) .AND. cabenotc.aplicontra = 2
   SCAN ALL
      INSERT INTO cuotas_n (docinicial, tiponota, nronota, nrocuota, importe) ;
         VALUES ("V", cabenotc.tiponota, cabenotc.nronota, tmpcuonota.nrocuota, IIF(INLIST(cabenotc.tiponota, 1, 3), tmpcuonota.monto_ndeb - tmpcuonota.monto, IIF(INLIST(cabenotc.tiponota, 2, 4), tmpcuonota.monto_ncre - tmpcuonota.monto, 0)))
      SELECT cuotas_v
      SET ORDER TO TAG indice1 OF cuotas_v.cdx
         
      IF SEEK(STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7) + STR(cuotas_n.nrocuota, 3))
         IF INLIST(cabenotc.tiponota, 1, 3)
            REPLACE cuotas_v.monto_ndeb WITH (cuotas_v.monto_ndeb + cuotas_n.importe)
         ELSE
            IF INLIST(cabenotc.tiponota, 2, 4)
               REPLACE cuotas_v.monto_ncre WITH (cuotas_v.monto_ncre + cuotas_n.importe)
            ENDIF
         ENDIF
      ELSE
         WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR LA CUOTA N§: " + ALLTRIM(STR(cuotas_n.nrocuota, 3)) + " DE LA VENTA: " + ALLTRIM(STR(cabenotc.tipodocu, 1)) + "/" + ALLTRIM(STR(cabenotc.nrodocu, 7)) + " !"
      ENDIF
      SELECT tmpcuonota
   ENDSCAN 
ENDIF

POP KEY

*!*********************************************************************
*!
*!      Funci¢n: _DeleteInvoice
*!
*!  Llamado por: MKNOTA_C.PRG       
*!
*!  Descripci¢n: Borra la nota de debito o credito - clientes.
*!
*!*********************************************************************
FUNCTION _DeleteInvoice

PUSH KEY CLEAR

*-- Actualiza el campo cuotas_v.monto_ndeb o cuotas_v.monto_ncre y borra la(s) cuota(s) de la nota de debito / credito.
SELECT cuotas_n
SET ORDER TO TAG indice1 OF cuotas_n.cdx

IF SEEK("V" + STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7))
   SCAN WHILE ("V" + STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7)) = ("V" + STR(cuotas_n.tiponota, 1) + STR(cuotas_n.nronota, 7))
      SELECT cuotas_v
      SET ORDER TO TAG indice1 OF cuotas_v.cdx
      
      IF SEEK(STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7) + STR(cuotas_n.nrocuota, 3))
         IF INLIST(cabenotc.tiponota, 1, 3)
            REPLACE cuotas_v.monto_ndeb WITH (cuotas_v.monto_ndeb - cuotas_n.importe)
         ELSE
            IF INLIST(cabenotc.tiponota, 2, 4)
               REPLACE cuotas_v.monto_ncre WITH (cuotas_v.monto_ncre - cuotas_n.importe)
            ENDIF
         ENDIF
      ELSE
         WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR LA CUOTA N§: " + ALLTRIM(STR(cuotas_n.nrocuota, 3)) + " DE LA VENTA: " + ALLTRIM(STR(cabenotc.tipodocu, 1)) + "/" + ALLTRIM(STR(cabenotc.nrodocu, 7)) + " !"
      ENDIF
      
      SELECT cuotas_n
      DELETE
   ENDSCAN
ENDIF

*-- Actualiza el campo maesprod.stock_actu y borra el detalle de la nota de debito o credito.
SELECT detanotc
SET ORDER TO TAG indice1 OF detanotc.cdx

IF SEEK(STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7))
   SCAN WHILE (STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7)) = (STR(detanotc.tiponota, 1) + STR(detanotc.nronota, 7))
      IF detanotc.tipo = "S"
         SELECT maesprod
         SET ORDER TO TAG indice1 OF maesprod.cdx
         
         IF SEEK(detanotc.articulo)
            IF INLIST(cabenotc.tiponota, 1, 3)
               REPLACE maesprod.stock_actu WITH (maesprod.stock_actu + detanotc.cantidad)
            ELSE
               IF INLIST(cabenotc.tiponota, 2, 4)
                  REPLACE maesprod.stock_actu WITH (maesprod.stock_actu - detanotc.cantidad)
               ENDIF
            ENDIF
         ELSE
            WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL ARTICULO: " + ALLTRIM(detanotc.articulo) + " !"
         ENDIF
      ENDIF
      SELECT detanotc
      DELETE
   ENDSCAN
ELSE
   IF .NOT. cabenotc.anulado .AND. cabenotc.tiponota <> 0 .AND. cabenotc.nronota <> 0
      WAIT WINDOW "­ NO SE HA ENCONTRADO DETALLE A BORRAR !"
   ENDIF
ENDIF

*-- Actualiza el campo clientes.saldo_actu, si cabenotc.tipodocu = 2 y cabenotc.aplicontra = 2.
IF cabenotc.tipodocu = 2 .AND. cabenotc.aplicontra = 2
   SELECT clientes
   SET ORDER TO TAG indice1 OF clientes.cdx
   
   IF SEEK(cabenotc.cliente)
      IF INLIST(cabenotc.tiponota, 1, 3)
         IF cabevent.moneda = 1 
            REPLACE clientes.saldo_actu WITH (clientes.saldo_actu - cabenotc.monto_nota)
         ELSE
            REPLACE clientes.saldo_usd  WITH (clientes.saldo_usd  - cabenotc.monto_nota)
         ENDIF
      ELSE
         IF INLIST(cabenotc.tiponota, 2, 4)
            IF cabevent.moneda = 1
               REPLACE clientes.saldo_actu WITH (clientes.saldo_actu + cabenotc.monto_nota)
            ELSE
               REPLACE clientes.saldo_usd  WITH (clientes.saldo_usd  + cabenotc.monto_nota)
            ENDIF
         ENDIF
      ENDIF
   ELSE
      IF .NOT. cabenotc.anulado .AND. cabenotc.tiponota <> 0 .AND. cabenotc.nronota <> 0
         WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DEL CLIENTE: " + ALLTRIM(STR(cabenotc.cliente, 5)) + " !"
      ENDIF
   ENDIF
ENDIF

*-- Actualiza el campo cabevent.monto_ndeb o cabevent.monto_ncre y borra el encabezado de la nota de debito / credito.
SELECT cabevent
SET ORDER TO TAG indice1 OF cabevent.cdx

IF SEEK(STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7))
   IF INLIST(cabenotc.tiponota, 1, 3) .AND. cabenotc.aplicontra = 2
      REPLACE cabevent.monto_ndeb WITH (cabevent.monto_ndeb - cabenotc.monto_nota)
   ELSE
      IF INLIST(cabenotc.tiponota, 2, 4) .AND. cabenotc.aplicontra = 2
         REPLACE cabevent.monto_ncre WITH (cabevent.monto_ncre - cabenotc.monto_nota)
      ENDIF
   ENDIF
ELSE
   IF .NOT. cabenotc.anulado .AND. cabenotc.tiponota <> 0 .AND. cabenotc.nronota <> 0
      WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DE LA VENTA: " + ALLTRIM(STR(cabenotc.tipodocu, 1)) + "/" + ALLTRIM(STR(cabenotc.nrodocu, 7)) + " !" 
   ENDIF
ENDIF

SELECT cabenotc
SET ORDER TO TAG indice1 OF cabenotc.cdx

IF SEEK(STR(m.tiponota, 1) + STR(m.nronota, 7))
   SCAN WHILE (STR(m.tiponota, 1) + STR(m.nronota, 7)) = (STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7))
      DELETE
   ENDSCAN
ENDIF

POP KEY

*!*********************************************************************
*!
*!      Funci¢n: _LoadMaestemp
*!
*!  Llamado por: MKNOTA_C.PRG       
*!
*!  Descripci¢n: Borra la nota de debito o credito - clientes.
*!
*!*********************************************************************
FUNCTION _LoadMaestemp 

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT maestemp
ZAP

SELECT detavent
SET ORDER TO TAG indice1 OF detavent.cdx

IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7))
   SCAN WHILE STR(m.tipodocu, 1) + STR(m.nrodocu, 7) = STR(detavent.tipodocu, 1) + STR(detavent.nrodocu, 7)
      SELECT maesprod
      SET ORDER TO TAG indice1 OF maesprod.cdx
   
      IF SEEK(detavent.articulo)
         INSERT INTO maestemp (codigo, codigo2, codorig, nombre, lista3, lista4, lista5, familia, rubro, subrubro, marca, unidad, proveedor, procedenci, ubicacion, vigente, lprecio, impuesto, pimpuesto, pcostog, pcostod, pventag1, pventag2, pventag3, pventag4, pventag5, pventad1, pventad2, pventad3, pventad4, pventad5, paumento1, paumento2, paumento3, paumento4, paumento5, stock_min, stock_max, polinvsmin, polinvsmax, garantia, caracter1, caracter2, caracter3, otros1, otros2, fecucompra, fecrepo, stock_actu, stock_ot, cantidad) ;
            VALUES (detavent.articulo, maesprod.codigo2, maesprod.codorig, maesprod.nombre, maesprod.lista3, maesprod.lista4, maesprod.lista5, maesprod.familia, maesprod.rubro, maesprod.subrubro, maesprod.marca, maesprod.unidad, maesprod.proveedor, maesprod.procedenci, maesprod.ubicacion, maesprod.vigente, maesprod.lprecio, detavent.impuesto, detavent.pimpuesto, maesprod.pcostog, maesprod.pcostod, IIF(cabevent.porcdesc > 0, ROUND(detavent.precio * (1 - cabevent.porcdesc / 100), 4), IIF(cabevent.descuento > 0, ROUND(detavent.precio * (1 - cabevent.descuento / 100), 4), detavent.precio)), maesprod.pventag2, maesprod.pventag3, maesprod.pventag4, maesprod.pventag5, maesprod.pventad1, maesprod.pventad2, maesprod.pventad3, maesprod.pventad4, maesprod.pventad5, maesprod.paumento1, maesprod.paumento2, maesprod.paumento3, maesprod.paumento4, maesprod.paumento5, maesprod.stock_min, maesprod.stock_max, maesprod.polinvsmin, maesprod.polinvsmax, maesprod.garantia, maesprod.caracter1, maesprod.caracter2, maesprod.caracter3, maesprod.otros1, maesprod.otros2, maesprod.fecucompra, maesprod.fecrepo, maesprod.stock_actu, maesprod.stock_ot, detavent.cantidad)
      ELSE 
         WAIT WINDOW "­ ERROR, NO SE PUDO ENCONTRAR EL ARTICULO: "+ ALLTRIM(detavent.articulo) + " !"
      ENDIF
      SELECT detavent
   
   ENDSCAN
ELSE
   WAIT WINDOW "­ LA VENTA: " + ALLTRIM(STR(m.tipodocu, 1)) + "/" + ALLTRIM(STR(m.nrodocu, 7)) + " NO POSEE DETALLE !"
ENDIF
     
SELECT cabenotc
SET ORDER TO TAG indice3 OF cabenotc.cdx

IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7))
   SCAN WHILE STR(m.tipodocu, 1) + STR(m.nrodocu, 7) = STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7)
      SELECT detanotc
      SET ORDER TO indice1 OF detanotc.cdx
      IF SEEK(STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7))
         SCAN WHILE STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7) = STR(detanotc.tiponota, 1) + STR(detanotc.nronota, 7)
            SELECT maestemp
            SET ORDER TO TAG indice1
      
            IF SEEK(detanotc.articulo)
               IF detanotc.tipo = "S"
                  REPLACE maestemp.cantidad WITH (maestemp.cantidad - detanotc.cantidad)
               ENDIF
            ENDIF
            SELECT detanotc
         ENDSCAN
      ENDIF
      SELECT cabenotc
   ENDSCAN
ENDIF

DO _LoadQuota

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF
