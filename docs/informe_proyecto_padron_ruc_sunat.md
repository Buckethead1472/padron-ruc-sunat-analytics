# Informe técnico: carga y preparación de los datos

## Objetivo

Cargar el Padrón Reducido RUC de SUNAT (18.3 millones de registros) y una tabla de ubigeo del INEI en PostgreSQL, dejando una base lista para responder preguntas de negocio con SQL. Este documento registra las fuentes, los problemas de carga y cómo se resolvieron. Las consultas de análisis están en [`sql/`](../sql/) y los insights en [`insights/`](../insights/).

## 1. Fuentes de datos

El detalle de cada fuente (enlaces, formato, campos y fecha de corte) está en [data/README.md](../data/README.md). Resumen:

- **Padrón Reducido RUC (SUNAT):** `.txt` separado por `|`, codificación Latin-1 (no UTF-8), ~300 MB, 18,362,259 filas cargadas.
- **Ubigeo (INEI, vía `geodir/ubigeo-peru`):** `.csv` en UTF-8, 1,874 distritos.

Dos observaciones del padrón:

- El campo `DEPARTAMENTO` no es la región política: es parte de la dirección física (por ejemplo, el número de departamento de un edificio). La región se obtiene del `UBIGEO`.
- Cada línea trae un `|` sobrante al final, que genera una 16.ª columna vacía. Por eso la tabla final incluye una columna de buffer (`columna_extra`).


## 2. Problemas encontrados durante la importación

| Problema | Causa | Solución |
|---|---|---|
| La descarga del padrón no iniciaba en el navegador | Archivo pesado (~300 MB) y servidor de SUNAT inestable | Reintentar, usar un gestor de descargas u otro navegador |
| `ERROR: datos extra después de la última columna esperada` | El archivo trae un `\|` sobrante al final de cada línea (16 campos en vez de 15) | Se agregó la columna `columna_extra` para absorber el campo vacío |
| `ERROR: el valor es demasiado largo para varchar(255)` | Longitudes de texto subestimadas (razones sociales largas) | Todas las columnas de la tabla se definieron como `TEXT` |
| `ERROR: faltan datos en la columna...` | Comillas dobles sueltas dentro de nombres de empresas rompían el parser CSV de Postgres | Script de Python que divide cada línea por `\|` con un máximo fijo de columnas y las une con un delimitador de control (`\x01`) que nunca aparece en el texto real |
| `ERROR: datos extra después de la última columna esperada` (segunda vez, otra causa) | Filas con separadores de más por caracteres sueltos, imposibles de prever caso por caso | El mismo script de limpieza, que fuerza exactamente 16 columnas por fila |
| `ERROR: secuencia de bytes no válida para codificación UTF8` | El archivo de CONCYTEC también estaba en Latin-1 | Cambiar `ENCODING 'UTF8'` por `ENCODING 'LATIN1'` en el `\copy` |
| `ERROR: la sintaxis de entrada no es válida para tipo numeric: "4,430.84"` | La `superficie` del ubigeo usa coma como separador de miles | `REPLACE(superficie, ',', '')::NUMERIC` |
| 85% de registros sin coincidencia en el primer `JOIN` | 15.6 millones de RUCs tienen `ubigeo = '-'` (sin dirección fiscal estructurada): dato faltante real, no un error | Se excluyen del análisis geográfico con `INNER JOIN` (siguen siendo válidos para análisis sin ubicación) |

## 3. Scripts de carga

- [`scripts/01_limpieza_padron.py`](../scripts/01_limpieza_padron.py): fuerza 16 columnas por fila y escribe el archivo limpio con delimitador `\x01`.
- [`scripts/02_carga_postgres.sql`](../scripts/02_carga_postgres.sql): crea las tablas y carga los datos con `\copy`, que se ejecuta del lado del cliente y evita problemas de permisos del servidor.

El `\copy` del padrón usa `QUOTE E'\x02'` para que ninguna comilla del texto se interprete como delimitador de campo.

## 4. Estructura final de la base

**Motor:** PostgreSQL. **Herramienta de carga:** `psql`.

- **`padron_ruc`:** 16 columnas de tipo `TEXT` (incluida `columna_extra`), 18,362,259 filas.
- **`ubigeo`:** dimensión geográfica del INEI con `ubigeo` como clave primaria, población, superficie y coordenadas, 1,874 filas.

No hay clave foránea declarada, por el volumen y por el porcentaje mínimo de registros sin coincidencia. La relación lógica es `padron_ruc.ubigeo = ubigeo.ubigeo`.

### Calidad del cruce

| Concepto | Registros |
|---|---|
| Total en `padron_ruc` | 18,362,259 |
| Con `ubigeo = '-'` (sin dirección fiscal) | 15,662,160 |
| Con ubigeo real pero sin coincidencia en `ubigeo` | 1,842 (0.068% de los que tienen ubigeo real) |
| **Cruzan correctamente** | **2,698,257** |

## 5. Entorno

Windows, PostgreSQL, `psql` como cliente y Python (ejecutado en Visual Studio Code) para la limpieza.