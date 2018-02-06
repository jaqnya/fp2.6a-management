*:*************************************************************************
*:
*: Archivo de Procedimiento: SQLQuery.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: B£squeda filtrada de informaci¢n.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 09/05/2004
*:
*:*************************************************************************

PARAMETER pcString, pcField
PRIVATE pcTable
pcTable = SUBSTR(pcField, 1, ATC(".", pcField) - 1)

DO CASE
   CASE pcTable = "clientes"
      PUSH KEY CLEAR

      PRIVATE pcCurrWindow, pcExpresion
      pcCurrWindow = WONTOP()

      WAIT WINDOW "BUSCANDO..." NOWAIT

      SELECT 0
      arch_temp = "tm" + SYS(3) + ".dbf"

      CREATE TABLE &arch_temp (codigo     N(05),;
                               nombre     C(56),;
                               saldo_actu N(12),;
                               ruc        C(15),;
                               telefono   C(30),;
                               documento  C(15),;
                               nombre_c   C(50),;
                               docconyuge C(15),;
                               nombre_g   C(50),;
                               docgarante C(15))

      INDEX ON codigo     TAG indice1
      INDEX ON nombre     TAG indice2
      INDEX ON documento  TAG indice3
      INDEX ON nombre_c   TAG indice4
      INDEX ON docconyuge TAG indice5
      INDEX ON nombre_g   TAG indice6
      INDEX ON docgarante TAG indice7

      USE &arch_temp ALIAS clietemp
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
            pcFirst = SUBSTR(pcString, 1, (ATC("*", pcString) - 1))
         ENDIF
      ENDIF

      IF RIGHT(pcString, 1) = "*"
         pnOccurs = OCCURS("*", pcString) - 1
      ELSE
         pnOccurs = OCCURS("*", pcString)
      ENDIF

      pcExpresion = ""
      PRIVATE paString

      IF pnOccurs > 0
         DIMENSION paString(pnOccurs)
      ENDIF

      FOR pnCounter = 1 TO pnOccurs
         paString(pnCounter) = ALLTRIM(SUBSTR(pcString, ATC("*", pcString, pnCounter) + 1, (ATC("*", pcString, pnCounter + 1) - 1) - ATC("*", pcString, pnCounter)))
         IF pnCounter = pnOccurs
            IF RIGHT(pcString, 1) = "*"
               paString(pnCounter) = ALLTRIM(SUBSTR(pcString, ATC("*", pcString, pnCounter) + 1, (ATC("*", pcString, pnCounter + 1) - 1) - ATC("*", pcString, pnCounter)))         
            ELSE
               paString(pnCounter) = ALLTRIM(SUBSTR(pcString, ATC("*", pcString, pnCounter) + 1))
            ENDIF
         ENDIF
      ENDFOR

      FOR pnCounter = 1 TO pnOccurs
         IF pnCounter < pnOccurs
            pcExpresion = pcExpresion + [ATC("] + paString(pnCounter) + [", ] + pcField + [) > 0] + [ .and. ]
         ELSE 
            pcExpresion = pcExpresion + [ATC("] + paString(pnCounter) + [", ] + pcField + [) > 0]
         ENDIF
      ENDFOR

      SELECT clientes

      PRIVATE pcSelect, pcOrder, pnRecNo
      pcSelect = SELECT()
      pcOrder  = ORDER()
      pnRecNo  = IIF(EOF(), 0, RECNO())

      IF pcFirst = ".NULL."
         HIDE WINDOW (pcCurrWindow)
     
         GO TOP
         pnDoCounter = 1
         DO WHILE .NOT. EOF()
            IF EVAL(pcExpresion)
               DO SaveSearch WITH "Clientes"
            ENDIF
            SKIP
            DO progress WITH ((pnDoCounter * 100) / RECCOUNT()), "PROCESANDO: ARTICULOS..."
            pnDoCounter = pnDoCounter + 1
         ENDDO

         SHOW WINDOW (pcCurrWindow)
         RELEASE WINDOW _thermom
      ELSE
         IF SEEK(pcFirst) 
            DO WHILE SUBSTR(&pcField, 1, LEN(ALLTRIM(pcFirst))) = ALLTRIM(pcFirst) .AND. NOT EOF()
               IF pnOccurs = 0
                  DO SaveSearch WITH "Clientes"
               ELSE
                  IF EVAL(pcExpresion)
                     DO SaveSearch WITH "Clientes"
                  ENDIF
               ENDIF
               SKIP
            ENDDO
         ENDIF
      ENDIF
      WAIT CLEAR

      SELECT clietemp
      DO CASE
         CASE pcField = "clientes.codigo"
            SET ORDER TO TAG indice1
         CASE pcField = "clientes.nombre"
            SET ORDER TO TAG indice2
         CASE pcField = "clientes.documento"
            SET ORDER TO TAG indice3
         CASE pcField = "clientes.nombre_c"
            SET ORDER TO TAG indice4
         CASE pcField = "clientes.docconyuge"
            SET ORDER TO TAG indice5
         CASE pcField = "clientes.nombre_g"
            SET ORDER TO TAG indice6
         CASE pcField = "clientes.docgarante"
            SET ORDER TO TAG indice7
      ENDCASE

      IF RECCOUNT() <> 0
         GO TOP
         IF NOT WEXIST ("brwClieTmp")
            DEFINE WINDOW brwClieTmp ;
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

         *-- MS-DOS Macros de teclado.
         ON KEY LABEL "F4" DO cliorden.prg
   
         RELEASE WINDOW (pcCurrWindow)

         BROWSE WINDOW brwClieTmp FIELDS ;
            codigo                              :R:06:H = "C¢digo"             :P = "999999" ,;
            calc_f1 = SUBSTR(nombre, 1, 54)     :R:54:H = "Nombre"             :P = "@!" ,;
            saldo_actu                          :R:14:H = " Saldo Actual"      :P = "99,999,999,999" ,;
            calc_f2 = SUBSTR(ruc, 1, 11)        :R:11:H = "R.U.C." ,;
            calc_f3 = SUBSTR(telefono, 1, 30)   :R:30:H = "Tel‚fono" ,;
            calc_f4 = SUBSTR(documento, 1, 15)  :R:15:H = "Documento Clie" ,;
            calc_f5 = SUBSTR(nombre_c, 1, 50)   :R:50:H = "Nombre del C¢nyuge" :P = "@!" ,;
            calc_f6 = SUBSTR(docconyuge, 1, 15) :R:15:H = "Documento Cony" ,;
            calc_f7 = SUBSTR(nombre_g, 1, 50)   :R:50:H = "Nombre del Garante" :P = "@!" ,;
            calc_f8 = SUBSTR(docgarante, 1, 15) :R:15:H = "Documento Garan" ;
            NOAPPEND NODELETE NOMODIFY


         *-- MS-DOS Restablece macros de teclado.
         ON KEY LABEL "F4" 
   
         SELECT clientes
         PRIVATE pcTag
         pcTag = TAG()
         SET ORDER TO TAG indice1 OF clientes.cdx
         SEEK clietemp.codigo
         SET ORDER TO TAG &pcTag OF clientes.cdx
         RELEASE pcTag
      ELSE
         WAIT WINDOW "­ LOS DATOS BUSCADOS NO HAN SIDO ENCONTRADOS !"
  
         SELECT (pcSelect)
         SET ORDER TO TAG (pcOrder)
         IF pnRecNo # 0
            GOTO RECORD pnRecNo
         ENDIF
      ENDIF
   
      SELECT clietemp
      USE

      DELETE FILE &arch_temp
      DELETE FILE SUBSTR(arch_temp, 1, ATC(".", arch_temp))+"CDX"
      RELEASE WINDOW brwClieTmp

      SELECT clientes
      POP KEY

   CASE pcTable = "ot"
      PUSH KEY CLEAR

      PRIVATE pcCurrWindow, arch_temp, pcExpresion, pcFirst, pnOccurs, paString, pnCounter, pnSelect, pcOrder, pnRecNo, pcTag
      pcCurrWindow = WONTOP()

      WAIT WINDOW "BUSCANDO..." NOWAIT

      SELECT 0
      arch_temp = "tm" + SYS(3) + ".dbf"

      CREATE TABLE &arch_temp (serie      C(01) ,;
                               nroot      N(07) ,;
                               cliente    N(05) ,;
                               nombreot   C(40) ,;
                               contacto   C(40) ,;
                               direcot    C(40) ,;
                               telefot    C(40) ,;
                               cedulaot   C(15) ,;
                               departamen N(03) ,;
                               ciudad     N(05) ,;
                               barrio     N(05) ,;
                               maquina    N(03) ,;
                               marca      N(04) ,;
                               modelo     N(04) ,;
                               accesorio  C(56) ,;
                               motor      C(25) ,;
                               chasis     C(25) ,;
                               mecanico   N(03) ,;
                               chapa      C(25) ,;
                               color      C(15) ,;
                               km         C(07) ,;
                               frecepcion D(08) ,;
                               fpentrega  D(08) ,;
                               trabajo1   C(60) ,;
                               trabajo2   C(60) ,;
                               trabajo3   C(60) ,;                                          
                               fentrega   D(08) ,;
                               estadoot   N(03) ,;
                               tipodocu   N(01) ,;
                               nrodocu    N(07) ,;
                               referencia C(10) ,;
                               localrep   N(01) ,;
                               id_local   N(02))

      INDEX ON serie + STR(nroot, 7)          TAG indice1
      INDEX ON DTOS(frecepcion)               TAG indice2
      INDEX ON DTOS(fentrega)                 TAG indice3
      INDEX ON cliente                        TAG indice4
      INDEX ON nombreot                       TAG indice5
      INDEX ON cedulaot                       TAG indice6
      INDEX ON STR(marca, 4) + STR(modelo, 4) TAG indice7
      INDEX ON estadoot                       TAG indice8 
      INDEX ON chapa                          TAG indice9 
      INDEX ON motor                          TAG indice10
      INDEX ON chasis                         TAG indice11

      USE &arch_temp ALIAS ottemp   
      SET ORDER TO indice5

      SET RELATION TO ottemp.marca    INTO marcas2  ADDITIVE   
      SET RELATION TO ottemp.modelo   INTO modelos  
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
            pcFirst = SUBSTR(pcString, 1, (ATC("*", pcString) - 1))
         ENDIF
      ENDIF

      IF RIGHT(pcString, 1) = "*"
         pnOccurs = OCCURS("*", pcString) - 1
      ELSE
         pnOccurs = OCCURS("*", pcString)
      ENDIF

      pcExpresion = ""

      IF pnOccurs > 0
         DIMENSION paString(pnOccurs)
      ENDIF

      FOR pnCounter = 1 TO pnOccurs
         paString(pnCounter) = ALLTRIM(SUBSTR(pcString, ATC("*", pcString, pnCounter) + 1, (ATC("*", pcString, pnCounter + 1) - 1) - ATC("*", pcString, pnCounter)))
         IF pnCounter = pnOccurs
            IF RIGHT(pcString, 1) = "*"
               paString(pnCounter) = ALLTRIM(SUBSTR(pcString, ATC("*", pcString, pnCounter) + 1, (ATC("*", pcString, pnCounter + 1) - 1) - ATC("*", pcString, pnCounter)))         
            ELSE
               paString(pnCounter) = ALLTRIM(SUBSTR(pcString, ATC("*", pcString, pnCounter) + 1))
            ENDIF
         ENDIF
      ENDFOR

      FOR pnCounter = 1 TO pnOccurs
         IF pnCounter < pnOccurs
            pcExpresion = pcExpresion + [ATC("] + paString(pnCounter) + [", ] + pcField + [) > 0] + [ .and. ]
         ELSE 
            pcExpresion = pcExpresion + [ATC("] + paString(pnCounter) + [", ] + pcField + [) > 0]
         ENDIF
      ENDFOR

      SELECT ot         

      pnSelect = SELECT()
      pcOrder  = ORDER()
      pnRecNo  = IIF(EOF(), 0, RECNO())

      IF pcFirst = ".NULL."
         HIDE WINDOW (pcCurrWindow)
     
         GO TOP
         pnCounter = 1

         SCAN ALL 
            IF EVAL(pcExpresion)
               DO SaveSearch WITH "Ot"
            ENDIF
            DO progress WITH ((pnCounter * 100) / RECCOUNT()), "PROCESANDO: ORDENES DE TRABAJO..."
            pnCounter = pnCounter + 1
         ENDSCAN

         SHOW WINDOW (pcCurrWindow)
         RELEASE WINDOW _thermom         
      ELSE
         IF SEEK(pcFirst) 
            SCAN WHILE SUBSTR(&pcField, 1, LEN(ALLTRIM(pcFirst))) = ALLTRIM(pcFirst)
               IF pnOccurs = 0
                  DO SaveSearch WITH "Ot"
               ELSE
                  IF EVAL(pcExpresion)
                     DO SaveSearch WITH "Ot"
                  ENDIF
               ENDIF
            ENDSCAN
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
               SYSTEM ;
               CLOSE ;
               NOFLOAT ;
               GROW ;
               MDI ;         
               NOMINIMIZE ;
               SHADOW ;
               ZOOM ;
               COLOR "W+/BG,GR+/RB,GR+/B,GR+/B,R+/B,W+/GR,GR+/RB,,," 
         ENDIF

         RELEASE WINDOW (pcCurrWindow)

         *-- MS-DOS Macros de teclado.
         ON KEY LABEL "F4" DO otorden2.prg
         ON KEY LABEL "CTRL+ENTER" DO ot1c.prg
   
         BROWSE WINDOW brwOTsTemp FIELDS ;
            calc_f1 = serie+STR(nroot, 8)                  :R:09:H = " OT N§ " ,;
            frecepcion                                     :R:11:H = "F.Recepci¢n" ,;
            fentrega                                       :R:10:H = "F.Entrega" ,;
            calc_f2 = SUBSTR(marcas2.nombre, 1, 10)        :R:10:H = "Marca" ,;
            calc_f3 = SUBSTR(modelos.nombre, 1, 06)        :R:06:H = "Modelo" ,;
            calc_f4 = LOWER(SUBSTR(estadoot.nombre, 1, 9)) :R:09:H = "Estado" ,;
            calc_f5 = SUBSTR(nombreot, 1, 30)              :R:30:H = "Cliente" ,;
            accesorio                                      :R:56:H = "Accesorio(s)" ,;
            chapa                                          :R:25:H = "Chapa" ,;
            motor                                          :R:25:H = "Motor" ,;
            chasis                                         :R:25:H = "Chasis" ;
            NOMODIFY NOAPPEND NODELETE 

         *-- MS-DOS Restablece macros de teclado.
         ON KEY LABEL "F4" 
         ON KEY LABEL "CTRL+ENTER"
   
         *-- B£sca la OT sobre la cual se ha posicionado el cursor en la ventana de 
         *-- inspecci¢n de RESULTADOS DE LA BUSQUEDA.
         SELECT ot
         pcTag = TAG()
         SET ORDER TO TAG indice1 OF ot.cdx
         SEEK ottemp.serie + STR(ottemp.nroot, 7)
         SET ORDER TO TAG &pcTag OF ot.cdx

      ELSE
         WAIT WINDOW "­ LOS DATOS BUSCADOS NO HAN SIDO ENCONTRADOS !"
  
         SELECT (pnSelect)
         SET ORDER TO TAG (pcOrder)
         IF pnRecNo <> 0
            GOTO RECORD pnRecNo
         ENDIF
      ENDIF
   
      SELECT ottemp
      USE

      DELETE FILE &arch_temp
      DELETE FILE SUBSTR(arch_temp, 1, ATC(".", arch_temp))+"CDX"
      RELEASE WINDOW brwOTsTemp

      SELECT ot        
      POP KEY
