*:**************************************************************************
*:
*: Archivo de Procedimiento: MNUCYCLE.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Controlador de Men£.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 20/04/2004
*:
*:**************************************************************************
PRIVATE pcChoice
pcChoice = ""

DO WHILE .T.
   IF mdemo
      DO modules2.spr WITH "pcChoice"
   ELSE
      DO modules.spr WITH "pcChoice"
   ENDIF
   
   IF LASTKEY() = 27
      SET EXACT OFF
      EXIT DO 
   ENDIF
   DO CASE
      CASE pcChoice = "tables.spr"     &&  Tablas.
         IF UserConfig("tables.spr", "Access", .T.)
            DO WHILE .T.
               DO tables.spr WITH "pcChoice"
               IF LASTKEY() = 27
                  EXIT DO 
               ENDIF  
               DO CASE
                  CASE pcChoice = "brwFamil.prg"     &&  Familias.
                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwFamil.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwRubr1.prg"     &&  Rubros.
                     IF UserConfig("brwRubr1.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwRubr1.prg
 
                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwRubr2.prg"     &&  Sub-Rubros.
                     IF UserConfig("brwRubr2.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwRubr2.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwMarc1.prg"     &&  Marcas para art¡culos.
                     IF UserConfig("brwMarc1.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwMarc1.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwProce.prg"     &&  Procedencias.
                     IF UserConfig("brwProce.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwProce.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwMaqui.prg"     && M quinas.
                     IF UserConfig("brwMaqui.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwMaqui.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwMarc2.prg"     &&  Marcas para ordenes de trabajo.
                     IF UserConfig("brwMarc2.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwMarc2.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwModel.prg"     &&  Modelos.
                     IF UserConfig("brwModel.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwModel.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwMoned.prg"     &&  Monedas.
                     IF UserConfig("brwMoned.prg", "Access", .T.)
                        DO SaveScreen
                       @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwMoned.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwDepar.prg"     &&  Departamentos.
                     IF UserConfig("brwDepar.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)
  
                        DO brwDepar.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwCiuda.prg"     &&  Ciudades.
                     IF UserConfig("brwCiuda.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwCiuda.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwBarri.prg"     &&  Barrios.
                     IF UserConfig("brwBarri.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwBarri.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwMecan.prg"     &&  Mec nicos.
                     IF UserConfig("brwMecan.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwMecan.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwServi.prg"     &&  Servicios.
                     IF UserConfig("brwServi.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwServi.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwVende.prg"     &&  Vendedores.
                     IF UserConfig("brwVende.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwVende.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwCobra.prg"     &&  Cobradores.
                     IF UserConfig("brwCobra.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwCobra.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwEstOt.prg"     &&  Estados de la OT.
                     IF UserConfig("brwEstOt.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwEstOt.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwUnida.prg"     &&  Unidades de medida.
                     IF UserConfig("brwUnida.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwUnida.prg
 
                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwMotNo.prg"     &&  Motivos de la notas.
                     IF UserConfig("brwMotNo.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwMotNo.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwMotCl.prg"     &&  Motivos de ser cliente.
                     IF UserConfig("brwMotCl.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwMotCl.prg

                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwLocal.prg"     &&  Locales de la Empresa.
                     IF UserConfig("brwLocal.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwLocal.prg
   
                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "brwUsuar.prg"     &&  Usuarios y permisos.   
                     IF UserConfig("brwUsuar.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwUsuar.prg
   
                        DO RestoreScreen
                     ENDIF
                  CASE pcChoice = "ofertas.prg"     &&  Ofertas.
                     DO ofertas.prg
               ENDCASE
            ENDDO
         ENDIF
      CASE pcChoice = "brwMaesp.prg"     &&  Art¡culos.
         IF UserConfig("brwMaesp.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO brwMaesp.prg

            DO RestoreScreen
         ENDIF
      CASE pcChoice = "brwAjust.prg"     &&  Ajustes de Inventario.
         IF UserConfig("brwAjust.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO brwAjust.prg

            DO RestoreScreen
         ENDIF
      CASE pcChoice = "brwClien.prg"
         IF UserConfig("brwClien.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO brwClien.prg

            DO RestoreScreen
         ENDIF
      CASE pcChoice = "5"
      CASE pcChoice = "6"
      CASE pcChoice = "ventas.prg"
         IF UserConfig("ventas.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO ventas.prg

            DO RestoreScreen
         ENDIF
      CASE pcChoice = "pedidoc.prg"
         DO pedidoc.prg
      CASE pcChoice = "ped_usd.prg"
         IF gnUser = 1 THEN
            DO ped_usd.prg
         ENDIF
      CASE pcChoice = "notaclie.prg"
         IF UserConfig("notaclie.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO notaclie.prg

            DO RestoreScreen
         ENDIF
      CASE pcChoice = "moviot1a.prg"
         IF UserConfig("moviot.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO moviot1a.prg

            DO RestoreScreen
         ENDIF
      CASE pcChoice = "moviot1b.prg"
         IF UserConfig("moviot.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO moviot1b.prg

            DO RestoreScreen
         ENDIF
      CASE pcChoice = "10"
      CASE pcChoice = "brwCobro.prg"  && Cobros a Clientes.
         IF UserConfig("brwCobro.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO brwCobro.prg

            DO RestoreScreen
         ENDIF
      CASE pcChoice = "12"
         DO ot
      CASE pcChoice = "brwProve.prg"     &&  Proveedores.
         IF UserConfig("brwProve.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO brwProve.prg

            DO RestoreScreen
         ENDIF
      CASE pcChoice = "compras.prg"      &&  Compras.
         IF UserConfig("compras.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO compras.prg

            DO RestoreScreen
         ENDIF
      CASE pcChoice = "importa.prg"      &&  Importaciones.
*        IF UserConfig("compras.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO importa.prg

            DO RestoreScreen
*        ENDIF
      CASE pcChoice = "brwPagos.prg"     &&  Pagos a Proveedores.
         IF UserConfig("brwPagos.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO brwPagos.prg

            DO RestoreScreen
         ENDIF
      CASE pcChoice = "notaprov.prg"     &&  Nota de Deb./Cred. de Proveedores.
         IF UserConfig("notaprov.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO notaprov.prg

            DO RestoreScreen
         ENDIF
      CASE pcChoice = "brwot.prg"
         IF UserConfig("brwOt.prg", "Access", .T.)
            DO SaveScreen
            @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

            DO brwOt.prg

            DO RestoreScreen
         ENDIF
      CASE pcChoice = "garantia.spr"     &&  M quinas en Garant¡a
         IF UserConfig("tables.spr", "Access", .T.)
            DO WHILE .T.
               DO garantia.spr WITH "pcChoice"
               IF LASTKEY() = 27
                  EXIT DO 
               ENDIF  
               DO CASE
                  CASE pcChoice = "brwOt2.prg"     &&  Familias.
*                    IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO brwOt2.prg

                        DO RestoreScreen
*                    ENDIF
                  CASE pcChoice = "moviot2.prg"     &&  Rubros.
                     IF UserConfig("brwRubr1.prg", "Access", .T.)
                        DO SaveScreen
                        @ 05,05,19,74 BOX REPLICATE(CHR(177), 8) + CHR(177)

                        DO moviot2.prg
 
                        DO RestoreScreen
                     ENDIF
               ENDCASE
            ENDDO
         ENDIF
   ENDCASE
ENDDO