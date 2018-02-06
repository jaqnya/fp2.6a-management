SELECT maesprod.nombre, ;
  SUM(detavent.precio * detavent.cantidad) ;
  FROM maesprod, detavent ;
  WHERE maesprod.codigo = detavent.articulo ;
  GROUP BY maesprod.nombre ;
  ORDER BY 2 DESC