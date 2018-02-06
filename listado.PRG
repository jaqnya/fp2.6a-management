*/ Libro IVA - Ventas */

*  set's 
   SET TALK    OFF
   SET CENTURY ON
   SET DATE    BRITISH   
   SET DELETED ON
   SET SAFETY  OFF
   CLOSE DATABASES
   CLEAR ALL

*  var
   m.fecha1   = CTOD("03/05/2006")
   m.fecha2   = CTOD("03/05/2006")
   m.iva_base = 10

   file_01  = " "
   file_02  = " "
   file_03  = " "

*  db_section
   USE cabevent IN 0 ORDER 2
   USE detavent IN 0 ORDER 1
   USE cabeven2 in 0 ORDER 1
   USE clientes in 0 ORDER 1
   USE monedas  in 0 ORDER 1
   USE ot       in 0 ORDER 1
   USE maesprod in 0 ORDER 1

   SELECT 0
   file_01 = createmp()
   CREATE TABLE &file_01 ;
     (tipodocu   N(01),;
      nrodocu    N(07),;
      fechadocu  D(08),;
      cliente    N(05),;
      nombre_a   C(50),;
      ruc        C(15),;
      gravada    N(09),;
      impuesto   N(09),;
      exenta     N(09),;
      total_fact N(09),;
      importe    N(09,2),;
      moneda     C(04),;
      cambio     N(13,6),;
      monto_mmnn N(09),;
      fechaanu   D(08),;
      anulado    L(01),;
      maquina    N(09),;
      mercaderia N(09),;
      taller     N(09),;
      serv_prop  N(09),;
      serv_terc  N(09))
                          
   USE &file_01 ALIAS informe
   INDEX ON STR(tipodocu, 1) + STR(nrodocu, 7) TAG "indice1"

   SELECT 0
   file_02 = createmp()
   CREATE TABLE &file_02 ;
     (porc_iva  N(6,2),;
      monto     N(13,4),;
      descuento N(13,4),;
      neto      N(13,4),;
      gravada   N(13,4),;
      exenta    N(13,4),;
      impuesto  N(13,4)) 
                          
   USE &file_02 ALIAS pie_factura
   INDEX ON porc_iva TAG "indice1"

   SELECT 0
   file_03 = createmp()
   CREATE TABLE &file_03 ;
     (articulo  C(15),;
      cantidad  N(9,2),;
      precio    N(13,4),;
      descuento N(7,4),;
      impuesto  N(6,2),;
      rubro     N(4))
                          
   USE &file_03 ALIAS detatemp

   SELECT cabevent
   REPLACE tipocambio WITH 1 FOR moneda = 1
   SET RELATION TO cliente INTO clientes, moneda INTO monedas, serie + STR(nroot, 7) INTO ot, STR(tipodocu, 1) + STR(nrodocu, 7) INTO cabeven2 ADDITIVE
   
   SELECT detavent
   SET RELATION TO articulo INTO maesprod ADDITIVE
   
