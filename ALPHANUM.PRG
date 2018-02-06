* Delete in a string the following ASCII characters:
*INDEX ON alphanum(codigo2) TAG indice14 OF maesprod.cdx


*
* ALPHANUM.PRG - Elimina de una cadena de texto los siguientes caracteres:
*                " "  - Espacio en blanco.
*                "-"  - Gui¢n.
*                "/"  - Barra de divisi¢n. 
PARAMETER cString

cString = STRTRAN(cString, " ", "")
cString = STRTRAN(cString, "-", "")
cString = STRTRAN(cString, "/", "")

RETURN (cString)