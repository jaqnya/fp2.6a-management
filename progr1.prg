*/ Libro IVA - Ventas */

*  set
   set century on
   set date    british   
   set deleted on
   close databases
   clear all

*  var
   fecha1 = ctod("01/12/2005")
   fecha2 = ctod("31/12/2005")
   arch1  = "tm" + right(sys(3), 6)
   
*  db_section
   use cabevent in 0 order 2
   use detavent in 0 order 1
   use cabeven2 in 0 order 1
   use clientes in 0 order 1
   use monedas  in 0 order 1
   use ot       in 0 order 1
   use maesprod in 0 order 1

   select 0
   create table &arch1 (tipodocu   N(01) ,;
                        nrodocu    N(07) ,;
                        fechadocu  D(08) ,;
                        cliente    N(05) ,;
                        nombre_a   C(50) ,;
                        ruc        C(15) ,;
                        gravada    N(09) ,;
                        impuesto   N(09) ,;
                        exenta     N(09) ,;
                        total_fact N(09) ,;
                        importe    N(09,2) ,;
                        moneda     C(04) ,;
                        cambio     N(13,6) ,;
                        monto_mmnn N(09) ,;
                        fechaanu   D(08) ,;
                        anulado    L(01) ,;
                        maquina    N(09) ,;
                        mercaderia N(09) ,;
                        taller     N(09) ,;
                        serv_prop  N(09) ,;
                        serv_terc  N(09))

   use &arch1 alias temp1
   index on str(tipodocu, 1) + str(nrodocu, 7) tag "indice1"

   select cabevent
   set relation to cliente into clientes, moneda into monedas, serie + str(nroot, 7) into ot, str(tipodocu, 1) + str(nrodocu, 7) into cabeven2 additive
   
   select detavent
   set relation to articulo into maesprod additive

