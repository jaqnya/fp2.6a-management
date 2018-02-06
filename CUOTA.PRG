CLEAR
SET CENTURY ON
SET DATE BRITISH
SET TALK OFF

m.monto_fact  = 1300000
pnQtyCuotas   = 1
pnEntrInicial = 15
m.fechadocu   = DTOC(DATE())
pnInterval    = 30

? "monto: " +  str(m.monto_fact)
? "ei     " + str(pnentrinicial)
IF pnEntrInicial > 0
   DIMENSION paQtyCuota[pnQtyCuotas + 1]
ELSE
   DIMENSION paQtyCuota[pnQtyCuotas]
ENDIF

FOR pnCounter = 1 TO (pnQtyCuotas + IIF(pnEntrInicial = 0, 0, 1))
   IF pnEntrInicial > 0 .AND. pnCounter = 1
      paQtyCuota[pnCounter] = STR(pnCounter, 3) + " ³ " + DTOC(CTOD(m.fechadocu)) + " ³ " + TRANSFORM(pnEntrInicial, "999,999,999")
   ELSE
      IF pnCounter = (pnQtyCuotas + IIF(pnEntrInicial = 0, 0, 1))
         paQtyCuota[pnCounter] = STR(pnCounter, 3) + " ³ " + DTOC(CTOD(m.fechadocu) + (pnInterval * (pnCounter + IIF(pnEntrInicial = 0, 0, -1)))) + " ³ " + TRANSFORM(m.monto_fact - pnEntrInicial - (INT((m.monto_fact - pnEntrInicial) / pnQtyCuotas) * (pnQtyCuotas - 1)), "999,999,999")
      ELSE
         paQtyCuota[pnCounter] = STR(pnCounter, 3) + " ³ " + DTOC(CTOD(m.fechadocu) + (pnInterval * (pnCounter + IIF(pnEntrInicial = 0, 0, -1)))) + " ³ " + TRANSFORM(INT((m.monto_fact - pnEntrInicial) / pnQtyCuotas), "999,999,999")
      ENDIF
   ENDIF
? paQtyCuota[pnCounter]
ENDFOR
