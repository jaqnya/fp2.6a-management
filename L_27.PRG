*IF muSop(85,1)<>'X'
*     RETURN
*ENDIF
npeso = "A & A IMPORTACIONES S.R.L."
STORE " " TO archi_01, mdestino

 DO l_27a
 STORE 'S' TO moPcion
 DEFINE WINDOW l_27 FROM 06, 19 TO 12, 59 SHADOW TITLE  ;
        ' CUADRO ANUAL DE COMPRAS '
 ACTIVATE WINDOW l_27
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
           DO l_27b
           DO deStino
           DO CASE
                CASE mdEstino='P'
                     IF deSea_vfr()
                          SET DISPLAY TO VGA50
                     ENDIF
                     REPORT FORMAT l_27 PREVIEW
                     SET DISPLAY TO VGA25
                CASE mdEstino='I'
                     REPORT FORMAT l_27 TO PRINTER NOCONSOLE
           ENDCASE
      ENDIF
 ENDDO
 SELECT teMporal
 USE
 DO boRratm WITH arChi_01
 DEACTIVATE WINDOW l_27
 RELEASE WINDOW l_27
 RETURN
*
PROCEDURE l_27a
 SELECT 0
 arChi_01 = crEatemp()
 create table &archi_01 (mes        c (11), tipo1      n (11), tipo2      n (11), monto_ndeb n (11), monto_ncre n (11), total_mens n (11), porcentaje n (5,2))
 use &archi_01 alias TEMPORAL exclusive
 RETURN
*
PROCEDURE l_27b
 SELECT teMporal
 ZAP
 FOR i = 1 TO 12
      APPEND BLANK
      REPLACE meS WITH deScmes(i)
 ENDFOR
 PRIVATE a
 coNtador = 0
 SELECT deTacomp
 SET ORDER TO 1
 SELECT caBecomp
 SET ORDER TO 2
 SET EXACT OFF
 SEEK STR(maNo, 4)
 SET EXACT ON
 DO WHILE maNo=YEAR(feChadocu) .AND.  .NOT. EOF()
      coNtador = coNtador+1
      WAIT WINDOW NOWAIT 'PROCESANDO EL ARCH.DE COMPRAS: '+ ;
           ALLTRIM(TRANSFORM(coNtador, '9,999,999'))+'/'+ ;
           ALLTRIM(TRANSFORM(RECCOUNT(), '9,999,999'))
      mcTipo = 'TIPO'+STR(tiPodocu, 1)
      STORE 0 TO a
      IF moPcion='N'
           SELECT deTacomp
           SEEK STR(caBecomp.tiPodocu, 1)+STR(caBecomp.nrOdocu, 9)+ ;
                STR(caBecomp.prOveedor, 5)
           DO WHILE caBecomp.tiPodocu=tiPodocu .AND. caBecomp.nrOdocu= ;
              nrOdocu .AND. caBecomp.prOveedor=prOveedor .AND.  .NOT. EOF()
                IF tiPodocu=3
                     a = a+((deTacomp.caNtidad*deTacomp.prEcio)/1.1)
                ELSE
                     a = a+ROUND((deTacomp.caNtidad*deTacomp.prEcio), 0)
                ENDIF
                SELECT deTacomp
                SKIP 1
           ENDDO
           SELECT teMporal
           GOTO MONTH(caBecomp.feChadocu)
           IF caBecomp.tiPodocu<>3 .AND. caBecomp.imPortdesc>0
                IF caBecomp.poRcdesc>0
                     a = a-ROUND(((a*caBecomp.poRcdesc)/100), 0)
                ELSE
                     a = a-caBecomp.imPortdesc
                ENDIF
           ENDIF
      ELSE
           a = caBecomp.moNto_fact
      ENDIF
      
      *- Source append by Zero Cool -*
      IF (cabecomp.moneda <> 1)
         a = ROUND(a * cabecomp.tipocambio, 0)
      ENDIF
      *- EOF Source append by Zero Cool -*
      
      SELECT teMporal
      GOTO MONTH(caBecomp.feChadocu)
      DO CASE
           CASE caBecomp.tiPodocu=1 .OR. caBecomp.tiPodocu=3 .OR.  ;
                caBecomp.tiPodocu=4
                REPLACE tiPo1 WITH tiPo1+a
           CASE caBecomp.tiPodocu=2 .OR. caBecomp.tiPodocu=5
                REPLACE tiPo2 WITH tiPo2+a
      ENDCASE
      SELECT caBecomp
      SKIP 1
 ENDDO
 SET ORDER TO 1
 SELECT deTanotp
 SET ORDER TO 1
 coNtador = 0
 SELECT caBenotp
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
           SELECT deTanotp
           SEEK STR(caBenotp.tiPonota, 1)+STR(caBenotp.nrOnota, 9)+ ;
                STR(caBenotp.prOveedor, 5)
           DO WHILE caBenotp.tiPonota=tiPonota .AND. caBenotp.nrOnota= ;
              nrOnota .AND. caBenotp.prOveedor=prOveedor .AND.  .NOT. EOF()
                SELECT teMporal
                GOTO MONTH(caBenotp.feChanota)
                DO CASE
                     CASE caBenotp.tiPonota=1 .OR. caBenotp.tiPonota=3
                          REPLACE moNto_ndeb WITH moNto_ndeb+ ;
                                  INT(ROUND((deTanotp.caNtidad* ;
                                  deTanotp.prEcio), 0))
                     CASE caBenotp.tiPonota=2 .OR. caBenotp.tiPonota=4
                          REPLACE moNto_ncre WITH moNto_ncre+ ;
                                  INT(ROUND((deTanotp.caNtidad* ;
                                  deTanotp.prEcio), 0))
                ENDCASE
                SELECT deTanotp
                SKIP 1
           ENDDO
      ELSE
           SELECT teMporal
           GOTO MONTH(caBenotp.feChanota)
           DO CASE
                CASE caBenotp.tiPonota=1 .OR. caBenotp.tiPonota=3
                     REPLACE moNto_ndeb WITH moNto_ndeb+caBenotp.moNto_nota
                CASE caBenotp.tiPonota=2 .OR. caBenotp.tiPonota=4
                     REPLACE moNto_ncre WITH moNto_ncre+caBenotp.moNto_nota
           ENDCASE
      ENDIF
      SELECT caBenotp
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
