/*
    Este query devuelve las devoluciones de los últimos 7 días
*/

SELECT
    FECHAELAB AS "Fecha",
    ALMACEN AS "Almacén",
    CASE 
        WHEN TIPO_DOC = 'F' THEN 'Factura'
        WHEN TIPO_DOC = 'R' THEN 'Remisión'
        WHEN TIPO_DOC = 'V' THEN 'Nota de Venta'
        WHEN TIPO_DOC IN ('D', 'd') THEN 'Devolución'
        ELSE 'Desconocido'
    END AS "Tipo",
    REFER AS "Documento",
    CONM01.DESCR AS "Movimiento",
    CLAVE_CLPV AS "Cliente-Proveedor",
    CVE_ART AS "Producto",
    CANT AS "Cantidad",
    COSTO AS "Costo",
    PRECIO AS "Precio",
    NOMBRE AS "Vendedor"
FROM
    MINVE01 
LEFT JOIN
    CONM01 
        ON MINVE01.CVE_CPTO = CONM01.CVE_CPTO 
LEFT JOIN
    VEND01 
        ON MINVE01.VEND = VEND01.CVE_VEND 
WHERE
    CAST(fechaelab AS DATE) BETWEEN CURRENT_DATE -7 AND CURRENT_DATE -1
    AND MINVE01.CVE_CPTO IN ('2', '4', '5');
