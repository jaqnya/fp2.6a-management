*
* verificar_facturacion_ot.prg
* 
* Derechos Reservados (c) 2000-2009 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
* 
* Descripcion:
* Verifica la integridad referencial del estado de las ordenes de
* trabajo
*
* Historial de Modificacion:
* Julio 08, 2009   Jose Avilio Acuna Acosta   Creador del Programa
*
CLEAR
CLOSE DATABASES

SET CENTURY   ON
SET DATE      BRITISH
SET DELETED   ON
SET ESCAPE    OFF
SET EXCLUSIVE OFF
SET SAFETY    OFF
SET TALK      OFF
*-----------------------------------------------------------------------------*
SELECT;
   a.tipodocu,;
   a.nrodocu,;
   a.fechadocu,;
   a.serie,;
   a.nroot,;
   b.estadoot,;
   c.nombre;
FROM;
   cabevent a;
   INNER JOIN ot b;
      ON a.serie = b.serie AND;
         a.nroot = b.nroot;
   INNER JOIN estadoot c;
      ON b.estadoot = c.codigo;
WHERE;
   !EMPTY(a.nroot) AND;
   b.estadoot <> 6;
INTO CURSOR;
   tm_ventas

SELECT tm_ventas
SCAN ALL
   ? "** El estado de la OT " + serie + "-" + ALLTRIM(STR(nroot)) + " es " + ALLTRIM(STR(estadoot)) + " - " + ALLTRIM(nombre) FONT "Courier New", 9
   ? "   Pero ya ha sido facturada con el documento " + ALLTRIM(STR(tipodocu)) + "/" + ALLTRIM(STR(nrodocu)) + " del " + DTOC(fechadocu) FONT "Courier New", 9
   ?
ENDSCAN
*-----------------------------------------------------------------------------*
WAIT CLEAR
CLOSE DATABASES
MESSAGEBOX("Finalizó la revisión.", 0+64, "Aviso")