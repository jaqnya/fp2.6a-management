npeso = "A & A IMPORTACIONES S.R.L."
color_04 = "BG+/B"

DO l_54a

PRIVATE mvend1, mvend2, mfecha1, mfecha2, mopcion1, mopcion2, archi_01, mdestino
STORE 0  TO mvend1, mvend2
STORE "" TO mopcion1, mopcion2, archi_01, mdestino
STORE {} TO mfecha1, mfecha2

SELECT vendedor
SET ORDER TO TAG indice2 OF vendedor.cdx
GOTO TOP
mvend1 = codigo
GOTO BOTTOM
mvend2 = codigo

DEFINE WINDOW l_54 ;
   FROM 05,03 ;
   TO   15,73 ;
   TITLE " COMISION DE VENDEDORES " ;
   NOCLOSE ;
   NOFLOAT ;
   NOGROW ;
   NOMDI ;
   SHADOW ;
   NOZOOM 

ACTIVATE WINDOW l_54

STORE DATE() TO mfecha1, mfecha2
STORE "N"    TO mopcion1
STORE "S"    TO mopcion2

DO WHILE .T.

   @ 01,03 SAY "DEL VENDEDOR:" GET mvend1 PICTURE "999" VALID vldVend1() &&COLOR &color_04
   @ 02,03 SAY "AL  VENDEDOR:" GET mvend2 PICTURE "999" VALID vldVend2() &&COLOR &color_04
   @ 04,03 SAY "DESDE EL:" GET mfecha1 &&COLOR &color_04
   @ 05,03 SAY "HASTA EL:" GET mfecha2 &&COLOR &color_04
   @ 07,03 SAY "INCLUIR DETALLE DE LA VENTA (S/N):" GET mopcion2 PICTURE "@!" &&COLOR &color_04
   
   READ COLOR ", W/BG+"
   
   IF (LASTKEY() = 27)
      EXIT
   ENDIF
   
   IF (mfecha1 > mfecha2)
      WAIT WINDOW "LA FECHA FINAL DEBE SER MAYOR QUE LA FECHA INICIAL !" 
      LOOP
   ENDIF
   
   IF (.NOT. INLIST(UPPER(mopcion1), "S", "N"))
      WAIT WINDOW "LA OPCION DE INCLUIR EL DETALLE DE LA VENTA DEBE SER: (S)I o (N)O !"
      LOOP
   ENDIF
   
   SELECT vendedor
   SET ORDER TO TAG indice1 OF vendedor.cdx

   IF SEEK(mvend1)
      mnombre1 = nombre
   ENDIF

   IF SEEK(mvend2)
      mnombre2 = nombre
   ENDIF

   IF (esta_corre())
      DO l_54b

      SELECT clientes
      SET ORDER TO TAG indice1 OF clientes.cdx

      SELECT temporal
      SET ORDER TO TAG indice2
      
*     IF (mopcion1 = "S")
*        SELECT maesprod
*        SET ORDER TO TAG indice1 OF maesprod.cdx
*        
*        SELECT temporal
*        SET RELATION TO articulo INTO maesprod, ;
*                        cliente  INTO clientes ADDITIVE
*     ELSE
*        SET RELATION TO cliente INTO clientes
*     ENDIF

      IF (mopcion2 = "S")
         SELECT maesprod
         SET ORDER TO TAG indice1 OF maesprod.cdx
         
         SELECT temporal
         SET RELATION TO articulo INTO maesprod, ;
                         cliente  INTO clientes ADDITIVE
      ELSE
         SET RELATION TO cliente INTO clientes
      ENDIF
      
      GOTO TOP
      DO destino

      DO CASE
         CASE (mdestino = "P")
            IF (desea_vfr())
               SET DISPLAY TO VGA50
            ENDIF
            
