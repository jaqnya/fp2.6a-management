create database albensrl.dbc

create table accesos.dbf (usuario n(04),;
                          fecha_e d(08),;
                          hora_e  c(08),;
                          fecha_s d(08),;
                          hora_s  c(08))

create table ayuda.dbf (programa c(10),;
                        linea    n(03),;
                        ayuda    c(61))

create table barrios.dbf (codigo n(04),;
                          nombre c(30))

create table cabecob.dbf (tiporeci   n(01),;
                          nroreci    n(07),;
                          fechareci  d(08),;
                          factura    c(01),;
                          cliente    n(07),;
                          cobrador   n(03),;
                          comision   n(06,2),;
                          monto_cobr n(09),;
                          localcobro n(01))  

create table cabecomp.dbf (tipodocu   n(01),;
                           nrodocu    n(09),;
                           fechadocu  d(08),;
                           proveedor  n(05),;
                           porcdesc   n(05,2),;
                           importdesc n(08),;
                           monto_fact n(09),;
                           monto_ndeb n(09),;
                           monto_ncre n(09),;
                           monto_pago n(09),;
                           importac   c(01))

create table cabemot.dbf (tipobole   n(01),;
                          serie      c(01),;
                          nrobole    n(07),;
                          fecha      d(08),;
                          monto_fact n(08),;
                          obs        c(40))

create table cabemovi.dbf (tipobole   n(01),;
                           nrobole    n(07),;
                           fecha      d(08),;
                           serieot    c(01),;
                           nroot      n(07),;
                           local      n(01))

create table cabenotc.dbf (tiponota   n(01),;
                           nronota    n(07),;
                           tipodocu   n(01),;
                           nrodocu    n(07),;
                           fechanota  d(08),;
                           cliente    n(07),;
                           motivonota n(03),;
                           aplicontra n(01),;
                           fechaanu   d(08),;
                           anulado    l(01),;
                           monto_nota n(09))

create table cabenotp.dbf (tiponota   n(01),;
                           nronota    n(09),;
                           tipodocu   n(01),;
                           nrodocu    n(09),;
                           fechanota  d(08),;
                           proveedor  n(05),;
                           motivonota n(03),;
                           monto_nota n(09),;
                           aplicontra n(01),;
                           localpago  n(01))

create table cabepag.dbf (tiporeci   n(01),;
                          nroreci    n(07),;
                          fechareci  d(08),;
                          proveedor  n(05),;
                          monto_pago n(09),;
                          localpago  n(01))  

create table cabepres.dbf (tipodocu   n(01),;
                           nrodocu    n(07),;
                           fechadocu  d(08),;
                           moneda     c(01),;
                           cambio     n(08,2),;
                           nroremi    n(06),;
                           fecharemi  d(08),;
                           dias_plazo n(03),;
                           fecha_venc d(08),;
                           cliente    n(07),;
                           cliente2   n(07),;
                           vendedor   n(03),;
                           comision_v n(06,2),;
                           porcdesc   n(05,2),;
                           importdesc n(08),;
                           impreso    l(01),;
                           fechaanu   d(08),;
                           anulado    l(01),;
                           monto_fact n(08),;
                           monto_cobr n(08),;
                           monto_ndeb n(08),;
                           monto_ncre n(08)) 
                           
create table caberemi.dbf (tiporemi   n(01),;
                           serie      c(01),;
                           nroremi    n(07),;
                           fecharemi  d(08),;
                           cliente    n(07),;
                           monto_fact n(08),;
                           obs        c(40))

create table cabeven2.dbf (tipodocu   n(01),;
                           nrodocu    n(07),;
                           propietari c(40),;
                           direccion  c(40),;
                           telefono   c(25),;
                           marca      n(04),;
                           modelo     n(04),;
                           motor      c(25))

create table cabevent.dbf (tipodocu   n(01),;
                           nrodocu    n(07),;
                           fechadocu  d(08),;
                           moneda     c(01),;
                           cambio     n(08,2),;
                           nroremi    n(06),;
                           fecharemi  d(08),;
                           dias_plazo n(03),;
                           fecha_venc d(08),;
                           cliente    n(07),;
                           cliente2   n(07),;
                           vendedor   n(03),;
                           comision_v n(06,2),;
                           porcdesc   n(05,2),;
                           importdesc n(08),;
                           impreso    l(01),;
                           fechaanu   d(08),;
                           anulado    l(01),;
                           monto_fact n(08),;
                           monto_cobr n(08),;
                           monto_ndeb n(08),;
                           monto_ncre n(08),;
                           serie      c(01),;
                           nroot      n(07))

create table ciudades.dbf (codigo n(05),;
                           nombre c(30))

