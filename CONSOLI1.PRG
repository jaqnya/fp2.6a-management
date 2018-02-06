=CreateTable("cabe1con.dbf")
=CreateIndex("cabe1con.dbf")
=CreateTable("deta1con.dbf")
=CreateIndex("deta1con.dbf")
=CreateTable("cuot1con.dbf")
=CreateIndex("cuot1con.dbf")

=CreateTable("cabe2con.dbf")
=CreateIndex("cabe2con.dbf")
=CreateTable("deta2con.dbf")
=CreateIndex("deta2con.dbf")



*
* CREATETABLE - Crea archivos.
*
PROCEDURE CreateTable
PARAMETER cFile

DO CASE
   CASE cFile = "cabe1con.dbf"
      CREATE TABLE cabe1con.dbf (tipodocu   N(01) ,;
                                 nrodocu    N(07) ,;
                                 lstprecio  N(01) ,;
                                 fechadocu  D(08) ,;
                                 serie      C(01) ,;
                                 nroot      N(07) ,;
                                 moneda     N(04) ,;
                                 tipocambio N(09,2) ,;
                                 qty_cuotas N(03) ,;
                                 nroremi    N(06) ,;
                                 fecharemi  D(08) ,;
                                 cliente    N(05) ,;
                                 vendedor   N(03) ,;
                                 comision_v N(06,2) ,;
                                 porcdesc   N(08,4) ,;
                                 importdesc N(12,2) ,;
                                 descuento  N(08,4) ,;
                                 impreso    L(01) ,;
                                 fechaanu   D(08) ,;
                                 anulado    L(01) ,;
                                 monto_fact N(08) ,;
                                 monto_cobr N(08) ,;
                                 monto_ndeb N(08) ,;
                                 monto_ncre N(08) ,;
                                 consignaci L(01) ,;
                                 id_local   N(02))
   CASE cFile = "deta1con.dbf"
      CREATE TABLE deta1con.dbf (tipodocu   N(01) ,;
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
   CASE cFile = "cuot1con.dbf"
      CREATE TABLE cuot1con.dbf (tipodocu   N(01) ,;
                                 nrodocu    N(07) ,;
                                 tipo       N(01) ,;
                                 nrocuota   N(03) ,;
                                 fecha      D(08) ,;
                                 importe    N(09) ,;
                                 abonado    N(09) ,;
                                 monto_ndeb N(09) ,;
                                 monto_ncre N(09) ,;
                                 id_local   N(02))
   CASE cFile = "cabe2con.dbf"
      CREATE TABLE cabe2con.dbf (tiporeci   N(01) ,;
                                 nroreci    N(07) ,;
                                 fechareci  D(08) ,;
                                 id_local   N(02) ,;
                                 moneda     N(04) ,;
                                 tipocambio N(09,2) ,;
                                 factura    C(01) ,;
                                 cliente    N(07) ,;
                                 cobrador   N(03) ,;
                                 comision   N(06,2) ,;
                                 monto_cobr N(09) ,;
                                 fechaanu   D(08) ,;
                                 anulado    L(01))
   CASE cFile = "deta2con.dbf"
      CREATE TABLE deta2con.dbf (tiporeci  N(01) ,;
                                 nroreci   N(07) ,;
                                 tipodocu  N(01) ,;
                                 nrodocu   N(07) ,;
                                 nrocuota  N(03) ,;
                                 fechadocu D(08) ,;
                                 monto     N(09) ,;
                                 id_local  N(02))
ENDCASE

*
* CREATEINDEX - Crea indices.
*
PROCEDURE CreateIndex
PARAMETER cFile

DO CASE
   CASE cFile = "cabe1con.dbf"
      DELETE TAG ALL OF cabe1con.cdx
      INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) TAG indice1 OF cabe1con.cdx
      INDEX ON DTOS(fechadocu)                    TAG indice2 OF cabe1con.cdx
      INDEX ON cliente                            TAG indice3 OF cabe1con.cdx
   CASE cFile = "deta1con.dbf"
      DELETE TAG ALL OF deta1con.cdx
      INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) TAG indice1 OF deta1con.cdx
   CASE cFile = "cuot1con.dbf"
      DELETE TAG ALL OF cuot1con.cdx
      INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) + STR(nrocuota, 3) TAG indice1 OF cuot1con.cdx
   CASE cFile = "cabe2con.dbf"
      DELETE TAG ALL OF cabe2con.cdx
      INDEX ON STR(tiporeci, 1) + STR(nroreci, 7) TAG indice1 OF cabe2con.cdx
      INDEX ON DTOS(fechareci)                    TAG indice2 OF cabe2con.cdx
      INDEX ON cliente                            TAG indice3 OF cabe2con.cdx
   CASE cFile = "deta2con.dbf"
      DELETE TAG ALL OF deta2con.cdx
      INDEX ON STR(tiporeci, 1) + STR(nroreci, 7) TAG indice1 OF deta2con.cdx
      INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) TAG indice2 OF deta2con.cdx
ENDCASE