*:*********************************************************************
*:
*: Archivo de Procedimiento: MOVIOT.PRG
*:
*:                  Sistema: Integrado de Gesti¢n Financiera.
*:              Sub-Sistema: Movimientos de  Art¡culos  por  Ordenes de
*:                           Trabajo.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 28/02/2004
*:
*:*********************************************************************
WAIT WINDOW "POR FAVOR, ESPERE MIENTRAS SE CARGA EL MODULO..." NOWAIT
*-- Variables de la tabla.
PRIVATE m.tipobole, m.serie, m.nrobole, m.fecha, m.lstprecio, m.monto_fact, m.obs1, m.obs2, m.cliente, m.mecanico, m.estadoot, m.marca, m.modelo, m.maquina, m.localrep, m.referencia

*-- Variables para c lculos del programa.
PRIVATE pnGravada, pnExenta, pnImpuesto, pnSubTotal, pcDelete

*-- Inicializa variables del programa.
STORE .F. TO plAdding, plEditing

*-- MS-DOS  Definiciones de ventanas.
IF .NOT. WEXIST("tmpdetmot")
   DEFINE WINDOW tmpdetmot ;
      FROM 06,00 ;
      TO 19,79 ;
      TITLE "DETALLE" ;
      NOFLOAT ;
      CLOSE ;
      NOSHADOW ;
      ZOOM ;
      NOMINIMIZE ;
      SYSTEM ;
      COLOR SCHEME 15
ENDIF

IF .NOT. WEXIST("brwMoviOt")
   DEFINE WINDOW brwMoviOt ;
      FROM 01,00 ;
      TO 23,79 ;
      TITLE "< MOVIMIENTOS DE ARTICULOS POR ORDENES DE TRABAJO >" ;
      NOFLOAT ;
      CLOSE ;
      NOSHADOW ;
      ZOOM ;
      NOMINIMIZE ;
      SYSTEM ;
      COLOR SCHEME 15
ENDIF

*-- MS-DOS Base de datos, ¡ndices, relaciones.
SELECT 0
temp01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp01 (tipobole   N(01) ,;
                      serie      C(01) ,;
                      nrobole    N(07) ,;
                      articulo   C(15) ,;
                      cantidad   N(09,2) ,;
                      precio     N(13,4) ,;
                      pdescuento N(07,4) ,;
                      impuesto   L(01) ,;
                      pimpuesto  N(06,2) ,;
                      mecanico   N(03) ,;
                      comision_m N(06,2) ,;
                      descr_trab C(40))

USE &temp01 ALIAS tmpdetmot EXCLUSIVE
INDEX ON STR(tipobole, 1) + serie + STR(nrobole, 7) TAG indice1
INDEX ON articulo                                   TAG indice2
SET RELATION TO tmpdetmot.articulo INTO maesprod ,;        
                tmpdetmot.mecanico INTO mecanico ADDITIVE

WAIT CLEAR

SELECT cabemot 
GO TOP

*--- Establece relaciones entre las tablas.
SET RELATION TO cabemot.serie + STR(cabemot.nrobole, 7) INTO ot ADDITIVE

SCATTER MEMVAR MEMO

DO _RefreshInvoice

