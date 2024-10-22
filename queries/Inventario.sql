/*
 Este query devuelve las existencias y compras realizadas en los
 últimos siete días para los productos de las líneas y marcas
 especificadas.
 
 Tanto las líneas como las marcas pueden ser modificadas para adaptarse
 a los registros que contenga tu base de datos.
 */
-- Compras
WITH compras AS(
    SELECT SUM(cant * signo) as cantidadComprada,
        cve_art as producto
    FROM minve01
    WHERE CAST(fechaelab AS DATE) BETWEEN CURRENT_DATE -7 AND CURRENT_DATE -1
        AND tipo_doc IN ('c', 'r', 'd')
        AND almacen IN ('1', '2', '5', '6', '7', '13', '14', '15', '16')
        AND (
            (
                (
                    SELECT lin_prod
                    FROM inve01
                    WHERE inve01.cve_art = minve01.cve_art
                ) IN (
                    'ACCES',
                    'AUVI',
                    'COMPU',
                    'CONSU',
                    'IMPRE',
                    'SCANN'
                )
                AND (
                    SELECT camplib3
                    FROM inve_clib01
                    WHERE inve_clib01.cve_prod = minve01.cve_art
                ) IN ('HP')
            )
            OR (
                (
                    SELECT lin_prod
                    FROM inve01
                    WHERE inve01.cve_art = minve01.cve_art
                ) IN ('ACCES', 'AUVI')
                AND (
                    SELECT camplib3
                    FROM inve_clib01
                    WHERE inve_clib01.cve_prod = minve01.cve_art
                ) IN ('POLY')
            )
        )
    GROUP BY cve_art
) -- Inventario
SELECT cve_art AS "Producto",
    COALESCE(cantidadComprada, 0) AS "Comprado",
    SUM(
        COALESCE(
            (
                SELECT exist
                FROM mult01
                WHERE mult01.cve_art = inve01.cve_art
                    AND cve_alm = 1
            ),
            0
        ) + COALESCE(
            (
                SELECT exist
                FROM mult01
                WHERE mult01.cve_art = inve01.cve_art
                    AND cve_alm = 2
            ),
            0
        ) + COALESCE(
            (
                SELECT exist
                FROM mult01
                WHERE mult01.cve_art = inve01.cve_art
                    AND cve_alm = 5
            ),
            0
        ) + COALESCE(
            (
                SELECT exist
                FROM mult01
                WHERE mult01.cve_art = inve01.cve_art
                    AND cve_alm = 6
            ),
            0
        ) + COALESCE(
            (
                SELECT exist
                FROM mult01
                WHERE mult01.cve_art = inve01.cve_art
                    AND cve_alm = 7
            ),
            0
        ) + COALESCE(
            (
                SELECT exist
                FROM mult01
                WHERE mult01.cve_art = inve01.cve_art
                    AND cve_alm = 13
            ),
            0
        ) + COALESCE(
            (
                SELECT exist
                FROM mult01
                WHERE mult01.cve_art = inve01.cve_art
                    AND cve_alm = 14
            ),
            0
        ) + COALESCE(
            (
                SELECT exist
                FROM mult01
                WHERE mult01.cve_art = inve01.cve_art
                    AND cve_alm = 15
            ),
            0
        ) + COALESCE(
            (
                SELECT exist
                FROM mult01
                WHERE mult01.cve_art = inve01.cve_art
                    AND cve_alm = 16
            ),
            0
        )
    ) AS "Existencia",
    lin_prod AS "Linea",
    (
        SELECT camplib2
        FROM inve_clib01
        WHERE inve_clib01.cve_prod = inve01.cve_art
    ) AS "SubLinea",
    (
        SELECT camplib3
        FROM inve_clib01
        WHERE inve_clib01.cve_prod = inve01.cve_art
    ) AS "Marca",
    descr AS "Descripcion"
FROM inve01
    LEFT JOIN compras ON inve01.cve_art = compras.producto
WHERE status = 'A'
    AND (
        (
            lin_prod IN (
                'ACCES',
                'AUVI',
                'COMPU',
                'CONSU',
                'IMPRE',
                'SCANN'
            )
            AND (
                SELECT camplib3
                FROM inve_clib01
                WHERE inve_clib01.cve_prod = inve01.cve_art
            ) IN ('HP')
        )
        OR (
            lin_prod IN ('ACCES', 'AUVI')
            AND (
                SELECT camplib3
                FROM inve_clib01
                WHERE inve_clib01.cve_prod = inve01.cve_art
            ) IN ('POLY')
        )
    )
GROUP BY cve_art,
    cantidadComprada,
    lin_prod,
    (
        SELECT camplib2
        FROM inve_clib01
        WHERE inve_clib01.cve_prod = inve01.cve_art
    ),
    (
        SELECT camplib3
        FROM inve_clib01
        WHERE inve_clib01.cve_prod = inve01.cve_art
    ),
    descr
ORDER BY cve_art;