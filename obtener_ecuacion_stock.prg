*
* obtener_ecuacion_stock.prg
*
* Derechos Reservados (c) 2000-2012 José Acuña
* Acosta Ñu Nº 143
* Tres Bocas, Villa Elisa, Paraguay
* E-Mail: turtlesoftpy@gmail.com
*
* Descripción:
* Función para obtener el precio de costo neto de los productos de las compras
* comprendidas en un rango de fecha determinado.
*
* Historial de Modificación:
* Octubre 31, 2011   José Avilio Acuña Acosta   Creador del Programa
*
FUNCTION obtener_ecuacion_stock
   PARAMETERS d_desde, d_hasta

   * begin { validación de parámetros }
   IF PARAMETERS() < 2 THEN
      MESSAGEBOX("No se han pasado suficientes parámetros.", 0+64, "Función: obtener_ecuacion_stock")
      RETURN .F.
   ENDIF

   IF TYPE("d_desde") <> "D" THEN
      MESSAGEBOX("El parámetro 'd_desde' debe ser de tipo fecha.", 0+64, "Función: obtener_ecuacion_stock")
      RETURN .F.
   ENDIF

   IF TYPE("d_hasta") <> "D" THEN
      MESSAGEBOX("El parámetro 'd_hasta' debe ser de tipo fecha.", 0+64, "Función: obtener_ecuacion_stock")
      RETURN .F.
   ENDIF
   * end { validación de parámetros }

   * begin { código principal }
   abrir_archivo()

   * selecciona todos los registros de la cabecera de compras que cumplan con la condición.
   WAIT "Consultando [COMPRAS]..." WINDOW NOWAIT
   SELECT;
      tipodocu,;
      nrodocu,;
      proveedor;
   FROM;
      cabecomp;
   WHERE;
      BETWEEN(fechadocu, d_desde, d_hasta);
   INTO CURSOR;
      tm_cabecomp

   n_contador = 0
   SELECT tm_cabecomp
   SCAN ALL
      n_contador = n_contador + 1
      WAIT "Procesando [COMPRAS]... " + ALLTRIM(STR(n_contador)) + "/" + ALLTRIM(STR(RECCOUNT())) WINDOW NOWAIT

      DO obtener_detalle_neto_compra WITH tipodocu, nrodocu, proveedor

      SELECT tm_detacomp
      SCAN ALL
         c_articulo = articulo
         c_producto = producto
         n_cantidad_compra = cantidad
         n_importe_compra  = ROUND(precio_unit_mmnn * cantidad, 0)

         SELECT tm_cuadro
         LOCATE FOR articulo = c_articulo
         IF FOUND() THEN
            REPLACE cantidad_compra WITH cantidad_compra + n_cantidad_compra,;
                    importe_compra  WITH importe_compra  + n_importe_compra
         ELSE
            INSERT INTO tm_cuadro (articulo, producto, cantidad_compra, importe_compra);
               VALUES (c_articulo, c_producto, n_cantidad_compra, n_importe_compra)
         ENDIF
      ENDSCAN
   ENDSCAN
   
   * selecciona todos los registros de la cabecera de notas de créditos de proveedores que cumplan con la condición.
   WAIT "Consultando [NOTAS DE CRÉDITOS - PROVEEDORES]..." WINDOW NOWAIT
   SELECT;
      a.tiponota,;
      a.nronota,;
      a.tipodocu,;
      a.nrodocu,;
      a.proveedor,;
      IIF(b.tipocambio = 0, 000001.00, b.tipocambio) AS tipocambio;
   FROM;
      cabenotp a,;
      cabecomp b;
   WHERE;
      a.tipodocu = b.tipodocu AND;
      a.nrodocu = b.nrodocu AND;
      a.proveedor = b.proveedor AND;
      BETWEEN(a.fechanota, d_desde, d_hasta);
   INTO CURSOR;
      tm_cabenotp

   n_contador = 0
   SELECT tm_cabenotp
   SCAN ALL
      n_contador = n_contador + 1
      WAIT "Procesando [NOTAS DE CRÉDITOS - PROVEEDORES]... " + ALLTRIM(STR(n_contador)) + "/" + ALLTRIM(STR(RECCOUNT())) WINDOW NOWAIT

      * obtiene datos de la cabecera.
      n_tiponota = tiponota
      n_nronota = nronota
      n_proveedor = proveedor
      n_tipocambio = tipocambio

      * selecciona el detalle de la nota de crédito.
      SELECT;
         a.tipo,;
         a.articulo,;
         b.nombre AS producto,;
         a.cantidad,;
         a.precio,;
         a.pdescuento;
      FROM;
         detanotp a,;
         maesprod b;
      WHERE;
         a.tiponota = n_tiponota AND;
         a.nronota = n_nronota AND;
         a.proveedor = n_proveedor AND;
   	     a.articulo = b.codigo;
      INTO CURSOR;
         tm_detanotp
      
      SELECT tm_detanotp
      SCAN ALL
         c_tipo = tipo
         c_articulo = articulo
         c_producto = producto
         n_cantidad_compra = cantidad
         n_subtotal = ROUND(precio * cantidad, 4)
         n_descuento = ROUND(n_subtotal * pdescuento / 100, 4)
         n_importe_compra = ROUND((n_subtotal - n_descuento) * n_tipocambio, 0)

         SELECT tm_cuadro
         LOCATE FOR articulo = c_articulo
         IF FOUND() THEN
            IF c_tipo = "S" THEN
               REPLACE cantidad_compra WITH cantidad_compra - n_cantidad_compra
            ENDIF
            REPLACE importe_compra  WITH importe_compra - n_importe_compra
         ELSE
            INSERT INTO tm_cuadro (articulo, producto, cantidad_compra, importe_compra);
               VALUES (c_articulo, c_producto, IIF(c_tipo = "S", -n_cantidad_compra, 0), -n_importe_compra)
         ENDIF
      ENDSCAN
   ENDSCAN

   * selecciona todos los registros de la cabecera de ventas que cumplan con la condición.
   WAIT "Consultando [VENTAS]..." WINDOW NOWAIT
   SELECT;
      b.articulo,;
      c.nombre AS producto,;
      SUM(b.cantidad) AS cantidad;
   FROM;
      cabevent a,;
      detavent b,;
      maesprod c;
   WHERE;
      a.tipodocu = b.tipodocu AND;
      a.nrodocu = b.nrodocu AND;
      b.articulo = c.codigo AND;
      BETWEEN(a.fechadocu, d_desde, d_hasta);
   GROUP BY;
      b.articulo,;
      c.nombre;
   INTO CURSOR;
      tm_detavent

   n_contador = 0
   SELECT tm_detavent
   SCAN ALL
      n_contador = n_contador + 1
      WAIT "Procesando [VENTAS]... " + ALLTRIM(STR(n_contador)) + "/" + ALLTRIM(STR(RECCOUNT())) WINDOW NOWAIT

      * obtener datos del detalle.
      c_articulo = articulo
      c_producto = producto
      n_cantidad_venta = cantidad

      SELECT tm_cuadro
      LOCATE FOR articulo = c_articulo
      IF FOUND() THEN
         REPLACE cantidad_venta WITH cantidad_venta + n_cantidad_venta
      ELSE
         INSERT INTO tm_cuadro (articulo, producto, cantidad_venta);
            VALUES (c_articulo, c_producto, n_cantidad_venta)
      ENDIF
   ENDSCAN

   * selecciona todos los registros de la cabecera de notas de creditos de clientes que cumplan con la condición.
   WAIT "Consultando [NOTAS DE CREDITOS - CLIENTES]..." WINDOW NOWAIT
   SELECT;
      b.articulo,;
      c.nombre AS producto,;
      SUM(b.cantidad) AS cantidad;
   FROM;
      cabenotc a,;
      detanotc b,;
      maesprod c;
   WHERE;
      a.tiponota = b.tiponota AND;
      a.nronota = b.nronota AND;
      b.articulo = c.codigo AND;
      b.tipo = "S" AND;
      BETWEEN(a.fechanota, d_desde, d_hasta);
   GROUP BY;
      b.articulo,;
      c.nombre;
   INTO CURSOR;
      tm_detanotc

   n_contador = 0
   SELECT tm_detanotc
   SCAN ALL
      n_contador = n_contador + 1
      WAIT "Procesando [NOTAS DE CREDITOS - CLIENTES]... " + ALLTRIM(STR(n_contador)) + "/" + ALLTRIM(STR(RECCOUNT())) WINDOW NOWAIT

      * obtener datos del detalle.
      c_articulo = articulo
      c_producto = producto
      n_cantidad_venta = cantidad

      SELECT tm_cuadro
      LOCATE FOR articulo = c_articulo
      IF FOUND() THEN
         REPLACE cantidad_venta WITH cantidad_venta - n_cantidad_venta
      ELSE
         INSERT INTO tm_cuadro (articulo, producto, cantidad_venta);
            VALUES (c_articulo, c_producto, -n_cantidad_venta)
      ENDIF
   ENDSCAN

   * cierra todas las tablas excepto el cursor 'tm_cuadro'
   cerrar_archivo()

   * realiza consultas en el disco duro local para saber la existencia de acuerdo a la copia de respaldo correspondiente.
   USE c:\turtle\aya\integrad.000\maesprod IN 0 ALIAS maespcen
   USE c:\turtle\aya\integrad.001\maesprod IN 0 ALIAS maespsuc

   * archivo maestro de productos de la casa central.
   SELECT;
      codigo AS articulo,;
      nombre AS producto,;
      stock_actu AS cantidad,;
      pcostog AS ultimo_costo;
   FROM;
      maespcen;
   WHERE;
      stock_actu > 0;
   INTO CURSOR;
      tm_maespcen

   n_contador = 0
   SELECT tm_maespcen
   SCAN ALL
      n_contador = n_contador + 1
      WAIT "Procesando [PRODUCTOS - CENTRAL - LOCAL HDD]... " + ALLTRIM(STR(n_contador)) + "/" + ALLTRIM(STR(RECCOUNT())) WINDOW NOWAIT

      * obtener datos del detalle.
      c_articulo = articulo
      c_producto = producto
      n_cantidad_saldo = cantidad
      n_ultimo_costo = ultimo_costo

      SELECT tm_cuadro
      LOCATE FOR articulo = c_articulo
      IF FOUND() THEN
         REPLACE cantidad_saldo WITH cantidad_saldo + n_cantidad_saldo
      ELSE
         INSERT INTO tm_cuadro (articulo, producto, cantidad_saldo, ultimo_costo);
            VALUES (c_articulo, c_producto, n_cantidad_saldo, n_ultimo_costo)
      ENDIF
   ENDSCAN

   * archivo maestro de productos de la sucursal.
   SELECT;
      codigo AS articulo,;
      nombre AS producto,;
      stock_actu AS cantidad;
   FROM;
      maespsuc;
   WHERE;
      stock_actu > 0;
   INTO CURSOR;
      tm_maespsuc

   n_contador = 0
   SELECT tm_maespsuc
   SCAN ALL
      n_contador = n_contador + 1
      WAIT "Procesando [PRODUCTOS - DEPOSITO - LOCAL HDD]... " + ALLTRIM(STR(n_contador)) + "/" + ALLTRIM(STR(RECCOUNT())) WINDOW NOWAIT

      * obtener datos del detalle.
      c_articulo = articulo
      c_producto = producto
      n_cantidad_saldo = cantidad

      SELECT tm_cuadro
      LOCATE FOR articulo = c_articulo
      IF FOUND() THEN
         REPLACE cantidad_saldo WITH cantidad_saldo + n_cantidad_saldo
      ELSE
         INSERT INTO tm_cuadro (articulo, producto, cantidad_saldo);
            VALUES (c_articulo, c_producto, n_cantidad_saldo)
      ENDIF
   ENDSCAN

   IF USED("maespcen") THEN
      SELECT maespcen
      USE
   ENDIF

   IF USED("maespsuc") THEN
      SELECT maespsuc
      USE
   ENDIF

   * procesa los datos del inventario inicial de mercaderías.
   USE c:\inventario2011 IN 0
   
   n_contador = 0
   SELECT inventario2011
   SCAN ALL
      n_contador = n_contador + 1
      WAIT "Procesando [INVENTARIO INICIAL]... " + ALLTRIM(STR(n_contador)) + "/" + ALLTRIM(STR(RECCOUNT())) WINDOW NOWAIT

      * obtener datos del archivo
      c_articulo = articulo
      c_producto = producto
      n_cantidad_inicial = cantidad
      n_importe_inicial = total

      SELECT tm_cuadro
      LOCATE FOR articulo = c_articulo
      IF FOUND() THEN
         REPLACE cantidad_inicial WITH cantidad_inicial + n_cantidad_inicial,;
                 importe_inicial WITH importe_inicial + n_importe_inicial
      ELSE
         INSERT INTO tm_cuadro (articulo, producto, cantidad_inicial, importe_inicial);
            VALUES (c_articulo, c_producto, n_cantidad_inicial, n_importe_inicial)
      ENDIF      
   ENDSCAN
   
   IF USED("inventario2011") THEN
      SELECT inventario2011
      USE
   ENDIF

   * archivo maestro de productos de la casa central para obtener el ultimo precio de costo.
   USE c:\turtle\aya\integrad.000\maesprod IN 0 ALIAS maespcen
   
   SELECT;
      codigo AS articulo,;
      nombre AS producto,;
      stock_actu AS cantidad,;
      pcostog AS ultimo_costo;
   FROM;
      maespcen;
   INTO CURSOR;
      tm_maespcen

   n_contador = 0
   SELECT tm_maespcen
   SCAN ALL
      n_contador = n_contador + 1
      WAIT "Procesando [PRODUCTOS :: ULTIMO COSTO :: - CENTRAL - LOCAL HDD]... " + ALLTRIM(STR(n_contador)) + "/" + ALLTRIM(STR(RECCOUNT())) WINDOW NOWAIT

      * obtener datos del detalle.
      c_articulo = articulo
      n_ultimo_costo = ultimo_costo

      SELECT tm_cuadro
      LOCATE FOR articulo = c_articulo
      IF FOUND() THEN
         REPLACE ultimo_costo WITH n_ultimo_costo
      ENDIF
   ENDSCAN

   IF USED("maespcen") THEN
      SELECT maespcen
      USE
   ENDIF

   SELECT tm_cuadro
   BROWSE FOR cantidad_compra = 0 AND importe_compra <> 0
   REPLACE importe_compra WITH 0 FOR cantidad_compra = 0 AND importe_compra <> 0
   BROWSE
   * end { código principal }
