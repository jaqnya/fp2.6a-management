*:*********************************************************************
*:
*: Archivo de Procedimiento: OPENFILE.PRG
*:
*:                  Sistema: Integrado de Gesti¢n Financiera.
*:              Sub-Sistema: Abre tablas y establece relaciones.
*:                  Versi¢n: 1.0
*:                    Autor: Jos‚ Avilio Acu¤a Acosta.
*:        Derechos de Autor: (c) 2004, Alben S.R.L.             
*:      Ultima Modificaci¢n: 28/02/2004
*:
*:*********************************************************************
*-- MS-DOS Base de datos, ¡ndices, relaciones.
CLOSE DATABASES
WAIT WINDOW "ACCEDIENDO AL SISTEMA, POR FAVOR AGUARDE UN MOMENTO..." NOWAIT

PRIVATE pnNroTabla
pnNroTabla = 0

DO openfile.spr

IF USED("accesos")
   SELECT accesos
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("accesos.dbf", "DBF", "¨ D¢nde est  ACCESOS.DBF ?")) ;
      AGAIN ALIAS accesos SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar
 
IF USED("almacen")
   SELECT almacen
   SET ORDER TO TAG indice1 OF almacen.cdx
ELSE
   SELECT 0
   USE (LOCFILE("almacen.dbf", "DBF", "¨ D¢nde est  ALMACEN.DBF ?")) ;
      AGAIN ALIAS almacen SHARED ;
      ORDER TAG indice1 OF almacen.cdx
ENDIF
DO _DrawProgressBar

IF USED("ayuda")
   SELECT ayuda
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("ayuda.dbf", "DBF", "¨ D¢nde est  AYUDA.DBF ?")) ;
      AGAIN ALIAS ayuda SHARED ;
      ORDER 0
ENDIF
DO _DrawProgressBar

IF USED("barrios")
   SELECT barrios
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("barrios.dbf", "DBF", "¨ D¢nde est  BARRIOS.DBF ?")) ;
      AGAIN ALIAS barrios SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("cabecob")
   SELECT cabecob 
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabecob.dbf", "DBF", "¨ D¢nde est  CABECOB.DBF ?")) ;
      AGAIN ALIAS cabecob SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("cabecomp")
   SELECT cabecomp
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabecomp.dbf", "DBF", "¨ D¢nde est  CABECOMP.DBF ?")) ;
      AGAIN ALIAS cabecomp SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("cabemot")
   SELECT cabemot
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabemot.dbf", "DBF", "¨ D¢nde est  CABEMOT.DBF ?")) ;
      AGAIN ALIAS cabemot SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("cabemot2")
   SELECT cabemot2
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabemot2.dbf", "DBF", "¨ D¢nde est  CABEMOT2.DBF ?")) ;
      AGAIN ALIAS cabemot2 SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("cabemovi")
   SELECT cabemovi
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabemovi.dbf", "DBF", "¨ D¢nde est  CABEMOVI.DBF ?")) ;
      AGAIN ALIAS cabemovi SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("cabenotc")
   SELECT cabenotc
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabenotc.dbf", "DBF", "¨ D¢nde est  CABENOTC.DBF ?")) ;
      AGAIN ALIAS cabenotc SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("cabenotp")
   SELECT cabenotp
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabenotp.dbf", "DBF", "¨ D¢nde est  CABENOTP.DBF ?")) ;
      AGAIN ALIAS cabenotp SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("cabepag")
   SELECT cabepag
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabepag.dbf", "DBF", "¨ D¢nde est  CABEPAG.DBF ?")) ;
      AGAIN ALIAS cabepag SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("cabepres")
   SELECT cabepres
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabepres.dbf", "DBF", "¨ D¢nde est  CABEPRES.DBF ?")) ;
      AGAIN ALIAS cabepres SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("caberemi")
   SELECT caberemi
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("caberemi.dbf", "DBF", "¨ D¢nde est  CABEREMI.DBF ?")) ;
      AGAIN ALIAS caberemi SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("cabeven2")
   SELECT cabeven2
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabeven2.dbf", "DBF", "¨ D¢nde est  CABEVEN2.DBF ?")) ;
      AGAIN ALIAS cabeven2 SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("cabevent")
   SELECT cabevent
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabevent.dbf", "DBF", "¨ D¢nde est  CABEVENT.DBF ?")) ;
      AGAIN ALIAS cabevent SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("ciudades")
   SELECT ciudades
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("ciudades.dbf", "DBF", "¨ D¢nde est  CIUDADES.DBF ?")) ;
      AGAIN ALIAS ciudades SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("clientes")
   SELECT clientes
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("clientes.dbf", "DBF", "¨ D¢nde est  CLIENTES.DBF ?")) ;
      AGAIN ALIAS clientes SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("cobrador")
   SELECT cobrador
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cobrador.dbf", "DBF", "¨ D¢nde est  COBRADOR.DBF ?")) ;
      AGAIN ALIAS cobrador SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("control")
   SELECT control 
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("control.dbf", "DBF", "¨ D¢nde est  CONTROL.DBF ?")) ;
      AGAIN ALIAS control SHARED ;
      ORDER 0
