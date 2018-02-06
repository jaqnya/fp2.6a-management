*:**************************************************************************
*:
*: Archivo de Procedimiento: OT.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: ABM para Ordenes de Trabajo.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 08/05/2004
*:
*:**************************************************************************
PARAMETER cWhatToDo

*-- Variables de la Tabla.
PRIVATE m.serie, m.nroot, m.cliente, m.nombreot, m.contacto, m.direcot, m.telefot, m.cedulaot, m.departamen, m.ciudad, m.barrio, m.maquina, m.marca, m.modelo, m.accesorio, m.motor, m.chasis, m.mecanico, m.chapa, m.color, m.km, m.frecepcion, m.fpentrega, m.trabajo1, m.trabajo2, m.trabajo3, m.fentrega, m.estadoot, m.tipodocu, m.nrodocu, m.referencia, m.localrep, m.id_local, m.fecha, m.monto_fact

*-- Variables para c lculos del programa.
PRIVATE plAdding, plEditing, plDeleting, pnChoice, pcAppend, pnSelect, pcOrder, pnRecNo, plFound, pnSaveWarn

DO CASE
   CASE cWhatToDo = "Add"
      IF .NOT. UserConfig("brwOt.prg", "Add", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT ot
      SCATTER MEMVAR MEMO BLANK

      plAdding     = .T.
      plEditing    = .F.
      plDeleting   = .F.
      pnSaveWarn   = 0
      
      DO ot.spr

      IF pnSaveWarn = 1     
         APPEND BLANK
         GATHER MEMVAR MEMO
      ENDIF

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      pnSaveWarn   = 0
      
      POP KEY
   CASE cWhatToDo = "Edit"
      IF .NOT. UserConfig("brwOt.prg", "Edit", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT ot

      IF DELETED()
         WAIT WINDOW "ESTA OT YA HA SIDO BORRADA, NO SE PUEDE EFECTUAR MODIFICACIONES !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO ot.prg WITH "Add"
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
      pnSaveWarn   = 0
      
      DO ot.spr

      UNLOCK IN ot
      
      IF pnSaveWarn = 1     
         GATHER MEMVAR MEMO
      ENDIF

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      pnSaveWarn   = 0
      
      POP KEY
   CASE cWhatToDo = "Delete"
      IF .NOT. UserConfig("brwOt.prg", "Delete", .T.)
         RETURN
      ENDIF

      PUSH KEY CLEAR

      SELECT ot

      IF DELETED()
         WAIT WINDOW "­ ESTA ORDEN DE TRABAJO YA HA SIDO BORRADA !"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO ot.prg WITH "Add"
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

      SELECT cabemot
      SET ORDER TO TAG indice1 OF cabemot.cdx

      IF SEEK(STR(2, 1) + ot.serie + STR(ot.nroot, 7))
         ?? CHR(7)             
         WAIT WINDOW "OT UTILIZADA EN LA TABLA DE MOVIMIENTOS, IMPOSIBLE BORRARLA !"
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
         DO WHILE .T.
            WAIT WINDOW "¨ DESEA BORRARLO ? [S/N]" TO pcDeleteIt
            IF INLIST(UPPER(pcDeleteIt), "S", "N")
               EXIT DO
            ENDIF
         ENDDO   

         IF UPPER(pcDeleteIt) = "S" 
            DELETE
         ENDIF
      ENDIF
      
      UNLOCK IN ot

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
                     DO ot.prg WITH "Add"
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
      
      SELECT ot

      IF DELETED()
         WAIT WINDOW "­ ESTE ORDEN DE TRABAJO YA HA SIDO BORRADO !" + CHR(13) + ;
                     "           NO SE PUEDE VISUALIZAR"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO ot.prg WITH "Add"
               EXIT DO
            ENDIF
            IF UPPER(pcAppend) = "N"
               EXIT DO
            ENDIF
         ENDDO    
         POP KEY
         RETURN
      ENDIF

*!*	      IF .NOT. RLOCK()
*!*	         WAIT WINDOW "­ ESTE REGISTRO ESTA SIENDO UTILIZADO POR OTRO USUARIO !"
*!*	         POP KEY
*!*	         RETURN         
*!*	      ENDIF

      SCATTER MEMVAR MEMO
      
      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .T.
      
      DO ot1.spr

*!*	      UNLOCK IN ot

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .F.

      POP KEY
   CASE cWhatToDo = "Detail"
      PUSH KEY CLEAR
      
      SELECT ot

      IF DELETED()
         WAIT WINDOW "­ ESTE ORDEN DE TRABAJO YA HA SIDO BORRADO !" + CHR(13) + ;
                     "     NO SE PUEDE  VISUALIZAR EL DETALLE"
         POP KEY
         RETURN
      ENDIF

      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO ot.prg WITH "Add"
               EXIT DO
            ENDIF
            IF UPPER(pcAppend) = "N"
               EXIT DO
            ENDIF
         ENDDO    
         POP KEY
         RETURN
      ENDIF

*!*	      IF .NOT. RLOCK()
*!*	         WAIT WINDOW "­ ESTE REGISTRO ESTA SIENDO UTILIZADO POR OTRO USUARIO !"
*!*	         POP KEY
*!*	         RETURN
*!*	      ENDIF

      SCATTER MEMVAR MEMO
      
      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .T.
      
      IF INLIST(ot.estadoot, 3, 15) THEN
         SELECT cabemot2
         SET ORDER TO TAG indice1 OF cabemot2.cdx

         IF SEEK(STR(2, 1) + ot.serie + STR(ot.nroot, 7))
            DO _brwDetai2
         ENDIF
      ENDIF

      IF INLIST(ot.estadoot, 5, 6) THEN
         SELECT cabemot
         SET ORDER TO TAG indice1 OF cabemot.cdx

         IF SEEK(STR(2, 1) + ot.serie + STR(ot.nroot, 7))
            DO _brwDetail
         ENDIF
      ENDIF

* Desactivado el 25/07/2013         
*      SELECT cabemot
*      SET ORDER TO TAG indice1 OF cabemot.cdx
*
*      IF SEEK(STR(2, 1) + ot.serie + STR(ot.nroot, 7))
*         DO _brwDetail
*      ELSE
*         SELECT cabemot2
*         SET ORDER TO TAG indice1 OF cabemot2.cdx
*   
*         IF SEEK(STR(2, 1) + ot.serie + STR(ot.nroot, 7))
*            DO _brwDetai2
*         ENDIF
*      ENDIF
      
      SELECT ot

*!*	      UNLOCK IN ot

      plAdding     = .F.
      plEditing    = .F.
      plDeleting   = .F.
      plConsulting = .F.

      POP KEY

ENDCASE

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

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

*-- MS-DOS Base de datos, ¡ndices, relaciones.
SELECT 0
temp01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp01 (tipobole   N(01),;
                      serie      C(01),;
                      nrobole    N(07),;
                      articulo   C(15),;
                      cantidad   N(09,2),;
                      precio     N(13,4),;
                      pimpuesto  N(06,2),;
                      impuesto   L(01),;
                      mecanico   N(03),;
                      descr_trab C(40))

USE &temp01 ALIAS tmpdetmot EXCLUSIVE
INDEX ON STR(tipobole, 1) + serie + STR(nrobole, 7) TAG indice1
INDEX ON articulo                                   TAG indice2
SET RELATION TO tmpdetmot.articulo INTO maesprod ,;        
                tmpdetmot.mecanico INTO mecanico ADDITIVE

SELECT cabemot
SET ORDER TO TAG indice1 OF cabemot.cdx

IF SEEK(STR(2, 1) + ot.serie + STR(ot.nroot, 7))
   SELECT detamot 
   SET ORDER TO TAG indice1 OF detamot.cdx

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
  
   SELECT tmpdetmot
   SET ORDER TO 0
   GO TOP

   *-- MS-DOS  Definiciones de ventanas.
   IF .NOT. WEXIST("tmpdetmot")
      DEFINE WINDOW tmpdetmot ;
         FROM 01,00 ;
         TO 23,79 ;
         TITLE " OT N§: " + ot.serie + " - " + ALLTRIM(STR(ot.nroot, 7)) + " - FT: " + DTOC(cabemot.fecha) + " - "  +  ALLTRIM(LEFT(ot.nombreot, 20)) + " - TOTAL: " + ALLTRIM(TRANSFORM(cabemot.monto_fact, "9,999,999")) ;
         NOFLOAT ;
         CLOSE ;
         NOSHADOW ;
         ZOOM ;
         NOMINIMIZE ;
         SYSTEM ;
         COLOR SCHEME 15
   ENDIF

   IF gnUser <> 200 THEN
      BROWSE WINDOW tmpdetmot FIELDS ;
         calc_f0 = SUBSTR(articulo, 1, 13)        :R:13:H = "C¢digo" ,;
         calc_f1 = IIF(EMPTY(descr_trab), SUBSTR(maesprod.nombre, 1, 36), SUBSTR(descr_trab, 1, 36)) :R:36:H = "Descripci¢n"  :P = "@!" :W = .F. ,;
         cantidad                                 :R:09:H = "Cantidad"     :P = "999999.99" ,;
         calc_f2 = ROUND(precio * (1 + pimpuesto / 100), 0) :R:15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = .F. ,;
         calc_f3 = ROUND(ROUND(precio * (1 + pimpuesto / 100), 0) * cantidad, 0)    :R:13:H = "Sub-Total"    :P = "9,999,999,999" ;
         NOAPPEND NODELETE NOMODIFY
   ELSE
      BROWSE WINDOW tmpdetmot FIELDS ;
         calc_f0 = SUBSTR(articulo, 1, 13)        :R:13:H = "C¢digo" ,;
         calc_f1 = IIF(EMPTY(descr_trab), SUBSTR(maesprod.nombre, 1, 52), SUBSTR(descr_trab, 1, 52)) :R:52:H = "Descripci¢n"  :P = "@!" :W = .F. ,;
         cantidad                                 :R:09:H = "Cantidad"     :P = "999999.99" ;
         NOAPPEND NODELETE NOMODIFY
   ENDIF


*   BROWSE WINDOW tmpdetmot  FIELDS ;
*      calc_f0 = SUBSTR(articulo, 1, 13)        :R:13:H = "C¢digo" ,;
*      calc_f1 = IIF(EMPTY(descr_trab), SUBSTR(maesprod.nombre, 1, 36), SUBSTR(descr_trab, 1, 36)) :R:36:H = "Descripci¢n"  :P = "@!" :W = .F. ,;
*      cantidad                                 :R:09:H = "Cantidad"     :P = "999999.99" ,;
*      precio                                   :R:15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = .F. ,;
*      calc_f2 = ROUND(precio * cantidad, 0)    :R:15:H = "Sub-Total"    :P = "999,999,999,999" ,;
*      mecanico                                 :R:03:H = "Mec"          :P = "999" ,; 
*      calc_f3 = SUBSTR(mecanico.nombre, 1, 30) :R:30:H = "Nombre del Mec nico" :P = "@!" :W = .F. ,;
*      calc_f4 = IIF(impuesto, "   S¡", "")     :R:08:H = "Impuesto"     :W = .F. ,;
*      pimpuesto                                :R:06:H = "% Imp."       :P = "999.99" ;
*      NOAPPEND NODELETE NOMODIFY

ELSE
   WAIT WINDOW "­ ESTA OT NO POSEE MOVIMIENTOS DE DETALLE !"
ENDIF

SELECT ot

*-- MS-DOS Cierre de Bases de Datos.
IF USED("tmpdetmot")
   SELECT tmpdetmot 
   USE
ENDIF
DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"

IF WEXIST("tmpdetmot")
   RELEASE WINDOW tmpdetmot
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder) 
IF pnRecNo <> 0 
   GOTO RECORD pnRecNo
ENDIF



*!*********************************************************************
*!
*!      Funci¢n: _brwDetail     
*!
*!  Llamado por: VENTAS.PRG       
*!
*!  Descripci¢n: Examina el detalle de art¡culos del documento.
*!
*!*********************************************************************
FUNCTION _brwDetai2 

PRIVATE pnSelect, pcOrder, pnRecNo
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0, RECNO())

