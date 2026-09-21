# Análisis del Padrón RUC de SUNAT con SQL y Power BI

¿Qué tan sano es el ecosistema empresarial peruano y dónde conviene actuar? Este proyecto responde cuatro preguntas de negocio con SQL avanzado sobre el Padrón RUC de SUNAT (18.3 millones de contribuyentes), cruzado con datos de ubigeo del INEI.

## Hallazgos principales

- El **48.87%** de los RUCs con ubicación válida (~2.7 millones) ya fue dado de baja, y el rango entre departamentos es de solo 13 puntos: la mortalidad empresarial es un fenómeno nacional.
- **Lima concentra el 50.25%** de las empresas activas registradas con ubicación válida; el segundo lugar, Arequipa, tiene 5.94%.
- Lima ocupa 3 de los 4 primeros puestos en densidad de empresas activas por cada 1,000 habitantes (San Isidro lidera con 428.6).

## Preguntas de negocio

| # | Pregunta | Stakeholder | Query | Insight |
|---|----------|-------------|-------|---------|
| 1 | ¿Qué departamentos tienen mayor mortalidad empresarial? | Riesgo crediticio | [SQL](sql/01_mortalidad_departamento.sql) | [Ver](insights/01_mortalidad_departamento.md) |
| 2 | ¿Qué distritos tienen mayor densidad de empresas activas por cada 1,000 habitantes? | Expansión retail | [SQL](sql/02_densidad_distrital.sql) | [Ver](insights/02_densidad_distrital.md) |
| 3 | ¿Dónde es más urgente actualizar domicilios fiscales? | Fiscalización (SUNAT) | [SQL](sql/03_condicion_domicilio.sql) | [Ver](insights/03_condicion_domicilio.md) |
| 4 | ¿Cómo se concentran las empresas activas por departamento? | Ventas B2B | [SQL](sql/04_top_departamentos_activas.sql) | [Ver](insights/04_top_departamentos_activas.md) |

## Dashboard

[Ver dashboard interactivo en Power BI]([PEGAR_LINK_AQUI](https://app.powerbi.com/view?r=eyJrIjoiMTE4OWRjMDAtMGMwYy00NTM1LThiNjItNjhkZTg2YzU2YTgzIiwidCI6ImE4MDFlMWIwLWI3OGQtNGNjNS1hYWIyLWYzMmJhM2JjYWU3YiIsImMiOjR9))

## Stack

PostgreSQL · SQL avanzado (CTEs, window functions, `FILTER`, subconsultas) · Python (limpieza) · Power BI

## Pipeline

```
Padrón RUC (SUNAT, .txt) ──► Limpieza con Python ──► PostgreSQL ──► Consultas SQL ──► Power BI
Ubigeo (INEI, .csv)      ──────────────────────────►
```

## Alcance de los datos

El padrón completo tiene 18.3 millones de registros, pero 15.6 millones no tienen dirección fiscal estructurada (`ubigeo = '-'`). Los análisis geográficos usan los **2,698,257 RUCs con ubicación válida**.

## Problemas técnicos resueltos

La carga del padrón requirió resolver un separador sobrante en cada línea, comillas sueltas que rompían el parser, filas con columnas de más y un encoding Latin-1 que no es UTF-8. También se probó una segunda fuente de ubigeo (CONCYTEC) y se descartó porque cruzaba peor con los datos reales. El detalle está en [docs/informe_tecnico.md](docs/informe_tecnico.md).

## Cómo replicarlo

1. Descargar el Padrón Reducido RUC y la tabla de ubigeo (ver [data/README.md](data/README.md)).
2. Ejecutar [scripts/01_limpieza_padron.py](scripts/01_limpieza_padron.py).
3. Crear las tablas y cargar los datos con [scripts/02_carga_postgres.sql](scripts/02_carga_postgres.sql).
4. Ejecutar las consultas de la carpeta `sql/`.

## Autor

Yamil Nair Solis Diaz, ingeniero de sistemas e informática.
