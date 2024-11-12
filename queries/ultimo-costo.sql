/*
 Regresa el costo de los productos, tomando en cuenta el último costo, pero
 solo si el documento no está cancelado y el almacén es 1, 12 o 16.
 */
SELECT minve01.cve_art,
    costo
FROM minve01
    INNER JOIN(
        SELECT cve_art,
            MAX(minve01.num_mov) mov
        FROM minve01
            LEFT JOIN compc01 ON minve01.refer = compc01.cve_doc
            LEFT JOIN compr01 ON minve01.refer = compr01.cve_doc
        WHERE minve01.tipo_doc IN ('c', 'r')
            AND minve01.almacen IN (1, 12, 16)
            AND (
                compc01.status <> 'C'
                OR compr01.status <> 'C'
            )
        GROUP BY cve_art
    ) ultimo on ultimo.cve_art = minve01.cve_art
    AND ultimo.mov = minve01.num_mov
ORDER BY minve01.cve_art