CLEAR ALL
CLEAR

SET CENTURY ON
SET DATE    BRITISH
SET DELETED ON
SET EXACT   ON
SET SAFETY  OFF
SET TALK    OFF

CREATE CURSOR tm_cuadro (;
   fila INTEGER,;
   empleado VARCHAR(40),;
   forma_pago VARCHAR(7),;
   precio_unit INTEGER,;
   hora1  INTEGER,;
   sueldo1 INTEGER,;
   hora2  INTEGER,;
   sueldo2 INTEGER,;
   hora3  INTEGER,;
   sueldo3 INTEGER,;
   hora4  INTEGER,;
   sueldo4 INTEGER,;
   hora5  INTEGER,;
   sueldo5 INTEGER,;
   hora6  INTEGER,;
   sueldo6 INTEGER,;
   p50a INTEGER,;
   p100a INTEGER,;
   p50b INTEGER,;
   p100b INTEGER,;
   total_hora INTEGER,;
   total_salario INTEGER,;
   aguinaldo INTEGER,;
   bonif_fam INTEGER,;
   vacaciones INTEGER,;
   otros_ingr INTEGER,;
   total INTEGER;
)

USE c:\datos IN 0 EXCLUSIVE

* sueldo minimo.
n_fila_1 = ROUND((((1507484 * 3) + (1658232 * 9)) / 12)/ 30, 0)
n_fila_2 = ROUND(1658232 / 30, 0)

* obtiene una lista de los empleados.
SELECT;
   DISTINC nombre;
FROM;
   datos;
ORDER BY;
   nombre;
WHERE;
   !EMPTY(nombre);
INTO CURSOR;
   tm_unique


* crea entradas dobles para cada empleado.
SELECT tm_unique
SCAN ALL
   c_nombre = nombre

   INSERT INTO tm_cuadro (fila, empleado, forma_pago);
      VALUES (1, c_nombre, "Mensual")
   INSERT INTO tm_cuadro (fila, empleado, forma_pago);
      VALUES (2, c_nombre, "Mensual")
ENDSCAN

