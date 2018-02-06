SELECT maesprod.codigo, maesprod.nombre, SUM(detacomp.cantidad) ;
  FROM maesprod, cabecomp, detacomp ;
  WHERE (cabecomp.tipodocu = detacomp.tipodocu .AND. cabecomp.nrodocu = detacomp.nrodocu .AND. cabecomp.proveedor = detacomp.proveedor)