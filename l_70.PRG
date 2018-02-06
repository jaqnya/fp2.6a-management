SET DELETED ON
SET DATE BRITISH
SET CENTURY ON

CLEAR ALL
CLEAR

USE cabecomp IN 0 SHARED
USE detacomp IN 0 SHARED
USE maesprod IN 0 SHARED
USE monedas  IN 0 SHARED
USE proveedo IN 0 SHARED

m.fecha1 = CTOD("01/01/2000")
m.fecha2 = CTOD("31/12/2007")
m.articulo = "HV61           "

* Crear archivo temporal
archi1 = "tm" + RIGHT(SYS(3), 6)

SELECT 0
CREATE TABLE &archi1 (;
   tipodocu   N(1),;
   nrodocu    N(9),;
   fechadocu  D(8),;
   id_provee  N(5),;
   proveedor  C(40),;
   id_divisa  N(5),;
   divisa     C(30),;
   cambio     N(11,4),;
   id_produc  C(15),;
   producto   C(40),;
   cantidad   N(6,2),;
   prec_bruto N(13,4),;
   prec_neto  N(9),;
   desc_linea N(8,4),;
   desc_pie   N(8,4))

USE &archi1 ALIAS l_70
INDEX ON DTOS(fechadocu) + STR(id_provee, 5) + STR(tipodocu, 1) + STR(nrodocu, 9) TAG fechadocu

SELECT cabecomp
SET ORDER TO 2   && DTOS(FECHADOCU)+STR(PROVEEDOR,5)+STR(TIPODOCU,1)+STR(NRODOCU,9)
SCAN FOR BETWEEN(fechadocu, m.fecha1, m.fecha2)
   SELECT detacomp
   SET ORDER TO 1   && STR(TIPODOCU,1)+STR(NRODOCU,9)+STR(PROVEEDOR,5)
   IF SEEK(STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9) + STR(cabecomp.proveedor, 5)) THEN
      SCAN WHILE tipodocu = cabecomp.tipodocu AND nrodocu = cabecomp.nrodocu AND proveedor = cabecomp.proveedor
         IF articulo = m.articulo THEN
            SELECT maesprod
            SET ORDER TO 1   && CODIGO
            SEEK detacomp.articulo
            
            SELECT proveedo
            SET ORDER TO 1   && CODIGO
            SEEK cabecomp.proveedor
            
            SELECT monedas
            SET ORDER TO 1   && CODIGO
            SEEK cabecomp.moneda

            m.porcdesc = IIF(cabecomp.porcdesc > 0, cabecomp.porcdesc, IIF(cabecomp.descuento > 0, cabecomp.descuento, 0))
            m.neto_lineal = detacomp.precio - ROUND(detacomp.precio * detacomp.pdescuento / 100, 4)
            m.prec_neto   = m.neto_lineal - ROUND(m.neto_lineal * m.porcdesc / 100, 4)
            m.prec_neto = IIF(cabecomp.moneda = 1, m.prec_neto, ROUND(m.prec_neto * cabecomp.tipocambio, 0))
            
            INSERT INTO l_70 (tipodocu, nrodocu, fechadocu, id_provee, proveedor, id_divisa, divisa, cambio, id_produc, producto, cantidad, prec_bruto, prec_neto, desc_linea, desc_pie);
               VALUES (cabecomp.tipodocu, cabecomp.nrodocu, cabecomp.fechadocu, cabecomp.proveedor, proveedo.nombre, cabecomp.moneda, monedas.nombre, cabecomp.tipocambio, detacomp.articulo, maesprod.nombre, detacomp.cantidad, detacomp.precio,  m.prec_neto, detacomp.pdescuento, m.porcdesc)
         ENDIF
      ENDSCAN
   ENDIF
ENDSCAN


SELECT l_70
BROWSE NOEDIT
