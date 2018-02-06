PROCEDURE articulo

   PRIVATE m.codigo, m.nombre, m.aplicacion, ;
           lAdding, lEditing
           
   PRIVATE cAlias_A, cAlias_B, cAlias_C, cAlias_D, cAlias_E, cAlias_F, cAlias_G, cAlias_H, cAlias_I, cRoute, cSetExact
   cAlias_A = "A" && createmp()  && Alias para la tabla MAESPROD.DBF
   cAlias_B = "b" &&createmp()  && Alias para la tabla FAMILIAS.DBF
   cAlias_C = "c" &&createmp()  && Alias para la tabla RUBROS1.DBF
   cAlias_D = "d" &&createmp()  && Alias para la tabla RUBROS2.DBF
   cAlias_E = "E" &&createmp()  && Alias para la tabla MARCAS1.DBF
   cAlias_F = "F"  &&createmp()  && Alias para la tabla UNIDAD.DBF
   cAlias_G = "G" &&createmp()  && Alias para la tabla PROCEDEN.DBF
   cAlias_H = "H" &&createmp()  && Alias para la tabla PROVEEDO.DBF

   cRoute = IIF(TYPE("cPath") = "U", "", cPath)  && Ruta de acceso
   
   DO openDBFs WITH "MAESPROD"


*-- MS-DOS Definiciones de ventanas.
IF .NOT. WEXIST("brwMaesprod")
   DEFINE WINDOW brwMaesprod ;
      FROM 01,00 ;
      TO   23,79 ;
      TITLE "< ARTICULOS >" ;
      SYSTEM ;
      CLOSE ;
      FLOAT ;
      GROW ;
      MDI ;         
      NOMINIMIZE ;
      SHADOW ;
      ZOOM ;
      COLOR SCHEME 15
ENDIF


SELECT 1




