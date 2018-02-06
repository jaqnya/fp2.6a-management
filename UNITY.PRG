*-- Compras.
SELECT cabecomp
SET ORDER TO TAG indice1 OF cabecomp.cdx

SELECT detacomp
SET ORDER TO TAG indice1 OF detacomp.cdx

GO TOP

SCAN ALL
   SELECT cabecomp
   
   IF SEEK(STR(detacomp.tipodocu, 1) + STR(detacomp.nrodocu, 9) + STR(detacomp.proveedor, 5))
      nCounter = 0
      SCAN WHILE STR(cabecomp.tipodocu, 1) + STR(cabecomp.nrodocu, 9) + STR(cabecomp.proveedor, 5) = STR(detacomp.tipodocu, 1) + STR(detacomp.nrodocu, 9) + STR(detacomp.proveedor, 5)
         nCounter = nCounter + 1
      ENDSCAN
      IF nCounter > 1
         WAIT WINDOW STR(detacomp.tipodocu, 1) + STR(detacomp.nrodocu, 9) + STR(detacomp.proveedor, 5) + " ENCABEZADO DUPLICADO"
      ENDIF
   ELSE
      WAIT WINDOW STR(detacomp.tipodocu, 1) + STR(detacomp.nrodocu, 9) + STR(detacomp.proveedor, 5) + " NOT FOUND"
   ENDIF
   
   SELECT detacomp
ENDSCAN

*-- Ventas.
SELECT cabevent
SET ORDER TO TAG indice1 OF cabevent.cdx

SELECT detavent
SET ORDER TO TAG indice1 OF detavent.cdx

GO TOP

SCAN ALL
   SELECT cabevent
   
   IF SEEK(STR(detavent.tipodocu, 1) + STR(detavent.nrodocu, 7))
      nCounter = 0
      SCAN WHILE STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7) = STR(detavent.tipodocu, 1) + STR(detavent.nrodocu, 7)
         nCounter = nCounter + 1
      ENDSCAN
      IF nCounter > 1
         WAIT WINDOW STR(detavent.tipodocu, 1) + STR(detavent.nrodocu, 7) + " ENCABEZADO DUPLICADO"
      ENDIF
   ELSE
      WAIT WINDOW STR(detavent.tipodocu, 1) + STR(detavent.nrodocu, 7) + " NOT FOUND"
   ENDIF
   
   SELECT detavent
ENDSCAN

*-- Notas de credito proveedores
SELECT cabenotp
SET ORDER TO TAG indice1 OF cabenotp.cdx

SELECT detanotp
SET ORDER TO TAG indice1 OF detanotp.cdx

GO TOP

SCAN ALL
   SELECT cabenotp
   
   IF SEEK(STR(detanotp.tiponota, 1) + STR(detanotp.nronota, 9) + STR(detanotp.proveedor, 5))
      nCounter = 0
      SCAN WHILE STR(cabenotp.tiponota, 1) + STR(cabenotp.nronota, 9) + STR(cabenotp.proveedor, 5) = STR(detanotp.tiponota, 1) + STR(detanotp.nronota, 9) + STR(detanotp.proveedor, 5)
         nCounter = nCounter + 1
      ENDSCAN
      IF nCounter > 1
         WAIT WINDOW STR(detanotp.tiponota, 1) + STR(detanotp.nronota, 9) + STR(detanotp.proveedor, 5) + " ENCABEZADO DUPLICADO"
      ENDIF
   ELSE
      WAIT WINDOW STR(detanotp.tiponota, 1) + STR(detanotp.nronota, 9) + STR(detanotp.proveedor, 5) + " NOT FOUND"
   ENDIF
   
   SELECT detanotp
ENDSCAN

*-- Notas de credito de clientes
SELECT cabenotc
SET ORDER TO TAG indice1 OF cabenotc.cdx

SELECT detanotc
SET ORDER TO TAG indice1 OF detanotc.cdx

GO TOP

SCAN ALL
   SELECT cabenotc
   
   IF SEEK(STR(detanotc.tiponota, 1) + STR(detanotc.nronota, 7))
      nCounter = 0
      SCAN WHILE STR(cabenotc.tiponota, 1) + STR(cabenotc.nronota, 7) = STR(detanotc.tiponota, 1) + STR(detanotc.nronota, 7)
         nCounter = nCounter + 1
      ENDSCAN
      IF nCounter > 1
         WAIT WINDOW STR(detanotc.tiponota, 1) + STR(detanotc.nronota, 7) + " ENCABEZADO DUPLICADO"
      ENDIF
   ELSE
      WAIT WINDOW STR(detanotc.tiponota, 1) + STR(detanotc.nronota, 7) + " NOT FOUND"
   ENDIF
   
   SELECT detanotc
ENDSCAN

*-- Movimientos de deposito
SELECT cabemovi
SET ORDER TO TAG indice1 OF cabemovi.cdx

SELECT detamovi
SET ORDER TO TAG indice1 OF detamovi.cdx

GO TOP

SCAN ALL
   SELECT cabemovi
   
   IF SEEK(STR(detamovi.tipobole, 1) + STR(detamovi.nrobole, 7))
      nCounter = 0
      SCAN WHILE STR(cabemovi.tipobole, 1) + STR(cabemovi.nrobole, 7) = STR(detamovi.tipobole, 1) + STR(detamovi.nrobole, 7)
         nCounter = nCounter + 1
      ENDSCAN
      IF nCounter > 1
         WAIT WINDOW STR(detamovi.tipobole, 1) + STR(detamovi.nrobole, 7) + " ENCABEZADO DUPLICADO"
      ENDIF
   ELSE
      WAIT WINDOW STR(detamovi.tipobole, 1) + STR(detamovi.nrobole, 7) + " NOT FOUND"
   ENDIF
   
   SELECT detamovi
ENDSCAN