ENDIF
DO _DrawProgressBar

IF USED("cuotas_c")
   SELECT cuotas_c
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cuotas_c.dbf", "DBF", "¨ D¢nde est  CUOTAS_C.DBF ?")) ;
      AGAIN ALIAS cuotas_c SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("cuotas_n")
   SELECT cuotas_n
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cuotas_n.dbf", "DBF", "¨ D¢nde est  CUOTAS_N.DBF ?")) ;
      AGAIN ALIAS cuotas_n SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("cuotas_p")
   SELECT cuotas_p
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cuotas_p.dbf", "DBF", "¨ D¢nde est  CUOTAS_P.DBF ?")) ;
      AGAIN ALIAS cuotas_p SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("cuotas_v")
   SELECT cuotas_v
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cuotas_v.dbf", "DBF", "¨ D¢nde est  CUOTAS_V.DBF ?")) ;
      AGAIN ALIAS cuotas_v SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("depar")
   SELECT depar
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("depar.dbf", "DBF", "¨ D¢nde est  DEPAR.DBF ?")) ;
      AGAIN ALIAS depar SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("detacob")
   SELECT detacob 
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detacob.dbf", "DBF", "¨ D¢nde est  DETACOB.DBF ?")) ;
      AGAIN ALIAS detacob SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("detacomp")
   SELECT detacomp
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detacomp.dbf", "DBF", "¨ D¢nde est  DETACOMP.DBF ?")) ;
      AGAIN ALIAS detacomp SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("detamot")
   SELECT detamot
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detamot.dbf", "DBF", "¨ D¢nde est  DETAMOT.DBF ?")) ;
      AGAIN ALIAS detamot SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("detamot2")
   SELECT detamot2
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detamot2.dbf", "DBF", "¨ D¢nde est  DETAMOT2.DBF ?")) ;
      AGAIN ALIAS detamot2 SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("detamovi")
   SELECT detamovi
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detamovi.dbf", "DBF", "¨ D¢nde est  DETAMOVI.DBF ?")) ;
      AGAIN ALIAS detamovi SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("detanotc")
   SELECT detanotc
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detanotc.dbf", "DBF", "¨ D¢nde est  DETANOTC.DBF ?")) ;
      AGAIN ALIAS detanotc SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("detanotp")
   SELECT detanotp
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detanotp.dbf", "DBF", "¨ D¢nde est  DETANOTP.DBF ?")) ;
      AGAIN ALIAS detanotp SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("detapag")
   SELECT detapag
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detapag.dbf", "DBF", "¨ D¢nde est  DETAPAG.DBF ?")) ;
      AGAIN ALIAS detapag SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("detapres")
   SELECT detapres
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detapres.dbf", "DBF", "¨ D¢nde est  DETAPRES.DBF ?")) ;
      AGAIN ALIAS detapres SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("detaremi")
   SELECT detaremi
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detaremi.dbf", "DBF", "¨ D¢nde est  DETAREMI.DBF ?")) ;
      AGAIN ALIAS detaremi SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("detavent")
   SELECT detavent
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detavent.dbf", "DBF", "¨ D¢nde est  DETAVENT.DBF ?")) ;
      AGAIN ALIAS detavent SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("division")
   SELECT division
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("division.dbf", "DBF", "¨ D¢nde est  DIVISION.DBF ?")) ;
      AGAIN ALIAS division SHARED ;
      ORDER 0
