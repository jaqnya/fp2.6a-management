SET CENTURY   ON
SET DATE      BRITISH
SET DELETED   ON
SET EXCLUSIVE OFF
SET SAFETY    OFF

CLOSE DATABASES

USE cabevent IN 0
USE clientes IN 0
USE cabecob  IN 0

SELECT * ;
   FROM cabevent ;
   WHERE cabevent.cliente = 189 ;
     AND INLIST(cabevent.tipodocu, 2, 8) ;
   INTO TABLE 1

SELECT * ;
   FROM cabecob ;
   WHERE cabecob.cliente = 189 ;
     AND cabecob.tiporeci = 1 ;
   INTO TABLE 2

SELECT * ;
   FROM cabenotc ;
   WHERE cabenotc.cliente = 189 ;
     AND INLIST(cabenotc.tipodocu, 2, 8) ;
     AND cabenotc.aplicontra = 2 ;
   INTO TABLE 3

CLOSE DATABASES

USE 1 IN 0 ALIAS tabla1
USE 2 IN 0 ALIAS tabla2
USE 3 IN 0 ALIAS tabla3

SELECT 1 
INDEX ON DTOS(fechadocu) TAG fechadocu

SELECT 2
INDEX ON DTOS(fechareci) TAG fechareci

SELECT 3
INDEX ON DTOS(fechanota) TAG fechanota

SELECT 0 
CREATE TABLE extracto ;
  (documento C(30),;
   fechadocu D(8),;
   debito    N(9),;
   credito   N(9),;
   saldo     N(9))

USE extracto 

SELECT 1
SCAN ALL
   SELECT extracto
   APPEND BLANK
   IF INLIST(tabla1.tipodocu, 2, 8) THEN
      REPLACE documento WITH "FACT.CREDITO No.: " + ALLTRIM(TRANSFORM(tabla1.nrodocu, "999,999,999"))
      REPLACE fechadocu WITH tabla1.fechadocu
      REPLACE debito    WITH tabla1.monto_fact
   ENDIF
ENDSCAN

SELECT 2
SCAN ALL
   SELECT extracto
   APPEND BLANK
   IF tabla2.tiporeci = 1 THEN
      REPLACE documento WITH "REC.DE COBRO No.: " + ALLTRIM(TRANSFORM(tabla2.nroreci, "999,999,999"))
      REPLACE fechadocu WITH tabla2.fechareci
      REPLACE credito   WITH tabla2.monto_cobr
   ENDIF
ENDSCAN
   
SELECT 3
SCAN ALL
   SELECT extracto
   APPEND BLANK
   IF tabla3.tiponota = 2 AND INLIST(tabla3.tipodocu, 2, 8) THEN
      REPLACE documento WITH "NOTA CREDITO No.: " + ALLTRIM(TRANSFORM(tabla3.nronota, "999,999,999"))
      REPLACE fechadocu with tabla3.fechanota
      REPLACE credito   WITH tabla3.monto_nota
   ENDIF
ENDSCAN   
     
SELECT extracto
INDEX ON DTOS(fechadocu) TAG fechadocu

EXPORT TO extracto TYPE XLS