*           IF (mopcion1 = "N")
*              REPORT FORM L_54a PREVIEW
*           ELSE
*              REPORT FORM L_54b PREVIEW
*           ENDIF
            
            IF (mopcion2 = "S")
               REPORT FORM L_54bc PREVIEW
            ELSE
            *  REPORT FORM L_54b PREVIEW
            ENDIF

            SET DISPLAY TO VGA25
         CASE (mdestino = "I")
            WAIT WINDOW "COLOQUE LA LETRA CONDENSADA Y PULSE UNA TECLA PARA CONTINUAR..."
            WAIT WINDOW "IMPRIMIENDO" NOWAIT
            
            IF (mopcion1 = "N")
               REPORT FORM l_54a TO PRINTER NOCONSOLE
            ELSE
               REPORT FORM l_54b TO PRINTER NOCONSOLE
            ENDIF
            
            WAIT CLEAR
      ENDCASE
      SET RELATION TO
   ENDIF
   STORE DATE() TO mfecha1, mfecha2
   SELECT vendedor
   SET ORDER TO TAG indice2 OF vendedor.cdx
   GOTO TOP
   mvend1 = codigo
   GOTO BOTTOM
   mvend2 = codigo
   CLEAR
ENDDO

SELECT temporal
USE
DO borratm WITH archi_01
RELEASE WINDOW l_54



*--------------------------------------------------------------------------*
PROCEDURE l_54a

IF USED("vendedor")
   SELECT vendedor
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("vendedor.dbf", "DBF", "¨ D¢nde est  VENDEDOR.DBF ?")) ;
      AGAIN ALIAS vendedor SHARED ;
      ORDER TAG indice1
ENDIF

IF USED("cabevent")
   SELECT cabevent
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabevent.dbf", "DBF", "¨ D¢nde est  CABEVENT.DBF ?")) ;
      AGAIN ALIAS cabevent SHARED ;
      ORDER TAG indice1
ENDIF

IF USED("detavent")
   SELECT detavent
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detavent.dbf", "DBF", "¨ D¢nde est  DETAVENT.DBF ?")) ;
      AGAIN ALIAS detavent SHARED ;
      ORDER TAG indice1
ENDIF

IF USED("cabenotc")
   SELECT cabenotc
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabenotc.dbf", "DBF", "¨ D¢nde est  CABENOTC.DBF ?")) ;
      AGAIN ALIAS cabenotc SHARED ;
      ORDER TAG indice1
ENDIF

IF USED("detanotc")
   SELECT detanotc
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detanotc.dbf", "DBF", "¨ D¢nde est  DETANOTC.DBF ?")) ;
      AGAIN ALIAS detanotc SHARED ;
      ORDER TAG indice1
ENDIF

IF USED("clientes")
   SELECT clientes
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("clientes.dbf", "DBF", "¨ D¢nde est  CLIENTES.DBF ?")) ;
      AGAIN ALIAS clientes SHARED ;
      ORDER TAG indice1
ENDIF

IF USED("maesprod")
   SELECT maesprod
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("maesprod.dbf", "DBF", "¨ D¢nde est  MAESPROD.DBF ?")) ;
      AGAIN ALIAS maesprod SHARED ;
      ORDER TAG indice1
ENDIF

archi_01 = "tm" + RIGHT(SYS(3), 6)

CREATE TABLE &archi_01 (cliente    N(07)   ,;
                        vendedor   N(03)   ,;
                        nombre     C(51)   ,;
                        comision1  N(6,2)  ,;
                        comision2  N(6,2)  ,;
                        comision3  N(6,2)  ,;
                        tipodocu   N(01)   ,;
                        nrodocu    N(07)   ,;
                        fechadocu  D(08)   ,;
                        monto_fact N(10)   ,;
                        monto_ndeb N(09)   ,;
                        monto_ncre N(09)   ,;
                        porcdesc   N(6,4)  ,;
                        importdesc N(09)   ,;
                        dias_plazo N(03)   ,;
                        articulo   C(15)   ,;
                        cantidad   N(9,2)  ,;
                        precio     N(11,2) ,;
                        impuesto   L(01)   ,;
                        monto1     N(09)   ,;
                        monto2     N(09)   ,;
                        repuestos  N(09)   ,;
                        servicios  N(09)   ,;
                        otros      N(09)   ,;
                        tienenota  L(01))

