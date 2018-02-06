PARAMETERS mfecha1, mfecha2, m.destino, m.totalizar, mmecanico

WAIT "AGUARDE UN MOMENTO, PROCESANDO..." WINDOW NOWAIT

* Lista de mecanicos purete este es el que funciona loco.

*!*   CLEAR ALL
*!*   CLEAR

*!*   SET CENTURY ON
*!*   SET DATE BRITISH
*!*   SET DELETED ON

*!*   mfecha1 = CTOD("01/10/2006")
*!*   mfecha2 = CTOD("31/10/2006")

*!*	   Descripcion del proceso:
*!*	   ------------------------
*!*	   1. Se crea la tabla 'repair' el cual contendra la lista de las reparaciones realizadas 
*!*	      en un rango de fecha.
*!*	   2. Se procesa la tabla 'repair' para sumar los repuestos.
*!*	      2.1 Busca en la tabla 'ot', si encuentra
*!*	      2.2 Busca en la tabla 'cabemot', si encuentra
*!*	      2.3 Busca en la tabla 'detamot', si encuentra
*!*	      2.4 Escanea todo el detalle y realiza la suma correspondiente.
*!*	   3. Se procesa la tabla 'repair' para sumar los servicios.
*!*	      3.1 Idem punto 2  
   
IF !USED("cabemot") THEN
   USE cabemot IN 0 SHARED
ENDIF

IF !USED("detamot") THEN
   USE detamot IN 0 SHARED
ENDIF

IF !USED("ot") THEN
   USE ot IN 0 SHARED
ENDIF

IF !USED("mecanico") THEN
   USE mecanico IN 0 SHARED
ENDIF

IF !USED("cabevent") THEN
   USE cabevent IN 0 SHARED
ENDIF

IF !USED("detavent") THEN
   USE detavent IN 0 SHARED
ENDIF

archi_01 = "tm" + RIGHT(SYS(3), 6)

CREATE TABLE &archi_01 ;
  (mecanico   N(5),;
   mec_nombre C(30),;
   fechadocu  D(8),;
   documento  C(15),;
   repuestos  N(9),;
   comi_repu  N(9),;
   servicios  N(9),;
   comi_serv  N(9),;
   otros      N(9))
USE 
USE &archi_01 IN 0 ALIAS infmecan
INDEX ON mec_nombre + DTOS(fechadocu) + documento TAG indice1
   
archi_02 = "tm" + RIGHT(SYS(3), 5)
SELECT DISTINCT c.tipobole, c.serie, c.nrobole, c.fecha ;
   FROM cabemot c, detamot d ;
   WHERE c.tipobole  = d.tipobole ;
     AND c.serie     = d.serie ;
     AND c.nrobole   = d.nrobole ;
     AND BETWEEN(c.fecha, mfecha1, mfecha2) ;
   ORDER BY c.fecha ;
   INTO TABLE &archi_02

USE
USE &archi_02 IN 0 ALIAS repair

SELECT ot
SET ORDER TO 1

SELECT cabemot 
SET ORDER TO 1

SELECT detamot
SET ORDER TO 1

SELECT mecanico
SET ORDER TO 1