* procesa el archivo de movimientos de los empleados.
SELECT datos
SCAN FOR !EMPTY(nombre)
   c_nombre = nombre
   n_mes  = mes
   n_dias = dias
   n_remuneraci = remuneraci
   n_aguinaldo  = aguinaldo
   n_bonif_fam  = bonif_fam
   n_vacaciones = vacaciones
   n_otros_ingr = otros_ingr

   DO CASE
      CASE INLIST(n_mes, 1, 7)
         IF n_mes = 1 THEN
            SELECT tm_cuadro
            LOCATE FOR empleado = c_nombre AND fila = 1
            IF FOUND() THEN
               REPLACE hora1  WITH hora1  + (n_dias * 8),;
                       sueldo1 WITH sueldo1 + n_remuneraci,;
                       aguinaldo  WITH aguinaldo  + n_aguinaldo,;
                       bonif_fam  WITH bonif_fam  + n_bonif_fam,;
                       vacaciones WITH vacaciones + n_vacaciones,;
                       otros_ingr WITH otros_ingr + n_otros_ingr
            ENDIF
         ELSE
            SELECT tm_cuadro
            LOCATE FOR empleado = c_nombre AND fila = 2
            IF FOUND() THEN
               REPLACE hora1  WITH hora1  + (n_dias * 8),;
                       sueldo1 WITH sueldo1 + n_remuneraci,;
                       aguinaldo  WITH aguinaldo  + n_aguinaldo,;
                       bonif_fam  WITH bonif_fam  + n_bonif_fam,;
                       vacaciones WITH vacaciones + n_vacaciones,;
                       otros_ingr WITH otros_ingr + n_otros_ingr
            ENDIF
         ENDIF
      CASE INLIST(n_mes, 2, 8)
         IF n_mes = 2 THEN
            SELECT tm_cuadro
            LOCATE FOR empleado = c_nombre AND fila = 1
            IF FOUND() THEN
               REPLACE hora2  WITH hora2  + (n_dias * 8),;
                       sueldo2 WITH sueldo2 + n_remuneraci,;
                       aguinaldo  WITH aguinaldo  + n_aguinaldo,;
                       bonif_fam  WITH bonif_fam  + n_bonif_fam,;
                       vacaciones WITH vacaciones + n_vacaciones,;
                       otros_ingr WITH otros_ingr + n_otros_ingr
            ENDIF
         ELSE
            SELECT tm_cuadro
            LOCATE FOR empleado = c_nombre AND fila = 2
            IF FOUND() THEN
               REPLACE hora2  WITH hora2  + (n_dias * 8),;
                       sueldo2 WITH sueldo2 + n_remuneraci,;
                       aguinaldo  WITH aguinaldo  + n_aguinaldo,;
                       bonif_fam  WITH bonif_fam  + n_bonif_fam,;
                       vacaciones WITH vacaciones + n_vacaciones,;
                       otros_ingr WITH otros_ingr + n_otros_ingr
            ENDIF
         ENDIF
      CASE INLIST(n_mes, 3, 9)
         IF n_mes = 3 THEN
            SELECT tm_cuadro
            LOCATE FOR empleado = c_nombre AND fila = 1
            IF FOUND() THEN
               REPLACE hora3  WITH hora3  + (n_dias * 8),;
                       sueldo3 WITH sueldo3 + n_remuneraci,;
                       aguinaldo  WITH aguinaldo  + n_aguinaldo,;
                       bonif_fam  WITH bonif_fam  + n_bonif_fam,;
                       vacaciones WITH vacaciones + n_vacaciones,;
                       otros_ingr WITH otros_ingr + n_otros_ingr
            ENDIF
         ELSE
            SELECT tm_cuadro
            LOCATE FOR empleado = c_nombre AND fila = 2
            IF FOUND() THEN
               REPLACE hora3  WITH hora3  + (n_dias * 8),;
                       sueldo3 WITH sueldo3 + n_remuneraci,;
                       aguinaldo  WITH aguinaldo  + n_aguinaldo,;
                       bonif_fam  WITH bonif_fam  + n_bonif_fam,;
                       vacaciones WITH vacaciones + n_vacaciones,;
                       otros_ingr WITH otros_ingr + n_otros_ingr
            ENDIF
         ENDIF
      CASE INLIST(n_mes, 4, 10)
         IF n_mes = 4 THEN
            SELECT tm_cuadro
            LOCATE FOR empleado = c_nombre AND fila = 1
            IF FOUND() THEN
               REPLACE hora4  WITH hora4  + (n_dias * 8),;
                       sueldo4 WITH sueldo4 + n_remuneraci,;
                       aguinaldo  WITH aguinaldo  + n_aguinaldo,;
                       bonif_fam  WITH bonif_fam  + n_bonif_fam,;
                       vacaciones WITH vacaciones + n_vacaciones,;
                       otros_ingr WITH otros_ingr + n_otros_ingr
            ENDIF
         ELSE
            SELECT tm_cuadro
            LOCATE FOR empleado = c_nombre AND fila = 2
            IF FOUND() THEN
               REPLACE hora4  WITH hora4  + (n_dias * 8),;
                       sueldo4 WITH sueldo4 + n_remuneraci,;
                       aguinaldo  WITH aguinaldo  + n_aguinaldo,;
                       bonif_fam  WITH bonif_fam  + n_bonif_fam,;
                       vacaciones WITH vacaciones + n_vacaciones,;
                       otros_ingr WITH otros_ingr + n_otros_ingr
            ENDIF
         ENDIF
      CASE INLIST(n_mes, 5, 11)
         IF n_mes = 5 THEN
            SELECT tm_cuadro
            LOCATE FOR empleado = c_nombre AND fila = 1
            IF FOUND() THEN
               REPLACE hora5  WITH hora5  + (n_dias * 8),;
                       sueldo5 WITH sueldo5 + n_remuneraci,;
                       aguinaldo  WITH aguinaldo  + n_aguinaldo,;
                       bonif_fam  WITH bonif_fam  + n_bonif_fam,;
                       vacaciones WITH vacaciones + n_vacaciones,;
                       otros_ingr WITH otros_ingr + n_otros_ingr
            ENDIF
         ELSE
            SELECT tm_cuadro
            LOCATE FOR empleado = c_nombre AND fila = 2
            IF FOUND() THEN
               REPLACE hora5  WITH hora5  + (n_dias * 8),;
                       sueldo5 WITH sueldo5 + n_remuneraci,;
                       aguinaldo  WITH aguinaldo  + n_aguinaldo,;
                       bonif_fam  WITH bonif_fam  + n_bonif_fam,;
                       vacaciones WITH vacaciones + n_vacaciones,;
                       otros_ingr WITH otros_ingr + n_otros_ingr
            ENDIF
         ENDIF
      CASE INLIST(n_mes, 6, 12)
         IF n_mes = 6 THEN
            SELECT tm_cuadro
            LOCATE FOR empleado = c_nombre AND fila = 1
            IF FOUND() THEN
               REPLACE hora6  WITH hora6  + (n_dias * 8),;
                       sueldo6 WITH sueldo6 + n_remuneraci,;
                       aguinaldo  WITH aguinaldo  + n_aguinaldo,;
                       bonif_fam  WITH bonif_fam  + n_bonif_fam,;
                       vacaciones WITH vacaciones + n_vacaciones,;
                       otros_ingr WITH otros_ingr + n_otros_ingr
            ENDIF
         ELSE
            SELECT tm_cuadro
            LOCATE FOR empleado = c_nombre AND fila = 2
            IF FOUND() THEN
               REPLACE hora6  WITH hora6  + (n_dias * 8),;
                       sueldo6 WITH sueldo6 + n_remuneraci,;
                       aguinaldo  WITH aguinaldo  + n_aguinaldo,;
                       bonif_fam  WITH bonif_fam  + n_bonif_fam,;
                       vacaciones WITH vacaciones + n_vacaciones,;
                       otros_ingr WITH otros_ingr + n_otros_ingr
            ENDIF
         ENDIF
   ENDCASE
