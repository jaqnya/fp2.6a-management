PARAMETER m.tipodocu, m.nrodocu, m.nrodocu2, m.fechadocu

CLEAR 
CLOSE DATABASES

USE cabevent.dbf SHARED
SET ORDER TO TAG indice1 OF cabevent.cdx
SET TALK OFF
SET ESCAPE OFF
SET DELETED ON
SET CENTURY ON
SET DATE BRITISH

*m.tipodocu   = 7
*m.nrodocu    = 27301
*m.nrodocu2   = 27316
m.monto_fact = 0
*m.fechadocu  = CTOD("07/11/2006")

IF SEEK(STR(m.tipodocu, 1) + STR(m.nrodocu, 7)) THEN
   DO WHILE STR(tipodocu, 1) + STR(nrodocu, 7) <= STR(m.tipodocu, 1) + STR(m.nrodocu2, 7) .AND. .NOT. EOF()
      IF moneda = 1 THEN
         m.monto_fact = m.monto_fact + monto_fact
         IF importdesc > 0 .OR. porcdesc > 0 THEN
            ?  tipodocu
            ?? nrodocu
            ?? importdesc
            ?? porcdesc
         ENDIF
      ELSE
*        m.monto_fact = m.monto_fact + ROUND(monto_fact * tipocambio, 0)
      ENDIF

      IF cabevent.fechadocu <> m.fechadocu THEN
         IF !cabevent.anulado THEN
            ? nrodocu
            ?? monto_fact
            ?? moneda
            ?? tipocambio
         ELSE
            IF cabevent.fechaanu <> m.fechadocu THEN
               ? nrodocu
               ?? monto_fact
               ?? moneda
               ?? tipocambio
            ENDIF
         ENDIF
      ENDIF
         
      SKIP
   ENDDO
ELSE
   WAIT WINDOW "EL NRO DE INICIO NO FUE ENCONTRADO."
ENDIF
CLOSE DATABASES      

? "---------REPORTE DEL PROCESO---------"
? "Tipo de Documento : " + ALLTRIM(STR(m.tipodocu))
? "Factura Inicial # : " + ALLTRIM(TRANSFORM(m.nrodocu, "9,999,999"))
? "Factura Final   # : " + ALLTRIM(TRANSFORM(m.nrodocu2, "9,999,999"))
? "                   -------------"                  
? "SUMA DEL CONJUNTO : " + ALLTRIM(TRANSFORM(m.monto_fact, "999,999,999"))
? "                   ============="                  
WAIT WINDOW TRANSFORM(m.monto_fact, "999,999,999") NOWAIT

CLEAR ALL