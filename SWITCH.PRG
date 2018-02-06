*:*********************************************************************
*:
*: Archivo de Procedimiento: SWITCH.PRG
*:
*:                  Sistema: Interruptor de Ventanas de B£squda.   
*:                    Autor: Jos‚ Avilio Acu¤a Acosta
*:                 Copyright (c) 2004, Alben S.R.L.             
*:            Last modified: 12/02/2004           
*:
*:            Procs & Fncts:
*:
*:*********************************************************************

PARAMETER cAlias

PUSH KEY CLEAR

DO CASE
   CASE LOWER(cAlias) = "clientes"
      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO clientes.prg WITH "Add"
               EXIT DO
            ENDIF
            IF UPPER(pcAppend) = "N"
               EXIT DO
            ENDIF
         ENDDO    
         POP KEY
         RETURN
      ENDIF

      DO CASE
         CASE LOWER(TAG()) = "indice1"
            DO clibusc1.spr
         CASE LOWER(TAG()) = "indice2"
            DO clibusc2.spr
         CASE LOWER(TAG()) = "indice3"
            DO clibusc3.spr
         CASE LOWER(TAG()) = "indice4"
            DO clibusc4.spr
         CASE LOWER(TAG()) = "indice5"
            DO clibusc5.spr
         CASE LOWER(TAG()) = "indice6"
            DO clibusc6.spr
         CASE LOWER(TAG()) = "indice7"
            DO clibusc7.spr
      ENDCASE

   CASE LOWER(cAlias) = "cabecob"
      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO cobros.prg 
               EXIT DO
            ENDIF
            IF UPPER(pcAppend) = "N"
               EXIT DO
            ENDIF
         ENDDO    
         POP KEY
         RETURN
      ENDIF

      DO CASE
         CASE LOWER(TAG()) = "indice1"
            DO vtabusc1.spr
         CASE LOWER(TAG()) = "indice2"
            DO vtabusc2.spr
         CASE LOWER(TAG()) = "indice3"
            DO vtabusc3.spr
      ENDCASE

   CASE LOWER(cAlias) = "ot"
      IF EOF()
         DO WHILE .T.
            WAIT WINDOW "    LA TABLA SE ENCUENTRA VACIA" + CHR(13) + "¨ DESEA AGREGAR UN NUEVO REGISTRO ? [S/N]" TO pcAppend
            IF UPPER(pcAppend) = "S"
               DO ot.prg WITH "Add"
               EXIT DO
            ENDIF
            IF UPPER(pcAppend) = "N"
               EXIT DO
            ENDIF
         ENDDO    
         POP KEY
         RETURN
      ENDIF

      DO CASE
         CASE LOWER(TAG()) == "indice1"
            DO otbusc01.spr
         CASE LOWER(TAG()) == "indice2"
            DO otbusc02.spr
         CASE LOWER(TAG()) == "indice3"
            DO otbusc03.spr
         CASE LOWER(TAG()) == "indice4"
            DO vtabusc3.spr
         CASE LOWER(TAG()) == "indice5"
            DO otbusc05.spr
         CASE LOWER(TAG()) == "indice6"
            DO otbusc06.spr
         CASE LOWER(TAG()) == "indice7"
            DO otbusc07.spr
         CASE LOWER(TAG()) == "indice8"
            DO otbusc08.spr
         CASE LOWER(TAG()) == "indice9"
            DO otbusc09.spr
         CASE LOWER(TAG()) == "indice10"
            DO otbusc10.spr
         CASE LOWER(TAG()) == "indice11"
            DO otbusc11.spr
      ENDCASE

ENDCASE

POP KEY