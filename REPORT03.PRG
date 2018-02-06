*
* REPORT03 - Informe por marca agrupado.
*

*-- Declara variables para c lculos del programa.
PRIVATE temp01, pnCounter

*-- Inicializa variables del programa.
temp01    = ""
pnCounter = 1

*-- C¢digo de configuraci¢n.
=Setup()

*----------------------*
*  PROGRAMA PRINCIPAL  *         
*----------------------*

*-- Obtiene el nombre de la marca.
SELECT marcas1

IF .NOT. SEEK(mmarca)
   WAIT WINDOW "­ ATENCION ! No se ha encontrado la marca seleccionada."
ENDIF

*-- Copia los articulos que cumplan con la condicion de la marca.
pnCounter = 1
SELECT maesprod

IF SEEK(mmarca)
   SCAN WHILE marca = mmarca
      WAIT WINDOW "1/4 - PROCESANDO LA TABLA DE ARTICULOS: " + ALLTRIM(TRANSFORM(pnCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT

      SELECT tmpmoviart
      
      IF .NOT. SEEK(STR(maesprod.subrubro, 4) + "C")
         INSERT INTO tmpmoviart (articulo, nombre, subrubro, nombresr, tipo) ;
            VALUES ("", "", maesprod.subrubro, rubros2.nombre, "C")
         INSERT INTO tmpmoviart (articulo, nombre, subrubro, nombresr, tipo) ;
          VALUES ("", "", maesprod.subrubro, rubros2.nombre, "V")
      ENDIF
      
      SELECT maesprod
      pnCounter = pnCounter + 1
   ENDSCAN
ENDIF

SELECT maesprod
SET ORDER TO TAG indice1 OF maesprod.cdx

*-- Procesa la tabla de compras.
pnCounter = 1
SELECT cabecomp
GO TOP

SCAN ALL
   WAIT WINDOW "2/4 - PROCESANDO LA TABLA DE COMPRAS: " + ALLTRIM(TRANSFORM(pnCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT

   IF YEAR(cabecomp.fechadocu) = mano
      SELECT detacomp
      
      IF SEEK(STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9) + STR(cabecomp.proveedor, 5))
         SCAN WHILE STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9)  + STR(cabecomp.proveedor, 5) = STR(detacomp.tipodocu, 1) + STR(detacomp.nrodocu, 9) + STR(detacomp.proveedor, 5)
            IF maesprod.marca = mmarca
               SELECT tmpmoviart

               IF SEEK(STR(maesprod.subrubro, 4) + "C")
                  =SaveData("C", MONTH(cabecomp.fechadocu), detacomp.cantidad)
               ENDIF
            
               SELECT detacomp
            ENDIF
         ENDSCAN
      ENDIF

      SELECT cabecomp
   ENDIF
   pnCounter = pnCounter + 1
ENDSCAN

*-- Procesa la tabla de ventas.
pnCounter = 1
SELECT cabevent
GO TOP

SCAN ALL
   WAIT WINDOW "3/4 - PROCESANDO LA TABLA DE VENTAS: " + ALLTRIM(TRANSFORM(pnCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT

   IF YEAR(cabevent.fechadocu) = mano
       SELECT detavent
      
      IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
         SCAN WHILE STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7) = STR(detavent.tipodocu, 1) + STR(detavent.nrodocu, 7)
            IF maesprod.marca = mmarca
               SELECT tmpmoviart

               IF SEEK(STR(maesprod.subrubro, 4) + "V")
                  =SaveData("V", MONTH(cabevent.fechadocu), detavent.cantidad)
               ENDIF
            
               SELECT detavent
            ENDIF
         ENDSCAN
      ENDIF

      SELECT cabevent
   ENDIF
   pnCounter = pnCounter + 1
ENDSCAN

*-- Totaliza compras y ventas.
SELECT tmpmoviart

SCAN ALL
   WAIT WINDOW "4/4 - FORMATEANDO TABLA TEMPORAL..." NOWAIT
   REPLACE total WITH (enero + febrero + marzo + abril + mayo + junio + julio + agosto + setiembre + octubre + noviembre + diciembre)
ENDSCAN

WAIT CLEAR

DO WHILE LASTKEY() <> 27
   WAIT WINDOW "DESTINO: (P)ANTALLA o (I)MPRESORA" TO pcDestino
   
   IF INLIST(UPPER(pcDestino), "P", "I")
      EXIT DO
   ENDIF
ENDDO

IF TYPE("pcDestino") <> "U"
   IF UPPER(pcDestino) = "P"
      SELECT tmpmoviart
      SET ORDER TO TAG indice4

      REPORT FORM l_10b.frx PREVIEW
   ENDIF
ENDIF

*-- C¢digo de limpieza.
=Cleanup()

*-----------------------------------------------------------------------*
* MS-DOS © Procedimientos y funciones de soporte.                       *
*-----------------------------------------------------------------------*

*
* SETUP - C¢digo de configuraci¢n.
*
PROCEDURE Setup

*-- Crea tablas temporales.
SELECT 0
temp01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp01 (articulo   C(15) ,;
                      nombre     C(40) ,;
                      subrubro   N(04) ,;
                      nombresr   C(30) ,;
                      tipo       C(01) ,;
                      enero      N(05) ,;
                      febrero    N(05) ,;
                      marzo      N(05) ,;
                      abril      N(05) ,;
                      mayo       N(05) ,;
                      junio      N(05) ,;
                      julio      N(05) ,;
                      agosto     N(05) ,;
                      setiembre  N(05) ,;
                      octubre    N(05) ,;
                      noviembre  N(05) ,;
                      diciembre  N(05) ,;
                      total      N(05))

USE &temp01 ALIAS tmpmoviart EXCLUSIVE

INDEX ON articulo + tipo         TAG indice1
INDEX ON nombre                  TAG indice2
INDEX ON STR(subrubro, 4) + tipo TAG indice3
INDEX ON nombresr                TAG indice4

*-- Ordena las tablas.
SELECT maesprod
SET ORDER TO TAG indice5 OF maesprod.cdx

SELECT marcas1
SET ORDER TO TAG indice1 OF marcas1.cdx

SELECT rubros2
SET ORDER TO TAG indice1 OF rubros2.cdx

SELECT cabecomp
SET ORDER TO TAG indice1 OF cabecomp.cdx

SELECT detacomp
SET ORDER TO TAG indice1 OF detacomp.cdx

SELECT cabevent 
SET ORDER TO TAG indice1 OF cabevent.cdx

SELECT detavent
SET ORDER TO TAG indice1 OF detavent.cdx

SELECT tmpmoviart
SET ORDER TO TAG indice3

*-- Estable relaciones entre las tablas.
SELECT maesprod
SET RELATION TO maesprod.subrubro INTO rubros2  ADDITIVE   

SELECT detacomp
SET RELATION TO detacomp.articulo INTO maesprod ADDITIVE

SELECT detavent
SET RELATION TO detavent.articulo INTO maesprod ADDITIVE

*
* CLEANUP - C¢digo de limpieza.
*
PROCEDURE Cleanup

*-- Elimina tablas temporales.
IF USED("tmpmoviart")
   SELECT tmpmoviart
   USE
ENDIF

DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"

*-- Quiebra las relaciones entre las tablas.
SELECT maesprod 
SET RELATION OFF INTO rubros2 

SELECT detacomp
SET RELATION OFF INTO maesprod

SELECT detavent
SET RELATION OFF INTO maesprod 

*
* SAVEDATA - Graba registro.
*
PROCEDURE SaveData
PARAMETERS cType, nMonth, nQuantity

SELECT tmpmoviart

DO CASE
   CASE nMonth == 1
      REPLACE enero WITH enero + nQuantity
   CASE nMonth == 2
      REPLACE febrero WITH febrero + nQuantity
   CASE nMonth == 3
      REPLACE marzo WITH marzo + nQuantity
   CASE nMonth == 4
      REPLACE abril WITH abril + nQuantity
   CASE nMonth == 5
      REPLACE mayo WITH mayo + nQuantity
   CASE nMonth == 6
      REPLACE junio WITH junio + nQuantity
   CASE nMonth == 7
      REPLACE julio WITH julio + nQuantity
   CASE nMonth == 8
      REPLACE agosto WITH agosto + nQuantity
   CASE nMonth == 9
      REPLACE setiembre WITH setiembre + nQuantity
   CASE nMonth == 10
      REPLACE octubre WITH octubre + nQuantity
   CASE nMonth == 11
      REPLACE noviembre WITH noviembre + nQuantity
   CASE nMonth == 12
      REPLACE diciembre WITH diciembre + nQuantity
ENDCASE
