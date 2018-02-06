CLEAR ALL
CLEAR

SET CENTURY ON
SET DATE BRITISH
SET DELETED ON
SET EXACT ON


USE cabevent IN 0 SHARED
USE detavent IN 0 SHARED
USE cabecomp IN 0 SHARED
USE detacomp IN 0 SHARED
USE cabenotc IN 0 SHARED
USE detanotc IN 0 SHARED
USE cabenotp IN 0 SHARED
USE detanotp IN 0 SHARED
USE maesprod IN 0 SHARED

ldDateFrom = CTOD("01/01/2011")
ldDateTo   = CTOD("23/06/2011")

CREATE CURSOR tm_muestra (;
   id_producto C(15),;
   descripcion C(40),;
   cantidad N(9,2),;
   costo_unitario N(12,4),;
   costo_total N(12),;
   fecha_ultima_compra D(8),;
   existencia_inicial N(9,2),;
   cantidad_compra N(9,2),;
   importe_compra N(12),;
   cantidad_venta N(9,2),;
   importe_venta N(12),;
   existencia_final N(9,2);
)

SELECT maesprod
SCAN ALL
   mid_producto = ALLTRIM(codigo)
   mdescripcion = ALLTRIM(nombre)
   INSERT INTO tm_muestra (id_producto, descripcion) VALUES (mid_producto, mdescripcion)
ENDSCAN

