*/ Libro IVA - Compras */

*  set
   set century   on
   set date      british   
   set deleted   on
   set exclusive off
   close databases
   clear all

*  var
   fecha1 = ctod("01/12/2005")
   fecha2 = ctod("31/12/2005")
   arch1  = "tm" + right(sys(3), 6)

   store 0 to mgravada, mexenta, mpos_dec, mtotal_linea, mpart_grav, mpart_exen, mporc_grav, ;
              mporc_exen, mdesc_grav, mdesc_exen, mimpuesto, mimpu_incl, msubtotal

*  db_section
   use cabecomp in 0 order 2
   use detacomp in 0 order 1
   use proveedo in 0 order 1
   use monedas  in 0 order 1
   use maesprod in 0 order 1

   select 0
   create table &arch1 (tipodocu   N(01) ,;
                        nrodocu    N(09) ,;
                        fechadocu  D(08) ,;
                        proveedor  N(05) ,;
                        nombre_a   C(50) ,;
                        ruc        C(15) ,;
                        gravada    N(09) ,;
                        impuesto   N(09) ,;
                        exenta     N(09) ,;
                        total_fact N(09) ,;
                        importe    N(09,2) ,;
                        moneda     C(04) ,;
                        cambio     N(13,6) ,;
                        monto_mmnn N(09))

   use &arch1 alias temp1
   index on str(tipodocu, 1) + str(nrodocu, 9) + str(proveedor, 5) tag "indice1"

   select cabecomp
   set relation to proveedor into proveedo, moneda into monedas additive
   
   select detacomp
   set relation to articulo into maesprod additive

*  begin
   select cabecomp
   scan all
      if fechadocu >= fecha1 and fechadocu <= fecha2
         select detacomp
         if seek(str(cabecomp.tipodocu, 1) + str(cabecomp.nrodocu, 9) + str(cabecomp.proveedor, 5))
            store 0 to mgravada, mexenta, mpos_dec, mtotal_linea, mpart_grav, mpart_exen, mporc_grav, ;
                       mporc_exen, mdesc_grav, mdesc_exen, mimpuesto, mimpu_incl, msubtotal, ;
                       mserv_propio, mserv_tercero, mmaquina, mmercaderia, mtaller

            mpos_dec = iif(cabecomp.moneda = 1, 0, 2)

            scan while cabecomp.tipodocu = detacomp.tipodocu .and. cabecomp.nrodocu = detacomp.nrodocu .and. cabecomp.proveedor = detacomp.proveedor
               mtotal_linea = round(precio * cantidad, mpos_dec) - round(round(precio * cantidad, mpos_dec) * pdescuento / 100, mpos_dec)
               mpart_grav   = mtotal_linea * (pimpuesto * 10 / 100)
               mpart_exen   = mtotal_linea - mpart_grav
               mgravada     = mgravada + mpart_grav
               mexenta      = mexenta  + mpart_exen
            endscan
            
            msubtotal   = mgravada + mexenta
      
            mporc_grav  = round(mgravada * 100 / msubtotal, 8)
            mporc_exen  = 100 - mporc_grav   && */ no es necesario calcular, pero se deja constancia */
            
            mdesc_grav  = round(cabecomp.importdesc * mporc_grav / 100, mpos_dec)
            mdesc_exen  = cabecomp.importdesc - mdesc_grav
            
            mgravada    = mgravada - mdesc_grav
            mexenta     = mexenta  - mdesc_exen
            
            mimpuesto   = round(mgravada * 10 / 100, mpos_dec)
            mtotal_fact = mgravada + mexenta + mimpuesto
            
            if cabecomp.moneda <> 1
               mtotal_fact = round(mtotal_fact * cabecomp.tipocambio, 0)
               mexenta     = round(mexenta * cabecomp.tipocambio, 0)
               mimpu_incl  = mtotal_fact - mexenta
               mgravada    = round(mimpu_incl / 1.1, 0)
               mimpuesto   = mimpu_incl - mgravada
            endif
            
            mnombre_a = proveedo.nombre
            mruc      = proveedo.ruc
               
            select temp1

            append blank
            replace tipodocu   with cabecomp.tipodocu
            replace nrodocu    with cabecomp.nrodocu
            replace fechadocu  with cabecomp.fechadocu
            replace proveedor  with cabecomp.proveedor
            replace nombre_a   with mnombre_a
            replace ruc        with mruc
            replace gravada    with mgravada
            replace impuesto   with mimpuesto
            replace exenta     with mexenta
            replace total_fact with mtotal_fact
            replace importe    with cabecomp.monto_fact
            replace moneda     with monedas.simbolo
            replace cambio     with cabecomp.tipocambio
            replace monto_mmnn with iif(cabecomp.moneda = 1, cabecomp.monto_fact, round(cabecomp.monto_fact * cabecomp.tipocambio, 0))
         endif
      endif
      
      select cabecomp
   endscan
      
   select temp1
   export to "c:\windows\escrit~1\" + arch1 type xls
   use 
   delete file arch1 + ".dbf"
   delete file arch1 + ".cdx"
   close databases
   clear all
*  end