*-- Bucle principal del programa.
DO WHILE .T.  
   pnKey = INKEY(0, "HM")         && Tomar INKEY(), ocultar cursor, comprobar rat¢n.
   IF pnKey = 0                   && No hay pulsaci¢n de tecla ni rat¢n.
      LOOP
   ENDIF
   IF pnKey = 27                  && Tecla ESC presionada,              
      EXIT                        && salir del bucle principal.
   ENDIF
   IF pnKey = 151                 && Clic sencillo del rat¢n.
      LOOP
   ENDIF
   DO CASE
      CASE pnKey = -1             && Tecla F2 presionada, agregar registro.
         DO mkmoviot.prg WITH "Add"
         DO _RefreshInvoice
      CASE pnKey = -2             && Tecla F3 presionada, modificar registro.
         DO mkmoviot.prg WITH "Edit"
         DO _RefreshInvoice
      CASE pnKey = -7             && Tecla F8 presionada, eliminar registro
         DO _DeleteInvoice
      CASE pnKey = 5              && Tecla  presionada, siguiente registro.
         DO _NextRecord
      CASE pnKey = 24             && Tecla  presionada, registro anterior.
         DO _PriorRecord         
      CASE pnKey = 19             && Tecla  presionada, primer registro.
         DO _TopRecord
      CASE pnKey = 4              && Tecla -> presionada, £ltimo registro.
         DO _BottomRecord
      CASE INLIST(pnKey, 68, 100) && Tecla "D" may£scula o min£scula, examinar detalle.
         DO _brwDetail
      CASE pnKey = -3             && Tecla F4 presionada, ordenar.         
         DO orden03.spr
      CASE pnKey = -9             && Tecla F10 presionada, examinar notas.
         ON KEY LABEL "F4" DO motorden.spr
         ON KEY LABEL "F5" DO _MoviOtSwitch

         DO _brwMoviOt 

         ON KEY LABEL "F4" 
         ON KEY LABEL "F5" 

         DO _RefreshInvoice
      CASE pnKey = -4             && Tecla F5 presionada, buscar.
         DO _MoviOtSwitch
      CASE pnKey = 1              && CTRL+A, Actualizaci¢n de precios.
         IF ot.estadoot = 6
            WAIT WINDOW "­ ESTE MOVIMIENTO DE OT YA HA SIDO FACTURADO, IMPOSIBLE MODIFICARLO !"
         ELSE
            =updMovOt(cabemot.serie, cabemot.nrobole, cabemot.lstprecio)
            DO _RefreshInvoice
         ENDIF
      ENDCASE
ENDDO     Fin del bucle principal.     
        

*-- MS-DOS Cierre de Bases de Datos.
IF USED("tmpdetmot")
   SELECT tmpdetmot 
   USE
ENDIF

DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"

*-- Quiebra las relaciones entre las tablas.
SELECT cabemot
SET RELATION OFF INTO ot 

*-- Elimina ventanas.
IF WEXIST("tmpdetmot")
   RELEASE WINDOW tmpdetmot
ENDIF

IF WEXIST("brwMoviOt")
   RELEASE WINDOW brwMoviOt
ENDIF

*-- MS-DOS Procedimientos y funciones de soporte.
*!*********************************************************************
*!
*!      Funci¢n: _RefreshInvoice
*!
*!  Llamado por: MOVIOT.PRG                  
*!
*!  Descripci¢n: Actualiza  la  visualizaci¢n  del  formato,  cabecera, 
*!               detalle y pie del movimiento de orden de trabajo.
*!
*!*********************************************************************
FUNCTION _RefreshInvoice

DO _fmtInvoice
DO _ShowHeader
DO _ShowDetail
DO _InvoiceFoot

*!*********************************************************************
*!
*!      Funci¢n: _fmtInvoice  
*!
*!  Llamado por: _RefreshInvoice
*!
*!  Descripci¢n: Dibuja el formato del movimiento de orden de trabajo.
*!
*!*********************************************************************
FUNCTION _fmtInvoice
@ 01,00 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 02,00 SAY "³ OT N§...:              Fecha:                Lista de Precios N§:            ³"
@ 03,00 SAY "³ Cliente.:                                                                    ³"
@ 04,00 SAY "³ Mec nico:                                    Estado OT:                      ³"
@ 05,00 SAY "³ M quina.:                                                                    ³"
@ 06,00 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ´"
@ 07,00 SAY "³ Descripci¢n                            ³ Cantidad ³ Precio Unit.  ³ Importe  ³"
@ 08,00 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ´"
@ 09,00 SAY "³                                        ³          ³               ³          ³"
@ 10,00 SAY "³                                        ³          ³               ³          ³"
@ 11,00 SAY "³                                        ³          ³               ³          ³"
@ 12,00 SAY "³                                        ³          ³               ³          ³"
@ 13,00 SAY "³                                        ³          ³               ³          ³"
@ 14,00 SAY "³                                        ³          ³               ³          ³"
@ 15,00 SAY "³                                        ³          ³               ³          ³"
@ 16,00 SAY "³                                        ³          ³               ³          ³"
@ 17,00 SAY "³                                        ³          ³               ³          ³"
@ 18,00 SAY "³                                        ³          ³               ³          ³"
@ 19,00 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´"
@ 20,00 SAY "³Local de Rep.:                     Ref.:              SUB-TOTALES:            ³"
@ 21,00 SAY "³Obs.:                                                      I.V.A.:            ³"
@ 22,00 SAY "³                                                    TOTAL GENERAL:            ³"
@ 23,00 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

