CLEAR
CLEAR ALL

SET DATE      BRITISH
SET DELETED   ON
SET CENTURY   ON
SET EXCLUSIVE ON
SET SAFETY    OFF
SET TALK      OFF

USE z:\turtle\aya\integrad.000\maespmix IN 0 EXCLUSIVE
USE z:\turtle\aya\integrad.000\maesprod IN 0 SHARED ALIAS maespcen
USE z:\turtle\aya\integrad.001\maesprod IN 0 SHARED ALIAS maespdep

SELECT maespmix
ZAP

SELECT maespcen
SET ORDER TO 2
SCAN ALL
   SCATTER MEMVAR MEMO

   m.stock_actu = m.stock_actu - m.stock_ot
   m.stock_ot   = 0

   SELECT maespdep
   SET ORDER TO 1
   IF SEEK(m.codigo) THEN
      m.stock_act2 = stock_actu - stock_ot
      m.stock_ot2  = 0
   ELSE
      WAIT "El articulo: " + ALLTRIM(m.codigo) + " - " + ALLTRIM(m.nombre) + CHR(13) + "no ha sido encontrado en el DEPOSITO." WINDOW
      STORE 0 TO m.stock_act2, m.stock_ot2
   ENDIF

   m.stock = m.stock_actu + m.stock_act2

   INSERT INTO maespmix FROM MEMVAR
ENDSCAN

SELECT maespcen
USE

SELECT maespdep
USE

SELECT maespmix
USE

*/------------------------------------------------------------------------/*

*   2 - STIHL 
*   3 - HUSQVARNA
*   8 - RAISMAN 
*  18 - FRENOBRAS
*  19 - OREGON
*  21 - MEGAVILLE
*  47 - VEDAMOTORS
*  48 - ELKO
*  50 - AIP
*  63 - ITECE
*  95 - AÇOTECNICA
* 409 - GASSEN
* 430 - CASTOR
* 455 - GRILON
* 459 - KNB
* 461 - CABER
* 464 - DUNLOP
* 465 - AILYN
* 467 - PLATT
* 471 - SIVERST
* 476 - ESPEL
* 478 - CIRCUIT
* 479 - ATHENA
* 491 - STINGER
* 492 - TOUGH

* RUBROS {MOTOS}
*   8 - LINEA NAUTICA
*   9 - MOTOS REPUESTOS Y ACCESORIOS

USE z:\turtle\aya\integrad.000\maespmix IN 0 EXCLUSIVE
USE z:\turtle\aya\integrad.000\marcas1 IN 0 SHARED

SELECT m.codigo, m.codorig, m.codigo2, m.nombre, m.pventag1, m.pventag2, m.pventag3, m.pventag4, m.pventag5, m.pventad1, m.pventad2, m.pventad3, m.pventad4, m.pventad5, m.pimpuesto, m2.nombre AS marca, stock_actu AS stock_cen, stock_act2 AS stock_dep, stock;
   FROM maespmix m, marcas1 m2 ;
   WHERE m.marca = m2.codigo ;
      AND INLIST(m.marca, 63) ;
      AND m.rubro <> 2 ;
   ORDER BY m2.nombre, m.nombre ;
   INTO TABLE tmpartic
*!*	      AND (m.stock_actu - m.stock_ot) > 0 ;


SELECT maespmix
USE

SELECT marcas1
USE

SELECT tmpartic
   
INDEX ON nombre TAG nombre
BROWSE
*!*	REPORT FORM ventag3a PREVIEW      && without grouping
*!*	REPORT FORM ventag3a TO PRINTER   && without grouping
EXPORT TO c:\datos TYPE XL5