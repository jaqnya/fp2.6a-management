IF lAdding .OR. lEditing .OR. lDeleting
   IF INLIST(LASTKEY(), K_PGUP, K_ENTER)
      IF EMPTY(m.serieot2)
         ?? CHR(7)
         =MsgBox(C_MESSA_33, "", 0, "MESSAGE", "C")
         _CUROBJ = OBJNUM(m.serieot2)
         RETURN .F.
      ELSE
         IF m.nroot2 <= 0
            ?? CHR(7)
            =MsgBox(C_MESSA_02, "", 0, "MESSAGE", "C")
            _CUROBJ = OBJNUM(m.nroot2)
            RETURN .F.
         ELSE
            IF m.division <= 0
               ?? CHR(7)
               =MsgBox(C_MESSA_34, "", 0, "MESSAGE", "C")
               _CUROBJ = OBJNUM(m.division)
               RETURN .F.
            ELSE
               IF m.trecepcion <= 0
                  ?? CHR(7)
                  =MsgBox(C_MESSA_35, "", 0, "MESSAGE", "C")
                  _CUROBJ = OBJNUM(m.trecepcion)
                  RETURN .F.
               ELSE
                  IF m.cliente <= 0
                     ?? CHR(7)
                     =MsgBox(C_MESSA_36, "", 0, "MESSAGE", "C")
                     _CUROBJ = OBJNUM(m.cliente)
                     RETURN .F.
                  ELSE
                     IF EMPTY(m.nombreot)
                        ?? CHR(7)
                        =MsgBox(C_MESSA_22, "", 0, "MESSAGE", "C")
                        _CUROBJ = OBJNUM(m.nombreot)
                        RETURN .F.
                     ELSE
                        IF m.maquina <= 0
                           ?? CHR(7)
                           =MsgBox(C_MESSA_37, "", 0, "MESSAGE", "C")
                           _CUROBJ = OBJNUM(m.maquina)
                           RETURN .F.
                        ELSE
                           IF m.marca <= 0
                              ?? CHR(7)
                              =MsgBox(C_MESSA_38, "", 0, "MESSAGE", "C")
                              _CUROBJ = OBJNUM(m.marca)
                              RETURN .F.
                           ELSE
                              IF m.modelo <= 0
                                 ?? CHR(7)
                                 =MsgBox(C_MESSA_39, "", 0, "MESSAGE", "C")
                                 _CUROBJ = OBJNUM(m.modelo)
                                 RETURN .F.
                              ENDIF
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   
      IF lEditing
         IF .NOT. DataChanged()
            RETURN .F.
         ENDIF
      ENDIF
   
      IF RDLEVEL() < 5
         nSaveWarn = MsgBox(C_MESSA_42, "", 0, "MESSAGE", "C")
      ELSE
         IF lAdding
            =MsgBox(C_MESSA_40, "", 0, "MESSAGE", "C")         
         ELSE
            IF lEditing
               =MsgBox(C_MESSA_41, "", 0, "MESSAGE", "C")
            ENDIF
         ENDIF
         nSaveWarn = 7   && Don't save.
      ENDIF
      
      IF INLIST(nSaveWarn, 6, 7)   && Save or Don't save.
         RETURN
      ELSE
         IF nSaveWarn = 2   
            RETURN .F.
         ENDIF
      ENDIF
   ENDIF
ENDIF