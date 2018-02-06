*:**************************************************************************
*:
*: Archivo de Procedimiento: MKNOTA_P.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: ABM de Notas de D‚b./Cr‚d. de Proveedores
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 05/05/2004
*:
*:**************************************************************************
PARAMETER pcWhatToDo

PUSH KEY CLEAR

*-- Variables de la Tabla de Cabecera.
PRIVATE m.tiponota,m.nronota, m.tipodocu, m.nrodocu, m.fechanota, m.proveedor, m.motivonota, m.monto_nota, m.aplicontra, m.id_local

*-- Variables para c lculos del programa.
PRIVATE pnGravada, pnExenta, pnImpuesto, pnSubTotal

IF pcWhatToDo = "Add"
   SELECT cabenotp
   SCATTER MEMVAR MEMO BLANK
   
ELSE
   IF pcWhatToDo = "Edit"
      IF cabenotp.fechanota <> DATE() THEN
         WAIT "LOS REGISTROS DE ESTA TABLA NO PUEDEN SER MODIFICADOS !" WINDOW NOWAIT
         POP KEY 
         RETURN
      ENDIF

      SELECT cabenotp
      SCATTER MEMVAR MEMO
   ENDIF
ENDIF

*-- Inicializaci¢n de variables.
STORE 0 TO pnGravada, pnExenta, pnImpuesto, pnSubTotal, m.moneda, m.tipocambio

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

*-- Determina que c¢digo se utilizar  para la carga del detalle de la compra.
DO WHILE .T.
   WAIT WINDOW "¨ DESEA UTILIZAR CODIGO: (O)RIGINAL O (A)LTERNATIVO ?" TO pcWhatCode
   IF UPPER(pcWhatCode) = "O"
      pcMpdOrder = "indice7"
      EXIT DO
   ELSE
      IF UPPER(pcWhatCode) = "A"
         pcMpdOrder = "indice6"
         EXIT DO 
      ENDIF
   ENDIF
ENDDO

SELECT cabenotp

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
   SIZE 1,9 ;
   DEFAULT 0 ;
   PICTURE "999999999" ;
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

@ 03,14 GET m.proveedor ;
   SIZE 1,5 ;
   DEFAULT 0 ;
   PICTURE "99999" ;
   WHEN plAdding ;
   VALID _vldProveedor() ;
   COLOR SCHEME 1

@ 04,14 GET m.tipodocu ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN plAdding ;
   VALID _vldTipoDocu() ;
   COLOR SCHEME 1

@ 04,44 GET m.nrodocu ;
   SIZE 1,9 ;
   DEFAULT 0 ;
   PICTURE "999999999" ;
   WHEN plAdding ;
   VALID _vldNroDocu() ;
   COLOR SCHEME 1

IF plAdding 
   @ 04,69 SAY {} ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W
ENDIF

@ 06,14 GET m.motivonota ;
   SIZE 1,3 ;
   DEFAULT 0 ;
   PICTURE "999" ;
   WHEN plAdding .OR. plEditing ;
   VALID _vldMotivoNota() ;
   COLOR SCHEME 1
   
@ 06,67 GET m.aplicontra ;
   SIZE 1,1 ;
   DEFAULT 0 ;
   PICTURE "9" ;
   WHEN .F. ;
   VALID _vldAplicontra() ;
   COLOR SCHEME 1

@ 05,14 SAY m.moneda ;
   SIZE 1,4 ;
   PICTURE "9999" ;
   COLOR N/W

@ 05,69 SAY m.tipocambio ;
   SIZE 1,09 ;
   PICTURE "999999.99" ;
   COLOR N/W

@ 20,65 SAY pnSubTotal ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR N/W

@ 21,65 SAY pnImpuesto ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR N/W     

@ 22,65 SAY m.monto_nota ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR B/W

READ CYCLE ;
   MODAL ;
   COLOR , W+/BG 

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
   WAIT WINDOW "­ EL TIPO DE DOCUMENTO DEBE SER: 1 ¢ 2 !"
   RETURN .F.
ENDIF   

IF m.tiponota <= 0
   @ 02,17 SAY REPLICATE(CHR(32), 21) ;
      SIZE 1,21 ;
      PICTURE "@!" ;
      COLOR W/N
   DO tipodoc3.spr WITH "m.tiponota", 0, .F.
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
   CASE m.tiponota = 2
      @ 02,17 SAY "NOTA DE CREDITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 3
      @ 02,17 SAY "C.I. NOTA DE DEBITO" ;
         SIZE 1,21 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 4
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

IF m.nronota <= 0
   WAIT WINDOW "­ EL N§ DEL DOCUMENTO DEBE SER MAYOR QUE CERO !"
   RETURN .F.
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldProveedor
*!
*!  Llamado por: MKCUOTA_P.PRG          
*!
*!  Descripci¢n: Validaci¢n del campo pRmero de documento.    
*!
*!*********************************************************************
FUNCTION _vldProveedor
IF INLIST(LASTKEY(), 5, 19, 27, 127)
   RETURN 
ENDIF

IF m.proveedor <= 0
   @ 03,21 SAY REPLICATE(CHR(32), 40) ;
      SIZE 1,40 ;
      PICTURE "@!" ;
      COLOR W/N
   DO prov_pop.spr WITH "m.proveedor", 0, .F.
ENDIF

IF m.proveedor = 0
   RETURN .F.
ENDIF

PRIVATE pnSelect, pcOrder, pnRecNo

pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT proveedo
SET ORDER TO TAG indice1 OF proveedo.cdx

IF SEEK(m.proveedor)
   @ 03,21 SAY PADR(ALLTRIM(proveedo.nombre), 40, CHR(32)) ;
      SIZE 1,40 ;
      PICTURE "@!" ;
      COLOR W/N

   IF .NOT. proveedo.vigente = "S"
      WAIT WINDOW "­ CODIGO DE PROVEEDOR NO VIGENTE !"
      @ 03,21 SAY REPLICATE(CHR(32), 40) ;
         SIZE 1,40 ;
         PICTURE "@!" ;
         COLOR W/N
      
      SELECT (pnSelect)
      SET ORDER TO TAG (pcOrder)
      IF pnRecNo <> 0
         GOTO RECORD pnRecNo
      ENDIF
      
      RETURN .F.
   ENDIF

ELSE
   @ 03,21 SAY REPLICATE(CHR(32), 40) ;
      SIZE 1,40 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE PROVEEDOR INEXISTENTE !"   
   DO prov_pop.spr WITH "m.proveedor", 0, .F.
   SHOW GETS

   SELECT proveedo
   SET ORDER TO TAG indice1 OF proveedo.cdx

   IF SEEK(m.proveedor)
      @ 03,21 SAY PADR(ALLTRIM(proveedo.nombre), 40, CHR(32)) ;
         SIZE 1,40 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 03,21 SAY REPLICATE(CHR(32), 40) ;
         SIZE 1,40 ;
         PICTURE "@!" ;
         COLOR W/N

      SELECT (pnSelect)
      SET ORDER TO TAG (pcOrder)
      IF pnRecNo <> 0
         GOTO RECORD pnRecNo
      ENDIF

      RETURN .F.
   ENDIF   
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*-- Verifica si la nota de d‚b./cr‚d. que se est  cargando ya existe.
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT cabenotp
SET ORDER TO TAG indice1 OF cabenotp.cdx

