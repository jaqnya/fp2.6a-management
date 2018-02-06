*:**************************************************************************
*:
*: Archivo de Procedimiento: REINDEX.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Mantenimiento de Bases de Datos.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 15/04/2004
*:
*:**************************************************************************
CLEAR
SET DATE    BRITISH
SET CENTURY ON
SET DELETED ON
SET ESCAPE  OFF
SET TALK    OFF

DO reindex1.spr

PRIVATE pnNroIndice
pnNroIndice = 0

CLOSE DATABASES

**------------------------------------------------------------------------**
=CDXName("ACCESOS.CDX")
DO WHILE .T.
   file_status = status("ACCESOS.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE accesos.dbf EXCLUSIVE
         DELETE TAG ALL OF accesos.cdx
         =IndexNumber()
         INDEX ON usuario TAG indice1 OF accesos.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("ACCESOS.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("BARRIOS.CDX")
DO WHILE .T.
   file_status = status("BARRIOS.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE barrios.dbf EXCLUSIVE
         DELETE TAG ALL OF barrios.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF barrios.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF barrios.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("BARRIOS.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CABECOB.CDX")
DO WHILE .T.
   file_status = status("CABECOB.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cabecob.dbf EXCLUSIVE
         DELETE TAG ALL OF cabecob.cdx
         =IndexNumber()
         INDEX ON STR(tiporeci, 1) + STR(nroreci, 7) TAG indice1 OF cabecob.cdx
         =IndexNumber()
         INDEX ON DTOS(fechareci)                    TAG indice2 OF cabecob.cdx
         =IndexNumber()
         INDEX ON cliente                            TAG indice3 OF cabecob.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CABECOB.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CABECOMP.CDX")
DO WHILE .T.
   file_status = status("CABECOMP.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cabecomp.dbf EXCLUSIVE
         DELETE TAG ALL OF cabecomp.cdx
         =IndexNumber()
         INDEX ON STR(tipodocu, 1) + STR(nrodocu, 9) + STR(proveedor, 5) + DTOS(fechadocu) TAG indice1 OF cabecomp.cdx
         =IndexNumber()
         INDEX ON DTOS(fechadocu) + STR(proveedor, 5) + STR(tipodocu, 1) + STR(nrodocu, 9) TAG indice2 OF cabecomp.cdx
         =IndexNumber()
         INDEX ON STR(proveedor, 5) + DTOS(fechadocu) + STR(tipodocu, 1) + STR(nrodocu, 9) TAG indice3 OF cabecomp.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CABECOMP.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CABEMOT.CDX")
DO WHILE .T.
   file_status = status("CABEMOT.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cabemot.dbf EXCLUSIVE
         DELETE TAG ALL OF cabemot.cdx
         =IndexNumber()
         INDEX ON STR(tipobole, 1) + serie + STR(nrobole, 7)               TAG indice1 OF cabemot.cdx
         =IndexNumber()
         INDEX ON DTOS(fecha) + STR(tipobole, 1) + serie + STR(nrobole, 7) TAG indice2 OF cabemot.cdx
         =IndexNumber()
         INDEX ON STR(tipobole, 1) + serie + STR(nrobole, 7) + DTOS(fecha) TAG indice3 OF cabemot.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CABEMOT.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CABEMOT2.CDX")
DO WHILE .T.
   file_status = status("CABEMOT2.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cabemot2.dbf EXCLUSIVE
         DELETE TAG ALL OF cabemot2.cdx
         =IndexNumber()
         INDEX ON STR(tipobole, 1) + serie + STR(nrobole, 7)               TAG indice1 OF cabemot2.cdx
         =IndexNumber()
         INDEX ON DTOS(fecha) + STR(tipobole, 1) + serie + STR(nrobole, 7) TAG indice2 OF cabemot2.cdx
         =IndexNumber()
         INDEX ON STR(tipobole, 1) + serie + STR(nrobole, 7) + DTOS(fecha) TAG indice3 OF cabemot2.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CABEMOT2.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CABEMOVI.CDX")
DO WHILE .T.
   file_status = status("CABEMOVI.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cabemovi.dbf EXCLUSIVE
         DELETE TAG ALL OF cabemovi.cdx
         =IndexNumber()
         INDEX ON STR(tipobole, 1) + STR(nrobole, 7)               TAG indice1 OF cabemovi.cdx
         =IndexNumber()
         INDEX ON DTOS(fecha) + STR(tipobole, 1) + STR(nrobole, 7) TAG indice2 OF cabemovi.cdx
         =IndexNumber()
         INDEX ON STR(tipobole, 1) + STR(nrobole, 7) + DTOS(fecha) TAG indice3 OF cabemovi.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CABEMOVI.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CABENOTC.CDX")
DO WHILE .T.
   file_status = status("CABENOTC.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cabenotc.dbf EXCLUSIVE
         DELETE TAG ALL OF cabenotc.cdx
         =IndexNumber()
         INDEX ON STR(tiponota, 1) + STR(nronota, 7) TAG indice1 OF cabenotc.cdx
         =IndexNumber()
         INDEX ON DTOS(fechanota)                    TAG indice2 OF cabenotc.cdx
         =IndexNumber()
         INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) TAG indice3 OF cabenotc.cdx
         =IndexNumber()
         INDEX ON cliente                            TAG indice4 OF cabenotc.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CABENOTC.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CABENOTP.CDX")
DO WHILE .T.
   file_status = status("CABENOTP.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cabenotp.dbf EXCLUSIVE
         DELETE TAG ALL OF cabenotp.cdx
         =IndexNumber()
         INDEX ON STR(tiponota, 1) + STR(nronota, 9) + STR(proveedor, 5) TAG indice1 OF cabenotp.cdx         
         =IndexNumber()
         INDEX ON DTOS(fechanota)                                        TAG indice2 OF cabenotp.cdx
         =IndexNumber()
         INDEX ON STR(tipodocu, 1) + STR(nrodocu, 9) + STR(proveedor, 5) TAG indice3 OF cabenotp.cdx
         =IndexNumber()
         INDEX ON proveedor                                              TAG indice4 OF cabenotp.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CABENOTP.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CABEPAG.CDX")
DO WHILE .T.
   file_status = status("CABEPAG.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cabepag.dbf EXCLUSIVE
         DELETE TAG ALL OF cabepag.cdx
         =IndexNumber()
         INDEX ON STR(tiporeci, 1) + STR(nroreci, 7) + STR(proveedor, 5) TAG indice1 OF cabepag.cdx
         =IndexNumber()
         INDEX ON DTOS(fechareci)                                        TAG indice2 OF cabepag.cdx
         =IndexNumber()
         INDEX ON STR(proveedor, 5) + DTOS(fechareci)                    TAG indice3 OF cabepag.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CABEPAG.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CABEPRES.CDX")
DO WHILE .T.
   file_status = status("CABEPRES.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cabepres.dbf EXCLUSIVE
         DELETE TAG ALL OF cabepres.cdx
         =IndexNumber()
         INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) TAG indice1 OF cabepres.cdx
         =IndexNumber()
         INDEX ON DTOS(fechadocu)                    TAG indice2 OF cabepres.cdx
         =IndexNumber()
         INDEX ON cliente                            TAG indice3 OF cabepres.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CABEPRES.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CABEREMI.CDX")
DO WHILE .T.
   file_status = status("CABEREMI.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE caberemi.dbf EXCLUSIVE
         DELETE TAG ALL OF caberemi.cdx
         =IndexNumber()
         INDEX ON STR(tiporemi, 1) + serie + STR(nroremi, 7) TAG indice1 OF caberemi.cdx
         =IndexNumber()
         INDEX ON DTOS(fecharemi)                            TAG indice2 OF caberemi.cdx
         =IndexNumber()
         INDEX ON cliente                                    TAG indice3 OF caberemi.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CABEREMI.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CABEVEN2.CDX")
DO WHILE .T.
   file_status = status("CABEVEN2.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cabeven2.dbf EXCLUSIVE
         DELETE TAG ALL OF cabeven2.cdx
         =IndexNumber()
         INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) TAG indice1 OF cabeven2.cdx
         =IndexNumber()
         INDEX ON nombre                             TAG indice2 OF cabeven2.cdx
*        =IndexNumber()
*        INDEX ON motor                              TAG indice3 OF cabeven2.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CABEVEN2.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CABEVENT.CDX")
DO WHILE .T.
   file_status = status("CABEVENT.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cabevent.dbf EXCLUSIVE
         DELETE TAG ALL OF cabevent.cdx
         =IndexNumber()
         INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) TAG indice1 OF cabevent.cdx
         =IndexNumber()
         INDEX ON DTOS(fechadocu)                    TAG indice2 OF cabevent.cdx
         =IndexNumber()
         INDEX ON cliente                            TAG indice3 OF cabevent.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CABEVENT.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CIUDADES.CDX")
DO WHILE .T.
   file_status = status("CIUDADES.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE ciudades.dbf EXCLUSIVE
         DELETE TAG ALL OF ciudades.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF ciudades.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF ciudades.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CIUDADES.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CLIENTES.CDX")
DO WHILE .T.
   file_status = status("CLIENTES.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE clientes.dbf EXCLUSIVE
         DELETE TAG ALL OF clientes.cdx
         =IndexNumber()
         INDEX ON codigo     TAG indice1 OF clientes.cdx
         =IndexNumber()
         INDEX ON nombre     TAG indice2 OF clientes.cdx
         =IndexNumber()
         INDEX ON documento  TAG indice3 OF clientes.cdx
         =IndexNumber()
         INDEX ON nombre_c   TAG indice4 OF clientes.cdx
         =IndexNumber()
         INDEX ON docconyuge TAG indice5 OF clientes.cdx
         =IndexNumber()
         INDEX ON nombre_g   TAG indice6 OF clientes.cdx
         =IndexNumber()
         INDEX ON docgarante TAG indice7 OF clientes.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CLIENTES.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("COBRADOR.CDX")
DO WHILE .T.
   file_status = status("COBRADOR.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cobrador.dbf EXCLUSIVE
         DELETE TAG ALL OF cobrador.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF cobrador.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF cobrador.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("COBRADOR.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CUOTAS_C.CDX")
DO WHILE .T.
   file_status = status("CUOTAS_C.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cuotas_c.dbf EXCLUSIVE
         DELETE TAG ALL OF cuotas_c.cdx
         =IndexNumber()
         INDEX ON STR(tipodocu, 1) + STR(nrodocu, 9) + STR(proveedor, 5) + STR(nrocuota, 3) TAG indice1 OF cuotas_c.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CUOTAS_C.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CUOTAS_N.CDX")
DO WHILE .T.
   file_status = status("CUOTAS_N.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cuotas_n.dbf EXCLUSIVE
         DELETE TAG ALL OF cuotas_n.cdx
         =IndexNumber()
         INDEX ON docinicial + STR(tiponota, 1) + STR(nronota, 7) TAG indice1 OF cuotas_n.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CUOTAS_N.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CUOTAS_P.CDX")
DO WHILE .T.
   file_status = status("CUOTAS_P.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cuotas_p.dbf EXCLUSIVE
         DELETE TAG ALL OF cuotas_p.cdx
         =IndexNumber()
         INDEX ON STR(tiponota, 1) + STR(nronota, 9) + STR(proveedor, 5) TAG indice1 OF cuotas_p.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CUOTAS_P.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("CUOTAS_V.CDX")
DO WHILE .T.
   file_status = status("CUOTAS_V.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE cuotas_v.dbf EXCLUSIVE
         DELETE TAG ALL OF cuotas_v.cdx
         =IndexNumber()
         INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) + STR(nrocuota, 3) TAG indice1 OF cuotas_v.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CUOTAS_V.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("DEPAR.CDX")
DO WHILE .T.
   file_status = status("DEPAR.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE depar.dbf EXCLUSIVE
         DELETE TAG ALL OF depar.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF depar.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF depar.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("DEPAR.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("DETACOB.CDX")
DO WHILE .T.
   file_status = status("DETACOB.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE detacob.dbf EXCLUSIVE
         DELETE TAG ALL OF detacob.cdx
         =IndexNumber()
         INDEX ON STR(tiporeci, 1) + STR(nroreci, 7) TAG indice1 OF detacob.cdx
         =IndexNumber()
         INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) TAG indice2 OF detacob.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("DETACOB.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("DETACOMP.CDX")
DO WHILE .T.
   file_status = status("DETACOMP.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE detacomp.dbf EXCLUSIVE
         DELETE TAG ALL OF detacomp.cdx
         =IndexNumber()
         INDEX ON STR(tipodocu, 1) + STR(nrodocu, 9) + STR(proveedor, 5) TAG indice1 OF detacomp.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("CABECOMP.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("DETAMOT.CDX")
DO WHILE .T.
   file_status = status("DETAMOT.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE detamot.dbf EXCLUSIVE
         DELETE TAG ALL OF detamot.cdx
         =IndexNumber()
         INDEX ON STR(tipobole, 1) + serie + STR(nrobole, 7) TAG indice1 OF detamot.cdx
         =IndexNumber()
         INDEX ON articulo                                   TAG indice2 OF detamot.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("DETAMOT.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("DETAMOT2.CDX")
DO WHILE .T.
   file_status = status("DETAMOT2.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE detamot2.dbf EXCLUSIVE
         DELETE TAG ALL OF detamot2.cdx
         =IndexNumber()
         INDEX ON STR(tipobole, 1) + serie + STR(nrobole, 7) TAG indice1 OF detamot2.cdx
         =IndexNumber()
         INDEX ON articulo                                   TAG indice2 OF detamot2.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("DETAMOT2.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("DETAMOVI.CDX")
DO WHILE .T.
   file_status = status("DETAMOVI.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE detamovi.dbf EXCLUSIVE
         DELETE TAG ALL OF detamovi.cdx
         =IndexNumber()
         INDEX ON STR(tipobole, 1) + STR(nrobole, 7) TAG indice1 OF detamovi.cdx
         =IndexNumber()
         INDEX ON articulo                           TAG indice2 OF detamovi.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("DETAMOVI.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("DETANOTC.CDX")
DO WHILE .T.
   file_status = status("DETANOTC.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE detanotc.dbf EXCLUSIVE
         DELETE TAG ALL OF detanotc.cdx
         =IndexNumber()
         INDEX ON STR(tiponota, 1) + STR(nronota, 7) TAG indice1 OF detanotc.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("DETANOTC.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("DETANOTP.CDX")
DO WHILE .T.
   file_status = status("DETANOTP.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE detanotp.dbf EXCLUSIVE
         DELETE TAG ALL OF detanotp.cdx
         =IndexNumber()
         INDEX ON STR(tiponota, 1) + STR(nronota, 9) + STR(proveedor, 5) TAG indice1 OF detanotp.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("DETANOTP.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("DETAPAG.CDX")
DO WHILE .T.
   file_status = status("DETAPAG.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE detapag.dbf EXCLUSIVE
         DELETE TAG ALL OF detapag.cdx
         =IndexNumber()
         INDEX ON STR(tiporeci, 1) + STR(nroreci, 7) + STR(proveedor, 5) TAG indice1 OF detapag.cdx
         =IndexNumber()
         INDEX ON STR(tipodocu, 1) + STR(nrodocu, 9) + STR(proveedor, 5) TAG indice2 OF detapag.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("DETAPAG.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("DETAPRES.CDX")
DO WHILE .T.
   file_status = status("DETAPRES.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE detapres.dbf EXCLUSIVE
         DELETE TAG ALL OF detapres.cdx
         =IndexNumber()
         INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) TAG indice1 OF detapres.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("DETAPRES.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("DETAREMI.CDX")
DO WHILE .T.
   file_status = status("DETAREMI.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE detaremi.dbf EXCLUSIVE
         DELETE TAG ALL OF detaremi.cdx
         =IndexNumber()
         INDEX ON STR(tiporemi, 1) + serie +  STR(nroremi, 7) TAG indice1 OF detaremi.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("DETAREMI.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("DETAVENT.CDX")
DO WHILE .T.
   file_status = status("DETAVENT.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE detavent.dbf EXCLUSIVE
         DELETE TAG ALL OF detavent.cdx
         =IndexNumber()
         INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) TAG indice1 OF detavent.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("DETAVENT.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("DIVISION.CDX")
DO WHILE .T.
   file_status = status("DIVISION.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE division.dbf EXCLUSIVE
         DELETE TAG ALL OF division.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF division.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF division.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("DIVISION.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("ESTADOOT.CDX")
DO WHILE .T.
   file_status = status("ESTADOOT.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE estadoot.dbf EXCLUSIVE
         DELETE TAG ALL OF estadoot.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF estadoot.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF estadoot.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("ESTADOOT.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("FAMILIAS.CDX")
DO WHILE .T.
   file_status = status("FAMILIAS.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE familias.dbf EXCLUSIVE
         DELETE TAG ALL OF familias.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF familias.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF familias.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("FAMILIAS.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("LOCALES.CDX")
DO WHILE .T.
   file_status = status("LOCALES.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE locales.dbf EXCLUSIVE
         DELETE TAG ALL OF locales.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF locales.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF locales.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("LOCALES.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("MAESPROD.CDX")
DO WHILE .T.
   file_status = status("MAESPROD.DBF")
   DO CASE
      CASE file_status = 0
             SELECT 0
         USE maesprod.dbf EXCLUSIVE
         DELETE TAG ALL OF maesprod.cdx
         =IndexNumber()
         INDEX ON codigo      TAG indice1 OF maesprod.cdx
         =IndexNumber()       
         INDEX ON nombre      TAG indice2 OF maesprod.cdx
         =IndexNumber()
         INDEX ON rubro       TAG indice3 OF maesprod.cdx
         =IndexNumber()
         INDEX ON subrubro    TAG indice4 OF maesprod.cdx
         =IndexNumber()
         INDEX ON marca       TAG indice5 OF maesprod.cdx
         =IndexNumber()
         INDEX ON codigo2     TAG indice6 OF maesprod.cdx
         =IndexNumber()
         INDEX ON codorig     TAG indice7 OF maesprod.cdx
         =IndexNumber()
         INDEX ON val(codigo) TAG indice8 OF maesprod.cdx
         =IndexNumber()
         INDEX ON familia     TAG indice9 OF maesprod.cdx
         =IndexNumber()
         INDEX ON nombre      TAG indice10 OF maesprod.cdx for vigente 
         =IndexNumber()
         INDEX ON codigo      TAG indice11 OF maesprod.cdx for vigente 
         =IndexNumber()
         INDEX ON codigo2     TAG indice12 OF maesprod.cdx for vigente 
         =IndexNumber()
         INDEX ON codorig     TAG indice13 OF maesprod.cdx for vigente
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("MAESPROD.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("MAQUINAS.CDX")
DO WHILE .T.
   file_status = status("MAQUINAS.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE maquinas.dbf EXCLUSIVE
         DELETE TAG ALL OF maquinas.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF maquinas.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF maquinas.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("MAQUINAS.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("MARCAS1.CDX")
DO WHILE .T.
   file_status = status("MARCAS1.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE marcas1.dbf EXCLUSIVE
         DELETE TAG ALL OF marcas1.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF marcas1.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF marcas1.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("MARCAS1.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("MARCAS2.CDX")
DO WHILE .T.
   file_status = status("MARCAS2.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE marcas2.dbf EXCLUSIVE
         DELETE TAG ALL OF marcas2.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF marcas2.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF marcas2.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("MARCAS2.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("MECANCFG.CDX")
DO WHILE .T.
   file_status = status("MECANCFG.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE mecancfg.dbf EXCLUSIVE
         DELETE TAG ALL OF mecancfg.cdx
         =IndexNumber()
         INDEX ON mecanico TAG indice1 OF mecancfg.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("MECANCFG.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("MECANICO.CDX")
DO WHILE .T.
   file_status = status("MECANICO.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE mecanico.dbf EXCLUSIVE
         DELETE TAG ALL OF mecanico.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF mecanico.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF mecanico.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("MECANICO.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("MODELOS.CDX")
DO WHILE .T.
   file_status = status("MODELOS.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE modelos.dbf EXCLUSIVE
         DELETE TAG ALL OF modelos.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF modelos.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF modelos.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("MODELOS.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("MONEDAS.CDX")
DO WHILE .T.
   file_status = status("MONEDAS.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE monedas.dbf EXCLUSIVE
         DELETE TAG ALL OF monedas.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF monedas.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF monedas.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("MONEDAS.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("MOTIVOCL.CDX")
DO WHILE .T.
   file_status = status("MOTIVOCL.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE motivocl.dbf EXCLUSIVE
         DELETE TAG ALL OF motivocl.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF motivocl.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF motivocl.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("MOTIVOCL.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("MOTIVONO.CDX")
DO WHILE .T.
   file_status = status("MOTIVONO.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE motivono.dbf EXCLUSIVE
         DELETE TAG ALL OF motivono.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF motivono.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF motivono.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("MOTIVONO.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("OT.CDX")
DO WHILE .T.
   file_status = status("OT.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE ot.dbf EXCLUSIVE
         DELETE TAG ALL OF ot.cdx
         =IndexNumber()
         INDEX ON serie + STR(nroot, 7)          TAG indice1 OF ot.cdx
         =IndexNumber()
         INDEX ON DTOS(frecepcion)               TAG indice2 OF ot.cdx
         =IndexNumber()
         INDEX ON DTOS(fentrega)                 TAG indice3 OF ot.cdx
         =IndexNumber()
         INDEX ON cliente                        TAG indice4 OF ot.cdx
         =IndexNumber()
         INDEX ON nombreot                       TAG indice5 OF ot.cdx
         =IndexNumber()
         INDEX ON cedulaot                       TAG indice6 OF ot.cdx
         =IndexNumber()
         INDEX ON STR(marca, 4) + STR(modelo, 4) TAG indice7 OF ot.cdx
         =IndexNumber()
         INDEX ON estadoot                       TAG indice8 OF ot.cdx
         =IndexNumber()
         INDEX ON chapa                          TAG indice9 OF ot.cdx
         =IndexNumber()
         INDEX ON motor                          TAG indice10 OF ot.cdx
         =IndexNumber()
         INDEX ON chasis                         TAG indice11 OF ot.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("OT.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("OT2.CDX")
DO WHILE .T.
   file_status = status("OT2.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE ot2.dbf EXCLUSIVE
         DELETE TAG ALL OF ot2.cdx
         =IndexNumber()
         INDEX ON serieot2 + STR(nroot2, 7)      TAG indice1 OF ot2.cdx
         =IndexNumber()
         INDEX ON DTOS(frecepcion)               TAG indice2 OF ot2.cdx
         =IndexNumber()
         INDEX ON DTOS(fentrega)                 TAG indice3 OF ot2.cdx
         =IndexNumber()
         INDEX ON cliente                        TAG indice4 OF ot2.cdx
         =IndexNumber()
         INDEX ON nombreot                       TAG indice5 OF ot2.cdx
         =IndexNumber()
         INDEX ON cedulaot                       TAG indice6 OF ot2.cdx
         =IndexNumber()
         INDEX ON STR(marca, 4) + STR(modelo, 4) TAG indice7 OF ot2.cdx
         =IndexNumber()
         INDEX ON estadoot                       TAG indice8 OF ot2.cdx
         =IndexNumber()
         INDEX ON chapa                          TAG indice9 OF ot2.cdx
         =IndexNumber()
         INDEX ON motor                          TAG indice10 OF ot2.cdx
         =IndexNumber()
         INDEX ON chasis                         TAG indice11 OF ot2.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("OT2.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("PROCEDEN.CDX")
DO WHILE .T.
   file_status = status("PROCEDEN.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE proceden.dbf EXCLUSIVE
         DELETE TAG ALL OF proceden.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF proceden.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF proceden.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("PROCEDEN.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("PROVEEDO.CDX")
DO WHILE .T.
   file_status = status("PROVEEDO.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE proveedo.dbf EXCLUSIVE
         DELETE TAG ALL OF proveedo.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF proveedo.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF proveedo.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("PROVEEDO.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("RMAQUINA.CDX")
DO WHILE .T.
   file_status = status("RMAQUINA.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE rmaquina.dbf EXCLUSIVE
         DELETE TAG ALL OF rmaquina.cdx
         =IndexNumber()
         INDEX ON numero                         TAG indice1 OF rmaquina.cdx
         =IndexNumber()
         INDEX ON frecepcion                     TAG indice2 OF rmaquina.cdx
         =IndexNumber()
         INDEX ON cliente                        TAG indice3 OF rmaquina.cdx
         =IndexNumber()
         INDEX ON STR(marca, 4) + STR(modelo, 4) TAG indice4 OF rmaquina.cdx
         =IndexNumber()
         INDEX ON chapa                          TAG indice5 OF rmaquina.cdx
         =IndexNumber()
         INDEX ON nombreot                       TAG indice6 OF rmaquina.cdx
         =IndexNumber()
         INDEX ON cedulaot                       TAG indice7 OF rmaquina.cdx
         =IndexNumber()
         INDEX ON fentrega                       TAG indice8 OF rmaquina.cdx
         =IndexNumber()
         INDEX ON motor                          TAG indice9 OF rmaquina.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("RMAQUINA.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("RUBROS1.CDX")
DO WHILE .T.
   file_status = status("RUBROS1.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE rubros1.dbf EXCLUSIVE
         DELETE TAG ALL OF rubros1.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF rubros1.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF rubros1.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("RUBROS1.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("RUBROS2.CDX")
DO WHILE .T.
   file_status = status("RUBROS2.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE rubros2.dbf EXCLUSIVE
         DELETE TAG ALL OF rubros2.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF rubros2.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF rubros2.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("RUBROS2.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("SERVICIO.CDX")
DO WHILE .T.
   file_status = status("SERVICIO.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE servicio.dbf EXCLUSIVE
         DELETE TAG ALL OF servicio.cdx
         =IndexNumber()
         INDEX ON articulo TAG indice1 OF servicio.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("SERVICIO.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("TRECEP.CDX")
DO WHILE .T.
   file_status = status("TRECEP.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE trecep.dbf EXCLUSIVE
         DELETE TAG ALL OF trecep.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF trecep.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF trecep.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("TRECEP.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("UNIDAD.CDX")
DO WHILE .T.
   file_status = status("UNIDAD.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE unidad.dbf EXCLUSIVE
         DELETE TAG ALL OF unidad.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF unidad.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF unidad.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("UNIDAD.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("USERCFG.CDX")
DO WHILE .T.
   file_status = status("USERCFG.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE usercfg.dbf EXCLUSIVE
         DELETE TAG ALL OF usercfg.cdx
         =IndexNumber()
         INDEX ON STR(usuario, 4) + prgname TAG indice1 OF usercfg.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("USERCFG.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("USOP.CDX")
DO WHILE .T.
   file_status = status("USOP.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE usop.dbf EXCLUSIVE
         DELETE TAG ALL OF usop.cdx
         =IndexNumber()
         INDEX ON usuario TAG indice1 OF usop.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("USOP.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("USUARIOS.CDX")
DO WHILE .T.
   file_status = status("USUARIOS.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE usuarios.dbf EXCLUSIVE
         DELETE TAG ALL OF usuarios.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF usuarios.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF usuarios.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("USUARIOS.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**
=CDXName("VENDEDOR.CDX")
DO WHILE .T.
   file_status = status("VENDEDOR.DBF")
   DO CASE
      CASE file_status = 0
         SELECT 0
         USE vendedor.dbf EXCLUSIVE
         DELETE TAG ALL OF vendedor.cdx
         =IndexNumber()
         INDEX ON codigo TAG indice1 OF vendedor.cdx
         =IndexNumber()
         INDEX ON nombre TAG indice2 OF vendedor.cdx
         USE
         EXIT DO
      CASE file_status = 1
         IF _RetryReindex("VENDEDOR.DBF")
            LOOP
         ELSE
            EXIT DO
         ENDIF
      OTHERWISE
         EXIT DO
   ENDCASE
ENDDO
**-------------------------------------------------------------------------**

? CHR(7)+CHR(7)   && Indica la finalizaci¢n del proceso.
QUIT

*!**************************************************************************
*!
*!      Funci¢n: IndexNumber
*!
*!  Llamado por: REINDEX.PRG                
*!
*!  Descripci¢n: Devuelve el n£mero de indice que se est  creando.
*!
*!**************************************************************************
FUNCTION IndexNumber
pnNroIndice = pnNroIndice + 1  
@ 06,23 SAY PADR(ALLTRIM(STR(pnNroIndice)), 12, CHR(32)) ;
   SIZE 1,12 ;
   COLOR GR+/B

*!**************************************************************************
*!
*!      Funci¢n: CDXName     
*!
*!  Llamado por: REINDEX.PRG                
*!
*!  Descripci¢n: Imprime el nombre del archivo CDX que se est  procesando.
*!
*!**************************************************************************
FUNCTION CDXName
PARAMETER pcCDXName
@ 04,23 SAY PADR(pcCDXName, 12, CHR(32)) ;
   SIZE 1,12 ;
   COLOR GR+/B

*!**************************************************************************
*!
*!      Funci¢n: _RetryReindex
*!
*!  Llamado por: REINDEX.PRG                
*!
*!  Descripci¢n: Intenta reindexar una tabla que se encuentra en uso compar-
*!               tido.
*!
*!**************************************************************************
FUNCTION _RetryReindex
PARAMETER pcWhatTable
DO WHILE .T.
   WAIT WINDOW [­ LA TABLA "]+pcWhatTable+[" SE ENCUENTRA EN USO !] + CHR(13) + ;
               [¨ DESEA INTENTAR REINDEXARLO DE NUEVO ? ] + "[S/N]" TO pcWhatToDo
   IF UPPER(pcWhatToDo) = "S"
      RETURN .T.
      EXIT DO
   ELSE
      IF UPPER(pcWhatToDo) = "N"
         RETURN .F.
         EXIT DO 
      ENDIF
   ENDIF
ENDDO