*!*********************************************************************
*!
*!      Funci¢n: _ShowHeader
*!
*!  Llamado por: _RefreshInvoice
*!
*!  Descripci¢n: Carga la cabecera del movimiento de orden de trabajo.
*!
*!*********************************************************************
FUNCTION _ShowHeader 

SELECT cabemot
SCATTER MEMVAR

SELECT ot
SET ORDER TO TAG indice1 OF ot.cdx

IF .NOT. SEEK(cabemot.serie + STR(cabemot.nrobole, 7))
   IF .NOT. EMPTY(m.serie) .AND. m.nrobole <> 0
      WAIT WINDOW "NO SE ENCONTRO LA OT N§: " + cabemot.serie + "/" + ALLTRIM(STR(cabemot.nrobole, 7))
   ENDIF
   STORE 0 TO m.cliente, m.mecanico, m.estadoot, m.maquina, m.marca, m.modelo, m.localrep, m.accesorio
   m.referencia = SPACE(01)
ELSE
   m.cliente    = ot.cliente
   m.mecanico   = ot.mecanico
   m.estadoot   = ot.estadoot
   m.maquina    = ot.maquina
   m.marca      = ot.marca
   m.modelo     = ot.modelo
   m.accesorio  = ot.accesorio
   m.localrep   = ot.localrep
   m.referencia = ot.referencia
ENDIF

@ 02,12 SAY m.serie ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W

@ 02,14 SAY m.nrobole ;
   SIZE 1,7 ;
   PICTURE "9999999" ;
   COLOR N/W

@ 02,32 SAY m.fecha ;
   SIZE 1,10 ;
   PICTURE "@D" ;
   COLOR N/W

@ 02,68 SAY m.lstprecio ;
   SIZE 1,1 ;
   PICTURE "9" ;
   COLOR N/W

@ 03,12 SAY m.cliente ;
   SIZE 1,5 ;
   PICTURE "99999" ;
   COLOR N/W

@ 03,19 SAY ot.nombreot ;
   SIZE 1,40 ;
   PICTURE "@!" ;
   COLOR W/N

@ 04,12 SAY m.mecanico ;
   SIZE 1,3 ;
   PICTURE "999" ;
   COLOR N/W

*-- Imprime el nombre del mecanico.
SELECT mecanico
SET ORDER TO TAG indice1 OF mecanico.cdx

IF SEEK(m.mecanico)
   @ 04,19 SAY PADR(ALLTRIM(mecanico.nombre), 26, CHR(32)) ;
      SIZE 1,25 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 04,19 SAY REPLICATE(CHR(32), 25) ;
      SIZE 1,25 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

SELECT cabemot

@ 04,58 SAY m.estadoot ;
   SIZE 1,3 ;
   PICTURE "999" ;
   COLOR N/W

*-- Imprime el nombre del estado de la orden de trabajo.
SELECT estadoot
SET ORDER TO TAG indice1 OF estadoot.cdx

IF SEEK(m.estadoot)
   @ 04,63 SAY PADR(ALLTRIM(estadoot.nombre), 15, CHR(32)) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR W/N
ELSE
   @ 04,63 SAY REPLICATE(CHR(32), 15) ;
      SIZE 1,15 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

SELECT cabemot

*-- Imprime el nombre de la marca y el del modelo.
SELECT maquinas
SET ORDER TO TAG indice1 OF maquinas.cdx