*  begin
   SELECT cabevent
   SCAN ALL
      IF fechadocu >= m.fecha1 and fechadocu <= m.fecha2
         m.cambio     = tipocambio
         m.iva_inclui = IIF(INLIST(tipodocu, 3, 7, 8), .T., .F.)
         m.decimales  = IIF(moneda = 1, 0, 2)
         m.porcdesc   = 0

         DO cargar_detalle
         DO cargar_pie_factura
         DO pie_factura
       
         SELECT pie_factura
         STORE 0 TO m.gravada, m.exenta, m.impuesto

         SCAN ALL
            m.gravada  = m.gravada + gravada
            m.exenta   = m.exenta + exenta
            m.impuesto = m.impuesto + impuesto
         ENDSCAN         
         m.total_fact = m.gravada + m.exenta + m.impuesto

         *-------------------------------------------------*
         SELECT detatemp
         STORE 0 TO m.maquina, m.mercaderia, m.taller, m.serv_prop, m.serv_terc, m.mer_exenta
         SCAN ALL
            m.monto_linea = ROUND(precio * cantidad, m.decimales)
            m.monto_desc  = ROUND(m.monto_linea * m.porcdesc / 100, m.decimales)
            m.monto_neto  = m.monto_linea - m.monto_desc

            DO CASE
               CASE INLIST(articulo, "99010", "99011", "99012", "99013", "99014", "99020", "99021", "99022")
                  m.serv_prop = m.serv_prop + m.monto_neto
               CASE INLIST(articulo, "10001", "99001", "99002", "99003")
                  m.serv_terc = m.serv_terc + m.monto_neto
               OTHERWISE
                  IF rubro <> 2
                     IF impuesto > 0 THEN
                        m.mercaderia = m.mercaderia + m.monto_neto
                     ELSE
                        m.mer_exenta = m.mer_exenta + m.monto_neto
                     ENDIF
                  ELSE
                     m.maquina = m.maquina + m.monto_neto
                  ENDIF
            ENDCASE
            
            IF !EMPTY(cabevent.serie) .AND. !EMPTY(cabevent.nroot)
               m.taller = m.mercaderia
               m.mercaderia = 0
            ENDIF
         ENDSCAN
            
         * convierte el importe a moneda local
         m.maquina    = ROUND(m.maquina * m.cambio, 0)
         m.mercaderia = ROUND(m.mercaderia * m.cambio, 0)
         m.taller     = ROUND(m.taller * m.cambio, 0)
         m.serv_prop  = ROUND(m.serv_prop * m.cambio, 0)
         m.serv_terc  = ROUND(m.serv_terc * m.cambio, 0)
         m.mer_exenta = ROUND(m.mer_exenta * m.cambio, 0)
         m.suma = m.maquina + m.mercaderia + m.taller + m.serv_prop + m.serv_terc
                        
            DO WHILE m.suma <> m.gravada 
               WAIT WINDOW STR(m.suma) + STR(m.gravada)
               IF m.exenta <> m.mer_exenta
                  m.mer_exenta = m.exenta
               ELSE
                  IF m.gravada <> m.maquina + m.mercaderia + m.taller + m.serv_prop + m.serv_terc
                     IF m.gravada > m.maquina + m.mercaderia + m.taller + m.serv_prop + m.serv_terc
                        m.dif = m.gravada - (m.maquina + m.mercaderia + m.taller + m.serv_prop + m.serv_terc)
                     ELSE
                        m.dif = -m.gravada + (m.maquina + m.mercaderia + m.taller + m.serv_prop + m.serv_terc)
                     ENDIF
                     IF m.dif > 0 THEN
                        IF m.mercaderia > 0 AND m.dif < m.mercaderia
                           m.mercaderia = m.mercaderia - m.dif
                        ELSE
                           IF m.taller > 0 AND m.dif < m.taller
                              m.taller = m.taller - m.dif
                           ELSE
                              IF m.maquina > 0 AND m.dif < m.maquina
                                 m.maquina = m.maquina - m.dif
                              ENDIF
                           ENDIF
                        ENDIF
                     ELSE
                        IF m.mercaderia > 0 
                           m.mercaderia = m.mercaderia + m.dif
                        ELSE
                           IF m.taller > 0
                              m.taller = m.taller + m.dif
                           ELSE
                              IF m.maquina > 0 
                                 m.maquina = m.maquina + m.dif
                              ENDIF
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            ENDDO

         
         *------------------------------------------*
         SELECT informe
         APPEND BLANK
         REPLACE tipodocu   WITH cabevent.tipodocu
         REPLACE nrodocu    WITH cabevent.nrodocu
         REPLACE fechadocu  WITH cabevent.fechadocu
         REPLACE cliente    WITH cabevent.cliente
         REPLACE gravada    WITH m.gravada
         REPLACE impuesto   WITH m.impuesto
         REPLACE exenta     WITH m.exenta
         REPLACE total_fact WITH m.total_fact
         REPLACE importe    WITH cabevent.monto_fact
         REPLACE moneda     WITH monedas.simbolo
         REPLACE cambio     WITH cabevent.tipocambio
         REPLACE monto_mmnn WITH IIF(cabevent.moneda = 1, cabevent.monto_fact, ROUND(cabevent.monto_fact * cabevent.tipocambio, 0))
         REPLACE fechaanu   WITH cabevent.fechaanu
         REPLACE anulado    WITH cabevent.anulado
         REPLACE maquina    WITH m.maquina
         REPLACE mercaderia WITH m.mercaderia
         REPLACE taller     WITH m.taller
         REPLACE serv_prop  WITH m.serv_prop
         REPLACE serv_terc  WITH m.serv_terc
      ENDIF
   ENDSCAN

   SELECT informe 
   BROWSE                


   SELECT informe 
   USE
   DO borratm WITH file_01
   
   SELECT pie_factura
   USE
   DO borratm WITH file_02
   
   SELECT detatemp
   USE
   DO borratm WITH file_03
                                