*-- MS-DOS Base de datos, ¡ndices, relaciones.
SELECT 0
temp01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp01 (tipobole   N(01),;
                      serie      C(01),;
                      nrobole    N(07),;
                      articulo   C(15),;
                      cantidad   N(09,2),;
                      precio     N(13,4),;
                      pimpuesto  N(06,2),;
                      impuesto   L(01),;
                      mecanico   N(03),;
                      descr_trab C(40))

USE &temp01 ALIAS tmpdetmot EXCLUSIVE
INDEX ON STR(tipobole, 1) + serie + STR(nrobole, 7) TAG indice1
INDEX ON articulo                                   TAG indice2
SET RELATION TO tmpdetmot.articulo INTO maesprod ,;        
                tmpdetmot.mecanico INTO mecanico ADDITIVE

SELECT cabemot2
SET ORDER TO TAG indice1 OF cabemot2.cdx

IF SEEK(STR(2, 1) + ot.serie + STR(ot.nroot, 7))
   SELECT detamot2 
   SET ORDER TO TAG indice1 OF detamot2.cdx

   IF SEEK(STR(cabemot2.tipobole, 1) + cabemot2.serie + STR(cabemot2.nrobole, 7))
      SCAN WHILE (STR(cabemot2.tipobole, 1) + cabemot2.serie + STR(cabemot2.nrobole, 7)) = (STR(detamot2.tipobole, 1) + detamot2.serie + STR(detamot2.nrobole, 7))
         INSERT INTO tmpdetmot (tipobole, serie, nrobole, articulo, cantidad, precio, pimpuesto, impuesto, mecanico, descr_trab) ;
            VALUES (detamot2.tipobole, detamot2.serie, detamot2.nrobole, detamot2.articulo, detamot2.cantidad, detamot2.precio, detamot2.pimpuesto, detamot2.impuesto, detamot2.mecanico, detamot2.descr_trab) 
      ENDSCAN
   ELSE
      IF cabemot2.tipobole <> 0 .AND. cabemot2.nrobole <> 0
         WAIT WINDOW "ESTE MOVIMIENTO DE OT NO POSEE DETALLE, BORRELO Y VUELVA A CARGARLO"
      ENDIF
   ENDIF
  
   SELECT tmpdetmot
   SET ORDER TO 0
   GO TOP

   *-- MS-DOS  Definiciones de ventanas.
   IF .NOT. WEXIST("tmpdetmot")
      DEFINE WINDOW tmpdetmot ;
         FROM 01,00 ;
         TO 23,79 ;
         TITLE " OT N§: " + ot.serie + " - " + ALLTRIM(STR(ot.nroot, 7)) + " - FT: " + DTOC(cabemot2.fecha) + " - "  +  ALLTRIM(LEFT(ot.nombreot, 20)) + " - TOTAL: " + ALLTRIM(TRANSFORM(cabemot2.monto_fact, "9,999,999")) ;
         NOFLOAT ;
         CLOSE ;
         NOSHADOW ;
         ZOOM ;
         NOMINIMIZE ;
         SYSTEM ;
         COLOR SCHEME 15
   ENDIF

   BROWSE WINDOW tmpdetmot  FIELDS ;
      calc_f0 = SUBSTR(articulo, 1, 13)        :R:13:H = "C¢digo" ,;
      calc_f1 = IIF(EMPTY(descr_trab), SUBSTR(maesprod.nombre, 1, 36), SUBSTR(descr_trab, 1, 36)) :R:36:H = "Descripci¢n"  :P = "@!" :W = .F. ,;
      cantidad                                 :R:09:H = "Cantidad"     :P = "999999.99" ,;
      calc_f2 = ROUND(precio * (1 + pimpuesto / 100), 0) :R:15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = .F. ,;
      calc_f3 = ROUND(ROUND(precio * (1 + pimpuesto / 100), 0) * cantidad, 0)    :R:13:H = "Sub-Total"    :P = "9,999,999,999" ;
      NOAPPEND NODELETE NOMODIFY

