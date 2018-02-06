CLEAR ALL
SET CENTURY   ON
SET DATE      BRITISH
SET DELETED   ON 
SET EXCLUSIVE OFF
SET SAFETY    OFF

fecha1 = CTOD("01/12/2012")
fecha2 = CTOD("31/12/2012")

USE cabevent
SET ORDER TO 2   && DTOS(FECHADOCU)

BROWSE FOR moneda <> 1 ;
       AND BETWEEN(fechadocu, fecha1, fecha2) ;
       AND INLIST(tipodocu, 7, 8) ;
       FREEZE tipocambio
       
SELECT * FROM cabevent WHERE moneda <> 1 AND BETWEEN(fechadocu, fecha1, fecha2) AND tipodocu = 7 INTO TABLE tmp_venta_dolar_contado
SELECT * FROM cabecob WHERE !INLIST(moneda, 0, 1) AND BETWEEN(fechareci, fecha1, fecha2) AND tiporeci = 1 