ENDIF
DO _DrawProgressBar

IF USED("estadoot")
   SELECT estadoot
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("estadoot.dbf", "DBF", "¨ D¢nde est  ESTADOOT.DBF ?")) ;
      AGAIN ALIAS estadoot SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("familias")
   SELECT familias
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("familias.dbf", "DBF", "¨ D¢nde est  FAMILIAS.DBF ?")) ;
      AGAIN ALIAS familias SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("locales")
   SELECT locales
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("locales.dbf", "DBF", "¨ D¢nde est  LOCALES.DBF ?")) ;
      AGAIN ALIAS locales SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("maesprod")
   SELECT maesprod
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("maesprod.dbf", "DBF", "¨ D¢nde est  MAESPROD.DBF ?")) ;
      AGAIN ALIAS maesprod SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("maquinas")
   SELECT maquinas
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("maquinas.dbf", "DBF", "¨ D¢nde est  MAQUINAS.DBF ?")) ;
      AGAIN ALIAS maquinas SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("marcas1")
   SELECT marcas1
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("marcas1.dbf", "DBF", "¨ D¢nde est  MARCAS1.DBF ?")) ;
      AGAIN ALIAS marcas1 SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("marcas2")
   SELECT marcas2
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("marcas2.dbf", "DBF", "¨ D¢nde est  MARCAS2.DBF ?")) ;
      AGAIN ALIAS marcas2 SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("mecancfg")
   SELECT mecancfg
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("mecancfg.dbf", "DBF", "¨ D¢nde est  MECANCFG.DBF ?")) ;
      AGAIN ALIAS mecancfg SHARED ;
      ORDER TAG 0
ENDIF
DO _DrawProgressBar

IF USED("mecanico")
   SELECT mecanico
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("mecanico.dbf", "DBF", "¨ D¢nde est  MECANICO.DBF ?")) ;
      AGAIN ALIAS mecanico SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("modelos")
   SELECT modelos
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("modelos.dbf", "DBF", "¨ D¢nde est  MODELOS.DBF ?")) ;
      AGAIN ALIAS modelos SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("monedas")
   SELECT monedas
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("monedas.dbf", "DBF", "¨ D¢nde est  MONEDAS.DBF ?")) ;
      AGAIN ALIAS monedas SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("motivocl")
   SELECT motivocl
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("motivocl.dbf", "DBF", "¨ D¢nde est  MOTIVOCL.DBF ?")) ;
      AGAIN ALIAS motivocl SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("motivono")
   SELECT motivono
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("motivono.dbf", "DBF", "¨ D¢nde est  MOTIVONO.DBF ?")) ;
      AGAIN ALIAS motivono SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("opciones")
   SELECT opciones
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("opciones.dbf", "DBF", "¨ D¢nde est  OPCIONES.DBF ?")) ;
      AGAIN ALIAS opciones SHARED ;
      ORDER 0
ENDIF
DO _DrawProgressBar

IF USED("ot")
   SELECT ot
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("ot.dbf", "DBF", "¨ D¢nde est  OT.DBF ?")) ;
      AGAIN ALIAS ot SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("ot2")
   SELECT ot2
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("ot2.dbf", "DBF", "¨ D¢nde est  OT2.DBF ?")) ;
      AGAIN ALIAS ot2 SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("proceden")
   SELECT proceden
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("proceden.dbf", "DBF", "¨ D¢nde est  PROCEDEN.DBF ?")) ;
      AGAIN ALIAS proceden SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("proveedo")
   SELECT proveedo
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("proveedo.dbf", "DBF", "¨ D¢nde est  PROVEEDO.DBF ?")) ;
      AGAIN ALIAS proveedo SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("rmaquina")
   SELECT rmaquina
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("rmaquina.dbf", "DBF", "¨ D¢nde est  RMAQUINA.DBF ?")) ;
      AGAIN ALIAS rmaquina SHARED ;
      ORDER 0
