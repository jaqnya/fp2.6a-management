DO seteo

USE proveedo IN 0 SHARED
USE cabecomp IN 0 SHARED
USE cabenotp IN 0 SHARED
USE cabepag IN 0 SHARED

n_moneda = 2   && Dolares Americanos
n_anyo   = 2011
c_excluir = "8, 22, 27, 41, 47, 64, 76"

CREATE CURSOR tm_cuadro (;
   id_proveedor N(5),;
   proveedor C(40),;
   mes N(2),;
   anyo N(4),;
   compra N(9,2),;
   devolucion N(9,2),;
   pago N(9,2);
)

* compras
SELECT;
   a.tipodocu,;
   a.nrodocu,;
   MONTH(a.fechadocu) AS mes,;
   YEAR(a.fechadocu) AS anyo,;
   a.fechadocu,;
   a.proveedor AS id_proveedor,;
   b.nombre AS proveedor,;
   a.monto_fact;
FROM;
   cabecomp a,;
   proveedo b;
WHERE;
   a.proveedor = b.codigo AND;
   !INLIST(a.proveedor, &c_excluir) AND;
   a.moneda = n_moneda AND;
   YEAR(a.fechadocu) = n_anyo;
INTO CURSOR;
   tm_compra

SELECT;
   id_proveedor,;
   proveedor,;
   mes,;
   anyo,;
   SUM(monto_fact) AS monto_fact;
FROM;
   tm_compra;
GROUP BY;
   id_proveedor,;
   proveedor,;
   mes,;
   anyo;
INTO CURSOR;
   tm_compra

* devoluciones
SELECT;
   a.tiponota,;
   a.nronota,;
   MONTH(a.fechanota) AS mes,;
   YEAR(a.fechanota) AS anyo,;
   a.fechanota,;
   a.proveedor AS id_proveedor,;
   b.nombre AS proveedor,;
   a.monto_nota;
FROM;
   cabenotp a,;
   proveedo b,;
   cabecomp c;
WHERE;
   a.proveedor = b.codigo AND;
   a.tipodocu = c.tipodocu AND;
   a.nrodocu = c.nrodocu AND;
   a.proveedor = c.proveedor AND;
   !INLIST(a.proveedor, &c_excluir) AND;
   c.moneda = n_moneda AND;
   YEAR(a.fechanota) = n_anyo;
INTO CURSOR;
   tm_devolucion

SELECT;
   id_proveedor,;
   proveedor,;
   mes,;
   anyo,;
   SUM(monto_nota) AS monto_nota;
FROM;
   tm_devolucion;
GROUP BY;
   id_proveedor,;
   proveedor,;
   mes,;
   anyo;
INTO CURSOR;
   tm_devolucion

* pago
SELECT;
   a.tiporeci,;
   a.nroreci,;
   MONTH(a.fechareci) AS mes,;
   YEAR(a.fechareci) AS anyo,;
   a.fechareci,;
   a.proveedor AS id_proveedor,;
   b.nombre AS proveedor,;
   a.monto_pago;
FROM;
   cabepag a,;
   proveedo b;
WHERE;
   a.proveedor = b.codigo AND;
   !INLIST(a.proveedor, &c_excluir) AND;
   a.moneda = n_moneda AND;
   YEAR(a.fechareci) = n_anyo;
INTO CURSOR;
   tm_pago

SELECT;
   id_proveedor,;
   proveedor,;
   mes,;
   anyo,;
   SUM(monto_pago) AS monto_pago;
FROM;
   tm_pago;
GROUP BY;
   id_proveedor,;
   proveedor,;
   mes,;
   anyo;
INTO CURSOR;
   tm_pago

* Armar cuadro
SELECT tm_compra
SCAN ALL
   n_id_proveedor = id_proveedor
   c_proveedor = proveedor
   n_mes = mes
   n_anyo = anyo
   n_compra = monto_fact

   SELECT tm_cuadro
   LOCATE FOR id_proveedor = n_id_proveedor AND mes = n_mes AND anyo = n_anyo
   IF FOUND() THEN
      REPLACE compra WITH n_compra
   ELSE
      INSERT INTO tm_cuadro VALUES (n_id_proveedor, c_proveedor, n_mes, n_anyo, n_compra, 0, 0)
   ENDIF
ENDSCAN

SELECT tm_devolucion
SCAN ALL
   n_id_proveedor = id_proveedor
   c_proveedor = proveedor
   n_mes = mes
   n_anyo = anyo
   n_devolucion = monto_nota

   SELECT tm_cuadro
   LOCATE FOR id_proveedor = n_id_proveedor AND mes = n_mes AND anyo = n_anyo
   IF FOUND() THEN
      REPLACE devolucion WITH n_devolucion
   ELSE
      INSERT INTO tm_cuadro VALUES (n_id_proveedor, c_proveedor, n_mes, n_anyo, 0, n_devolucion, 0)
   ENDIF
ENDSCAN

SELECT tm_pago
SCAN ALL
   n_id_proveedor = id_proveedor
   c_proveedor = proveedor
   n_mes = mes
   n_anyo = anyo
   n_pago = monto_pago

   SELECT tm_cuadro
   LOCATE FOR id_proveedor = n_id_proveedor AND mes = n_mes AND anyo = n_anyo
   IF FOUND() THEN
      REPLACE pago WITH n_pago
   ELSE
      INSERT INTO tm_cuadro VALUES (n_id_proveedor, c_proveedor, n_mes, n_anyo, 0, 0, n_pago)
   ENDIF
ENDSCAN

SELECT tm_cuadro
BROWSE