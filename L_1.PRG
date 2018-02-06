*/ Cobros a Clientes */
* set
   set century on
   set date    british
   set deleted on
   close databases
   clear all

* var
   fecha1 = CTOD("01/12/2005")
   fecha2 = CTOD("31/12/2005")
   arch   = "tm" + right(sys(3), 6)

* db_section

   use cabecob  in 0 order 2
   use detacob  in 0 order 1
   use clientes in 0 order 1
   use monedas  in 0 order 1
   use cabevent in 0 order 1

   select cabecob
   set relation to cliente into clientes, moneda into monedas additive
   
   select detacob
   set relation to str(tipodocu, 1) + str(nrodocu, 7) into cabevent additive

   select 0
   create table &arch (tiporeci   N(01) ,;
                       nroreci    N(07) ,;
                       fechareci  D(08) ,;
                       cliente    C(56) ,;
                       ruc        C(15) ,;
                       monto_cobr N(12,2) ,;
                       moneda     C(04) ,;
                       tipocambio N(09,2) ,;
                       monto_mmnn N(12) ,;
                       dif_cambio N(12) ,;
                       monto_fina N(12) ,;
                       detalle    C(60) ,;
                       fechaanu   D(08) ,;
                       anulado    L(01))
   use &arch alias temporal
   index on dtos(fechareci) + str(tiporeci, 1) + str(nroreci, 7) tag "indice1"

* begin
   select cabecob
   scan all
      if (fechareci >= fecha1 and fechareci <= fecha2) .or. ;
         (fechaanu  >= fecha1 and fechaanu  <= fecha2)
         select temporal
           append blank
           replace tiporeci   with cabecob.tiporeci
           replace nroreci    with cabecob.nroreci
           replace fechareci  with iif(cabecob.anulado, cabecob.fechaanu, cabecob.fechareci)
           replace cliente    with iif(cabecob.anulado, "A N U L A D O", clientes.nombre)
           replace ruc        with clientes.ruc
           replace monto_cobr with cabecob.monto_cobr
           replace moneda     with monedas.simbolo
           replace tipocambio with cabecob.tipocambio

           if cabecob.moneda <> 1
              replace monto_mmnn with round(cabecob.monto_cobr * cabecob.tipocambio, 0)
           else
              replace monto_mmnn with cabecob.monto_cobr
           endif
           
           replace fechaanu   with cabecob.fechaanu
           replace anulado    with cabecob.anulado
           
           select detacob
           if seek(str(cabecob.tiporeci, 1) + str(cabecob.nroreci, 7))
              mdetalle    = " "
              mdif_cambio = 0
              mmonto_fact = 0
              scan while cabecob.tiporeci = detacob.tiporeci .and. cabecob.nroreci  = detacob.nroreci
                 if mdetalle = " "
                    mdetalle = alltrim(str(detacob.nrodocu))
                 else
                    mdetalle = mdetalle + "-" + alltrim(str(detacob.nrodocu))
                 endif
                 mmonto_fact = mmonto_fact + round(detacob.monto * cabevent.tipocambio, 0)
              endscan
              select temporal
              mdif_cambio = mmonto_fact - round(cabecob.monto_cobr * cabecob.tipocambio, 0)
              replace detalle    with mdetalle
              replace dif_cambio with mdif_cambio
              replace monto_fina WITH monto_mmnn + dif_cambio
           endif
      endif
      select cabecob
   endscan

   select temporal
   
   export to "c:\windows\escrit~1\" + arch type xls
   use
   delete file arch + ".dbf"
   delete file arch + ".cdx"

   close databases
* end