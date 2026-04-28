WITH ventas_base AS (
    SELECT
        cve_art AS producto,
        FLOOR(
            DATEDIFF(
                DAY,
                CAST(EXTRACT(YEAR FROM fechaelab) || '-01-01' AS DATE),
                fechaelab
            ) / 7
        ) + 1 AS semana,
        CASE
            WHEN cve_cpto IN (51, 56) THEN cant
            WHEN cve_cpto IN (2, 4) THEN -cant
            ELSE 0
        END AS cantidad
    FROM minve01
    WHERE
        EXTRACT(YEAR FROM fechaelab) = EXTRACT(YEAR FROM CURRENT_DATE)
        AND fechaelab <= CURRENT_DATE
        AND almacen IN (1,2,5,6,7,8,9,10,11,12,13,14,15,16,18)
        AND cve_cpto IN (2,4,51,56)
),

ventas AS (
    SELECT
        producto,

        SUM(CASE WHEN semana = 1 THEN cantidad ELSE 0 END) AS semana_01,
        SUM(CASE WHEN semana = 2 THEN cantidad ELSE 0 END) AS semana_02,
        SUM(CASE WHEN semana = 3 THEN cantidad ELSE 0 END) AS semana_03,
        SUM(CASE WHEN semana = 4 THEN cantidad ELSE 0 END) AS semana_04,
        SUM(CASE WHEN semana = 5 THEN cantidad ELSE 0 END) AS semana_05,
        SUM(CASE WHEN semana = 6 THEN cantidad ELSE 0 END) AS semana_06,
        SUM(CASE WHEN semana = 7 THEN cantidad ELSE 0 END) AS semana_07,
        SUM(CASE WHEN semana = 8 THEN cantidad ELSE 0 END) AS semana_08,
        SUM(CASE WHEN semana = 9 THEN cantidad ELSE 0 END) AS semana_09,
        SUM(CASE WHEN semana = 10 THEN cantidad ELSE 0 END) AS semana_10,
        SUM(CASE WHEN semana = 11 THEN cantidad ELSE 0 END) AS semana_11,
        SUM(CASE WHEN semana = 12 THEN cantidad ELSE 0 END) AS semana_12,
        SUM(CASE WHEN semana = 13 THEN cantidad ELSE 0 END) AS semana_13,
        SUM(CASE WHEN semana = 14 THEN cantidad ELSE 0 END) AS semana_14,
        SUM(CASE WHEN semana = 15 THEN cantidad ELSE 0 END) AS semana_15,
        SUM(CASE WHEN semana = 16 THEN cantidad ELSE 0 END) AS semana_16,
        SUM(CASE WHEN semana = 17 THEN cantidad ELSE 0 END) AS semana_17,
        SUM(CASE WHEN semana = 18 THEN cantidad ELSE 0 END) AS semana_18,
        SUM(CASE WHEN semana = 19 THEN cantidad ELSE 0 END) AS semana_19,
        SUM(CASE WHEN semana = 20 THEN cantidad ELSE 0 END) AS semana_20,
        SUM(CASE WHEN semana = 21 THEN cantidad ELSE 0 END) AS semana_21,
        SUM(CASE WHEN semana = 22 THEN cantidad ELSE 0 END) AS semana_22,
        SUM(CASE WHEN semana = 23 THEN cantidad ELSE 0 END) AS semana_23,
        SUM(CASE WHEN semana = 24 THEN cantidad ELSE 0 END) AS semana_24,
        SUM(CASE WHEN semana = 25 THEN cantidad ELSE 0 END) AS semana_25,
        SUM(CASE WHEN semana = 26 THEN cantidad ELSE 0 END) AS semana_26,
        SUM(CASE WHEN semana = 27 THEN cantidad ELSE 0 END) AS semana_27,
        SUM(CASE WHEN semana = 28 THEN cantidad ELSE 0 END) AS semana_28,
        SUM(CASE WHEN semana = 29 THEN cantidad ELSE 0 END) AS semana_29,
        SUM(CASE WHEN semana = 30 THEN cantidad ELSE 0 END) AS semana_30,
        SUM(CASE WHEN semana = 31 THEN cantidad ELSE 0 END) AS semana_31,
        SUM(CASE WHEN semana = 32 THEN cantidad ELSE 0 END) AS semana_32,
        SUM(CASE WHEN semana = 33 THEN cantidad ELSE 0 END) AS semana_33,
        SUM(CASE WHEN semana = 34 THEN cantidad ELSE 0 END) AS semana_34,
        SUM(CASE WHEN semana = 35 THEN cantidad ELSE 0 END) AS semana_35,
        SUM(CASE WHEN semana = 36 THEN cantidad ELSE 0 END) AS semana_36,
        SUM(CASE WHEN semana = 37 THEN cantidad ELSE 0 END) AS semana_37,
        SUM(CASE WHEN semana = 38 THEN cantidad ELSE 0 END) AS semana_38,
        SUM(CASE WHEN semana = 39 THEN cantidad ELSE 0 END) AS semana_39,
        SUM(CASE WHEN semana = 40 THEN cantidad ELSE 0 END) AS semana_40,
        SUM(CASE WHEN semana = 41 THEN cantidad ELSE 0 END) AS semana_41,
        SUM(CASE WHEN semana = 42 THEN cantidad ELSE 0 END) AS semana_42,
        SUM(CASE WHEN semana = 43 THEN cantidad ELSE 0 END) AS semana_43,
        SUM(CASE WHEN semana = 44 THEN cantidad ELSE 0 END) AS semana_44,
        SUM(CASE WHEN semana = 45 THEN cantidad ELSE 0 END) AS semana_45,
        SUM(CASE WHEN semana = 46 THEN cantidad ELSE 0 END) AS semana_46,
        SUM(CASE WHEN semana = 47 THEN cantidad ELSE 0 END) AS semana_47,
        SUM(CASE WHEN semana = 48 THEN cantidad ELSE 0 END) AS semana_48,
        SUM(CASE WHEN semana = 49 THEN cantidad ELSE 0 END) AS semana_49,
        SUM(CASE WHEN semana = 50 THEN cantidad ELSE 0 END) AS semana_50,
        SUM(CASE WHEN semana = 51 THEN cantidad ELSE 0 END) AS semana_51,
        SUM(CASE WHEN semana = 52 THEN cantidad ELSE 0 END) AS semana_52,
        SUM(CASE WHEN semana = 53 THEN cantidad ELSE 0 END) AS semana_53

    FROM ventas_base
    GROUP BY producto
),

