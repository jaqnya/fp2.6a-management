CLEAR ALL
CLEAR

SET DELETED ON
SET CENTURY ON
SET DATE BRITISH

CREATE CURSOR lista (codigo C(15), nombre C(40), operacion C(20), fecha D(8), entrada N(5), salida N(5))

USE maesprod IN 0 SHARED
USE cabevent IN 0 SHARED
USE detavent IN 0 SHARED
USE cabemovi IN 0 SHARED
USE detamovi IN 0 SHARED

SELECT cabevent
SCAN FOR fechadocu >= CTOD("21/10/2010")
   lnTipoDocu = tipodocu
   lnNroDocu = nrodocu
   
   SELECT detavent
   SET ORDER TO 1
   IF SEEK(STR(lnTipoDocu, 1) + STR(lnNroDocu, 7)) THEN
      SCAN WHILE tipodocu = lnTipoDocu AND nrodocu = lnNroDocu
         IF INLIST(articulo, "783", "6364", "6682") THEN
            INSERT INTO lista (codigo, operacion, fecha, salida) VALUES (detavent.articulo, "Venta: " + ALLTRIM(STR(lnTipoDocu)) + "/" + ALLTRIM(STR(lnNroDocu)), cabevent.fechadocu, detavent.cantidad)
         ENDIF
      ENDSCAN
   ELSE
      WAIT "La venta: " + ALLTRIM(STR(lnTipoDocu)) + "/" + ALLTRIM(STR(lnNroDocu)) + " no existe." WINDOW
   ENDIF
ENDSCAN

SELECT cabemovi
SCAN FOR fecha >= CTOD("21/10/2010")
   lnTipoBole = tipobole
   lnNroBole = nrobole
   
   SELECT detamovi
   SET ORDER TO 1
   IF SEEK(STR(lnTipoBole, 1) + STR(lnNroBole, 7)) THEN
      SCAN WHILE tipobole = lnTipoBole AND nrobole = lnNroBole
         IF INLIST(articulo, "783", "6364", "6682") THEN
            IF INLIST(lnTipoBole, 1, 3) THEN && Entrada
               INSERT INTO lista (codigo, operacion, fecha, entrada) VALUES (detamovi.articulo, "Entrada: " + ALLTRIM(STR(lnTipoBole)) + "/" + ALLTRIM(STR(lnNroBole)), cabemovi.fecha, detamovi.cantidad)
            ENDIF
            IF INLIST(lnTipoBole, 2, 4) THEN && Salida
               INSERT INTO lista (codigo, operacion, fecha, salida) VALUES (detamovi.articulo, "Salida: " + ALLTRIM(STR(lnTipoBole)) + "/" + ALLTRIM(STR(lnNroBole)), cabemovi.fecha, detamovi.cantidad)
            ENDIF
         ENDIF
      ENDSCAN
   ELSE
      WAIT "El ajuste: " + ALLTRIM(STR(lnTipoBole)) + "/" + ALLTRIM(STR(lnNroBole)) + " no existe." WINDOW
   ENDIF
ENDSCAN

SELECT lista
SCAN ALL
   SELECT maesprod
   SET ORDER TO 1
   IF SEEK(lista.codigo) THEN
      SELECT lista
      REPLACE nombre WITH maesprod.nombre
   ELSE
      WAIT "El articulo: " + ALLTRIM(lista.codigo) + " no existe."
   ENDIF
ENDSCAN

SELECT lista
INDEX ON codigo + DTOS(fecha) TAG indice1
browse
