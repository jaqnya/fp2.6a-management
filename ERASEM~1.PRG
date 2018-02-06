IF USED("detacomp")
   SELECT detacomp
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detacomp.dbf", "DBF", "¨ D¢nde est  DETACOMP.DBF ?")) ;
      AGAIN ALIAS detacomp ;
      ORDER TAG indice1
ENDIF

IF USED("detavent")
   SELECT detavent
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detavent.dbf", "DBF", "¨ D¢nde est  DETAVENT.DBF ?")) ;
      AGAIN ALIAS detavent ;
      ORDER TAG indice1
ENDIF

IF USED("detanotc")
   SELECT detanotc
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detanotc.dbf", "DBF", "¨ D¢nde est  DETANOTC.DBF ?")) ;
      AGAIN ALIAS detanotc ;
      ORDER TAG indice1
ENDIF

IF USED("detanotp")
   SELECT detanotp
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detanotp.dbf", "DBF", "¨ D¢nde est  DETANOTP.DBF ?")) ;
      AGAIN ALIAS detanotp ;
      ORDER TAG indice1
ENDIF

IF USED("detaremi")
   SELECT detaremi
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detaremi.dbf", "DBF", "¨ D¢nde est  DETAREMI.DBF ?")) ;
      AGAIN ALIAS detaremi ;
      ORDER TAG indice1
ENDIF

IF USED("detapres")
   SELECT detapres
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detapres.dbf", "DBF", "¨ D¢nde est  DETAPRES.DBF ?")) ;
      AGAIN ALIAS detapres ;
      ORDER TAG indice1
ENDIF

IF USED("detamovi")
   SELECT detamovi
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detamovi.dbf", "DBF", "¨ D¢nde est  DETAMOVI.DBF ?")) ;
      AGAIN ALIAS detamovi ;
      ORDER TAG indice1
ENDIF

IF USED("detamot")
   SELECT detamot
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detamot.dbf", "DBF", "¨ D¢nde est  DETAMOT.DBF ?")) ;
      AGAIN ALIAS detamot ;
      ORDER TAG indice1
ENDIF



               PRIVATE pcSelect, pcOrder, pnRecNo
               pcSelect = SELECT()
               pcOrder  = ORDER()
               pnRecNo  = IIF(EOF(), 0, RECNO())

               SELECT detavent
               GO TOP
               LOCATE FOR detavent.articulo = maesprod.codigo
               IF FOUND() 
                  WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE VENTAS, IMPOSIBLE BORRARLO !"
                  SELECT (pcSelect)
                  SET ORDER TO TAG (pcOrder) 
                  IF pnRecNo # 0 
                     GOTO RECORD pnRecNo
                  ENDIF
               ELSE 
                  SELECT detacomp
                  GO TOP
                  LOCATE FOR detacomp.articulo = maesprod.codigo
                  IF FOUND() 
                     WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE COMPRAS, IMPOSIBLE BORRARLO !"
                     SELECT (pcSelect)
                     SET ORDER TO TAG (pcOrder) 
                     IF pnRecNo # 0 
                        GOTO RECORD pnRecNo
                     ENDIF
                  ELSE 
                     SELECT detanotc
                     GO TOP
                     LOCATE FOR detanotc.articulo = maesprod.codigo
                     IF FOUND() 
                        WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE N.DEB/CRED (C), IMPOSIBLE BORRARLO !"
                        SELECT (pcSelect)
                        SET ORDER TO TAG (pcOrder) 
                        IF pnRecNo # 0 
                           GOTO RECORD pnRecNo
                        ENDIF
                     ELSE 
                        SELECT detanotp
                        GO TOP
                        LOCATE FOR detanotp.articulo = maesprod.codigo
                        IF FOUND()
                           WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE N.DEB/CRED (P), IMPOSIBLE BORRARLO !"
                           SELECT (pcSelect)
                           SET ORDER TO TAG (pcOrder) 
                           IF pnRecNo # 0 
                           GOTO RECORD pnRecNo
                           ENDIF
                        ELSE
                          SELECT detaremi
                          GO TOP
                          LOCATE FOR detaremi.articulo = maesprod.codigo
                          IF FOUND()
                             WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE REMISIONES, IMPOSIBLE BORRARLO !"
                             SELECT (pcSelect)
                             SET ORDER TO TAG (pcOrder) 
                             IF pnRecNo # 0 
                                GOTO RECORD pnRecNo
                             ENDIF
                          ELSE
                             SELECT detapres
                             GO TOP
                             LOCATE FOR detapres.articulo = maesprod.codigo
                                IF FOUND()
                                   WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE PRESUPUESTOS, IMPOSIBLE BORRARLO !"                                   
                                   SELECT (pcSelect)
                                   SET ORDER TO TAG (pcOrder) 
                                   IF pnRecNo # 0 
                                      GOTO RECORD pnRecNo
                                   ENDIF
                                ELSE
                                   SELECT detamovi
                                   GO TOP
                                   LOCATE FOR detamovi.articulo = maesprod.codigo
                                   IF FOUND()
                                      WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE AJUSTES, IMPOSIBLE BORRARLO !"                                   
                                      SELECT (pcSelect)
                                      SET ORDER TO TAG (pcOrder) 
                                      IF pnRecNo # 0 
                                         GOTO RECORD pnRecNo
                                      ENDIF
                                   ELSE
                                      SELECT detamot
                                      GO TOP
                                      LOCATE FOR detamot.articulo = maesprod.codigo
                                      IF FOUND()
                                         WAIT WINDOW "ESTE ARTICULO FIGURA EN LA TABLA DE MOV. DE OT, IMPOSIBLE BORRARLO !"
                                         SELECT (pcSelect)
                                         SET ORDER TO TAG (pcOrder) 
                                         IF pnRecNo # 0 
                                            GOTO RECORD pnRecNo
                                         ENDIF
                                      ELSE
                                         DELETE
                                         WAIT WINDOW "­ ESTE ARTICULO HA SIDO BORRADO !"
                                      ENDIF
                                   ENDIF
                                ENDIF
                          ENDIF 
                        ENDIF
                     ENDIF
                  ENDIF
               ENDIF




IF USED("detacomp")
   SELECT detacomp
   USE 
ENDIF

IF USED("detavent")
   SELECT detavent
   USE 
ENDIF

IF USED("detanotc")
   SELECT detanotc
   USE
ENDIF

IF USED("detanotp")
   SELECT detanotp
   USE 
ENDIF

IF USED("detaremi")
   SELECT detaremi
   USE
ENDIF

IF USED("detapres")
   SELECT detapres
   USE 
ENDIF

IF USED("detamovi")
   SELECT detamovi
   USE
ENDIF

IF USED("detamot")
   SELECT detamot
   USE
ENDIF
