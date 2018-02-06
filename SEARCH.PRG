PARAMETER pcString, pcField
PUSH KEY CLEAR
WAIT WINDOW "BUSCANDO..." NOWAIT
SELECT 0
arch_temp = "tm"+SYS(3)+".dbf"
CREATE TABLE &arch_temp (codigo    c(15),;
                         codigo2   c(15),;
                         codorig   c(15),;
                         nombre    c(40),;
                         pventag1  n(12.3),;
                         pventag2  n(12.3),;
                         pventag3  n(12.3),;
                         pventag4  n(12.3),;
                         pventag5  n(12.3),;
                         impuesto  l(01),;
                         pimpuesto n(06.2))
INDEX ON codigo TAG indice1 
INDEX ON nombre TAG indice2

USE &arch_temp ALIAS maestemp
SET ORDER TO indice2

pcString = UPPER(ALLTRIM(pcString))
DO WHILE AT("**", pcString) > 0
   pcString = STRTRAN(pcString, "**", "*")
ENDDO

IF LEFT(pcString, 1) = "*"
   pcFirst = ".NULL."
ELSE
   IF OCCURS("*", pcString) = 0
      pcFirst = pcString
   ELSE
      pcFirst = SUBSTR(pcString, 1, (ATC("*", pcString)-1))
   ENDIF
ENDIF

IF RIGHT(pcString, 1) = "*"
   pnOccurs = OCCURS("*", pcString)-1
ELSE
   pnOccurs = OCCURS("*", pcString)
ENDIF

pcExpresion = ""
PRIVATE paString

IF pnOccurs > 0
   DIMENSION paString(pnOccurs)
ENDIF

FOR pnCounter = 1 TO pnOccurs
   paString(pnCounter) = ALLTRIM(SUBSTR(pcString, ATC("*", pcString, pnCounter)+1, (ATC("*", pcString, pnCounter+1)-1)-ATC("*", pcString, pnCounter)))
   IF pnCounter = pnOccurs
      IF RIGHT(pcString, 1) = "*"
         paString(pnCounter) = ALLTRIM(SUBSTR(pcString, ATC("*", pcString, pnCounter)+1, (ATC("*", pcString, pnCounter+1)-1)-ATC("*", pcString, pnCounter)))         
      ELSE
         paString(pnCounter) = ALLTRIM(SUBSTR(pcString, ATC("*", pcString, pnCounter)+1))
      ENDIF
   ENDIF
ENDFOR

FOR pnCounter = 1 TO pnOccurs
   IF pnCounter < pnOccurs
*     pcExpresion = pcExpresion + [ATC("]+paString(pnCounter)+[", maesprod.nombre) > 0] + [ .and. ]
      pcExpresion = pcExpresion + [ATC("]+paString(pnCounter)+[", ]+ pcField + [) > 0] + [ .and. ]
   ELSE 
      pcExpresion = pcExpresion + [ATC("]+paString(pnCounter)+[", ]+ pcField + [) > 0]
*      pcExpresion = pcExpresion + [ATC("]+paString(pnCounter)+[", maesprod.nombre) > 0]
   ENDIF
ENDFOR

SELECT maesprod

IF pcFirst = ".NULL."
   GO TOP
   pnDoCounter = 1
   DO WHILE .NOT. EOF()
*     wait window "PROCESANDO: " + ALLTRIM(transFORm(nDoCounter, "9,999,999")) + "/" + ALLTRIM(transFORm(reccount(), "9,999,999")) nowait
      IF EVAL(pcExpresion)
         =SaveSearch()
      ENDIF
      SKIP
      DO progress WITH ((pnDoCounter*100)/RECCOUNT()), "PROCESANDO: ARTICULOS..."
      pnDoCounter = pnDoCounter + 1
   ENDDO
   RELEASE WINDOW _thermom
ELSE
   IF SEEK(pcFirst) 
      DO WHILE SUBSTR(&pcField, 1, LEN(ALLTRIM(pcFirst))) = ALLTRIM(pcFirst) .AND. NOT EOF()
