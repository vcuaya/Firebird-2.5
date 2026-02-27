-- Nueva solicitud
WITH compras AS (
    SELECT
        cve_art AS producto,

        SUM(CASE WHEN DATEDIFF(DAY, DATE '2025-11-17', fechaelab) BETWEEN 00 AND 06 THEN cant * signo ELSE 0 END) AS semana_01,
        SUM(CASE WHEN DATEDIFF(DAY, DATE '2025-11-17', fechaelab) BETWEEN 07 AND 13 THEN cant * signo ELSE 0 END) AS semana_02,
        SUM(CASE WHEN DATEDIFF(DAY, DATE '2025-11-17', fechaelab) BETWEEN 14 AND 20 THEN cant * signo ELSE 0 END) AS semana_03,
        SUM(CASE WHEN DATEDIFF(DAY, DATE '2025-11-17', fechaelab) BETWEEN 21 AND 27 THEN cant * signo ELSE 0 END) AS semana_04,
        SUM(CASE WHEN DATEDIFF(DAY, DATE '2025-11-17', fechaelab) BETWEEN 28 AND 34 THEN cant * signo ELSE 0 END) AS semana_05,
        SUM(CASE WHEN DATEDIFF(DAY, DATE '2025-11-17', fechaelab) BETWEEN 35 AND 41 THEN cant * signo ELSE 0 END) AS semana_06,
        SUM(CASE WHEN DATEDIFF(DAY, DATE '2025-11-17', fechaelab) BETWEEN 42 AND 48 THEN cant * signo ELSE 0 END) AS semana_07,
        SUM(CASE WHEN DATEDIFF(DAY, DATE '2025-11-17', fechaelab) BETWEEN 49 AND 55 THEN cant * signo ELSE 0 END) AS semana_08,
        SUM(CASE WHEN DATEDIFF(DAY, DATE '2025-11-17', fechaelab) BETWEEN 56 AND 62 THEN cant * signo ELSE 0 END) AS semana_09,
        SUM(CASE WHEN DATEDIFF(DAY, DATE '2025-11-17', fechaelab) BETWEEN 63 AND 69 THEN cant * signo ELSE 0 END) AS semana_10,
        SUM(CASE WHEN DATEDIFF(DAY, DATE '2025-11-17', fechaelab) BETWEEN 70 AND 76 THEN cant * signo ELSE 0 END) AS semana_11,
        SUM(CASE WHEN DATEDIFF(DAY, DATE '2025-11-17', fechaelab) BETWEEN 77 AND 83 THEN cant * signo ELSE 0 END) AS semana_12,
        SUM(CASE WHEN DATEDIFF(DAY, DATE '2025-11-17', fechaelab) BETWEEN 84 AND 90 THEN cant * signo ELSE 0 END) AS semana_13,
        SUM(CASE WHEN DATEDIFF(DAY, DATE '2025-11-17', fechaelab) BETWEEN 91 AND 97 THEN cant * signo ELSE 0 END) AS semana_14

    FROM minve01
    WHERE
        fechaelab >= DATE '2025-11-17'
        AND fechaelab <= CURRENT_DATE
        AND tipo_doc IN ('c', 'r', 'd')
        AND almacen IN ('1', '5', '12', '13', '14', '16')
    GROUP BY cve_art
),

pedidos AS (
    SELECT
        cve_art,
        COUNT(*) AS total_pedidos
    FROM (
        SELECT
            cve_art,
            refer,
            SUM(cant * signo * -1) AS neto_periodo
        FROM minve01
        WHERE
            tipo_doc IN ('F','R','V','D')
            AND almacen IN (1,2,5,6,7,8,9,10,11,12,13,14,15,16,18)
            AND fechaelab BETWEEN DATE '2025-11-17' AND CURRENT_DATE
        GROUP BY
            cve_art,
            refer
    ) t
    WHERE neto_periodo > 0
    GROUP BY cve_art
),

existencias AS (
    SELECT
        cve_art,
        SUM(exist) AS total_exist,
        LIST(
            CASE WHEN exist > 0 THEN cve_alm END, ', '
        ) AS ubicacion
    FROM mult01
    WHERE cve_alm IN (1,2,5,6,7,8,9,10,11,12,13,14,15,16,18)
    GROUP BY cve_art
)

SELECT
    inve01.cve_art AS "Clave",
    inve01.descr AS "Descripción",
    inve_clib01.camplib3 AS "Marca",
    inve01.costo_prom AS "Costo Promedio",

    COALESCE(compras.semana_01, 0) AS "Semana 01",
    COALESCE(compras.semana_02, 0) AS "Semana 02",
    COALESCE(compras.semana_03, 0) AS "Semana 03",
    COALESCE(compras.semana_04, 0) AS "Semana 04",
    COALESCE(compras.semana_05, 0) AS "Semana 05",
    COALESCE(compras.semana_06, 0) AS "Semana 06",
    COALESCE(compras.semana_07, 0) AS "Semana 07",
    COALESCE(compras.semana_08, 0) AS "Semana 08",
    COALESCE(compras.semana_09, 0) AS "Semana 09",
    COALESCE(compras.semana_10, 0) AS "Semana 10",
    COALESCE(compras.semana_11, 0) AS "Semana 11",
    COALESCE(compras.semana_12, 0) AS "Semana 12",
    COALESCE(compras.semana_13, 0) AS "Semana 13",
    COALESCE(compras.semana_14, 0) AS "Semana 14",

    COALESCE(SUM(mult01.exist), 0) AS "Inventario Disponible",

    COALESCE(pedidos.total_pedidos, 0) AS "Número de Pedidos",
    
		COALESCE(existencias.ubicacion, '') AS "Ubicación"

FROM inve01

LEFT JOIN inve_clib01 ON inve01.cve_art = inve_clib01.cve_prod
LEFT JOIN compras ON inve01.cve_art = compras.producto
LEFT JOIN pedidos ON inve01.cve_art = pedidos.cve_art
LEFT JOIN existencias ON inve01.cve_art = existencias.cve_art
LEFT JOIN mult01 
    ON inve01.cve_art = mult01.cve_art
    AND mult01.cve_alm IN (1,2,5,6,7,8,9,10,11,12,13,14,15,16,18)

WHERE inve01.status = 'A'
--		AND inve01.cve_art = '81S77LT-V2'

GROUP BY
    inve01.cve_art,
    inve01.descr,
    inve_clib01.camplib3,
    inve01.costo_prom,
    compras.semana_01,
    compras.semana_02,
    compras.semana_03,
    compras.semana_04,
    compras.semana_05,
    compras.semana_06,
    compras.semana_07,
    compras.semana_08,
    compras.semana_09,
    compras.semana_10,
    compras.semana_11,
    compras.semana_12,
    compras.semana_13,
    compras.semana_14,
    pedidos.total_pedidos,
    existencias.ubicacion;