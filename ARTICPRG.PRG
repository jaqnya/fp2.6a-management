*ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
*³  Programa..: Articulo.                                                 ³         
*³  Parametros: <expN>                                                    ³      
*³  Prop¢sito.: Manipular informaci¢n de una tabla.                       ³
*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*³                     Ï  Descripci¢n de Parametros  Ï                    ³       
*³                     ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ                    ³
*³  <expN>.: Numero de la opci¢n a ejecutar.                              ³       
*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*³                        Ï  Posibles Paramentros  Ï                      ³       
*³                        ÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ                      ³
*³  0: Abre una ventana de inspecci¢n.                                    ³       
*³  1: Ayuda.                                                             ³       
*³  2: Agregar.                                                           ³       
*³  3: Modificar.                                                         ³       
*³  4: Ordenar.                                                           ³       
*³  5: Buscar.                                                            ³       
*³  8: Borrar.                                                            ³       
*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*³                              Ï  Ejemplo Ï                              ³       
*³                              ÍÍÍÍÍÍÍÍÍÍÍÍ                              ³
*³  a) do Articulo with 0                                                 ³
*³                                                                        ³
*³  b) =Articulo(0)                                                       ³
*³                                                                        ³
*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*³  Creado....: 08/06/2003.                                               ³
*³  Modificado: 08/06/2003.                                               ³
*ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´
*³  Autor.....: Turtle Software Paraguay S.R.L.                           ³
*³              Jos‚ Avilio Acu¤a Acosta.                                 ³
*ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

parameter nOpcion
push key clear

do case
   case nOpcion == 0
*
*      save screen to ScreenImagen
*      do fondo02.prg
*      do helpbar with 2

*      if seek(str(nUserCode,4)+str(22,3))
*         if usop.f2 == "X"
*            on key label "F2" do depar with 2
*            @ 24,09 say "Agregar" color w/n
*         endif
*         if usop.f3 == "X"
*            on key label "F3" do depar with 3
*            @ 24,17 say "Modif." color w/n
*         endif
 *        if usop.f8 == "X"
*            on key label "F8" do depar with 8
*            @ 24,57 say "Borrar" color w/n
*         endif

         on key label "F4" do artorden.spr
         @ 24,25 say "Ordenar" color w/n

         on key label "F5" do arswitch.prg
         @ 24,33 say "Buscar" color w/n

*      endif


      if used("maesprod")
         select maesprod   
         set order to tag "indice2" of maesprod.cdx
      else
         select 0
         use (locfile("maesprod.dbf","DBF","¨ D¢nde est  MAESPROD.DBF ?"));
            again alias maesprod shared ;
            order tag "indice2" of maesprod.cdx
      endif

      if used("marcas")
         select marcas   
         set order to tag "indice2" of marcas.cdx
      else
         select 0
         use (locfile("marcas.dbf","DBF","¨ D¢nde est  MARCAS.DBF ?"));
            again alias marcas shared ;
            order tag "indice2" of marcas.cdx
      endif

      if used("rubros1")
         select rubros1  
         set order to tag "indice2" of rubros1.cdx
      else
         select 0
         use (locfile("rubros1.dbf","DBF","¨ D¢nde est  RUBROS1.DBF ?"));
            again alias rubros1 shared ;
            order tag "indice2" of rubros1.cdx
      endif

      if used("rubros2")
         select rubros2  
         set order to tag "indice2" of rubros2.cdx
      else
         select 0
         use (locfile("rubros2.dbf","DBF","¨ D¢nde est  RUBROS2.DBF ?"));
            again alias rubros2 shared ;
            order tag "indice2" of rubros2.cdx
      endif

      if used("familias")
         select familias 
         set order to tag "indice2" of familias.cdx
      else
         select 0
         use (locfile("familias.dbf","DBF","¨ D¢nde est  FAMILIAS.DBF ?"));
            again alias familias shared ;
            order tag "indice2" of familias.cdx
      endif

      select maesprod

      set relation to maesprod.familia  into familias additive
      set relation to maesprod.rubro    into rubros1  additive
      set relation to maesprod.subrubro into rubros2  additive
      set relation to maesprod.marca    into marcas   additive

      if not wexist ("b_articulo")
         define window b_articulo ;
            from 01,00 ;
            to 23,79 ;
            title " < ARTICULOS > " ;
            float ;
            grow ;
            close ;
            noshadow ;
            nominimize ;
            zoom ;
            system ;
            color scheme 16
      endif

      browse window b_articulo fields;
      codigo                                         :r:09:h = 'C¢digo',;
      nombre                                         :r:39:h = 'Nombre',;
      impuesto = ((iif(impuesto = .t.,'S','')))      :r:01:h='',;
      pventag1                                       :r:10:h='P.Vta 1' :p = '99,999,999',;
      precio1 = (round((pventag1 * 1.1),0))          :r:13:h='P.Vta 1 c/Iva' :p = '99,999,999',;
      pventag2                                       :r:10:h='P.Vta 2' :p = '99,999,999',;
      precio2 = (round((pventag2 * 1.1),0))          :r:13:h='P.Vta 2 c/Iva' :p = '99,999,999',;
      pventag3                                       :r:10:h='P.Vta 3' :p = '99,999,999',;
      precio3 = (round((pventag3 * 1.1),0))          :r:13:h='P.Vta 3 c/Iva' :p = '99,999,999',;
      impuesto1 = ((iif(impuesto = .t.,'   Si',''))) :r:08:h='Impuesto',;
      stock_actu                                     :r:13:h='Stock Actual' :p = '99,999,999.99',;
      familias->nombre                               :r:30:h = 'Familia',;
      rubros1->nombre                                :r:30:h = 'Rubro',;
      rubros2->nombre                                :r:30:h = 'Sub-Rubro',;
      marcas->nombre                                 :r:30:h = 'Marcas',;
      nombre2 = nombre                               :r:40:h = 'Nombre',;
      codigo2                                        :r:15:h = 'C¢d.Alternativo',;
      codorig                                        :r:15:h = 'C¢d. Origen' nomodify noappend nodelete

      release window b_articulo
