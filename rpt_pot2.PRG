PARAMETER m.serie, m.nrobole

pcLocal = "A & A IMPORTACIONES S.R.L."

SELECT cabemot2
LOCATE FOR serie = m.serie AND nrobole = m.nrobole
IF FOUND() THEN
   m.tipobole    = tipobole
   m.serie       = serie
   m.nrobole     = nrobole
   m.fecha       = fecha
   m.id_vend     = vendedor
   m.observacion = ALLTRIM(obs1) + ALLTRIM(obs2) + ALLTRIM(obs3)
   m.porcdesc    = porcdesc
   m.importdesc  = importdesc
   m.monto_fact  = monto_fact
ELSE
   WAIT "LA OT N§ " + ALLTRIM(m.serie) + "-" + ALLTRIM(STR(m.nrobole)) + " NO EXISTE." WINDOW
   RETURN
ENDIF

dbf_file = "tmp" + RIGHT(SYS(2015), 5)

CREATE TABLE (dbf_file) (;
   tipobole N(1),;
   serie C(1),;
   nropedido N(7),;
   fecha D(8),;
   hora C(8),;
   id_cliente N(5),;
   cliente C(56),;
   direccion C(60),;
   telefono C(30),;
   fax C(30),;
   ruc C(15),;
   id_vend N(5),;
   vendedor C(30),;
   id_mec N(5),;
   mecanico C(30),;
   id_product C(15),;
   cod_origen C(15),;
   cod_altern C(15),;
   ubicacion C(10),;
   producto C(50),;
   cantidad N(9,2),;
   precio N(9),;
   porc_iva N(6,2),;
   porcdesc N(8,4),;
   importdesc N(9),;
   estado C(24),;
   stock_cen N(9,2),;
   stock_dep N(9,2);
)

SELECT ot
LOCATE FOR serie = m.serie AND nroot = m.nrobole
IF FOUND() THEN
   m.id_cliente = cliente
   m.cliente    = nombreot
   m.ruc        = cedulaot
   m.direccion  = direcot
   m.telefono   = telefot
   m.fax        = ""
   m.contacto   = contacto
   m.maquina    = maquina
   m.marca      = marca
   m.modelo     = modelo
   m.accesorio  = accesorio
   m.motor      = IIF(!EMPTY(motor), motor, '(SIN ESPECIFICAR)')
   m.id_mec     = mecanico
   m.frecepcion = frecepcion
   m.fpentrega  = fpentrega
   m.trabajo    = ALLTRIM(trabajo1) + IIF(!EMPTY(trabajo2), '  /  ' + ALLTRIM(trabajo2), '') + IIF(!EMPTY(trabajo3), '  /  ' + ALLTRIM(trabajo3), '')
   m.id_estado  = estadoot
ENDIF

IF m.id_cliente > 1 THEN
   SELECT clientes
   LOCATE FOR codigo = m.id_cliente
   IF FOUND() THEN
      m.ruc = ruc
      m.fax = fax
   ENDIF
ENDIF

SELECT estadoot
LOCATE FOR codigo = m.id_estado
IF FOUND() THEN
   m.estado = nombre
   IF m.id_estado = 1 THEN
      m.estado = 'RECEPCION'
   ENDIF
ELSE
   m.estado = ""
ENDIF

SELECT vendedor
LOCATE FOR codigo = m.id_vend
IF FOUND() THEN
   m.vendedor = nombre
   IF m.id_vend = 1 THEN
      m.vendedor = '(SIN ESPECIFICAR)'
   ENDIF
ELSE
   m.vendedor = ""
ENDIF

SELECT mecanico
LOCATE FOR codigo = m.id_mec
IF FOUND() THEN
   m.mecanico = nombre
   IF m.id_mec = 1 THEN
      m.mecanico = '(SIN ESPECIFICAR)'
   ENDIF
ELSE
   m.mecanico = ""
ENDIF

m.equipo = ""

SELECT maquinas
LOCATE FOR codigo = m.maquina
IF FOUND() THEN
   m.equipo = m.equipo + ALLTRIM(nombre)
ENDIF

SELECT marcas2
LOCATE FOR codigo = m.marca
IF FOUND() THEN
   m.equipo = m.equipo + ' ' + ALLTRIM(nombre)
