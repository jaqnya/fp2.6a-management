DO seteo

USE cabevent IN 0 SHARED
USE detavent IN 0 SHARED

SELECT * FROM cabevent a, detavent b WHERE a.tipodocu = b.tipodocu AND BETWEEN(a.fechadocu, CTOD("01/01/2012"), CTOD("16/01/2012")) AND b.articulo = "6550"