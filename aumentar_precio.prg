CLEAR
CLEAR ALL

SET DATE    BRITISH
SET DELETED ON
SET CENTURY ON
SET SAFETY  OFF

lnPorcAumento = 5   && El valor debe estar en tanto porciento

USE maesprod IN 0 SHARED

CREATE CURSOR new_list (;
   codigo C(15),;
   nombre C(40),;
   familia N(5),;
   marca N(5),;
   pvpg1 N(13,4),;
   pvpg2 N(13,4),;
   pvpg3 N(13,4),;
   pvpg4 N(13,4),;
   pvpg5 N(13,4),;
   pvpd1 N(13,4),;
   pvpd2 N(13,4),;
   pvpd3 N(13,4),;
   pvpd4 N(13,4),;
   pvpd5 N(13,4);
);

SELECT * FROM maesprod WHERE familia = 23 AND marca = 8 INTO CURSOR temp

SELECT temp
SCAN ALL
   SCATTER MEMVAR MEMO
   pvpg1 = ROUND(pventag1 * (1 + pimpuesto / 100), 0)
   pvpg2 = ROUND(pventag2 * (1 + pimpuesto / 100), 0)
   pvpg3 = ROUND(pventag3 * (1 + pimpuesto / 100), 0)
   pvpg4 = pventag4
   pvpg5 = pventag5
   pvpd1 = pventad1
   pvpd2 = pventad2
   pvpd3 = pventad3
   pvpd4 = pventad4
   pvpd5 = pventad5
   INSERT INTO new_list FROM MEMVAR
ENDSCAN

SELECT new_list
EXPORT TO c:\old_list TYPE XLS

SELECT new_list
SCAN ALL
   REPLACE pvpg1 WITH pvpg1 * (1 + lnPorcAumento / 100)
   REPLACE pvpg2 WITH pvpg2 * (1 + lnPorcAumento / 100)
   REPLACE pvpg3 WITH pvpg3 * (1 + lnPorcAumento / 100)
   REPLACE pvpg4 WITH pvpg4 * (1 + lnPorcAumento / 100)
   REPLACE pvpg5 WITH pvpg5 * (1 + lnPorcAumento / 100)

   REPLACE pvpd1 WITH pvpd1 * (1 + lnPorcAumento / 100)
   REPLACE pvpd2 WITH pvpd2 * (1 + lnPorcAumento / 100)
   REPLACE pvpd3 WITH pvpd3 * (1 + lnPorcAumento / 100)
   REPLACE pvpd4 WITH pvpd4 * (1 + lnPorcAumento / 100)
   REPLACE pvpd5 WITH pvpd5 * (1 + lnPorcAumento / 100)
  
   IF pvpg1 > 0 THEN
      m.pvpg1 = ROUND(pvpg1, 0)
      IF RIGHT(STR(m.pvpg1), 2) > "00" .AND. ;
         RIGHT(STR(m.pvpg1), 2) < "50"
         m.pvpg1 = (m.pvpg1 - VAL(RIGHT(STR(m.pvpg1), 2)) + 50)
      ELSE
         IF RIGHT(STR(m.pvpg1), 2) <= "99" .AND. ;
            RIGHT(STR(m.pvpg1), 2) > "50"
            m.pvpg1 = (m.pvpg1 - VAL(RIGHT(STR(m.pvpg1), 2)) + 100)
         ENDIF
      ENDIF
      
      REPLACE pvpg1 WITH m.pvpg1 / 1.1
   ENDIF

   IF pvpg2 > 0 THEN
      m.pvpg2 = ROUND(pvpg2, 0)
      IF RIGHT(STR(m.pvpg2), 2) > "00" .AND. ;
         RIGHT(STR(m.pvpg2), 2) < "50"
         m.pvpg2 = (m.pvpg2 - VAL(RIGHT(STR(m.pvpg2), 2)) + 50)
      ELSE
         IF RIGHT(STR(m.pvpg2), 2) <= "99" .AND. ;
            RIGHT(STR(m.pvpg2), 2) > "50"
            m.pvpg2 = (m.pvpg2 - VAL(RIGHT(STR(m.pvpg2), 2)) + 100)
         ENDIF
      ENDIF
      
      REPLACE pvpg2 WITH m.pvpg2 / 1.1
   ENDIF
   
   IF pvpg3 > 0 THEN
      m.pvpg3 = ROUND(pvpg3, 0)
      IF RIGHT(STR(m.pvpg3), 2) > "00" .AND. ;
         RIGHT(STR(m.pvpg3), 2) < "50"
         m.pvpg3 = (m.pvpg3 - VAL(RIGHT(STR(m.pvpg3), 2)) + 50)
      ELSE
         IF RIGHT(STR(m.pvpg3), 2) <= "99" .AND. ;
            RIGHT(STR(m.pvpg3), 2) > "50"
            m.pvpg3 = (m.pvpg3 - VAL(RIGHT(STR(m.pvpg3), 2)) + 100)
         ENDIF
      ENDIF
      
      REPLACE pvpg3 WITH m.pvpg3 / 1.1
   ENDIF
ENDSCAN

SELECT new_list
EXPORT TO c:\new_list TYPE XLS

SELECT new_list
SCAN ALL
   lcArticulo = codigo
   SELECT maesprod
   SET ORDER TO 1
   IF SEEK(lcArticulo) THEN
      REPLACE pventag1 WITH new_list.pvpg1
      REPLACE pventag2 WITH new_list.pvpg2
      REPLACE pventag3 WITH new_list.pvpg3
      REPLACE pventag4 WITH new_list.pvpg4
      REPLACE pventag5 WITH new_list.pvpg5
      REPLACE pventad1 WITH new_list.pvpd1
      REPLACE pventad2 WITH new_list.pvpd2
      REPLACE pventad3 WITH new_list.pvpd3
      REPLACE pventad4 WITH new_list.pvpd4
      REPLACE pventad5 WITH new_list.pvpd5
   ELSE
      WAIT "El articulo: " + ALLTRIM(lcArticulo) + " no existe." WINDOW
   ENDIF
ENDSCAN