ENDIF

SELECT modelos
LOCATE FOR codigo = m.modelo
IF FOUND() THEN
   m.equipo = m.equipo + ' ' + ALLTRIM(nombre)
ENDIF

SELECT detamot2
SET ORDER TO 1
IF SEEK(STR(m.tipobole, 1)+ m.serie + STR(m.nrobole, 7)) THEN
   SCAN WHILE tipobole = m.tipobole AND serie = m.serie AND nrobole = m.nrobole
      m.id_product = articulo
      m.descr_trab = descr_trab
      m.cantidad   = cantidad
      m.precio     = precio
      m.porc_iva   = pimpuesto

      SELECT maesprod
      SET ORDER TO 1
      IF SEEK(m.id_product) THEN
         m.producto   = IIF(EMPTY(m.descr_trab), nombre, m.descr_trab)
         m.cod_altern = codigo2
         m.cod_origen = codorig
         m.ubicacion  = ubicacion
      ELSE
         m.producto   = m.descr_trab
         m.cod_altern = ""
         m.cod_origen = ""
         m.ubicacion  = ""
      ENDIF

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
      IF !INLIST(ALLTRIM(m.id_product), "99013", "99014", "99015", "99016", "10001") THEN
         REPLACE stock_cen WITH maesprod.stock_actu - maesprod.stock_ot
      ELSE
         REPLACE stock_cen WITH 0
      ENDIF
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
      IF !INLIST(ALLTRIM(m.id_product), "99013", "99014", "99015", "99016", "10001") THEN
         REPLACE stock_dep WITH maesprod2.stock_actu - maesprod2.stock_ot
      ELSE
         REPLACE stock_dep WITH 0
      ENDIF
   ENDIF
ENDSCAN

IF USED("maesprod2") THEN
   SELECT maesprod2
   USE
ENDIF

dbf_file2 = "tmp" + RIGHT(SYS(2015), 5)

CREATE TABLE (dbf_file2) (;
   tipobole N(1),;
   serie C(1),;
   nrobole N(10),;
   fecha D(8),;
   frecepcion D(8),;
   fpentrega D(8),;
   id_cliente N(5),;
   cliente C(56),;
   direccion C(60),;
   telefono C(30),;
   fax C(30),;
   ruc C(15),;
   equipo C(50),;
   accesorio C(56),;
   motor C(25),;
   trabajo C(180),;
   id_vend N(5),;
   vendedor C(30),;
   id_mec N(5),;
   mecanico C(30),;
   id_product C(15),;
   cod_origen C(15),;
   cod_altern C(15),;
   ubicacion C(10),;
   producto C(50),;
   cantidad N(9,2),;
   precio N(9),;
   porc_iva N(6,2),;
   porcdesc N(8,4),;
   importdesc N(9),;
   estado C(24),;
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
      CASE m.cantidad > (m.stock_cen + m.stock_dep)
         m.faltante = m.cantidad - (m.stock_cen + m.stock_dep)

         IF m.stock_cen > 0 THEN
            m.almacen = "CASA CENTRAL"
            m.cantidad = m.stock_cen
            INSERT INTO (dbf_file2) FROM MEMVAR
         ENDIF

         IF m.stock_dep > 0 THEN
            m.almacen = "DEPOSITO"
            m.cantidad = m.stock_dep
            INSERT INTO (dbf_file2) FROM MEMVAR
         ENDIF

         m.almacen = "SIN EXISTENCIA"
         m.cantidad = m.faltante
         INSERT INTO (dbf_file2) FROM MEMVAR         
      CASE INLIST(ALLTRIM(m.id_product), "99013", "99014", "99015", "99016", "10001")
         m.almacen = "CASA CENTRAL"
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

SELECT (dbf_file2)
REPLACE precio WITH ROUND(precio * (1 + porc_iva / 100), 0) ALL
m.archivo = 'tmp' + RIGHT(SYS(2015), 5)
EXPORT TO SYS(5) + '\' + m.archivo TYPE XLS
WAIT "La hoja de c lculo '" + m.archivo + "' ha sido creada en la unidad " + SYS(5) WINDOW NOWAIT
USE
DELETE FILE (dbf_file2 + ".dbf")
DELETE FILE (dbf_file2 + ".cdx")