BROWSE WINDOW brwMaesprod FIELDS ;
   calc_f1 = SUBSTR(codigo, 1, 9)                       :R:09:H = "C¢digo" ,;
   calc_f2 = SUBSTR(nombre, 1, 39)                      :R:39:H = "Nombre" ,;
   calc_f3 = IIF(impuesto, "S", "")                     :R:01:H = "",;
   pventag1                                             :R:10:H = "P.Vta 1":P = "99,999,999" ,;
   calc_f4 = ROUND(pventag1 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 1 c/Iva":P = "9,999,999,999" ,;
   pventag2                                             :R:10:H = "P.Vta 2":P = "99,999,999" ,;
   calc_f5 = ROUND(pventag2 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 2 c/Iva":P = "9,999,999,999" ,;
   pventag3                                             :R:10:H = "P.Vta 3":P = "99,999,999" ,;
   calc_f6 = ROUND(pventag3 * (1 + pimpuesto / 100), 0) :R:13:H = "P.Vta 3 c/Iva":P = "9,999,999,999" ,;
   calc_f7 = IIF(impuesto, "   S¡   ", "")              :R:08:H = "Impuesto" ,;
   stock_actu                                           :R:13:H = "Stock Actual":P = "99,999,999.99" ,;  
   calc_f8  = SUBSTR(rubros1.nombre, 1, 30)             :R:30:H = "Rubro" ,;
   calc_f9  = SUBSTR(rubros2.nombre, 1, 30)             :R:30:H = "Sub-Rubro",;   
   calc_f10 = SUBSTR(marcas1.nombre, 1, 30)             :R:30:H = "Marcas",;      
   calc_f11 = SUBSTR(nombre, 1, 40)                     :R:40:H = "Nombre" ,;
   calc_f12 = SUBSTR(codigo2, 1, 15)                    :R:15:H = "C¢d.Alternativo" ,;
   calc_f13 = SUBSTR(codorig, 1, 15)                    :R:15:H = "C¢d. Origen" ;
   NOAPPEND NODELETE NOMODIFY






   DO closeDBFs WITH "MAESPROD"
*ENDPROC
   
PROCEDURE openDBFs
PARAMETERS cModule

   DO CASE
      CASE (ALLTRIM(UPPER(cModule)) = "MAESPROD")
         IF .NOT. (FILE(cRoute + "maesprod.dbf") .OR. FILE(cRoute + "maesprod.cdx"))
            WAIT WINDOW "El archivo '" + ALLTRIM(LOWER(cRoute + "maesprod.dbf")) + "' no existe."
            RETURN 
         ENDIF

         IF .NOT. (FILE(cRoute + "familias.dbf") .OR. FILE(cRoute + "familias.cdx"))
            WAIT WINDOW "El archivo '" + ALLTRIM(LOWER(cRoute + "familias.dbf")) + "' no existe."
            RETURN 
         ENDIF

         IF .NOT. (FILE(cRoute + "rubros1.dbf") .OR. FILE(cRoute + "rubros1.cdx"))
            WAIT WINDOW "El archivo '" + ALLTRIM(LOWER(cRoute + "rubros1.dbf")) + "' no existe."
            RETURN 
         ENDIF

         IF .NOT. (FILE(cRoute + "rubros2.dbf") .OR. FILE(cRoute + "rubros2.cdx"))
            WAIT WINDOW "El archivo '" + ALLTRIM(LOWER(cRoute + "cuotas_v.dbf")) + "' no existe."
            RETURN 
         ENDIF

         IF .NOT. (FILE(cRoute + "marcas1.dbf") .OR. FILE(cRoute + "marcas1.cdx"))
            WAIT WINDOW "El archivo '" + ALLTRIM(LOWER(cRoute + "marcas1.dbf")) + "' no existe."
            RETURN 
         ENDIF

         IF .NOT. (FILE(cRoute + "unidad.dbf") .OR. FILE(cRoute + "unidad.cdx"))
            WAIT WINDOW "El archivo '" + ALLTRIM(LOWER(cRoute + "unidad.dbf")) + "' no existe."
            RETURN 
         ENDIF

         IF .NOT. (FILE(cRoute + "proceden.dbf") .OR. FILE(cRoute + "proceden.cdx"))
            WAIT WINDOW "El archivo '" + ALLTRIM(LOWER(cRoute + "proceden.dbf")) + "' no existe."
            RETURN 
         ENDIF

         IF .NOT. (FILE(cRoute + "proveedo.dbf") .OR. FILE(cRoute + "proveedo.cdx"))
            WAIT WINDOW "El archivo '" + ALLTRIM(LOWER(cRoute + "poroveedo.dbf")) + "' no existe."
            RETURN 
         ENDIF

         SELECT 0
         USE (LOCFILE(cRoute + "maesprod.dbf", "DBF", "¿Donde esta MAESPROD.DBF?")) ;
            AGAIN ALIAS (cAlias_A) SHARED ;
            ORDER TAG indice2

         SELECT 0
         USE (LOCFILE(cRoute + "familias.dbf", "DBF", "¿Donde esta FAMILIAS.DBF?")) ;
            AGAIN ALIAS (cAlias_B) SHARED ;
            ORDER TAG indice1

         SELECT 0
         USE (LOCFILE(cRoute + "rubros1.dbf", "DBF", "¿Donde esta RUBROS1.DBF?")) ;
            AGAIN ALIAS (cAlias_C) SHARED ;
            ORDER TAG indice1
      
         SELECT 0
         USE (LOCFILE(cRoute + "rubros2.dbf", "DBF", "¿Donde esta RUBROS2.DBF?")) ;
            AGAIN ALIAS (cAlias_D) SHARED ;
            ORDER TAG indice1
      
         SELECT 0
         USE (LOCFILE(cRoute + "marcas1.dbf", "DBF", "¿Donde esta MARCAS1.DBF?")) ;
            AGAIN ALIAS (cAlias_E) SHARED ;
            ORDER TAG indice1
      
         SELECT 0
         USE (LOCFILE(cRoute + "unidad.dbf", "DBF", "¿Donde esta UNIDAD.DBF?")) ;
            AGAIN ALIAS (cAlias_F) SHARED ;
            ORDER TAG indice1
      
         SELECT 0
         USE (LOCFILE(cRoute + "proceden.dbf", "DBF", "¿Donde esta PROCEDEN.DBF?")) ;
            AGAIN ALIAS (cAlias_G) SHARED ;
            ORDER TAG indice1
      
         SELECT 0
               USE (LOCFILE(cRoute + "proveedo.dbf", "DBF", "¿Donde esta PROVEEDO.DBF?")) ;
            AGAIN ALIAS (cAlias_H) SHARED ;
            ORDER TAG indice1
   ENDCASE

      
PROCEDURE closedbfs
PARAMETER cModule

DO CASE
   CASE (UPPER(cmODULE) = "MAESPROD")
      USE IN (cAlias_A)
      USE IN (cAlias_B)
      USE IN (cAlias_C)
      USE IN (cAlias_D)
      USE IN (cAlias_E)
      USE IN (cAlias_F)
      USE IN (cAlias_G)
      USE IN (cAlias_H)
   OTHERWISE

ENDCASE





