/*
 Query para obtener los productos con existencias en el almacen 1:
 - Clave
 - UPC
 - Descripción
 - Linea
 - Marca
 - Categoría
 - Existencia
 - Último Costo
 - Costo Promedio
 */
SELECT mult01.cve_art AS "clave",
	cves_alter01.cve_alter AS "upc",
	inve01.descr AS "descripcion",
	inve01.lin_prod AS "linea",
	inve_clib01.camplib3 AS "marca",
	inve_clib01.camplib2 AS "categoria",
	mult01.exist AS "existencia",
	COALESCE(
		(
			SELECT costo
			FROM minve01
				INNER JOIN(
					SELECT cve_art,
						MAX(minve01.num_mov) mov
					FROM minve01
						LEFT JOIN compc01 ON minve01.refer = compc01.cve_doc
						LEFT JOIN compr01 ON minve01.refer = compr01.cve_doc
					WHERE minve01.tipo_doc IN ('c', 'r')
						AND (
							compc01.status <> 'C'
							OR compr01.status <> 'C'
						)
						AND almacen = 1
					GROUP BY cve_art
				) ultimo ON ultimo.cve_art = minve01.cve_art
				AND ultimo.mov = minve01.num_mov
			WHERE minve01.cve_art = inve01.cve_art
			ORDER BY minve01.cve_art
		),
		(
			SELECT costo
			FROM minve01
				INNER JOIN(
					SELECT cve_art,
						MAX(minve01.num_mov) mov
					FROM minve01
						LEFT JOIN compc01 ON minve01.refer = compc01.cve_doc
						LEFT JOIN compr01 ON minve01.refer = compr01.cve_doc
					WHERE minve01.tipo_doc IN ('c', 'r')
						AND (
							compc01.status <> 'C'
							OR compr01.status <> 'C'
						)
						AND almacen = 16
					GROUP BY cve_art
				) ultimo ON ultimo.cve_art = minve01.cve_art
				AND ultimo.mov = minve01.num_mov
			WHERE minve01.cve_art = inve01.cve_art
			ORDER BY minve01.cve_art
		),
		(
			SELECT costo
			FROM minve01
				INNER JOIN(
					SELECT cve_art,
						MAX(minve01.num_mov) mov
					FROM minve01
						LEFT JOIN compc01 ON minve01.refer = compc01.cve_doc
						LEFT JOIN compr01 ON minve01.refer = compr01.cve_doc
					WHERE minve01.tipo_doc IN ('c', 'r')
						AND (
							compc01.status <> 'C'
							OR compr01.status <> 'C'
						)
						AND almacen = 14
					GROUP BY cve_art
				) ultimo ON ultimo.cve_art = minve01.cve_art
				AND ultimo.mov = minve01.num_mov
			WHERE minve01.cve_art = inve01.cve_art
			ORDER BY minve01.cve_art
		)
	) AS "ultimo_costo",
	COALESCE(
		(
			SELECT SUM(cant * costo) / SUM(cant)
			FROM minve01
				LEFT JOIN compc01 ON minve01.refer = compc01.cve_doc
				LEFT JOIN compr01 ON minve01.refer = compr01.cve_doc
			WHERE minve01.cve_art = inve01.cve_art
				AND minve01.almacen = 1
				AND (
					compc01.status <> 'C'
					OR compr01.status <> 'C'
				)
			GROUP BY cve_art
			ORDER BY cve_art
		),
		(
			SELECT SUM(cant * costo) / SUM(cant)
			FROM minve01
				LEFT JOIN compc01 ON minve01.refer = compc01.cve_doc
				LEFT JOIN compr01 ON minve01.refer = compr01.cve_doc
			WHERE minve01.cve_art = inve01.cve_art
				AND minve01.almacen = 16
				AND (
					compc01.status <> 'C'
					OR compr01.status <> 'C'
				)
			GROUP BY cve_art
			ORDER BY cve_art
		),
		(
			SELECT SUM(cant * costo) / SUM(cant)
			FROM minve01
				LEFT JOIN compc01 ON minve01.refer = compc01.cve_doc
				LEFT JOIN compr01 ON minve01.refer = compr01.cve_doc
			WHERE minve01.cve_art = inve01.cve_art
				AND minve01.almacen = 14
				AND (
					compc01.status <> 'C'
					OR compr01.status <> 'C'
				)
			GROUP BY cve_art
			ORDER BY cve_art
		)
	) AS "costo_promedio"
FROM mult01
	LEFT JOIN cves_alter01 ON cves_alter01.cve_art = mult01.cve_art
	LEFT JOIN inve01 ON inve01.cve_art = mult01.cve_art
	LEFT JOIN inve_clib01 ON inve_clib01.cve_prod = mult01.cve_art
WHERE mult01.CVE_ALM = 1
	AND mult01.status = 'A'
	AND mult01.EXIST > 0
ORDER BY mult01.CVE_ART