create table clientes.dbf (codigo     n(05),;
                           nombre     c(25),;
                           apellido   c(31),;
                           direc1     c(60),;
                           direc2     c(60),;
                           direc3     c(60),;
                           direc4     c(60),;
                           direc5     c(60),;
                           direc6     c(60),;
                           direc7     c(60),;
                           direc8     c(60),;
                           direc9     c(60),;
                           direc10    c(60),;
                           departamen n(03),;
                           ciudad     n(05),;
                           barrio     n(05),;
                           telefono   c(30),;
                           fechanac   d(08),;
                           contacto   c(30),;
                           ruc        c(15),;
                           dias_plazo n(03),;
                           documento  c(15),;
                           limite_cre n(09),;
                           calificac  n(01),;
                           fec_ioper  d(08),;
                           motivoclie n(04),;
                           odatosclie c(40),;
                           trabajo    c(50),;
                           teltrabajo c(30),;
                           directraba c(60),;
                           cargo      c(40),;
                           sueldo     n(09),;
                           antiguedad n(05,2),;
                           oingresos  n(09),;
                           gastos     n(09),;
                           nombre_c   c(25),;
                           apellido_c c(25),;
                           docconyuge c(15),;
                           fechanacco d(08),;
                           trabajocon c(50),;
                           dirtracony c(60),;
                           cargoconyu c(40),;
                           teltracony c(15),;
                           sueldoc    n(09),;
                           oingresosc n(09),;
                           gastosc    n(09),;
                           antiguec   n(05,2),;
                           nombre_g   c(25),;
                           apellido_g c(25),;
                           dir1garan  c(60),;
                           dir2garan  c(60),;
                           telgarante c(30),;
                           tragarante c(50),;
                           dirtragar  c(60),;
                           tetragaran c(30),;
                           cargogaran c(40),;
                           docgarante c(15),;
                           fechanacg  d(08),;
                           relacion   c(20),;
                           sueldog    n(09),;
                           oingresosg n(09),;
                           antigueg   n(05,2),;
                           gastosg    n(09),;
                           casa       c(01),;
                           hipoteca   c(01),;
                           estado_civ c(01),;
                           saldo_actu n(12),;
                           obs1       c(74),;
                           obs2       c(74),;
                           obs3       c(74),;
                           obs4       c(74),;
                           obs5       c(74),;
                           obs6       c(74),;
                           obs7       c(74),;
                           obs8       c(74),;
                           obs9       c(74),;
                           obs10      c(74),;
                           ref1       c(74),;
                           ref2       c(74),;
                           ref3       c(74),;
                           ref4       c(74),;
                           ref5       c(74),;
                           ctacatas   c(25),;
                           dequien    c(50))

create table cobrador.dbf (codigo   n(03),;
                           nombre   c(30),;
                           comision n(06,2))

create table cuotas_c.dbf (tipodocu   n(01),;
                           nrodocu    n(09),;
                           proveedor  n(05),;
                           tipo       n(01),;
                           nrocuota   n(03),;
                           fecha      d(08),;
                           importe    n(09),;
                           abonado    n(09),;
                           monto_ndeb n(09),;
                           monto_ncre n(09))

create table cuotas_n.dbf (docinicial c(01),;
                           tiponota   n(01),;
                           nronota    n(07),;
                           nrocuota   n(03),;
                           importe    n(09)) 
  
create table cuotas_p.dbf (tiponota   n(01),;
                           nronota    n(09),;
                           proveedor  n(05),;
                           nrocuota   n(03),;
                           importe    n(09)) 

create table cuotas_v.dbf (tipodocu   n(01),;
                           nrodocu    n(07),;
                           tipo       n(01),;
                           nrocuota   n(03),;
                           fecha      d(08),;
                           importe    n(09),;
                           abonado    n(09),;
                           monto_ndeb n(09),;
                           monto_ncre n(09))

create table depar.dbf (codigo n(03),;
                        nombre c(30))

                                    
create table detacob.dbf (tiporeci  n(01),;
                          nroreci   n(07),;
                          tipodocu  n(01),;
                          nrodocu   n(07),;
                          nrocuota  n(03),;
                          fechadocu d(08),;
                          monto     n(09))

create table detacomp.dbf (tipodocu   n(01),;
                           nrodocu    n(09),;
                           proveedor  n(05),;
                           articulo   c(15),;
                           cantidad   n(09,2),;
                           precio     n(11,2),;
                           impuesto   l(01),;
                           pimpuesto  n(06,2),;
                           serie      c(15))

create table detamot.dbf (tipobole   n(01),;
                          serie      c(01),;
                          nrobole    n(07),;
                          articulo   c(15),;
                          cantidad   n(11,2),;
                          precio     n(11,2),;
                          pimpuesto  n(06,2),;
                          impuesto   l(01),;
                          mecanico   n(03),;
                          descr_trab c(40))

create table detamovi.dbf (tipobole   n(01),;
                           nrobole    n(07),;
                           articulo   c(15),;
                           cantidad   n(11,2))

