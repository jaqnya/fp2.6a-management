PRIVATE pnCounter
pnCounter = 1

*-- MS-DOS Definiciones de ventanas.
IF .NOT. WEXIST("preview")
   DEFINE WINDOW preview ;
      FROM 01,00 ;
      TO 23,79 ;
      TITLE "Vista Preliminar - ESC p/Salir" ;
      SYSTEM ;
      CLOSE ;
      NOFLOAT ;
      GROW ;
      MDI ;         
      NOMINIMIZE ;
      SHADOW ;
      ZOOM ;
      COLOR SCHEME 15
ENDIF

*-- MS-DOS Base de datos, ¡ndices, relaciones.
SELECT 0
temp01 = "tm" + RIGHT(SYS(3), 6) + ".dbf"
temp02 = "tm" + RIGHT(SYS(3), 6) + ".txt"

CREATE TABLE &temp01 (tipodocu   N(01) ,;
                      nrodocu    N(07) ,;
                      fechadocu  D(08) ,;
                      cliente    N(05) ,;
                      nombre_a   C(56) ,;
                      moneda     N(04) ,;
                      nombre_b   C(30) ,;
                      simbolo    C(04) ,;
                      tipo       N(01) ,;
                      nrocuota   N(03) ,;
                      qty_cuotas N(03) ,;
                      fecha      D(08) ,;
                      importe    N(12,2) ,;
                      abonado    N(12,2) ,;
                      monto_ndeb N(12,2) ,;
                      monto_ncre N(12,2) ,;
                      consignaci L(01) ,;
                      id_local   N(02))

USE &temp01 ALIAS tmcuotas_v EXCLUSIVE
INDEX ON STR(moneda, 4) + nombre_a + DTOS(fecha) + STR(tipodocu, 1) + STR(nrodocu, 7) TAG indice1

SELECT cabevent
SET ORDER TO TAG indice1 OF cabevent.cdx

SET RELATION TO cabevent.cliente INTO clientes
SET RELATION TO cabevent.moneda  INTO monedas ADDITIVE

SELECT cuotas_v
SET ORDER TO TAG indice1 OF cuotas_v.cdx

SET RELATION TO STR(cuotas_v.tipodocu, 1) + STR(cuotas_v.nrodocu, 7) INTO cabevent

GO TOP