ENDIF
DO _DrawProgressBar

IF USED("rubros1")
   SELECT rubros1
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("rubros1.dbf", "DBF", "¨ D¢nde est  RUBROS1.DBF ?")) ;
      AGAIN ALIAS rubros1 SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("rubros2")
   SELECT rubros2 
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("rubros2.dbf", "DBF", "¨ D¢nde est  RUBROS2.DBF ?")) ;
      AGAIN ALIAS rubros2 SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("servicio")
   SELECT servicio
   SET ORDER TO TAG 0
ELSE
   SELECT 0
   USE (LOCFILE("servicio.dbf", "DBF", "¨ D¢nde est  SERVICIO.DBF ?")) ;
      AGAIN ALIAS servicio SHARED ;
      ORDER TAG 0
ENDIF
DO _DrawProgressBar

IF USED("trecep")
   SELECT trecep
   SET ORDER TO 0
ELSE
   SELECT 0
   USE (LOCFILE("trecep.dbf", "DBF", "¨ D¢nde est  TRECEP.DBF ?")) ;
      AGAIN ALIAS trecep SHARED ;
      ORDER 0
ENDIF
DO _DrawProgressBar

IF USED("unidad")
   SELECT unidad
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("unidad.dbf", "DBF", "¨ D¢nde est  UNIDAD.DBF ?")) ;
      AGAIN ALIAS unidad SHARED ;
      ORDER TAG indice1
ENDIF

IF USED("cabeimpo")
   SELECT cabeimpo
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cabeimpo.dbf", "DBF", "¨ D¢nde est  CABEIMPO.DBF ?")) ;
      AGAIN ALIAS cabeimpo SHARED ;
      ORDER TAG indice1
ENDIF

IF USED("detaimpo")
   SELECT detaimpo
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("detaimpo.dbf", "DBF", "¨ D¢nde est  DETAIMPO.DBF ?")) ;
      AGAIN ALIAS detaimpo SHARED ;
      ORDER TAG indice1
ENDIF

IF USED("cuotas_i")
   SELECT cuotas_i
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("cuotas_i.dbf", "DBF", "¨ D¢nde est  CUOTAS_I.DBF ?")) ;
      AGAIN ALIAS cuotas_i SHARED ;
      ORDER TAG indice1
ENDIF

DO _DrawProgressBar

IF USED("usercfg")
   SELECT usercfg
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("usercfg.dbf", "DBF", "¨ D¢nde est  USERCFG.DBF ?")) ;
      AGAIN ALIAS usercfg SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("usop")
   SELECT usop
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("usop.dbf", "DBF", "¨ D¢nde est  USOP.DBF ?")) ;
      AGAIN ALIAS usop SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("usuarios")
   SELECT usuarios
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("usuarios.dbf", "DBF", "¨ D¢nde est  USUARIOS.DBF ?")) ;
      AGAIN ALIAS usuarios SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("vendedor")
   SELECT vendedor
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("vendedor.dbf", "DBF", "¨ D¢nde est  VENDEDOR.DBF ?")) ;
      AGAIN ALIAS vendedor SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

IF USED("servicio")
   SELECT servicio
   SET ORDER TO TAG indice1
ELSE
   SELECT 0
   USE (LOCFILE("servicio.dbf", "DBF", "¨ D¢nde est  SERVICIO.DBF ?")) ;
      AGAIN ALIAS servicio SHARED ;
      ORDER TAG indice1
ENDIF
DO _DrawProgressBar

