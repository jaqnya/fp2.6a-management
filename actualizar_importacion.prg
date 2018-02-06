*/-- Advertencia: Si ocurre cualquier error el programa se detendrá inmediatamente --*/
CLEAR ALL
CLEAR

SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON
SET EXACT   ON

*/-- Datos de la Factura Comercial --*/
lnTipoDocu = 2
lnNroDocu = 12211
lnProveedor = 22
lnImporte = 34803.00

USE maesprod IN 0 SHARED
USE cabecomp IN 0 SHARED
USE detacomp IN 0 SHARED
USE cuotas_c IN 0 SHARED
USE familias IN 0 SHARED
USE c:\datos IN 0 EXCLUSIVE

SELECT cabecomp
LOCATE FOR tipodocu = lnTipoDocu AND nrodocu = lnNroDocu AND proveedor = lnProveedor
IF FOUND() THEN
   REPLACE tipocambio WITH 1
   REPLACE monto_fact WITH lnImporte
ELSE
   WAIT "La compra: " + STR(lnTipoDocu, 1) + "/" + ALLTRIM(STR(lnNroDocu, 9)) + " del proveedor: " + ALLTRIM(STR(lnProveedor, 5)) + " no existe." WINDOW
   RETURN 0
ENDIF

SELECT cuotas_c
LOCATE FOR tipodocu = lnTipoDocu AND nrodocu = lnNroDocu AND proveedor = lnProveedor
IF FOUND() THEN
   REPLACE importe WITH lnImporte
ENDIF

SELECT detacomp
SET ORDER TO 1
IF SEEK(STR(lnTipoDocu, 1) + STR(lnNroDocu, 9) + STR(lnProveedor, 5)) THEN
   SCAN FOR tipodocu = lnTipoDocu AND nrodocu = lnNroDocu AND proveedor = lnProveedor
      lcCodigo = articulo
      SELECT datos
      LOCATE FOR codigo = lcCodigo
      IF FOUND() THEN
         SELECT detacomp
         REPLACE precio WITH datos.precio
      ELSE
         WAIT "El producto: '" + lcCodigo + "' no existe en la tabla 'datos'." WINDOW
      ENDIF
   ENDSCAN
ELSE
   WAIT "La compra: " + STR(lnTipoDocu, 1) + "/" + ALLTRIM(STR(lnNroDocu, 9)) + " del proveedor: " + ALLTRIM(STR(lnProveedor, 5)) + " no existe." WINDOW
   RETURN 0
ENDIF

SELECT datos
SCAN ALL
   lcCodigo = codigo
   lnPCostoG = pcostog
   lnPCostoD = pcostod

   SELECT maesprod
   SET ORDER TO 1
   IF SEEK(lcCodigo) THEN
      lnFamilia = familia

      SELECT familias
      SET ORDER TO 1
      IF SEEK(lnFamilia) THEN
         lnPVentaD1 = IIF(p1 > 0, ROUND(lnPCostoD * (1 + (p1 / 100)), 4), 0)
         lnPVentaD2 = IIF(p2 > 0, ROUND(lnPCostoD * (1 + (p2 / 100)), 4), 0)
         lnPVentaD3 = IIF(p3 > 0, ROUND(lnPCostoD * (1 + (p3 / 100)), 4), 0)
         lnPVentaD4 = IIF(p4 > 0, ROUND(lnPCostoD * (1 + (p4 / 100)), 4), 0)
         lnPVentaD5 = IIF(p5 > 0, ROUND(lnPCostoD * (1 + (p5 / 100)), 4), 0)
      ELSE
         WAIT "La familia: " + ALLTRIM(STR(lnFamilia)) + " no existe." WINDOW
         RETURN 0
      ENDIF

      SELECT maesprod
      REPLACE pcostog WITH lnPCostoG,;
              pcostod WITH lnPCostoD,;
              pventad1 WITH lnPVentaD1,;
              pventad2 WITH lnPVentaD2,;
              pventad3 WITH lnPVentaD3,;
              pventad4 WITH lnPVentaD4,;
              pventad5 WITH lnPVentaD5
   ELSE
      WAIT "El producto: '" + lcCodigo + "' no existe." WINDOW
      RETURN 0
   ENDIF
ENDSCAN