*:**************************************************************************
*:
*: Archivo de Procedimiento: MNUCYCL1.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Controlador del Men£ de Listados e Informes.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 24/05/2004
*:
*:**************************************************************************
PRIVATE pcChoice
pcChoice = ""

DO WHILE .T.
   DO reports.spr WITH "pcChoice"
   IF LASTKEY() = 27
      SET EXACT OFF
      EXIT DO 
   ENDIF
   DO CASE
      CASE pcChoice = "articulo.spr"     &&  Art¡culos.
*         IF UserConfig("tables.spr", "Access", .T.)
            DO WHILE .T.
               DO articulo.spr WITH "pcChoice"
               IF LASTKEY() = 27
                  EXIT DO 
               ENDIF  
               DO CASE
                  CASE pcChoice = "l_13.spr"     &&  Existencia de Art¡culos.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_13.spr
*                     ENDIF
                  CASE pcChoice = "l_15.spr"     &&  Stock M¡nimo
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_15.spr
*                     ENDIF
                  CASE pcChoice = "l_16.spr"     &&  Stock M ximo
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_16.spr
*                     ENDIF
                  CASE pcChoice = "l_05.spr"     &&  1. Listado de Art¡culos.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_05.spr
*                     ENDIF
                  CASE pcChoice = "l_08.spr"     &&  1. Listado de Art¡culos.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_08.spr
*                     ENDIF
                  CASE pcChoice = "l_10.spr"     &&  1. Listado de Art¡culos.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_10.spr
*                     ENDIF
                  CASE pcChoice = "l_11.spr"     &&  1. Listado de Art¡culos.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_11.spr
*                     ENDIF
                  CASE pcChoice = "l_12.spr"     &&  1. Listado de Art¡culos.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_12.spr
*                     ENDIF
                  CASE pcChoice = "best_pro.spr"     &&  1. Listado de Art¡culos.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO best_pro.spr
*                     ENDIF
                  CASE pcChoice = "l_23.prg"     &&  12. Informe de ultimo movimiento de compra y venta.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_23.prg
*                     ENDIF
               ENDCASE
            ENDDO
*         ENDIF
      CASE pcChoice = "clientes.spr"     &&  Clientes.
*         IF UserConfig("tables.spr", "Access", .T.)
            DO WHILE .T.
               DO clientes.spr WITH "pcChoice"
               IF LASTKEY() = 27
                  EXIT DO 
               ENDIF  
               DO CASE
                  CASE pcChoice = "l_04.spr"     &&  2. Ventas Pendientes de Cobro.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_04.spr
*                     ENDIF
               ENDCASE
            ENDDO
*         ENDIF
      CASE pcChoice = "ventas.spr"     &&  Ventas.
*         IF UserConfig("tables.spr", "Access", .T.)
            DO WHILE .T.
               DO ventas.spr WITH "pcChoice"
               IF LASTKEY() = 27
                  EXIT DO 
               ENDIF  
               DO CASE
                  CASE pcChoice = "l_20.prg"     && 17. Cuadro Anual de Ventas por Vendedor
                     DO l_20.prg
                  CASE pcChoice = "l_20a.prg"     && 19. Cuadro Anual de Ventas por Vendedor y Marca
                     DO l_20a.prg
                  CASE pcChoice = "l_21.prg"     && 18. Liquidacion de Caja Diaria
                     DO l_21.prg
                  CASE pcChoice = "infmecan.spr"     && 13. Comisi¢n de Mec nicos. V2.0
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO infmecan.spr
*                       DO l_02x1.spr
*                     ENDIF
                  CASE pcChoice = "l_02.spr"     && 13. Comisi¢n de Mec nicos.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_02.spr
*                       DO l_02x1.spr
*                     ENDIF
                  CASE pcChoice = "l_54.spr"     && 13. Comisi¢n de Vendedores.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
*                       DO sql.prg
                        DO sql_X.prg
*                       DO l_54.spr
*                     ENDIF
                  CASE pcChoice = "l_14.prg"     && 13. Comisi¢n de Vendedores.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_14.prg
*                     ENDIF
                  CASE pcChoice = "l_09.spr"     && 13. Comisi¢n de Mec nicos.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_09.spr
*                     ENDIF
                  CASE pcChoice = "l_03.spr"     && 10. Ventas y Detalle de los Art¡culos Vendidos.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_03.spr
*                     ENDIF
                  CASE pcChoice = "l_04.spr"     &&  8. Ventas Pendientes de Cobro.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_04.spr
*                     ENDIF
                  CASE pcChoice = "l_61.spr"     &&  15. Estadistica de Ventas.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_61.spr
*                     ENDIF
               ENDCASE
            ENDDO
*         ENDIF
      CASE pcChoice = "cobros1.spr"     &&  Cobros.
*         IF UserConfig("tables.spr", "Access", .T.)
            DO WHILE .T.
               DO cobros1.spr WITH "pcChoice"
               IF LASTKEY() = 27
                  EXIT DO 
               ENDIF  
               DO CASE
                  CASE pcChoice = "l_01.spr"     &&  2. Compras Pendientes de Pago.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_01.spr
*                     ENDIF
               ENDCASE
            ENDDO
*         ENDIF
      CASE pcChoice = "proveedo.spr"     &&  Proveedores.
*         IF UserConfig("tables.spr", "Access", .T.)
            DO WHILE .T.
               DO proveedo.spr WITH "pcChoice"
               IF LASTKEY() = 27
                  EXIT DO 
               ENDIF  
               DO CASE
                  CASE pcChoice = "l_01.spr"     &&  2. Compras Pendientes de Pago.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_01.spr
*                     ENDIF
               ENDCASE
            ENDDO
*         ENDIF
      CASE pcChoice = "compras.spr"     &&  Compras.
*         IF UserConfig("tables.spr", "Access", .T.)
            DO WHILE .T.
               DO compras.spr WITH "pcChoice"
               IF LASTKEY() = 27
                  EXIT DO 
               ENDIF  
               DO CASE
                  CASE pcChoice = "l_01.spr"     &&  2. Compras Pendientes de Pago.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_01.spr
*                     ENDIF
                  CASE pcChoice = "l_27.prg"     &&  1. Cuadro Anual de Compras.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_27.prg
*                     ENDIF
                  CASE pcChoice = "l_08.spr"     &&
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_08.spr
*                     ENDIF
                  CASE pcChoice = "l_07.spr"     &&
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_07.spr
*                     ENDIF
                  CASE pcChoice = "l_06.spr"     &&  9. Estad¡stica de Compras.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_06.spr
*                     ENDIF
               ENDCASE
            ENDDO
*         ENDIF
      CASE pcChoice = "pagos2.spr"     &&  Pagos.
*         IF UserConfig("tables.spr", "Access", .T.)
            DO WHILE .T.
               DO pagos2.spr WITH "pcChoice"
               IF LASTKEY() = 27
                  EXIT DO 
               ENDIF  
               DO CASE
                  CASE pcChoice = "l_01.spr"     &&  2. Compras Pendientes de Pago.
*                     IF UserConfig("brwFamil.prg", "Access", .T.)
                        DO l_01.spr
*                     ENDIF
               ENDCASE
            ENDDO
*         ENDIF
   ENDCASE
ENDDO
