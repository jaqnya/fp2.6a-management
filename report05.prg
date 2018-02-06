*
* REPORT05 - Ficha de Movimientos de Art¡culo.
*

*-- Declara variables para c lculos del programa.
PRIVATE temp01, pnCounter, pnSaldo

*-- Inicializa variables del programa.
temp01    = ""
pnCounter = 1
pnSaldo   = 0

*-- C¢digo de configuraci¢n.
=Setup()

*----------------------*
*  PROGRAMA PRINCIPAL  *         
*----------------------*

*-- Obtiene el nombre del producto.
SELECT maesprod 

IF SEEK(marti1)
   mtitle  = ALLTRIM(maesprod.nombre) + " (" + ALLTRIM(maesprod.codigo) + ")"
ENDIF

*-- Procesa la tabla de movimiento de dep¢sito.
pnCounter = 1
SELECT cabemovi
GO TOP

SCAN ALL
   WAIT WINDOW "1/7 - PROCESANDO LA TABLA DE MOV. DE DEPOSITO: " + ALLTRIM(TRANSFORM(pnCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT

   IF fecha <= mfecha2
      SELECT detamovi

      IF SEEK(STR(cabemovi.tipobole, 1) + STR(cabemovi.nrobole, 7))
         SCAN WHILE STR(cabemovi.tipobole, 1) + STR(cabemovi.nrobole, 7) = STR(detamovi.tipobole, 1) + STR(detamovi.nrobole, 7)
            IF articulo = marti1
               IF BETWEEN(cabemovi.fecha, mfecha1, mfecha2)
                  =SaveInTable("cabemovi")
               ELSE
                  =SaveInMemory("cabemovi")
               ENDIF
            ENDIF
         ENDSCAN
      ENDIF

      SELECT cabemovi
   ENDIF
   pnCounter = pnCounter + 1
ENDSCAN

*-- Procesa la tabla de compras.
pnCounter = 1
SELECT cabecomp
GO TOP

SCAN ALL
   WAIT WINDOW "2/7 - PROCESANDO LA TABLA DE COMPRAS: " + ALLTRIM(TRANSFORM(pnCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT

   IF fechadocu <= mfecha2
      SELECT detacomp
      
      IF SEEK(STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9) + STR(cabecomp.proveedor, 5))
         SCAN WHILE STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9)  + STR(cabecomp.proveedor, 5) = STR(detacomp.tipodocu, 1) + STR(detacomp.nrodocu, 9) + STR(detacomp.proveedor, 5)
            IF articulo = marti1
               IF BETWEEN(cabecomp.fechadocu, mfecha1, mfecha2)
                  =SaveInTable("cabecomp")
               ELSE
                  =SaveInMemory("cabecomp")
               ENDIF
            ENDIF
         ENDSCAN
      ENDIF

      SELECT cabecomp
   ENDIF
   pnCounter = pnCounter + 1
ENDSCAN

*-- Procesa la tabla de notas de d‚b./cr‚d. de proveedores.
pnCounter = 1
SELECT cabenotp
GO TOP

SCAN ALL
   WAIT WINDOW "3/7 - PROCESANDO LA TABLA DE NOTAS DE PROVEEDORES: " + ALLTRIM(TRANSFORM(pnCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT

   IF fechanota <= mfecha2
      SELECT detanotp
      
      IF SEEK(STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5))
         SCAN WHILE STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5) = STR(detanotp.tiponota, 1) + STR(detanotp.nronota, 9) + STR(detanotp.proveedor, 5)
            IF articulo = marti1 .AND. tipo = "S"
               IF BETWEEN(cabenotp.fechanota, mfecha1, mfecha2)
                  =SaveInTable("cabenotp")
               ELSE
                  =SaveInMemory("cabenotp")
               ENDIF
            ENDIF
         ENDSCAN
      ENDIF

      SELECT cabenotp
   ENDIF
   pnCounter = pnCounter + 1
ENDSCAN

*-- Procesa la tabla de ventas.
pnCounter = 1
SELECT cabevent
GO TOP

SCAN ALL
   WAIT WINDOW "4/7 - PROCESANDO LA TABLA DE VENTAS: " + ALLTRIM(TRANSFORM(pnCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT

   IF fechadocu <= mfecha2
      SELECT detavent
      
      IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
         SCAN WHILE STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7) = STR(detavent.tipodocu, 1) + STR(detavent.nrodocu, 7)
            IF articulo = marti1
               IF BETWEEN(cabevent.fechadocu, mfecha1, mfecha2)
                  =SaveInTable("cabevent")
               ELSE
                  =SaveInMemory("cabevent")
               ENDIF
            ENDIF
         ENDSCAN
      ENDIF

      SELECT cabevent
   ENDIF
   pnCounter = pnCounter + 1
ENDSCAN

*-- Procesa la tabla de notas de d‚b./cr‚d. de clientes.
pnCounter = 1
SELECT cabenotc
GO TOP

SCAN ALL
   WAIT WINDOW "5/7 - PROCESANDO LA TABLA DE NOTAS DE CLIENTES: " + ALLTRIM(TRANSFORM(pnCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT

   IF fechanota <= mfecha2
      SELECT detanotc
      
      IF SEEK(STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7))
         SCAN WHILE STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7) = STR(detanotc.tiponota, 1) + STR(detanotc.nronota, 7)
            IF articulo = marti1 .AND. tipo = "S"
               IF BETWEEN(cabenotc.fechanota, mfecha1, mfecha2)
                  =SaveInTable("cabenotc")
               ELSE
                  =SaveInMemory("cabenotc")
               ENDIF
            ENDIF
            SELECT detanotc
         ENDSCAN
      ENDIF

      SELECT cabenotc
   ENDIF
   pnCounter = pnCounter + 1
ENDSCAN


INSERT INTO temporal (documento, stock_actu) ;
   VALUES ("SALDO ANTERIOR", pnSaldo)

*-- Procesa la tabla de movimiento de ordenes de trabajo.
pnCounter = 1
SELECT ot       
GO TOP

SCAN ALL
   WAIT WINDOW "6/7 - PROCESANDO LA TABLA DE ORDENES DE TRABAJO: " + ALLTRIM(TRANSFORM(pnCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT

   IF estadoot <> 6   &&  6. Facturado.
      SELECT cabemot

      IF SEEK(STR(2, 1) + ot.serie + STR(ot.nroot, 7))
         IF fecha <= mfecha2
            SELECT detamot
         
            IF SEEK(STR(cabemot.tipobole, 1) + cabemot.serie + STR(cabemot.nrobole, 7))
               SCAN WHILE STR(cabemot.tipobole, 1) + cabemot.serie + STR(cabemot.nrobole, 7) = STR(detamot.tipobole, 1) + detamot.serie + STR(detamot.nrobole, 7)
                  IF articulo = marti1
                     IF BETWEEN(cabemot.fecha, mfecha1, mfecha2)
                        =SaveInTable("cabemot")
                     ELSE
                        =SaveInMemory("cabemot")
                     ENDIF
                  ENDIF
               ENDSCAN
            ENDIF
         ENDIF
      ENDIF
      SELECT ot
   ENDIF
   pnCounter = pnCounter + 1
ENDSCAN

*-- Calcula el saldo de existencias del art¡culo.
pnCounter = 1
SELECT temporal

SCAN ALL
   WAIT WINDOW "7/7 - GENERA LOS SALDOS ANTERIORES: " + ALLTRIM(TRANSFORM(pnCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT
   
   IF entrada <> 0
      pnSaldo = pnSaldo + entrada   
   ELSE
      IF salida <> 0
         pnSaldo = pnSaldo - salida
      ENDIF
   ENDIF
      
   REPLACE stock_actu WITH pnSaldo
   pnCounter = pnCounter + 1
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
      REPORT FORM l_11.frx PREVIEW
   ENDIF
   IF UPPER(pcDestino) = "I"
      REPORT FORM l_11.frx TO PRINT
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
                      nombreart  C(40) ,;
                      fecha      D(08) ,;
                      tipodocu   N(01) ,;
                      documento  C(30) ,;
                      nrodocu    N(09) ,;
                      entrada    N(11,2) ,;
                      salida     N(11,2) ,;
                      stock_actu N(11,2) ,;
                      precio     N(11,2) ,;
                      nombrecp   C(40))

USE &temp01 ALIAS temporal EXCLUSIVE

INDEX ON nombreart + articulo + DTOS(fecha) + IIF(entrada <> 0, "0", "1")  TAG indice1

*-- Ordena las tablas.
SELECT proveedo
SET ORDER TO TAG indice1 OF proveedo.cdx

SELECT clientes
SET ORDER TO TAG indice1 OF clientes.cdx

SELECT maesprod
SET ORDER TO TAG indice1 OF maesprod.cdx

SELECT cabemovi
SET ORDER TO TAG indice1 OF cabemovi.cdx

SELECT detamovi
SET ORDER TO TAG indice1 OF detamovi.cdx

SELECT cabecomp
SET ORDER TO TAG indice1 OF cabecomp.cdx

SELECT detacomp
SET ORDER TO TAG indice1 OF detacomp.cdx

SELECT cabenotp
SET ORDER TO TAG indice1 OF cabenotp.cdx

SELECT detanotp
SET ORDER TO TAG indice1 OF detanotp.cdx

SELECT cabevent
SET ORDER TO TAG indice1 OF cabevent.cdx

SELECT detavent
SET ORDER TO TAG indice1 OF detavent.cdx

SELECT cabenotc
SET ORDER TO TAG indice1 OF cabenotc.cdx

SELECT detanotc
SET ORDER TO TAG indice1 OF detanotc.cdx

SELECT ot
SET ORDER TO TAG indice1 OF ot.cdx

SELECT cabemot
SET ORDER TO TAG indice1 OF cabemot.cdx

SELECT detamot
SET ORDER TO TAG indice1 OF detamot.cdx

*-- Estable relaciones entre las tablas.
SELECT cabecomp
SET RELATION TO cabecomp.proveedor INTO proveedo ADDITIVE

SELECT cabenotp
SET RELATION TO cabenotp.proveedor INTO proveedo ADDITIVE

SELECT cabevent 
SET RELATION TO cabevent.cliente   INTO clientes ADDITIVE

SELECT detamovi
SET RELATION TO detamovi.articulo INTO maesprod ADDITIVE

SELECT detacomp
SET RELATION TO detacomp.articulo INTO maesprod ADDITIVE

SELECT detanotp
SET RELATION TO detanotp.articulo INTO maesprod ADDITIVE

SELECT detavent
SET RELATION TO detavent.articulo INTO maesprod ADDITIVE

SELECT detanotc
SET RELATION TO detanotc.articulo INTO maesprod ADDITIVE

SELECT detamot
SET RELATION TO detamot.articulo  INTO maesprod ADDITIVE

*
* CLEANUP - C¢digo de limpieza.
*
PROCEDURE Cleanup

*-- Elimina tablas temporales.
IF USED("temporal")
   SELECT temporal
   USE
ENDIF

DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"

*-- Quiebra las relaciones entre las tablas.
SELECT cabecomp
SET RELATION OFF INTO proveedo

SELECT cabenotp
SET RELATION OFF INTO proveedo

SELECT cabevent 
SET RELATION OFF INTO clientes

SELECT detamovi
SET RELATION OFF INTO maesprod 

SELECT detacomp
SET RELATION OFF INTO maesprod 

SELECT detanotp
SET RELATION OFF INTO maesprod 

SELECT detavent
SET RELATION OFF INTO maesprod 

SELECT detanotc
SET RELATION OFF INTO maesprod 

SELECT detamot
SET RELATION OFF INTO maesprod 

*
* SAVEINMEMORY - Calcula el saldo anterior.
*
PROCEDURE SaveInMemory
PARAMETER cTable

DO CASE
   CASE LOWER(cTable) = "cabemovi"
      IF INLIST(cabemovi.tipobole, 1, 3)     && 1. Entrada, 3. Ajuste - Entrada.
         pnSaldo = pnSaldo + detamovi.cantidad
      ELSE
         IF INLIST(cabemovi.tipobole, 2, 4)  && 2. Salida,  4. Ajuste - Salida.
            pnSaldo = pnSaldo - detamovi.cantidad
         ENDIF
      ENDIF
   CASE LOWER(cTable) = "cabecomp"
      pnSaldo = pnSaldo + detacomp.cantidad
   CASE LOWER(cTable) = "cabenotp"
      IF INLIST(cabenotp.tiponota, 1, 3)     && 1. Nota de D‚bito,  3. C.I. Nota de D‚bito.
         pnSaldo = pnSaldo + detanotp.cantidad
      ELSE
         IF INLIST(cabenotp.tiponota, 2, 4)  && 2. Nota de Cr‚dito, 4. C.I. Nota de Cr‚dito.
            pnSaldo = pnSaldo - detanotp.cantidad
         ENDIF
      ENDIF
   CASE LOWER(cTable) = "cabevent"
      pnSaldo = pnSaldo - detavent.cantidad
   CASE LOWER(cTable) = "cabenotc"
      IF INLIST(cabenotc.tiponota, 1, 3)     && 1. Nota de D‚bito,  3. C.I. Nota de D‚bito.
         pnSaldo = pnSaldo - detanotc.cantidad
      ELSE
         IF INLIST(cabenotc.tiponota, 2, 4)  && 2. Nota de Cr‚dito, 4. C.I. Nota de Cr‚dito.
            pnSaldo = pnSaldo + detanotc.cantidad
         ENDIF
      ENDIF
   CASE LOWER(cTable) = "cabemot"
      pnSaldo = pnSaldo - detamot.cantidad
ENDCASE      

*
* SAVEINTABLE - Graba registro.
*
PROCEDURE SaveInTable
PARAMETERS cTable

DO CASE
   CASE LOWER(cTable) = "cabemovi"
      IF INLIST(cabemovi.tipobole, 1, 3)     && 1. Entrada, 3. Ajuste - Entrada.
         INSERT INTO temporal (articulo, nombreart, fecha, tipodocu, documento, nrodocu, entrada, salida, stock_actu, precio, nombrecp) ;
            VALUES (maesprod.codigo, maesprod.nombre, cabemovi.fecha, cabemovi.tipobole, IIF(cabemovi.tipobole = 1, "Ent.D. ", "Aj.Ent. ") + ALLTRIM(STR(cabemovi.nrobole, 7)), cabemovi.nrobole, detamovi.cantidad, 0, 0, 0, "") 
      ELSE
         IF INLIST(cabemovi.tipobole, 2, 4)  && 2. Salida,  4. Ajuste - Salida.
            INSERT INTO temporal (articulo, nombreart, fecha, tipodocu, documento, nrodocu, entrada, salida, stock_actu, precio, nombrecp) ;
               VALUES (maesprod.codigo, maesprod.nombre, cabemovi.fecha, cabemovi.tipobole, IIF(cabemovi.tipobole = 2, "Sal.D. ", "Aj.Sal. ") + ALLTRIM(STR(cabemovi.nrobole, 7)), cabemovi.nrobole, 0, detamovi.cantidad, 0, 0, "") 
         ENDIF
      ENDIF
   CASE LOWER(cTable) = "cabecomp"
      DO CASE  Determina el texto que corresponde al tipo de documento.
         CASE cabecomp.tipodocu = 1
            mdocumento = "Compra Contado "
         CASE cabecomp.tipodocu = 2
            mdocumento = "Compra Cr‚dito "
         CASE cabecomp.tipodocu = 3
            mdocumento = "Compra Iva Incl. "
         CASE cabecomp.tipodocu = 4
            mdocumento = "Compra Tr. Unico "
         CASE cabecomp.tipodocu = 5
            mdocumento = "C.I. Compra Ctdo. "
         CASE cabecomp.tipodocu = 6
            mdocumento = "C.I. Compra Cr‚d. "
         OTHERWISE
            mdocumento = ""
      ENDCASE   

      INSERT INTO temporal (articulo, nombreart, fecha, tipodocu, documento, nrodocu, entrada, salida, stock_actu, precio, nombrecp) ;
         VALUES (maesprod.codigo, maesprod.nombre, cabecomp.fechadocu, cabecomp.tipodocu, mdocumento + ALLTRIM(STR(cabecomp.nrodocu, 9)), cabecomp.nrodocu, detacomp.cantidad, 0, 0, 0, ALLTRIM(proveedo.nombre)) 

   CASE LOWER(cTable) = "cabenotp"
      IF INLIST(cabenotp.tiponota, 1, 3)     && 1. Nota de D‚bito,  3. C.I. Nota de D‚bito.
         INSERT INTO temporal (articulo, nombreart, fecha, tipodocu, documento, nrodocu, entrada, salida, stock_actu, precio, nombrecp) ;
            VALUES (maesprod.codigo, maesprod.nombre, cabenotp.fechanota, cabenotp.tiponota, IIF(cabenotp.tiponota = 1, "N.D‚bito Comp. ", "C.I.N.D‚b.Comp. ") + ALLTRIM(STR(cabenotp.nronota, 9)), cabenotp.nronota, detanotp.cantidad, 0, 0, 0, ALLTRIM(proveedo.nombre)) 
      ELSE
         IF INLIST(cabenotp.tiponota, 2, 4)  && 2. Nota de Cr‚dito, 4. C.I. Nota de Cr‚dito.
            INSERT INTO temporal (articulo, nombreart, fecha, tipodocu, documento, nrodocu, entrada, salida, stock_actu, precio, nombrecp) ;
               VALUES (maesprod.codigo, maesprod.nombre, cabenotp.fechanota, cabenotp.tiponota, IIF(cabenotp.tiponota = 2, "N.Cr‚dito Comp. ", "C.I.N.Cr‚d.Comp. ") + ALLTRIM(STR(cabenotp.nronota, 9)), cabenotp.nronota, 0, detanotp.cantidad, 0, 0, ALLTRIM(proveedo.nombre)) 
         ENDIF
      ENDIF
   CASE LOWER(cTable) = "cabevent"
      DO CASE  Determina el texto que corresponde al tipo de documento.
         CASE cabevent.tipodocu = 1
            mdocumento = "Vta. Contado "
         CASE cabevent.tipodocu = 2
            mdocumento = "Vta. Cr‚dito "
         CASE cabevent.tipodocu = 3
            mdocumento = "Vta. Iva Incl. "
         CASE cabevent.tipodocu = 4
            mdocumento = "Vta. Tr. Unico "
         CASE cabevent.tipodocu = 5
            mdocumento = "C.I.Vta.Ctdo. "
         CASE cabevent.tipodocu = 6
            mdocumento = "C.I.Vta.Cr‚d. "
         OTHERWISE
            mdocumento = ""
      ENDCASE   
            
      INSERT INTO temporal (articulo, nombreart, fecha, tipodocu, documento, nrodocu, entrada, salida, stock_actu, precio, nombrecp) ;
         VALUES (maesprod.codigo, maesprod.nombre, cabevent.fechadocu, cabevent.tipodocu, mdocumento + ALLTRIM(STR(cabevent.nrodocu, 9)), cabevent.nrodocu, 0, detavent.cantidad, 0, 0, ALLTRIM(clientes.nombre)) 

   CASE LOWER(cTable) = "cabenotc"
      *-- Obtiene el nombre del cliente.
      SELECT cabevent
      
      IF .NOT. SEEK(STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7))
         WAIT WINDOW " ­ ATENCION ! No se ha encontrado la venta: " + STR(cabenotc.tipodocu, 1) + "/" + ALLTRIM(STR(cabenotc.nrodocu, 7))
      ENDIF

      IF INLIST(cabenotc.tiponota, 1, 3)     && 1. Nota de D‚bito,  3. C.I. Nota de D‚bito.
         INSERT INTO temporal (articulo, nombreart, fecha, tipodocu, documento, nrodocu, entrada, salida, stock_actu, precio, nombrecp) ;
            VALUES (maesprod.codigo, maesprod.nombre, cabenotc.fechanota, cabenotc.tiponota, IIF(cabenotc.tiponota = 1, "N.D‚bito Comp. ", "C.I.N.D‚b.Comp. ") + ALLTRIM(STR(cabenotc.nronota, 7)), cabenotc.nronota, 0, detanotc.cantidad, 0, 0, ALLTRIM(clientes.nombre)) 
      ELSE
         IF INLIST(cabenotc.tiponota, 2, 4)  && 2. Nota de Cr‚dito, 4. C.I. Nota de Cr‚dito.
            INSERT INTO temporal (articulo, nombreart, fecha, tipodocu, documento, nrodocu, entrada, salida, stock_actu, precio, nombrecp) ;
               VALUES (maesprod.codigo, maesprod.nombre, cabenotc.fechanota, cabenotc.tiponota, IIF(cabenotc.tiponota = 2, "N.Cr‚dito Comp. ", "C.I.N.Cr‚d.Comp. ") + ALLTRIM(STR(cabenotc.nronota, 7)), cabenotc.nronota, 0, 0, detanotc.cantidad, 0, ALLTRIM(clientes.nombre)) 
         ENDIF
      ENDIF
   CASE LOWER(cTable) = "cabemot"
      INSERT INTO temporal (articulo, nombreart, fecha, tipodocu, documento, nrodocu, entrada, salida, stock_actu, precio, nombrecp) ;
         VALUES (maesprod.codigo, maesprod.nombre, cabemot.fecha, cabemot.tipobole, "Orden de Trabajo " + cabemot.serie + "-" + ALLTRIM(STR(cabemot.nrobole, 7)), cabemot.nrobole, 0, detamot.cantidad, 0, 0, ALLTRIM(ot.nombreot)) 
ENDCASE