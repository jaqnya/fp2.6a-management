CREATE TABLE cabeimpo ;
  (nro_import C(9),;
   proveedor  N(5),;
   fecha_impo D(8),;
   forma_pago N(4),;
   divisa     N(4),;
   cambio_adu N(11,4),;
   cambio_gto N(11,4),;
   cambio_vta N(11,4),;
   porcdesc   N(8,4),;
   importdesc N(12,2),;
   monto_fact N(12,2),;
   monto_pago N(12,2),;
   gastos     N(12,2))

USE cabeimpo
INDEX ON nro_import + STR(proveedor, 5) TAG indice1
INDEX ON DTOS(fecha_impo)               TAG indice2
INDEX ON proveedor                      TAG indice3

CREATE TABLE detaimpo ;
  (nro_import C(9),;
   proveedor  N(5),;
   articulo   C(15),;
   cantidad   N(8,2),;
   precio     N(13,4),;
   descuento  N(7,4),;
   tasa_iva   N(6,2),;
   descr_acti C(40),;
   familia    N(4),;
   rubro      N(4),;
   subrubro   N(4),;
   marca      N(4),;
   unidad     N(4),;
   proceden   N(4),;
   proveedo   N(4))

USE detaimpo
INDEX ON nro_import + STR(proveedor, 5) TAG indice1

CREATE TABLE cuotas_i ;
  (nro_import C(9),;
   proveedor  N(5),;
   tipo       N(1),;
   nro_cuota  N(3),;
   fecha      D(8),;
   importe    N(12,2),;
   abonado    N(12,2),;
   monto_ndeb N(12,2),;
   monto_ncre N(12,2))

USE cuotas_i
INDEX ON nro_import + STR(proveedor, 5) + STR(nro_cuota, 3) TAG indice1

CREATE TABLE gto_desp ;
  (nro_import C(9),;
   proveedor  N(5),;
   codigo     N(4),;
   monto      N(9),;
   exento     N(9),;
   gravado    N(9),;
   iva_credit N(9),;
   renta      N(9))

USE gto_desp
INDEX ON nro_import + STR(proveedor, 5) TAG indice1

CREATE TABLE detaimp2 ;
  (nro_import C(9),;
   proveedor  N(5),;
   articulo   C(15),;
   pcostog    N(13,4),;
   pcostod    N(13,4),;
   pventag1   N(13,4),;
   pventag2   N(13,4),;
   pventag3   N(13,4),;
   pventag4   N(13,4),;
   pventag5   N(13,4),;
   pventad1   N(13,4),;
   pventad2   N(13,4),;
   pventad3   N(13,4),;
   pventad4   N(13,4),;
   pventad5   N(13,4),;
   h_pcostog  N(13,4),;
   h_pcostod  N(13,4),;
   h_pventag1 N(13,4),;
   h_pventag2 N(13,4),;
   h_pventag3 N(13,4),;
   h_pventag4 N(13,4),;
   h_pventag5 N(13,4),;
   h_pventad1 N(13,4),;
   h_pventad2 N(13,4),;
   h_pventad3 N(13,4),;
   h_pventad4 N(13,4),;
   h_pventad5 N(13,4),;
   h_fecucomp D(8))

USE detaimp2
INDEX ON nro_import + STR(proveedor, 5) TAG indice1

CREATE TABLE form_pag ;
  (codigo     N(4),;
   nombre     C(30),;
   num_pago   N(3),;
   dias_plazo N(3),;
   vigente    L(1))

USE form_pag
INDEX ON codigo TAG indice1
INDEX ON nombre TAG indice2

INSERT INTO form_pag (codigo, nombre, num_pago, dias_plazo, vigente) ;
   VALUES (1, "CONTADO", 0, 0, .T.)

INSERT INTO form_pag (codigo, nombre, num_pago, dias_plazo, vigente) ;
   VALUES (2, "30 DIAS", 1, 30, .T.)

INSERT INTO form_pag (codigo, nombre, num_pago, dias_plazo, vigente) ;
   VALUES (3, "60 DIAS", 1, 60, .T.)

INSERT INTO form_pag (codigo, nombre, num_pago, dias_plazo, vigente) ;
   VALUES (4, "30/60 DIAS", 2, 30, .T.)

INSERT INTO form_pag (codigo, nombre, num_pago, dias_plazo, vigente) ;
   VALUES (5, "30/60/90 DIAS", 3, 30, .T.)

INSERT INTO form_pag (codigo, nombre, num_pago, dias_plazo, vigente) ;
   VALUES (6, "TARJETA DE CREDITO", 0, 0, .T.)

INSERT INTO form_pag (codigo, nombre, num_pago, dias_plazo, vigente) ;
   VALUES (7, "CHEQUE AL DIA", 0, 0, .T.)

INSERT INTO form_pag (codigo, nombre, num_pago, dias_plazo, vigente) ;
   VALUES (8, "CHEQUE DIFERIDO", 0, 0, .T.)
