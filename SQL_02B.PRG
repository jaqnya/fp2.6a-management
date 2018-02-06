mfecha1 = DATE()
mfecha2 = DATE()

*-- Proposito: Obtener el costo de los articulos hasta la fecha
SET DELETED   ON
SET EXCLUSIVE OFF
SET CENTURY   ON
SET DATE      BRITISH
SET SAFETY    OFF

*--------------------------------------------------------------------------*
WAIT "CREANDO TABLA TEMPORAL..." WINDOW NOWAIT

SELECT 0
CREATE TABLE costs ;
  (codigo     C(15),;
   codorig    C(15),;
   nombre     C(40),;
   cantidad   N(11,2),;
   impo_total N(11),;
   promedio   N(13,4))
   
USE costs EXCLUSIVE
INDEX ON codigo TAG codigo
   
*
* Procesa la tabla de compras
*
WAIT "PROCESANDO LA TABLA DE COMPRAS..." WINDOW NOWAIT

SELECT d.articulo, SUM(d.cantidad) AS cantidad, SUM(line_value(d.cantidad, d.precio, d.pdescuento, c.porcdesc, c.importdesc, c.descuento, c.moneda, c.tipocambio)) AS importe ;
   FROM cabecomp c, detacomp d ;
   WHERE c.tipodocu  = d.tipodocu ;
     AND c.nrodocu   = d.nrodocu ;
     AND c.proveedor = d.proveedor ;
     AND c.fechadocu <= mfecha2 ;
   GROUP BY d.articulo ;
   ORDER BY 1 ;
   INTO TABLE archi_01
   
*
* Procesa la tabla de notas de d‚bito de proveedores
*
WAIT "PROCESANDO LA TABLA DE NOTAS DE DEBITO DE PROVEEDORES..." WINDOW NOWAIT

SELECT d.articulo, SUM(line_value(d.cantidad, d.precio, d.pdescuento, 0, 0, 0, e.moneda, e.tipocambio)) AS importe ;
   FROM cabenotp c, detanotp d, cabecomp e ;
   WHERE c.tiponota  = d.tiponota ;
     AND c.nronota   = d.nronota ;
     AND c.proveedor = d.proveedor ;
     AND c.fechanota <= mfecha2 ;
     AND c.tipodocu  = e.tipodocu ;
     AND c.nrodocu   = e.nrodocu ;
     AND c.proveedor = e.proveedor ;
     AND INLIST(c.tiponota, 1, 3) ;
     AND d.tipo = "P" ;
   GROUP BY d.articulo ;
   ORDER BY 1 ;
   INTO TABLE archi_02

*
* Procesa la tabla de notas de cr‚dito de proveedores
*
WAIT "PROCESANDO LA TABLA DE NOTAS DE CREDITO DE PROVEEDORES..." WINDOW NOWAIT

SELECT d.articulo, SUM(line_value(d.cantidad, d.precio, d.pdescuento, 0, 0, 0, e.moneda, e.tipocambio)) AS importe ;
   FROM cabenotp c, detanotp d, cabecomp e ;
   WHERE c.tiponota  = d.tiponota ;
     AND c.nronota   = d.nronota ;
     AND c.proveedor = d.proveedor ;
     AND c.fechanota <= mfecha2 ;
     AND c.tipodocu  = e.tipodocu ;
     AND c.nrodocu   = e.nrodocu ;
     AND c.proveedor = e.proveedor ;
     AND INLIST(c.tiponota, 2, 4) ;
     AND d.tipo = "P" ;
   GROUP BY d.articulo ;
   ORDER BY 1 ;
   INTO TABLE archi_03
   
WAIT "CALCULANDO PRECIO DE COSTO PROMEDIO..." WINDOW NOWAIT

SELECT costs
SET ORDER TO 1

APPEND FROM maesprod FIELDS codigo, codorig, nombre

SELECT archi_01   && compras
SCAN ALL
   SELECT costs
   IF SEEK(archi_01.articulo) THEN
      REPLACE cantidad   WITH (cantidad + archi_01.cantidad)
      REPLACE impo_total WITH (impo_total + archi_01.importe)
   ELSE
      WAIT "EL ARTICULO: " + ALLTRIM(archi_01.articulo) + " NO HA SIDO ENCONTRADO !" WINDOW
   ENDIF
ENDSCAN

SELECT archi_02   && notas de d‚bito de proveedores
SCAN ALL
   SELECT costs
   IF SEEK(archi_02.articulo) THEN
      REPLACE impo_total WITH (impo_total + archi_02.importe)
   ELSE
      WAIT "EL ARTICULO: " + ALLTRIM(archi_02.articulo) + " NO HA SIDO ENCONTRADO !" WINDOW
   ENDIF
ENDSCAN

SELECT archi_03   && notas de cr‚dito de proveedores
SCAN ALL
   SELECT costs
   IF SEEK(archi_03.articulo) THEN
      REPLACE impo_total WITH (impo_total - archi_03.importe)
   ELSE
      WAIT "EL ARTICULO: " + ALLTRIM(archi_03.articulo) + " NO HA SIDO ENCONTRADO !" WINDOW
   ENDIF
ENDSCAN

DIMENSION mpcostog[1, 1]
STORE 0 TO mpcostog

SELECT costs
REPLACE promedio WITH IIF(cantidad > 0, ROUND(impo_total / cantidad, 4), 0) ALL

SCAN ALL
   IF promedio = 0 THEN
      mcodigo = costs.codigo
      SELECT pcostog FROM maesprod WHERE codigo = mcodigo INTO ARRAY mpcostog
      REPLACE promedio WITH mpcostog
   ENDIF
ENDSCAN

WAIT CLEAR

BROWSE 
       
*--------------------------------------------------------------------------*
FUNCTION line_value
PARAMETERS mcantidad, mprecio, mpdescuento, mporcdesc, mimportdesc, mdescuento, mdivisa, mtipocambio
   PRIVATE mreturn, mmonto
   STORE 0 TO mreturn, mmonto

   IF mporcdesc = 0 .AND. mdescuento = 0 THEN
      mreturn = (mprecio * mcantidad) - (mprecio * mcantidad * mpdescuento / 100)
   ELSE
      IF mporcdesc > 0 THEN
         mmonto  = (mprecio * mcantidad) - (mprecio * mcantidad * mpdescuento / 100)
         mreturn = (mmonto - (mmonto * mporcdesc / 100))
      ELSE
         IF mdescuento > 0 THEN
            mmonto  = (mprecio * mcantidad) - (mprecio * mcantidad * mpdescuento / 100)
            mreturn = (mmonto - (mmonto * mdescuento / 100))
         ELSE
            IF mimportdesc > 0 THEN
               WAIT "UN ERROR DE CALCULO HA OCURRIDO !" WINDOW
            ENDIF
         ENDIF
      ENDIF
   ENDIF
   
   IF mdivisa = 1 THEN
      mreturn = ROUND(mreturn, 0)
   ELSE
      mreturn = ROUND(mreturn * mtipocambio, 0)
   ENDIF

   RETURN (mreturn)
*ENDFUNC