IF .NOT. SEEK(m.maquina) .AND. m.maquina <> 0
   @ 05,12 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR N/W
   WAIT WINDOW "NO SE ENCONTRO LA MAQUINA N§: " + ALLTRIM(STR(ot.maquina, 3))
ENDIF

SELECT marcas2
SET ORDER TO TAG indice1 OF marcas2.cdx

IF .NOT. SEEK(m.marca) .AND. m.marca <> 0
   @ 05,12 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR N/W
   WAIT WINDOW "NO SE ENCONTRO LA MARCA N§: " + ALLTRIM(STR(ot.marca, 4))
ENDIF

SELECT modelos
SET ORDER TO TAG indice1 OF modelos.cdx

IF .NOT. SEEK(m.modelo) .AND. m.modelo <> 0
   @ 05,12 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR N/W
   WAIT WINDOW "NO SE ENCONTRO EL MODELO N§: " + ALLTRIM(STR(ot.modelo, 4))
ENDIF

@ 05,12 SAY PADR(ALLTRIM(maquinas.nombre) + " " + ALLTRIM(marcas2.nombre) + " " + ALLTRIM(modelos.nombre) , 30, CHR(32)) ;
   SIZE 1,30 ;
   PICTURE "@!" ;
   COLOR N/W

SELECT cabemot

@ 05,44 SAY PADR(ALLTRIM(ot.accesorio), 35, CHR(32)) ;
   SIZE 1,35 ;
   PICTURE "@!" ;
   COLOR N/W

@ 20,16 SAY m.localrep ;
   SIZE 1,2 ;
   PICTURE "99" ;
   COLOR N/W

*-- Imprime el nombre del local de reparaci¢n.
IF m.localrep <> 0
   SELECT locales  
   SET ORDER TO indice1 OF locales.cdx

   IF SEEK(m.localrep)
      @ 20,20 SAY PADR(ALLTRIM(locales.nombre), 14, CHR(32)) ;
         SIZE 1,14 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 20,20 SAY REPLICATE(CHR(32), 14) ;
         SIZE 1,14 ;
         PICTURE "@!" ;
         COLOR W/N
   ENDIF
ELSE
   @ 20,20 SAY REPLICATE(CHR(32), 14) ;
      SIZE 1,14 ;
      PICTURE "@!" ;
      COLOR W/N
ENDIF

SELECT cabemot

@ 20,42 SAY m.referencia ;
   SIZE 1,10 ;
   PICTURE "@!" ;
   COLOR N/W

@ 21,07 SAY PADR(ALLTRIM(m.obs1), 45, CHR(32)) ;
   SIZE 1,45 ;
   PICTURE "@!" ;
   COLOR N/W

@ 22,07 SAY PADR(ALLTRIM(m.obs2), 45, CHR(32)) ;
   SIZE 1,45 ;
   PICTURE "@!" ;
   COLOR N/W



*!*********************************************************************
*!
*!      Funci¢n: _ShowDetail
*!
*!  Llamado por: _RefreshInvoice
*!
*!  Descripci¢n: Carga el detalle de la factura y lo visualiza.
*!
*!*********************************************************************
FUNCTION _ShowDetail

SELECT tmpdetmot     &&   Vac¡a la  tabla  temporal  que  contiene  el
ZAP                  &&   detalle de art¡culos del documento.

SELECT detamot 
SET ORDER TO TAG indice1

IF SEEK(STR(cabemot.tipobole, 1) + cabemot.serie + STR(cabemot.nrobole, 7))
   SCAN WHILE (STR(cabemot.tipobole, 1) + cabemot.serie + STR(cabemot.nrobole, 7)) = (STR(detamot.tipobole, 1) + detamot.serie + STR(detamot.nrobole, 7))
      INSERT INTO tmpdetmot (tipobole, serie, nrobole, articulo, cantidad, precio, pimpuesto, impuesto, mecanico, descr_trab) ;
         VALUES (detamot.tipobole, detamot.serie, detamot.nrobole, detamot.articulo, detamot.cantidad, detamot.precio, detamot.pimpuesto, detamot.impuesto, detamot.mecanico, detamot.descr_trab) 
   ENDSCAN
