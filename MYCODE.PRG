PRIVATE cSetTalk, cSetCentury, cSetCompatible, cSetDate, cSetDeleted, cSetNotify, cSetSafety, cMacros, nSelect
STORE "" TO cSetTalk, cSetCentury, cSetCompatible, cSetDate, cSetDeleted, cSetNotify, cSetSafety, cMacros, nSelect


DO environment WITH "ON"
DO environment WITH "off"

PROCEDURE environment
PARAMETER cStatus

   IF (UPPER(ALLTRIM(cStatus)) = "ON")
      IF (SET("TALK") = "ON")
         SET TALK OFF
         cSetTalk = "ON"
      ELSE
         cSetTalk = "OFF"
      ENDIF

      IF (SET("CENTURY") = "OFF")
         SET CENTURY ON 
         cSetCentury = "OFF"
      ELSE
         cSetCentury = "ON"
      ENDIF

      cSetCompatible = SET("COMPATIBLE")
      SET COMPATIBLE FOXPLUS

      IF (SET("DATE") <> "BRITISH")
         cSetDate = SET("DATE")
         SET DATE BRITISH
      ELSE
         cSetDate = "BRITISH"
      ENDIF

      IF (SET("DELETED") = "OFF")
         SET DELETED ON
         cSetDeleted = "OFF"
      ELSE
         cSetDeleted = "ON"
      ENDIF

      IF (SET("NOTIFY") = "ON")
         SET NOTIFY OFF
         cSetNotify = "ON"
      ELSE
         cSetNotify = "OFF"
      ENDIF

      IF (SET("SAFETY") = "ON")
         SET SAFETY OFF
         cSetSafety = "ON"
      ELSE
         cSetSafety = "OFF"
      ENDIF
      
      cMacros = "tm" + RIGHT(SYS(3), 6) + ".fky"
      SAVE MACROS TO &cMacros
      CLEAR MACROS
      
      nSelect = SELECT()
   ELSE
      IF (UPPER(ALLTRIM(cStatus)) = "OFF")
         IF (cSetTalk = "ON")
            SET TALK ON
         ENDIF
         
         IF (cSetCentury = "OFF")
            SET CENTURY OFF
         ENDIF

         IF (cSetCompatible = "ON")
            SET COMPATIBLE ON
         ENDIF

         IF (cSetDate <> "BRITISH")
            SET DATE &cSetDate
         ENDIF

         IF (cSetDeleted = "OFF")
            SET DELETED OFF
         ENDIF

         IF (SET("NOTIFY") = "ON")
            SET NOTIFY ON
         ENDIF

         IF (SET("SAFETY") = "ON")
            SET SAFETY ON
         ENDIF
      
         RESTORE MACROS FROM &cMacros
 
         IF (.NOT. EMPTY(ALIAS(nSelect)))     
            SELECT (nSelect)
         ENDIF
      ENDIF
   ENDIF