pedidos AS (
    SELECT
        cve_art,
        COUNT(*) AS total_pedidos
    FROM (
        SELECT
            cve_art,
            refer,
            (
                MAX(CASE WHEN cve_cpto = 51 THEN 1 ELSE 0 END)
                - MAX(CASE WHEN cve_cpto IN (2, 4) THEN 1 ELSE 0 END)
                + MAX(CASE WHEN cve_cpto = 56 THEN 1 ELSE 0 END)
            ) AS neto_periodo
        FROM minve01
        WHERE
            EXTRACT(YEAR FROM fechaelab) = EXTRACT(YEAR FROM CURRENT_DATE)
            AND almacen IN (1,2,5,6,7,8,9,10,11,12,13,14,15,16,18)
            AND cve_cpto IN (2,4,51,56)
        GROUP BY cve_art, refer
    )
    WHERE neto_periodo > 0
    GROUP BY cve_art
),

existencias AS (
    SELECT
        cve_art,
        SUM(exist) AS total_exist,
        LIST(
            CASE WHEN exist > 0 THEN cve_alm END,
            ', '
        ) AS ubicacion
    FROM mult01
    WHERE cve_alm IN (1,2,5,6,7,8,9,10,11,12,13,14,15,16,18)
    GROUP BY cve_art
)

