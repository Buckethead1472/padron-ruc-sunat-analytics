--2. ¿Cuáles son los distritos con mayor densidad empresarial activa por cada 1,000 habitantes?

WITH empresas_activos AS (
SELECT 
	u.departamento,
	u.distrito,
	u.poblacion,
	COUNT(*) FILTER (WHERE pr.estado_contribuyente = 'ACTIVO') AS total_activos
FROM padron_ruc pr
INNER JOIN ubigeo u ON pr.ubigeo=u.ubigeo
WHERE poblacion >= 10000
GROUP BY u.distrito,u.poblacion,u.departamento
),

poblacion_densidad AS (
SELECT
	departamento,
	distrito,
	poblacion,
	ROUND(total_activos/poblacion::numeric * 1000, 2) AS densidad
FROM empresas_activos
),

base AS (
SELECT 
	departamento,
	distrito,
	poblacion,
	densidad,
	ROW_NUMBER() OVER(
	PARTITION BY departamento
	ORDER BY densidad DESC) as ranking
FROM poblacion_densidad
)
SELECT
	departamento,
	distrito,
	poblacion,
	densidad,
	ranking
FROM base
WHERE ranking <=3
ORDER BY departamento 