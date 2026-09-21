/*
Pregunta 4: gerente comercial B2B, armando territorios de venta.

	Pregunta: ¿Cuáles son los 5 departamentos con más empresas activas,
y qué porcentaje del total nacional de empresas activas representa cada uno?
*/

WITH activas_departamento AS (
    SELECT 
        u.departamento,
        COUNT(*) AS total_activas
    FROM padron_ruc pr
    INNER JOIN ubigeo u ON pr.ubigeo = u.ubigeo
    WHERE pr.estado_contribuyente = 'ACTIVO'
    GROUP BY u.departamento
)
SELECT 
    departamento,
    total_activas,
    SUM(total_activas) OVER () AS total_nacional,
    ROUND(total_activas::NUMERIC / SUM(total_activas) OVER (), 4) AS porcentaje_nacional
FROM activas_departamento
ORDER BY total_activas DESC
LIMIT 5