SCAN ALL
   WAIT WINDOW "PROCESANDO LA TABLA DE CUOTAS DE VENTAS: " + ALLTRIM(TRANSFORM(pnCounter, "999,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "999,999,999")) NOWAIT
   IF ((importe + monto_ndeb) - (abonado + monto_ncre)) <> 0
      INSERT INTO tmcuotas_v (tipodocu, nrodocu, fechadocu, cliente, nombre_a, ;
         moneda, nombre_b, simbolo, tipo, nrocuota, qty_cuotas, fecha, importe, abonado, ;
         monto_ndeb, monto_ncre, consignaci, id_local) ;
         VALUES (cuotas_v.tipodocu, cuotas_v.nrodocu, cabevent.fechadocu, cabevent.proveedor, ;
            clientes.nombre, cabevent.moneda, monedas.nombre, monedas.simbolo, ;
            cuotas_v.tipo, cuotas_v.nrocuota, cabevent.qty_cuotas, cuotas_v.fecha, ;
            cuotas_v.importe, cuotas_v.abonado, cuotas_v.monto_ndeb, ;
            cuotas_v.monto_ncre, cabevent.consignaci, cuotas_v.id_local)
   ENDIF
   pnCounter = pnCounter + 1
ENDSCAN

WAIT CLEAR

SELECT tmcuotas_v

DO CASE 
   CASE m.proveedor = -1 .AND. m.criteria = 2
      IF m.destino = "P"
         IF m.formato = "R"
            REPORT FORM l_01abet.frx TO &temp02 NOCONSOLE
            ACTIVATE WINDOW preview
            MODIFY COMMAND &temp02 WINDOW preview NOMODIFY
            RELEASE WINDOW preview
         ELSE
            IF m.formato = "C"
               REPORT FORM l_01.frx TO &temp02 NOCONSOLE
               ACTIVATE WINDOW preview
               MODIFY COMMAND &temp02 WINDOW preview NOMODIFY
               RELEASE WINDOW preview
            ENDIF
         ENDIF
      ELSE
         IF m.destino = "I"
            IF .NOT. PRINTSTATUS()
               ?? CHR(7)
               WAIT WINDOW "­ ASEGURESE DE QUE LA IMPRESORA ESTA CONECTADA Y ENCENDIDA !"
            ELSE
               WAIT WINDOW "IMPRIMIENDO..." NOWAIT
               IF m.formato = "R"
                  REPORT FORM l_01abet.frx TO PRINTER NOCONSOLE
               ELSE
                  IF m.formato = "C"
                     REPORT FORM l_01.frx TO PRINTER NOCONSOLE                  
                  ENDIF
               ENDIF
               WAIT CLEAR
            ENDIF
         ENDIF
      ENDIF
   CASE .NOT. INLIST(m.proveedor, 0, -1) .AND. m.criteria = 2
      IF m.destino = "P"
         IF m.formato = "R"
            REPORT FORM l_01abet.frx TO &temp02 FOR proveedor = m.proveedor NOCONSOLE
            ACTIVATE WINDOW preview
            MODIFY COMMAND &temp02 WINDOW preview NOMODIFY
            RELEASE WINDOW preview
         ELSE
            IF m.formato = "C"
               REPORT FORM l_01.frx TO &temp02 FOR proveedor = m.proveedor NOCONSOLE
               ACTIVATE WINDOW preview
               MODIFY COMMAND &temp02 WINDOW preview NOMODIFY
               RELEASE WINDOW preview            
            ENDIF
         ENDIF
      ELSE
         IF m.destino = "I"
            IF .NOT. PRINTSTATUS()
               ?? CHR(7)
               WAIT WINDOW "­ ASEGURESE DE QUE LA IMPRESORA ESTA CONECTADA Y ENCENDIDA !"
            ELSE
               WAIT WINDOW "IMPRIMIENDO..." NOWAIT
               IF m.formato = "R"
                  REPORT FORM l_01abet.frx FOR proveedor = m.proveedor TO PRINTER NOCONSOLE
               ELSE
                  IF m.formato = "C"
                     REPORT FORM l_01.frx FOR proveedor = m.proveedor TO PRINTER NOCONSOLE
                  ENDIF
               ENDIF
               WAIT CLEAR
            ENDIF
         ENDIF
      ENDIF
   CASE m.proveedor = -1 .AND. m.criteria = 1
      IF m.destino = "P"
         IF m.formato = "R"
            REPORT FORM l_01abet.frx TO &temp02 FOR BETWEEN(fecha, m.fecha01, m.fecha02) NOCONSOLE
            ACTIVATE WINDOW preview
            MODIFY COMMAND &temp02 WINDOW preview NOMODIFY
            RELEASE WINDOW preview
         ELSE
            IF m.formato = "C"
               REPORT FORM l_01.frx TO &temp02 FOR BETWEEN(fecha, m.fecha01, m.fecha02) NOCONSOLE
               ACTIVATE WINDOW preview
               MODIFY COMMAND &temp02 WINDOW preview NOMODIFY
               RELEASE WINDOW preview            
            ENDIF
         ENDIF
      ELSE
         IF m.destino = "I"
            IF .NOT. PRINTSTATUS()
               ?? CHR(7)
               WAIT WINDOW "­ ASEGURESE DE QUE LA IMPRESORA ESTA CONECTADA Y ENCENDIDA !"
            ELSE
               WAIT WINDOW "IMPRIMIENDO..." NOWAIT
               IF m.formato = "R"
                  REPORT FORM l_01abet.frx FOR BETWEEN(fecha, m.fecha01, m.fecha02) TO PRINTER NOCONSOLE
               ELSE
                  IF m.formato = "C"
                     REPORT FORM l_01.frx FOR BETWEEN(fecha, m.fecha01, m.fecha02) TO PRINTER NOCONSOLE
                  ENDIF
               ENDIF
               WAIT CLEAR
            ENDIF
         ENDIF
      ENDIF
   CASE .NOT. INLIST(m.proveedor, 0, -1) .AND. m.criteria = 1
      IF m.destino = "P"
         IF m.formato = "R"
            REPORT FORM l_01abet.frx TO &temp02 FOR proveedor = m.proveedor .AND. BETWEEN(fecha, m.fecha01, m.fecha02) NOCONSOLE
            ACTIVATE WINDOW preview
            MODIFY COMMAND &temp02 WINDOW preview NOMODIFY
            RELEASE WINDOW preview
         ELSE
            IF m.formato = "C"
               REPORT FORM l_01.frx TO &temp02 FOR proveedor = m.proveedor .AND. BETWEEN(fecha, m.fecha01, m.fecha02) NOCONSOLE
               ACTIVATE WINDOW preview
               MODIFY COMMAND &temp02 WINDOW preview NOMODIFY
               RELEASE WINDOW preview            
            ENDIF
         ENDIF
      ELSE
         IF m.destino = "I"
            IF .NOT. PRINTSTATUS()
               ?? CHR(7)
               WAIT WINDOW "­ ASEGURESE DE QUE LA IMPRESORA ESTA CONECTADA Y ENCENDIDA !"
            ELSE
               WAIT WINDOW "IMPRIMIENDO..." NOWAIT
               IF m.formato = "R"
                  REPORT FORM l_01abet.frx FOR proveedor = m.proveedor .AND. BETWEEN(fecha, m.fecha01, m.fecha02) TO PRINTER NOCONSOLE
               ELSE
                  IF m.formato = "C"
                     REPORT FORM l_01.frx FOR proveedor = m.proveedor .AND. BETWEEN(fecha, m.fecha01, m.fecha02) TO PRINTER NOCONSOLE                 
                  ENDIF
               ENDIF
               WAIT CLEAR
            ENDIF          
         ENDIF
      ENDIF
ENDCASE

*-- MS-DOS Cleanup.

*-- Elimina la tabla temporal.
IF USED("tmcuotas_v")
   SELECT tmcuotas_v
   USE
ENDIF

DELETE FILE &temp01
DELETE FILE SUBSTR(temp01, 1, ATC(".", temp01)) + "CDX"

*-- Elimina relaciones entre tablas.
SELECT cabevent
SET RELATION OFF INTO clientes
SET RELATION OFF INTO monedas

SELECT cuotas_v
SET RELATION OFF INTO cabevent                      

IF WEXIST("preview")
   RELEASE WINDOW preview
ENDIF