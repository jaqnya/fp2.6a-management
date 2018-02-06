push key clear
on key label "F2" do depar with "Add"
on key label "F3" do depar with "Edit"
on key label "F4" do deporden.spr
on key label "F5" do deswitch.prg
on key label "F8" do depar with "Delete"

if used("depar")
   select depar   
   set order to tag "indice2" of depar.cdx
else
   select 0
   use (locfile("depar.dbf","DBF","¨ D¢nde est  DEPAR.DBF ?"));
        again alias depar ;
        order tag "indice2" of depar.cdx
endif

if not wexist ("b_depar")
   define window b_depar ;
      from 02,19 ;
      to 22,59 ;
      title "< DEPARTAMENTOS >" ;
      float ;
      grow ;
      close ;
      shadow ;
      nominimize ;
      zoom ;
      system ; 
      color scheme 16
endif

browse window b_depar fields ;
   codigo   :r:06:h = 'C¢digo', ;
   nombre   :r:30:h = 'Nombre'   nomodify noappend nodelete 
release window b_depar

if used("depar")
   select depar
   use
endif

pop key