*  begin
   select cabevent
   scan all
      if fechadocu >= fecha1 and fechadocu <= fecha2
         select detavent
         if seek(str(cabevent.tipodocu, 1) + str(cabevent.nrodocu, 7))
            store 0 to mgravada, mexenta, mpos_dec, mtotal_linea, mpart_grav, mpart_exen, mporc_grav, ;
                       mporc_exen, mdesc_grav, mdesc_exen, mimpuesto, mimpu_incl, msubtotal, ;
                       mserv_propio, mserv_tercero, mmaquina, mmercaderia, mtaller

            mpos_dec = iif(cabevent.moneda = 1, 0, 2)

            scan while cabevent.tipodocu = detavent.tipodocu .and. cabevent.nrodocu = detavent.nrodocu
               mtotal_linea = round(precio * cantidad, mpos_dec)
               mpart_grav   = mtotal_linea * (pimpuesto * 10 / 100)
               mpart_exen   = mtotal_linea - mpart_grav
               mgravada     = mgravada + mpart_grav
               mexenta      = mexenta  + mpart_exen

               do case
                  case inlist(articulo, "99010", "99011", "99012", "99013", "99014", "99020", "99021", "99022")
                     mserv_propio = mserv_propio + mtotal_linea
                  case inlist(articulo, "10001", "99001", "99002", "99003")
                     mserv_tercero = mserv_tercero + mtotal_linea
                  otherwise
                     if maesprod.rubro <> 2
                        mmercaderia = mmercaderia + mtotal_linea
                     else
                        mmaquina = mmaquina + mtotal_linea
                     endif
               endcase
            endscan
            
            msubtotal   = mgravada + mexenta
      
            mporc_grav  = round(mgravada * 100 / msubtotal, 8)
            mporc_exen  = 100 - mporc_grav   && */ no es necesario calcular, pero se deja contancia */
            
            mdesc_grav  = round(cabevent.importdesc * mporc_grav / 100, mpos_dec)
            mdesc_exen  = cabevent.importdesc - mdesc_grav
            
            mgravada    = mgravada - mdesc_grav
            mexenta     = mexenta  - mdesc_exen
            
            mimpuesto   = round(mgravada * 10 / 100, mpos_dec)
            mtotal_fact = mgravada + mexenta + mimpuesto
            
            mmercaderia = mmercaderia - mdesc_grav - mdesc_exen

            if .not. empty(cabevent.serie) .and. .not. empty(cabevent.nroot)
               mtaller = mmercaderia
               mmercaderia = 0
            endif
            
            if cabevent.moneda <> 1
               mtotal_fact = round(mtotal_fact * cabevent.tipocambio, 0)
               mexenta     = round(mexenta * cabevent.tipocambio, 0)
               mimpu_incl  = mtotal_fact - mexenta
               mgravada    = round(mimpu_incl / 1.1, 0)
               mimpuesto   = mimpu_incl - mgravada
               
               mserv_propio  = round(mserv_propio  * cabevent.tipocambio, 0)
               mserv_tercero = round(mserv_tercero * cabevent.tipocambio, 0)
               
               if mmercaderia = 0 .and. mtaller = 0
                  mmaquina = mgravada + mexenta - mserv_propio - mserv_tercero
               else 
                  if mmaquina = 0 .and. mtaller = 0
                     mmercaderia = mgravada + mexenta - mserv_propio - mserv_tercero
                  else 
                     if mmaquina = 0 .and. mmercaderia = 0
                        mtaller = mgravada + mexenta - mservi_propio - mserv_tercero
                     else
                        if mmaquina > 0 .and. mmercaderia > 0 .and. mtaller = 0
                           mmaquina  = round(mmaquina  * cabevent.tipocambio, 0)
                           mmercaderia = mgravada + mexenta - mmaquina - mserv_propio - mserv_tercero
                        else
                           mmaquina    = round(mmaquina  * cabevent.tipocambio, 0)
                           mmercaderia = round(mmercaderia * cabevent.tipocambio, 0)
                           mtaller = mgravada + mexenta - mmaquina - mmercaderia - mservi_propio - mserv_tercero
                        endif
                     endif
                  endif
               endif 

            endif
            
            if .not. empty(cabeven2.nombre)
               mnombre_a = cabeven2.nombre
               mruc      = cabeven2.documento
            else
               if .not. empty(cabevent.serie) .and. .not. empty(cabevent.nroot)
                  mnombre_a = ot.nombreot
                  mruc      = " "
               else
                  mnombre_a = clientes.nombre
                  mruc      = clientes.ruc
               endif
            endif
               
            select temp1

            append blank
            replace tipodocu   with cabevent.tipodocu
            replace nrodocu    with cabevent.nrodocu
            replace fechadocu  with cabevent.fechadocu
            replace cliente    with cabevent.cliente
            replace nombre_a   with mnombre_a
            replace ruc        with mruc
            replace gravada    with mgravada
            replace impuesto   with mimpuesto
            replace exenta     with mexenta
            replace total_fact with mtotal_fact
            replace importe    with cabevent.monto_fact
            replace moneda     with monedas.simbolo
            replace cambio     with cabevent.tipocambio
            replace monto_mmnn with iif(cabevent.moneda = 1, cabevent.monto_fact, round(cabevent.monto_fact * cabevent.tipocambio, 0))
            replace fechaanu   with cabevent.fechaanu
            replace anulado    with cabevent.anulado
            replace maquina    with mmaquina
            replace mercaderia with mmercaderia
            replace taller     with mtaller
            replace serv_prop  with mserv_propio
            replace serv_terc  with mserv_tercero
         endif
      else
         if fechaanu >= fecha1 and fechaanu <= fecha2
            select temp1
            
            append blank
            replace tipodocu   with cabevent.tipodocu
            replace nrodocu    with cabevent.nrodocu
            replace fechadocu  with cabevent.fechaanu
            replace nombre_a   with "A N U L A D O"
            replace anulado    with cabevent.anulado
         endif
      endif
      
      select cabevent
   endscan
      
   select temp1
   export to "c:\windows\escrit~1\" + arch1 type xls
   use 
   delete file arch1 + ".dbf"
   delete file arch1 + ".cdx"
   close databases
   clear all
*  end