*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('6749', 'CILINDRO COMPLETO HV 61 48MM PLATT', 331, 123707.52, 40947189, {^2010/3/30}, 94)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('6076', 'NYLON 3.0MM 1KL REDONDO GRILON', 999, 39360, 39320640, {^2010/12/23}, 10)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1649', 'CIGUEÑAL ST 08 ITC BB', 172, 160380, 27585360, {^2010/11/12}, 19)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('20000', 'PISTON C/ARO HV 62 48MM PLATT', 1283, 17400, 22324200, {^2007/12/7}, 1214)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1662', 'CIGUEÑAL HV 61 PLATT', 254, 81120, 20604480, {^2009/3/17}, 495)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('320', 'ELECTRONICO HV 61 MN/51/268/240R MEGAVIL', 432, 43708.5, 18882072, {^2010/10/21}, 106)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('672', 'FILTRO NAFTA HV OEM-LIKE', 3465, 4891.68, 16949671, {^2010/3/26}, 2555)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('6009', 'CAÑITO NAFTA 10 METROS 3MM HV RAISMAN', 317, 45168, 14318256, {^2010/4/8}, 103)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('3306', 'ESPADA ST 038/029/039/066 20" ITC', 111, 128799, 14296689, {^2010/11/12}, 2)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('701', 'JGO REP CARB COMPL FS220/012 ZAMA RAISMA', 1261, 10939.5, 13794710, {^2010/10/21}, 87)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('621A', 'ESCAPE HV 62/61 MV RAISMAN', 492, 27014.5, 13291134, {^2010/7/20}, 0)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1911', 'ELECTRONICO ST 038/034 MEGAVILLE', 299, 38511, 11514789, {^2010/10/21}, 75)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1608', 'CARBURADOR ST 08 RAISMAN', 154, 73161, 11266794, {^2010/10/21}, 11)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('20007', 'PISTON C/ARO ST 08 47MM PLATT', 521, 17400, 9065400, {^2007/12/7}, 676)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('6153', 'NYLON BLISTER 3.0 MM 55 MT REDONDO GRILO', 299, 30288, 9056112, {^2010/12/23}, 58)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('7257', 'NYLON BLISTER 3.3 MM 45 MT REDONDO GRILO', 299, 30288, 9056112, {^2010/12/23}, 0)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1971', 'TRIMMY ST FS 160/220/280/360 RAISMAN', 391, 22918.5, 8961134, {^2010/10/21}, 1)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('418', 'RODILLO PIÑON HV 61 ESTRELLA PLATT', 2519, 3536, 8907184, {^2009/3/17}, 2323)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('913', 'BIELA HV 61 PLATT', 376, 23192, 8720192, {^2009/3/17}, 493)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('20008', 'PISTON C/ARO ST 08 49MM PLATT', 500, 17400, 8700000, {^2007/12/7}, 573)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('7256', 'NYLON 3.0MM 2KL REDONDO GRILON', 108, 79296, 8563968, {^2010/12/23}, 0)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1372', 'CARBURADOR HV 61 MN RAISMAN', 132, 64251, 8481132, {^2010/10/21}, 3)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1811', 'JGO REP CARB COMPL C/ASIENTO ST08 RAISMA', 619, 12870, 7966530, {^2010/10/21}, 36)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1852', 'ELECTRONICO ST FS 220/025/250 MEGAVILLE', 205, 38511, 7894755, {^2010/10/21}, 2)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('828', 'JGO REP CARB HV 61MN/ST 066/660 RAISMAN', 1134, 6930, 7858620, {^2010/10/21}, 1017)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('706', 'JGO REP CARB COMPL HV 235/41/45 WALB RAI', 1011, 7672.5, 7756898, {^2010/10/21}, 519)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('7139', 'LIMA REDONDA 7/32 RAISMAN', 3477, 2182.5, 7588553, {^2010/7/20}, 0)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('5030', 'CADENA OREGON LG 36D 3/8 HV61/ST038/041', 143, 50554, 7229222, {^2010/9/7}, 334)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('6481', 'CDI DIGITAL BIZ 125 MEGAVILLE', 50, 130500, 6525000, {^2008/2/12}, 50)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('56', 'CUCHILLA 3P 300 HV 240R/ST FS 220 ITC', 191, 33858, 6466878, {^2010/11/12}, 0)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1121', 'CIGUEÑAL HV 61 MN/268 ITC', 33, 187704, 6194232, {^2010/11/12}, 8)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1061', 'JGO REP CARB COMPL BROSOL RAISMAN', 471, 13018.5, 6131714, {^2010/10/21}, 15)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('HV61', 'MOTOSIERRA HUSQVARNA 61 (61CC) 20"', 3, 2023539, 6070617, {^2010/12/30}, 1)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('16396', 'CAMARA HERO GO PRO MOTORSPORT WIDE ANGLE', 5, 1202928, 6014640, {^2010/6/9}, 0)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('697', 'JGO REP CARB COMPL HV61/ST051 TILLOTSON', 983, 6088.5, 5984996, {^2010/10/21}, 564)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('11113', 'PEDAL DE ARRANQUE XL 125', 96, 61432, 5897472, {^2006/11/29}, 103)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1663', 'CILINDRO SOLO ST 08 47MM FRENOBRAS', 59, 98554.5, 5814716, {^2010/10/27}, 15)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('6862', 'CARBURADOR ST FS 160/220/280 RAISMAN', 95, 59202, 5624190, {^2010/10/21}, 0)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('20031', 'ARO ST 038/380/381/051 52MM PLATT', 3499, 1600, 5598400, {^2007/12/7}, 3280)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('20030', 'ARO ST 08 49MM PLATT', 3467, 1600, 5547200, {^2007/12/7}, 3267)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('6551', 'CARBURADOR ST 08 BROSOL RAISMAN', 87, 63540, 5527980, {^2008/5/29}, 140)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('6550', 'BUJIA RAISMAN CJ7Y CHICA', 1778, 3104, 5518912, {^2010/7/20}, 2306)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1963', 'CUCHILLA PLANA OM/ST FS85 300 X 1" ITC', 337, 15888, 5354256, {^2010/4/15}, 0)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('6480', 'CDI DIGITAL XR250 TORNADO MEGAVILLE', 41, 130500, 5350500, {^2008/2/12}, 45)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1845', 'CUCHILLA 3P 300 ST FS 106/EFCO/OM ITC', 157, 33858, 5315706, {^2010/11/12}, 0)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('3031', 'LIMA REDONDA 3/16 OREGON', 371, 4613, 1711423, {^2010/12/27}, 343)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('6602', 'JGO REP CARB OM 750/EFCO 8510/POWER TOOL', 168, 5480.5, 920724, {^2010/7/16}, 88)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('586', 'PISTON C/ARO ST 051 52MM AILYN', 21, 27750, 582750, {^2008/10/28}, 20)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('16427', 'PROTECTOR DE MANO SX BICOMP NE/VE', 4, 91179, 364716, {^2010/10/20}, 0)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('12324', 'NUMERO ADHESIVO CIRCUIT 5 BLANCO', 56, 4276.8, 239501, {^2010/4/7}, 12)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('12316', 'NUMERO ADHESIVO CIRCUIT 8 NEGRO', 38, 4276.8, 162518, {^2010/4/7}, 19)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('16350', 'CUBIERTA 100/90 - 17 MONSTER DUNLOP', 1, 112320, 112320, {^2010/2/18}, 1)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('16013', 'CADENITA ARRANQUE C100 25H64L TOUGH', 18, 4365, 78570, {^2009/12/12}, 19)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1913', 'VARILLA ACELERADOR HV 61/62/266 BB', 44, 1273, 56012, {^2010/7/5}, 20)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1209', 'TORNILLO EMBRAGUE HV 132', 2, 19228, 38456, {^2006/3/15}, 2)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('7', 'PISTON C/ARO ST 070 58MM CASTOR', 1, 25625, 25625, {^2006/12/4}, 2)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('6368', 'RUEDA GARDEN 110MM CHICA', 2, 8164, 16328, {^2007/1/19}, 2)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('1731', 'REMACHE 404 LG OREGON', 11, 879, 9669, {^2010/10/18}, 0)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('238', 'ARANDELA PRESION 5MM', 449, 12.35, 5545, {^2010/9/14}, 187)
*!*	INSERT INTO tm_muestra (id_producto, descripcion, cantidad, costo_unitario, costo_total, fecha_ultima_compra, existencia_inicial) VALUES ('236', 'ARANDELA PRESION 3MM', 20, 25, 500, {^2000/6/23}, 19)

