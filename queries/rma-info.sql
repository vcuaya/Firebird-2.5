SELECT
    compq01.fechaelab AS "Fecha",
    compq01.cve_doc AS "RMA",
  
    CASE
        WHEN compq01.status IN ('O', 'E') THEN 'Vigente'
        WHEN compq01.status = 'C' THEN 'Cancelado'
        ELSE 'Desconocido'
    END AS "Estatus RMA",
    
    compq01.su_refer AS "Cliente",
    compq01.obs_cond AS "Documento de Venta",
    
		COALESCE(factf01.doc_sig, factv01.doc_sig, factr01.doc_sig, 'Sin documento') AS "Doc. Siguiente",
   
    par_compq01.num_par AS "No. Partida",
    par_compq01.cant AS "Cantidad",
    par_compq01.cve_art AS "Producto",

    CASE
        WHEN COALESCE(factf01.status, factv01.status, factr01.status) IN ('O','E') THEN 'Vigente'
        WHEN COALESCE(factf01.status, factv01.status, factr01.status) = 'C' THEN 'Cancelado'
        ELSE 'No Encontrado'
    END AS "Estatus Venta",
    
    obs_part.str_obs AS "Condiciones Físicas",
    obs_doc.str_obs AS "Motivo de Devolución"

FROM compq01

LEFT JOIN par_compq01 
    ON par_compq01.cve_doc = compq01.cve_doc

LEFT JOIN factf01 
    ON factf01.cve_doc = compq01.obs_cond

LEFT JOIN factv01 
    ON factv01.cve_doc = compq01.obs_cond

LEFT JOIN factr01 
    ON factr01.cve_doc = compq01.obs_cond

LEFT JOIN obs_docc01 obs_part
    ON obs_part.cve_obs = par_compq01.cve_obs

LEFT JOIN obs_docc01 obs_doc
    ON obs_doc.cve_obs = compq01.cve_obs

--WHERE par_compq01.cve_art LIKE '210-BNHN';