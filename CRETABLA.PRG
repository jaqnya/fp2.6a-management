*:**************************************************************************
*:
*: Archivo de Procedimiento: CRETABLA.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Crea Tablas del Sistema.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/04/2004
*:
*:**************************************************************************

**------------------------------------------------------------------------**
CREATE TABLE accesos.dbf (usuario N(04),;
                          fecha_e D(08),;
                          hora_e  C(08),;
                          fecha_s D(08),;
                          hora_s  C(08))
**------------------------------------------------------------------------**
CREATE TABLE ayuda.dbf (programa C(10),;
                        linea    N(03),;
                        ayuda    C(61))
**------------------------------------------------------------------------**
CREATE TABLE barrios.dbf (codigo     N(05) ,;
                          nombre     C(30) ,;
                          departamen N(03) ,;
                          ciudad     N(05) ,;
                          vigente    L(01) ,;
                          id_local   N(02))
**------------------------------------------------------------------------**
CREATE TABLE cabecob.dbf (tiporeci   N(01) ,;
                          nroreci    N(07) ,;
                          fechareci  D(08) ,;
                          local      N(01) ,;
                          moneda     N(04) ,;
                          tipocambio N(09,2) ,;
                          factura    C(01) ,;
                          cliente    N(07) ,;
                          cobrador   N(03) ,;
                          comision   N(06,2) ,;
                          monto_cobr N(09) ,;
                          fechaanu   D(08) ,;
                          anulado    L(01) ,;
                          id_local   N(02))

**------------------------------------------------------------------------**
CREATE TABLE cabecomp.dbf (tipodocu   N(01) ,;
                           nrodocu    N(09) ,;
                           fechadocu  D(08) ,;
                           proveedor  N(05) ,;
                           moneda     N(04) ,;
                           tipocambio N(09,2) ,;
                           qty_cuotas N(03) ,;
                           porcdesc   N(08,4) ,;
                           importdesc N(12,3) ,;
                           descuento  N(08,4) ,;
                           monto_fact N(12,2) ,;
                           monto_ndeb N(12,2) ,;
                           monto_ncre N(12,2) ,;
                           monto_pago N(12,2) ,;
                           consignaci L(01) ,;
                           id_local   N(02))
**------------------------------------------------------------------------**
CREATE TABLE cabemot.dbf (tipobole   N(01),;
                          serie      C(01),;
                          nrobole    N(07),;
                          fecha      D(08),;
                          lstprecio  N(01),;
                          monto_fact N(08),;
                          obs1       C(45),;
                          obs2       C(45))
**------------------------------------------------------------------------**
CREATE TABLE cabemovi.dbf (tipobole   N(01) ,;
                           nrobole    N(07) ,;
                           fecha      D(08) ,;
                           local      N(02) ,;
                           id_local   N(02))
**------------------------------------------------------------------------**
CREATE TABLE cabenotc.dbf (tiponota   N(01),;
                           nronota    N(07),;
                           tipodocu   N(01),;
                           nrodocu    N(07),;
                           fechanota  D(08),;
                           cliente    N(07),;
                           motivonota N(03),;
                           aplicontra N(01),;
                           fechaanu   D(08),;
                           anulado    L(01),;
                           monto_nota N(09))
**------------------------------------------------------------------------**
CREATE TABLE cabenotp.dbf (tiponota   N(01) ,;
                           nronota    N(09) ,;
                           tipodocu   N(01) ,;
                           nrodocu    N(09) ,;
                           fechanota  D(08) ,;
                           proveedor  N(05) ,;
                           motivonota N(03) ,;
                           monto_nota N(12,2) ,;
                           aplicontra N(01) ,;
                           id_local   N(02))
**------------------------------------------------------------------------**
CREATE TABLE cabepag.dbf (tiporeci   N(01) ,;
                          nroreci    N(07) ,;
                          fechareci  D(08) ,;
                          proveedor  N(05) ,;
                          moneda     N(04) ,;
                          tipocambio N(09,2) ,;
                          monto_pago N(12,2) ,;
                          id_local   N(02))  
**------------------------------------------------------------------------**
CREATE TABLE cabepres.dbf (tipodocu   N(01),;
                           nrodocu    N(07),;
                           fechadocu  D(08),;
                           moneda     C(01),;
                           cambio     N(08,2),;
                           nroremi    N(06),;
                           fecharemi  D(08),;
                           dias_plazo N(03),;
                           fecha_venc D(08),;
                           cliente    N(07),;
                           cliente2   N(07),;
                           vendedor   N(03),;
                           comision_v N(06,2),;
                           porcdesc   N(05,2),;
                           importdesc N(08),;
                           impreso    L(01),;
                           fechaanu   D(08),;
                           anulado    L(01),;
                           monto_fact N(08),;
                           monto_cobr N(08),;
                           monto_ndeb N(08),;
                           monto_ncre N(08)) 
**------------------------------------------------------------------------**                           
CREATE TABLE caberemi.dbf (tiporemi   N(01),;
                           serie      C(01),;
                           nroremi    N(07),;
                           fecharemi  D(08),;
                           cliente    N(05),;
                           monto_fact N(08),;
                           obs        C(40))
