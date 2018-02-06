SELECT maesprod.nombre, ;
  SUM(detavent.cantidad), ;
  SUM(detavent.precio * detavent.cantidad) ;
  FROM maesprod, cabevent, detavent ;
  WHERE maesprod.codigo = detavent.articulo AND ;
  cabevent.tipodocu = detavent.tipodocu AND ;
  cabevent.nrodocu  = detavent.nrodocu AND;
  cabevent.fechadocu BETWEEN CTOD("01/01/2005") AND CTOD("03/01/2005");
  GROUP BY maesprod.nombre ;
  ORDER BY 2 DESC