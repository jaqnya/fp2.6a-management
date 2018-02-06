LOCAL c_servidor, c_base_datos, c_usuario, c_password, c_puerto, c_cadena_conexion
c_controlador = "MySQL ODBC 5.1 Driver"
c_servidor = "localhost"
c_base_datos = "test"
c_usuario = "root"
c_password = "usbw"
c_puerto = "3307"

*!*	SQLSETPROP(0,"DispLogin",3)

c_cadena_conexion = "DRIVER=" + c_controlador +;
                    ";PORT=" + c_puerto +;
                    ";SERVER=" + c_servidor +;
                    ";DATABASE=" + c_base_datos +;
                    ";UID=" + c_usuario +;
                    ";PWD=" + c_password

IF SQLSTRINGCONNECT(c_cadena_conexion) > 0 THEN
   WAIT "Conectado" WINDOW NOWAIT
ELSE
   WAIT "Imposible conectar" WINDOW NOWAIT
ENDIF

MESSAGEBOX(c_cadena_conexion)