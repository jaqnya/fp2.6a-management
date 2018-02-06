*
* obtener_detalle_neto_compra.prg
*
* Derechos Reservados (c) 2000-2012 José Acuña
* Acosta Ñu Nº 143
* Tres Bocas, Villa Elisa, Paraguay
* E-Mail: turtlesoftpy@gmail.com
*
* Descripción:
* Función para obtener el precio de costo neto de los productos de una compra,
* devuelve el cursor 'tm_detacomp' como resultado del proceso;
* solo efectúa la operación si el parámetro 'n_tipodocu' es igual a 1, 2, 7 u 8.
*
* Historial de Modificación:
* Octubre 30, 2011   José Avilio Acuña Acosta   Creador del Programa
*
FUNCTION obtener_detalle_neto_compra
   PARAMETERS n_tipodocu, n_nrodocu, n_proveedor

   * begin { validación de parámetros }
   IF PARAMETERS() < 3 THEN
      MESSAGEBOX("No se han pasado suficientes parámetros.", 0+64, "Función: obtener_detalle_neto_compra")
      RETURN .F.
   ENDIF

   IF TYPE("n_tipodocu") <> "N" THEN
      MESSAGEBOX("El parámetro 'n_tipodocu' debe ser de tipo numérico.", 0+64, "Función: obtener_detalle_neto_compra")
      RETURN .F.
   ENDIF

   IF TYPE("n_nrodocu") <> "N" THEN
      MESSAGEBOX("El parámetro 'n_nrodocu' debe ser de tipo numérico.", 0+64, "Función: obtener_detalle_neto_compra")
      RETURN .F.
   ENDIF

   IF TYPE("n_proveedor") <> "N" THEN
      MESSAGEBOX("El parámetro 'n_proveedor' debe ser de tipo numérico.", 0+64, "Función: obtener_detalle_neto_compra")
      RETURN .F.
   ENDIF

   IF .NOT. INLIST(n_tipodocu, 1, 2, 7, 8) THEN
      MESSAGEBOX("El parámetro 'n_tipodocu' debe ser: 1, 2, 7 u 8.", 0+64, "Función: obtener_detalle_neto_compra")
      RETURN .F.
   ENDIF
   * end { validación de parámetros }

   * begin { código principal }
   abrir_archivo()

   SELECT cabecomp
   LOCATE FOR tipodocu = n_tipodocu AND nrodocu = n_nrodocu AND proveedor = n_proveedor
   IF .NOT. FOUND() THEN
      MESSAGEBOX("La cabecera de la compra no existe." + CHR(13) + CHR(13) +;
                 "Parámetros de la función:" + CHR(13) +;
                 "-------------------------------" + CHR(13) +;
                 "n_tipodocu = " + ALLTRIM(STR(n_tipodocu)) + CHR(13) +;
                 "n_nrodocu = " + ALLTRIM(STR(n_nrodocu)) + CHR(13) +;
                 "n_proveedor = " + ALLTRIM(STR(n_proveedor)), 0+64, "Función: obtener_detalle_neto_compra")
      RETURN .F.
   ENDIF

   * determina las posiciones decimales y el tipo de cambio.
   n_decimales = IIF(cabecomp.moneda = 1, 0, 2)
   n_tipocambio = IIF(cabecomp.tipocambio = 0, 1, cabecomp.tipocambio)

   * obtiene y calcula los valores iniciales del detalle de compras.
   SELECT detacomp
   SCAN FOR tipodocu = n_tipodocu AND nrodocu = n_nrodocu AND proveedor = n_proveedor
      DO CASE
         CASE INLIST(n_tipodocu, 1, 2)   && I.V.A. discriminado.
            * campos complementarios.
            n_precio = precio
            l_iva_incluido = .F.
         CASE INLIST(n_tipodocu, 7, 8)   && I.V.A. incluido.
            * campo calculado.
            n_precio = ROUND(precio * (1 + pimpuesto / 100), 4)
            * campo complementario.
            l_iva_incluido = .T.
      ENDCASE

      * campos calculados.
      n_subtotal_a = ROUND(n_precio * cantidad, n_decimales)
      n_desc_linea = ROUND(n_subtotal_a * pdescuento / 100, n_decimales)
      n_subtotal_b = n_subtotal_a - n_desc_linea

      * campos complementarios.
      c_articulo = articulo
      n_cantidad = cantidad
      n_porc_desc = pdescuento
      n_porc_iva = pimpuesto

      * obtiene el nombre del producto.
      SELECT maesprod
      LOCATE FOR codigo = c_articulo
      IF FOUND() THEN
         c_producto = nombre
      ELSE
         MESSAGEBOX("El artículo: " + ALLTRIM(c_articulo) + " no existe.", 0+64, "Función: obtener_detalle_neto_compra")
      ENDIF

      INSERT INTO tm_detacomp (tipodocu, nrodocu, proveedor, articulo, producto, cantidad, precio, subtotal_a, porc_desc, desc_linea, subtotal_b, porc_iva, iva_incluido);
         VALUES (n_tipodocu, n_nrodocu, n_proveedor, c_articulo, c_producto, n_cantidad, n_precio, n_subtotal_a, n_porc_desc, n_desc_linea, n_subtotal_b, n_porc_iva, l_iva_incluido)
   ENDSCAN

   * calcula el porcentaje de participación de cada línea de detalle con relación al subtotal_b; halla el total_neto y total_neto_mmnn.
   SELECT tm_detacomp
   SUM subtotal_b TO n_suma_subtotal_b
   REPLACE porc_part WITH ROUND(subtotal_b / n_suma_subtotal_b * 100, 6),;
           dcto_gral WITH ROUND(cabecomp.importdesc * porc_part / 100, n_decimales) ALL

   * determina si hay diferencia por redondeo y si es así realiza el ajuste correspondiente.
   SELECT tm_detacomp
   SUM dcto_gral TO n_suma_dcto_gral

   IF n_suma_dcto_gral <> cabecomp.importdesc THEN
      SELECT tm_detacomp
      GOTO TOP
      REPLACE dcto_gral WITH dcto_gral + (cabecomp.importdesc - n_suma_dcto_gral)
   ENDIF

   REPLACE total_neto WITH subtotal_b - dcto_gral,;
           total_neto_mmnn WITH ROUND(total_neto * n_tipocambio, 0) ALL

   * determina si hay diferencia por redondeo y si es así realiza el ajuste correspondiente.
   SELECT tm_detacomp
   SUM total_neto, total_neto_mmnn TO n_suma_total_neto, n_suma_total_neto_mmnn
   n_suma_total_neto = ROUND(n_suma_total_neto * n_tipocambio, 0)

   IF n_suma_total_neto <> n_suma_total_neto_mmnn THEN
      SELECT tm_detacomp
      GOTO TOP
      REPLACE total_neto_mmnn WITH total_neto_mmnn + (n_suma_total_neto - n_suma_total_neto_mmnn)
   ENDIF

   * determina el precio de costo unitario sin I.V.A.
   SELECT tm_detacomp
   SCAN ALL
      n_porc_iva = IIF(iva_incluido, ROUND(1 + (porc_iva / 100), 2), 1)
      n_precio_unit_mmnn = ROUND(ROUND(total_neto_mmnn / n_porc_iva, 8) / cantidad, 8)
      REPLACE precio_unit_mmnn WITH n_precio_unit_mmnn
   ENDSCAN
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

   IF .NOT. USED("maesprod") THEN
      USE maesprod IN 0 AGAIN ORDER 0 SHARED
   ENDIF

   IF .NOT. USED("proveedo") THEN
      USE proveedo IN 0 AGAIN ORDER 0 SHARED
   ENDIF

   CREATE CURSOR tm_detacomp (;
      tipodocu INTEGER,;
      nrodocu INTEGER,;
      proveedor INTEGER,;
      articulo VARCHAR(15),;
      producto VARCHAR(40),;
      cantidad NUMERIC(9,2),;
      precio NUMERIC(13,4),;
      subtotal_a NUMERIC(13,4),;
      porc_desc NUMERIC(8,4),;
      desc_linea NUMERIC(13,4),;
      subtotal_b NUMERIC(12,2),;
      porc_part NUMERIC(8,4),;
      dcto_gral NUMERIC(12,2),;
      total_neto NUMERIC(12,2),;
      total_neto_mmnn INTEGER,;
      porc_iva NUMERIC(6,2),;
      iva_incluido LOGICAL(1),;
      precio_unit_mmnn NUMERIC(18,8);
   )
ENDPROC