ELSE
  IF cabemot.tipobole <> 0 .AND. cabemot.nrobole <> 0
     WAIT WINDOW "ESTE MOVIMIENTO DE OT NO POSEE DETALLE, BORRELO Y VUELVA A CARGARLO"
  ENDIF
ENDIF

SELECT cabemot
DO _PrintDetail
   
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

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

#DEFINE pnRow    8
#DEFINE pnColumn 1

SELECT tmpdetmot 
SET ORDER TO 0
GO TOP

SCAN WHILE RECNO() <= 10 .AND. .NOT. (EMPTY(articulo) .OR. EMPTY(cantidad) .OR. EMPTY(precio))
   @ pnRow + RECNO(), pnColumn + 1  SAY IIF(EMPTY(descr_trab), SUBSTR(maesprod.nombre, 1, 39), SUBSTR(descr_trab, 1, 39)) COLOR N/W
   @ pnRow + RECNO(), pnColumn + 41 SAY cantidad                       PICTURE "999,999.99"                               COLOR N/W
   @ pnRow + RECNO(), pnColumn + 52 SAY precio                         PICTURE "99,999,999.9999"                          COLOR N/W
   @ pnRow + RECNO(), pnColumn + 68 SAY ROUND(precio * cantidad, 0)    PICTURE "99,999,999"                               COLOR N/W
ENDSCAN

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _InvoiceFoot   
*!
*!  Llamado por: _RefreshInvoice
*!
*!  Descripci¢n: Imprime el pie del documento.
*!
*!*********************************************************************
FUNCTION _InvoiceFoot

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

SELECT tmpdetmot 
GO TOP

STORE 0 TO m.monto_fact, pnGravada, pnExenta, pnImpuesto, pnSubTotal

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
m.monto_fact = pnSubTotal + pnImpuesto

@ 20,68 SAY pnSubTotal ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

@ 21,68 SAY pnImpuesto ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR N/W

@ 22,68 SAY m.monto_fact ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR B/W

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

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

IF SEEK(STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7))
   SCAN WHILE STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7) = STR(cuotas_v.tipodocu, 1) + STR(cuotas_v.nrodocu, 7)
      INSERT INTO tmpcuonota (tipodocu, nrodocu, tipo, nrocuota, fecha, importe, abonado, monto_ndeb, monto_ncre) ;
         VALUES (cuotas_v.tipodocu, cuotas_v.nrodocu, cuotas_v.tipo, cuotas_v.nrocuota, cuotas_v.fecha, cuotas_v.importe, cuotas_v.abonado, cuotas_v.monto_ndeb, cuotas_v.monto_ncre)
   ENDSCAN
ELSE
  IF .NOT. cabevent.anulado .AND. cabevent.tipodocu = 2
     WAIT WINDOW "     ­ ESTE DOCUMENTO NO POSEE CUOTAS !" + CHR(13) + ;
                 "MODIFIQUELO PARA VOLVER A GENERAR LAS CUOTAS"
  ENDIF
ENDIF

SELECT cabenotc

*!*********************************************************************
*!
*!      Funci¢n: _brwDetail     
*!
*!  Llamado por: VENTAS.PRG       
*!
*!  Descripci¢n: Examina el detalle de art¡culos del documento.
*!
*!*********************************************************************
FUNCTION _brwDetail 

SELECT tmpdetmot 
GO TOP

BROWSE WINDOW tmpdetmot  FIELDS ;
   calc_f0 = SUBSTR(articulo, 1, 13)        :R:13:H = "C¢digo" ,;
   calc_f1 = IIF(EMPTY(descr_trab), SUBSTR(maesprod.nombre, 1, 36), SUBSTR(descr_trab, 1, 36)) :R:36:H = "Descripci¢n"  :P = "@!" :W = .F. ,;
   cantidad                                 :R:09:H = "Cantidad"     :P = "999999.99" ,;
   precio                                   :R:15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = .F. ,;
   calc_f2 = ROUND(precio * cantidad, 0)    :R:15:H = "Sub-Total"    :P = "999,999,999,999" ,;
   mecanico                                 :R:03:H = "Mec"          :P = "999" ,; 
   calc_f3 = SUBSTR(mecanico.nombre, 1, 30) :R:30:H = "Nombre del Mec nico" :P = "@!" :W = .F. ,;
   calc_f4 = IIF(impuesto, "   S¡", "")     :R:08:H = "Impuesto"     :W = .F. ,;
   pimpuesto                                :R:06:H = "% Imp."       :P = "999.99" ;
   NOAPPEND NODELETE NOMODIFY