create table detanotc.dbf (tiponota   n(01),;
                           nronota    n(07),;
                           tipo       c(01),;
                           articulo   c(15),;
                           cantidad   n(09,2),;
                           precio     n(11,2),;
                           impuesto   l(01),;
                           pimpuesto  n(06,2),;
                           serie      c(15))

create table detanotp.dbf (tiponota   n(01),;
                           nronota    n(09),;
                           proveedor  n(05),;
                           tipo       c(01),;
                           articulo   c(15),;
                           detalle    c(40),;
                           cantidad   n(09,2),;
                           precio     n(11,2),;
                           impuesto   l(01),;
                           pimpuesto  n(06,2),;
                           serie      c(15))

create table detapag.dbf (tiporeci  n(01),;
                          nroreci   n(07),;
                          fechadocu d(08),;
                          tipodocu  n(01),;
                          nrodocu   n(09),;
                          proveedor n(05),;
                          nrocuota  n(03),;
                          monto     n(09))

create table detapres.dbf (tipodocu  n(01),;
                           nrodocu   n(07),;
                           articulo   c(15),;
                           cantidad   n(09,2),;
                           precio     n(11,2),;
                           impuesto   l(01),;
                           pimpuesto  n(06,2),;
                           serie      c(15))
                       
create table detaremi.dbf (tiporemi  n(01),;
                           serie     c(01),;
                           nroremi   n(07),;
                           articulo   c(15),;
                           cantidad   n(11,2),;
                           precio     n(11,2),;
                           pimpuesto  n(06,2),;
                           impuesto   l(01))

create table detavent.dbf (tipodocu   n(01),;
                           nrodocu    n(07),;
                           articulo   c(15),;
                           cantidad   n(09,2),;
                           precio     n(11,2),;
                           impuesto   l(01),;
                           pimpuesto  n(06,2),;
                           serie      c(15),;
                           mecanico   n(03),;
                           descr_trab c(40))

create table division.dbf (codigo n(03),;
                           nombre c(30))

create table estadoot.dbf (codigo n(03),;
                           nombre c(30))

create table familias.dbf (codigo n(04),;
                           nombre c(30),;
                           p1     n(06,2),;
                           p2     n(06,2),;
                           p3     n(06,2),;
                           p4     n(06,2),;
                           p5     n(06,2))

create table maesprod.dbf (codigo     c(15),;
                           codigo2    c(15),;
                           codorig    c(15),;
                           proveedor  n(05),;
                           nombre     c(40),;
                           familia    n(04),;
                           rubro      n(04),;
                           subrubro   n(04),;
                           marca      n(04),;
                           unidad     n(03),;
                           caracter1  c(60),;
                           caracter2  c(60),;
                           caracter3  c(60),;
                           pcostog    n(12,3),;
                           pcostod    n(12,3),;
                           pcostogr   n(12,3),;
                           pcostodr   n(12,3),;
                           pcostogre  n(12,3),;
                           pcostodre  n(12,3),;
                           pventag1   n(12,3),;
                           pventag2   n(12,3),;
                           pventag3   n(12,3),;
                           pventag4   n(12,3),;
                           pventag5   n(12,3),;
                           pventad1   n(12,3),;
                           pventad2   n(12,3),;
                           pventad3   n(12,3),;
                           pventad4   n(12,3),;
                           pventad5   n(12,3),;
                           impuesto   l(01),;
                           pimpuesto  n(06,2),;
                           paumento1  n(06,2),;
                           paumento2  n(06,2),;
                           paumento3  n(06,2),;
                           paumento4  n(06,2),;
                           paumento5  n(06,2),;
                           garantia   c(20),;
                           procedenci c(20),;
                           vigente    l(01),;
                           otros1     c(60),;
                           otros2     c(60),;
                           lprecio    l(01),;
                           stock_min  n(11,2),;
                           stock_max  n(11,2),;
                           polinvsmin l(01),;
                           polinvsmax l(01),;
                           fecucompra d(08),;
                           fecrepo    d(08),;
                           stock_actu n(11,2),;
                           stock_ot   n(11,2),;
                           ubicacion  c(10),;
                           lista3     c(01),;
                           lista4     c(01),;
                           lista5     c(01))

create table marcas.dbf (codigo n(04),;
                         nombre c(30))

create table mecanico.dbf (codigo n(03),;
                           nombre c(30))

create table modelos.dbf (codigo n(04),;
                          nombre c(30),;
                          marca  n(04))

create table motivocl.dbf (codigo n(04),;
                           nombre c(30))

create table motivono.dbf (codigo n(03),;
                           nombre c(30))

create table opciones.dbf (nro      n(03),;
                           opcion   c(75),;
                           tipo     c(01),;
                           programa c(10),;
                           acceso   c(01),;
                           f2       c(01),;
                           f3       c(01),;
                           f8       c(01),;
                           f12      c(01))

CLEAR
DISPLAY TABLES  && Displays tables in the database
DISPLAY DATABASES  && Displays table information
