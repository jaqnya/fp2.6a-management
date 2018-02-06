clear
set talk off
set point to ','
set separator to '.'
store 0 to n_cuota_constante, n_valor_actual_CV, n_tasa_interes, n_tiempo, n_nro_capitalizaciones, n_saldo_actual, n_monto_interes, n_amortizacion, n_suma_amortizacion, n_suma_monto_interes

@ 01,01 say 'Valor Actual de la Deuda: ' get n_valor_actual_CV  picture '99,999,999'
@ 02,01 say 'Tiempo..................: ' get n_tiempo           picture '9,999'
@ 03,01 say 'Tasa de Inter‚s Mensual.: ' get n_tasa_interes     picture '9,999.999'
read
clear
n_cuota_constante = round(((((1+(n_tasa_interes/100))^n_tiempo)*(n_tasa_interes/100)*n_valor_actual_CV)/(((1+(n_tasa_interes/100))^n_tiempo)-1)),0)
? ' CUADRO DE AMORTIZACIONES O TABLA DEL SERVICIO DE LA DEUDA'
? ' ========================================================='
? '                  *** SISTEMA FRANCES ***'
?
? 'Cuota Constante..........: ' + transform(n_cuota_constante, '9,999,999')
?
n_saldo_actual = n_valor_actual_CV

for contador_tiempo = 1 to n_tiempo - 1 
   n_monto_interes     = round((n_saldo_actual*(n_tasa_interes/100)),0)
   n_amortizacion      = n_cuota_constante -  n_monto_interes
   ? transform(contador_tiempo, '99,999,999') +  ' '  + transform(n_saldo_actual, '99,999,999') + ' ' + transform(n_cuota_constante, '99,999,999') + ' ' + transform(n_monto_interes, '99,999,999') + ' ' + transform(n_amortizacion, '99,999,999')
   n_saldo_actual      = n_saldo_actual - n_amortizacion
   n_suma_amortizacion = n_suma_amortizacion + n_amortizacion
   n_suma_monto_interes = n_suma_monto_interes + n_monto_interes
endfor

n_amortizacion      = n_saldo_actual
n_monto_interes     = n_cuota_constante - n_amortizacion
n_suma_amortizacion = n_suma_amortizacion + n_amortizacion
n_suma_monto_interes = n_suma_monto_interes + n_monto_interes

? transform(contador_tiempo, '99,999,999') +  ' '  + transform(n_saldo_actual, '99,999,999') + ' ' + transform(n_cuota_constante, '99,999,999') + ' ' + transform(n_monto_interes, '99,999,999') + ' ' + transform(n_amortizacion, '99,999,999')
?
? 'Suma Total Amortizaciones: ' + transform(n_suma_amortizacion, '99,999,999') 
? 'Suma Total Intereses.....: ' + transform(n_suma_monto_intereses, '99,999,999') 
? 'Suma Total de Cuotas.....: ' + transform((n_cuota_constante_CV * n_tiempo), '99,999,999') 