**------------------------------------------------------------------------**
CREATE TABLE cabeven2.dbf (tipodocu   N(01),;
                           nrodocu    N(07),;
                           propietari C(40),;
                           direccion  C(40),;
                           telefono   C(25),;
                           maquina    N(03),;
                           marca      N(04),;
                           modelo     N(04),;
                           motor      C(25))
**------------------------------------------------------------------------**
CREATE TABLE cabevent.dbf (tipodocu   N(01),;
                           nrodocu    N(07),;
                           lstprecio  N(01),;
                           fechadocu  D(08),;
                           serie      C(01),;
                           nroot      N(07),;
                           moneda     N(04),;
                           tipocambio N(09,2),;
                           nroremi    N(06),;
                           fecharemi  D(08),;
                           cliente    N(05),;
                           vendedor   N(03),;
                           comision_v N(06,2),;
                           porcdesc   N(08,4),;
                           importdesc N(12,2),;
                           descuento  N(08,4),;
                           impreso    L(01),;
                           fechaanu   D(08),;
                           anulado    L(01),;
                           monto_fact N(08),;
                           monto_cobr N(08),;
                           monto_ndeb N(08),;
                           monto_ncre N(08))
**------------------------------------------------------------------------**
CREATE TABLE ciudades.dbf (codigo     N(05) ,;
                           nombre     C(30) ,;
                           departamen N(03) ,;
                           vigente    L(01) ,;
                           id_local   N(02))
**------------------------------------------------------------------------**
DIMENSION paClientes[82,4]