ENDFUNC

*-----------------------------------------------------------------------------*
PROCEDURE abrir_archivo
   * establece que el intento de bloqueo de las tablas se realice una sola vez.
   IF SET("REPROCESS") <> 1 THEN
      SET REPROCESS TO 1
   ENDIF

   * archivos de referencia.
   IF .NOT. USED("cabecomp") THEN
      USE cabecomp IN 0 AGAIN ORDER 0 SHARED
   ENDIF

   IF .NOT. USED("detacomp") THEN
      USE detacomp IN 0 AGAIN ORDER 0 SHARED
   ENDIF

   IF .NOT. USED("cabenotp") THEN
      USE cabenotp IN 0 AGAIN ORDER 0 SHARED
   ENDIF

   IF .NOT. USED("detanotp") THEN
      USE detanotp IN 0 AGAIN ORDER 0 SHARED
   ENDIF

   IF .NOT. USED("cabevent") THEN
      USE cabevent IN 0 AGAIN ORDER 0 SHARED
   ENDIF

   IF .NOT. USED("detavent") THEN
      USE detavent IN 0 AGAIN ORDER 0 SHARED
   ENDIF

   IF .NOT. USED("cabenotc") THEN
      USE cabenotc IN 0 AGAIN ORDER 0 SHARED
   ENDIF

   IF .NOT. USED("detanotc") THEN
      USE detanotc IN 0 AGAIN ORDER 0 SHARED
   ENDIF

   IF .NOT. USED("maesprod") THEN
      USE maesprod IN 0 AGAIN ORDER 0 SHARED
   ENDIF

   IF .NOT. USED("proveedo") THEN
      USE proveedo IN 0 AGAIN ORDER 0 SHARED
   ENDIF

   CREATE CURSOR tm_cuadro (;
      articulo VARCHAR(15),;
      producto VARCHAR(40),;
      cantidad_inicial NUMERIC(9,2),;
      importe_inicial INTEGER,;
      cantidad_compra NUMERIC(9,2),;
      importe_compra INTEGER,;
      cantidad_venta NUMERIC(9,2),;
      importe_venta INTEGER,;
      cantidad_saldo NUMERIC(9,2),;
      importe_saldo INTEGER,;
      ultimo_costo NUMERIC(12,4);
   )
   INDEX ON producto TAG producto