SELECT;
   b.articulo,;
   SUM(b.cantidad) AS cantidad,;
   SUM(ROUND(ROUND(b.precio * a.tipocambio, 0) * b.cantidad, 0)) AS importe;
FROM;
   cabevent a,;
   detavent b;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   BETWEEN(a.fechadocu, ldDateFrom, ldDateTo);
GROUP BY;
   b.articulo;
INTO CURSOR;
   tm_venta

SELECT;
   b.articulo,;
   SUM(b.cantidad) AS cantidad,;
   SUM(ROUND((b.precio - (b.precio * b.pdescuento / 100) - (b.precio * IIF(a.importdesc > 0, a.descuento, 0) / 100)) * b.cantidad * IIF(a.moneda = 1, 000001.00, a.tipocambio), 0)) AS importe;
FROM;
   cabecomp a,;
   detacomp b;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.proveedor = b.proveedor AND;
   BETWEEN(a.fechadocu, ldDateFrom, ldDateTo);
GROUP BY;
   b.articulo;
INTO CURSOR;
   tm_compra

SELECT;
   b.articulo,;
   SUM(b.cantidad) AS cantidad,;
   SUM(ROUND(ROUND(b.precio * c.tipocambio, 0) * b.cantidad, 0)) AS importe;
FROM;
   cabenotc a,;
   detanotc b,;
   cabevent c;
WHERE;
   a.tiponota = b.tiponota AND;
   a.nronota = b.nronota AND;
   a.tipodocu = c.tipodocu AND;
   a.nrodocu = c.nrodocu AND;
   a.tiponota = 2 AND;
   b.tipo = "S" AND;
   BETWEEN(a.fechanota, ldDateFrom, ldDateTo);
GROUP BY;
   b.articulo;
INTO CURSOR;
   tm_nota_cliente

SELECT;
   b.articulo,;
   SUM(b.cantidad) AS cantidad,;
   SUM(ROUND((b.precio - (b.precio * b.pdescuento / 100)) * b.cantidad * IIF(c.moneda = 1, 000001.00, c.tipocambio), 0)) AS importe;
FROM;
   cabenotp a,;
   detanotp b,;
   cabecomp c;
WHERE;
   a.tiponota = b.tiponota AND;
   a.nronota = b.nronota AND;
   a.proveedor = b.proveedor AND;
   a.tipodocu = c.tipodocu AND;
   a.nrodocu = c.nrodocu AND;
   a.proveedor = c.proveedor AND;
   a.tiponota = 2 AND;
   b.tipo = "S" AND;
   BETWEEN(a.fechanota, ldDateFrom, ldDateTo);
GROUP BY;
   b.articulo;
INTO CURSOR;
   tm_nota_proveedor

SELECT tm_muestra
SCAN ALL
   lcIdProducto = id_producto

   SELECT tm_venta
   LOCATE FOR articulo = lcIdProducto
   IF FOUND() THEN
      SELECT tm_muestra
      REPLACE cantidad_venta WITH tm_venta.cantidad,;
              importe_venta WITH tm_venta.importe
   ELSE
      WAIT "El producto: '" + ALLTRIM(lcIdProducto) + "' no existe en la tabla de ventas." WINDOW NOWAIT
   ENDIF

   SELECT tm_compra
   LOCATE FOR articulo = lcIdProducto
   IF FOUND() THEN
      SELECT tm_muestra
      REPLACE cantidad_compra WITH tm_compra.cantidad,;
              importe_compra WITH tm_compra.importe
   ELSE
      WAIT "El producto: '" + ALLTRIM(lcIdProducto) + "' no existe en la tabla de compras." WINDOW NOWAIT
   ENDIF

   SELECT tm_nota_cliente
   LOCATE FOR articulo = lcIdProducto
   IF FOUND() THEN
      SELECT tm_muestra
      REPLACE cantidad_venta WITH cantidad_venta - tm_nota_cliente.cantidad,;
              importe_venta WITH importe_venta - tm_nota_cliente.importe
   ELSE
      WAIT "El producto: '" + ALLTRIM(lcIdProducto) + "' no existe en la tabla de nota de crédito de clientes." WINDOW NOWAIT
   ENDIF

   SELECT tm_nota_proveedor
   LOCATE FOR articulo = lcIdProducto
   IF FOUND() THEN
      SELECT tm_muestra
      REPLACE cantidad_compra WITH cantidad_compra - tm_nota_proveedor.cantidad,;
              importe_compra WITH importe_compra - tm_nota_proveedor.importe
   ELSE
      WAIT "El producto: '" + ALLTRIM(lcIdProducto) + "' no existe en la tabla de nota de crédito de proveedores." WINDOW NOWAIT
   ENDIF
ENDSCAN

WAIT "Proceso Concluido" WINDOW NOWAIT

SELECT tm_muestra
REPLACE existencia_final WITH (existencia_inicial + cantidad_compra - cantidad_venta) ALL
BROWSE
BROWSE FOR cantidad <> existencia_final
EXPORT TO c:\movimiento_muestra TYPE XL5