# Datos

Este proyecto usa dos fuentes públicas. Los datos crudos no se incluyen en el repositorio por su tamaño.

## 1. Padrón Reducido RUC (SUNAT)

- **Página de descarga:** https://www.sunat.gob.pe/descargaPRR/mrc137_padron_reducido.html
- **Archivo usado:** `padron_reducido_RUC.zip`.
- **Fecha de corte de esta descarga:** 28/08/2026
- **Formato:** `.txt` separado por `|`, codificación Latin-1 (no UTF-8), ~300 MB descomprimido.
- **Registros cargados:** 18,362,259.

SUNAT actualiza este archivo con frecuencia, por lo que una descarga posterior puede dar cifras ligeramente distintas a las publicadas aquí.

**Campos:** RUC, nombre o razón social, estado del contribuyente, condición de domicilio, ubigeo, tipo de vía, nombre de vía, código de zona, tipo de zona, número, interior, lote, departamento, manzana y kilómetro.

Notas:

- El campo `DEPARTAMENTO` es parte de la dirección física (por ejemplo, un número de departamento en un edificio), no la región política. La región se obtiene con el `UBIGEO`.
- Cada línea trae un `|` sobrante al final, lo que genera una columna vacía. El script de limpieza lo maneja.

## 2. Tabla de ubigeo (INEI)

- **Repositorio:** https://github.com/geodir/ubigeo-peru
- **Archivo usado:** `geodir-ubigeo-inei.csv`
- **Formato:** `.csv` separado por comas, UTF-8, 1,874 distritos.
- **Campos:** ubigeo, distrito, provincia, departamento, población, superficie, latitud y longitud.
- **Limpieza necesaria:** `población` y `superficie` traen comas como separador de miles (por ejemplo `"4,430.84"`), que deben quitarse antes de convertirlas a número.