IF SEEK(STR(m.tiponota, 1) + STR(m.nronota, 9) + STR(m.proveedor, 5))
   SHOW GET m.proveedor
   _CUROBJ = OBJNUM(m.proveedor)         

   IF m.tiponota = 1
      WAIT WINDOW "­ ESTA NOTA DE DEBITO YA HA SIDO CARGADA !"
   ELSE
      IF m.tiponota = 2
         WAIT WINDOW "­ ESTA NOTA DE CREDITO YA HA SIDO CARGADA !"
      ELSE
         WAIT WINDOW "­ ESTE N§ DE DOCUMENTO YA HA SIDO CARGADO !"
      ENDIF
   ENDIF

ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

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
            IF .NOT. pnDia <= 31
               WAIT WINDOW "­ FECHA INVALIDA !"
               RETURN .F.
            ENDIF 
         CASE pnMes = 2
            IF MOD(pnAnyo, 4) <> 0
               IF .NOT. pnDia <= 28
                  WAIT WINDOW "­ FECHA INVALIDA !"
                  RETURN .F.
               ENDIF
            ELSE
               IF .NOT. (MOD(pnAnyo, 100) = 0 .AND. MOD(pnAnyo, 400) <> 0)
                  IF .NOT. pnDia <= 29
                     WAIT WINDOW "­ FECHA INVALIDA !"
                     RETURN .F.
                  ENDIF
               ENDIF 
            ENDIF
         CASE INLIST(pnMes, 4, 6, 9, 11)
            IF .NOT. pnDia <= 30
               WAIT WINDOW "­ FECHA INVALIDA !"
               RETURN .F.
            ENDIF
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
   @ 04,17 SAY REPLICATE(CHR(32), 21) ;
      SIZE 1,22 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ EL TIPO DE DOCUMENTO DE COMPRA DEBE SER: 1 AL 8 !"
   RETURN .F.
ENDIF   

IF m.tipodocu <= 0
   @ 04,17 SAY REPLICATE(CHR(32), 21) ;
      SIZE 1,22 ;
      PICTURE "@!" ;
      COLOR W/N
   DO tipodoc2.spr WITH "m.tipodocu", 0, .F.
ENDIF

IF m.tipodocu = 0
   RETURN .F.
ENDIF

DO CASE
   CASE INLIST(m.tipodocu, 1, 7)
      @ 04,17 SAY "COMPRA CONTADO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE INLIST(m.tipodocu, 2, 8)
      @ 04,17 SAY "COMPRA CREDITO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 3
      @ 04,17 SAY "COMPRA I.V.A. INCLUIDO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 4
      @ 04,17 SAY "COMPRA TRIBUTO UNICO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   OTHERWISE
      @ 04,17 SAY REPLICATE(CHR(32), 22) ;
         SIZE 1,22 ;
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

IF m.nrodocu <= 0
   m.fechadocu = {}

   @ 04,69 SAY m.fechadocu ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W

   WAIT WINDOW "­ EL N§ DEL DOCUMENTO DE COMPRA DEBE SER MAYOR QUE CERO !"
   RETURN .F.
ENDIF

*-- Imprime la fecha del documento, moneda y tipo de cambio de compra.
PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT cabecomp
SET ORDER TO TAG indice1 OF cabecomp.cdx

IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 9) + STR(m.proveedor, 5))
   m.fechadocu  = cabecomp.fechadocu
   m.moneda     = cabecomp.moneda    
   m.tipocambio = cabecomp.tipocambio  

   @ 04,69 SAY m.fechadocu ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W

   @ 05,14 SAY m.moneda ;
      SIZE 1,4 ;
      PICTURE "9999" ;
      COLOR N/W
   
   *-- Imprime el nombre de la moneda.
   SELECT monedas
   SET ORDER TO TAG indice1 OF monedas.cdx
 
   IF SEEK(m.moneda)
      IF m.moneda = 1
         @ 05,20 SAY PADR(ALLTRIM(monedas.nombre), 30, CHR(32)) ;
            SIZE 1,30 ;
            PICTURE "@!" ;
            COLOR W/N
      ELSE
         @ 05,20 SAY PADR(ALLTRIM(monedas.nombre), 30, CHR(32)) ;
            SIZE 1,30 ;
            PICTURE "@!" ;
            COLOR G/N
      ENDIF
   ELSE
      @ 05,20 SAY REPLICATE(CHR(32), 30) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR W/N
   ENDIF

   SELECT cabenotp

   @ 05,69 SAY m.tipocambio ;
      SIZE 1,09 ;
      PICTURE "999999.99" ;
      COLOR N/W
ELSE
   m.fechadocu  = {}
   m.moneda     = 0
   m.tipocambio = 0

   @ 04,69 SAY m.fechadocu ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W

   @ 05,14 SAY m.moneda ;
      SIZE 1,4 ;
      PICTURE "9999" ;
      COLOR N/W

   @ 05,69 SAY m.tipocambio ;
      SIZE 1,09 ;
      PICTURE "999999.99" ;
      COLOR N/W

   WAIT WINDOW "­ EL DOCUMENTO DE COMPRA INGRESADO NO EXISTE !"

   SELECT (pnSelect)
   SET ORDER TO TAG (pcOrder)
   IF pnRecNo <> 0
      GOTO RECORD pnRecNo
   ENDIF

   RETURN .F.
ENDIF

DO _LoadMaestemp 

IF INLIST(m.tipodocu, 1, 3, 4, 5, 7)
   m.aplicontra = 1
ELSE
   IF INLIST(m.tipodocu, 2, 6, 8)
      IF ((cabecomp.monto_fact + cabecomp.monto_ndeb) - (cabecomp.monto_pago + cabecomp.monto_ncre)) > 0 .AND. ;
         ((cabecomp.monto_fact + cabecomp.monto_ndeb) - (cabecomp.monto_pago + cabecomp.monto_ncre)) >= m.monto_nota
         m.aplicontra = 2
      ELSE
         m.aplicontra = 1
      ENDIF
   ENDIF
ENDIF

*-- Imprime el nombre de aplicado contra.
IF m.aplicontra = 1
   @ 06,69 SAY PADR(ALLTRIM("CAJA"), 10, CHR(32)) ;
      SIZE 1,10 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   IF m.aplicontra = 2
      @ 06,69 SAY PADR(ALLTRIM("CTA. CTE."), 10, CHR(32)) ;
         SIZE 1,10 ;
         PICTURE "@!" ;
         COLOR W/N
   ENDIF
ENDIF

SHOW GETS

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

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
   @ 06,19 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
   DO mono_pop.spr WITH "m.motivonota", 0, .F.
ENDIF

IF m.motivonota = 0
   RETURN .F.
ENDIF

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT motivono
SET ORDER TO TAG indice1 OF motivono.cdx

