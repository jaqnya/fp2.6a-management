PRIVATE plRequest, pcChoice
pcChoice = ""
plRequest = .F.

DO WHILE .T.
   DO _Layout
   STORE 0 TO pnOption
   
   @ 06,10 PROMPT ' \<1. MANTENIMIENTO   ' COLOR W/N,W/N,W/N,N/W,   ,N/W,W+/N,  ,   ,- 
   @ 12,10 PROMPT ' \<2. CONSULTAS       ' COLOR W/N,W/N,W/N,N/W,   ,N/W,W+/N,  ,   ,- 
   @ 18,10 PROMPT ' \<3. LISTADOS        ' COLOR W/N,W/N,W/N,N/W,   ,N/W,W+/N,  ,   ,- 
   @ 06,51 PROMPT ' \<4. OTRAS OPCIONES  ' COLOR W/N,W/N,W/N,N/W,   ,N/W,W+/N,  ,   ,- 
   @ 12,51 PROMPT ' \<0. FIN DEL SISTEMA ' COLOR W/N,W/N,W/N,N/W,   ,N/W,W+/N,  ,   ,- 

   MENU TO pnOption
   
   DO CASE
      CASE INLIST(pnOption, 0, 5)
         DO WHILE .T.
            DO quit02.spr
            IF LASTKEY() # 27
               EXIT DO 
            ENDIF
         ENDDO
         IF plRequest
            CLOSE DATABASES
            RETURN
         ENDIF
      CASE pnOption = 1           
         IF UserConfig("mnucycle.prg", "Access", .T.)
            DO mnucycle.prg
         ENDIF
      CASE pnOption = 2
         IF UserConfig("mnucycl2.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO mnucycl2.prg

            DO RestoreScreen
         ENDIF
      CASE pnOption = 3
         IF UserConfig("mnucycl1.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO mnucycl1.prg

            DO RestoreScreen
         ENDIF
      CASE pnOption = 4
         IF UserConfig("othersop.spr", "Access", .T.)
            *-- Dibuja el fondo de la pantalla principal.
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO WHILE .T.
               DO othersop.spr WITH "pcChoice"
               IF LASTKEY() = 27
                  EXIT DO 
               ENDIF
               DO CASE
                  CASE pcChoice = "a_01.spr"   && 10. Actualizaci¢n del listado de clientes.
   *                 IF UserConfig("rpccclie.spr", "Access", .T.)
                        DO a_01.spr
   *                 ENDIF
                  CASE pcChoice = "a_02.spr"   &&  9. Actualizaci¢n de Precios de Costo desde otros locales.
   *                 IF UserConfig("rpccclie.spr", "Access", .T.)
                        DO a_02.spr
   *                 ENDIF
                  CASE pcChoice = "rpccclie.spr"
                     IF UserConfig("rpccclie.spr", "Access", .T.)
                        DO rpccclie.spr
                     ENDIF
                  CASE pcChoice = "rpccprov.spr"
                     IF UserConfig("rpccprov.spr", "Access", .T.)
                        DO rpccprov.spr
                     ENDIF
                  CASE pcChoice = "rpstmaes.spr"
                     IF UserConfig("rpstmaes.spr", "Access", .T.)
                        DO rpstmaes.spr
                     ENDIF
                  CASE pcChoice = "rpstmae1.spr"
                     IF UserConfig("rpstmae1.spr", "Access", .T.)
                        DO rpstmae1.spr
                     ENDIF
                  CASE pcChoice = "control.spr"
                     IF UserConfig("control.spr", "Access", .T.)
                        DO control.spr
                     ENDIF
                  CASE pcChoice = "fusion.spr"
                     IF UserConfig("fusion.spr", "Access", .T.)
                        DO fusion.spr
                     ENDIF
                  CASE pcChoice = "property.spr"
                     IF UserConfig("property.spr", "Access", .T.)
                        DO mnudata.spr
                     ENDIF
                  CASE pcChoice = "o_03.spr"
   *                 IF UserConfig("o_03.spr", "Access", .T.)
                        DO o_03.spr
   *                 ENDIF
                  CASE pcChoice = "o_04.spr"
   *                 IF UserConfig("o_04.spr", "Access", .T.)
                        DO o_04.spr
   *                 ENDIF
                  CASE pcChoice = "fstprmfy.spr"
                     DO fstprmfy.spr
               ENDCASE
            ENDDO
    
            DO RestoreScreen
         ENDIF
   ENDCASE
ENDDO
   
*-- Procedimientos y funciones del soporte.
FUNCTION _Layout         &&  Screen Layout 

@ 05,09 TO 07,30  COLOR W/N && Cuadro N§ 1
@ 11,09 TO 13,30  COLOR W/N && Cuadro N§ 2
@ 17,09 TO 19,30  COLOR W/N && Cuadro N§ 3
@ 05,50 TO 07,71  COLOR W/N && Cuadro N§ 4
@ 11,50 TO 13,71  COLOR W/N && Cuadro N§ 5

@ 06,10 SAY " 1. MANTENIMIENTO    " ;
   SIZE 1,20, 0 ;
   COLOR W/N   
@ 12,10 SAY " 2. CONSULTAS        " ;
   SIZE 1,20, 0 ;
   COLOR W/N   
@ 18,10 SAY " 3. LISTADOS         " ;
   SIZE 1,20, 0 ;
   COLOR W/N   
@ 06,51 SAY " 4. OTRAS OPCIONES   " ;
   SIZE 1,19, 0 ;
   COLOR W/N   
@ 12,51 SAY " 0. FIN DEL SISTEMA  " ;
   SIZE 1,19, 0 ;
   COLOR W/N   
@ 24,00 SAY 'Usuario: ' + ALLTRIM(buscar('nombre', 'usuarios', gnUser)) ;
   SIZE 1,40, 0 ;
   COLOR N/W

@ 24,61 SAY DTOC(DATE()) + ' ' + TIME() ;
   SIZE 1,19, 0 ;
   COLOR N/W