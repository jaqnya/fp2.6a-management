* set
   set century on
   set date    british
   set deleted on
   close databases
   clear all
   
* var
   fecha1 = CTOD("01/12/2005")
   fecha2 = CTOD("01/12/2005")
   arch1  = "tm" + right(sys(3), 6)
   for i = 1 to 10000
   next
   arch2  = "tm" + right(sys(3), 6)
   
* db_section

   use cabevent in 0 order 2
   use detavent in 0 order 1
   use clientes in 0 order 1
   use monedas  in 0 order 1

   select cabevent
   set relation to cliente into clientes, moneda into monedas additive
   
   select 0
   create table &arch1 (tipodocu   N(01) ,;
                        nrodocu    N(07) ,;
                        fechadocu  D(08) ,;
                        cliente    C(56) ,;
                        ruc        C(15) ,;
                        monto_fact N(12,2) ,;
                        moneda     C(04) ,;
                        tipocambio N(09,2) ,;
                        monto_mmnn N(12) ,;
                        gravado    N(10) ,;
                        exento     N(10) ,;
                        impuesto   N(10) ,;
                        fechaanu   D(08) ,;
                        anulado    L(01))
   use &arch1 alias temporal
   index on dtos(fechadocu) + str(tipodocu, 1) + str(nrodocu, 7) tag "indice1"

   select 0
   create table &arch2 (tipodocu   N(01) ,;
                        nrodocu    N(07) ,;
                        cantidad   N(09,2) ,;
                        articulo   C(15) ,;
                        precio     N(13,4) ,;
                        impuesto   L(01) ,;
                        pimpuesto  N(06,2) ,;
                        porc_part  N(12,8))
                        
   use &arch2 alias temporal2
   index on str(tipodocu, 1) + str(nrodocu, 7) tag "indice1"

* begin
   select cabevent
   scan all
      if (fechadocu >= fecha1 and fechadocu <= fecha2) .or. ;
         (fechaanu  >= fecha1 and fechaanu  <= fecha2)
         select temporal
           append blank
           replace tipodocu   with cabevent.tipodocu
           replace nrodocu    with cabevent.nrodocu
           replace fechadocu  with iif(cabevent.anulado, cabevent.fechaanu, cabevent.fechadocu)
           replace cliente    with iif(cabevent.anulado, "A N U L A D O", clientes.nombre)
           replace ruc        with clientes.ruc
           replace monto_fact with cabevent.monto_fact
           replace moneda     with monedas.simbolo
           replace tipocambio with cabevent.tipocambio

           if cabevent.moneda <> 1
              replace monto_mmnn with round(cabevent.monto_fact * cabevent.tipocambio, 0)
           else
              replace monto_mmnn with cabevent.monto_fact
           endif
           
           replace fechaanu   with cabevent.fechaanu
           replace anulado    with cabevent.anulado
           
           select detavent
           if seek(str(cabevent.tipodocu, 1) + str(cabevent.nrodocu, 7))
              scan while cabevent.tipodocu = detavent.tipodocu .and. cabevent.nrodocu = detavent.nrodocu
                 insert into temporal2 (tipodocu, nrodocu, cantidad, articulo, precio, impuesto, pimpuesto, porc_part) ;
                    values (detavent.tipodocu, detavent.nrodocu, detavent.cantidad, detavent.articulo, detavent.precio, detavent.impuesto, detavent.pimpuesto, 0)
              endscan
              
              select temporal2

              msubtotal = 0
              mgravada  = 0
              mexenta   = 0
              
              mpos_dec = iif(cabevent.moneda = 1, 0, 2)
              
              scan all
                 msubtotal = msubtotal + ROUND(precio * cantidad, mpos_dec)
              endscan
               
              scan all
                 replace porc_part WITH ROUND(ROUND(precio * cantidad, mpos_dec) / msubtotal, 8)
              endscan
*             BROW

              STORE 0 TO m.monto_fact, pnGravada, pnExenta, pnImpuesto, pnSubTotal, pnDescGrav, pnDescExen, pnSubTota1, m.importdesc

              SCAN ALL
                 DO CASE
                    CASE impuesto .AND. pimpuesto > 0 .AND. pimpuesto < 10
                       pnGravada = pnGravada + ROUND(precio * cantidad, 0) * (pimpuesto * (10 / 100))
                       pnExenta  = pnExenta  + ROUND(precio * cantidad, 0) * (1 - (pimpuesto * (10 / 100)))
                    CASE impuesto .AND. pimpuesto = 10
                       pnGravada = pnGravada + ROUND(precio * cantidad, 0)            
                    CASE .NOT. impuesto .AND. pimpuesto = 0
                       pnExenta  = pnExenta  + ROUND(precio * cantidad, 0)
                 ENDCASE
              ENDSCAN

              pnSubTotal = pnGravada + pnExenta

              IF cabevent.importdesc > 0 .AND. cabevent.porcdesc = 0
                 pnDescGrav   = ROUND(m.importdesc * ROUND(pnGravada * 100 / pnSubTotal, 2) / 100, 0)
                 pnDescExen   = cabevent.importdesc - pnDescGrav
                 pnSubTota1   = pnSubTotal - cabevent.importdesc
                 pnImpuesto   = ROUND((pnGravada - pnDescGrav) * (10 / 100), 0)
                 m.monto_fact = pnSubTota1 + pnImpuesto
              ELSE
                 IF cabevent.porcdesc > 0
                    pnDescGrav   = ROUND((pnGravada * (m.porcdesc / 100)), 0)
                    pnDescExen   = ROUND((pnExenta  * (m.porcdesc / 100)), 0)
                    m.importdesc = pnDescGrav + pnDescExen
                    pnSubTota1   = pnGravada - pnDescGrav + pnExenta - pnDescExen
                    pnImpuesto   = ROUND(ROUND(pnGravada * (1 - m.porcdesc / 100), 0) * (10 / 100), 0)
                    m.monto_fact = pnSubTota1 + pnImpuesto
                 ELSE
                    IF cabevent.importdesc = 0 .AND. cabevent.porcdesc = 0
                       pnImpuesto   = ROUND(pnGravada * (10 / 100), 0)
                       m.monto_fact = pnSubTotal + pnImpuesto
                    ENDIF
                 ENDIF
              ENDIF

              select temporal
              replace gravado  with pngravada - pndescgrav
              replace exento   with pnexenta  - pndescexen
              replace impuesto with pnimpuesto
              select temporal2
              zap
           endif
      endif
      select cabevent
   endscan

   select temporal
   
   export to "c:\windows\escrit~1\" + arch1 type xls
   use

   delete file arch1 + ".dbf"
   delete file arch1 + ".cdx"

   select temporal2
   use
   delete file arch2 + ".dbf"
   delete file arch2 + ".cdx"

   close databases
* end