IF SEEK(m.motivonota)
   IF motivono.vigente
      @ 06,19 SAY PADR(ALLTRIM(motivono.nombre), 30, CHR(32)) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 06,19 SAY REPLICATE(CHR(32), 30) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR W/N
      WAIT WINDOW "­ CODIGO DE MOTIVO DE LA NOTA NO VIGENTE !"

      SELECT (pnSelect)
      SET ORDER TO TAG (pcOrder)
      IF pnRecNo <> 0
        GOTO RECORD pnRecNo
      ENDIF

      RETURN .F.
   ENDIF
ELSE
   @ 06,19 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE MOTIVO DE LA NOTA INEXISTENTE !"
   DO mono_pop.spr WITH "m.motivonota", 0, .F.
   SHOW GET m.motivonota

   SELECT motivono
   SET ORDER TO TAG indice1 OF motivono.cdx
 
   IF SEEK(m.motivonota)
      IF motivono.vigente
         @ 06,19 SAY PADR(ALLTRIM(monedas.nombre), 30, CHR(32)) ;
            SIZE 1,30 ;
            PICTURE "@!" ;
            COLOR W/N
      ELSE
         @ 06,19 SAY REPLICATE(CHR(32), 30) ;
            SIZE 1,30 ;
            PICTURE "@!" ;
            COLOR W/N
         WAIT WINDOW "­ CODIGO DE MOTIVO DE LA NOTA NO VIGENTE !"

         SELECT (pnSelect)
         SET ORDER TO TAG (pcOrder)
         IF pnRecNo <> 0
            GOTO RECORD pnRecNo
         ENDIF

         RETURN .F.
      ENDIF
   ELSE
      @ 06,19 SAY REPLICATE(CHR(32), 28) ;
         SIZE 1,28 ;
         PICTURE "@!" ;
         COLOR W/N

      SELECT (pnSelect)
      SET ORDER TO TAG (pcOrder)
      IF pnRecNo <> 0
         GOTO RECORD pnRecNo
      ENDIF

      RETURN .F.
   ENDIF
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

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
            IF INLIST(cabenotp.tiponota, 1, 3)
               WAIT WINDOW "­ LA NOTA DE DEBITO FUE GRABADA !" TIMEOUT 0.75
            ELSE
               IF INLIST(cabenotp.tiponota, 2, 4)
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
                     IF INLIST(cabenotp.tiponota, 1, 3)
                        WAIT WINDOW "­ LA NOTA DE DEBITO FUE GRABADA !" TIMEOUT 0.75
                     ELSE
                        IF INLIST(cabenotp.tiponota, 2, 4)
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
   @ 06,69 SAY REPLICATE(CHR(32), 10) ;
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
   @ 06,69 SAY PADR(ALLTRIM("CAJA"), 10, CHR(32)) ;
      SIZE 1,10 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   IF m.aplicontra = 2
      @ 06,69 SAY PADR(ALLTRIM("CTA. CTE."), 10, CHR(32)) ;
         SIZE 1,10 ;
         PICTURE "@!" ;
         COLOR W/N
         
      IF INLIST(m.tiponota, 2, 4) .AND. INLIST(m.tipodocu, 2, 6, 8)
         IF ((cabecomp.monto_fact + cabecomp.monto_ndeb) - (cabecomp.monto_pago + cabecomp.monto_ncre)) <= 0
            SHOW GETS
            WAIT WINDOW "­ LA COMPRA INGRESADA TIENE SALDO CERO !"
            RETURN .F.
         ENDIF
      ENDIF
   ELSE
      @ 06,69 SAY REPLICATE(CHR(32), 09) ;
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
         IF INLIST(cabenotp.tiponota, 1, 3)
            WAIT WINDOW "­ LA NOTA DE DEBITO FUE GRABADA !" TIMEOUT 0.75
         ELSE
            IF INLIST(cabenotp.tiponota, 2, 4)
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
                  IF INLIST(cabenotp.tiponota, 1, 3)
                     WAIT WINDOW "­ LA NOTA DE DEBITO FUE GRABADA !" TIMEOUT 0.75
                  ELSE
                     IF INLIST(cabenotp.tiponota, 2, 4)
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

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT tmpdetnota
SET ORDER TO 0

IF RECCOUNT() = 0
   INSERT INTO tmpdetnota (tiponota, nronota, tipo, articulo, cantidad, precio, impuesto, pimpuesto) ;
      VALUES (0, 0, "", "", 0, 0, .F., 0)
ENDIF

ON KEY LABEL "F8" DO _DeleteLine

DO WHILE LASTKEY() <> 27
   @ 20,12 CLEAR TO 22,41
   
   @ 10,01 CLEAR TO 18,01     && Tipo.
   @ 10,03 CLEAR TO 18,40     && Descripci¢n.
   @ 10,42 CLEAR TO 18,51     && Cantidad.
   @ 10,53 CLEAR TO 18,67     && Precio Unit.
   @ 10,69 CLEAR TO 18,78     && Importe.

   GO BOTTOM

   IF m.moneda <> 1
      BROWSE WINDOW tmpdetnota FIELDS ;
         tipo                                       :01:H = ""             :P = "@A!"                :V = _vldTipo():F ,;
         articulo                                   :13:H = "C¢digo"       :P = "@!"                 :V = _vldCodigo():F ,;
         calc_f1 = SUBSTR(maesprod.nombre, 1, 35) :R:35:H = "Descripci¢n"  :W = .F. ,;
         cantidad                                   :08:H = "Cantidad"     :P = "99999.99"           :W = (tipo = "S") :V = _vldCantidad():F ,;
         precio                                     :15:H = "Precio Unit." :P = "@K 9999999999.9999" :W = (tipo = "P") :V = _vldPrecio():F  ,;
         pdescuento                                 :07:H = "% Dcto."      :P = "99.9999" :V = _vldDescuento() ,;      
         calc_f2 = ROUND(precio * (1 - pdescuento / 100) * cantidad, 2)    :11:H = " Sub-Total"   :P = "9999,999.99" :W = _whenSubTotal(articulo) :V = _vldAddNewLine() :F ;
         NODELETE NOAPPEND 
   ELSE  
      BROWSE WINDOW tmpdetnota FIELDS ;
         tipo                                       :01:H = ""             :P = "@A!"                :V = _vldTipo():F ,;
         articulo                                   :13:H = "C¢digo"       :P = "@!"                 :V = _vldCodigo():F ,;
         calc_f1 = SUBSTR(maesprod.nombre, 1, 35) :R:35:H = "Descripci¢n"  :W = .F. ,;
         cantidad                                   :08:H = "Cantidad"     :P = "99999.99"           :W = (tipo = "S") :V = _vldCantidad():F ,;
         precio                                     :15:H = "Precio Unit." :P = "@K 9999999999.9999" :W = (tipo = "P" .OR. tipo = "S") :V = _vldPrecio():F  ,;
         pdescuento                                 :07:H = "% Dcto."      :P = "99.9999" :V = _vldDescuento() ,;      
         calc_f2 = ROUND(precio * (1 - pdescuento / 100) * cantidad, 0)    :11:H = " Sub-Total"   :P = "999,999,999" :W = _whenSubTotal(articulo) :V = _vldAddNewLine() :F ;
         NODELETE NOAPPEND 
   ENDIF