USE plazos   IN 0 ALIAS plazos   SHARED
USE cabeofer IN 0 ALIAS cabeofer SHARED
USE detaofer IN 0 ALIAS detaofer SHARED
USE pediarti IN 0 ALIAS pediarti SHARED

*SELECT barrios
*SET RELATION TO barrios.departamen INTO depar
*SET RELATION TO barrios.ciudad     INTO ciudades

*SELECT cabecob
*SET RELATION TO cabecob.cliente INTO clientes ADDITIVE

*SELECT cabecomp
*SET RELATION TO cabecomp.proveedor INTO proveedo ADDITIVE
*SET RELATION TO cabecomp.moneda    INTO monedas  ADDITIVE

*SELECT cabemot
*SET RELATION TO cabemot.serie + STR(cabemot.nrobole, 7) INTO ot ADDITIVE

*SELECT cabemovi
*SET RELATION TO cabemovi.local INTO locales ADDITIVE

*SELECT cabenotc
*SET RELATION TO cabenotc.cliente INTO clientes ADDITIVE

*SELECT cabenotp
*SET RELATION TO cabenotp.proveedor INTO proveedo ADDITIVE

*SELECT cabepag
*SET RELATION TO cabepag.proveedor INTO proveedo ADDITIVE
*SET RELATION TO cabepag.moneda    INTO monedas  ADDITIVE
*SET RELATION TO cabepag.id_local  INTO locales  ADDITIVE

*SELECT cabevent
*SET RELATION TO cabevent.cliente INTO clientes ADDITIVE
*SET RELATION TO cabevent.moneda  INTO monedas  ADDITIVE

*SELECT ciudades
*SET RELATION TO ciudades.departamen INTO depar

*SELECT clientes
*SET RELATION TO clientes.departamen INTO depar   
*SET RELATION TO clientes.ciudad     INTO ciudades
*SET RELATION TO clientes.barrio     INTO barrios  
*SET RELATION TO clientes.motivoclie INTO motivocl ADDITIVE

*SELECT detacomp
*SET RELATION TO detacomp.articulo INTO maesprod ADDITIVE

*SELECT detanotc
*SET RELATION TO detanotc.articulo INTO maesprod ADDITIVE

*SELECT detavent
*SET RELATION TO detavent.articulo INTO maesprod ADDITIVE
              
*SELECT maesprod
*SET RELATION TO maesprod.familia    INTO familias ADDITIVE   
*SET RELATION TO maesprod.rubro      INTO rubros1  ADDITIVE   
*SET RELATION TO maesprod.subrubro   INTO rubros2  ADDITIVE   
*SET RELATION TO maesprod.marca      INTO marcas1  ADDITIVE   
*SET RELATION TO maesprod.unidad     INTO unidad   ADDITIVE   
*SET RELATION TO maesprod.procedenci INTO proceden ADDITIVE   
*SET RELATION TO maesprod.proveedor  INTO proveedo ADDITIVE

*SELECT mecancfg
*SET RELATION TO mecancfg.articulo INTO maesprod ADDITIVE
*SET RELATION TO mecancfg.articulo INTO servicio 

*SELECT ot
*SET RELATION TO ot.marca    INTO marcas2  ADDITIVE
*SET RELATION TO ot.modelo   INTO modelos  ADDITIVE
*SET RELATION TO ot.estadoot INTO estadoot ADDITIVE

*SELECT servicio
*SET RELATION TO servicio.articulo INTO maesprod ADDITIVE

WAIT CLEAR
RELEASE WINDOW 

*!*********************************************************************
*!
*!      Funci¢n: _DrawProgressBar
*!
*!  Llamado por: OPENFILE.PRG                
*!
*!  Descripci¢n: Dibuja la barra de estado.
*!
*!*********************************************************************
FUNCTION _DrawProgressBar
pnNroTabla = pnNroTabla + 1  
@ 00,01 SAY PADR(REPLICATE(CHR(219), pnNroTabla), 51, CHR(176)) ;
   SIZE 1,51 ;
   PICTURE "@!" ;
   COLOR W/N