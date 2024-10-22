/*
    Este query obtiene los pedidos devueltos de un cliente agrupados por
    mes y año.
*/

SELECT
    EXTRACT(YEAR FROM FECHAELAB) AS "Año",
    CASE
        WHEN EXTRACT(MONTH FROM FECHAELAB) = 1 THEN 'Enero'
        WHEN EXTRACT(MONTH FROM FECHAELAB) = 2 THEN 'Febrero'
        WHEN EXTRACT(MONTH FROM FECHAELAB) = 3 THEN 'Marzo'
        WHEN EXTRACT(MONTH FROM FECHAELAB) = 4 THEN 'Abril'
        WHEN EXTRACT(MONTH FROM FECHAELAB) = 5 THEN 'Mayo'
        WHEN EXTRACT(MONTH FROM FECHAELAB) = 6 THEN 'Junio'
        WHEN EXTRACT(MONTH FROM FECHAELAB) = 7 THEN 'Julio'
        WHEN EXTRACT(MONTH FROM FECHAELAB) = 8 THEN 'Agosto'
        WHEN EXTRACT(MONTH FROM FECHAELAB) = 9 THEN 'Septiembre'
        WHEN EXTRACT(MONTH FROM FECHAELAB) = 10 THEN 'Octubre'
        WHEN EXTRACT(MONTH FROM FECHAELAB) = 11 THEN 'Noviembre'
        WHEN EXTRACT(MONTH FROM FECHAELAB) = 12 THEN 'Diciembre'
    END AS "Mes",
    COUNT(REFER) AS "Pedidos Devueltos" -- Modificar el alias de acuerdo a la clave de concepto elegida
FROM
    MINVE01
WHERE
    CVE_CPTO = 51 -- 2 = Devolución de venta, 4 = Cancelación de venta, 51 = Ventas, 56 = Cancelación Devolución de venta
    AND ALMACEN = 1 -- 1 = Almacén por defecto, opcionalmente puedes cambiarlo
    AND CLAVE_CLPV = 'CL0000000001' -- Clave de cliente
GROUP BY
    EXTRACT(YEAR FROM FECHAELAB),
    EXTRACT(MONTH FROM FECHAELAB);