*--------------------------------------------------------------------------*
PROCEDURE cargar_detalle
   SELECT detatemp
   ZAP
   
   SELECT pie_factura
   ZAP
   
   SELECT detavent
   SET ORDER TO 1
   SEEK STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)
   SCAN WHILE tipodocu = cabevent.tipodocu .AND. nrodocu = cabevent.nrodocu
      IF m.iva_inclui THEN
         m.precio = ROUND(precio * (1 + pimpuesto / 100), 4)
      ELSE
         m.precio = precio
      ENDIF
      
      INSERT INTO detatemp (articulo, cantidad, precio, descuento, impuesto) ;
         VALUE (detavent.articulo, detavent.cantidad, m.precio, detavent.pdescuento, detavent.pimpuesto)
   ENDSCAN

   SELECT maesprod
   SET ORDER TO 1
 
   SELECT detatemp
   SCAN ALL
      SELECT maesprod
      SEEK detatemp.articulo
      IF FOUND() THEN
         SELECT detatemp
         REPLACE rubro WITH maesprod.rubro
      ENDIF
   ENDSCAN
*ENDPROC

*--------------------------------------------------------------------------*
PROCEDURE pie_factura
   SELECT pie_factura
   SCAN ALL
      IF m.iva_inclui THEN
         IF porc_iva > 0 THEN
            m.base_imponible = ROUND(neto / (1 + porc_iva / 100), m.decimales)
         ELSE
            m.base_imponible = neto
         ENDIF
      ELSE
         m.base_imponible = neto
      ENDIF

      m.gravada = ROUND(m.base_imponible * porc_iva * m.iva_base / 100, m.decimales)
      m.exenta  = m.base_imponible - m.gravada

      IF m.iva_inclui THEN
         m.iva = neto - m.gravada - m.exenta
      ELSE
         m.iva = ROUND(m.gravada * porc_iva / 100, m.decimales)
      ENDIF

      * convierte el importe a moneda local
      m.monto_fact = m.gravada + m.exenta + m.iva
      m.monto_fact = ROUND(m.monto_fact * m.cambio, 0)
      m.exenta     = ROUND(m.exenta * m.cambio, 0)
      m.gravada    = ROUND((m.monto_fact - m.exenta) / 1.1, 0)
      m.iva        = m.monto_fact - m.gravada - m.exenta

      REPLACE gravada  WITH m.gravada
      REPLACE exenta   WITH m.exenta
      REPLACE impuesto WITH m.iva
   ENDSCAN
*ENDPROC



* subrutina calcular rubro de venta
* posible opciones:
* 1 - Máquina
* 2 - Mercadería Gravada
* 3 - Taller
* 4 - Servicio Propio
* 5 - Servicio Tercero
* 6 - Exenta