ENDDO

*        precio                                     :15:H = "Precio Unit." :P = "@K 99999999.9999"   :W = (tipo = "P") :V = _vldPrecio():F  ,;

ON KEY LABEL "F8"

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

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

*IF INLIST(LASTKEY(), K_DOWN, K_F8)
*   RETURN 
*ENDIF  

IF LASTKEY() =  K_F8
   RETURN 
ENDIF  


IF EMPTY(articulo)
   PUSH KEY CLEAR

   *-- Procedimiento de inspecci¢n de art¡culos.
   ON KEY LABEL "ENTER" KEYBOARD "{CTRL+W}"
   DO _brwMaesTemp
   ON KEY LABEL "ENTER" 

   POP KEY
  
   IF LASTKEY() <> 27           
      REPLACE tmpdetnota.articulo WITH maestemp.codigo
      REPLACE tmpdetnota.tipoc    WITH "A"
   ELSE 
      RETURN .F.
   ENDIF
ENDIF

SELECT maestemp
IF tmpdetnota.tipoc <> "A"
   SET ORDER TO TAG &pcMpdOrder 
ELSE
   SET ORDER TO TAG indice1 
ENDIF

PRIVATE pcSetExact

IF SET("EXACT") = "OFF"
   SET EXACT ON 
   pcSetExact = "OFF"
ELSE
   pcSetExact = "ON"
ENDIF

IF .NOT. SEEK(tmpdetnota.articulo)
   SET ORDER TO TAG indice1

   WAIT WINDOW "­ CODIGO DE ARTICULO INEXISTENTE !"

   IF pcSetExact = "OFF"
      SET EXACT OFF
   ENDIF

   RETURN .F.
ENDIF

REPLACE tmpdetnota.tipoc     WITH "A"
REPLACE tmpdetnota.articulo  WITH maestemp.codigo
REPLACE tmpdetnota.impuesto  WITH maestemp.impuesto
REPLACE tmpdetnota.pimpuesto WITH maestemp.pimpuesto
REPLACE tmpdetnota.precio    WITH maestemp.pventag1

SET ORDER TO TAG indice1

@ 20,12 SAY rubros1.nombre ;
   SIZE 1,30 ;
   PICTURE "@!" ;
   COLOR W/N

@ 21,12 SAY IIF(maestemp.impuesto, "S¡   " + STR(maestemp.pimpuesto,6,2)+ " %", "No") ;
   SIZE 1,13 ;
   COLOR W/N  

@ 22,12 SAY maestemp.stock_actu ;
   SIZE 1,11 ;
   PICTURE "99999999.99" ;
   COLOR W/N      

SELECT tmpdetnota

IF pcSetExact = "OFF"
   SET EXACT OFF
ENDIF

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

DO _InvoiceFoot

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

DO _InvoiceFoot

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
      INSERT INTO tmpdetnota (tiponota, nronota, tipo, articulo, cantidad, precio, impuesto, pimpuesto) ;
         VALUES (0, 0, "", "", 0, 0, .F., 0)
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
   INSERT INTO tmpdetnota (tiponota, nronota, tipo, articulo, cantidad, precio, impuesto, pimpuesto) ;
      VALUES (0, 0, "", "", 0, 0, .F., 0)
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

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

#DEFINE pnRow    9
#DEFINE pnColumn 1

SELECT tmpdetnota
GO TOP

SCAN WHILE RECNO() <= 9 .AND. .NOT. (EMPTY(articulo) .OR. EMPTY(cantidad) .OR. EMPTY(precio))
   @ pnRow + RECNO(), pnColumn      SAY tipo                                                   COLOR N/W
   @ pnRow + RECNO(), pnColumn + 2  SAY SUBSTR(maesprod.nombre, 1, 38)                         COLOR N/W
   @ pnRow + RECNO(), pnColumn + 41 SAY cantidad                       PICTURE "999,999.99"    COLOR N/W
   @ pnRow + RECNO(), pnColumn + 52 SAY precio                         PICTURE "99,999,999.9999" COLOR N/W
   IF m.moneda <> 1
      @ pnRow + RECNO(), pnColumn + 68 SAY ROUND(precio * cantidad, 2) PICTURE "999,999.99"    COLOR N/W
   ELSE
      @ pnRow + RECNO(), pnColumn + 68 SAY ROUND(precio * cantidad, 0) PICTURE "99,999,999"    COLOR N/W  
   ENDIF
ENDSCAN

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _vldDescuento
*!
*!  Llamado por: _brwLoadDetail
*!
*!  Descripci¢n: Validaci¢n del campo precio unitario en el detalle del   
*!               comprobante de venta.
*!
*!*********************************************************************
FUNCTION _vldDescuento
IF pdescuento < 0
   WAIT WINDOW "­ EL PORCENTAJE DE DESCUENTO DEBE SER MAYOR O IGUAL QUE CERO !"
   RETURN .F.
ENDIF         

DO _InvoiceFoot

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

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT servicio
SET ORDER TO indice1 OF servicio.cdx

IF SEEK(pcArticulo)
   RETURN 
ELSE
   RETURN .F.
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

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

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT servicio
SET ORDER TO indice1 OF servicio.cdx

IF SEEK(pcArticulo)
   RETURN .F.
ELSE
   RETURN 
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

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

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT tmpdetnota
GO TOP

STORE 0 TO m.monto_nota, pnGravada, pnExenta, pnImpuesto, pnSubTotal

IF m.moneda <> 1
   SCAN ALL
      DO CASE
         CASE impuesto .AND. pimpuesto > 0 .AND. pimpuesto < 10
            pnGravada = pnGravada + ROUND(precio * (1 - pdescuento / 100) * cantidad, 2) * (pimpuesto * (control.pimpuesto / 100))
            pnExenta  = pnExenta  + ROUND(precio * (1 - pdescuento / 100) * cantidad, 2) * (1 - (pimpuesto * (control.pimpuesto / 100)))
         CASE impuesto .AND. pimpuesto = control.pimpuesto
            pnGravada = pnGravada + ROUND(precio * (1 - pdescuento / 100) * cantidad, 2)            
         CASE .NOT. impuesto .AND. pimpuesto = 0
            pnExenta  = pnExenta  + ROUND(precio * (1 - pdescuento / 100) * cantidad, 2)
      ENDCASE
   ENDSCAN

   pnSubTotal   = pnGravada + pnExenta
   pnImpuesto   = ROUND(pnGravada * (control.pimpuesto / 100), 2)
   m.monto_nota = pnSubTotal + pnImpuesto