paClientes[01, 01] = "codigo"
paClientes[01, 02] = "N"
paClientes[01, 03] = 05
paClientes[01, 04] = 00
paClientes[02, 01] = "nombre"
paClientes[02, 02] = "C"
paClientes[02, 03] = 56
paClientes[02, 04] = 00
paClientes[03, 01] = "direc1"
paClientes[03, 02] = "C"
paClientes[03, 03] = 60
paClientes[03, 04] = 00
paClientes[04, 01] = "direc2"
paClientes[04, 02] = "C"
paClientes[04, 03] = 60
paClientes[04, 04] = 00
paClientes[05, 01] = "direc3"
paClientes[05, 02] = "C"
paClientes[05, 03] = 60
paClientes[05, 04] = 00
paClientes[06, 01] = "direc4"
paClientes[06, 02] = "C"
paClientes[06, 03] = 60
paClientes[06, 04] = 00
paClientes[07, 01] = "direc5"
paClientes[07, 02] = "C"
paClientes[07, 03] = 60
paClientes[07, 04] = 00
paClientes[08, 01] = "direc6"
paClientes[08, 02] = "C"
paClientes[08, 03] = 60
paClientes[08, 04] = 00
paClientes[09, 01] = "direc7"
paClientes[09, 02] = "C"
paClientes[09, 03] = 60
paClientes[09, 04] = 00
paClientes[10, 01] = "direc8"
paClientes[10, 02] = "C"
paClientes[10, 03] = 60
paClientes[10, 04] = 00
paClientes[11, 01] = "direc9"
paClientes[11, 02] = "C"
paClientes[11, 03] = 60
paClientes[11, 04] = 00
paClientes[12, 01] = "departamen"
paClientes[12, 02] = "N"
paClientes[12, 03] = 03
paClientes[12, 04] = 00
paClientes[13, 01] = "ciudad"
paClientes[13, 02] = "N"
paClientes[13, 03] = 05
paClientes[13, 04] = 00
paClientes[14, 01] = "barrio"
paClientes[14, 02] = "N"
paClientes[14, 03] = 05
paClientes[14, 04] = 00
paClientes[15, 01] = "telefono"
paClientes[15, 02] = "C"
paClientes[15, 03] = 30
paClientes[15, 04] = 00
paClientes[16, 01] = "fax"
paClientes[16, 02] = "C"
paClientes[16, 03] = 30
paClientes[16, 04] = 00
paClientes[17, 01] = "e_mail"
paClientes[17, 02] = "C"
paClientes[17, 03] = 40
paClientes[17, 04] = 00
paClientes[18, 01] = "fechanac"
paClientes[18, 02] = "D"
paClientes[18, 03] = 08
paClientes[18, 04] = 00
paClientes[19, 01] = "contacto"
paClientes[19, 02] = "C"
paClientes[19, 03] = 30
paClientes[19, 04] = 00
paClientes[20, 01] = "ruc"
paClientes[20, 02] = "C"
paClientes[20, 03] = 15
paClientes[20, 04] = 00
paClientes[21, 01] = "dias_plazo"
paClientes[21, 02] = "N"
paClientes[21, 03] = 03
paClientes[21, 04] = 00
paClientes[22, 01] = "documento"
paClientes[22, 02] = "C"
paClientes[22, 03] = 15
paClientes[22, 04] = 00
paClientes[23, 01] = "limite_cre"
paClientes[23, 02] = "N"
paClientes[23, 03] = 09
paClientes[23, 04] = 00
paClientes[24, 01] = "calificac"
paClientes[24, 02] = "N"
paClientes[24, 03] = 01
paClientes[24, 04] = 00
paClientes[25, 01] = "fec_ioper"
paClientes[25, 02] = "D"
paClientes[25, 03] = 08
paClientes[25, 04] = 00
paClientes[26, 01] = "motivoclie"
paClientes[26, 02] = "N"
paClientes[26, 03] = 04
paClientes[26, 04] = 00
paClientes[27, 01] = "odatosclie"
paClientes[27, 02] = "C"
paClientes[27, 03] = 40
paClientes[27, 04] = 00
paClientes[28, 01] = "trabajo"
paClientes[28, 02] = "C"
paClientes[28, 03] = 50
paClientes[28, 04] = 00
paClientes[29, 01] = "teltrabajo"
paClientes[29, 02] = "C"
paClientes[29, 03] = 30
paClientes[29, 04] = 00
paClientes[30, 01] = "directraba"
paClientes[30, 02] = "C"
paClientes[30, 03] = 60
paClientes[30, 04] = 00
paClientes[31, 01] = "cargo"
paClientes[31, 02] = "C"
paClientes[31, 03] = 40
paClientes[31, 04] = 00
paClientes[32, 01] = "sueldo"
paClientes[32, 02] = "N"
paClientes[32, 03] = 09
paClientes[32, 04] = 00
paClientes[33, 01] = "antiguedad"
paClientes[33, 02] = "N"
paClientes[33, 03] = 05
paClientes[33, 04] = 02
paClientes[34, 01] = "oingresos"
paClientes[34, 02] = "N"
paClientes[34, 03] = 09
paClientes[34, 04] = 00
paClientes[35, 01] = "gastos"
paClientes[35, 02] = "N"
paClientes[35, 03] = 09
paClientes[35, 04] = 00
paClientes[36, 01] = "nombre_c"
paClientes[36, 02] = "C"
paClientes[36, 03] = 50
paClientes[36, 04] = 00
paClientes[37, 01] = "docconyuge"
paClientes[37, 02] = "C"
paClientes[37, 03] = 15
paClientes[37, 04] = 00
paClientes[38, 01] = "fechanacco"
paClientes[38, 02] = "D"
paClientes[38, 03] = 08
paClientes[38, 04] = 00
paClientes[39, 01] = "trabajocon"
paClientes[39, 02] = "C"
paClientes[39, 03] = 50
paClientes[39, 04] = 00
paClientes[40, 01] = "dirtracony"
paClientes[40, 02] = "C"
paClientes[40, 03] = 60
paClientes[40, 04] = 00
paClientes[41, 01] = "cargoconyu"
paClientes[41, 02] = "C"
paClientes[41, 03] = 40
paClientes[41, 04] = 00
paClientes[42, 01] = "teltracony"
paClientes[42, 02] = "C"
paClientes[42, 03] = 15
paClientes[42, 04] = 00
paClientes[43, 01] = "sueldoc"
paClientes[43, 02] = "N"
paClientes[43, 03] = 09
paClientes[43, 04] = 00
paClientes[44, 01] = "oingresosc"
paClientes[44, 02] = "N"
paClientes[44, 03] = 09
paClientes[44, 04] = 00
paClientes[45, 01] = "gastosc"
paClientes[45, 02] = "N"
paClientes[45, 03] = 09
paClientes[45, 04] = 00
paClientes[46, 01] = "antiguec"
paClientes[46, 02] = "N"
paClientes[46, 03] = 05
paClientes[46, 04] = 02
paClientes[47, 01] = "nombre_g"
paClientes[47, 02] = "C"
paClientes[47, 03] = 50
paClientes[47, 04] = 00
paClientes[48, 01] = "dir1garan"
paClientes[48, 02] = "C"
paClientes[48, 03] = 60
paClientes[48, 04] = 00
paClientes[49, 01] = "dir2garan"
paClientes[49, 02] = "C"
paClientes[49, 03] = 60
paClientes[49, 04] = 00
paClientes[50, 01] = "telgarante"
paClientes[50, 02] = "C"
paClientes[50, 03] = 30
paClientes[50, 04] = 00
paClientes[51, 01] = "tragarante"
paClientes[51, 02] = "C"
paClientes[51, 03] = 50
paClientes[51, 04] = 00
paClientes[52, 01] = "dirtragar"
paClientes[52, 02] = "C"
paClientes[52, 03] = 60
paClientes[52, 04] = 00
paClientes[53, 01] = "tetragaran"
paClientes[53, 02] = "C"
paClientes[53, 03] = 30
paClientes[53, 04] = 00
paClientes[54, 01] = "cargogaran"
paClientes[54, 02] = "C"
paClientes[54, 03] = 40
paClientes[54, 04] = 00
paClientes[55, 01] = "docgarante"
paClientes[55, 02] = "C"
paClientes[55, 03] = 15
paClientes[55, 04] = 00
paClientes[56, 01] = "fechanacg"
paClientes[56, 02] = "D"
paClientes[56, 03] = 08
paClientes[56, 04] = 00
paClientes[57, 01] = "relacion"
paClientes[57, 02] = "C"
paClientes[57, 03] = 20
paClientes[57, 04] = 00
paClientes[58, 01] = "sueldog"
paClientes[58, 02] = "N"
paClientes[58, 03] = 09
paClientes[58, 04] = 00
paClientes[59, 01] = "oingresosg"
paClientes[59, 02] = "N"
paClientes[59, 03] = 09
paClientes[59, 04] = 00
paClientes[60, 01] = "antigueg"
paClientes[60, 02] = "N"
paClientes[60, 03] = 05
paClientes[60, 04] = 02
paClientes[61, 01] = "gastosg"
paClientes[61, 02] = "N"
paClientes[61, 03] = 09
paClientes[61, 04] = 00
paClientes[62, 01] = "casa"
paClientes[62, 02] = "C"
paClientes[62, 03] = 01
paClientes[62, 04] = 00
paClientes[63, 01] = "hipoteca"
paClientes[63, 02] = "C"
paClientes[63, 03] = 01
paClientes[63, 04] = 00
paClientes[64, 01] = "estado_civ"
paClientes[64, 02] = "C"
paClientes[64, 03] = 01
paClientes[64, 04] = 00
paClientes[65, 01] = "saldo_actu"
paClientes[65, 02] = "N"
paClientes[65, 03] = 12
paClientes[65, 04] = 00
paClientes[66, 01] = "obs1"
paClientes[66, 02] = "C"
paClientes[66, 03] = 72
paClientes[66, 04] = 00
paClientes[67, 01] = "obs2"
paClientes[67, 02] = "C"
paClientes[67, 03] = 72
paClientes[67, 04] = 00
paClientes[68, 01] = "obs3"
paClientes[68, 02] = "C"
paClientes[68, 03] = 72
paClientes[68, 04] = 00
paClientes[69, 01] = "obs4"
paClientes[69, 02] = "C"
paClientes[69, 03] = 72
paClientes[69, 04] = 00
paClientes[70, 01] = "obs5"
paClientes[70, 02] = "C"
paClientes[70, 03] = 72
paClientes[70, 04] = 00
paClientes[71, 01] = "obs6"
paClientes[71, 02] = "C"
paClientes[71, 03] = 72
paClientes[71, 04] = 00
paClientes[72, 01] = "obs7"
paClientes[72, 02] = "C"
paClientes[72, 03] = 72
paClientes[72, 04] = 00
paClientes[73, 01] = "obs8"
paClientes[73, 02] = "C"
paClientes[73, 03] = 72
paClientes[73, 04] = 00
paClientes[74, 01] = "obs9"
paClientes[74, 02] = "C"
paClientes[74, 03] = 72
paClientes[74, 04] = 00
paClientes[75, 01] = "obs10"
paClientes[75, 02] = "C"
paClientes[75, 03] = 72
paClientes[75, 04] = 00
paClientes[76, 01] = "ref1"
paClientes[76, 02] = "C"
paClientes[76, 03] = 72
paClientes[76, 04] = 00
paClientes[77, 01] = "ref2"
paClientes[77, 02] = "C"
paClientes[77, 03] = 72
paClientes[77, 04] = 00
paClientes[78, 01] = "ref3"
paClientes[78, 02] = "C"
paClientes[78, 03] = 72
paClientes[78, 04] = 00
paClientes[79, 01] = "ref4"
paClientes[79, 02] = "C"
paClientes[79, 03] = 72
paClientes[79, 04] = 00
paClientes[80, 01] = "ref5"
paClientes[80, 02] = "C"
paClientes[80, 03] = 72
paClientes[80, 04] = 00
paClientes[81, 01] = "ctacatas"
paClientes[81, 02] = "C"
paClientes[81, 03] = 25
paClientes[81, 04] = 00
paClientes[82, 01] = "dequien"
paClientes[82, 02] = "C"
paClientes[82, 03] = 50
paClientes[82, 04] = 00

