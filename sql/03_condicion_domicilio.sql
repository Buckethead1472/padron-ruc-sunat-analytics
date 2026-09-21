-- Pregunta de negocio: ¿Qué departamentos concentran más RUCs con domicilio no ubicable (NO HABIDO + variantes de NO HALLADO) y dónde es más urgente actuar según si siguen sin estar dados de baja?
-- Insight completo: ver insights/03_condicion_domicilio.md
-- Stakeholder: SUNAT, área de fiscalización (campañas de actualización de domicilio)
-- 'NO HA%' agrupa NO HABIDO y todas las variantes de NO HALLADO (se mudó, cerrado, no existe, etc.)
WITH calculo AS (
    SELECT
        u.departamento,
        COUNT(*) AS total_departamento,
 
        COUNT(*) FILTER (WHERE pr.condicion_domicilio LIKE 'NO HA%') AS total_no_habido,
        COUNT(*) FILTER (
            WHERE pr.estado_contribuyente NOT LIKE 'BAJA%'
              AND pr.condicion_domicilio LIKE 'NO HA%'
        ) AS activos_no_habido,
        COUNT(*) FILTER (
            WHERE pr.estado_contribuyente LIKE 'BAJA%'
              AND pr.condicion_domicilio LIKE 'NO HA%'
        ) AS baja_no_habido
    FROM padron_ruc pr
    INNER JOIN ubigeo u ON pr.ubigeo = u.ubigeo
    GROUP BY u.departamento
)
SELECT
    departamento,
    total_departamento,
    total_no_habido,
    activos_no_habido,
    baja_no_habido,
    ROUND(total_no_habido::NUMERIC / total_departamento, 4) AS tasa_no_habido,
    ROUND(activos_no_habido::NUMERIC / NULLIF(total_no_habido, 0), 4) AS porcentaje_no_habido_que_sigue_activo,
    ROUND(activos_no_habido::NUMERIC / total_departamento, 4) AS tasa_activo_no_habido
FROM calculo
ORDER BY tasa_activo_no_habido DESC, activos_no_habido DESC;