* Calcula el importe de repuestos.
SELECT repair
SCAN ALL
   SELECT ot
   IF SEEK(repair.serie + STR(repair.nrobole, 7)) THEN
      SELECT cabemot
      IF SEEK("2" + ot.serie + STR(ot.nroot, 7)) THEN
         SELECT detamot
         IF SEEK(STR(cabemot.tipobole, 1) + cabemot.serie + STR(cabemot.nrobole, 7)) THEN
            STORE 0 TO m.repuestos, m.comi_repu, m.servicios, m.comi_serv, m.otros, m.total_linea
            SCAN WHILE cabemot.tipobole = tipobole .AND. cabemot.serie = serie .AND. cabemot.nrobole = nrobole
               m.total_linea = ROUND(precio * cantidad, 0)
               IF !INLIST(articulo, "99010", "99011", "99012", "99013", "99014", "99020", "99021", "99022", "10001", "99001", "99002", "99003") THEN
                  m.repuestos = m.repuestos + m.total_linea
               ENDIF
            ENDSCAN

            SELECT mecanico
            LOCATE FOR codigo = ot.mecanico
            
            IF FOUND() THEN
               m.porc_comi  = ROUND(pcomisrpto / 100, 3)
               m.mec_nombre = mecanico.nombre
            ELSE
               m.porc_comi  = 0
               m.mec_nombre = ""
            ENDIF
            
            m.repuestos = m.repuestos - cabemot.importdesc
            m.comi_repu = ROUND(m.repuestos * m.porc_comi, 0)
            m.mecanico  = ot.mecanico
            m.fechadocu = cabemot.fecha
            m.documento = "OT  " +  cabemot.serie + STR(cabemot.nrobole, 7)
            
            INSERT INTO infmecan VALUES (m.mecanico, m.mec_nombre, m.fechadocu, m.documento, m.repuestos, m.comi_repu, m.servicios, m.comi_serv, m.otros)
         ENDIF
      ENDIF
   ENDIF
ENDSCAN

* Calcula el importe de servicios propios y de terceros.
SELECT repair
SCAN ALL
   SELECT ot
   IF SEEK(repair.serie + STR(repair.nrobole, 7)) THEN
      SELECT cabemot
      IF SEEK("2" + ot.serie + STR(ot.nroot, 7)) THEN
         SELECT detamot
         IF SEEK(STR(cabemot.tipobole, 1) + cabemot.serie + STR(cabemot.nrobole, 7)) THEN
            SCAN WHILE cabemot.tipobole = tipobole .AND. cabemot.serie = serie .AND. cabemot.nrobole = nrobole
               STORE 0 TO m.repuestos, m.comi_repu, m.servicios, m.comi_serv, m.otros, m.total_linea
               m.total_linea = ROUND(precio * cantidad, 0)
               DO CASE
                  CASE INLIST(articulo, "99010", "99011", "99012", "99013", "99014", "99020", "99021", "99022")
                     m.servicios = m.servicios + m.total_linea
                     DO CASE
                        CASE articulo = "99010"
                           m.porc_comi = 0.15
                        CASE articulo = "99011" 
                           m.porc_comi = 0.30
                        CASE articulo = "99012" 
                           m.porc_comi = 0.40                                                   
                        CASE articulo = "99013" 
                           m.porc_comi = 0.50                                                   
                        CASE INLIST(articulo, "99014", "99020", "99021", "99022")
                           m.porc_comi = 0.65
                     ENDCASE
                     m.comi_serv = m.comi_serv + ROUND(m.total_linea * m.porc_comi, 0)
                  CASE INLIST(articulo, "10001", "99001", "99002", "99003")
                     m.otros = m.otros + m.total_linea
               ENDCASE
               
               IF m.servicios > 0 .OR. m.otros > 0 THEN
                  SELECT infmecan
                  LOCATE FOR documento = "OT  " + cabemot.serie + STR(cabemot.nrobole, 7) .AND. mecanico = detamot.mecanico
               
                  IF FOUND() THEN
                     REPLACE servicios WITH (servicios + m.servicios)
                     REPLACE comi_serv WITH (comi_serv + m.comi_serv)
                     REPLACE otros     WITH (otros + m.otros)
                  ELSE
                     SELECT mecanico
                     LOCATE FOR codigo = detamot.mecanico
            
                     IF FOUND() THEN
                        m.mec_nombre = mecanico.nombre
                     ELSE
                        m.mec_nombre = ""
                     ENDIF

                     m.mecanico  = detamot.mecanico
                     m.fechadocu = cabemot.fecha
                     m.documento = "OT  " + cabemot.serie + STR(cabemot.nrobole, 7)
                  
                     INSERT INTO infmecan VALUES (m.mecanico, m.mec_nombre, m.fechadocu, m.documento, m.repuestos, m.comi_repu, m.servicios, m.comi_serv, m.otros)
                  ENDIF
               ENDIF
            ENDSCAN
         ENDIF
      ENDIF
   ENDIF