*      restore screen from ScreenImagen

      if used("maesprod")
         select maesprod
         use
      endif

      if used("marcas")
         select marcas
         use
      endif

      if used("rubros1")
         select rubros1
         use
      endif

      if used("rubros2")
         select rubros2
         use
      endif

      if used("familias")
         select familias
         use
      endif


      pop key
      return

   case nOpcion == 4 && Muestra las opciones de ordenado para la b£squeda.

      if not wexist ("p_orden")
         define window p_orden ;
            from 07,29 ;
            to 14,48 ;
            title " ORDENAR POR " ;
            nofloat ;
            nogrow ;
            noclose ;
            noshadow ;
            nominimize ;
            nozoom ;
            color scheme 16
      endif

      if wvisible("p_orden")
         activate window p_orden same
      else
         activate window p_orden noshow 
      endif

      set color to 'n/w'
      @ 00,00,05,17 box
      set color to 

      do while .t.
         store 0 to nOption

         @ 01,01 prompt ' 1. CODIGO      ' color &color_03
         @ 02,01 prompt ' 2. NOMBRE      ' color &color_03
         @ 03,01 prompt ' 3. COD. ALTER. ' color &color_03 
         @ 04,01 prompt ' 4. COD. ORIGEN ' color &color_03

         if not wvisible("p_orden")
            activate window p_orden
         endif

         menu to nOption

         do case
            case nOption == 0
               release window p_orden
               pop key
               return
            case nOption == 1
               set order to indice1
               release window p_orden
               pop key
               return
            case nOption == 2
               set order to indice2
               release window p_orden
               pop key
               return
            case nOption == 3
               set order to indice6
               release window p_orden
               pop key
               return
            case nOption == 4
               set order to indice7
               release window p_orden
               pop key
               return
         endcase
      enddo
   
   case nOpcion == 5 && Busca la informaci¢n solicitada. 

      do case
         case order() == 'INDICE1'   && B£squeda por C¢digo de la Empresa.

            private nRecno
            store recno() to nRecno

            if !fstatus("maesprod")
               wait window "­ LA TABLA ESTA VACIA, NO SE PUEDE REALIZAR BUSQUEDAS !"
               pop key
               return
            endif

            if not wexist ("d_BuscaCodigo")
               define window d_BuscaCodigo ;
                  from 08,25 ;
                  to 10,54 ;
                  title " BUSQUEDA POR " ;
                  nofloat ;
                  nogrow ;
                  noclose ;
                  noshadow ;
                  nominimize ;
                  nozoom ;
                  color &color_01
            endif

            if wvisible("d_BuscaCodigo")
               activate window d_BuscaCodigo same
            else
               activate window d_BuscaCodigo noshow 
            endif

            private BuscaCodigo
     
            @ 00,02 say "CODIGO:" ;
               size 1,7, 0 ;
               color &cText

            @ 00,10 get BuscaCodigo ;
               size 1,15 ;
               default " " ;
               function "@T" ;
               color &cField 
  
            if not wvisible("d_BuscaCodigo")
               activate window d_BuscaCodigo
            endif

            read color ,&cRead
      
            release window d_BuscaCodigo

            if lastkey() == 27
               go nRecno
               pop key
               return
            endif
   
            if not empty(BuscaCodigo)
               if seek(upper(BuscaCodigo))
                  pop key
                  return
               else
                  wait window "­ LOS DATOS BUSCADOS NO HAN SIDO ENCONTRADOS !"
                  go nRecno
                  pop key
                  return 
               endif
            else
               go nRecno
               pop key
               return
            endif

         case order() == 'INDICE2'   && B£squeda por Nombre.

            private nRecno
            store recno() to nRecno

            if !fstatus("maesprod")
               wait window "­ LA TABLA ESTA VACIA, NO SE PUEDE REALIZAR BUSQUEDAS !"
               pop key
               return
            endif

            if not wexist ("d_BuscaNombre")
               define window d_BuscaNombre ;
                  from 08,13 ;
                  to 10,66 ;
                  title " BUSQUEDA POR " ;
                  nofloat ;
                  nogrow ;
                  noclose ;
                  noshadow ;
                  nominimize ;
                  nozoom ;
                  color &color_01
            endif

            if wvisible("d_BuscaNombre")
               activate window d_BuscaNombre same
            else
               activate window d_BuscaNombre noshow 
            endif

            private BuscaNombre
                 
            @ 00,02 say "NOMBRE:" ;
               size 1,7, 0 ;
               color &cText

            @ 00,10 get BuscaNombre ;
               size 1,40 ;
               default " " ;
               function "@T" ;
               color &cField
  
            if not wvisible("d_BuscaNombre")
               activate window d_BuscaNombre
            endif

            read color ,&cRead
      
            release window d_BuscaNombre

            if lastkey() == 27
               go nRecno
               pop key
               return 
            endif
   
            if not empty(BuscaNombre)
               if occurs("*",BuscaNombre) > 0
                  do search with BuscaNombre
                  go nRecno
                  pop key
                  return
               endif
               if seek(upper(BuscaNombre))
                  pop key
                  return
               else
                  wait window "­ LOS DATOS BUSCADOS NO HAN SIDO ENCONTRADOS !"
                  go nRecno
                  pop key
                  return 
               endif
            else
               go nRecno
               pop key
               return
            endif

         case order() == 'INDICE6'   && B£squeda por C¢digo Alternativo.

            private nRecno
            store recno() to nRecno

            if !fstatus("maesprod")
               wait window "­ LA TABLA ESTA VACIA, NO SE PUEDE REALIZAR BUSQUEDAS !"
               pop key
               return
            endif

            if not wexist ("d_BuscaCodAlt")
               define window d_BuscaCodAlt ;
                  from 08,19 ;
                  to 10,60 ;
                  title " BUSQUEDA POR " ;
                  nofloat ;
                  nogrow ;
                  noclose ;
                  noshadow ;
                  nominimize ;
                  nozoom ;
                  color &color_01
            endif

            if wvisible("d_BuscaCodAlt")
               activate window d_BuscaCodAlt same
            else
               activate window d_BuscaCodAlt noshow 
            endif

            private BuscaCodAlt

            @ 00,02 say "CODIGO ALTERNATIVO:" ;
               size 1,19, 0 ;
               color &cText

            @ 00,22 get BuscaCodAlt ;
               size 1,15 ;
               default " " ;
               function "@T" ;
               color &cField
  
            if not wvisible("d_BuscaCodAlt")
               activate window d_BuscaCodAlt
            endif

            read color ,&cRead
      
            release window d_BuscaCodAlt

            if lastkey() == 27
               go nRecno
               pop key
               return 
            endif
   
            if not empty(BuscaCodAlt)
               if seek(upper(BuscaCodAlt))
                  pop key
                  return
               else
                  wait window "­ LOS DATOS BUSCADOS NO HAN SIDO ENCONTRADOS !"
                  go nRecno
                  pop key
                  return 
               endif
            else
               go nRecno
               pop key
               return
            endif

         case order() == 'INDICE7'   && B£squeda por C¢digo de Origen.

            private nRecno
            store recno() to nRecno

            if !fstatus("maesprod")
               wait window "­ LA TABLA ESTA VACIA, NO SE PUEDE REALIZAR BUSQUEDAS !"
               pop key
               return
            endif

            if not wexist ("d_BuscaCodOrig")
               define window d_BuscaCodOrig ;
                  from 08,20 ;
                  to 10,59 ;
                  title " BUSQUEDA POR " ;
                  nofloat ;
                  nogrow ;
                  noclose ;
                  noshadow ;
                  nominimize ;
                  nozoom ;
                  color &color_01
            endif

            if wvisible("d_BuscaCodOrig")
               activate window d_BuscaCodOrig same
            else
               activate window d_BuscaCodOrig noshow 
            endif

            private BuscaCodOrig
                 
            @ 00,02 say "CODIGO DE ORIGEN:" ;
               size 1,17, 0 ;
               color &cText

            @ 00,20 get BuscaCodOrig ;
               size 1,15 ;
               default " " ;
               function "@T" ;
               color &cField
  
            if not wvisible("d_BuscaCodOrig")
               activate window d_BuscaCodOrig
            endif

            read color ,&cRead
      
            release window d_BuscaCodOrig

            if lastkey() == 27
               go nRecno
               pop key
               return 
            endif

            if not empty(BuscaCodOrig)
               if seek(upper(BuscaCodOrig))
                  pop key
                  return
               else
                  wait window "­ LOS DATOS BUSCADOS NO HAN SIDO ENCONTRADOS !"
                  go nRecno
                  pop key
                  return 
               endif
            else
               go nRecno
               pop key
               return
            endif
   endcase
endcase









