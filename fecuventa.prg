* Calcula la fecha de ultima venta de los productos
*
* Estructura del archivo datos2.dbf
* --------------------------------
* articulo C(15)
* producto C(56)
* fecha_ven D(8)    // Fecha de la ultima venta del ejercicio cerrado
* fecha_com D(8)    // Fecha de la ultima compra del ejercicio cerrado
* fecha_ven2 D(8)   // Fecha segun los auditores
* cantidad N(6,2)   // Cantidad segun los auditores
* precio N(9,2)     // Precio segun los auditores
* cant_ven N(6,2)   // Cantidad de la ultima venta del ejercicio cerrado
* prec_ven N(9,2)   // Precio de la ultima venta del ejercicio cerrado

DO seteo

USE cabevent IN 0 SHARED
USE detavent IN 0 SHARED
USE cabecomp IN 0 SHARED
USE detacomp IN 0 SHARED
USE c:\datos2 IN 0 EXCLUSIVE

* Determinacion de la fecha de ultima venta
ldFechaTope = CTOD("31/12/2011")

SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.fechadocu,;
   b.articulo,;
   b.cantidad,;
   b.precio;
FROM;
   cabevent a,;
   detavent b;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.fechadocu <= ldFechaTope;
ORDER BY;
   b.articulo,;
   a.fechadocu DESC;
INTO CURSOR;
   tm_venta

SELECT;
   articulo,;
   MAX(fechadocu) AS fecha;
FROM;
   tm_venta;
GROUP BY;
   articulo;
INTO CURSOR;
   tm_ultfecha

SELECT datos2
SCAN ALL
   lcCodigo = articulo
   ldFechaVen = CTOD("  /  /    ")
   
   SELECT tm_ultfecha
   LOCATE FOR articulo = lcCodigo
   IF FOUND() THEN
      ldFechaVen = fecha
   ENDIF
   
   SELECT datos2
   REPLACE fecha_ven WITH ldFechaVen
ENDSCAN

SELECT tm_venta
USE

SELECT tm_ultfecha
USE

* Determinacion de la fecha de ultima compra
SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.fechadocu,;
   b.articulo,;
   b.cantidad,;
   b.precio;
FROM;
   cabecomp a,;
   detacomp b;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.proveedor = b.proveedor AND;
   a.fechadocu <= ldFechaTope;
ORDER BY;
   b.articulo,;
   a.fechadocu DESC;
INTO CURSOR;
   tm_compra

SELECT;
   articulo,;
   MAX(fechadocu) AS fecha;
FROM;
   tm_compra;
GROUP BY;
   articulo;
INTO CURSOR;
   tm_ultfecha

SELECT datos2
SCAN ALL
   lcCodigo = articulo
   ldFechaCom = CTOD("  /  /    ")
   
   SELECT tm_ultfecha
   LOCATE FOR articulo = lcCodigo
   IF FOUND() THEN
      ldFechaCom = fecha
   ENDIF
   
   SELECT datos2
   REPLACE fecha_com WITH ldFechaCom
ENDSCAN

SELECT tm_compra
USE

SELECT tm_ultfecha
USE

* Determinacion de la fecha de ultima venta mas reciente despues del fin del ejercicio
ldFechaTope = CTOD("29/02/2012")

SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.fechadocu,;
   b.articulo,;
   b.cantidad,;
   IIF(a.moneda <> 1, ROUND(a.tipocambio * b.precio, 0), ROUND(b.precio, 0)) AS precio;
FROM;
   cabevent a,;
   detavent b;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.fechadocu <= ldFechaTope;
ORDER BY;
   b.articulo,;
   a.fechadocu DESC;
INTO CURSOR;
   tm_venta

SELECT datos2
SCAN ALL
   lcCodigo = articulo
   ldFechaVen2 = CTOD("  /  /    ")
   lnCantidad = 0
   lnPrecio = 0

   SELECT tm_venta
   LOCATE FOR articulo = lcCodigo
   IF FOUND() THEN
      ldFechaVen2 = fechadocu
      lnCantidad = cantidad
      lnPrecio = precio
   ENDIF
   
   SELECT datos2
   REPLACE fecha_ven2 WITH ldFechaVen2,;
           cantidad WITH lnCantidad,;
           precio WITH lnPrecio
ENDSCAN

SELECT tm_venta
USE

* Determinacion de la fecha de ultima venta del ejercicio cerrado
ldFechaTope = CTOD("31/12/2011")

SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.fechadocu,;
   b.articulo,;
   b.cantidad,;
   IIF(a.moneda <> 1, ROUND(a.tipocambio * b.precio, 0), ROUND(b.precio, 0)) AS precio;
FROM;
   cabevent a,;
   detavent b;
WHERE;
   a.tipodocu = b.tipodocu AND;
   a.nrodocu = b.nrodocu AND;
   a.fechadocu <= ldFechaTope;
ORDER BY;
   b.articulo,;
   a.fechadocu DESC;
INTO CURSOR;
   tm_venta

SELECT datos2
SCAN ALL
   lcCodigo = articulo
   ldFechaVen = CTOD("  /  /    ")
   lnCantVen = 0
   lnPrecVen = 0

   SELECT tm_venta
   LOCATE FOR articulo = lcCodigo
   IF FOUND() THEN
      ldFechaVen = fechadocu
      lnCantVen = cantidad
      lnPrecVen = precio
   ENDIF
   
   SELECT datos2
   IF fecha_ven <> ldFechaVen THEN
      MESSAGEBOX("Las fechas no coinciden." + CHR(13) + "Producto: " + lcCodigo , 0+16, "Error Grave")
   ENDIF

   REPLACE fecha_ven WITH ldFechaVen,;
           cant_ven WITH lnCantVen,;
           prec_ven WITH lnPrecVen
ENDSCAN

SELECT tm_venta
USE

*--------------------------------------*
SELECT datos2
BROWSE