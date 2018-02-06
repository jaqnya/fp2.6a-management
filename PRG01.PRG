* Proposito: Verifica si las compras a credito tienen detalles y cuotas.
* Encaso de que no posea cuotas el sistema se encargara
* de crearlas de la sgte manera monto_fact / 2

close databases
set escape off
set deleted on
set century on
set date british


if used("cabecomp")
   select cabecomp
   set order to tag "indice1"
else
   select 0
   use (locfile("cabecomp.dbf","DBF","Donde esta CABECOMP.DBF ?"));
      again alias cabecomp ;
      order tag "indice1"
endif

if used("detacomp")
   select detacomp
   set order to tag "indice1"
else
   select 0
   use (locfile("detacomp.dbf","DBF","Donde esta DETACOMP.DBF ?"));
      again alias detacomp ;
      order tag "indice1"
endif

if used("cuotas_c")
   select cuotas_c
   set order to tag "indice1"
else
   select 0
   use (locfile("cuotas_c.dbf","DBF","Donde esta CUOTAS_C.DBF ?"));
      again alias cuotas_c ;
      order tag "indice1"
endif

select cabecomp
set relation to str(tipodocu,1)+str(nrodocu,9)+str(proveedor,5) into detacomp additive
set relation to str(tipodocu,1)+str(nrodocu,9)+str(proveedor,5) into cuotas_c additive

select cabecomp
go top

if seek(str(2,1))
   do while cabecomp.tipodocu == 2 .not. eof()                
      select detacomp
      
      if .not. seek(str(cabecomp.tipodocu,1)+str(cabecomp.nrodocu,9)+str(cabecomp.proveedor,5))
         wait window "NO POSEE DETALLE "+str(cabecomp.tipodocu,1)+str(cabecomp.nrodocu,9)+str(cabecomp.proveedor,5)
      endif
      
      select cuotas_c
      if .not. seek(str(cabecomp.tipodocu,1)+str(cabecomp.nrodocu,9)+str(cabecomp.proveedor,5))
         wait window "LA COMPRA: "+alltrim(str(cabecomp.tipodocu,1))+"/"+alltrim(str(cabecomp.nrodocu,9))+" CUYO CODIGO DE PROVEEDOR ES: "+alltrim(str(cabecomp.proveedor,5))+" NO POSEE CUOTAS"

         append blank

         replace cuotas_c.tipodocu   with cabecomp.tipodocu
         replace cuotas_c.nrodocu    with cabecomp.nrodocu
         replace cuotas_c.proveedor  with cabecomp.proveedor         
         replace cuotas_c.tipo       with 2
         replace cuotas_c.nrocuota   with 1
         replace cuotas_c.fecha      with cabecomp.fechadocu+30
         replace cuotas_c.importe    with round(cabecomp.monto_fact/2,0)
         replace cuotas_c.abonado    with 0
         replace cuotas_c.monto_ndeb with 0
         replace cuotas_c.monto_ncre with 0      
         
         append blank

         replace cuotas_c.tipodocu   with cabecomp.tipodocu
         replace cuotas_c.nrodocu    with cabecomp.nrodocu
         replace cuotas_c.proveedor  with cabecomp.proveedor
         replace cuotas_c.tipo       with 2
         replace cuotas_c.nrocuota   with 2
         replace cuotas_c.fecha      with cabecomp.fechadocu+60
         replace cuotas_c.importe    with int(cabecomp.monto_fact/2)
         replace cuotas_c.abonado    with 0
         replace cuotas_c.monto_ndeb with 0
         replace cuotas_c.monto_ncre with 0      

      endif

      select cabecomp
      skip
   enddo
endif