*     DO WHILE SUBSTR(maesprod.nombre,1, LEN(ALLTRIM(pcFirst))) = ALLTRIM(pcFirst) .AND. NOT EOF()
         IF pnOccurs = 0
            =SaveSearch()
         ELSE
            IF EVAL(pcExpresion)
               =SaveSearch()
            ENDIF
         ENDIF
         SKIP
      ENDDO
   ENDIF
ENDIF
WAIT CLEAR

SELECT maestemp

IF RECCOUNT() # 0
   GO TOP
   IF NOT WEXIST ("BArticuTemp")
      DEFINE WINDOW BArticuTemp ;
         FROM 01,00 ;
         TO 23,79 ;
         TITLE " < RESULTADOS DE BUSQUEDA: " + pcString + " > " ;
         FLOAT ;
         GROW ;
         CLOSE ;
         NOSHADOW ;
         NOMINIMIZE ;
         ZOOM ;
         SYSTEM ;
         COLOR SCHEME 16
   ENDIF

   BROWSE WINDOW BArticuTemp FIELDS;
   codigo                                         :R:09:H = 'C¢digo',;
   nombre                                         :R:39:H = 'Nombre',;
   impuesto = IIF(impuesto, "S","")               :R:01:H ='',;
   pventag1                                       :R:10:H ='P.Vta 1' :p = '99,999,999',;
   precio1 = ROUND(pventag1 * 1.1,0)            :R:13:H ='P.Vta 1 c/Iva' :p = '99,999,999',;
   pventag2                                       :R:10:H ='P.Vta 2' :p = '99,999,999',;
   precio2 = ROUND(pventag2 * 1.1,0)            :R:13:H ='P.Vta 2 c/Iva' :p = '99,999,999',;
   pventag3                                       :R:10:H ='P.Vta 3' :p = '99,999,999',;
   precio3 = ROUND(pventag3 * 1.1,0)           :R:13:H ='P.Vta 3 c/Iva' :p = '99,999,999',;
   impuesto1 = IIF(impuesto,"   Si","")           :R:08:H ='Impuesto',;
   nombre2 = nombre                               :R:40:H = 'Nombre',;
   codigo2                                        :R:15:H = 'C¢d.Alternativo',;
   codorig                                        :R:15:H = 'C¢d. Origen' nomodify noappend nodelete

   IF ASCAN(paMaesprod,maestemp.nombre,1) > 0
*     =ASORT(paMaesprod, AELEMENT(paMaesprod,1,2))
      lstMaesprod = ASUBSCRIPT(paMaesprod,ASCAN(paMaesprod,maestemp.nombre,1),1)
   ENDIF
 ELSE
  WAIT WINDOW "­ LOS DATOS BUSCADOS NO HAN SIDO ENCONTRADOS !"
ENDIF
   
SELECT maestemp
USE

DELETE FILE &arch_temp
DELETE FILE SUBSTR(arch_temp, 1, ATC(".", arch_temp))+"CDX"
RELEASE WINDOW BArticuTemp

SELECT maesprod
POP KEY



FUNCTION SaveSearch

SELECT maestemp
APPEND BLANK
REPLACE maestemp.codigo    WITH maesprod.codigo
REPLACE maestemp.codorig   WITH maesprod.codorig
REPLACE maestemp.codigo2   WITH maesprod.codigo2
REPLACE maestemp.nombre    WITH maesprod.nombre
REPLACE maestemp.pventag1  WITH maesprod.pventag1
REPLACE maestemp.pventag2  WITH maesprod.pventag2
REPLACE maestemp.pventag3  WITH maesprod.pventag3
REPLACE maestemp.pventag4  WITH maesprod.pventag4
REPLACE maestemp.pventag5  WITH maesprod.pventag5
REPLACE maestemp.impuesto  WITH maesprod.impuesto
REPLACE maestemp.pimpuesto WITH maesprod.pimpuesto
SELECT maesprod

