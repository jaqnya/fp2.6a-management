*/ Pagos a Proveedores */
* set
   set century   on
   set date      british
   set deleted   on
   set exclusive off
   close databases
   clear all

* var
   fecha1 = CTOD("01/12/2005")
   fecha2 = CTOD("31/12/2005")
   arch   = "tm" + right(sys(3), 6)

* db_section

   use cabepag  in 0 order 2
   use detapag  in 0 order 1
   use proveedo in 0 order 1
   use monedas  in 0 order 1
   use cabecomp in 0 order 1

   select cabepag
   set relation to proveedor into proveedo, moneda into monedas additive
   
   select detapag
   set relation to str(tipodocu, 1) + str(nrodocu, 9) + str(proveedor, 5) into cabecomp additive

   select 0
   create table &arch (tiporeci   N(01) ,;
                       nroreci    N(07) ,;
                       fechareci  D(08) ,;
                       proveedor  C(56) ,;
                       ruc        C(15) ,;
                       monto_pago N(12,2) ,;
                       moneda     C(04) ,;
                       tipocambio N(09,2) ,;
                       monto_mmnn N(12) ,;
                       dif_cambio N(12) ,;
                       monto_fina N(12) ,;
                       detalle    C(60))
   use &arch alias temporal
   index on dtos(fechareci) + str(tiporeci, 1) + str(nroreci, 7) tag "indice1"

* begin
   select cabepag
   scan all
      if fechareci >= fecha1 .and. fechareci <= fecha2
         select temporal
           append blank
           replace tiporeci   with cabepag.tiporeci
           replace nroreci    with cabepag.nroreci
           replace fechareci  with cabepag.fechareci
           replace proveedor  with proveedo.nombre
           replace ruc        with proveedo.ruc
           replace monto_pago with cabepag.monto_pago
           replace moneda     with monedas.simbolo
           replace tipocambio with cabepag.tipocambio

           if cabepag.moneda <> 1
              replace monto_mmnn with round(cabepag.monto_pago * cabepag.tipocambio, 0)
           else
              replace monto_mmnn with cabepag.monto_pago
           endif
           
           select detapag
           if seek(str(cabepag.tiporeci, 1) + str(cabepag.nroreci, 7) + str(cabepag.proveedor, 5))
              mdetalle    = " "
              mdif_cambio = 0
              mmonto_fact = 0
              scan while cabepag.tiporeci = detapag.tiporeci .and. cabepag.nroreci  = detapag.nroreci .and. cabepag.proveedor = detapag.proveedor
                 if mdetalle = " "
                    mdetalle = alltrim(str(detapag.nrodocu))
                 else
                    mdetalle = mdetalle + "-" + alltrim(str(detapag.nrodocu))
                 endif
                 mmonto_fact = mmonto_fact + round(detapag.monto * cabecomp.tipocambio, 0)
              endscan
              select temporal
              mdif_cambio = mmonto_fact - round(cabepag.monto_pago * cabepag.tipocambio, 0)
              replace detalle    with mdetalle
              replace dif_cambio with mdif_cambio
              replace monto_fina WITH monto_mmnn + dif_cambio
           endif
      endif
      select cabepag
   endscan

   select temporal
   
   export to "c:\windows\escrit~1\" + arch type xls
   use
   delete file arch + ".dbf"
   delete file arch + ".cdx"

   close databases
* end