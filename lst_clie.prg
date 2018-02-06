CLEAR ALL
CLEAR

SET DELETED   ON
SET DATE      BRITISH 
SET CENTURY   ON
SET EXCLUSIVE OFF
SET EXACT     ON

SELECT;
   a.nombre,;
   a.contacto,;
   a.telefono,;
   a.direc1 AS direccion,;
   a.ruta AS id_ruta,;
   b.nombre AS ruta;
FROM;
   clientes a,;
   ruta b;
WHERE;
   a.ruta = b.id_ruta AND;
   INLIST(ruta, 3);
ORDER BY;
   5, 1

   
REPORT FORM lst_clie PREVIEW 
*REPORT FORM lst_clie TO PRINTER NOCONSOLE