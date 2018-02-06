*
* VTACREDI.PRG - Actualizacion de cuenta corriente de clientes.
*

* Codigo de Configuracion.
=Setup()

* Procedimiento Principal.

*-- Procesa el archivo de venta.
SELECT cabevent 
GO TOP

pnCounter = 1

SCAN ALL
   WAIT WINDOW "PROCESO 1/3 - VENTAS: " + ALLTRIM(TRANSFORM(pnCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT
   IF INLIST(cabevent.tipodocu, 2, 6) .AND. (cabevent.monto_fact + cabevent.monto_ndeb) - (cabevent.monto_cobr + cabevent.monto_ncre) > 0
      *-- Copia el encabezado.
      SELECT cabevent
         SCATTER MEMVAR MEMO
      SELECT cabe1con
         APPEND BLANK
         GATHER MEMVAR MEMO

      *-- Copia el detalle.
      SELECT detavent
      
      IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
         SCAN WHILE STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7) = STR(detavent.tipodocu, 1) + STR(detavent.nrodocu, 7)
            SELECT detavent 
               SCATTER MEMVAR MEMO
            SELECT deta1con
               APPEND BLANK
               GATHER MEMVAR MEMO
               IF EMPTY(descr_trab)
                  REPLACE descr_trab WITH maesprod.nombre
               ENDIF
            SELECT detavent              
         ENDSCAN
      ENDIF

      *-- Copia las cuotas.
      SELECT cuotas_v

      IF SEEK(STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7))
         SCAN WHILE STR(cabevent.tipodocu, 1) + STR(cabevent.nrodocu, 7) = STR(cuotas_v.tipodocu, 1) + STR(cuotas_v.nrodocu, 7)
            SELECT cuotas_v 
               SCATTER MEMVAR MEMO
            SELECT cuot1con
               APPEND BLANK
               GATHER MEMVAR MEMO
            SELECT cuotas_v              
         ENDSCAN
      ENDIF

   ENDIF

   SELECT cabevent
   pnCounter = pnCounter + 1
ENDSCAN

*-- Procesa el archivo de cobros.
SELECT cabecob 
GO TOP

pnCounter = 1

SCAN ALL
   WAIT WINDOW "PROCESO 2/3 - COBROS: " + ALLTRIM(TRANSFORM(pnCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT
   SELECT detacob

   IF SEEK(STR(cabecob.tiporeci, 1) + STR(cabecob.nroreci, 7))
      SCAN WHILE STR(cabecob.tiporeci, 1) + STR(cabecob.nroreci, 7) = STR(detacob.tiporeci, 1) + STR(detacob.nroreci, 7)
         SELECT cabevent
         
         IF SEEK(STR(detacob.tipodocu, 1) + STR(detacob.nrodocu, 7))
            IF cabecob.id_local <> cabevent.id_local
               SELECT detacob
                  SCATTER MEMVAR MEMO
               SELECT deta2con
                  APPEND BLANK 
                  GATHER MEMVAR MEMO
            ENDIF      
         ENDIF
      
         SELECT detacob
      ENDSCAN
   ENDIF
   
   SELECT cabecob
   pnCounter = pnCounter + 1
ENDSCAN

*-- Procesa el archivo de actualizacion de cobros.
SELECT deta2con
GO TOP

pnCounter = 1

SCAN ALL
   WAIT WINDOW "PROCESO 3/3 - DETALLE DE COBROS: " + ALLTRIM(TRANSFORM(pnCounter, "9,999,999")) + "/" + ALLTRIM(TRANSFORM(RECCOUNT(), "9,999,999")) NOWAIT
   SELECT cabe2con

   IF .NOT. SEEK(STR(deta2con.tiporeci, 1) + STR(deta2con.nroreci, 7))
      SELECT cabecob
   
      IF SEEK(STR(deta2con.tiporeci, 1) + STR(deta2con.nroreci, 7))      
         SELECT cabecob
            SCATTER MEMVAR MEMO
         SELECT cabe2con
            APPEND BLANK
            GATHER MEMVAR MEMO
            REPLACE cabe2con.monto_cobr WITH deta2con.monto
      ENDIF
   ELSE
      SELECT cabe2con
      REPLACE cabe2con.monto_cobr WITH (cabe2con.monto_cobr + deta2con.monto)
   ENDIF
   
   SELECT deta2con
   pnCounter = pnCounter + 1
ENDSCAN

=Cleanup()

*
* SETUP - Codigo de Configuracion
*
PROCEDURE Setup

IF USED("cabe1con")
   SELECT cabe1con
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabe1con.dbf", "DBF", "¨ D¢nde est  CABE1CON.DBF ?")) ;
      AGAIN ALIAS cabe1con EXCLUSIVE ;
      ORDER TAG indice1
ENDIF

IF USED("deta1con")
   SELECT deta1con
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("deta1con.dbf", "DBF", "¨ D¢nde est  DETA1CON.DBF ?")) ;
      AGAIN ALIAS deta1con EXCLUSIVE ;
      ORDER TAG indice1
ENDIF

IF USED("cuot1con")
   SELECT cuot1con
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cuot1con.dbf", "DBF", "¨ D¢nde est  CUOT1CON.DBF ?")) ;
      AGAIN ALIAS cuot1con EXCLUSIVE ;
      ORDER TAG indice1
ENDIF

IF USED("cabe2con")
   SELECT cabe2con
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabe2con.dbf", "DBF", "¨ D¢nde est  CABE2CON.DBF ?")) ;
      AGAIN ALIAS cabe2con EXCLUSIVE ;
      ORDER TAG indice1
ENDIF

IF USED("deta2con")
   SELECT deta2con
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("deta2con.dbf", "DBF", "¨ D¢nde est  DETA2CON.DBF ?")) ;
      AGAIN ALIAS deta2con EXCLUSIVE ;
      ORDER TAG indice1
ENDIF

SELECT cabe1con
ZAP

SELECT deta1con
ZAP

SELECT cuot1con
ZAP

SELECT cabe2con
ZAP

SELECT deta2con
ZAP

SELECT maesprod
SET ORDER TO TAG indice1 OF maesprod.cdx

SELECT cabevent
SET ORDER TO TAG indice1 OF cabevent.cdx

SELECT detavent 
SET ORDER TO TAG indice1 OF detavent.cdx

SELECT cuotas_v
SET ORDER TO TAG indice1 OF cuotas_v.cdx

SELECT cabecob
SET ORDER TO TAG indice1 OF cabecob.cdx

SELECT detacob
SET ORDER TO TAG indice1 OF detacob.cdx

*-- Establece relaciones entre las tablas.
SELECT detavent
SET RELATION TO detavent.articulo INTO maesprod

*
* CLEANUP - Codigo de Limpieza.
*
PROCEDURE Cleanup

IF USED("cabe1con")
   SELECT cabe1con
   USE
ENDIF

IF USED("deta1con")
   SELECT deta1con
   USE
ENDIF

IF USED("cuot1con")
   SELECT cuot1con
   USE
ENDIF

IF USED("cabe2con")
   SELECT cabe2con
   USE
ENDIF

IF USED("deta2con")
   SELECT deta2con
   USE
ENDIF

*-- Quiebra las relaciones entre las tablas.
SELECT detavent
SET RELATION OFF INTO maesprod