CREATE TABLE clientes.dbf FROM ARRAY paClientes
**------------------------------------------------------------------------**
CREATE TABLE cobrador.dbf (codigo   N(03) ,;
                           nombre   C(30) ,;
                           comision N(06,2) ,;
                           vigente  L(01) ,;
                           id_local N(02))
**------------------------------------------------------------------------**
CREATE TABLE control.dbf (empresa    C(26) ,;
                          local      N(01) ,;
                          id_local   N(02) ,;
                          ruc        C(15) ,;
                          directory  C(53) ,;
                          direccion  C(53) ,;
                          ciudad     C(30) ,;
                          barrio     C(30) ,;
                          telefono   C(30) ,;
                          fax        C(30) ,;
                          e_mail     C(53) ,;
                          web_site   C(53) ,;
                          pimpuesto  N(06,2) ,;
                          simbolo    C(04) ,;
                          moneda     C(20) ,;
                          maecounter C(10) ,;
                          clicounter C(10) ,;
                          procounter C(10) ,;
                          serieot    C(10) ,;
                          tipocambio N(08,2))
**------------------------------------------------------------------------**
CREATE TABLE cuotas_c.dbf (tipodocu   N(01) ,;
                           nrodocu    N(09) ,;
                           proveedor  N(05) ,;
                           tipo       N(01) ,;
                           nrocuota   N(03) ,;
                           fecha      D(08) ,;
                           importe    N(12,2) ,;
                           abonado    N(12,2) ,;
                           monto_ndeb N(12,2) ,;
                           monto_ncre N(12,2) ,;
                           id_local   N(02))
**------------------------------------------------------------------------**
CREATE TABLE cuotas_n.dbf (docinicial C(01),;
                           tiponota   N(01),;
                           nronota    N(07),;
                           nrocuota   N(03),;
                           importe    N(09)) 
