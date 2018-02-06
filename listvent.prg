PROCEDURE footer
*       1        2         3          4         5         6         7 
* +----------------------------------------------------------------------+
* | % I.V.A |  MONTO  |   DTO.  |   NETO   | GRAVADA | EXENTA | IMPUESTO |
* +----------------------------------------------------------------------+


   PRIVATE m.decimales, m.iva_inclui, m.iva_base, aImpuesto, m.pos, m.count
   DIMENSION aImpuesto[1,4]

   m.decimales  = IIF(m.moneda = 1, 0, 2)
   m.iva_inclui = IIF(INLIST(m.tipodocu, 3, 7, 8), .T., .F.)
   m.iva_base   = 10
   aImpuesto    = 0
   m.pos        = 0
   m.count      = ALEN(aImpuesto, 1)
   STORE 0 TO m.suma_grav, m.suma_exen, m.suma_iva

   SELECT tmpdetvent
   SCAN ALL
      m.monto_linea = ROUND(precio * cantidad, m.decimales)
      m.desc_linea  = ROUND(m.monto_linea * pdescuento / 100, m.decimales)
      m.monto_neto  = m.monto_linea - m.desc_linea
      
      m.suma_total  = m.suma_total + m.monto_neto 

      m.pos = ASCAN(aImpuesto, pimpuesto, 1)

      IF m.pos = 0
         m.count = m.count + 1
         DIMENSION aImpuesto[m.count,4]

         aImpuesto[m.count,1] = pimpuesto
         aImpuesto[m.count,2] = aImpuesto[m.count,2] + m.monto_neto
      ELSE
         aImpuesto[m.pos,1] = pimpuesto
         aImpuesto[m.pos,2] = aImpuesto[m.count,2] + m.monto_neto
      ENDIF
   ENDSCAN

   IF m.porcdesc > 0 THEN
      m.importdesc = ROUND(m.suma_total * m.porcdesc / 100, m.decimales)
   ELSE
      IF m.importdesc > 0 THEN
         m.porcdesc = ROUND(m.importdesc * 100 / m.suma_total, 4)
      ENDIF
   ENDIF

   FOR m.index = 1 TO ALEN(aImpuesto, 1)
      aImpuesto[m.index,3] = ROUND(aImpuesto[m.index,2] * m.porcdesc / 100, m.decimales)
      aImpuesto[m.index,4] = aImpuesto[m.index,2] - aImpuesto[m.index,3]
      
      IF m.iva_inclui THEN
         IF aImpuesto[m.index,1] > 0 THEN
            m.base_imponible = ROUND(aImpuesto[m.index,4] / (1 + aImpuesto[m.index,1] / 100), m.decimales)
            m.gravada = ROUND(m.base_imponible * aImpuesto[m.index,1] * m.iva_base / 100, m.decimales)
            m.exenta  = m.base_imponible - m.gravada
            m.iva     = aImpuesto[m.index,4] - m.base_imponible
         ELSE
            m.gravada = 0
            m.exenta  = aImpuesto[m.index,4]
            m.iva     = 0
         ENDIF

         aImpuesto[m.index,5] = m.gravada
         aImpuesto[m.index,6] = m.exenta
         aImpuesto[m.index,7] = m.iva
      ELSE
         aImpuesto[m.index,5] = ROUND(aImpuesto[m.index,4] * aImpuesto[m.index,1] * m.iva_base / 100, m.decimales)
         aImpuesto[m.index,6] = aImpuesto[m.index,4] - aImpuesto[m.index,5]
         aImpuesto[m.index,7] = ROUND(aImpuesto[m.index,4] * aImpuesto[m.index,1] / 100, m.decimales)
      ENDIF
      
      m.suma_grav = m.suma_grav + aImpuesto[m.index,5]
      m.suma_exen = m.suma_exen + aImpuesto[m.index,6]
      m.suma_iva  = m.suma_iva  + aImpuesto[m.index,7]
   ENDFOR

*ENDPROC