ENDPROC

*-----------------------------------------------------------------------------*
PROCEDURE cerrar_archivo
   * archivos de referencia.
   IF USED("cabecomp") THEN
      SELECT cabecomp
      USE
   ENDIF

   IF USED("detacomp") THEN
      SELECT detacomp
      USE
   ENDIF

   IF USED("cabenotp") THEN
      SELECT cabenotp
      USE
   ENDIF

   IF USED("detanotp") THEN
      SELECT detanotp
      USE
   ENDIF

   IF USED("cabevent") THEN
      SELECT cabevent
      USE
   ENDIF

   IF USED("detavent") THEN
      SELECT detavent
      USE
   ENDIF

   IF USED("cabenotc") THEN
      SELECT cabenotc
      USE
   ENDIF

   IF USED("detanotc") THEN
      SELECT detanotc
      USE
   ENDIF

   IF USED("maesprod") THEN
      SELECT maesprod
      USE
   ENDIF

   IF USED("proveedo") THEN
      SELECT proveedo
      USE
   ENDIF

   * cursores.
   IF USED("tm_cabecomp") THEN
      SELECT tm_cabecomp
      USE
   ENDIF

   IF USED("tm_detacomp") THEN
      SELECT tm_detacomp
      USE
   ENDIF

   IF USED("tm_detavent") THEN
      SELECT tm_detavent
      USE
   ENDIF

   IF USED("tm_cabenotp") THEN
      SELECT tm_cabenotp
      USE
   ENDIF

   IF USED("tm_detanotp") THEN
      SELECT tm_detanotp
      USE
   ENDIF
ENDPROC