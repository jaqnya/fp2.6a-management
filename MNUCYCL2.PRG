*:**************************************************************************
*:
*: Archivo de Procedimiento: MNUCYCL1.PRG
*:
*:                  Sistema: Profesional de Gesti¢n Comercial y Financiera.
*:              Sub-Sistema: Controlador de Men£ de Listados.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 20/04/2004
*:
*:**************************************************************************
PRIVATE pcChoice
pcChoice = ""

DO WHILE .T.
   DO consulta.spr WITH "pcChoice"
   IF LASTKEY() = 27
      SET EXACT OFF
      EXIT DO 
   ENDIF
   DO CASE
      CASE pcChoice = "c_01.spr"         &&   1. Documentos relacionados a una factura de un cliente.
         IF UserConfig("c_01.spr", "Access", .T.)
            DO c_01.spr
         ENDIF
      CASE pcChoice = "c_02.spr"         &&   2. Documentos relacionados a una factura de un proveedor.
         IF UserConfig("c_02.spr", "Access", .T.)
            DO c_02.spr
         ENDIF
      CASE pcChoice = "brwmaes1.prg"     &&   3. Lista de Precios de Venta en D¢lares Americanos.
         IF UserConfig("brwMaes1.prg", "Access", .T.)
            DO brwmaes1.prg
         ENDIF
      CASE pcChoice = "brwmaes2.prg"     &&   4. Lista de Precios de Venta de Art¡culos Vigentes.
         IF UserConfig("brwMaes2.prg", "Access", .T.)
            DO brwmaes2.prg
         ENDIF
      CASE pcChoice = "consuven.spr"     &&   4. Lista de Precios de Venta de Art¡culos Vigentes.
*        IF UserConfig("consuven.spr", "Access", .T.)
            DO consuven.spr
*        ENDIF
      CASE pcChoice = "l_04.spr"     &&   4. Lista de Precios de Venta de Art¡culos Vigentes.
*        IF UserConfig("l_04.spr", "Access", .T.)
            DO l_04.spr
*        ENDIF
      CASE pcChoice = "l_22.prg"     &&   7. Articulos vendidos a un cliente.
*        IF UserConfig("consuven.spr", "Access", .T.)
            DO l_22.prg
*        ENDIF
      CASE pcChoice = "l_24.prg"     &&   8. Pedidos de clientes pendientes de facturaci¢n.
*        IF UserConfig("consuven.spr", "Access", .T.)
            DO l_24.prg
*        ENDIF
   ENDCASE
ENDDO