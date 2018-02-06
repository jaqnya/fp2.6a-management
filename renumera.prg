clear all
clear

j = 1026198

use cabevent shared

for i = 2404525 to 2404553
   select cabevent
   set order to 1

   if seek("7" + str(i, 7)) then
      do cambnro with 7, i, j
      ? "do cambnro with 7" + str(i, 7) + " de " + str(j, 7)
   else
      if seek("8" + str(i, 7)) then
         do cambnro with 8, i, j
         ? "do cambnro with 8" + str(i, 7) + " de " + str(j, 7)
      else
         wait "error" window
      endif
   endif
   ? str(i, 7) + " " + str(j, 7)
   ? "do cambnro with " + str(i, 7) + " de " + str(j, 7)
   j = j + 1
endfor