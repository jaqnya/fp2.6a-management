*здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё  Funci╒n...: Status.                                                   Ё         
*Ё  Parametros: <expC>                                                    Ё      
*Ё  Prop╒sito.: Verificar si la tabla especificada se encuentra en uso.   Ё
*Ё  Valores                                                               Ё
*Ё  Devueltos.: 0 = La tabla no est═ en uso.                              Ё
*Ё              1 = La tabla esta en uso.                                 Ё
*Ё              2 = Error.                                                Ё
*цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
*Ё                     о  Descripci╒n de Parametros  о                    Ё       
*Ё                     ммммммммммммммммммммммммммммммм                    Ё
*Ё  <expC>.: Nombre de la Tabla.                                          Ё       
*цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
*Ё                              о  Ejemplo о                              Ё       
*Ё                              мммммммммммм                              Ё
*Ё  a) do Status with 'C:\TABLAS\TABLA1.DBF'                              Ё
*Ё                                                                        Ё
*Ё  b) =Status('TABLA1.DBF')                                              Ё
*Ё                                                                        Ё
*цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
*Ё  Creado....: 08/06/2003.                                               Ё
*Ё  Modificado: 08/06/2003.                                               Ё
*цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢
*Ё  Autor.....: Turtle Software Paraguay S.R.L.                           Ё
*Ё              Jos┌ Avilio Acu╓a Acosta.                                 Ё
*юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды

PARAMETERS pcTable

pnStatus = 0

IF TYPE("pcTable") # "C"
   WAIT WINDOW "╜ FUNCION  STATUS : TIPO DE PARAMETRO INCORRECTO !"
   pnStatus = 2
ELSE
   IF !FILE(pcTable)
      WAIT WINDOW [╜ LA TABLA "]+pcTable+[" NO EXISTE O FUE REMOVIDA !]
      pnStatus = 2
   ENDIF
ENDIF

IF pnStatus = 0
   pnIdFile = FOPEN(pcTable, 12)
   =FCLOSE(pnIdFile)
   pnStatus = IIF(pnIdFile # -1, 0, 1)
ENDIF

RETURN (pnStatus)