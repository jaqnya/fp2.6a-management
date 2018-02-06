PARAMETER pcString, pcField

PRIVATE pcCurrWindow
pcCurrWindow = WONTOP()


PUSH KEY CLEAR
WAIT WINDOW "BUSCANDO..." NOWAIT
SELECT 0
arch_temp = "tm"+SYS(3)+".dbf"
CREATE TABLE &arch_temp (serie      C(01),;
                         nroot      N(07),;
                         cliente    N(05),;
                         nombreot   C (40),;
                         contacto   C(40),;
                         direcot    C(40),;
                         telefot    C(40),;
                         cedulaot   C(10),;
                         ciudadot   N(05),;
                         marca      N(04),;
                         modelo     N(04),;
                         maquina    C(56),;
                         maquina2   C(56),;
                         motor      C(25),;
                         chasis     C(25),;
                         mecanico   N(03),;
                         chapa      C(25),;
                         color      C(25),;
                         km         C(07),;
                         frecepcion D(08),;
                         fpentrega  D(08),;
                         trabajo1   C(60),;
                         trabajo2   C(60),;
                         trabajo3   C(60),;                                                  
                         fentrega   D(08),;
                         estadoot   N(03),;
                         tipodocu   N(01),;
                         nrodocu    N(07),;
                         referencia C(10),;
                         localrep   N(01))
                         
INDEX ON serie + STR(nroot, 7)            TAG indice1 
INDEX ON frecepcion                       TAG indice2 
INDEX ON fentrega                         TAG indice3
INDEX ON cliente                          TAG indice4 
INDEX ON nombreot                         TAG indice5 
INDEX ON cedulaot                         TAG indice6
INDEX ON STR(marca, 4) + STR(modelo, 4)   TAG indice7 
INDEX ON estadoot                         TAG indice8
INDEX ON chapa                            TAG indice9 
INDEX ON motor                            TAG indice10 
INDEX ON chasis                           TAG indice11

USE &arch_temp ALIAS ottemp
SET ORDER TO indice5

SET RELATION TO ottemp.marca    INTO marcas   ADDITIVE
SET RELATION TO ottemp.modelo   INTO modelos  ADDITIVE
SET RELATION TO ottemp.estadoot INTO estadoot ADDITIVE



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
*     pcExpresion = pcExpresion + [ATC("]+paString(pnCounter)+[", ot.nombre) > 0] + [ .and. ]
      pcExpresion = pcExpresion + [ATC("]+paString(pnCounter)+[", ]+ pcField + [) > 0] + [ .and. ]
   ELSE 
      pcExpresion = pcExpresion + [ATC("]+paString(pnCounter)+[", ]+ pcField + [) > 0]
*      pcExpresion = pcExpresion + [ATC("]+paString(pnCounter)+[", ot.nombre) > 0]
   ENDIF
ENDFOR

SELECT ot
SET ORDER TO TAG indice5

IF pcFirst = ".NULL."
   HIDE WINDOW (pcCurrWindow)

   GO TOP
   pnDoCounter = 1
   DO WHILE .NOT. EOF()
*     wait window "PROCESANDO: " + ALLTRIM(transFORm(nDoCounter, "9,999,999")) + "/" + ALLTRIM(transFORm(reccount(), "9,999,999")) nowait
      IF EVAL(pcExpresion)
         =SaveSearch()
      ENDIF
      SKIP
      DO progress WITH ((pnDoCounter*100)/RECCOUNT()), "PROCESANDO: ORDENES DE TRABAJO..."
      pnDoCounter = pnDoCounter + 1
   ENDDO
   RELEASE WINDOW _thermom
ELSE
   IF SEEK(pcFirst) 
      DO WHILE SUBSTR(&pcField, 1, LEN(ALLTRIM(pcFirst))) = ALLTRIM(pcFirst) .AND. NOT EOF()
*     DO WHILE SUBSTR(ot.nombre,1, LEN(ALLTRIM(pcFirst))) = ALLTRIM(pcFirst) .AND. NOT EOF()
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

SELECT ottemp
DO CASE
   CASE pcField = "ot.nombreot"
      SET ORDER TO TAG indice5
   OTHERWISE 
      SET ORDER TO TAG indice1
ENDCASE


IF RECCOUNT() # 0
   GO TOP
   IF NOT WEXIST ("brwOTsTemp")
      DEFINE WINDOW brwOTsTemp ;
         FROM 01,00 ;
         TO 23,79 ;
         TITLE " < RESULTADOS DE LA BUSQUEDA: " + pcString + " > " ;
         FLOAT ;
         GROW ;
         CLOSE ;
         NOSHADOW ;
         NOMINIMIZE ;
         ZOOM ;
         SYSTEM ;
         COLOR "W+/BG,GR+/RB,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,,," 
   ENDIF

   RELEASE WINDOW (pcCurrWindow)

   *-- MS-DOS Macros de teclado.
   ON KEY LABEL "F4" DO otorden2.prg

   BROWSE WINDOW brwOTsTemp FIELDS ;
      calc_f1 = serie+STR(nroot, 8)                  :R:09:H = " OT N§ " ,;
      frecepcion                                     :R:11:H = "F.Recepci¢n" ,;
      fentrega                                       :R:10:H = "F.Entrega" ,;
      calc_f2 = SUBSTR(marcas.nombre, 1, 10)         :R:10:H = "Marca" ,;
      calc_f3 = SUBSTR(modelos.nombre, 1, 06)        :R:06:H = "Modelo" ,;
      calc_f4 = LOWER(SUBSTR(estadoot.nombre, 1, 9)) :R:09:H = "Estado" ,;
      calc_f5 = SUBSTR(nombreot, 1, 30)              :R:30:H = "Cliente" ,;
      maquina                                        :R:56:H = "Accesorio(s)" ,;
      chapa                                          :R:25:H = "Chapa" ,;
      motor                                          :R:25:H = "Motor" ,;
      chasis                                         :R:25:H = "Chasis" nomodify noappend nodelete 


   *-- MS-DOS Restablece macros de teclado.
   ON KEY LABEL "F4" 
   
   SELECT ot
   PRIVATE pcTag
   pcTag = TAG()
   SET ORDER TO TAG indice1 OF ot.cdx
   SEEK ottemp.serie + STR(ottemp.nroot, 7)
   SET ORDER TO TAG &pcTag OF ot.cdx
   RELEASE pcTag
ELSE
   WAIT WINDOW "­ LOS DATOS BUSCADOS NO HAN SIDO ENCONTRADOS !"
ENDIF
   
SELECT ottemp
USE

DELETE FILE &arch_temp
DELETE FILE SUBSTR(arch_temp, 1, ATC(".", arch_temp))+"CDX"
RELEASE WINDOW brwOTsTemp

SELECT ot
POP KEY



FUNCTION SaveSearch

SCATTER MEMVAR
SELECT ottemp
APPEND BLANK
GATHER MEMVAR
SELECT ot

