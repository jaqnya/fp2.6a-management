CLEAR
CLEAR ALL
CLOSE ALL

SET CENTURY ON
SET DATE BRITISH
SET DELETED ON
SET EXACT   ON
SET TALK    OFF

USE cabecomp IN 0 SHARED
USE detacomp IN 0 SHARED
USE cuotas_c IN 0 SHARED

USE cabevent IN 0 SHARED
USE detavent IN 0 SHARED
USE cuotas_v IN 0 SHARED

USE cabenotp IN 0 SHARED
USE detanotp IN 0 SHARED
USE cuotas_p

USE cabenotc IN 0 SHARED
USE detanotc IN 0 SHARED
USE cuotas_n IN 0 SHARED

USE cabepag IN 0 SHARED
USE detapag IN 0 SHARED

USE cabecob IN 0 SHARED
USE detacob IN 0 SHARED

USE cabemovi IN 0 SHARED
USE detamovi IN 0 SHARED

USE cabemot IN 0 SHARED
USE detamot IN 0 SHARED

*n_anyo = 2012

* procesa las compras.
SELECT tipodocu, nrodocu, proveedor FROM cabecomp WHERE YEAR(fechadocu) = n_anyo INTO CURSOR tm_query

SELECT tm_query
SCAN ALL
   n_tipodocu = tipodocu
   n_nrodocu = nrodocu
   n_proveedor = proveedor

   SELECT cabecomp
   DELETE FOR tipodocu = n_tipodocu AND nrodocu = n_nrodocu AND proveedor = n_proveedor

   SELECT detacomp
   DELETE FOR tipodocu = n_tipodocu AND nrodocu = n_nrodocu AND proveedor = n_proveedor
   
   SELECT cuotas_c
   DELETE FOR tipodocu = n_tipodocu AND nrodocu = n_nrodocu AND proveedor = n_proveedor
ENDSCAN

* procesa las ventas.
SELECT tipodocu, nrodocu FROM cabevent WHERE YEAR(fechadocu) = n_anyo INTO CURSOR tm_query

SELECT tm_query
SCAN ALL
   n_tipodocu = tipodocu
   n_nrodocu = nrodocu

   SELECT cabevent
   DELETE FOR tipodocu = n_tipodocu AND nrodocu = n_nrodocu

   SELECT detavent
   DELETE FOR tipodocu = n_tipodocu AND nrodocu = n_nrodocu
   
   SELECT cuotas_v
   DELETE FOR tipodocu = n_tipodocu AND nrodocu = n_nrodocu
ENDSCAN

* procesa las devoluciones a proveedores.
SELECT tiponota, nronota, proveedor FROM cabenotp WHERE YEAR(fechanota) = n_anyo INTO CURSOR tm_query

SELECT tm_query
SCAN ALL
   n_tiponota = tiponota
   n_nronota = nronota
   n_proveedor = proveedor

   SELECT cabenotp
   DELETE FOR tiponota = n_tiponota AND nronota = n_nronota AND proveedor = n_proveedor

   SELECT detanotp
   DELETE FOR tiponota = n_tiponota AND nronota = n_nronota AND proveedor = n_proveedor
   
   SELECT cuotas_p
   DELETE FOR tiponota = n_tiponota AND nronota = n_nronota AND proveedor = n_proveedor
ENDSCAN

* procesa las devoluciones de clientes.
SELECT tiponota, nronota FROM cabenotc WHERE YEAR(fechanota) = n_anyo INTO CURSOR tm_query

SELECT tm_query
SCAN ALL
   n_tiponota = tiponota
   n_nronota = nronota

   SELECT cabenotc
   DELETE FOR tiponota = n_tiponota AND nronota = n_nronota

   SELECT detanotc
   DELETE FOR tiponota = n_tiponota AND nronota = n_nronota
   
   SELECT cuotas_n
   DELETE FOR tiponota = n_tiponota AND nronota = n_nronota
ENDSCAN

* procesa los pagos a proveedores.
SELECT tiporeci, nroreci, proveedor FROM cabepag WHERE YEAR(fechareci) = n_anyo INTO CURSOR tm_query

SELECT tm_query
SCAN ALL
   n_tiporeci = tiporeci
   n_nroreci = nroreci
   n_proveedor = proveedor

   SELECT cabepag
   DELETE FOR tiporeci = n_tiporeci AND nroreci = n_nroreci AND proveedor = n_proveedor

   SELECT detapag
   DELETE FOR tiporeci = n_tiporeci AND nroreci = n_nroreci AND proveedor = n_proveedor
ENDSCAN

* procesa los cobros a clientes.
SELECT tiporeci, nroreci FROM cabecob WHERE YEAR(fechareci) = n_anyo INTO CURSOR tm_query

SELECT tm_query
SCAN ALL
   n_tiporeci = tiporeci
   n_nroreci = nroreci

   SELECT cabecob
   DELETE FOR tiporeci = n_tiporeci AND nroreci = n_nroreci

   SELECT detacob
   DELETE FOR tiporeci = n_tiporeci AND nroreci = n_nroreci
ENDSCAN

* procesa los ajustes de inventario.
SELECT tipobole, nrobole FROM cabemovi WHERE YEAR(fecha) = n_anyo INTO CURSOR tm_query

SELECT tm_query
SCAN ALL
   n_tipobole = tipobole
   n_nrobole = nrobole

   SELECT cabemovi
   DELETE FOR tipobole = n_tipobole AND nrobole = n_nrobole

   SELECT detamovi
   DELETE FOR tipobole = n_tipobole AND nrobole = n_nrobole
ENDSCAN

* procesa las reparaciones del taller.
SELECT tipobole, nrobole FROM cabemot WHERE YEAR(fecha) = n_anyo INTO CURSOR tm_query

SELECT tm_query
SCAN ALL
   n_tipobole = tipobole
   n_nrobole = nrobole

   SELECT cabemot
   DELETE FOR tipobole = n_tipobole AND nrobole = n_nrobole

   SELECT detamot
   DELETE FOR tipobole = n_tipobole AND nrobole = n_nrobole
ENDSCAN