USE &archi_01 ALIAS temporal EXCLUSIVE
INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) TAG indice1 OF &archi_01
INDEX ON nombre + STR(vendedor, 3) + DTOS(fechadocu) + STR(tipodocu, 1) + STR(nrodocu, 7) TAG indice2 OF &archi_01

SET ORDER TO TAG indice1 OF &archi_01                      


*--------------------------------------------------------------------------*
PROCEDURE l_54b

SELECT temporal
ZAP

SELECT vendedor
SET ORDER TO TAG indice1 OF vendedor.cdx

SELECT cabenotc
SET ORDER TO TAG indice3 OF cabenotc.cdx

SELECT detavent
SET ORDER TO TAG indice1 OF detavent.cdx

SELECT cabevent
SET RELATION TO vendedor INTO vendedor 
SET ORDER TO TAG indice2 OF cabevent.cdx
GOTO TOP

nContador = 0

DO WHILE (fechadocu <= mfecha2 .AND. .NOT. EOF())
   nContador = nContador + 1
   
   WAIT WINDOW "1/2 - PROCESANDO EL ARCH. DE VENTAS: " + ;
      ALLTRIM(TRANSFORM(nContador, "999,999")) + "/" + ;
      ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) NOWAIT
   
   auxicar = vendedor.nombre

   IF fechadocu >= mfecha1 .AND. .NOT. anulado .AND. mnombre1 <= auxicar .AND. auxicar <= mnombre2)
      SELECT cabenotc
      SEEK STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)
      SELECT cabevent
*     IF (mopcion1 = "N")
*        DO l_54ba
*     ELSE
*        DO L_54bb
*     ENDIF

      IF (mopcion2 = "S")
         DO l_54bc
      ENDIF

      SELECT cabevent
   ENDIF
   SKIP 1
ENDDO
SET ORDER TO TAG indice1 OF cabevent.cdx
SET RELATION TO

WAIT CLEAR

IF (mopcion1 = "S")
   SELECT temporal
   GOTO TOP
   DO WHILE (.NOT. EOF())
      mtipodocu = tipodocu
      mnrodocu  = nrodocu
      SKIP 1
      DO WHILE (mtipodocu = tipodocu .AND. mnrodocu = nrodocu) .AND. .NOT. EOF())
         REPLACE monto_facto WITH 0
         REPLACE monto_ndeb  WITH 0
         REPLACE monto_ncre  WITH 0
         SKIP 1
      ENDDO
   ENDDO
ENDIF

   
*--------------------------------------------------------------------------*
PROCEDURE borratm
PARAMETER cFileName

PRIVATE architm1, architm2, architm3, architm4, architm5
architm1 = cFileName + ".DBF"
architm2 = cFileName + ".IDX"
architm3 = cFileName + ".VUE"
architm4 = cFileName + ".CDX"
architm5 = cFileName + ".FPT"

IF FILE(architm1)
   DELETE FILE &architm1
ENDIF

IF FILE(architm2)
   DELETE FILE &architm2
ENDIF

IF FILE(architm3)
   DELETE FILE &architm3
ENDIF

IF FILE(architm4)
   DELETE FILE &architm4
ENDIF

IF FILE(architm5)
   DELETE FILE &architm5
ENDIF


*--------------------------------------------------------------------------*
FUNCTION esta_corre

PRIVATE cCorrecto, lRetorno
STORE "" TO cCorrecto, lRetorno

DO WHILE .T.
   WAIT WINDOW "ESTA CORRECTO ? (S/N)" TO cCorrecto
   
   IF (INLIST(UPPER(cCorrecto), "S", "N") .OR. LASTKEY() = 27)
      EXIT
   ENDIF
