procedure saveval
parameters cStoreTo, cNewVal, lIsTable
if parameters() < 3
   wait window "NO SE HAN PASADO SUFICIENTES PARAMETROS"
   return .f.
endif

if lIsTable
   replace (cStoreTo) with (cNewVal)
else
   &cStoreTo = cNewVal
endif
return .t.


