/*
 Query para obtener el saldo por almacén
 */
SELECT cve_alm,
    sum(mult01.exist * costo_prom)
FROM mult01
    INNER JOIN inve01 ON mult01.cve_art = inve01.cve_art
GROUP BY cve_alm