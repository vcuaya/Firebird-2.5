-- =============================================================================
-- Consulta: Pedidos por Producto
-- Descripción: Reporte de ventas semanales, pedidos e inventarios por producto
-- =============================================================================

WITH ventas AS (
    SELECT
        cve_art AS producto,
        SUM(
            CASE
                WHEN DATEDIFF(DAY, DATE '2026-01-01', fechaelab) BETWEEN 00 AND 06 THEN
                    CASE
                        WHEN cve_cpto IN (51, 56) THEN cant
                        WHEN cve_cpto IN (2, 4)   THEN -cant
                        ELSE 0
                    END
                ELSE 0
            END
        ) AS semana_01,
        SUM(
            CASE
                WHEN DATEDIFF(DAY, DATE '2026-01-01', fechaelab) BETWEEN 07 AND 13 THEN
                    CASE
                        WHEN cve_cpto IN (51, 56) THEN cant
                        WHEN cve_cpto IN (2, 4)   THEN -cant
                        ELSE 0
                    END
                ELSE 0
            END
        ) AS semana_02,
        SUM(
            CASE
                WHEN DATEDIFF(DAY, DATE '2026-01-01', fechaelab) BETWEEN 14 AND 20 THEN
                    CASE
                        WHEN cve_cpto IN (51, 56) THEN cant
                        WHEN cve_cpto IN (2, 4)   THEN -cant
                        ELSE 0
                    END
                ELSE 0
            END
        ) AS semana_03,
        SUM(
            CASE
                WHEN DATEDIFF(DAY, DATE '2026-01-01', fechaelab) BETWEEN 21 AND 27 THEN
                    CASE
                        WHEN cve_cpto IN (51, 56) THEN cant
                        WHEN cve_cpto IN (2, 4)   THEN -cant
                        ELSE 0
                    END
                ELSE 0
            END
        ) AS semana_04,
        SUM(
            CASE
                WHEN DATEDIFF(DAY, DATE '2026-01-01', fechaelab) BETWEEN 28 AND 34 THEN
                    CASE
                        WHEN cve_cpto IN (51, 56) THEN cant
                        WHEN cve_cpto IN (2, 4)   THEN -cant
                        ELSE 0
                    END
                ELSE 0
            END
        ) AS semana_05,
        SUM(
            CASE
                WHEN DATEDIFF(DAY, DATE '2026-01-01', fechaelab) BETWEEN 35 AND 41 THEN
                    CASE
                        WHEN cve_cpto IN (51, 56) THEN cant
                        WHEN cve_cpto IN (2, 4)   THEN -cant
                        ELSE 0
                    END
                ELSE 0
            END
        ) AS semana_06,
        SUM(
            CASE
                WHEN DATEDIFF(DAY, DATE '2026-01-01', fechaelab) BETWEEN 42 AND 48 THEN
                    CASE
                        WHEN cve_cpto IN (51, 56) THEN cant
                        WHEN cve_cpto IN (2, 4)   THEN -cant
                        ELSE 0
                    END
                ELSE 0
            END
        ) AS semana_07,
        SUM(
            CASE
                WHEN DATEDIFF(DAY, DATE '2026-01-01', fechaelab) BETWEEN 49 AND 55 THEN
                    CASE
                        WHEN cve_cpto IN (51, 56) THEN cant
                        WHEN cve_cpto IN (2, 4)   THEN -cant
                        ELSE 0
                    END
                ELSE 0
            END
        ) AS semana_08,
        SUM(
            CASE
                WHEN DATEDIFF(DAY, DATE '2026-01-01', fechaelab) BETWEEN 56 AND 62 THEN
                    CASE
                        WHEN cve_cpto IN (51, 56) THEN cant
                        WHEN cve_cpto IN (2, 4)   THEN -cant
                        ELSE 0
                    END
                ELSE 0
            END
        ) AS semana_09,
        SUM(
            CASE
                WHEN DATEDIFF(DAY, DATE '2026-01-01', fechaelab) BETWEEN 63 AND 69 THEN
                    CASE
                        WHEN cve_cpto IN (51, 56) THEN cant
                        WHEN cve_cpto IN (2, 4)   THEN -cant
                        ELSE 0
                    END
                ELSE 0
            END
        ) AS semana_10,
        SUM(
            CASE
                WHEN DATEDIFF(DAY, DATE '2026-01-01', fechaelab) BETWEEN 70 AND 76 THEN
                    CASE
                        WHEN cve_cpto IN (51, 56) THEN cant
                        WHEN cve_cpto IN (2, 4)   THEN -cant
                        ELSE 0
                    END
                ELSE 0
            END
        ) AS semana_11,
        SUM(
            CASE
                WHEN DATEDIFF(DAY, DATE '2026-01-01', fechaelab) BETWEEN 77 AND 83 THEN
                    CASE
                        WHEN cve_cpto IN (51, 56) THEN cant
                        WHEN cve_cpto IN (2, 4)   THEN -cant
                        ELSE 0
                    END
                ELSE 0
            END
        ) AS semana_12,
        SUM(
            CASE
                WHEN DATEDIFF(DAY, DATE '2026-01-01', fechaelab) BETWEEN 84 AND 90 THEN
                    CASE
                        WHEN cve_cpto IN (51, 56) THEN cant
                        WHEN cve_cpto IN (2, 4)   THEN -cant
                        ELSE 0
                    END
                ELSE 0
            END
        ) AS semana_13,
        SUM(
            CASE
                WHEN DATEDIFF(DAY, DATE '2026-01-01', fechaelab) BETWEEN 91 AND 97 THEN
                    CASE
                        WHEN cve_cpto IN (51, 56) THEN cant
                        WHEN cve_cpto IN (2, 4)   THEN -cant
                        ELSE 0
                    END
                ELSE 0
            END
        ) AS semana_14
    FROM
        minve01
    WHERE
        fechaelab BETWEEN DATE '2026-01-01' AND CURRENT_DATE
        AND almacen IN (1, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18)
        AND cve_cpto IN (2, 4, 51, 56)
    GROUP BY
        cve_art
),

