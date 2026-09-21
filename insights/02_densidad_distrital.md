# Densidad de empresas activas por distrito

**Stakeholder:** Gerente de expansión de una cadena retail evaluando dónde abrir el próximo local.

**Pregunta:** ¿Qué distritos tienen mayor densidad de empresas activas por cada 1,000 habitantes?

**Query:** [sql/02_densidad_distrital.sql](../sql/02_densidad_distrital.sql)

## Insight

- San Isidro (Lima) lidera con 428.6 empresas activas por cada 1,000 habitantes, más del doble que el distrito líder de cualquier otro departamento (Arequipa, 196.7).
- Lima ocupa 3 de los 4 primeros puestos a nivel nacional: San Isidro (428.6), Miraflores (334.7) y Lince (172.9). El tercer puesto es Arequipa (196.7).
- Fuera de Lima, el distrito líder de cada departamento suele ser la capital departamental o el centro comercial de la ciudad principal (Arequipa, Trujillo, Chiclayo, Piura, Iquitos, y también Juliaca, Jaén y Tarapoto). Esto refleja comercio y servicios que atienden a población de toda la región, no solo a los residentes.
- Se excluyeron los distritos con menos de 10,000 habitantes para evitar distorsión estadística: poblaciones muy chicas con pocas empresas generan ratios artificialmente altos sin representar una oportunidad real de mercado.

## Decisión

Priorizar Lima (especialmente San Isidro y Miraflores) para formatos premium o de alto tráfico corporativo. Para la expansión regional, partir del distrito líder de cada departamento, que en la mayoría de los casos es la capital o el centro comercial de la ciudad principal, antes que los distritos periféricos.

<details>
<summary>Nota metodológica: filtro de población y alcance de la métrica</summary>

Se aplicó `WHERE poblacion >= 10000` antes de agrupar. Sin este filtro, distritos rurales muy pequeños (por ejemplo, uno con ~5,300 habitantes) aparecían con densidades infladas por tener solo un puñado de empresas, sin representar un mercado real para una cadena retail.

La métrica cuenta empresas según su domicilio fiscal y divide entre la población residente. Mide dónde están registradas las empresas, no dónde está la demanda: en distritos corporativos como San Isidro, el resultado puede reflejar sedes administrativas y no solo consumidores.

</details>