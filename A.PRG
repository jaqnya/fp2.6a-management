*!**************************************************************************
*!
*!  PROCEDIMIENTO: _InvoiceFoot   
*!
*!    DESCRIPCION: Calcula e imprime el pie del comprobante de venta.
*!
*!**************************************************************************
PROCEDURE _InvoiceFoot

PRIVATE pnSelect, pcOrder, pnRecNo, pnDecimals
pnSelect = SELECT()
pcOrder  = ORDER()
pnRecNo  = IIF(EOF(), 0,  RECNO())

SELECT tmpdetvent

*-- Inicializa variables del programa.
STORE 0 TO pnGravada, pnExenta, pnImpuesto, pnSubTotal, pnSubTota1, ;
           pnDescGrav, pnDescExen, pnDecimals

*-- Inicializa variables de la tabla.
STORE 0 TO m.monto_fact, m.descuento

*-- Especifica el n£mero de lugares decimales desplegado en las expresiones num‚ricas.
IF m.moneda <> 1
   pnDecimals = 2
ELSE
   pnDecimals = 0
ENDIF

*-- Calcula el importe gravado y exento del comprobante de venta.
SCAN ALL
   IF INLIST(m.tipodocu, 3, 7, 8) THEN
      mprecio = ROUND(precio / (1 + pimpuesto / 100), 4)
   ELSE
      mprecio = precio
   ENDIF

   DO CASE
      CASE impuesto .AND. pimpuesto > 0 .AND. pimpuesto < control.pimpuesto
         pnGravada = pnGravada + ROUND(mprecio * (1 - pdescuento / 100) * cantidad, pnDecimals) * (pimpuesto * control.pimpuesto / 100)
         pnExenta  = pnExenta + ROUND(mprecio * (1 - pdescuento / 100) * cantidad, pnDecimals) * (1 - (pimpuesto * control.pimpuesto / 100))
      CASE impuesto .AND. pimpuesto = control.pimpuesto
         pnGravada = pnGravada + ROUND(mprecio * (1 - pdescuento / 100 ) * cantidad, pnDecimals)
      CASE .NOT. impuesto .AND. pimpuesto = 0
         pnExenta  = pnExenta + ROUND(mprecio * (1 - pdescuento / 100) * cantidad, pnDecimals)
   ENDCASE
ENDSCAN
   
pnSubTotal = pnGravada + pnExenta
   
IF m.importdesc > 0 .AND. m.porcdesc = 0
   IF INLIST(m.tipodocu, 3, 7, 8) THEN
      mimportdesc = ROUND(m.importdesc / (1 + control.pimpuesto / 100), 0)
   ELSE
      mimportdesc = m.importdesc
   ENDIF

   pnDescGrav   = ROUND(mimportdesc * ROUND(pnGravada * 100 / pnSubTotal, pnDecimals) / 100, pnDecimals)
   pnDescExen   = mimportdesc - pnDescGrav
   pnSubTota1   = pnSubTotal - mimportdesc
   pnImpuesto   = ROUND((pnGravada - pnDescGrav) * (control.pimpuesto / 100), pnDecimals)
   m.monto_fact = pnSubTota1 + pnImpuesto
   m.descuento  = ROUND(mimportdesc / pnSubTotal * 100, 4)
ELSE
   IF m.porcdesc > 0
      pnDescGrav   = ROUND((pnGravada * (m.porcdesc / 100)), pnDecimals)
      pnDescExen   = ROUND((pnExenta * (m.porcdesc / 100)), pnDecimals)
      m.importdesc = pnDescGrav + pnDescExen
      pnSubTota1   = (pnGravada + pnExenta) - (pnDescGrav + pnDescExen)
      pnImpuesto   = ROUND(ROUND(pnGravada * (1 - m.porcdesc / 100), pnDecimals) * (control.pimpuesto / 100), pnDecimals)
      m.monto_fact = pnSubTota1 + pnImpuesto
   ELSE
      IF m.importdesc = 0 .AND. m.porcdesc = 0
         pnImpuesto   = ROUND(pnGravada * (control.pimpuesto / 100), pnDecimals)
         m.monto_fact = pnSubTotal + pnImpuesto
      ENDIF
   ENDIF
ENDIF

SELECT (pnSelect)
SET ORDER TO TAG (pcOrder)
IF pnRecNo <> 0
   GOTO RECORD pnRecNo
ENDIF

*-- Imprime en la pantalla el resultado de los c lculos.
@ 19,65 SAY IIF(INLIST(m.tipodocu, 3, 7, 8), m.monto_fact, pnSubTotal) ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR N/W

@ 20,43 SAY m.porcdesc ;
   SIZE 1,8 ;
   PICTURE "999.9999" ;
   COLOR N/W

@ 20,65 SAY m.importdesc ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR N/W

IF INLIST(m.tipodocu, 3, 7, 8)
   @ 19,02 CLEAR TO 22,41
   @ 21,56 SAY REPLICATE(CHR(32), 23)
   @ 22,02 SAY "I.V.A.:"
   
   @ 22,10 SAY pnImpuesto ;
      SIZE 1,14 ;
      PICTURE "999,999,999.99" ;
      COLOR N/W
ELSE
   @ 21,65 SAY pnImpuesto ;
      SIZE 1,14 ;
      PICTURE "999,999,999.99" ;
      COLOR N/W
ENDIF

@ 22,65 SAY m.monto_fact ;
   SIZE 1,14 ;
   PICTURE "999,999,999.99" ;
   COLOR B/W