ENDDO

DO CASE
   CASE (UPPER(cCorrecto) = "S")
      lRetorno = .T.
   CASE (UPPER(cCorrecto) = "N" .OR. LASTKEY() = 27)
      lRetorno = .F.     
ENDCASE

RETURN (lRetorno)


*--------------------------------------------------------------------------*
PROCEDURE destino

mdestino = ""

DO WHILE .T.
   WAIT WINDOW "DESTINO: (P)ANTALLA o (I)MPRESORA" TO mdestino
   mdestino = UPPER(mdestino)
   
   IF (INLIST(mdestino, "P", "I") .OR. LASTKEY() = 27)
      EXIT
   ENDIF
ENDDO


*--------------------------------------------------------------------------*
PROCEDURE l_54bc

SELECT detavent 

IF (SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)))
   STORE 0 TO nRepuestos, nServicios, nOtros, nSubTotal
   SCAN WHILE (cabevent.tipodocu = tipodocu .AND. cabevent.nrodocu = nrodocu)
      DO CASE 
         CASE (INLIST(articulo, "99010", "99011", "99012", "99013", "99014", "99020", "99021", "99022"))
            nServicios = nServicios + ROUND(detavent.precio * detavent.cantidad, 0)
         CASE (INLIST(articulo, "99001", "99002", "99003", "10001"))
            nOtros = nOtros  + ROUND(detavent.precio * detavent.cantidad, 0)
         OTHERWISE
            nRepuestos = nRepuestos + ROUND(detavent.precio * detavent.cantidad, 0)
      ENDCASE
   ENDSCAN
   
   IF (cabevent.importdesc > 0)
*     auxi_01 = nRepuestos + nOtros               && Total
*     auxi_02 = ROUND(nRepuestos / auxi_01, 6)    && % del Total para Repuestos
*     auxi_03 = cabevent.importdesc * auxi_02     && Importe del Dcto. para Repuestos
*     auxi_04 = cabevent.importdesc - auxi_03     && Importe del Dcto. para Otros
      
*     nRepuestos = nRepuestos - auxi_03
*     nOtros     = nOtros - auxi_04

      nRepuestos = nRepuestos - cabevent.importdesc
   ENDIF
   
   SELECT temporal
   
   APPEND BLANK
   REPLACE cliente    WITH cabevent.cliente
   REPLACE vendedor   WITH cabevent.vendedor
   REPLACE comision1  WITH cabevent.comision_1
   REPLACE comision2  WITH cabevent.comision_2
   REPLACE comision3  WITH cabevent.comision_3   
   REPLACE nombre     WITH ALLTRIM(vendedor.nombre)
   REPLACE tipodocu   WITH cabevent.tipodocu
   REPLACE nrodocu    WITH cabevent.nrodocu
   REPLACE fechadocu  WITH cabevent.fechadocu
   REPLACE repuestos  WITH nRepuestos
   REPLACE servicios  WITH nServicios
   REPLACE otros      WITH nOtros
ENDIF
   

*--------------------------------------------------------------------------*
FUNCTION desea_vfr
PUBLIC mdesea
STORE SPACE(1) TO mdesea_vfr

DO WHILE .T.
   WAIT WINDOW "DESEA VISUALIZAR EN FORMA REDUCIDA ? (S/N)" TO mdesea_vfr
   mdesea_vfr = UPPER(mdesea_vfr)
   
   IF (INLIST(mdesea_vfr, "S", "N") .OR. LASTKEY() = 27)
      EXIT
   ENDIF
ENDDO

IF (mdesea_vfr = "S")
   retorno = .T.
ELSE
   retorno = .F.
ENDIF

RETURN (retorno)

*--------------------------------------------------------------------------*
PROCEDURE vldVend1
IF (mvend1 <= 0)
   @ 01,22 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
   DO vend_pop.spr WITH "mvend1", 0, .F.