SELECT cabemot 

*!*********************************************************************
*!
*!      Funci¢n: _brwMoviOt   
*!
*!  Llamado por: MOVIOT.PRG       
*!
*!  Descripci¢n: Examina los movimientos cargados.
*!
*!*********************************************************************
FUNCTION _brwMoviOt

SELECT cabemot

BROWSE WINDOW brwMoviOt FIELDS ;
   calc_f1 = serie + " " + STR(nrobole, 7) :R:09:H = "OT N§" ,;
   fecha                                   :R:10:P = "@D"          :H = "Fecha" ,;
   monto_fact                              :R:11:P = "999,999,999" :H = "Importe" ,;
   calc_f2 = SUBSTR(ot.nombreot, 1, 40)    :R:40:P = "@!"          :H = "Cliente" ;
   NOAPPEND NODELETE NOMODIFY

*!*********************************************************************
*!
*!      Funci¢n: _MoviOtSwitch
*!
*!  Llamado por: MOVIOT.PRG       
*!
*!  Descripci¢n: Selecciona el tipo de ventana a desplegar  para reali-
*!               zar la b£squeda.
*!
*!*********************************************************************
FUNCTION _MoviOtSwitch

PUSH KEY CLEAR

IF EOF()
   DO WHILE .T.
      WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
      IF UPPER(pcAppend) = "S"
         DO mkmoviot.prg WITH "Add"
         DO _RefreshInvoice
         EXIT DO
      ENDIF
      IF UPPER(pcAppend) = "N"
         EXIT DO
      ENDIF
   ENDDO    
   POP KEY
   RETURN
ENDIF

DO CASE
   CASE LOWER(TAG()) = "indice1"
      DO buscar11.spr
   CASE LOWER(TAG()) = "indice2"
      DO buscar09.spr
ENDCASE

POP KEY

IF FOUND()
   DO _RefreshInvoice
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _DeleteInvoice
*!
*!  Llamado por: MKNOTA_C.PRG       
*!
*!  Descripci¢n: Borra o anula la nota de debito o credito - clientes.
*!
*!*********************************************************************
FUNCTION _DeleteInvoice

PUSH KEY CLEAR

IF EOF()
   DO WHILE .T.
      WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
      IF UPPER(pcAppend) = "S"
         DO mkmoviot.prg WITH "Add"
         DO _RefreshInvoice
         EXIT DO
      ENDIF
      IF UPPER(pcAppend) = "N"
         EXIT DO
      ENDIF
   ENDDO    
   POP KEY
   RETURN
ENDIF

IF ot.estadoot = 6
   WAIT WINDOW "­ ESTE MOVIMIENTO DE LA OT YA HA SIDO FACTURADO, IMPOSIBLE BORRARLO !" 
   POP KEY
   RETURN
ENDIF

DO WHILE .T.
   WAIT WINDOW "¨ DESEA BORRAR ESTE MOVIMIENTO DE LA OT ? [S/N]" TO pcDelete  

   IF INLIST(UPPER(pcDelete), "S", "N")
      EXIT DO
   ENDIF

ENDDO