*     precio                                   :R:15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = .F. ,;
*     calc_f2 = ROUND(precio * cantidad, 0)    :R:13:H = "Sub-Total"    :P = "9,999,999,999" ;

*   BROWSE WINDOW tmpdetmot  FIELDS ;
*      calc_f0 = SUBSTR(articulo, 1, 13)        :R:13:H = "C¢digo" ,;
*      calc_f1 = IIF(EMPTY(descr_trab), SUBSTR(maesprod.nombre, 1, 36), SUBSTR(descr_trab, 1, 36)) :R:36:H = "Descripci¢n"  :P = "@!" :W = .F. ,;
*      cantidad                                 :R:09:H = "Cantidad"     :P = "999999.99" ,;
*      precio                                   :R:15:H = "Precio Unit." :P = "@K 99,999,999.9999" :W = .F. ,;
*      calc_f2 = ROUND(precio * cantidad, 0)    :R:15:H = "Sub-Total"    :P = "999,999,999,999" ,;
*      mecanico                                 :R:03:H = "Mec"          :P = "999" ,; 
*      calc_f3 = SUBSTR(mecanico.nombre, 1, 30) :R:30:H = "Nombre del Mec nico" :P = "@!" :W = .F. ,;
*      calc_f4 = IIF(impuesto, "   S¡", "")     :R:08:H = "Impuesto"     :W = .F. ,;
*      pimpuesto                                :R:06:H = "% Imp."       :P = "999.99" ;
*      NOAPPEND NODELETE NOMODIFY

ELSE
   WAIT WINDOW "­ ESTA OT NO POSEE MOVIMIENTOS DE DETALLE !"
ENDIF

SELECT ot

*-- MS-DOS Cierre de Bases de Datos.
IF USED("tmpdetmot")
   SELECT tmpdetmot 
   USE
ENDIF
DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"

IF WEXIST("tmpdetmot")
   RELEASE WINDOW tmpdetmot
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder) 
IF pnRecNo <> 0 
   GOTO RECORD pnRecNo
ENDIF
