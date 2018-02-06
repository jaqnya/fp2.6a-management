set escape off
set notify off
set bell off

SELECT 0
USE FAMILIAS 

SELECT 0
use maesprod
scatter memvar blank


*m.vigente  = iif(m.vigente,  "S", "N")
*m.lprecio  = iif(m.lprecio,  "S", "N")
*m.impuesto = iif(m.impuesto, "G", "E")

m.vigente  = "S"
m.lprecio  = "S"
m.impuesto = "G"
m.adding   = .t.
m.next     = 0
m.prior    = 1
m.cancel   = 0

do while .t.
   if m.next = 1
      do articu02.spr
      if m.cancel = 1
         exit do
      endif
   endif
   if m.prior = 1
      do articu01.spr
   endif
   if m.cancel = 1
      exit do
   endif
enddo
set escape on
set notify on
set bell on
CLOSE DATA
