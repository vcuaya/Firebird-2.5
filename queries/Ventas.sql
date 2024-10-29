/*
	Query para obtener las ventas, cancelaciones y devoluciones de los
	clientes en los últimos siete días, filtrando por línea y marca.
*/

-- Ventas
SELECT (
		SELECT nombre
		FROM clie01
		WHERE clie01.clave = minve01.clave_clpv
	) AS "Nombre de Cliente",
	(
		SELECT rfc
		FROM clie01
		WHERE clie01.clave = minve01.clave_clpv
	) As "RFC",
	(
		COALESCE(
			(
				SELECT calle
				FROM clie01
				WHERE clie01.clave = minve01.clave_clpv
			),
			''
		) || COALESCE(
			' ' || (
				SELECT numext
				FROM clie01
				WHERE clie01.clave = minve01.clave_clpv
			),
			''
		) || COALESCE(
			' Interior ' || (
				SELECT numint
				FROM clie01
				WHERE clie01.clave = minve01.clave_clpv
			),
			''
		) || COALESCE(
			', ' || (
				SELECT colonia
				FROM clie01
				WHERE clie01.clave = minve01.clave_clpv
			),
			''
		)
	) AS "Direccion",
	(
		SELECT municipio
		FROM clie01
		WHERE clie01.clave = minve01.clave_clpv
	) AS "Municipio",
	(
		SELECT estado
		FROM clie01
		WHERE clie01.clave = minve01.clave_clpv
	) AS "Estado",
	(
		SELECT codigo
		FROM clie01
		WHERE clie01.clave = minve01.clave_clpv
	) AS "CP",
	clave_clpv AS "Clave de Cliente",
	cant * signo * -1 AS "Cantidad",
	cve_art AS "Producto",
	EXTRACT(
		YEAR
		FROM fechaelab
	) || LPAD(
		EXTRACT(
			MONTH
			FROM fechaelab
		),
		2,
		'0'
	) || LPAD(
		EXTRACT(
			DAY
			FROM fechaelab
		),
		2,
		'0'
	) AS "Fecha",
	refer AS "Documento",
	CASE
		WHEN refer LIKE 'CLV%'
		OR refer LIKE 'MC%'
		OR refer LIKE 'EC%' THEN 'N'
		ELSE 'Y'
	END AS "Drop Ship",
	CASE
		WHEN refer LIKE 'CLV%'
		OR refer LIKE 'MC%'
		OR refer LIKE 'EC%' THEN 'Y'
		ELSE 'N'
	END AS "Online"
FROM minve01
WHERE CAST(fechaelab AS DATE) BETWEEN CURRENT_DATE -7 AND CURRENT_DATE -1
	AND tipo_doc IN ('F', 'R', 'V', 'D')
	AND almacen IN ('1', '2', '5', '6', '7', '13', '14', '15', '16')
	AND(
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
		OR(
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
	);