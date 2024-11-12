/*
 Query para unir las tablas FACTF01, FACTR01 y FACTV01 (facturas,
 remisiones y notas de venta)
 */
SELECT tip_doc,
    cve_doc,
    cve_clpv,
    status,
    fechaelab,
    fecha_ent,
    fecha_cancela,
    num_moned,
    tipcamb,
    can_tot,
    importe,
    doc_ant,
    doc_sig
FROM FACTF01
UNION ALL
SELECT tip_doc,
    cve_doc,
    cve_clpv,
    status,
    fechaelab,
    fecha_ent,
    fecha_cancela,
    num_moned,
    tipcamb,
    can_tot,
    importe,
    doc_ant,
    doc_sig
FROM FACTR01
UNION ALL
SELECT tip_doc,
    cve_doc,
    cve_clpv,
    status,
    fechaelab,
    fecha_ent,
    fecha_cancela,
    num_moned,
    tipcamb,
    can_tot,
    importe,
    doc_ant,
    doc_sig
FROM FACTV01