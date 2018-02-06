push key clear
do case
   case order() == "INDICE1"
      do arbusc01.spr
      pop key
   case order() == "INDICE2"
      do arbusc02.spr
      pop key
   case order() == "INDICE6"
      do arbusc03.spr
      pop key
   case order() == "INDICE7"
      do arbusc04.spr
      pop key
endcase