ELSE
   SCAN ALL
      DO CASE
         CASE impuesto .AND. pimpuesto > 0 .AND. pimpuesto < 10
            pnGravada = pnGravada + ROUND(precio * (1 - pdescuento / 100) * cantidad, 0) * (pimpuesto * (control.pimpuesto / 100))
            pnExenta  = pnExenta  + ROUND(precio * (1 - pdescuento / 100) * cantidad, 0) * (1 - (pimpuesto * (control.pimpuesto / 100)))
         CASE impuesto .AND. pimpuesto = control.pimpuesto
            pnGravada = pnGravada + ROUND(precio * (1 - pdescuento / 100) * cantidad, 0)            
         CASE .NOT. impuesto .AND. pimpuesto = 0
            pnExenta  = pnExenta  + ROUND(precio * (1 - pdescuento / 100) * cantidad, 0)
      ENDCASE
   ENDSCAN

   pnSubTotal   = pnGravada + pnExenta
   pnImpuesto   = ROUND(pnGravada * (control.pimpuesto / 100), 0)
   m.monto_nota = pnSubTotal + pnImpuesto
ENDIF

@ 20,65 SAY pnSubTotal ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR N/W

@ 21,65 SAY pnImpuesto ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR N/W

@ 22,65 SAY m.monto_nota ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR B/W

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

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

SELECT cabenotp
*SCATTER MEMVAR

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
   SIZE 1,9 ;
   PICTURE "999999999" ;
   COLOR N/W

IF TYPE("m.fechanota") # "C"
   m.fechanota = DTOC(m.fechanota)
ENDIF

@ 02,69 SAY m.fechanota ;
   SIZE 1,10 ;
   PICTURE "99/99/9999" ;
   COLOR N/W

@ 03,14 SAY m.proveedor  ;
   SIZE 1,5 ;
   PICTURE "99999" ;
   COLOR N/W

*-- Imprime el nombre del proveedor selecionado.
SELECT proveedo
SET ORDER TO TAG indice1 OF proveedo.cdx

IF SEEK(m.proveedor)
   @ 03,21 SAY PADR(ALLTRIM(proveedo.nombre), 40, CHR(32)) ;
      SIZE 1,40 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 03,21 SAY REPLICATE(CHR(32), 40) ;
      SIZE 1,40 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

SELECT cabenotp

@ 04,14 SAY m.tipodocu ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W

*-- Imprime la etiqueta del tipo de documento.
DO CASE
   CASE INLIST(m.tipodocu, 1, 7)
      @ 04,17 SAY "COMPRA CONTADO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE INLIST(m.tipodocu, 2, 8)
      @ 04,17 SAY "COMPRA CREDITO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 3
      @ 04,17 SAY "COMPRA I.V.A. INCLUIDO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   CASE m.tipodocu = 4
      @ 04,17 SAY "COMPRA TRIBUTO UNICO" ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
   OTHERWISE
      @ 04,17 SAY REPLICATE(CHR(32), 22) ;
         SIZE 1,22 ;
         PICTURE "@!" ;
         COLOR W/N
ENDCASE

@ 04,44 SAY m.nrodocu ;
   SIZE 1,9 ;
   PICTURE "999999999" ;
   COLOR N/W

*-- Imprime la fecha del documento, moneda y tipo de cambio de compra.
SELECT cabecomp
SET ORDER TO TAG indice1 OF cabecomp.cdx

IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 9) + STR(m.proveedor, 5))
   m.fechadocu  = cabecomp.fechadocu
   m.moneda     = cabecomp.moneda    
   m.tipocambio = cabecomp.tipocambio  

   @ 04,69 SAY m.fechadocu ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W

   @ 05,14 SAY m.moneda ;
      SIZE 1,4 ;
      PICTURE "9999" ;
      COLOR N/W
   
   *-- Imprime el nombre de la moneda.
   SELECT monedas
   SET ORDER TO TAG indice1 OF monedas.cdx
 
   IF SEEK(m.moneda)
      IF m.moneda = 1
         @ 05,20 SAY PADR(ALLTRIM(monedas.nombre), 30, CHR(32)) ;
            SIZE 1,30 ;
            PICTURE "@!" ;
            COLOR W/N
      ELSE
         @ 05,20 SAY PADR(ALLTRIM(monedas.nombre), 30, CHR(32)) ;
            SIZE 1,30 ;
            PICTURE "@!" ;
            COLOR G/N
      ENDIF
   ELSE
      @ 05,20 SAY REPLICATE(CHR(32), 30) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR W/N
   ENDIF

   SELECT cabenotp

   @ 05,69 SAY m.tipocambio ;
      SIZE 1,09 ;
      PICTURE "999999.99" ;
      COLOR N/W
ELSE
   m.fechadocu  = {}
   m.moneda     = 0
   m.tipocambio = 0

   @ 04,69 SAY m.fechadocu ;
      SIZE 1,10 ;
      PICTURE "@D" ;
      COLOR N/W

   @ 05,14 SAY m.moneda ;
      SIZE 1,4 ;
      PICTURE "9999" ;
      COLOR N/W

   @ 05,69 SAY m.tipocambio ;
      SIZE 1,09 ;
      PICTURE "999999.99" ;
      COLOR N/W
ENDIF

SELECT cabenotp

@ 06,14 SAY m.motivonota ;
   SIZE 1,3 ;
   PICTURE "999" ;
   COLOR N/W
   
*-- Imprime el nombre del motivo de la nota.
SELECT motivono
SET ORDER TO TAG indice1 OF motivono.cdx

IF SEEK(m.motivonota)
   @ 06,19 SAY PADR(ALLTRIM(motivono.nombre), 30, CHR(32)) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 06,19 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

SELECT cabenotp
   
@ 06,67 SAY m.aplicontra ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W
   
*-- Imprime el nombre de aplicado contra.
IF m.aplicontra = 1
   @ 06,69 SAY PADR(ALLTRIM("CAJA"), 10, CHR(32)) ;
      SIZE 1,10 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   IF m.aplicontra = 2
      @ 06,69 SAY PADR(ALLTRIM("CTA. CTE."), 10, CHR(32)) ;
         SIZE 1,10 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 06,69 SAY REPLICATE(CHR(32), 10) ;
         SIZE 1,10 ;
         PICTURE "@!" ;
         COLOR W/N
   ENDIF
ENDIF

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
   calc_f13 = SUBSTR(codorig, 1, 15)                    :R:15:H = "C¢d. Origen" NOAPPEND NODELETE NOMODIFY

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
ON KEY LABEL "F3" DO impnotap.spr
ON KEY LABEL "SPACEBAR"  WAIT WINDOW ALLTRIM(TRANSFORM(m.monto_nota, "999,999,999.99")) + " / " + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) + " = " + ALLTRIM(TRANSFORM(ROUND(m.monto_nota / RECCOUNT(), 2), "999,999,999.99")) 

BROWSE WINDOW tmpformapl FIELDS ;
   calc_f1 = IIF(tipo = 1,"Entr",IIF(tipo = 2,"Cuot",""))      :R:04:H = "Tipo" ,;
   nrocuota                                                    :R:03:H = "N§" :P = "999",;
   fecha                                                       :R:10:H = "Fecha Vcto" ,;
   calc_f2 = TRANSFORM(importe, IIF(m.moneda <> 1, "999,999.99", "99,999,999")) :10:H = "Importe" ,;
   calc_f3 = TRANSFORM((importe + monto_ndeb) - (monto_ncre + abonado), IIF(m.moneda <> 1, "999,999.99", "99,999,999")) :R:10:H = "Saldo" ,;
   calc_f4 = TRANSFORM(abonado, IIF(m.moneda <> 1, "999,999.99", "99,999,999")) :10:H = "Abonado" ,;
   calc_f5 = TRANSFORM(monto_ndeb, IIF(m.moneda <> 1, "999,999.99", "99,999,999")) :10:H = "Monto Ndeb" ,;
   calc_f6 = TRANSFORM(monto_ncre, IIF(m.moneda <> 1, "999,999.99", "99,999,999")) :10:H = "Monto Ncre" ;
   NOAPPEND NODELETE NOMODIFY