ENDSCAN

* calcula los totales del cuadro
SELECT tm_cuadro
SCAN ALL
   c_empleado = PROPER(empleado)
   n_total_hora = hora1 + hora2 + hora3 + hora4 + hora5 + hora6
   n_total_salario = sueldo1 + sueldo2 + sueldo3 + sueldo4 + sueldo5 + sueldo6
   n_total = n_total_salario + aguinaldo + bonif_fam + vacaciones + otros_ingr

   REPLACE empleado WITH c_empleado,;
           precio_unit WITH IIF(fila = 1, n_fila_1, n_fila_2),;
           total_hora WITH n_total_hora,;
           total_salario WITH n_total_salario,;
           total WITH n_total
ENDSCAN

*!*	* obtiene una lista de los empleados.
*!*	SELECT;
*!*	   empleado,;
*!*	   COUNT(*) AS cantidad;
*!*	FROM;
*!*	   tm_cuadro;
*!*	WHERE;
*!*	   total <> 0;
*!*	GROUP BY;
*!*	   empleado;
*!*	HAVING;
*!*	   cantidad > 1;
*!*	INTO CURSOR;
*!*	   tm_unique

*!*	SELECT tm_unique
*!*	SCAN ALL
*!*	   c_empleado = empleado
*!*	   SELECT tm_cuadro
*!*	   LOCATE FOR empleado = c_empleado AND fila = 2
*!*	   IF FOUND() THEN
*!*	      REPLACE empleado WITH ""
*!*	   ENDIF
*!*	ENDSCAN

* muestra el cuadro y lo exporta en la unidad C como tm_cuadro.xls
SELECT tm_cuadro
REPLACE empleado WITH "" FOR fila = 2
BROWSE
EXPORT TO c:\tm_cuadro TYPE XL5