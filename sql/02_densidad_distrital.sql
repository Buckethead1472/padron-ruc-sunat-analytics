-- Pregunta de negocio: ¿Qué distritos tienen mayor densidad de empresas activas por cada 1,000 habitantes?
-- Insight completo: ver insights/02_densidad_distrital.md
-- Stakeholder: Gerente de expansión (retail)

WITH empresas_activos AS (
    SELECT
        u.departamento,
        u.distrito,
        u.poblacion,
        COUNT(*) FILTER (WHERE pr.estado_contribuyente = 'ACTIVO') AS total_activos
    FROM padron_ruc pr
    INNER JOIN ubigeo u ON pr.ubigeo = u.ubigeo
    WHERE u.poblacion >= 10000
    GROUP BY u.distrito, u.poblacion, u.departamento
),

poblacion_densidad AS (
    SELECT
        departamento,
        distrito,
        poblacion,
        ROUND(total_activos / poblacion::NUMERIC * 1000, 2) AS densidad
    FROM empresas_activos
),

base AS (
    SELECT
        departamento,
        distrito,
        poblacion,
        densidad,
        ROW_NUMBER() OVER (
            PARTITION BY departamento
            ORDER BY densidad DESC
        ) AS ranking
    FROM poblacion_densidad
)

SELECT
    departamento,
    distrito,
    poblacion,
    densidad,
    ranking
FROM base
WHERE ranking <= 3
ORDER BY departamento, ranking;
