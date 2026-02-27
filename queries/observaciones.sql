-- Observaciones de partida
SELECT fechaelab,
    tipo_doc,
    refer,
    almacen,
    clave_clpv,
    cve_art,
    cant,
    costo,
    precio,
    (
        SELECT str_obs
        FROM ominve01
        WHERE ominve01.cve_obs = minve01.cve_obs
    )
FROM minve01
WHERE tipo_doc IN ('F', 'R', 'D') -- Observaciones de documento
SELECT cve_doc,
    (
        SELECT str_obs
        FROM obs_docf01
        WHERE obs_docf01.str_obs = factv01.cve_obs
    )
FROM factv01 -- Datos de envío
SELECT cve_doc,
    infenvio01.*
FROM factp01
    LEFT JOIN infenvio01 ON factp01.dat_envio = infenvio01.cve_info