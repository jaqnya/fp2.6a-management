* Calcular comision de vendedor

CLEAR ALL

SET CENTURY   ON
SET DATE      BRITISH
SET DELETED   ON
SET EXCLUSIVE OFF
SET SAFETY    OFF

m.fecha1 = CTOD("01/05/2012")
m.fecha2 = CTOD("31/05/2012")
m.vendedor = 17
*!*	m.vendedor = 4

IF !USED("cabevent") THEN
   USE cabevent IN 0
ENDIF

IF !USED("detavent") THEN
   USE detavent IN 0
ENDIF

IF !USED("clientes") THEN
   USE clientes IN 0
ENDIF

IF !USED("vendedor") THEN
   USE vendedor IN 0
ENDIF

IF !USED("maesprod") THEN
   USE maesprod IN 0
ENDIF

IF !USED("monedas") THEN
   USE monedas IN 0
ENDIF

IF !USED("familias") THEN
   USE familias IN 0
ENDIF

IF !USED("vendecfg") THEN
   USE vendecfg IN 0
ENDIF

CREATE TABLE tmp2404503 (;
   tipodocu N(1),;
   nrodocu N(7),;
   fechadocu D(8),;
   div_id N(5),;
   div_nombre C(30),;
   div_cambio N(9,2),;
   cli_id N(5),;
   cli_nombre C(50),;
   ven_id N(5),;
   ven_nombre C(40),;
   pro_id C(15),;
   pro_nombre C(40),;
   pro_cantid N(9,2),;
   pro_precio N(13,4),;
   fam_id N(5),;
   fam_nombre C(40),;
   fam_contad N(6,2),;
   fam_credit N(6,2),;
   fam_cobran N(6,2),;
   comi_venta N(9),;
   comi_cobra N(9))
   
SELECT cabevent
SCAN FOR BETWEEN(fechadocu, m.fecha1, m.fecha2) AND vendedor = m.vendedor
   SELECT detavent
   SET ORDER TO 1
   IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)) THEN
      SCAN WHILE cabevent.tipodocu = tipodocu AND cabevent.nrodocu = nrodocu
         * buscar cliente
         SELECT clientes
         SET ORDER TO 1
         SEEK cabevent.cliente
         
         * buscar vendedor
         SELECT vendedor
         SET ORDER TO 1
         SEEK cabevent.vendedor
         
         * buscar producto
         SELECT maesprod
         SET ORDER TO 1
         SEEK detavent.articulo
         
         * buscar familia
         SELECT familias
         SET ORDER TO 1
         SEEK maesprod.familia
         
         * buscar divisa
         SELECT monedas
         SET ORDER TO 1
         SEEK cabevent.moneda

         * buscar comision
         SELECT vendecfg
         LOCATE FOR familia = maesprod.familia AND vendedor = m.vendedor
         IF FOUND() THEN
            m.mycondi = .T.
         ELSE
            m.mycondi = .F.
         ENDIF
         
         INSERT INTO tmp2404503 (tipodocu, nrodocu, fechadocu, div_id, div_nombre, div_cambio, cli_id, cli_nombre, ven_id, ven_nombre, pro_id, pro_nombre, pro_cantid, pro_precio, fam_id, fam_nombre, fam_contad, fam_credit, fam_cobran) ;
            VALUES (cabevent.tipodocu, cabevent.nrodocu, cabevent.fechadocu, cabevent.moneda, monedas.nombre, cabevent.tipocambio, cabevent.cliente, clientes.nombre, cabevent.vendedor, vendedor.nombre, detavent.articulo, maesprod.nombre, detavent.cantidad, detavent.precio, maesprod.familia, familias.nombre, IIF(m.mycondi, vendecfg.contado, 0), IIF(m.mycondi, vendecfg.credito, 0), IIF(m.mycondi, vendecfg.cobranza, 0))
      ENDSCAN
   ENDIF
ENDSCAN

* procesa las notas de credito.
IF !USED("cabenotc") THEN
   USE cabenotc IN 0
ENDIF

IF !USED("detanotc") THEN
   USE detanotc IN 0
ENDIF

SELECT cabenotc
SCAN FOR BETWEEN(fechanota, m.fecha1, m.fecha2)
   SELECT cabevent
   SET ORDER TO 1
   IF SEEK(STR(cabenotc.tipodocu, 1) + STR(cabenotc.nrodocu, 7)) THEN
      IF vendedor = m.vendedor THEN
         SELECT detanotc
         SET ORDER TO 1
         IF SEEK(STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7)) THEN
            SCAN WHILE cabenotc.tiponota = tiponota AND cabenotc.nronota = nronota
               * buscar cliente
               SELECT clientes
               SET ORDER TO 1
               SEEK cabevent.cliente
          
               * buscar vendedor
               SELECT vendedor
               SET ORDER TO 1
               SEEK cabevent.vendedor
         
               * buscar producto
               SELECT maesprod
               SET ORDER TO 1
               SEEK detanotc.articulo
         
               * buscar familia
               SELECT familias
               SET ORDER TO 1
               SEEK maesprod.familia
         
               * buscar divisa
               SELECT monedas
               SET ORDER TO 1
               SEEK cabevent.moneda

               * buscar comision
               SELECT vendecfg
               LOCATE FOR familia = maesprod.familia AND vendedor = m.vendedor
               IF FOUND() THEN
                  m.mycondi = .T.
               ELSE
                  m.mycondi = .F.
               ENDIF

               INSERT INTO tmp2404503 (tipodocu, nrodocu, fechadocu, div_id, div_nombre, div_cambio, cli_id, cli_nombre, ven_id, ven_nombre, pro_id, pro_nombre, pro_cantid, pro_precio, fam_id, fam_nombre, fam_contad, fam_credit) ;
                  VALUES (cabevent.tipodocu, cabenotc.nronota, cabenotc.fechanota, cabevent.moneda, monedas.nombre, cabevent.tipocambio, cabevent.cliente, clientes.nombre, cabevent.vendedor, vendedor.nombre, detanotc.articulo, maesprod.nombre, detanotc.cantidad, -(detanotc.precio), maesprod.familia, familias.nombre, IIF(m.mycondi, vendecfg.contado, 0), IIF(m.mycondi, vendecfg.credito, 0))
            ENDSCAN
         ENDIF
      ENDIF 
   ENDIF
ENDSCAN   

* terminar proceso
CLOSE DATABASES

USE tmp2404503
REPLACE div_cambio WITH 1 FOR div_id = 1 

SCAN ALL
   IF INLIST(tipodocu, 5, 7) THEN
      REPLACE comi_venta WITH ROUND(ROUND((pro_cantid * pro_precio) * div_cambio, 0) * fam_contad / 100, 0)
      REPLACE comi_cobra WITH 0
   ELSE
      IF INLIST(tipodocu, 6, 8) THEN
         REPLACE comi_venta WITH ROUND(ROUND((pro_cantid * pro_precio) * div_cambio, 0) * fam_credit / 100, 0)
         REPLACE comi_cobra WITH ROUND(ROUND((pro_cantid * pro_precio) * div_cambio, 0) * fam_cobran / 100, 0)
      ELSE
         WAIT "TIPO DE DOCUMENTO DESCONOCIDO !" WINDOW
      ENDIF
   ENDIF
ENDSCAN

EXPORT TO C:\tmp2404503 TYPE XL5