ENDIF

IF (mvend1 = 0)
   RETURN 0
ENDIF

DO SaveWorkArea

SELECT vendedor
SET ORDER TO TAG indice1 OF vendedor.cdx

IF SEEK(mvend1)
   IF (vendedor.vigente)
      @ 01,22 SAY PADR(ALLTRIM(vendedor.nombre), 30, CHR(32)) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 01,22 SAY REPLICATE(CHR(32), 30) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR W/N
      WAIT WINDOW "­ CODIGO DE VENDEDOR NO VIGENTE !"
      DO RestoreWorkArea
      RETURN 0  
   ENDIF
ELSE
   @ 01,22 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE VENDEDOR INEXISTENTE !"
   DO vend_pop.spr WITH "mvend1", 0, .F.
   SHOW GETS

   SELECT vendedor
   SET ORDER TO TAG indice1 OF vendedor.cdx

   IF SEEK(mvend1)
      IF (vendedor.vigente)
         @ 01,22 SAY PADR(ALLTRIM(vendedor.nombre), 30, CHR(32)) ;
            SIZE 1,30 ;
            PICTURE "@!" ;
            COLOR W/N
      ELSE
         @ 01,22 SAY REPLICATE(CHR(32), 30) ;
            SIZE 1,30 ;
            PICTURE "@!" ;
            COLOR W/N
         WAIT WINDOW "­ CODIGO DE VENDEDOR NO VIGENTE !"
         DO RestoreWorkArea
         RETURN 0  
      ENDIF
   ELSE
      @ 01,22 SAY REPLICATE(CHR(32), 30) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR W/N
      DO RestoreWorkArea
      RETURN 0  
   ENDIF
ENDIF      

*--------------------------------------------------------------------------*
PROCEDURE vldVend2
IF (mvend2 <= 0)
   @ 02,22 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
   DO vend_pop.spr WITH "mvend2", 0, .F.
ENDIF

IF (mvend2 = 0)
   RETURN 0
ENDIF

DO SaveWorkArea

SELECT vendedor
SET ORDER TO TAG indice1 OF vendedor.cdx

IF SEEK(mvend2)
   IF (vendedor.vigente)
      @ 02,22 SAY PADR(ALLTRIM(vendedor.nombre), 30, CHR(32)) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR W/N
   ELSE
      @ 02,22 SAY REPLICATE(CHR(32), 30) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR W/N
      WAIT WINDOW "­ CODIGO DE VENDEDOR NO VIGENTE !"
      DO RestoreWorkArea
      RETURN 0  
   ENDIF
ELSE
   @ 02,22 SAY REPLICATE(CHR(32), 30) ;
      SIZE 1,30 ;
      PICTURE "@!" ;
      COLOR W/N
   WAIT WINDOW "­ CODIGO DE VENDEDOR INEXISTENTE !"
   DO vend_pop.spr WITH "mvend2", 0, .F.
   SHOW GETS

   SELECT vendedor
   SET ORDER TO TAG indice1 OF vendedor.cdx

   IF SEEK(mvend2)
      IF (vendedor.vigente)
         @ 02,22 SAY PADR(ALLTRIM(vendedor.nombre), 30, CHR(32)) ;
            SIZE 1,30 ;
            PICTURE "@!" ;
            COLOR W/N
      ELSE
         @ 02,22 SAY REPLICATE(CHR(32), 30) ;
            SIZE 1,30 ;
            PICTURE "@!" ;
            COLOR W/N
         WAIT WINDOW "­ CODIGO DE VENDEDOR NO VIGENTE !"
         DO RestoreWorkArea
         RETURN 0  
      ENDIF
   ELSE
      @ 02,22 SAY REPLICATE(CHR(32), 30) ;
         SIZE 1,30 ;
         PICTURE "@!" ;
         COLOR W/N
      DO RestoreWorkArea
      RETURN 0  
   ENDIF
ENDIF      