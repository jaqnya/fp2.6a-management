* Calcular comision de vendedor por cobranza

CLEAR ALL

SET CENTURY   ON
SET DATE      BRITISH
SET DELETED   ON
SET EXCLUSIVE OFF
SET SAFETY    OFF

m.fecha1 = CTOD("01/05/2012")
m.fecha2 = CTOD("31/05/2012")
m.cobrador = 17
m.cobrador = 14
*!*	m.cobrador = 4

CREATE CURSOR ventas (;
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
   import_com N(9))

IF !USED("clientes") THEN
   USE clientes IN 0
ENDIF

IF !USED("vendedor") THEN
   USE vendedor IN 0
ENDIF

IF !USED("cabecob") THEN
   USE cabecob IN 0
ENDIF

IF !USED("detacob") THEN
   USE detacob IN 0
ENDIF

IF !USED("cabevent") THEN
   USE cabevent IN 0
ENDIF

IF !USED("monedas") THEN
   USE monedas IN 0
ENDIF

IF !USED("maesprod") THEN
   USE maesprod IN 0
ENDIF

IF !USED("familias") THEN
   USE familias IN 0
ENDIF

IF !USED("detavent") THEN
   USE detavent IN 0
ENDIF

IF !USED("vendecfg") THEN
   USE vendecfg IN 0
ENDIF

SELECT cabecob
SCAN FOR cobrador = m.cobrador AND BETWEEN(fechareci, m.fecha1, m.fecha2)
   SELECT detacob
   SET ORDER TO 1
   IF SEEK(STR(cabecob.tiporeci, 1) + STR(cabecob.nroreci, 7)) THEN
      SCAN WHILE cabecob.tiporeci = tiporeci AND cabecob.nroreci = nroreci
         SELECT ventas
         LOCATE FOR detacob.tipodocu = tipodocu AND detacob.nrodocu = nrodocu
         IF !FOUND() THEN
            SELECT cabevent
            SET ORDER TO 1
            IF SEEK(STR(detacob.tipodocu, 1) + STR(detacob.nrodocu, 7)) THEN
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
                     SEEK m.cobrador

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
                     LOCATE FOR familia = maesprod.familia AND vendedor = m.cobrador

                     INSERT INTO ventas (tipodocu, nrodocu, fechadocu, div_id, div_nombre, div_cambio, cli_id, cli_nombre, ven_id, ven_nombre, pro_id, pro_nombre, pro_cantid, pro_precio, fam_id, fam_nombre, fam_contad, fam_credit) ;
                        VALUES (cabevent.tipodocu, cabevent.nrodocu, cabevent.fechadocu, cabevent.moneda, monedas.nombre, cabevent.tipocambio, cabevent.cliente, clientes.nombre, cabevent.vendedor, vendedor.nombre, detavent.articulo, maesprod.nombre, detavent.cantidad, detavent.precio, maesprod.familia, familias.nombre, vendecfg.cobranza, 0)
                  ENDSCAN
               ENDIF
            ENDIF
         ENDIF
      ENDSCAN
   ENDIF
ENDSCAN

SELECT ventas
REPLACE div_cambio WITH 1 FOR div_id = 1 
REPLACE import_com WITH ROUND(ROUND((pro_cantid * pro_precio) * div_cambio, 0) * fam_contad / 100, 0) ALL
SELECT tipodocu, nrodocu, SUM(import_com) AS total_comi FROM ventas ORDER BY 1,2 GROUP BY 1,2 INTO CURSOR myCursor

CREATE CURSOR myComision (tipodocu N(1), nrodocu N(7), vendedor N(5), tiporeci N(1), nroreci N(7), fechareci D(8), monto_fact N(9), monto_cobr N(9), total_comi N(9), comi_final N(9))

SELECT cabecob
SCAN FOR cobrador = m.cobrador AND BETWEEN(fechareci, m.fecha1, m.fecha2)
   SELECT detacob
   SET ORDER TO 1
   IF SEEK(STR(cabecob.tiporeci, 1) + STR(cabecob.nroreci, 7)) THEN
      SCAN WHILE cabecob.tiporeci = tiporeci AND cabecob.nroreci = nroreci
         SELECT cabevent
         SET ORDER TO 1
         SEEK STR(detacob.tipodocu,1) + STR(detacob.nrodocu, 7)
         
         SELECT myCursor
         LOCATE FOR nrodocu = cabevent.nrodocu AND tipodocu = cabevent.tipodocu
         
         INSERT INTO myComision (tipodocu, nrodocu, vendedor, tiporeci, nroreci, fechareci, monto_fact, monto_cobr, total_comi, comi_final) ;
            VALUES (detacob.tipodocu, detacob.nrodocu, cabevent.vendedor, cabecob.tiporeci, cabecob.nroreci, cabecob.fechareci, cabevent.monto_fact, detacob.monto, myCursor.total_comi, 0)
      ENDSCAN
   ENDIF
ENDSCAN


SELECT myComision
REPLACE comi_final WITH ROUND((monto_cobr / monto_fact) * total_comi,0) ALL
EXPORT TO c:\ventas03 TYPE XL5