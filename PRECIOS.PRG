SET TALK OFF
USE DETACOMP

m.total = 0
m.sec = seconds()
SCAN FOR articulo = "JOSE"
      m.total = m.total + precio   
   ENDIF
ENDSCAN

? m.total
? seconds() - m.sec

SELECT 0
temp01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
CREATE TABLE &temp01 (precio     N(13,4) ,;
                      desc_linea N(07,4) ,;
                      desc_factu N(07,4))

USE &temp01 ALIAS tmpdetcomp EXCLUSIVE
INDEX ON STR(tipodocu, 1) + STR(nrodocu, 9) + STR(proveedor, 5) TAG indice1
SET RELATION TO tmpdetcomp.articulo INTO maesprod ADDITIVE
