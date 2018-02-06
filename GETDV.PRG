*
* obtener_dv.prg
*
* Derechos Reservados (c) 2000 - 2009 TurtleCorp
* Acosta Nu No. 143
* Tres Bocas, Villa Elisa, Paraguay
* Telefono: (021) 943-125 / Movil: (0961) 512-679 o (0985) 943-522
*
* Descripcion:
* Calcula el digito verificador del RUC
*
* Historial de Modificacion:
* Enero 03, 2009	Jose Avilio Acuna Acosta	Creador del Programa
*
PARAMETERS m.ruc

PRIVATE m.dv
m.dv = calcular(m.ruc, 11)

RETURN (m.dv)

*--------------------------------------------------------------------------------------------*
FUNCTION calcular
   PARAMETERS m.numero, m.basemax

   PRIVATE m.numero_al, i, m.caracter, k, m.total, m.numero_aux, m.resto, m.digito

   m.numero_al = ""

   FOR i = 1 TO LEN(m.numero)
      m.caracter = UPPER(SUBSTR(m.numero, i, 1))

      IF !BETWEEN(ASC(m.caracter), 48, 57) THEN
         m.numero_al = m.numero_al + ALLTRIM(STR(ASC(m.caracter)))
      ELSE
         m.numero_al = m.numero_al + m.caracter
      ENDIF
   ENDFOR

   k = 2
   m.total = 0

   FOR i = LEN(m.numero_al) TO 1 STEP -1
      IF k > m.basemax THEN
         k = 2
      ENDIF

      m.numero_aux = VAL(SUBSTR(m.numero_al, i, 1))
      m.total = m.total + (m.numero_aux * k)
      k = k + 1
   ENDFOR

   m.resto = MOD(m.total, 11)

   IF m.resto > 1 THEN
      m.digito = 11 - m.resto
   ELSE
      m.digito = 0
   ENDIF

   RETURN (m.digito)
*ENDFUNC