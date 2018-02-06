PRIVATE plRequest
plRequest = .F.

DO WHILE .T.
   DO _Layout
   STORE 0 TO pnOption
   
   @ 06,06 PROMPT " \<1.   SISTEMA INTEGRADO     " COLOR W/N,W/N,W/N,N/W,   ,N/W,W+/N,  ,   ,- 
   @ 12,06 PROMPT " \<2.    RE-ORGANIZACION      " COLOR W/N,W/N,W/N,N/W,   ,N/W,W+/N,  ,   ,- 
   @ 18,06 PROMPT " \<3.  COPIA DE SEGURIDAD     " COLOR W/N,W/N,W/N,N/W,   ,N/W,W+/N,  ,   ,- 
   @ 06,47 PROMPT " \<4. RECUPERACION DE DATOS  "  COLOR W/N,W/N,W/N,N/W,   ,N/W,W+/N,  ,   ,- 
   @ 12,47 PROMPT " \<0.  SALIR DE ESTE MENU    "  COLOR W/N,W/N,W/N,N/W,   ,N/W,W+/N,  ,   ,- 

   MENU TO pnOption
   
   DO CASE
      CASE INLIST(pnOption, 0, 5)     && 0. SALIR DE ESTE MENU
         DO WHILE .T.
            DO quit01.spr
            IF LASTKEY() # 27
               EXIT DO 
            ENDIF
         ENDDO
         IF plRequest
            RETURN
         ENDIF
      CASE pnOption = 1     && 1. SISTEMA INTEGRADO
         IF UserConfig("menu02.prg", "Access", .T.)
            DO openfile.prg
            DO _BackGround WITH 1
            DO _Center WITH 00, gcLocal, "N/W"

            *-- Imprime la fecha del sistema.
            DO CASE
               CASE DOW(DATE()) = 1
                  pcDate = "Domingo"
               CASE DOW(DATE()) = 2
                  pcDate = "Lunes"
               CASE DOW(DATE()) = 3
                  pcDate = "Martes"
               CASE DOW(DATE()) = 4
                  pcDate = "Mi‚rcoles"
               CASE DOW(DATE()) = 5
                  pcDate = "Jueves"
               CASE DOW(DATE()) = 6
                  pcDate = "Viernes"
               CASE DOW(DATE()) = 7
                  pcDate = "S bado"
            ENDCASE

            @ 00,00 SAY pcDate + ", " + DTOC(DATE()) ;
               SIZE 1,21 ;
               COLOR N/W

            DO menu02.prg
         ENDIF
      CASE pnOption = 2     && 2. RE-ORGANIZACION
         IF UserConfig("reindex.spr", "Access", .T.)
            IF SYS(5) = "C:"      
               DO SaveScreen
               @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

               DO reindex.spr

               DO RestoreScreen
            ELSE
               WAIT WINDOW msgNotServer
            ENDIF
         ENDIF
      CASE pnOption = 3     && 3. COPIA DE SEGURIDAD
         IF UserConfig("backup.spr", "Access", .T.)
            IF SYS(5) = "C:"      
               DO SaveScreen
               @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

               DO backup.spr 
 
               DO RestoreScreen
            ELSE
               WAIT WINDOW msgNotServer
            ENDIF
         ENDIF
      CASE pnOption = 4     && 4. RECUPERACION DE DATOS
         IF UserConfig("restore.spr", "Access", .T.)
            IF SYS(5) = "C:"      
               DO SaveScreen
               @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

               DO restore.spr 
  
               DO RestoreScreen
            ELSE
               WAIT WINDOW msgNotServer
            ENDIF
         ENDIF
   ENDCASE
ENDDO

*-- Procedimientos y funciones del soporte.

FUNCTION _Layout         &&  Screen Layout 
@ 05,05 TO 07,34  COLOR W/N && Cuadro N§ 1
@ 11,05 TO 13,34  COLOR W/N && Cuadro N§ 2
@ 17,05 TO 19,34  COLOR W/N && Cuadro N§ 3
@ 05,46 TO 07,74  COLOR W/N && Cuadro N§ 4
@ 11,46 TO 13,74  COLOR W/N && Cuadro N§ 5

@ 06,06 SAY " 1.   SISTEMA INTEGRADO" ;
   SIZE 1,28, 0 ;
   COLOR W/N   
@ 12,06 SAY " 2.    RE-ORGANIZACION" ;
   SIZE 1,28, 0 ;
   COLOR W/N   
@ 18,06 SAY " 3.  COPIA DE SEGURIDAD" ;
   SIZE 1,28, 0 ;
   COLOR W/N   
@ 06,47 SAY " 4. RECUPERACION DE DATOS" ;
   SIZE 1,27, 0 ;
   COLOR W/N   
@ 12,47 SAY " 0.  SALIR DE ESTE MENU" ;
   SIZE 1,27, 0 ;
   COLOR W/N