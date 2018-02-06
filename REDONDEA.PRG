CLEAR ALL

USE maesprod SHARED
GO TOP

SCAN ALL
   IF pventag1 > 0
      m.pventag1 = ROUND(pventag1, 0)
      IF RIGHT(STR(m.pventag1), 2) > "00" .AND. ;
         RIGHT(STR(m.pventag1), 2) < "50"
         m.pventag1 = (m.pventag1 - VAL(RIGHT(STR(m.pventag1), 2)) + 50)
      ELSE
         IF RIGHT(STR(m.pventag1), 2) <= "99" .AND. ;
            RIGHT(STR(m.pventag1), 2) > "50"
            m.pventag1 = (m.pventag1 - VAL(RIGHT(STR(m.pventag1), 2)) + 100)
         ENDIF
      ENDIF
    
      REPLACE pventag1 WITH ROUND(m.pventag1, 0)
   ENDIF
ENDSCAN        