*-- MS-DOS Restablece macros de teclado.
ON KEY LABEL "F3"
ON KEY LABEL "SPACEBAR" 

DEACTIVATE WINDOW tmpmarcuot 

SELECT cabenotp

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

SELECT cuotas_c

IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 9) + STR(m.proveedor, 5))
   SCAN WHILE STR(m.tipodocu, 1) + STR(m.nrodocu, 9) + STR(m.proveedor, 5) = STR(cuotas_c.tipodocu, 1) + STR(cuotas_c.nrodocu, 9) + STR(cuotas_c.proveedor, 5)
      INSERT INTO tmpcuonota (tipodocu, nrodocu, proveedor, tipo, nrocuota, fecha, importe, abonado, monto_ndeb, monto_ncre, monto) ;
         VALUES (cuotas_c.tipodocu, cuotas_c.nrodocu, cuotas_c.proveedor, cuotas_c.tipo, cuotas_c.nrocuota, cuotas_c.fecha, cuotas_c.importe, cuotas_c.abonado, cuotas_c.monto_ndeb, cuotas_c.monto_ncre, IIF(INLIST(m.tiponota, 1, 3), cuotas_c.monto_ndeb, IIF(INLIST(m.tiponota, 2, 4), cuotas_c.monto_ncre, 0)))
   ENDSCAN
ELSE
  IF INLIST(cabecomp.tipodocu, 2, 6, 8)
     WAIT WINDOW "     ­ ESTE DOCUMENTO NO POSEE CUOTAS !" + CHR(13) + ;
                 "MODIFIQUELO PARA VOLVER A GENERAR LAS CUOTAS"
  ENDIF
ENDIF

IF plEditing
   SELECT cuotas_p
   SET ORDER TO TAG indice1 OF cuotas_p.cdx

   IF SEEK(STR(m.tiponota, 1) + STR(m.nronota, 9) + STR(m.proveedor, 5))
      SCAN WHILE STR(m.tiponota, 1) + STR(m.nronota, 9) + STR(m.proveedor, 5) = STR(cuotas_p.tiponota, 1) + STR(cuotas_p.nronota, 9) + STR(cuotas_p.proveedor, 5)
         SELECT tmpcuonota
         SET ORDER TO TAG indice1 
         
         IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 9) + STR(m.proveedor, 5) + STR(cuotas_p.nrocuota, 3))
            IF INLIST(m.tiponota, 1, 3)
               REPLACE tmpcuonota.monto_ndeb WITH (tmpcuonota.monto_ndeb - cuotas_p.importe)
               REPLACE tmpcuonota.monto      WITH (tmpcuonota.monto - cuotas_p.importe)
            ELSE
               IF INLIST(m.tiponota, 2, 4)
                  REPLACE tmpcuonota.monto_ncre WITH (tmpcuonota.monto_ncre - cuotas_p.importe)
                  REPLACE tmpcuonota.monto      WITH (tmpcuonota.monto - cuotas_p.importe)
               ENDIF
            ENDIF
         ENDIF
         SELECT cuotas_p
      ENDSCAN
   ENDIF
ENDIF
         
SELECT cabenotp

*!*********************************************************************
*!
*!      Funci¢n: _SaveInvoice
*!
*!  Llamado por: MKNOTA_C.PRG                 
*!
*!  Descripci¢n: Graba la nota debito o credito - proveedo.
*!
*!*********************************************************************
FUNCTION _SaveInvoice

PUSH KEY CLEAR

IF plEditing
   DO _DeleteInvoice
ENDIF

*-- Graba el encabezado de la nota de debito o credito.
SELECT cabenotp

INSERT INTO cabenotp (tiponota, nronota, tipodocu, nrodocu, fechanota, proveedor, motivonota, aplicontra, monto_nota, id_local) ;
   VALUES (m.tiponota, m.nronota, m.tipodocu, m.nrodocu, CTOD(m.fechanota), m.proveedor, m.motivonota, m.aplicontra, m.monto_nota, control.id_local)
   
IF INLIST(cabenotp.tipodocu, 2, 6, 8) .AND. cabenotp.aplicontra = 2
   SELECT cabecomp
   SET ORDER TO TAG "indice1"
   SEEK STR(cabenotp.tipodocu, 1) + STR(cabenotp.nrodocu, 9) + STR(cabenotp.proveedor, 5)
   
   SELECT proveedo
   SET ORDER TO TAG "indice1"
         
   IF SEEK(cabenotp.proveedor)
      IF INLIST(cabenotp.tiponota, 1, 3)
         IF cabecomp.moneda = 1 THEN
            REPLACE saldo_actu WITH (saldo_actu + cabenotp.monto_nota)
         ELSE
            REPLACE saldo_usd  WITH (saldo_usd + cabenotp.monto_nota)
         ENDIF
      ELSE
         IF INLIST(cabenotp.tiponota, 2, 4)
            IF cabecomp.moneda = 1 THEN
               REPLACE saldo_actu WITH (saldo_actu - cabenotp.monto_nota)
            ELSE
               REPLACE saldo_usd  WITH (saldo_usd - cabenotp.monto_nota)
            ENDIF
         ENDIF
      ENDIF
   ELSE
      IF .NOT. cabenotp.anulado .AND. cabenotp.tiponota <> 0 .AND. cabenotp.nronota <> 0
         WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DEL CLIENTE: " + ALLTRIM(STR(cabenotp.cliente, 5)) + " !"
      ENDIF
   ENDIF
ENDIF

SELECT cabecomp
SET ORDER TO TAG indice1 OF cabecomp.cdx

IF SEEK(STR(cabenotp.tipodocu, 1) + STR(cabenotp.nrodocu, 9) + STR(cabenotp.proveedor, 5))
   IF INLIST(cabenotp.tiponota, 1, 3)
      REPLACE cabecomp.monto_ndeb WITH (cabecomp.monto_ndeb + cabenotp.monto_nota)
   ELSE
      IF INLIST(cabenotp.tiponota, 2, 4)
         REPLACE cabecomp.monto_ncre WITH (cabecomp.monto_ncre + cabenotp.monto_nota)
      ENDIF
   ENDIF
ELSE
   IF cabenotp.tiponota <> 0 .AND. cabenotp.nronota <> 0
      WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DEL CLIENTE: " + ALLTRIM(STR(cabenotp.cliente, 5)) + " !"
   ENDIF
ENDIF

*-- Graba el detalle de la nota de debito o credito y actualiza la existencia de mercaderias, si detanotp.tipo = "S".
SELECT tmpdetnota
GO TOP

