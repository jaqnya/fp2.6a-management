CLEAR ALL
SET CENTURY   ON
SET DATE      BRITISH
SET DELETED   ON
SET EXCLUSIVE OFF
SET SAFETY    OFF

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

USE control

m.cambio = control.tipocambi1

SELECT m.codigo, m.codorig, m.codigo2, m.nombre, m.pventag1, m.pventag2, m.pventag3, m.pventag4, m.pventag5, m.pventad1, m.pventad2, m.pventad3, m.pventad4, m.pventad5, m.pimpuesto, m2.nombre AS marca ;
   FROM maesprod m, marcas1 m2 ;
   WHERE m.marca = m2.codigo ;
      AND m.proveedor = 77 ;
   ORDER BY m2.nombre, m.nombre ;
   INTO TABLE pventag3


*      AND INLIST(m.rubro, 8, 9) ;   MOTOS


*    AND INLIST(m.marca, 471,479,21,47,478) ;
*    AND m.rubro <> 2 ;
*    AND INLIST(m.marca, 8,18,47,48,50,63,95,409,430,455,459,461,464,465,467,471,3,2,417,102) and m.rubro <> 2 ;
*    AND INLIST(m.marca, 8,18,47,48,50,63,95,409,430,455,459,461,464,465,467,471,3,2,417,102) and m.rubro <> 2 ;
*    AND INLIST(m.marca, 8,18,47,48,50,63,95,409,430,455,459,461,464,465,467,471) ;
*    AND (m.marca = 471 .OR. m.marca = 464 or (m.marca = 47 and m.rubro = 9)) ;
*    AND (m.stock_actu - m.stock_ot) > 0 ;
*    AND !INLIST(m.codigo, "10001", "99001", "99002", "99003", "99010", "99011", "99012", "99013", "99014", "99015", "99016", "99020", "99021", "99022") ;

SELECT pventag3
   
*REPORT FORM pv_dani PREVIEW 
*REPORT FORM pv_dani TO PRINTER

*DELETE FOR pventag1 <= 0
*REPORT FORM pv_dan2 PREVIEW      && Lista de Precios N§ 1 + 10%
*REPORT FORM pv_dan2 TO PRINTER   && Lista de Precios N§ 1 + 10%

*REPORT FORM venta3 PREVIEW 
*REPORT FORM venta3 TO PRINTER

*REPORT FORM ventag3 PREVIEW      && mas utilizado
*REPORT FORM ventag3 TO PRINTER   && mas utilizado

*INDEX ON nombre TAG nombre
*REPORT FORM ventag3a PREVIEW      && without grouping
*REPORT FORM ventag3a TO PRINTER   && without grouping

*INDEX ON nombre TAG nombre
*REPORT FORM ventag4a PREVIEW      && without grouping
*REPORT FORM ventag4a TO PRINTER   && without grouping

****INDEX ON nombre TAG nombre        && values in US$ list 4 or 3 only
****REPORT FORM ventag4b FOR pventad3 > 0 OR pventad4 <> 0 PREVIEW      && without grouping
****REPORT FORM ventag4b FOR pventad3 > 0 OR pventad4 <> 0 TO PRINTER   && without grouping

*INDEX ON nombre TAG nombre        && Codigo Original
*REPORT FORM ventag3b PREVIEW      && without grouping
*REPORT FORM ventag3b TO PRINTER   && without grouping


*INDEX ON nombre TAG nombre        && Codigo Alternativo
*REPORT FORM ventag3c PREVIEW      && without grouping
*REPORT FORM ventag3c TO PRINTER   && without grouping

*REPORT FORM ventag4 PREVIEW    && Trae el codigo alternativo
*REPORT FORM ventag4 TO PRINTER  && Trae el codigo alternativo

*REPORT FORM ventag4a PREVIEW    && Trae el codigo alternativo y lista 1, 3
*REPORT FORM ventag4a TO PRINTER  && Trae el codigo alternativo y list 1, 3

*REPORT FORM pventag4 PREVIEW
*REPORT FORM pventag4 TO PRINTER

REPORT FORM ventad1 PREVIEW
REPORT FORM ventad1 TO PRINTER

REPORT FORM ventad3 PREVIEW 
REPORT FORM ventad3 TO PRINTER


*REPORT FORM ventad4 PREVIEW 
*REPORT FORM ventad4 TO PRINTER

*REPORT FORM pventad3 PREVIEW 
*REPORT FORM pventad3 TO PRINTER
*REPORT FORM pventad3 TO FILE raisman.txt

*REPORT FORM pventad4 PREVIEW 
*REPORT FORM pventad4 TO PRINTER

*REPORT FORM pventag3 PREVIEW 
*REPORT FORM pventag3 TO PRINTER
*REPORT FORM pventag3 TO FILE listado.txt

*export TO my_list TYPE XLS
