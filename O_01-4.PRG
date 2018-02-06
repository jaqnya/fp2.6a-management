close databases
set deleted on

SELECT 0
use clientes.dbf alias clientes shared
set order to tag indice1

SELECT 0
use detanotc.dbf alias detanotc shared
set order to tag indice1

SELECT 0
use cabenotc.dbf alias cabenotc shared
set order to tag indice1

SELECT 0 
use detacob.dbf alias detacob shared
set order to tag indice1

SELECT 0
use cabevent.dbf alias cabevent shared
set order to tag indice1

SELECT 0
use cuotas_v.dbf alias cuotas_v shared
set order to tag indice1

SELECT 0
use cuotas_n.dbf alias cuotas_n shared
set order to tag indice1

SELECT 0
use cabecob.dbf alias cabecob shared
set order to tag indice1



PRIVATE pnCounter

* BOF: 1. Inicializa el saldo de Clientes.
pnCounter = 1
SELECT clientes
GO TOP

SCAN ALL
   WAIT WINDOW "PROCESO 1/8: " + LTRIM(TRANSFORM(pnCounter,"9,999,999")) + "/" + LTRIM(TRANSFORM(RECCOUNT(),"9,999,999")) NOWAIT
   REPLACE saldo_actu WITH 0
   pnCounter = pnCounter + 1

ENDSCAN
* EOF: 1. Inicializa el saldo de Clientes.


* BOF: 2. Inicializa los valores en Ventas.
pnCounter = 1
SELECT cabevent
GO TOP

SCAN ALL
   WAIT WINDOW "PROCESO 2/8: " + LTRIM(TRANSFORM(pnCounter,"9,999,999")) + "/" + LTRIM(TRANSFORM(RECCOUNT(),"9,999,999")) NOWAIT
   DO CASE
      CASE INLIST(tipodocu,1,3,4)
         REPLACE monto_cobr WITH monto_fact, ;
                 monto_ndeb WITH 0, ;
                 monto_ncre WITH 0
      CASE INLIST(tipodocu,2,5)
         REPLACE monto_cobr WITH 0, ;
                 monto_ndeb WITH 0, ;
                 monto_ncre WITH 0
   ENDCASE
   pnCounter = pnCounter + 1

ENDSCAN
* EOF: 2. Inicializa los valores en Ventas.


* BOF: 3. Inicializa los valores de las cuotas de Ventas.
pnCounter = 1
SELECT cuotas_v
GO TOP

SCAN ALL
   WAIT WINDOW "PROCESO 3/8: " + LTRIM(TRANSFORM(pnCounter,"9,999,999")) + "/" + LTRIM(TRANSFORM(RECCOUNT(),"9,999,999")) NOWAIT
   REPLACE abonado    WITH 0, ;
           monto_ndeb WITH 0, ;
           monto_ncre WITH 0
   pnCounter = pnCounter + 1
   skip
ENDSCAN
* EOF: 3. Inicializa los valores de las cuotas de Ventas.


* BOF: 4. Actualiza las Ventas y las cuotas desde Cobros.
pnCounter = 1
SELECT detacob
GO TOP

SCAN ALL
   WAIT WINDOW "PROCESO 4/8: " + LTRIM(TRANSFORM(pnCounter,"9,999,999")) + "/" + LTRIM(TRANSFORM(RECCOUNT(),"9,999,999")) NOWAIT
   SELECT cabevent
   if seek(str(detacob.tipodocu,1)+str(detacob.nrodocu,7))
      REPLACE monto_cobr WITH (monto_cobr+detacob.monto)
   else
      WAIT WINDOW "­ ERROR 1 !"
   endif
   SELECT cuotas_v
   if seek(str(detacob.tipodocu,1)+str(detacob.nrodocu,7)+str(detacob.nrocuota,3))
      REPLACE abonado WITH (abonado+detacob.monto)
   else
      WAIT WINDOW "­ ERROR 2 !"
   endif
   SELECT detacob
   pnCounter = pnCounter + 1
   skip
ENDSCAN
* EOF: 4. Actualiza las Ventas y las cuotas desde Cobros.


