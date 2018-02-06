*-- Establece el entorno de trabajo --*
CLEAR
CLOSE DATABASES

SET TALK OFF
SET ESCAPE OFF
SET DELETED ON

*-- Apertura de archivos --*
SELECT 0
USE cabevent.dbf SHARED
SET ORDER TO TAG indice1 OF cabevent.cdx

SELECT 0 
USE detavent.dbf SHARED
SET ORDER TO TAG indice1 OF detavent.cdx

SELECT 0 
USE maesprod.dbf SHARED
SET ORDER TO TAG indice1 OF maesprod.cdx

SELECT detavent 
SET RELATION TO detavent.articulo INTO maesprod

*-- Inicializacion de variables --*
STORE 0 TO nMaq, nMerc, nTaller, nMO, nGrav, nExe, nImp, nTot
nIVA = 10          
           
FacStartType = 1
FacStart     = 9751
FacEndType   = 1
FacEnd       = 9760 
TotalFact    = 0

*-- Rutina principal --*
SELECT cabevent
SET ORDER TO TAG indice1 OF cabevent.cdx

IF SEEK(STR(FacStartType, 1) + STR(FacStart, 7))
   DO WHILE STR(tipodocu, 1) + STR(nrodocu, 7) <= STR(FacEndType, 1) + STR(FacEnd, 7) .AND. .NOT. EOF()
      DO CalcDetail
      SELECT cabevent
      TotalFact = TotalFact + monto_fact
      SKIP
   ENDDO
ELSE
   WAIT WINDOW "EL NRO DE INICIO NO FUE ENCONTRADO."
ENDIF

CLOSE DATABASES

WAIT WINDOW TRANSFORM(totalfact, "999,999,999") NOWAIT

@ 14,10 SAY "M quina:" ;
   SIZE 1,11 ;
   PICTURE "@" ;
   COLOR BG+/B

@ 15,10 SAY nMaq ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR W+/BG+

@ 16,10 SAY nMerc ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR W+/BG+

@ 17,10 SAY nTaller ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR W+/BG+

@ 18,10 SAY nMO ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR W+/BG+

@ 19,10 SAY nGrav ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR W+/BG+
                     
@ 20,10 SAY nExe ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR W+/BG+

@ 21,10 SAY nImp ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR W+/BG+

@ 22,10 SAY nTot  ;
   SIZE 1,11 ;
   PICTURE "999,999,999" ;
   COLOR W+/BG+

**-----------------------------------------------------------****
* SHOWFOOT - Imprime el pie del documento.                      *
****-----------------------------------------------------------**
PROCEDURE CalcDetail

STORE 0 TO m.monto_fact, nGravada, nExenta, nImpuesto, nSubTotal, ;
           nDescGrav, nDescExen, nSubTota1

m.porcdesc   = cabevent.porcdesc
m.importdesc = cabevent.importdesc

SELECT detavent  
SET ORDER TO TAG indice1 OF detavent.cdx

IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
   SCAN WHILE STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7) == STR(tipodocu, 1) + STR(nrodocu, 7)
      DO CASE
         CASE impuesto .AND. pimpuesto > 0 .AND. pimpuesto < 10
            nGravada = nGravada + ROUND(precio * cantidad, 0) * (pimpuesto * (nIVA / 100))
            nExenta  = nExenta  + ROUND(precio * cantidad, 0) * (1 - (pimpuesto * (nIVA / 100)))
         CASE impuesto .AND. pimpuesto = nIVA
            nGravada = nGravada + ROUND(precio * cantidad, 0)            
         CASE .NOT. impuesto .AND. pimpuesto = 0
            nExenta  = nExenta  + ROUND(precio * cantidad, 0)
      ENDCASE
   ENDSCAN

   nSubTotal = nGravada + nExenta
  
   IF m.importdesc > 0 .AND. m.porcdesc = 0
      nDescGrav    = ROUND(m.importdesc * ROUND(nGravada * 100 / nSubTotal, 0) / 100, 0)
      nDescExen    = m.importdesc - nDescGrav
      nSubTota1    = nSubTotal - m.importdesc
      nImpuesto    = ROUND((nGravada - nDescGrav) * (nIVA / 100), 0)
      m.monto_fact = nSubTota1 + nImpuesto
      m.descuento  = ROUND(m.importdesc / nSubTotal * 100, 4)
   ELSE
      IF m.porcdesc > 0
         nDescGrav    = ROUND((nGravada * (m.porcdesc / 100)), 0)
         nDescExen    = ROUND((nGravada + nExenta) * (m.porcdesc / 100), 0) - nDescGrav
         m.importdesc = nDescGrav + nDescExen
         nSubTota1    = (nGravada + nExenta) - (nDescGrav + nDescExen)
         nImpuesto    = ROUND(ROUND(nGravada * (1 - m.porcdesc / 100), 0) * (nIVA / 100), 0)
         m.monto_fact = nSubTota1 + nImpuesto
      ELSE
         IF m.importdesc = 0 .AND. m.porcdesc = 0
            nImpuesto    = ROUND(nGravada * (nIVA / 100), 0)
            m.monto_fact = nSubTotal + nImpuesto
         ENDIF
      ENDIF
   ENDIF

   nGrav = nGrav + (nGravada - nDescGrav)
   nExe  = nExe  + (nExenta  - nDescExen)
   nTot  = nTot  + m.monto_fact
ENDIF