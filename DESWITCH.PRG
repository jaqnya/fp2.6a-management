push key clear

if eof()
   do depwarn2.spr
   pop key
   return
endif

do case
   case order() == "INDICE1"
      do debusc01.spr
      pop key
   case order() == "INDICE2"
      do debusc02.spr
      pop key
endcase