CLEAR
CLEAR ALL

SET CENTURY ON
SET DATE BRITISH
SET DELETED ON
SET EXACT ON

USE cabecomp IN 0 SHARED
USE c:\datos IN 0 SHARED

LOCAL n_contador, n_tipodocu, n_nrodocu, n_proveedor, n_monto_fact, n_tipocambio

n_contador = 1

SELECT datos
SCAN ALL
   WAIT "Procesando... " + ALLTRIM(STR(n_contador)) + "/" + ALLTRIM(STR(RECCOUNT())) WINDOW NOWAIT
   n_tipodocu   = tipodocu
   n_nrodocu    = nrodocu
   n_proveedor  = proveedor
   n_monto_fact = monto_fact
   n_tipocambio = tipocambio

   SELECT cabecomp
   LOCATE FOR tipodocu = n_tipodocu AND nrodocu = n_nrodocu AND proveedor = n_proveedor AND monto_fact = n_monto_fact
   IF FOUND() THEN
      REPLACE tipocambio WITH n_tipocambio
   ELSE
      MESSAGEBOX("La compra: " + ALLTRIM(STR(n_tipodocu)) + "/" + ALLTRIM(STR(n_nrodocu)) + "/" + ALLTRIM(STR(n_proveedor)) + ", no existe", 0+48, "Registro no encontrado")
   ENDIF

   n_contador = n_contador + 1
ENDSCAN

WAIT CLEAR

MESSAGEBOX("Se han procesado: " + ALLTRIM(STR(n_contador - 1)) + " registros.", 0+48, "Resultado")

*SELECT tipodocu, nrodocu, fechadocu, ROUND(monto_fact * tipocambio, 0) FROM cabecomp WHERE proveedor = 2 AND BETWEEN(fechadocu, CTOD("01/01/2011"), CTOD("30/09/2011"))
*SELECT SUM(ROUND(monto_fact * tipocambio, 0)) FROM cabecomp WHERE proveedor = 2 AND BETWEEN(fechadocu, CTOD("01/01/2011"), CTOD("30/09/2011"))