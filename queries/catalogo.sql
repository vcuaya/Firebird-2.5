SELECT -- Descripciones
    i.cve_art AS "Producto",
    i.descr AS "Descripción",
    c.desc_lin AS "Línea",
    ic.camplib2 AS "Sublínea",
    ic.camplib3 AS "Marca",
    -- Existencias
    SUM(
        CASE
            WHEN m.cve_alm = 1 THEN m.exist
            ELSE 0
        END
    ) AS "Alm 1",
    SUM(
        CASE
            WHEN m.cve_alm = 13 THEN m.exist
            ELSE 0
        END
    ) AS "Alm 13",
    SUM(
        CASE
            WHEN m.cve_alm = 16 THEN m.exist
            ELSE 0
        END
    ) AS "Alm 16",
    -- Costo Promedio
    cr.avg_costo AS "Costo Promedio",
    -- Métricas
    cr.stddev AS "Desviacion",
    cr.variacion AS "Variacion",
    -- Confiabilidad
    CASE
        WHEN cr.variacion IS NULL THEN 'SIN DATOS'
        WHEN cr.variacion < 0.1 THEN 'ALTA'
        WHEN cr.variacion < 0.3 THEN 'MEDIA'
        ELSE 'BAJA'
    END AS "Confiabilidad",
    -- Costo final
    COALESCE(cr.costo_robusto, i.ult_costo) AS "Costo",
    -- Precio
    CASE
        WHEN UPPER(c.desc_lin) = 'CONSUMIBLES'
        AND UPPER(ic.camplib2) = 'TONER CAJA BLANCA' THEN COALESCE(cr.costo_robusto, i.ult_costo) * 1.08
        ELSE COALESCE(cr.costo_robusto, i.ult_costo) * 1.04
    END AS "Precio"
FROM inve01 i
    LEFT JOIN clin01 c ON i.lin_prod = c.cve_lin
    LEFT JOIN inve_clib01 ic ON i.cve_art = ic.cve_prod
    LEFT JOIN mult01 m ON i.cve_art = m.cve_art -- Costo Robusto
    LEFT JOIN (
        SELECT s.cve_art,
            SUM(
                CASE
                    WHEN s.stddev = 0 THEN d.costo * d.cant
                    WHEN d.costo BETWEEN (s.avg_costo - 2 * s.stddev) AND (s.avg_costo + 2 * s.stddev) THEN d.costo * d.cant
                    ELSE 0
                END
            ) / NULLIF(
                SUM(
                    CASE
                        WHEN s.stddev = 0 THEN d.cant
                        WHEN d.costo BETWEEN (s.avg_costo - 2 * s.stddev) AND (s.avg_costo + 2 * s.stddev) THEN d.cant
                        ELSE 0
                    END
                ),
                0
            ) AS costo_robusto,
            s.avg_costo,
            s.stddev,
            CASE
                WHEN s.avg_costo = 0
                OR s.stddev IS NULL THEN NULL
                ELSE s.stddev / s.avg_costo
            END AS variacion
        FROM (
                SELECT cve_art,
                    AVG(costo) AS avg_costo,
                    CASE
                        WHEN (AVG(costo * costo) - POWER(AVG(costo), 2)) > 0 THEN SQRT(AVG(costo * costo) - POWER(AVG(costo), 2))
                        ELSE 0
                    END AS stddev
                FROM minve01
                WHERE tipo_doc = 'c'
                    AND costo > 0
                    AND cant > 0
                GROUP BY cve_art
            ) s
            LEFT JOIN minve01 d ON d.cve_art = s.cve_art
            AND d.tipo_doc = 'c'
            AND d.costo > 0
            AND d.cant > 0
        GROUP BY s.cve_art,
            s.avg_costo,
            s.stddev
    ) cr ON cr.cve_art = i.cve_art
WHERE i.status = 'A' --AND i.cve_art = '56F4X00'
    --OR i.cve_art = 'CE403A'
    --OR i.cve_art = 'CN053AL'
GROUP BY i.cve_art,
    i.descr,
    c.desc_lin,
    ic.camplib2,
    ic.camplib3,
    cr.costo_robusto,
    cr.avg_costo,
    cr.stddev,
    cr.variacion,
    i.ult_costo;