PROCEDURE calcular_rubro
   STORE 0 TO m.maquina, m.mercaderia, m.taller, m.serv_prop, m.serv_terc, m.exenta

   SELECT detatemp
   SCAN ALL
      IF rubro = 2
         m.maquina = ROUND(precio * cantidad, m.decimales)
      ENDIF
         
      
   ENDSCAN


FUNCTION crEatemp
 DO WHILE .T.
      vaR = 'TM'+SUBSTR(TIME(), 1, 2)+SUBSTR(TIME(), 4, 2)+SUBSTR(TIME(), 7, 2)
      IF  .NOT. FILE(vaR+'.DBF') .AND.  .NOT. FILE(vaR+'.NTX')
           vaR1 = 'VAR'
           VARI = &VAR1
           EXIT
      ENDIF
 ENDDO
 RETURN vaRi
*
PROCEDURE boRratm
 PARAMETER abOrrar
 PRIVATE arChitm1, arChitm2, arChitm3, arChitm4
 arChitm1 = abOrrar+'.DBF'
 arChitm2 = abOrrar+'.IDX'
 arChitm3 = abOrrar+'.VUE'
 arChitm4 = abOrrar+'.CDX'
 IF FILE(arChitm1)
      delete file &architm1
 ENDIF
 IF FILE(arChitm2)
      delete file &architm2
 ENDIF
 IF FILE(arChitm3)
      delete file &architm3
 ENDIF
 IF FILE(arChitm4)
      delete file &architm4
 ENDIF
 RETURN


*--------------------------------------------------------------------------*
PROCEDURE cargar_pie_factura
   STORE 0 TO m.suma_grav, m.suma_exen, m.suma_iva, m.suma_total
   m.porcdesc   = cabevent.porcdesc
   m.importdesc = cabevent.importdesc

   SELECT detatemp
   SCAN ALL
      m.monto_linea = ROUND(precio * cantidad, m.decimales)
      m.desc_linea  = ROUND(m.monto_linea * descuento / 100, m.decimales)
      m.monto_neto  = m.monto_linea - m.desc_linea
      
      m.suma_total  = m.suma_total + m.monto_neto 

      SELECT pie_factura
      IF !SEEK(detatemp.impuesto) THEN
         APPEND BLANK
         REPLACE porc_iva WITH detatemp.impuesto
         REPLACE monto    WITH m.monto_neto
      ELSE
         REPLACE monto WITH (monto + m.monto_neto)
      ENDIF

      SELECT detatemp
   ENDSCAN

   IF m.porcdesc > 0 THEN
      m.importdesc = ROUND(m.suma_total * m.porcdesc / 100, m.decimales)
   ELSE
      IF m.importdesc > 0 THEN
         m.porcdesc = ROUND(m.importdesc * 100 / m.suma_total, 4)
      ENDIF
   ENDIF

   SELECT pie_factura
   SCAN ALL
      REPLACE descuento WITH ROUND(monto * m.porcdesc / 100, m.decimales)
      REPLACE neto WITH (monto - descuento)

      IF m.iva_inclui THEN
         IF porc_iva > 0 THEN
            m.base_imponible = ROUND(neto / (1 + porc_iva / 100), m.decimales)
            m.gravada = ROUND(m.base_imponible * porc_iva * m.iva_base / 100, m.decimales)
            m.exenta  = m.base_imponible - m.gravada
            m.iva     = neto - m.base_imponible
         ELSE
            m.gravada = 0
            m.exenta  = neto
            m.iva     = 0
         ENDIF
      ELSE
         m.gravada = ROUND(neto * porc_iva * m.iva_base / 100, m.decimales)
         m.exenta  = neto - m.gravada
         m.iva     = ROUND(neto * porc_iva / 100, m.decimales)
      ENDIF

      REPLACE gravada  WITH m.gravada
      REPLACE exenta   WITH m.exenta
      REPLACE impuesto WITH m.iva
   ENDSCAN
*ENDPROC