**------------------------------------------------------------------------**  
CREATE TABLE cuotas_p.dbf (tiponota  N(01) ,;
                           nronota   N(09) ,;
                           proveedor N(05) ,;
                           nrocuota  N(03) ,;
                           importe   N(12,2) ,;
                           id_local  N(02)) 
**------------------------------------------------------------------------**
CREATE TABLE cuotas_v.dbf (tipodocu   N(01),;
                           nrodocu    N(07),;
                           tipo       N(01),;
                           nrocuota   N(03),;
                           fecha      D(08),;
                           importe    N(09),;
                           abonado    N(09),;
                           monto_ndeb N(09),;
                           monto_ncre N(09))
**------------------------------------------------------------------------**
CREATE TABLE depar.dbf (codigo   N(03) ,;
                        nombre   C(30) ,;
                        vigente  L(01) ,;
                        id_local N(02))
**------------------------------------------------------------------------**                                    
CREATE TABLE detacob.dbf (tiporeci  N(01),;
                          nroreci   N(07),;
                          tipodocu  N(01),;
                          nrodocu   N(07),;
                          nrocuota  N(03),;
                          fechadocu D(08),;
                          monto     N(09))
**------------------------------------------------------------------------**
CREATE TABLE detacomp.dbf (tipodocu   N(01) ,;
                           nrodocu    N(09) ,;
                           proveedor  N(05) ,;
                           articulo   C(15) ,;
                           cantidad   N(09,2) ,;
                           precio     N(13,4) ,;
                           pdescuento N(07,4) ,;
                           impuesto   L(01) ,;
                           pimpuesto  N(06,2) ,;
                           id_local   N(02))
**------------------------------------------------------------------------**
CREATE TABLE detamot.dbf (tipobole   N(01) ,;
                          serie      C(01) ,;
                          nrobole    N(07) ,;
                          articulo   C(15) ,;
                          cantidad   N(09,2) ,;
                          precio     N(13,4) ,;
                          pdescuento N(07,4) ,;
                          impuesto   L(01) ,;
                          pimpuesto  N(06,2) ,;
                          mecanico   N(03) ,;
                          comision_m N(06,2) ,;
                          descr_trab C(40) ,;
                          id_local   N(02))
**------------------------------------------------------------------------**
CREATE TABLE detamovi.dbf (tipobole   N(01) ,;
                           nrobole    N(07) ,;
                           articulo   C(15) ,;
                           cantidad   N(11,2) ,;
                           id_local   N(02))
**------------------------------------------------------------------------**
CREATE TABLE detanotc.dbf (tiponota   N(01),;
                           nronota    N(07),;
                           tipo       C(01),;
                           articulo   C(15),;
                           cantidad   N(09,2),;
                           precio     N(13,4) ,;
                           pdescuento N(07,4) ,;
                           impuesto   L(01),;
                           pimpuesto  N(06,2),;
                           serie      C(15))
**------------------------------------------------------------------------**
CREATE TABLE detanotp.dbf (tiponota   N(01) ,;
                           nronota    N(09) ,;
                           proveedor  N(05) ,;
                           tipo       C(01) ,;
                           articulo   C(15) ,;
                           detalle    C(40) ,;
                           cantidad   N(09,2) ,;
                           precio     N(13,4) ,;
                           pdescuento N(07,4) ,;
                           impuesto   L(01) ,;
                           pimpuesto  N(06,2) ,;
                           id_local   N(02))
**------------------------------------------------------------------------**
CREATE TABLE detapag.dbf (tiporeci  N(01) ,;
                          nroreci   N(07) ,;
                          fechadocu D(08) ,;
                          tipodocu  N(01) ,;
                          nrodocu   N(09) ,;
                          proveedor N(05) ,;
                          nrocuota  N(03) ,;
                          monto     N(12,2) ,;
                          id_local  N(02))
**------------------------------------------------------------------------**
CREATE TABLE detapres.dbf (tipodocu  N(01),;
                           nrodocu   N(07),;
                           articulo  C(15),;
                           cantidad  N(09,2),;
                           precio    N(11,2),;
                           impuesto  L(01),;
                           pimpuesto N(06,2),;
                           serie     C(15))
**------------------------------------------------------------------------**                       
CREATE TABLE detaremi.dbf (tiporemi  N(01),;
                           serie     C(01),;
                           nroremi   N(07),;
                           articulo  C(15),;
                           cantidad  N(11,2),;
                           precio    N(11,2),;
                           pimpuesto N(06,2),;
                           impuesto  L(01))
**------------------------------------------------------------------------**
CREATE TABLE detavent.dbf (tipodocu   N(01) ,;
                           nrodocu    N(07) ,;
                           articulo   C(15) ,;
                           cantidad   N(09,2) ,;
                           precio     N(13,4) ,;
                           pdescuento N(07,4) ,;                            
                           impuesto   L(01) ,;
                           pimpuesto  N(06,2) ,;
                           mecanico   N(03) ,;
                           comision_m N(06,2) ,;
                           descr_trab C(40) ,;
                           id_local   N(02))
**------------------------------------------------------------------------**
CREATE TABLE division.dbf (codigo N(03),;
                           nombre C(30))
**------------------------------------------------------------------------**
CREATE TABLE estadoot.dbf (codigo   N(03) ,;
                           nombre   C(30) ,;
                           vigente  L(01) ,;
                           id_local N(02))
