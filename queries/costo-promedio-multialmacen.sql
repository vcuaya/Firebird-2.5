/*
 Regresa el cálculo del costo promedio de los productos considerando la
 cantidad y el costo de los movimientos, cuyo documento no está cancelado y
 el almacén es: 1, 5, 12, 14 o 16.
 */
SELECT cve_art,
    SUM(cant * costo) / SUM(cant)
FROM minve01
    LEFT JOIN compc01 ON minve01.refer = compc01.cve_doc
    LEFT JOIN compr01 ON minve01.refer = compr01.cve_doc
WHERE minve01.tipo_doc IN ('c', 'r')
    AND minve01.almacen IN (1, 5, 12, 14, 16)
    AND (
        compc01.status <> 'C'
        OR compr01.status <> 'C'
    )
GROUP BY cve_art
ORDER BY cve_art