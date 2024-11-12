/*
 Query para unificar las tablas compr01 y compc01 (compras y recepciones)
 */
SELECT tip_doc,
	cve_doc,
	cve_clpv,
	status,
	su_refer,
	fechaelab,
	fecha_cancela,
	num_moned,
	tipcamb,
	can_tot,
	importe,
	doc_ant,
	doc_sig
FROM compc01
UNION ALL
SELECT tip_doc,
	cve_doc,
	cve_clpv,
	status,
	su_refer,
	fechaelab,
	fecha_cancela,
	num_moned,
	tipcamb,
	can_tot,
	importe,
	doc_ant,
	doc_sig
FROM compr01