**------------------------------------------------------------------------**
CREATE TABLE familias.dbf (codigo   N(04) ,;
                           nombre   C(30) ,;
                           p1       N(06,2) ,;
                           p2       N(06,2) ,;
                           p3       N(06,2) ,;
                           p4       N(06,2) ,;
                           p5       N(06,2) ,;
                           vigente  L(01) ,;
                           id_local N(02))
**------------------------------------------------------------------------**
CREATE TABLE grupos.dbf (codigo   N(04) ,;
                         nombre   C(30) ,;
                         vigente  L(01) ,;
                         id_local N(02))
**------------------------------------------------------------------------**
CREATE TABLE locales.dbf (codigo   N(02) ,;
                          nombre   C(30) ,;
                          vigente  L(01))
**------------------------------------------------------------------------**
CREATE TABLE maesprod.dbf (codigo     C(15) ,;
                           codigo2    C(15) ,;
                           codorig    C(15) ,;
                           nombre     C(40) ,;
                           aplicacion M ,;
                           lista3     L(01) ,;
                           lista4     L(01) ,;
                           lista5     L(01) ,;
                           familia    N(04) ,;
                           rubro      N(04) ,;
                           subrubro   N(04) ,;
                           marca      N(04) ,;
                           unidad     N(03) ,;
                           proveedor  N(05) ,;
                           procedenci N(04) ,;                           
                           ubicacion  C(10) ,;
                           vigente    L(01) ,;
                           lprecio    L(01) ,;
                           impuesto   L(01) ,;
                           pimpuesto  N(06,2) ,;                                                                                 
                           pcostog    N(13,4) ,;
                           pcostod    N(13,4) ,;
                           pcostogr   N(13,4) ,;
                           pcostodr   N(13,4) ,;
                           pcostogre  N(13,4) ,;
                           pcostodre  N(13,4) ,;
                           pventag1   N(13,4) ,;
                           pventag2   N(13,4) ,;
                           pventag3   N(13,4) ,;
                           pventag4   N(13,4) ,;
                           pventag5   N(13,4) ,;
                           pventad1   N(13,4) ,;
                           pventad2   N(13,4) ,;
                           pventad3   N(13,4) ,;
                           pventad4   N(13,4) ,;
                           pventad5   N(13,4) ,;
                           paumento1  N(06,2) ,;
                           paumento2  N(06,2) ,;
                           paumento3  N(06,2) ,;
                           paumento4  N(06,2) ,;
                           paumento5  N(06,2) ,;
                           stock_min  N(11,2) ,;
                           stock_max  N(11,2) ,;
                           polinvsmin L(01) ,;
                           polinvsmax L(01) ,;
                           garantia   C(20) ,;
                           caracter1  C(60) ,;
                           caracter2  C(60) ,;
                           caracter3  C(60) ,;
                           otros1     C(60) ,;
                           otros2     C(60) ,;
                           fecucompra D(08) ,;
                           fecrepo    D(08) ,;
                           stock_actu N(11,2) ,;
                           stock_ot   N(11,2) ,;
                           id_local   N(02))
**------------------------------------------------------------------------**
CREATE TABLE maquinas.dbf (codigo   N(03) ,;
                           nombre   C(30) ,;
                           vigente  L(01) ,;
                           id_local N(02))
**------------------------------------------------------------------------**
CREATE TABLE marcas1.dbf (codigo   N(04) ,;
                          nombre   C(30) ,;
                          vigente  L(01) ,;
                          id_local N(02))
**------------------------------------------------------------------------**
CREATE TABLE marcas2.dbf (codigo   N(04) ,;
                          nombre   C(30) ,;
                          vigente  L(01) ,;
                          id_local N(02))
**------------------------------------------------------------------------**
CREATE TABLE mecancfg.dbf (mecanico   N(03) ,;
                           articulo   C(15) ,;
                           comision   N(06,2) ,;
                           id_local   N(02))
**------------------------------------------------------------------------**
CREATE TABLE mecanico.dbf (codigo     N(03) ,;
                           nombre     C(30) ,;
                           documento  C(15) ,;
                           pcomisrpto N(06,2) ,;
                           vigente    L(01) ,;
                           id_local   N(02))
**------------------------------------------------------------------------**
CREATE TABLE modelos.dbf (codigo   N(04) ,;
                          nombre   C(30) ,;
                          marca    N(04) ,;
                          vigente  L(01) ,;
                          id_local N(02))
**------------------------------------------------------------------------**
CREATE TABLE monedas.dbf (codigo   N(04) ,;
                          nombre   C(30) ,;
                          simbolo  C(04) ,;
                          vigente  L(01) ,;
                          id_local N(02))

INSERT INTO monedas (codigo, nombre, simbolo, vigente, id_local) ;
   VALUES (1, "GUARANIES", "Gs.", .T., "00")
INSERT INTO monedas (codigo, nombre, simbolo, vigente, id_local) ;
   VALUES (2, "DOLARES AMERICANOS", "US$", .T., "00")
INSERT INTO monedas (codigo, nombre, simbolo, vigente, id_local) ;
   VALUES (3, "REALES", "RS$", .T., "00")
INSERT INTO monedas (codigo, nombre, simbolo, vigente, id_local) ;
   VALUES (4, "PESO ARGENTINO", "P$", .T., "00")