-- =============================================================================
-- CTE: Pedidos
-- Descripción: Cuenta pedidos únicos por producto donde el neto del periodo > 0
-- =============================================================================
pedidos AS (
    SELECT
        cve_art,
        COUNT(*) AS total_pedidos
    FROM (
        SELECT
            cve_art,
            refer,
            (
                MAX(CASE WHEN cve_cpto = 51   THEN 1 ELSE 0 END)
              - MAX(CASE WHEN cve_cpto IN (2, 4) THEN 1 ELSE 0 END)
              + MAX(CASE WHEN cve_cpto = 56   THEN 1 ELSE 0 END)
            ) AS neto_periodo
        FROM
            minve01
        WHERE
            fechaelab BETWEEN DATE '2026-01-01' AND CURRENT_DATE
            AND almacen IN (1, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18)
            AND cve_cpto IN (2, 4, 51, 56)
        GROUP BY
            cve_art,
            refer
    )
    WHERE
        neto_periodo > 0
    GROUP BY
        cve_art
),

-- =============================================================================
-- CTE: Existencias
-- Descripción: Suma inventario y genera lista de almacenes con existencia > 0
-- =============================================================================
existencias AS (
    SELECT
        cve_art,
        SUM(exist) AS total_exist,
        LIST(
            CASE
                WHEN exist > 0 THEN cve_alm
            END,
            ', '
        ) AS ubicacion
    FROM
        mult01
    WHERE
        cve_alm IN (1, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18)
    GROUP BY
        cve_art
)

-- =============================================================================
-- SELECT principal
-- Descripción: Une toda la información para el reporte final
-- =============================================================================
SELECT
    inve01.cve_art           AS "Clave",
    inve01.descr              AS "Descripcion",
    clin01.desc_lin          AS "Linea",
    inve_clib01.camplib3      AS "Marca",
    inve01.costo_prom         AS "Costo Promedio",

    -- Ventas semanales
    COALESCE(ventas.semana_01, 0) AS "Semana 01",
    COALESCE(ventas.semana_02, 0) AS "Semana 02",
    COALESCE(ventas.semana_03, 0) AS "Semana 03",
    COALESCE(ventas.semana_04, 0) AS "Semana 04",
    COALESCE(ventas.semana_05, 0) AS "Semana 05",
    COALESCE(ventas.semana_06, 0) AS "Semana 06",
    COALESCE(ventas.semana_07, 0) AS "Semana 07",
    COALESCE(ventas.semana_08, 0) AS "Semana 08",
    COALESCE(ventas.semana_09, 0) AS "Semana 09",
    COALESCE(ventas.semana_10, 0) AS "Semana 10",
    COALESCE(ventas.semana_11, 0) AS "Semana 11",
    COALESCE(ventas.semana_12, 0) AS "Semana 12",
    COALESCE(ventas.semana_13, 0) AS "Semana 13",
    COALESCE(ventas.semana_14, 0) AS "Semana 14",

    -- Totales
    COALESCE(SUM(mult01.exist), 0)       AS "Inventario Disponible",
    COALESCE(pedidos.total_pedidos, 0)    AS "Numero de Pedidos",
    COALESCE(existencias.ubicacion, '')  AS "Ubicacion"

FROM
    inve01
    LEFT JOIN clin01
        ON inve01.lin_prod = clin01.cve_lin
    LEFT JOIN inve_clib01
        ON inve01.cve_art = inve_clib01.cve_prod
    LEFT JOIN ventas
        ON inve01.cve_art = ventas.producto
    LEFT JOIN pedidos
        ON inve01.cve_art = pedidos.cve_art
    LEFT JOIN existencias
        ON inve01.cve_art = existencias.cve_art
    LEFT JOIN mult01
        ON inve01.cve_art = mult01.cve_art
        AND mult01.cve_alm IN (1, 2, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 18)

WHERE
    inve01.status = 'A'
    --AND inve01.cve_art = 'A11SPLT'  -- Descomentar para filtrar un producto

GROUP BY
    inve01.cve_art,
    inve01.descr,
    clin01.desc_lin,
    inve_clib01.camplib3,
    inve01.costo_prom,
    ventas.semana_01,
    ventas.semana_02,
    ventas.semana_03,
    ventas.semana_04,
    ventas.semana_05,
    ventas.semana_06,
    ventas.semana_07,
    ventas.semana_08,
    ventas.semana_09,
    ventas.semana_10,
    ventas.semana_11,
    ventas.semana_12,
    ventas.semana_13,
    ventas.semana_14,
    pedidos.total_pedidos,
    existencias.ubicacion;
