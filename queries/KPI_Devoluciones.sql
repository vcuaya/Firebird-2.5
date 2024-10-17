/*
    Este query selecciona el nombre y cuenta los valores distintos de REFER
    de la tabla MINVE01. Realiza una unión a la izquierda con la tabla VEND01
    en la columna VEND. Filtra los registros donde la fecha de elaboración
    está dentro de los últimos 7 días, y los valores de la columna concepto
    de MINVE01 está en los valores '2', '4', '5'.
    Finalmente, agrupa los resultados por NOMBRE.
*/

SELECT
    NOMBRE,
    COUNT(DISTINCT REFER)
FROM
    MINVE01
LEFT JOIN
    VEND01 ON MINVE01.VEND = VEND01.CVE_VEND
WHERE
    CAST(FECHAELAB AS DATE) BETWEEN CURRENT_DATE -7 AND CURRENT_DATE -1
    AND MINVE01.CVE_CPTO IN ('2', '4', '5')
GROUP BY NOMBRE;
