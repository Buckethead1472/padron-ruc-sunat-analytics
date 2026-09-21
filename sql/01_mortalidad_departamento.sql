-- Pregunta de negocio: ¿Qué departamentos tienen mayor riesgo de mortalidad empresarial?
-- Insight completo: ver insights/01_mortalidad_departamento.md
-- Stakeholder: Analista de riesgo crediticio

WITH datos_base AS (
    SELECT
        u.departamento,
        COUNT(*) FILTER (WHERE pr.estado_contribuyente LIKE 'BAJA%') AS baja,
        COUNT(*) FILTER (WHERE pr.estado_contribuyente NOT LIKE 'BAJA%') AS activo,
        COUNT(*) AS total,
        ROUND(COUNT(*) FILTER (WHERE pr.estado_contribuyente LIKE 'BAJA%')::NUMERIC / COUNT(*), 4) AS tasa
    FROM padron_ruc pr
    INNER JOIN ubigeo u ON pr.ubigeo = u.ubigeo
    GROUP BY u.departamento
),
promedio_ponde AS (
    SELECT SUM(baja)::NUMERIC / SUM(total) AS promedio_ponderado
    FROM datos_base
),
rank_tasa AS (
    SELECT
        departamento,
        tasa,
        baja,
        activo,
        ROW_NUMBER() OVER (ORDER BY tasa DESC) AS rankeo
    FROM datos_base
)
SELECT
    departamento,
    tasa,
    baja,
    activo,
    promedio_ponderado,
    rankeo,
    CASE WHEN tasa > promedio_ponderado THEN 'Por encima del promedio' ELSE 'Por debajo del promedio' END AS clasificacion
FROM rank_tasa
CROSS JOIN promedio_ponde
ORDER BY rankeo;
