W_NOMSER = "\\servidor"
W_SERVER = "Net TIME " + W_NOMSER + " /SET /YES"
oShell = CREATEOBJECT("Wscript.Shell")
? oShell.Run((W_SERVER),0,.t.)