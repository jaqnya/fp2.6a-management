CLOSE DATABASES

* Base de datos, ¡ndices, relaciones.
IF FILE("maesprod.dbf")
   IF USED("maesprod")
      SELECT maesprod
      SET ORDER TO TAG indice6
   ELSE
      SELECT 0
      USE (LOCFILE("maesprod.dbf", "DBF", "¨ D¢nde est  MAESPROD.DBF ?")) ;
         AGAIN ALIAS maesprod SHARED ;
         ORDER TAG indice6
   ENDIF
   
   SELECT 0    
   USE (LOCFILE("maesprod.dbf", "DBF", "¨ D¢nde est  MAESPROD.DBF ?")) ;
      AGAIN ALIAS maesprod2 SHARED ;
      ORDER TAG indice6
ELSE
   RETURN
ENDIF   

SELECT 0
temp01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp01 (codigo     C(15) ,;
                      codigo2    C(15) ,;
                      codorig    C(15) ,;
                      nombre     C(40) ,;
                      duplicado  N(04))

USE &temp01 ALIAS temporal EXCLUSIVE
INDEX ON codigo  TAG indice1
INDEX ON codigo2 TAG indice2
INDEX ON codorig TAG indice3
INDEX ON nombre  TAG indice4

SELECT maesprod

SCAN 
   * Inicializaci¢n de variables.
   cCodigo2 = maesprod.codigo2
   nFound   = 0
      
   IF .NOT. EMPTY(cCodigo2)
      SELECT maesprod2

      IF SEEK(maesprod.codigo2)
         SCAN WHILE maesprod2.codigo2 = cCodigo2
            nFound = nFound + 1
         ENDSCAN
      ENDIF   

      IF nFound > 1
*        WAIT WINDOW "CODIGO ORIGEN: " + ALLTRIM(cCodorig) + "     DUPLICADO: " + ALLTRIM(STR(nFound - 1, 5))
         INSERT INTO temporal (codigo, codigo2, codorig, nombre, duplicado) ;
            VALUES (maesprod.codigo, maesprod.codigo2, maesprod.codorig, maesprod.nombre, nFound)
      ENDIF
   
      SELECT maesprod
   ENDIF
ENDSCAN

SELECT temporal
SET ORDER TO TAG indice2
LIST OFF codigo, codigo2, nombre, duplicado
BROWSE FIELDS codigo, codigo2, nombre, duplicado

IF USED("temporal")
   SELECT temporal
   USE
ENDIF

DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"