IF UPPER(pcDelete) = "S"
   PUSH KEY CLEAR
   
   *-- Borra detalle del comprobante de venta y actualiza la existencia de mercader¡as.
   SELECT detamot
   SET ORDER TO TAG indice1 OF detamot.cdx

   IF SEEK(STR(cabemot.tipobole, 1) + cabemot.serie + STR(cabemot.nrobole, 7))
      SCAN WHILE (STR(cabemot.tipobole, 1) + cabemot.serie + STR(cabemot.nrobole, 7)) = (STR(detamot.tipobole, 1) + detamot.serie + STR(detamot.nrobole, 7))
         SELECT maesprod
         SET ORDER TO TAG indice1 OF maesprod.cdx

         IF SEEK(detamot.articulo)
            REPLACE maesprod.stock_ot WITH (maesprod.stock_ot - detamot.cantidad)
         ELSE
            WAIT WINDOW "­ IMPOSIBLE ACTUALIZAR EL ARTICULO: " + ALLTRIM(detamot.articulo) + " !"
         ENDIF
         SELECT detamot
         DELETE
      ENDSCAN
   ELSE
      IF cabemot.tipobole <> 0 .AND. cabemot.nrobole <> 0
         WAIT WINDOW "­ NO SE HA ENCONTRADO DETALLE A BORRAR !"
      ENDIF
   ENDIF
  
   *-- Cambia el estado de la orden de trabajo
   SELECT ot
   REPLACE ot.estadoot WITH 5
   
   *-- Borra el encabezado del comprobante de venta.
   SELECT cabemot
   SET ORDER TO TAG indice1 OF cabemot.cdx

   IF SEEK(STR(m.tipobole, 1) + m.serie + STR(m.nrobole, 7))
      SCAN WHILE (STR(m.tipobole, 1) + m.serie + STR(m.nrobole, 7)) = (STR(cabemot.tipobole, 1) + cabemot.serie + STR(cabemot.nrobole, 7))
         DELETE
      ENDSCAN
   ENDIF

   IF EOF()
      IF NOT BOF()
         SKIP -1 
         IF BOF("cabemot")
            GO TOP
         ELSE
*           DO _RefreshInvoice
         ENDIF
      ENDIF
   ENDIF

ENDIF

DO _RefreshInvoice
POP KEY

*!*********************************************************************
*!
*!      Funci¢n: _NextRecord    
*!
*!  Llamado por: VENTAS.PRG
*!
*!  Descripci¢n: Desplaza el puntero de registro al siguiente registro.
*!
*!*********************************************************************
FUNCTION _NextRecord
IF NOT EOF()
   SKIP 1
   IF EOF("cabemot")           
      WAIT WINDOW "­ FIN DE LA TABLA !" NOWAIT
      SKIP -1
   ELSE
      DO _RefreshInvoice
   ENDIF
ELSE
   WAIT WINDOW "­ FIN DE LA TABLA !" NOWAIT
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _PriorRecord    
*!
*!  Llamado por: VENTAS.PRG
*!
*!  Descripci¢n: Desplaza el puntero de registro al registro anterior.
*!
*!*********************************************************************
FUNCTION _PriorRecord
IF NOT BOF()
   SKIP -1
   IF BOF("cabemot")
      WAIT WINDOW "­ INICIO DE LA TABLA !" NOWAIT
      GO TOP
   ELSE
      DO _RefreshInvoice
   ENDIF
ELSE
   WAIT WINDOW "­ INICIO DE LA TABLA !" NOWAIT            
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _TopRecord    
*!
*!  Llamado por: VENTAS.PRG
*!
*!  Descripci¢n: Desplaza el puntero de registro al primer registro.
*!
*!*********************************************************************
FUNCTION _TopRecord
GO TOP 
IF NOT BOF()
   DO _RefreshInvoice
ELSE
   WAIT WINDOW "­ INICIO DE LA TABLA !" NOWAIT
ENDIF

*!*********************************************************************
*!
*!      Funci¢n: _BottomRecord 
*!
*!  Llamado por: VENTAS.PRG
*!
*!  Descripci¢n: Desplaza el puntero de registro al £ltimo registro.
*!
*!*********************************************************************
FUNCTION _BottomRecord
GO BOTTOM
IF NOT EOF()
   DO _RefreshInvoice
ELSE
   WAIT WINDOW "­ FIN DE LA TABLA !" NOWAIT
ENDIF
