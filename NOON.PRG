USE respaldo
SCATTER MEMVAR

SET CENTURY OFF
SET DATE    ITALIAN
SET CONSOLE ON

m.origen  = ALLTRIM(m.origen)
m.destino = ALLTRIM(m.destino)

*-- Copia todos los archivos *.DBF al directorio destino --*
STORE "RUN copy " + m.origen + "*.dbf " + m.destino + "tmp\" TO cRun
&cRun

*-- Copia todos los archivos *.FPT al directorio destino --*
STORE "RUN copy " + m.origen + "*.fpt " + m.destino + "tmp\" TO cRun
&cRun

*-- Elimina todos los archivos TMP*.* --*
STORE "RUN del " + m.destino + "tmp\" + "tm*.*" TO cRun
&cRun

*-- Comprime los datos con el programa PKZIP --*
STORE "RUN pkzip " + m.destino + "2\" + DTOC(DATE()) + ".zip -ex " + m.destino + "tmp\" + "*.*" TO cRun
&cRun

*-- Elimina todos los archivos *.DBF --*
STORE "RUN del " + m.destino + "tmp\" + "*.dbf" TO cRun
&cRun

*-- Elimina todos los archivos *.FPT --*
STORE "RUN del " + m.destino + "tmp\" + "*.fpt" TO cRun
&cRun