**------------------------------------------------------------------------**
CREATE TABLE motivocl.dbf (codigo   N(04) ,;
                           nombre   C(30) ,;
                           vigente  L(01) ,;
                           id_local N(02))
**------------------------------------------------------------------------**
CREATE TABLE motivono.dbf (codigo  N(03),;
                           nombre  C(30),;
                           vigente  L(01) ,;
                           id_local N(02))
**------------------------------------------------------------------------**
CREATE TABLE opciones.dbf (nro      N(03),;
                           opcion   C(75),;
                           tipo     C(01),;
                           programa C(10),;
                           acceso   L(01),;
                           f2       L(01),;
                           f3       L(01),;
                           f8       L(01),;
                           f12      L(01))
**------------------------------------------------------------------------**
CREATE TABLE ot.dbf (serie      C(01) ,;
                     nroot      N(07) ,;
                     cliente    N(05) ,;
                     nombreot   C(40) ,;
                     contacto   C(40) ,;
                     direcot    C(40) ,;
                     telefot    C(40) ,;
                     cedulaot   C(15) ,;
                     departamen N(03) ,;
                     ciudad     N(05) ,;
                     barrio     N(05) ,;
                     maquina    N(03) ,;
                     marca      N(04) ,;
                     modelo     N(04) ,;
                     accesorio  C(56) ,;
                     motor      C(25) ,;
                     chasis     C(25) ,;
                     mecanico   N(03) ,;
                     chapa      C(25) ,;
                     color      C(15) ,;
                     km         C(07) ,;
                     frecepcion D(08) ,;
                     fpentrega  D(08) ,;
                     trabajo1   C(60) ,;
                     trabajo2   C(60) ,;
                     trabajo3   C(60) ,;                                          
                     fentrega   D(08) ,;
                     estadoot   N(03) ,;
                     tipodocu   N(01) ,;
                     nrodocu    N(07) ,;
                     referencia C(10) ,;
                     localrep   N(02) ,;
                     id_local   N(02))
**------------------------------------------------------------------------**
CREATE TABLE proceden.dbf (codigo   N(04),;
                           nombre   C(30),;
                           vigente  L(01),;
                           id_local N(02))
**------------------------------------------------------------------------**
CREATE TABLE proveedo.dbf (codigo     N(05) ,;
                           nombre     C(40) ,;
                           direc1     C(60) ,;
                           direc2     C(60) ,;
                           ciudad     C(25) ,;
                           telefono   C(40) ,;
                           fax        C(25) ,;
                           e_mail     C(60) ,;
                           ruc        C(15) ,;
                           dias_plazo N(03) ,;
                           dueno      C(40) ,;
                           teldueno   C(25) ,;
                           gtegral    C(40) ,;
                           telgg      C(25) ,;
                           gteventas  C(40) ,;
                           telgv      C(25) ,;
                           gtemkg     C(40) ,;
                           telgm      C(25) ,;
                           stecnico   C(40) ,;
                           stdirec1   C(60) ,;
                           stdirec2   C(60) ,;
                           sttel      C(25) ,;
                           sthablar1  C(60) ,;
                           vendedor1  C(40) ,;
                           larti1     C(25) ,;
                           tvend1     C(25) ,;
                           vendedor2  C(40) ,;
                           larti2     C(25) ,;
                           tvend2     C(25) ,;
                           vendedor3  C(40) ,;
                           larti3     C(25) ,;
                           tvend3     C(25) ,;
                           vendedor4  C(40) ,;
                           larti4     C(25) ,;
                           tvend4     C(25) ,;
                           vendedor5  C(40) ,;
                           larti5     C(25) ,;
                           tvend5     C(25) ,;
                           saldo_actu N(12) ,;
                           vigente    C(01) ,;
                           id_local   N(02))
**------------------------------------------------------------------------**
CREATE TABLE rmaquina.dbf (numero     N(07),;
                           division   N(03),;
                           tiporecep  N(03),;
                           fecha      D(08),;
                           serieot    C(01),;
                           nroot      N(07),;
                           mecanico   N(03),;
                           tipodocu   N(01),;
                           nrodocu    N(07),;
                           cliente    N(05),;
                           nombreot   C(40),;
                           contacto   C(40),;
                           direcot    C(40),;
                           telefot    C(40),;
                           cedulaot   C(15),;
                           ciudadot   N(05),;
                           marca      N(04),;
                           modelo     N(04),;
                           accesorio  C(56),;
                           motor      C(25),;
                           chasis     C(25),;
                           chapa      C(25),;
                           color      C(15),;
                           km         C(07),;
                           trabajo1   C(60),;
                           trabajo2   C(60),;
                           trabajo3   C(60),;                                          
                           frecepcion D(08),;
                           fentrega   D(08),;
                           estadoot   N(03),;
                           referencia C(10),;
                           localrep   N(01))
**------------------------------------------------------------------------**
CREATE TABLE rubros1.dbf (codigo   N(04) ,;
                          nombre   C(30) ,;
                          vigente  L(01) ,;
                          id_local N(02))
**------------------------------------------------------------------------**
CREATE TABLE rubros2.dbf (codigo   N(04) ,;
                          nombre   C(30) ,;
                          vigente  L(01) ,;
                          id_local N(02))