ENDCASE

*-- Procedimientos y funciones del soporte.
*!*************************************************************************
*!
*!      Funci¢n: SaveSearch
*!
*!  Llamado por: SQLQuery.PRG                 
*!
*!  Descripci¢n: Graba los datos del registro seleccionado en la tabla 
*!               temporal.
*!
*!*************************************************************************
FUNCTION SaveSearch
PARAMETER cWhatTable

DO CASE 
   CASE cWhatTable = "Clientes"
      SCATTER MEMVAR MEMO FIELDS codigo, nombre, saldo_actu, ruc, telefono, documento, nombre_c, docconyuge, nombre_g, docgarante
      INSERT INTO clietemp (codigo, nombre, saldo_actu, ruc, telefono, documento, nombre_c, docconyuge, nombre_g, docgarante) ;
         VALUES (m.codigo, m.nombre, m.saldo_actu, m.ruc, m.telefono, m.documento, m.nombre_c, m.docconyuge, m.nombre_g, m.docgarante)
   CASE cWhatTable = "Ot"
      SCATTER MEMVAR MEMO 
      INSERT INTO ottemp (serie, nroot, cliente, nombreot, contacto, direcot, telefot, cedulaot, departamen, ciudad, barrio, maquina, marca, modelo, accesorio, motor, chasis, mecanico, chapa, color, km, frecepcion, fpentrega, trabajo1, trabajo2, trabajo3, fentrega, estadoot, tipodocu, nrodocu, referencia, localrep, id_local) ;
         VALUES (m.serie, m.nroot, m.cliente, m.nombreot, m.contacto, m.direcot, m.telefot, m.cedulaot, m.departamen, m.ciudad, m.barrio, m.maquina, m.marca, m.modelo, m.accesorio, m.motor, m.chasis, m.mecanico, m.chapa, m.color, m.km, m.frecepcion, m.fpentrega, m.trabajo1, m.trabajo2, m.trabajo3, m.fentrega, m.estadoot, m.tipodocu, m.nrodocu, m.referencia, m.localrep, m.id_local)
ENDCASE