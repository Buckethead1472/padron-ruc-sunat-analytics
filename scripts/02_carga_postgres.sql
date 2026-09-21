-- Carga del Padrón RUC y de la tabla de ubigeo en PostgreSQL.
-- Ejecutar desde psql. Ajusta las rutas de los \copy a tu equipo.
-- Nota: cada \copy debe ir en una sola línea.

-- 1. Padrón RUC (todas las columnas como TEXT)
CREATE TABLE padron_ruc (
    ruc                  TEXT,
    razon_social         TEXT,
    estado_contribuyente TEXT,
    condicion_domicilio  TEXT,
    ubigeo               TEXT,
    tipo_via             TEXT,
    nombre_via           TEXT,
    codigo_zona          TEXT,
    tipo_zona            TEXT,
    numero               TEXT,
    interior             TEXT,
    lote                 TEXT,
    departamento_dir     TEXT, 
    manzana              TEXT,
    kilometro            TEXT,
    columna_extra        TEXT  
);

\copy padron_ruc FROM 'ruta/a/padron_limpio.txt' WITH (FORMAT csv, DELIMITER E'\x01', HEADER false, ENCODING 'LATIN1', QUOTE E'\x02');


CREATE TABLE ubigeo_staging (
    ubigeo       TEXT,
    distrito     TEXT,
    provincia    TEXT,
    departamento TEXT,
    poblacion    TEXT,
    superficie   TEXT,
    lat          TEXT,
    lon          TEXT
);

\copy ubigeo_staging FROM 'ruta/a/geodir-ubigeo-inei.csv' WITH (FORMAT csv, HEADER true, ENCODING 'UTF8');

CREATE TABLE ubigeo (
    ubigeo       VARCHAR(6) PRIMARY KEY,
    distrito     VARCHAR(100),
    provincia    VARCHAR(100),
    departamento VARCHAR(100),
    poblacion    INTEGER,
    superficie   NUMERIC(10,2),
    latitud      NUMERIC(10,6),
    longitud     NUMERIC(10,6)
);


INSERT INTO ubigeo (ubigeo, distrito, provincia, departamento, poblacion, superficie, latitud, longitud)
SELECT DISTINCT
    ubigeo, distrito, provincia, departamento,
    REPLACE(poblacion, ',', '')::INTEGER,
    REPLACE(superficie, ',', '')::NUMERIC,
    lat::NUMERIC,
    lon::NUMERIC
FROM ubigeo_staging
WHERE ubigeo IS NOT NULL;

DROP TABLE ubigeo_staging;
