npeso = "A & A IMPORTACIONES S.R.L."
STORE " " TO archi_01, mdestino

 DO l_14a
 STORE 'S' TO moPcion
 DEFINE WINDOW l_14 FROM 06, 19 TO 12, 59 SHADOW TITLE  ;
        ' CUADRO ANUAL DE VENTAS '
 ACTIVATE WINDOW l_14
 DO WHILE .T.
      maNo = YEAR(DATE())
      @ 01, 03 SAY 'A¥O:' GET maNo PICTURE '9999'
      @ 03, 03 SAY 'DESEA INCLUIR IMPUESTOS (S/N):' GET moPcion PICTURE '!'
      READ
      IF LASTKEY()=27
           EXIT
      ENDIF
      IF  .NOT. (moPcion='S' .OR. moPcion='N')
           WAIT WINDOW 'LA OPCION DEBE SER: (S)I O (N)O !'
           LOOP
      ENDIF
      IF esTa_corre()
           DO l_14b
           DO deStino
           DO CASE
                CASE mdEstino='P'
                     IF deSea_vfr()
                          SET DISPLAY TO VGA50
                     ENDIF
                     REPORT FORMAT l_14 PREVIEW
                     SET DISPLAY TO VGA25
                CASE mdEstino='I'
                     REPORT FORMAT l_14 TO PRINTER NOCONSOLE
           ENDCASE
      ENDIF
 ENDDO
 SELECT teMporal
 USE
 DO boRratm WITH arChi_01
 DEACTIVATE WINDOW l_14
 RELEASE WINDOW l_14
 RETURN
*
PROCEDURE l_14a
 SELECT 0
 arChi_01 = "tm" + RIGHT(SYS(3), 6)
 create table &archi_01 (mes        c (11), tipo1      n (11), tipo2      n (11), monto_ndeb n (11), monto_ncre n (11), total_mens n (11), porcentaje n (5,2))
 use &archi_01 alias TEMPORAL exclusive
 RETURN
*
PROCEDURE l_14b
 SELECT teMporal
 ZAP
 FOR i = 1 TO 12
      APPEND BLANK
      REPLACE meS WITH deScmes(i)
 ENDFOR
 PRIVATE a
 coNtador = 0
 SELECT deTavent
 SET ORDER TO 1
 SELECT caBevent
 SET ORDER TO indice2
 SET EXACT OFF
 SEEK STR(maNo, 4)
 SET EXACT ON
 DO WHILE maNo=YEAR(feChadocu) .AND.  .NOT. EOF()
      coNtador = coNtador+1
      WAIT WINDOW NOWAIT 'PROCESANDO EL ARCH.DE VENTAS: '+ ;
           ALLTRIM(TRANSFORM(coNtador, '9,999,999'))+'/'+ ;
           ALLTRIM(TRANSFORM(RECCOUNT(), '9,999,999'))
      mcTipo = 'TIPO'+STR(tiPodocu, 1)
      STORE 0 TO a
      IF moPcion='N'
           SELECT deTavent
           SEEK STR(caBevent.tiPodocu, 1)+STR(caBevent.nrOdocu, 7)
           DO WHILE caBevent.tiPodocu=tiPodocu .AND. caBevent.nrOdocu= ;
              nrOdocu .AND.  .NOT. EOF()
                IF tiPodocu=3
                     a = a+((deTavent.caNtidad*deTavent.prEcio)/1.1)
                ELSE
                     a = a+ROUND((deTavent.caNtidad*deTavent.prEcio), 0)
                ENDIF
                SELECT deTavent
                SKIP 1
           ENDDO
           IF caBevent.tiPodocu<>3 .AND. caBevent.imPortdesc>0
                IF caBevent.poRcdesc>0
                     a = a-ROUND(((a*caBevent.poRcdesc)/100), 0)
                ELSE
                     a = a-caBevent.imPortdesc
                ENDIF
           ENDIF
      ELSE
           a = caBevent.moNto_fact
      ENDIF
 
       *- Source append by Zero Cool -*
      IF (cabevent.moneda <> 1)
         a = ROUND(a * cabevent.tipocambio, 0)
      ENDIF
      *- EOF Source append by Zero Cool -*
 
      SELECT teMporal
      GOTO MONTH(caBevent.feChadocu)
      DO CASE
           CASE INLIST(cabevent.tipodocu, 1, 3, 4, 7)
                REPLACE tiPo1 WITH tiPo1+a
           CASE INLIST(cabevent.tipodocu, 2, 8)
                REPLACE tiPo2 WITH tiPo2+a
      ENDCASE
      SELECT caBevent
      SKIP 1
 ENDDO
 SET ORDER TO 1
 coNtador = 0
 SELECT deTanotc
 SET ORDER TO 1
 SELECT caBenotc
 SET ORDER TO 2
 SET EXACT OFF
 SEEK STR(maNo, 4)
 SET EXACT ON
 DO WHILE maNo=YEAR(feChanota) .AND.  .NOT. EOF()
      coNtador = coNtador+1
      WAIT WINDOW NOWAIT 'PROCESANDO EL ARCH.DE DEBITOS Y CREDITOS: '+ ;
           ALLTRIM(TRANSFORM(coNtador, '9,999,999'))+'/'+ ;
           ALLTRIM(TRANSFORM(RECCOUNT(), '9,999,999'))
      IF moPcion='N'
           SELECT deTanotc
           SEEK STR(caBenotc.tiPonota, 1)+STR(caBenotc.nrOnota, 7)
           DO WHILE caBenotc.tiPonota=tiPonota .AND. caBenotc.nrOnota= ;
              nrOnota .AND.  .NOT. EOF()
                SELECT teMporal
                GOTO MONTH(caBenotc.feChanota)
                DO CASE
                     CASE caBenotc.tiPonota=1 .OR. caBenotc.tiPonota=3
                          REPLACE moNto_ndeb WITH moNto_ndeb+ ;
                                  INT(ROUND((deTanotc.caNtidad* ;
                                  deTanotc.prEcio), 0))
                     CASE caBenotc.tiPonota=2 .OR. caBenotc.tiPonota=4
                          REPLACE moNto_ncre WITH moNto_ncre+ ;
                                  INT(ROUND((deTanotc.caNtidad* ;
                                  deTanotc.prEcio), 0))
                ENDCASE
                SELECT deTanotc
                SKIP 1
           ENDDO
      ELSE
           SELECT teMporal
           GOTO MONTH(caBenotc.feChanota)
           DO CASE
                CASE caBenotc.tiPonota=1 .OR. caBenotc.tiPonota=3
                     REPLACE moNto_ndeb WITH moNto_ndeb+caBenotc.moNto_nota
                CASE caBenotc.tiPonota=2 .OR. caBenotc.tiPonota=4
                     REPLACE moNto_ncre WITH moNto_ncre+caBenotc.moNto_nota
           ENDCASE
      ENDIF
      SELECT caBenotc
      SKIP 1
 ENDDO
 SET ORDER TO 1
 KEYBOARD '{spacebar}'
 WAIT WINDOW ''
 SELECT teMporal
 SUM (tiPo1+tiPo2+moNto_ndeb)-moNto_ncre TO suMa
 GOTO TOP
 DO WHILE RECNO()<=12 .AND.  .NOT. EOF()
      REPLACE toTal_mens WITH (tiPo1+tiPo2+moNto_ndeb)-moNto_ncre
      IF suMa>0
           REPLACE poRcentaje WITH toTal_mens*100/suMa
      ENDIF
      SKIP 1
 ENDDO

 RETURN
*
