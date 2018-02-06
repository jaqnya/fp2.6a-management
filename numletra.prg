FUNCTION nuMletra
 PARAMETER nuMero
 PRIVATE s, i, leTra, x, y
 SET TALK OFF
 IF nuMero<>0
      leTra = STR(nuMero, 9)
      s = ''
      a = SUBSTR(leTra, 1, 3)
      b = SUBSTR(leTra, 4, 3)
      c = SUBSTR(leTra, 7, 3)
      IF VAL(leTra)=0
           s = s+'CERO'
      ELSE
           IF VAL(a)<>0
                s = s+coNvierte(a)
                IF VAL(RIGHT(a, 1))=1 .AND. SUBSTR(a, 2, 2)<>'11'
                     s = LEFT(s, LEN(s)-2)+' '
                ENDIF
                IF nuMero>=2000000
                     s = s+'MILLONES '
                ELSE
                     s = s+'MILLON '
                ENDIF
           ENDIF
           IF VAL(b)<>0
                s = s+coNvierte(b)
                IF nuMero>=1000 .AND. nuMero<2000
                     s = RIGHT(s, LEN(s)-4)
                ELSE
                     IF VAL(RIGHT(b, 1))=1 .AND. SUBSTR(b, 2, 2)<>'11'
                          s = LEFT(s, LEN(s)-2)+' '
                     ENDIF
                ENDIF
                s = s+'MIL '
           ENDIF
           IF VAL(c)<>0
                s = s+coNvierte(c)
                IF RIGHT(s, 2)='Y '
                     s = LEFT(s, LEN(s)-2)
                ENDIF
           ENDIF
      ENDIF
      enLetra = s
 ELSE
      enLetra = 'CERO'
 ENDIF
 RETURN enLetra
*
FUNCTION coNvierte
 PARAMETER w
 PRIVATE x, z, y
 STORE '' TO x, y, z
 x = SUBSTR(w, 1, 1)
 IF VAL(x)<>0
      IF x='1'
           IF VAL(RIGHT(w, 2))=0
                y = y+'CIEN '
           ELSE
                y = y+'CIENTO '
           ENDIF
      ELSE
           DO CASE
                CASE x='2'
                     y = y+'DOSCI'
                CASE x='3'
                     y = y+'TRESCI'
                CASE x='4'
                     y = y+'CUATROCI'
                CASE x='5'
                     y = y+'QUINI'
                CASE x='6'
                     y = y+'SEISCI'
                CASE x='7'
                     y = y+'SETECI'
                CASE x='8'
                     y = y+'OCHOCI'
                CASE x='9'
                     y = y+'NOVECI'
           ENDCASE
           y = y+'ENTOS '
      ENDIF
 ENDIF
 x = SUBSTR(w, 2, 1)
 z = SUBSTR(w, 3, 1)
 IF VAL(x)<>0
      IF x='1'
           DO CASE
                CASE z='0'
                     y = y+'DIEZ '
                CASE z='1'
                     y = y+'ONCE '
                CASE z='2'
                     y = y+'DOCE '
                CASE z='3'
                     y = y+'TRECE '
                CASE z='4'
                     y = y+'CATORCE '
                CASE z='5'
                     y = y+'QUINCE '
                CASE z='6'
                     y = y+'DIECISEIS '
                CASE z='7'
                     y = y+'DIECISIETE '
                CASE z='8'
                     y = y+'DIECIOCHO '
                CASE z='9'
                     y = y+'DIECINUEVE '
           ENDCASE
      ELSE
           DO CASE
                CASE x='2'
                     IF z='0'
                          y = y+'VEINTE '
                     ELSE
                          y = y+'VEINTI'
                     ENDIF
                CASE x='3'
                     y = y+'TREINTA Y '
                CASE x='4'
                     y = y+'CUARENTA Y '
                CASE x='5'
                     y = y+'CINCUENTA Y '
                CASE x='6'
                     y = y+'SESENTA Y '
                CASE x='7'
                     y = y+'SETENTA Y '
                CASE x='8'
                     y = y+'OCHENTA Y '
                CASE x='9'
                     y = y+'NOVENTA Y '
           ENDCASE
           IF VAL(x)>3 .AND. VAL(z)=0
                y = LEFT(y, LEN(y)-2)
           ENDIF
      ENDIF
 ENDIF
 IF x<>'1'
      DO CASE
           CASE z='1'
                y = y+'UNO '
           CASE z='2'
                y = y+'DOS '
           CASE z='3'
                y = y+'TRES '
           CASE z='4'
                y = y+'CUATRO '
           CASE z='5'
                y = y+'CINCO '
           CASE z='6'
                y = y+'SEIS '
           CASE z='7'
                y = y+'SIETE '
           CASE z='8'
                y = y+'OCHO '
           CASE z='9'
                y = y+'NUEVE '
      ENDCASE
 ENDIF
 RETURN y

