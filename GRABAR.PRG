SELECT cabecomp
INSERT INTO cabecomp (tipodocu, nrodocu, fechadocu, proveedor, porcdesc, importdesc, monto_fact, monto_ndeb, monto_ncre, monto_pago, importac) ;
   VALUES (m.tipodocu, m.nrodocu, m.fechadocu, m.proveedor, m.porcdesc, m.importdesc, m.monto_fact, 0, 0, 0, "N")
SELECT tmpdetcomp
GO TOP
SCAN
   INSERT INTO detacomp (tipodocu, nrodocu, proveedor, articulo, cantidad, precio, impuesto, pimpuesto, serie) ;
      VALUES (m.tipodocu, m.nrodocu, m.proveedor, tmpdetcomp.articulo, tmpdetcomp.cantidad, tmpdetcomp.precio, tmpdetcomp.impuesto, tmpdetcomp.pimpuesto, "")
ENDSCAN
SELECT cuotas_c
FOR pnCounter = 1 TO ALEN(paQtyCuota)
   INSERT INTO cuotas_c (tipodocu, nrodocu, proveedor, tipo, nrocuota, fecha, importe, abonado, monto_ndeb, monto_ncre) ;
      VALUES (m.tipodocu, m.nrodocu, m.proveedor, 2, VAL(SUBSTR(paQtyCuota[pnCounter], 1, 3), VAL(SUBSTR(paQtyCuota[pnCounter], 7, 10), VAL(SUBSTR(paQtyCuota[pnCounter], 20, 11), 0, 0, 0)
ENDFOR
      