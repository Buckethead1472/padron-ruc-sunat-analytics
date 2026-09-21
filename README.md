# Análisis del Padrón RUC de SUNAT con SQL y Power BI

Cuatro preguntas de negocio resueltas con SQL avanzado en PostgreSQL sobre el Padrón RUC de SUNAT (18.3 millones de contribuyentes peruanos), cruzado con datos geográficos del INEI y presentado en un dashboard de Power BI.

## Hallazgos principales

- El **48.87%** de los RUCs con ubicación válida (~2.7 millones) ya fue dado de baja, y el rango entre departamentos es de solo 13 puntos: la mortalidad empresarial es un fenómeno nacional, no de regiones puntuales.
- **Lima concentra el 50.25%** de las empresas activas registradas con ubicación válida. El segundo lugar, Arequipa, tiene 5.94%.
- Lima ocupa 3 de los 4 primeros puestos en densidad de empresas activas por cada 1,000 habitantes (San Isidro lidera con 428.6).
- Más del 90% de los RUCs con domicilio no ubicable ya están dados de baja; el caso urgente para fiscalización es el resto, y ahí Ucayali, Puno y Ayacucho tienen la mayor proporción relativa.

## Preguntas de negocio

| # | Pregunta | Stakeholder | Técnica SQL | Query | Insight |
|---|----------|-------------|-------------|-------|---------|
| 1 | ¿Qué departamentos tienen mayor mortalidad empresarial? | Riesgo crediticio | CTEs encadenadas, `FILTER`, `ROW_NUMBER`, `CROSS JOIN` con promedio ponderado | [SQL](sql/01_mortalidad_departamento.sql) | [Ver](insights/01_mortalidad_departamento.md) |
| 2 | ¿Qué distritos tienen mayor densidad de empresas activas por cada 1,000 habitantes? | Expansión retail | `ROW_NUMBER() OVER (PARTITION BY ...)` para top 3 por departamento | [SQL](sql/02_densidad_distrital.sql) | [Ver](insights/02_densidad_distrital.md) |
| 3 | ¿Dónde es más urgente actualizar domicilios fiscales? | Fiscalización (SUNAT) | Varios `COUNT(*) FILTER` cruzando dos condiciones, `NULLIF` | [SQL](sql/03_condicion_domicilio.sql) | [Ver](insights/03_condicion_domicilio.md) |
| 4 | ¿Cómo se concentran las empresas activas por departamento? | Ventas B2B | `SUM() OVER ()` sin partición, porcentaje sobre el total nacional | [SQL](sql/04_top_departamentos_activas.sql) | [Ver](insights/04_top_departamentos_activas.md) |

## Dashboard

[Ver dashboard interactivo en Power BI](https://app.powerbi.com/view?r=eyJrIjoiMTE4OWRjMDAtMGMwYy00NTM1LThiNjItNjhkZTg2YzU2YTgzIiwidCI6ImE4MDFlMWIwLWI3OGQtNGNjNS1hYWIyLWYzMmJhM2JjYWU3YiIsImMiOjR9)
