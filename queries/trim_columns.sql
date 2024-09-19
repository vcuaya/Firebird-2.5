/*
Query para limpiar los espacios en blanco al inicio y al final de las columnas de la tabla INVE01.

Caracteres a limpiar:
    - Espacios al inicio y al final
    - Tabulaciones (ASCII 9)
    - Espacios no separables (ASCII 160)
    - Saltos de línea (ASCII 13 y 10)

Columnas a limpiar:
    - CVE_ART
    - DESCR

Instrucciones:
    - Verificar que no existan productos duplicados, corre primero el query para verificar duplicados.
    - Si existen productos duplicados, corrígelos manualmente, es decir, elimina de la tabla el producto o productos duplicados.
    - Corre el query para limpiar los espacios en blanco al inicio y al final de las columnas de la tabla INVE01.

Advertencias:
    - Antes de limpiar la tabla INVE01, se debe limpiar la tabla MULT01.
    - Antes de limpiar la tabla MULT01 y la tabla INVE01, se debe verificar que no existan productos duplicados ya que la columna CVE_ART es la llave primaria de la tabla y debe ser única.
*/

-- Revisar duplicados
SELECT clean_cve_art, COUNT(*)
FROM (
    SELECT TRIM(BOTH FROM REPLACE(REPLACE(REPLACE(REPLACE(CVE_ART, ASCII_CHAR(9), ''), ASCII_CHAR(160), ''), ASCII_CHAR(13), ''), ASCII_CHAR(10), '')) AS clean_cve_art
    FROM INVE01 -- puedes cambiar por la tabla que necesites
) AS cleaned
GROUP BY clean_cve_art
HAVING COUNT(*) > 1;

-- Limpiar espacios en blanco al inicio y al final de las columnas
UPDATE INVE01 -- puedes cambiar por la tabla que necesites
SET CVE_ART = TRIM(BOTH FROM REPLACE(REPLACE(REPLACE(REPLACE(CVE_ART, ASCII_CHAR(9), ''), ASCII_CHAR(160), ''), ASCII_CHAR(13), ''), ASCII_CHAR(10), '')),
    DESCR = TRIM(BOTH FROM REPLACE(REPLACE(REPLACE(REPLACE(DESCR, ASCII_CHAR(9), ''), ASCII_CHAR(160), ''), ASCII_CHAR(13), ''), ASCII_CHAR(10), '')); -- verifica que la columna DESCR exista en la tabla o agrega la columna que necesites