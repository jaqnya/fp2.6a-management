SET DATE ITALIAN
SET CENTURY OFF

STORE DTOC(DATE()) TO today	&& save today's date
STORE "RUN pkzip " + ALLTRIM(LOWER(control.directory)) + "\respaldo\" + today + ".zip -ex *.dbf" TO HDD_Backup

? HDD_Backup

*   RUN pkzip a:datos.zip -& *.TXT

