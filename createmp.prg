*
* createmp.prg
*
* Derechos Reservados (c) 2000-2008 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0985) 943-522 o (0961) 512-679
*
* Descripcion:
* Devuelve un nombre de archivo valido que puede ser utilizado para crear
* archivos temporales
*
* Historial de Modificacion:
* Setiembre 21, 2008	Jose Avilio Acuna Acosta	Creador del Programa
*
PRIVATE lcReturn

DO WHILE .T.
   lcReturn = "tm" + RIGHT(SYS(2015), 6)
   IF !FILE(lcReturn + ".dbf") AND !FILE(lcReturn + ".cdx") AND !FILE(lcReturn + ".txt") AND !FILE(lcReturn + ".xls") THEN
      EXIT
   ENDIF
ENDDO

RETURN (lcReturn)