SELECT
    i.cve_art AS "Clave",
    i.descr AS "Descripción",
    c.desc_lin AS "Línea",
    ic.camplib3 AS "Marca",
    i.costo_prom AS "Costo Promedio",

    COALESCE(v.semana_01, 0) AS semana_01,
	COALESCE(v.semana_02, 0) AS semana_02,
	COALESCE(v.semana_03, 0) AS semana_03,
	COALESCE(v.semana_04, 0) AS semana_04,
	COALESCE(v.semana_05, 0) AS semana_05,
	COALESCE(v.semana_06, 0) AS semana_06,
	COALESCE(v.semana_07, 0) AS semana_07,
	COALESCE(v.semana_08, 0) AS semana_08,
	COALESCE(v.semana_09, 0) AS semana_09,
	COALESCE(v.semana_10, 0) AS semana_10,
	COALESCE(v.semana_11, 0) AS semana_11,
	COALESCE(v.semana_12, 0) AS semana_12,
	COALESCE(v.semana_13, 0) AS semana_13,
	COALESCE(v.semana_14, 0) AS semana_14,
	COALESCE(v.semana_15, 0) AS semana_15,
	COALESCE(v.semana_16, 0) AS semana_16,
	COALESCE(v.semana_17, 0) AS semana_17,
	COALESCE(v.semana_18, 0) AS semana_18,
	COALESCE(v.semana_19, 0) AS semana_19,
	COALESCE(v.semana_20, 0) AS semana_20,
	COALESCE(v.semana_21, 0) AS semana_21,
	COALESCE(v.semana_22, 0) AS semana_22,
	COALESCE(v.semana_23, 0) AS semana_23,
	COALESCE(v.semana_24, 0) AS semana_24,
	COALESCE(v.semana_25, 0) AS semana_25,
	COALESCE(v.semana_26, 0) AS semana_26,
	COALESCE(v.semana_27, 0) AS semana_27,
	COALESCE(v.semana_28, 0) AS semana_28,
	COALESCE(v.semana_29, 0) AS semana_29,
	COALESCE(v.semana_30, 0) AS semana_30,
	COALESCE(v.semana_31, 0) AS semana_31,
	COALESCE(v.semana_32, 0) AS semana_32,
	COALESCE(v.semana_33, 0) AS semana_33,
	COALESCE(v.semana_34, 0) AS semana_34,
	COALESCE(v.semana_35, 0) AS semana_35,
	COALESCE(v.semana_36, 0) AS semana_36,
	COALESCE(v.semana_37, 0) AS semana_37,
	COALESCE(v.semana_38, 0) AS semana_38,
	COALESCE(v.semana_39, 0) AS semana_39,
	COALESCE(v.semana_40, 0) AS semana_40,
	COALESCE(v.semana_41, 0) AS semana_41,
	COALESCE(v.semana_42, 0) AS semana_42,
	COALESCE(v.semana_43, 0) AS semana_43,
	COALESCE(v.semana_44, 0) AS semana_44,
	COALESCE(v.semana_45, 0) AS semana_45,
	COALESCE(v.semana_46, 0) AS semana_46,
	COALESCE(v.semana_47, 0) AS semana_47,
	COALESCE(v.semana_48, 0) AS semana_48,
	COALESCE(v.semana_49, 0) AS semana_49,
	COALESCE(v.semana_50, 0) AS semana_50,
	COALESCE(v.semana_51, 0) AS semana_51,
	COALESCE(v.semana_52, 0) AS semana_52,
	COALESCE(v.semana_53, 0) AS semana_53,

    COALESCE(e.total_exist, 0) AS "Inventario Disponible",
    COALESCE(p.total_pedidos, 0) AS "Número de Pedidos",
    COALESCE(e.ubicacion, '') AS "Ubicación"

FROM inve01 i
LEFT JOIN clin01 c ON i.lin_prod = c.cve_lin
LEFT JOIN inve_clib01 ic ON i.cve_art = ic.cve_prod
LEFT JOIN ventas v ON i.cve_art = v.producto
LEFT JOIN pedidos p ON i.cve_art = p.cve_art
LEFT JOIN existencias e ON i.cve_art = e.cve_art

WHERE i.status = 'A'
;