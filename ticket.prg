init_prn = CHR(27)+CHR(64)

condensed_on  = CHR(27)+CHR(15)
condensed_off = CHR(27)+CHR(14)

bold_on  = CHR(27)+CHR(69)
bold_off = CHR(27)+CHR(70)

underline_on  = CHR(27)+CHR(45)+CHR(1)
underline_off = CHR(27)+CHR(45)+CHR(0)

italic_on  = CHR(27)+CHR(52)
italic_off = CHR(27)+CHR(53)

op1 = CHR(27)+CHR(64)+CHR(27)+CHR(73)+CHR(0)+CHR(27)+CHR(33)+CHR(1) && GRANDE
op2 = CHR(27)+CHR(64)+CHR(27)+CHR(73)+CHR(0)+CHR(27)+CHR(33)+CHR(4) && GRANDE+


SET DEVICE TO FILE tmpx86.txt
@ ROW(), COL() SAY op1
@ 00, 00 SAY CHR(27)+CHR(69)+" A & A IMPORTACIONES S.R.L. " +CHR(27)+CHR(70)

*!*	@ 00, 00 SAY init_prn + bold_on + "PRONET S.A." + bold_off
*!*	@ 00, 00 SAY init_prn + italic_on + "PRONET S.A." + italic_off
*!*	@ 01, 00 SAY "RUC: PROA9885904             TEL: 444545"
*!*	@ 02, 00 SAY "ASUNCION                PDTE. FRANCO 173"
*!*	@ 03, 00 SAY "Terminal Fecha    Hora  Nro.Orden Pago"
*!*	@ 04, 00 SAY "----------------------------------------"
*!*	@ 05, 00 SAY ""

SET DEVICE TO SCREEN
MODIFY COMMAND tmpx86.txt
! copy tmpx86.txt prn
RETURN


TEXT TO cTicket NOSHOW
                    PRONET S.A.
RUC: PROA9885904             TEL: 444545
ASUNCION                PDTE. FRANCO 173
Terminal Fecha    Hora  Nro.Orden Pago
01900121 09/08/10 13:48 04100131285
----------------------------------------
97 - SET, Pago de Impuestos,
Contribuyente : 666357,
MEZA FOSTER ELVIRA BEATRIZ
Impuesto: 211, IVA GENERAL
Cajero: 13, VICTORJ
Nro.Consecutivo: 79
Importe: 1.186.725 Gs.
Hash: 87d8089d
----------------------------------------
---ESTE ES SU COMPROBANTE, CONSERVELO---
---PAGO POR ORDEN Y CUENTA DEL EMISOR---
"AQUI PAGO" - UN SERVICIO DE PRONET S.A.
ENDTEXT

STRTOFILE(cTicket, "tmpx86.txt", 0)
? cTicket
! copy tmpx86.txt prn