**------------------------------------------------------------------------**
CREATE TABLE servicio.dbf (articulo  C(15) ,;
                           pcomision N(06,2) ,;
                           id_local  N(02))
**------------------------------------------------------------------------**
CREATE TABLE trecep.dbf (codigo N(03),;
                         nombre C(30))
**------------------------------------------------------------------------**
CREATE TABLE unidad.dbf (codigo   N(04) ,;
                         nombre   C(30) ,;
                         vigente  L(01) ,;
                         id_local N(02))
**------------------------------------------------------------------------**
CREATE TABLE usercfg.dbf (usuario N(04) ,;
                          prgname C(12) ,;
                          access  L(01) ,;
                          add     L(01) ,;                          
                          edit    L(01) ,;                          
                          delete  L(01) ,;                          
                          print   L(01))
**------------------------------------------------------------------------**
CREATE TABLE usuarios.dbf (grupo     N(04) ,;
                           codigo    N(04) ,;
                           nombre    C(40) ,;
                           documento C(15) ,;
                           direc1    C(50) ,;
                           direc2    C(50) ,;
                           ciudad    C(25) ,;
                           barrio    C(25) ,;
                           telefono  C(40) ,;
                           fax       C(25) ,;
                           web_site  C(50) ,;
                           e_mail    C(50) ,;
                           obs1      C(50) ,;
                           obs2      C(50) ,;
                           clave     C(15))
**------------------------------------------------------------------------**
CREATE TABLE vendedor.dbf (codigo    N(03) ,;
                           nombre    C(30) ,;
                           comision1 N(06,2) ,;
                           comision2 N(06,2) ,;
                           vigente   L(01) ,;
                           id_local  N(02))
**------------------------------------------------------------------------**


PROCEDURE _LoadDefaultData

**------------------------------------------------------------------------**
IF USED("familias")
   SELECT familias
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("familias.dbf", "DBF", "¨ D¢nde est  FAMILIAS.DBF ?")) ;
      AGAIN ALIAS familias SHARED ;
      ORDER TAG indice1
ENDIF

INSERT INTO familias (codigo, nombre, p1, p2, p3, p4, p5, vigente) ;
   VALUES (1, "-", 0, 0, 0, 0, 0, .T.)

IF USED("familias")
   SELECT familias
   USE
ENDIF   

**------------------------------------------------------------------------**
IF USED("rubros1")
   SELECT rubros1
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("rubros1.dbf", "DBF", "¨ D¢nde est  RUBROS1.DBF ?")) ;
      AGAIN ALIAS rubros1 SHARED ;
      ORDER TAG indice1
ENDIF

INSERT INTO rubros1 (codigo, nombre, vigente) ;
   VALUES (1, "-", .T.)

IF USED("rubros1")
   SELECT rubros1
   USE
ENDIF

**------------------------------------------------------------------------**
IF USED("rubros2")
   SELECT rubros2
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("rubros2.dbf", "DBF", "¨ D¢nde est  RUBROS2.DBF ?")) ;
      AGAIN ALIAS rubros2 SHARED ;
      ORDER TAG indice1
ENDIF

INSERT INTO rubros2 (codigo, nombre, vigente) ;
   VALUES (1, "-", .T.)

IF USED("rubros2")
   SELECT rubros2
   USE
ENDIF

**------------------------------------------------------------------------**
IF USED("marcas1")
   SELECT marcas1
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("marcas1.dbf", "DBF", "¨ D¢nde est  MARCAS1.DBF ?")) ;
      AGAIN ALIAS marcas1 SHARED ;
      ORDER TAG indice1
ENDIF

INSERT INTO marcas1 (codigo, nombre, vigente) ;
   VALUES (1, "-", .T.)

IF USED("marcas1")
   SELECT marcas1
   USE
ENDIF

**------------------------------------------------------------------------**
IF USED("maquinas")
   SELECT maquinas
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("maquinas.dbf", "DBF", "¨ D¢nde est  MAQUINAS.DBF ?")) ;
      AGAIN ALIAS maquinas SHARED ;
      ORDER TAG indice1
ENDIF

INSERT INTO maquinas (codigo, nombre, vigente) ;
   VALUES (1, "-", .T.)

IF USED("maquinas")
   SELECT maquinas
   USE
ENDIF

**------------------------------------------------------------------------**
IF USED("marcas2")
   SELECT marcas2
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("marcas2.dbf", "DBF", "¨ D¢nde est  MARCAS2.DBF ?")) ;
      AGAIN ALIAS marcas2 SHARED ;
      ORDER TAG indice1
ENDIF

INSERT INTO marcas2 (codigo, nombre, vigente) ;
   VALUES (1, "-", .T.)

IF USED("marcas2")
   SELECT marcas2
   USE
ENDIF

**------------------------------------------------------------------------**
IF USED("modelos")
   SELECT modelos
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("modelos.dbf", "DBF", "¨ D¢nde est  MODELOS.DBF ?")) ;
      AGAIN ALIAS modelos SHARED ;
      ORDER TAG indice1
ENDIF

INSERT INTO modelos (codigo, nombre, marca, vigente) ;
   VALUES (1, "-", 1, .T.)

IF USED("modelos")
   SELECT modelos
   USE
ENDIF
