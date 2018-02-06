 color_04 = "W+/GR"
 DO l_54a
 SELECT veNdedores
 SET ORDER TO 2
 GOTO TOP
 mvEnd1 = coDigo
 GOTO BOTTOM
 mvEnd2 = coDigo
 DEFINE WINDOW l_54 FROM 05, 03 TO 15, 73 SHADOW TITLE  ;
        ' COMISION A VENDEDORES '
 ACTIVATE WINDOW l_54
 STORE DATE() TO mfEcha1, mfEcha2
 STORE 'N' TO moPcion1
 STORE 'F' TO moPcion2
 STORE 0 TO mnDeb, mnCre, mmOnto, mcOmisionv
 DO WHILE .T.
      @ 01,03 say "DEL VENDEDOR:" get mvend1 pict "999" valid pvendedor(.t.,01,22,32,"mvend1","mcomisionv",.f.,0,0) color &color_04
      @ 02,03 say "AL  VENDEDOR:" get mvend2 pict "999" valid pvendedor(.t.,02,22,32,"mvend2","mcomisionv",.f.,0,0) color &color_04
      @ 04,03 say "DESDE EL:" get mfecha1                                   color &color_04
      @ 05,03 say "HASTA EL:" get mfecha2                                   color &color_04
      @ 07,03 say "INCLUIR DETALLE DE LA VENTA (S/N):" get mopcion1 pict "!" color &color_04
      READ
      IF LASTKEY()=27
           EXIT
      ENDIF
      IF mfEcha1>mfEcha2
           WAIT WINDOW 'LA FECHA FINAL DEBE SER MAYOR QUE LA FECHA INICIAL !'
           LOOP
      ENDIF
      IF  .NOT. (moPcion1='S' .OR. moPcion1='N')
           WAIT WINDOW  ;
                'LA OPCION DE INCLUIR EL DETALLE DE LA VENTA DEBE SER: (S)i o (N)o !'
           LOOP
      ENDIF
      IF  .NOT. (moPcion2='F' .OR. moPcion2='N')
           WAIT WINDOW  ;
                'ORDENADO DEBE SER POR: (F)ECHA DE LA COMPRA O (N)OMBRE DEL CLIENTE !'
           LOOP
      ENDIF
      SELECT veNdedores
      SET ORDER TO 1
      SEEK mvEnd1
      mnOmbre1 = noMbre
      SEEK mvEnd2
      mnOmbre2 = noMbre
      IF esTa_corre()
           DO l_54b
           SELECT clIentes
           SET ORDER TO 1
           SELECT teMporal
           SET ORDER TO 2
           IF moPcion1='S'
                SELECT arTiculos
                SET ORDER TO 1
                SELECT teMporal
                SET RELATION TO arTiculo INTO arTiculos, clIente INTO clIentes ADDITIVE
           ELSE
                SET RELATION TO clIente INTO clIentes
           ENDIF
           GOTO TOP
           DO deStino
           DO CASE
                CASE mdEstino='P'
                     IF deSea_vfr()
                          SET DISPLAY TO VGA50
                     ENDIF
                     IF moPcion1='N'
                          REPORT FORMAT L_54A PREVIEW
                     ELSE
                          REPORT FORMAT L_54B PREVIEW
                     ENDIF
                     SET DISPLAY TO VGA25
                CASE mdEstino='I'
                     WAIT WINDOW  ;
                          'COLOQUE LA LETRA CONDENSADA Y PULSE UNA TECLA P/CONTINUAR...'
                     WAIT WINDOW NOWAIT 'IMPRIMIENDO...'
                     IF moPcion1='N'
                          REPORT FORMAT L_54A TO PRINTER NOCONSOLE
                     ELSE
                          REPORT FORMAT L_54B TO PRINTER NOCONSOLE
                     ENDIF
                     KEYBOARD '{spacebar}'
                     WAIT WINDOW ''
           ENDCASE
           SET RELATION TO
      ENDIF
      STORE DATE() TO mfEcha1, mfEcha2
      SELECT veNdedores
      SET ORDER TO 2
      GOTO TOP
      mvEnd1 = coDigo
      GOTO BOTTOM
      mvEnd2 = coDigo
      CLEAR
 ENDDO
 SELECT teMporal
 USE
 DO boRratm WITH arChi_01
 RELEASE WINDOW l_54
 RELEASE WINDOW l_54
 RETURN
*
PROCEDURE l_54a
 SELECT 0
 arChi_01 = crEatemp()
 create table &archi_01 (cliente    n (7), vendedor   n (3), nombre     c (51), comision   n (6,2), tipodocu   n (1), nrodocu    n (7), fechadocu  d (8), monto_fact n (10), monto_ndeb n (9), monto_ncre n (9), porcdesc   n (6,2), importdesc n (9), dias_plazo n (3), articulo   c (15), cantidad   n (9,2), precio     n (11,2), impuesto   l (1), monto1     n (9), monto2     n (9), tienenota  l (1))
 use &archi_01 alias TEMPORAL exclusive
 index on str(tipodocu,1)+str(nrodocu,7) tag indice1 of &archi_01
 index on nombre+str(vendedor,3)+dtos(fechadocu)+str(tipodocu,1)+str(nrodocu,7) tag indice2 of &archi_01
 SET ORDER TO 1
 RETURN
*