ENDSCAN

archi_03 = "tm" + RIGHT(SYS(3), 5)
SELECT DISTINCT c.tipodocu, c.nrodocu, c.fechadocu ;
   FROM cabevent c, detavent d ;
   WHERE c.tipodocu  = d.tipodocu ;
     AND c.nrodocu   = d.nrodocu ;
     AND BETWEEN(c.fechadocu, mfecha1, mfecha2) ;
     AND INLIST(articulo, "99010", "99011", "99012", "99013", "99014", "99020", "99021", "99022", "10001", "99001", "99002", "99003") ;
     AND EMPTY(c.nroot) ;
   ORDER BY c.fechadocu ;
   INTO TABLE &archi_03

USE
USE &archi_03 IN 0 ALIAS repair2

SELECT cabevent
SET ORDER TO 1

SELECT detavent
SET ORDER TO 1

* Calcula el importe de repuestos
SELECT repair2
SCAN ALL
   SELECT cabevent
   IF SEEK(STR(repair2.tipodocu, 1) + STR(repair2.nrodocu, 7)) THEN
      SELECT detavent
      IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)) THEN
         STORE 0 TO m.repuestos, m.comi_repu, m.servicios, m.comi_serv, m.otros, m.total_linea
         SCAN WHILE cabevent.tipodocu = tipodocu .AND. cabevent.nrodocu = nrodocu
            m.total_linea = ROUND(precio * cantidad, 0)
            IF !INLIST(articulo, "99010", "99011", "99012", "99013", "99014", "99020", "99021", "99022", "10001", "99001", "99002", "99003") THEN
               m.repuestos = m.repuestos + m.total_linea
            ENDIF
         ENDSCAN

         m.mecanico   = 0
         m.mec_nombre = ""
         m.repuestos  = m.repuestos - IIF(INLIST(cabevent.tipodocu, 3, 7, 8), cabevent.importdesc / 1.1, cabevent.importdesc)
         m.fechadocu  = cabevent.fechadocu
         m.documento  = IIF(INLIST(cabevent.tipodocu, 1, 3, 4, 5, 7), "FCON ", "FCRE ") + STR(cabevent.nrodocu, 7)
            
         INSERT INTO infmecan VALUES (m.mecanico, m.mec_nombre, m.fechadocu, m.documento, m.repuestos, m.comi_repu, m.servicios, m.comi_serv, m.otros)
      ENDIF
   ENDIF
ENDSCAN

