PARAMETERS tnNroDocu

PRIVATE lcRetorno

DO CASE
   CASE BETWEEN(tnNroDocu, 1000000, 1999999)
      lcRetorno = '001-001-' + TRANSFORM(tnNroDocu - 1000000, '@L 999999')
   CASE BETWEEN(tnNroDocu, 2000000, 2999999)
      lcRetorno = '001-002-' + TRANSFORM(tnNroDocu - 2000000, '@L 999999')
   CASE BETWEEN(tnNroDocu, 3000000, 3999999)
      lcRetorno = '003-001-' + TRANSFORM(tnNroDocu - 3000000, '@L 999999')
   CASE BETWEEN(tnNroDocu, 4000000, 4999999)
      lcRetorno = '001-001-' + TRANSFORM(tnNroDocu - 4000000, '@L 999999')
   OTHERWISE
      lcRetorno = STR(tnNroDocu, 15)
ENDCASE

RETURN lcRetorno
