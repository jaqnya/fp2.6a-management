PARAMETER m.nropedido

SELECT cabepedc
LOCATE FOR nropedido = m.nropedido
IF !FOUND() THEN
   WAIT "EL PEDIDO N§ " + ALLTRIM(STR(m.nropedido)) + " NO EXISTE." WINDOW
   RETURN
ENDIF

dbf_file = "tmp" + RIGHT(SYS(2015), 5)

CREATE TABLE (dbf_file) (;
   nropedido N(10),;
   fecha D(8),;
   hora C(8),;
   tipobole N(1),;
   nrobole N(7),;
   id_product C(15),;
   cantidad N(9,2),;
   stock_cen N(9,2),;
   stock_dep N(9,2);   
)

SELECT detapedc
SET ORDER TO 1
IF SEEK(m.nropedido) THEN
   SCAN WHILE nropedido = m.nropedido
      m.id_product = articulo
      m.cantidad   = cantidad

      INSERT INTO (dbf_file) FROM MEMVAR
   ENDSCAN
ENDIF

*--BOF: Deposito --*
SELECT (dbf_file)
SCAN ALL
   m.id_product = id_product
   SELECT maesprod
   SET ORDER TO 1
   IF SEEK(m.id_product)THEN
      SELECT (dbf_file)
      REPLACE stock_cen WITH maesprod.stock_actu - maesprod.stock_ot
   ENDIF
ENDSCAN

IF !USED("maesprod2") THEN
   USE SYS(5) + "\turtle\aya\integrad.001\maesprod" IN 0 AGAIN ORDER 1 SHARED ALIAS maesprod2
ENDIF

SELECT (dbf_file)
SCAN ALL
   m.id_product = id_product
   SELECT maesprod2
   SET ORDER TO 1
   IF SEEK(m.id_product) THEN
      SELECT (dbf_file)
      REPLACE stock_dep WITH maesprod2.stock_actu - maesprod2.stock_ot
   ENDIF
ENDSCAN

IF USED("maesprod2") THEN
   SELECT maesprod2
   USE
ENDIF

dbf_file2 = "tmp" + RIGHT(SYS(2015), 5)

CREATE TABLE (dbf_file2) (;
   nropedido N(10),;
   fecha D(8),;
   hora C(8),;
   tipobole N(1),;
   nrobole N(7),;
   id_product C(15),;
   cantidad N(9,2),;
   almacen C(20);
)
INDEX ON almacen TAG almacen

SELECT (dbf_file)
SCAN ALL
   SCATTER MEMVAR MEMO

   DO CASE
      CASE m.cantidad <= m.stock_cen
         m.almacen = "CASA CENTRAL"
         INSERT INTO (dbf_file2) FROM MEMVAR
      CASE m.cantidad > m.stock_cen AND m.cantidad <= m.stock_dep
         m.almacen = "DEPOSITO"
         INSERT INTO (dbf_file2) FROM MEMVAR
      CASE m.cantidad <= (m.stock_dep + m.stock_cen)
         m.almacen = "CASA CENTRAL"
         xcantidad = m.cantidad
         m.cantidad = m.stock_cen
         INSERT INTO (dbf_file2) FROM MEMVAR
         m.almacen = "DEPOSITO"
         m.cantidad = xcantidad - m.stock_cen
         INSERT INTO (dbf_file2) FROM MEMVAR
   ENDCASE
*!*	   DO CASE
*!*	      CASE m.cantidad <= m.stock_dep
*!*	         m.almacen = "DEPOSITO"
*!*	         INSERT INTO (dbf_file2) FROM MEMVAR
*!*	      CASE m.cantidad > m.stock_dep AND m.cantidad <= m.stock_cen
*!*	         m.almacen = "CASA CENTRAL"
*!*	         INSERT INTO (dbf_file2) FROM MEMVAR
*!*	      CASE m.cantidad <= (m.stock_cen + m.stock_dep)
*!*	         m.almacen = "DEPOSITO"
*!*	         xcantidad = m.cantidad
*!*	         m.cantidad = m.stock_dep
*!*	         INSERT INTO (dbf_file2) FROM MEMVAR
*!*	         m.almacen = "CASA CENTRAL"
*!*	         m.cantidad = xcantidad - m.stock_dep
*!*	         INSERT INTO (dbf_file2) FROM MEMVAR
*!*	   ENDCASE
ENDSCAN
*--EOF: Deposito --*

SELECT (dbf_file)
USE
DELETE FILE (dbf_file + ".dbf")

IF !USED("entr_dep") THEN
   USE entr_dep IN 0 AGAIN ORDER 0 SHARED
ENDIF

IF !USED("cabemovi2") THEN
   USE SYS(5) + "\turtle\aya\integrad.001\cabemovi" IN 0 AGAIN ORDER 1 SHARED ALIAS cabemovi2
ENDIF

IF !USED("detamovi2") THEN
   USE SYS(5) + "\turtle\aya\integrad.001\detamovi" IN 0 AGAIN ORDER 1 SHARED ALIAS detamovi2
ENDIF

IF !USED("maesprod2") THEN
   USE SYS(5) + "\turtle\aya\integrad.001\maesprod" IN 0 AGAIN ORDER 1 SHARED ALIAS maesprod2
ENDIF

NextCode = 0

SELECT cabemovi2
SET ORDER TO 1 DESCENDING
IF SEEK("2") THEN
   NextCode = nrobole + 1
ELSE
   NextCode = 1
ENDIF

SELECT (dbf_file2)
DELETE FOR almacen <> "DEPOSITO"
REPLACE fecha    WITH DATE(),;
        hora     WITH TIME(),;
        tipobole WITH 2,;
        nrobole  WITH NextCode ALL

*-- Grabar los ajustes --*
SELECT (dbf_file2)
lnCnt = 1
SCAN ALL
   SCATTER MEMVAR MEMO
   IF lnCnt = 1 THEN
      INSERT INTO cabemovi2 VALUES (m.tipobole, m.nrobole, m.fecha, 1, 2)
   ENDIF

   INSERT INTO detamovi2 VALUES (m.tipobole, m.nrobole, m.id_product, m.cantidad, 2)
   INSERT INTO entr_dep VALUES (m.nropedido, m.fecha, m.hora, m.tipobole, m.nrobole, m.id_product, m.cantidad)

   SELECT maesprod2
   SET ORDER TO 1
   IF SEEK(m.id_product) THEN
      REPLACE stock_actu WITH stock_actu - m.cantidad
   ELSE
      WAIT "El articulo: " + ALLTRIM(m.id_product) + " no existe." WINDOW
   ENDIF
   
   SELECT maesprod
   SET ORDER TO 1
   IF SEEK(m.id_product) THEN
      REPLACE stock_actu WITH stock_actu + m.cantidad
   ELSE
      WAIT "El articulo: " + ALLTRIM(m.id_product) + " no existe." WINDOW
   ENDIF

   lnCnt = lnCnt + 1
ENDSCAN
*-------------------------*

IF USED("entr_dep") THEN
   SELECT entr_dep
   USE
ENDIF

IF USED("cabemovi2") THEN
   SELECT cabemovi2
   USE
ENDIF

IF USED("detamovi2") THEN
   SELECT detamovi2
   USE
ENDIF

IF USED("maesprod2") THEN
   SELECT maesprod2
   USE
ENDIF

SELECT (dbf_file2)
USE
DELETE FILE (dbf_file2 + ".dbf")
DELETE FILE (dbf_file2 + ".cdx")