* Calcula el importe de servicios propios y de terceros.
SELECT repair2
SCAN ALL
   SELECT cabevent
   IF SEEK(STR(repair2.tipodocu, 1) + STR(repair2.nrodocu, 7)) THEN
      SELECT detavent
      IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7)) THEN
         SCAN WHILE cabevent.tipodocu = tipodocu .AND. cabevent.nrodocu = nrodocu
            STORE 0 TO m.repuestos, m.comi_repu, m.servicios, m.comi_serv, m.otros, m.total_linea
            m.total_linea = ROUND(precio * cantidad, 0)
            DO CASE
               CASE INLIST(articulo, "99010", "99011", "99012", "99013", "99014", "99020", "99021", "99022")
                  m.servicios = m.servicios + m.total_linea
                  DO CASE
                     CASE articulo = "99010"
                        m.porc_comi = 0.15
                     CASE articulo = "99011" 
                        m.porc_comi = 0.30
                     CASE articulo = "99012" 
                        m.porc_comi = 0.40                                                   
                     CASE articulo = "99013" 
                        m.porc_comi = 0.50                                                   
                     CASE INLIST(articulo, "99014", "99020", "99021", "99022")
                        m.porc_comi = 0.65
                  ENDCASE
                  m.comi_serv = m.comi_serv + ROUND(m.total_linea * m.porc_comi, 0)
               CASE INLIST(articulo, "10001", "99001", "99002", "99003")
                  m.otros = m.otros + m.total_linea
            ENDCASE
               
            IF m.servicios > 0 .OR. m.otros > 0 THEN
               SELECT infmecan
               LOCATE FOR documento = IIF(INLIST(cabevent.tipodocu, 1, 3, 4, 5, 7), "FCON ", "FCRE ") + STR(cabevent.nrodocu, 7) &&.AND. mecanico = detamot.mecanico
               
               IF FOUND() THEN
                  SELECT mecanico
                  LOCATE FOR codigo = detavent.mecanico
            
                  IF FOUND() THEN
                     m.mec_nombre = mecanico.nombre
                  ELSE
                     m.mec_nombre = ""
                  ENDIF

                  SELECT infmecan

                  REPLACE mecanico   WITH detavent.mecanico
                  REPLACE mec_nombre WITH m.mec_nombre
                  REPLACE servicios  WITH (servicios + m.servicios)
                  REPLACE comi_serv  WITH (comi_serv + m.comi_serv)
                  REPLACE otros      WITH (otros + m.otros)
               ELSE
                  WAIT WINDOW "no encon" 
               ENDIF
            ENDIF
         ENDSCAN
      ENDIF
   ENDIF
ENDSCAN

SELECT infmecan
SCAN ALL
   SELECT mecanico
   LOCATE FOR codigo = infmecan.mecanico
   
   IF FOUND() THEN
      m.porc_comi  = ROUND(pcomisrpto / 100, 3)
   ELSE
      m.porc_comi  = 0
   ENDIF
            
   SELECT infmecan
   REPLACE comi_repu WITH ROUND(repuestos * m.porc_comi, 0)
ENDSCAN

WAIT CLEAR

SELECT infmecan
IF m.destino = "P" .AND. m.totalizar = "N" THEN
   archi_04 = "tm" + RIGHT(SYS(3), 6) + ".txt"

   IF mmecanico = -1 THEN
      REPORT FORM infmecan TO &archi_04 NOCONSOLE
   ELSE
      REPORT FORM infmecan TO &archi_04 NOCONSOLE FOR mecanico = mmecanico      
   ENDIF

   DO lister.prg WITH (archi_04)
   DELETE FILE &archi_04
ENDIF

IF m.destino = "P" .AND. m.totalizar = "S" THEN
   archi_04 = "tm" + RIGHT(SYS(3), 6) + ".txt"

   IF mmecanico = -1 THEN
      REPORT FORM infmeca2 TO &archi_04 NOCONSOLE
   ELSE
      REPORT FORM infmeca2 TO &archi_04 NOCONSOLE FOR mecanico = mmecanico      
   ENDIF

   DO lister.prg WITH (archi_04)
   DELETE FILE &archi_04
ENDIF

IF m.destino = "I" .AND. m.totalizar = "N" THEN
   IF mmecanico = -1 THEN
      REPORT FORM infmecan TO PRINTER NOCONSOLE
   ELSE
      REPORT FORM infmecan TO PRINTER NOCONSOLE FOR mecanico = mmecanico      
   ENDIF
ENDIF

IF m.destino = "I" .AND. m.totalizar = "S" THEN
   IF mmecanico = -1 THEN
      REPORT FORM infmeca2 TO PRINTER NOCONSOLE
   ELSE
      REPORT FORM infmeca2 TO PRINTER NOCONSOLE FOR mecanico = mmecanico      
   ENDIF

ENDIF

SELECT infmecan
USE
DELETE FILE archi_01 + ".dbf"
DELETE FILE archi_01 + ".cdx"

SELECT repair
USE
DELETE FILE archi_02 + ".dbf"

SELECT repair2
USE
DELETE FILE archi_03 + ".dbf"

SELECT maesprod