SCAN ALL
   IF .NOT. (EMPTY(tmpdetnota.articulo) .OR. EMPTY(tmpdetnota.cantidad) .OR. EMPTY(tmpdetnota.precio))
      INSERT INTO detanotp (tiponota, nronota, proveedor, tipo, articulo, cantidad, precio, pdescuento, impuesto, pimpuesto) ;
         VALUES (cabenotp.tiponota, cabenotp.nronota, cabenotp.proveedor, tmpdetnota.tipo, tmpdetnota.articulo, tmpdetnota.cantidad, tmpdetnota.precio, tmpdetnota.pdescuento, tmpdetnota.impuesto, tmpdetnota.pimpuesto)
      IF detanotp.tipo = "S"
         SELECT maesprod
         SET ORDER TO TAG indice1 OF maesprod.cdx
         
         IF SEEK(detanotp.articulo)
            IF INLIST(cabenotp.tiponota, 1, 3)
               REPLACE maesprod.stock_actu WITH (maesprod.stock_actu + detanotp.cantidad)
            ELSE
               IF INLIST(cabenotp.tiponota, 2, 4)
                  REPLACE maesprod.stock_actu WITH (maesprod.stock_actu - detanotp.cantidad)
               ENDIF
            ENDIF
         ELSE
            WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL ARTICULO: " + ALLTRIM(detanotp.articulo) + " !"
         ENDIF
      ENDIF
      SELECT tmpdetnota
   ENDIF
ENDSCAN
   
*-- Graba la(s) cuota(s) de la nota de debito o credito.
SELECT tmpcuonota
GO TOP
   
IF RECCOUNT() > 0 .AND. INLIST(cabenotp.tipodocu, 2, 6, 8) .AND. cabenotp.aplicontra = 2
   SCAN ALL
      INSERT INTO cuotas_p (tiponota, nronota, proveedor, nrocuota, importe) ;
         VALUES (cabenotp.tiponota, cabenotp.nronota, cabenotp.proveedor, tmpcuonota.nrocuota, IIF(INLIST(cabenotp.tiponota, 1, 3), tmpcuonota.monto_ndeb - tmpcuonota.monto, IIF(INLIST(cabenotp.tiponota, 2, 4), tmpcuonota.monto_ncre - tmpcuonota.monto, 0)))
      SELECT cuotas_c
      SET ORDER TO TAG indice1 OF cuotas_c.cdx
         
      IF SEEK(STR(cabenotp.tipodocu, 1) + STR(cabenotp.nrodocu, 9) + STR(cabenotp.proveedor, 5) + STR(cuotas_p.nrocuota, 3))
         IF INLIST(cabenotp.tiponota, 1, 3)
            REPLACE cuotas_c.monto_ndeb WITH (cuotas_c.monto_ndeb + cuotas_p.importe)
         ELSE
            IF INLIST(cabenotp.tiponota, 2, 4)
               REPLACE cuotas_c.monto_ncre WITH (cuotas_c.monto_ncre + cuotas_p.importe)
            ENDIF
         ENDIF
      ELSE
         WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR LA CUOTA N§: " + ALLTRIM(STR(cuotas_p.nrocuota, 3)) + " DE LA VENTA: " + ALLTRIM(STR(cabenotp.tipodocu, 1)) + "/" + ALLTRIM(STR(cabenotp.nrodocu, 9)) + " !"
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
*!  Descripci¢n: Borra la nota de debito o credito - proveedo.
*!
*!*********************************************************************
FUNCTION _DeleteInvoice

PUSH KEY CLEAR

*-- Actualiza el campo cuotas_c.monto_ndeb o cuotas_c.monto_ncre y borra la(s) cuota(s) de la nota de debito / credito.
SELECT cuotas_p
SET ORDER TO TAG indice1 OF cuotas_p.cdx

IF SEEK(STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5))
   SCAN WHILE STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5) = STR(cuotas_p.tiponota, 1) + STR(cuotas_p.nronota, 9) + STR(cuotas_p.proveedor, 5)
      SELECT cuotas_c
      SET ORDER TO TAG indice1 OF cuotas_c.cdx
      
      IF SEEK(STR(cabenotp.tipodocu, 1) + STR(cabenotp.nrodocu, 9) + STR(cabenotp.proveedor, 5) + STR(cuotas_p.nrocuota, 3))
         IF INLIST(cabenotp.tiponota, 1, 3)
            REPLACE cuotas_c.monto_ndeb WITH (cuotas_c.monto_ndeb - cuotas_p.importe)
         ELSE
            IF INLIST(cabenotp.tiponota, 2, 4)
               REPLACE cuotas_c.monto_ncre WITH (cuotas_c.monto_ncre - cuotas_p.importe)
            ENDIF
         ENDIF
      ELSE
         WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR LA CUOTA N§: " + ALLTRIM(STR(cuotas_p.nrocuota, 3)) + " DE LA VENTA: " + ALLTRIM(STR(cabenotp.tipodocu, 1)) + "/" + ALLTRIM(STR(cabenotp.nrodocu, 9)) + " !"
      ENDIF
      
      SELECT cuotas_p
      DELETE
   ENDSCAN
ENDIF

*-- Actualiza el campo maesprod.stock_actu y borra el detalle de la nota de debito o credito.
SELECT detanotp
SET ORDER TO TAG indice1 OF detanotp.cdx

IF SEEK(STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5))
   SCAN WHILE STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5) = STR(detanotp.tiponota, 1) + STR(detanotp.nronota, 9) + STR(detanotp.proveedor, 5)
      IF detanotp.tipo = "S"
         SELECT maesprod
         SET ORDER TO TAG indice1 OF maesprod.cdx
         
         IF SEEK(detanotp.articulo)
            IF INLIST(cabenotp.tiponota, 1, 3)
               REPLACE maesprod.stock_actu WITH (maesprod.stock_actu - detanotp.cantidad)
            ELSE
               IF INLIST(cabenotp.tiponota, 2, 4)
                  REPLACE maesprod.stock_actu WITH (maesprod.stock_actu + detanotp.cantidad)
               ENDIF
            ENDIF
         ELSE
            WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL ARTICULO: " + ALLTRIM(detanotp.articulo) + " !"
         ENDIF
      ENDIF
      SELECT detanotp
      DELETE
   ENDSCAN
ELSE
   IF cabenotp.tiponota <> 0 .AND. cabenotp.nronota <> 0
      WAIT WINDOW "­ NO SE HA ENCONTRADO DETALLE A BORRAR !"
   ENDIF
ENDIF