* BOF: 5. Actualiza las Ventas y las cuotas desde N.Deb/Cred.
pnCounter = 1
SELECT cabenotc
GO TOP
SCAN ALL
   WAIT WINDOW "PROCESO 5/8: " + LTRIM(TRANSFORM(pnCounter,"9,999,999")) + "/" + LTRIM(TRANSFORM(RECCOUNT(),"9,999,999")) NOWAIT
   SELECT cabevent
   DO CASE
      CASE INLIST(cabenotc.tiponota,1,3)
         if seek(str(cabenotc.tipodocu,1)+str(cabenotc.nrodocu,7))
            REPLACE monto_ndeb WITH (cabenotc.monto_nota+monto_ndeb)
            REPLACE monto_cobr WITH (cabenotc.monto_nota+monto_cobr)
         else
            WAIT WINDOW "No se encontr¢ la venta: "+;
               ltrim(str(cabenotc.tipodocu,1)) + "/" + ;
               ltrim(str(cabenotc.nrodocu,7))+ " desde la nota: "+;
               ltrim(str(cabenotc.tiponota,1)) + "/" + ;
               ltrim(str(cabenotc.nronota,7))
         endif         
      CASE INLIST(cabenotc.tiponota,2,4)
         if seek(str(cabenotc.tipodocu,1)+str(cabenotc.nrodocu,7))
            REPLACE monto_ncre WITH (monto_ncre+cabenotc.monto_nota)
            if INLIST(cabenotc.tipodocu,1,3,4)
               REPLACE monto_cobr WITH (monto_cobr-cabenotc.monto_nota)
            endif
         else
            WAIT WINDOW "No se encontr¢ la venta: "+;
               ltrim(str(cabenotc.tipodocu,1)) + "/" + ;
               ltrim(str(cabenotc.nrodocu,7))+ " desde la nota: "+;
               ltrim(str(cabenotc.tiponota,1)) + "/" + ;
               ltrim(str(cabenotc.nronota,7))
         endif         
   ENDCASE

   if cabenotc.tipodocu == 2  && Si la N.Deb/Cred. es imputada a una Venta a Cr‚dito.
      SELECT cuotas_n
      if seek("V"+str(cabenotc.tiponota,1)+str(cabenotc.nronota,7))
         do while "V"+str(cabenotc.tiponota,1)+str(cabenotc.nronota,7) == "V"+str(cuotas_n.tiponota,1)+str(cuotas_n.nronota,7)) .and. not eof()
            SELECT cuotas_v
            if seek(str(cabenotc.tipodocu,1)+str(cabenotc.nrodocu,7)+str(cuotas_n.nrocuota,3))
               DO CASE
                  CASE INLIST(cabenotc.tiponota,1,3)
                     REPLACE monto_ndeb WITH (monto_ndeb+cuotas_n.importe)   
                  CASE INLIST(cabenotc.tiponota,2,4)
                     REPLACE monto_ncre WITH (monto_ncre+cuotas_n.importe)
               ENDCASE
            else     
               WAIT WINDOW "­ ERROR 2 !"
            endif
            SELECT cuotas_n
            skip
         ENDSCAN
      else
         WAIT WINDOW "No se encontr¢ la cuota de la nota: "+;
            ltrim(str(cabenotc.tiponota,1)) + "/" + ;
            ltrim(str(cabenotc.nronota,7))
      endif
   endif
   
   SELECT cabenotc
   pnCounter = pnCounter + 1
   skip
ENDSCAN
* EOF: 5. Actualiza las Ventas y las cuotas desde N.Deb/Cred.


* BOF: 6. Actualiza el saldo de Clientes desde Ventas.
SELECT cabevent
GO TOP
pnCounter = 1

if seek(str(2,1))
   do while INLIST(cabevent.tipodocu,2,5) .not. eof() 
      WAIT WINDOW "PROCESO 6/8: " + LTRIM(TRANSFORM(pnCounter,"9,999,999"))+"/" + LTRIM(TRANSFORM(RECCOUNT(),"9,999,999")) NOWAIT
*------------------------------------------      if INLIST(cabevent.tipodocu,2,3)
      SELECT clientes
      if seek(cabevent.cliente)
         REPLACE clientes.saldo_actu WITH (clientes.saldo_actu+cabevent.monto_fact)
      endif
      SELECT cabevent
*------------------------------------------      endif
      pnCounter = pnCounter + 1
      skip
   ENDSCAN
endif

* EOF: 6. Actualiza el saldo de Clientes desde Ventas.  


* BOF: 7. Actualiza el saldo de Clientes desde Cobros.
SELECT cabecob
GO TOP
pnCounter = 1

SCAN ALL 
   WAIT WINDOW "PROCESO 7/8: " + LTRIM(TRANSFORM(pnCounter,"9,999,999"))+"/" + LTRIM(TRANSFORM(RECCOUNT(),"9,999,999")) NOWAIT
   SELECT clientes
   if seek(cabecob.cliente)
      REPLACE clientes.saldo_actu WITH (clientes.saldo_actu+cabecob.monto_cobr)
   else
      WAIT WINDOW "No se encontr¢ el cliente: "+ltrim(str(cabecob.cliente,7))+" desde el recibo: "+ltrim(str(cabecob.tiporeci,1)) + "/" + ltrim(str(cabecob.nroreci,7))
   endif
   SELECT cabecob
   pnCounter = pnCounter + 1
   skip
ENDSCAN

* EOF: 7. Actualiza el saldo de Clientes desde Cobros.


* BOF: 8. Actualiza el saldo de Clientes desde N.Deb/Cred.
SELECT cabenotc
GO TOP
pnCounter = 1

SCAN ALL 
   WAIT WINDOW "PROCESO 8/8: " + LTRIM(TRANSFORM(pnCounter,"9,999,999"))+"/" + LTRIM(TRANSFORM(RECCOUNT(),"9,999,999")) NOWAIT
   if INLIST(cabenotc.tipodocu,2,5)
      SELECT clientes
      if seek(cabenotc.cliente)
         REPLACE clientes.saldo_actu WITH (clientes.saldo_actu+cabenotc.monto_nota)
      else
         WAIT WINDOW "No se encontr¢ el cliente: "+ltrim(str(cabenotc.cliente,7))+" desde la nota: "+ltrim(str(cabenotc.tiponota,1)) + "/" + ltrim(str(cabenotc.nronota,7))

      endif
      SELECT cabenotc
   endif
   pnCounter = pnCounter + 1
   skip
ENDSCAN

* EOF: 8. Actualiza el saldo de Clientes desde N.Deb/Cred.