*-- Actualiza el campo proveedo.saldo_actu, si cabenotp.tipodocu = 2 y cabenotp.aplicontra = 2.
IF INLIST(cabenotp.tipodocu, 2, 6, 8) .AND. cabenotp.aplicontra = 2
   SELECT cabecomp
   SET ORDER TO TAG "indice1"
   SEEK STR(cabenotp.tipodocu, 1) + STR(cabenotp.nrodocu, 9) + STR(cabenotp.proveedor, 5)
  
   SELECT proveedo
   SET ORDER TO TAG "indice1"
   
   IF SEEK(cabenotp.proveedor)
      IF INLIST(cabenotp.tiponota, 1, 3)
         IF cabecomp.moneda = 1 THEN
            REPLACE saldo_actu WITH (saldo_actu - cabenotp.monto_nota)
         ELSE
            REPLACE saldo_usd  WITH (saldo_usd - cabenotp.monto_nota)
         ENDIF
      ELSE
         IF INLIST(cabenotp.tiponota, 2, 4)
            IF cabecomp.moneda = 1 THEN
               REPLACE saldo_actu WITH (saldo_actu + cabenotp.monto_nota)
            ELSE
               REPLACE saldo_usd  WITH (saldo_usd  + cabenotp.monto_nota)
            ENDIF
         ENDIF
      ENDIF
   ELSE
      IF cabenotp.tiponota <> 0 .AND. cabenotp.nronota <> 0
         WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DEL CLIENTE: " + ALLTRIM(STR(cabenotp.cliente, 5)) + " !"
      ENDIF
   ENDIF
ENDIF

*-- Actualiza el campo cabecomp.monto_ndeb o cabecomp.monto_ncre y borra el encabezado de la nota de debito / credito.
SELECT cabecomp
SET ORDER TO TAG indice1 OF cabecomp.cdx

IF SEEK(STR(cabenotp.tipodocu, 1) + STR(cabenotp.nrodocu, 9) + STR(cabenotp.proveedor, 5))
   IF INLIST(cabenotp.tiponota, 1, 3) .AND. cabenotp.aplicontra = 2
      REPLACE cabecomp.monto_ndeb WITH (cabecomp.monto_ndeb - cabenotp.monto_nota)
   ELSE
      IF INLIST(cabenotp.tiponota, 2, 4) .AND. cabenotp.aplicontra = 2
         REPLACE cabecomp.monto_ncre WITH (cabecomp.monto_ncre - cabenotp.monto_nota)
      ENDIF
   ENDIF
ELSE
   IF cabenotp.tiponota <> 0 .AND. cabenotp.nronota <> 0
      WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL SALDO DE LA COMPRA: " + ALLTRIM(STR(cabenotp.tipodocu, 1)) + "/" + ALLTRIM(STR(cabenotp.nrodocu, 9)) + " !" 
   ENDIF
ENDIF

SELECT cabenotp
SET ORDER TO TAG indice1 OF cabenotp.cdx

IF SEEK(STR(m.tiponota, 1) + STR(m.nronota, 9) + STR(m.proveedor, 5))
   SCAN WHILE STR(m.tiponota, 1) + STR(m.nronota, 9) + STR(m.proveedor, 5) = STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5)
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
*!  Descripci¢n: Borra la nota de debito o credito - proveedo.
*!
*!*********************************************************************
FUNCTION _LoadMaestemp 

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT maestemp
ZAP

SELECT detacomp
SET ORDER TO TAG indice1 OF detacomp.cdx

IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 9) + STR(m.proveedor, 5))
   SCAN WHILE STR(m.tipodocu, 1) + STR(m.nrodocu, 9) + STR(m.proveedor, 5) = STR(detacomp.tipodocu, 1) + STR(detacomp.nrodocu, 9) + STR(detacomp.proveedor, 5)
      SELECT maesprod
      SET ORDER TO TAG indice1 OF maesprod.cdx
   
      IF SEEK(detacomp.articulo)
         INSERT INTO maestemp (codigo, codigo2, codorig, nombre, lista3, lista4, lista5, familia, rubro, subrubro, marca, unidad, proveedor, procedenci, ubicacion, vigente, lprecio, impuesto, pimpuesto, pcostog, pcostod, pventag1, pventag2, pventag3, pventag4, pventag5, pventad1, pventad2, pventad3, pventad4, pventad5, paumento1, paumento2, paumento3, paumento4, paumento5, stock_min, stock_max, polinvsmin, polinvsmax, garantia, caracter1, caracter2, caracter3, otros1, otros2, fecucompra, fecrepo, stock_actu, stock_ot, cantidad) ;
            VALUES (detacomp.articulo, maesprod.codigo2, maesprod.codorig, maesprod.nombre, maesprod.lista3, maesprod.lista4, maesprod.lista5, maesprod.familia, maesprod.rubro, maesprod.subrubro, maesprod.marca, maesprod.unidad, maesprod.proveedor, maesprod.procedenci, maesprod.ubicacion, maesprod.vigente, maesprod.lprecio, detacomp.impuesto, detacomp.pimpuesto, maesprod.pcostog, maesprod.pcostod, IIF(cabecomp.porcdesc > 0, ROUND(detacomp.precio * (1 - cabecomp.porcdesc / 100), 4), IIF(cabecomp.descuento > 0, ROUND(detacomp.precio * (1 - cabecomp.descuento / 100), 4), detacomp.precio)), maesprod.pventag2, maesprod.pventag3, maesprod.pventag4, maesprod.pventag5, maesprod.pventad1, maesprod.pventad2, maesprod.pventad3, maesprod.pventad4, maesprod.pventad5, maesprod.paumento1, maesprod.paumento2, maesprod.paumento3, maesprod.paumento4, maesprod.paumento5, maesprod.stock_min, maesprod.stock_max, maesprod.polinvsmin, maesprod.polinvsmax, maesprod.garantia, maesprod.caracter1, maesprod.caracter2, maesprod.caracter3, maesprod.otros1, maesprod.otros2, maesprod.fecucompra, maesprod.fecrepo, maesprod.stock_actu, maesprod.stock_ot, detacomp.cantidad)
      ELSE 
         WAIT WINDOW "­ ERROR, NO SE PUDO ENCONTRAR EL ARTICULO: "+ ALLTRIM(detacomp.articulo) + " !"
      ENDIF
      SELECT detacomp
   
   ENDSCAN
ELSE
   WAIT WINDOW "­ LA COMPRA: " + ALLTRIM(STR(m.tipodocu, 1)) + "/" + ALLTRIM(STR(m.nrodocu, 9)) + " NO POSEE DETALLE !"
ENDIF

SELECT cabenotp
SET ORDER TO TAG indice3 OF cabenotp.cdx

IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 9) + STR(m.proveedor, 5))
   SCAN WHILE STR(m.tipodocu, 1) + STR(m.nrodocu, 9) + STR(m.proveedor, 5) = STR(cabenotp.tipodocu, 1) + STR(cabenotp.nrodocu, 9) + STR(cabenotp.proveedor, 5)
      SELECT detanotp
      SET ORDER TO indice1 OF detanotp.cdx
      IF SEEK(STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5))
         SCAN WHILE STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5) = STR(detanotp.tiponota, 1) + STR(detanotp.nronota, 9) + STR(detanotp.proveedor, 5)
            SELECT maestemp
            SET ORDER TO TAG indice1
      
            IF SEEK(detanotp.articulo)
               IF detanotp.tipo = "S"
                  REPLACE maestemp.cantidad WITH (maestemp.cantidad - detanotp.cantidad)
               ENDIF
            ENDIF
            SELECT detanotp
         ENDSCAN
      ENDIF
      SELECT cabenotp
   ENDSCAN
ENDIF

DO _LoadQuota

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

