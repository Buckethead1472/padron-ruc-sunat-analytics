# Concentración de empresas activas por departamento

**Stakeholder:** Gerente comercial B2B armando territorios de venta a nivel nacional.

**Pregunta:** ¿Qué departamentos concentran más empresas activas y qué porcentaje del total nacional representa cada uno?

**Query:** [sql/04_top_departamentos_activas.sql](../sql/04_top_departamentos_activas.sql)

## Insight

- Lima concentra el **50.25%** de las empresas activas registradas con ubicación válida (444,231 de 883,974): la mitad está en un solo departamento.
- El segundo lugar, Arequipa (5.94%), tiene menos de una octava parte del peso de Lima.
- El top 5 (Lima, Arequipa, La Libertad, Cusco y Piura) reúne el 67.4% del total. El 32.6% restante se reparte entre los otros 20 departamentos.

## Decisión

Tratar a Lima como una unidad aparte al armar territorios de venta, posiblemente dividida en varios dado su volumen. Para el resto del país, tomar Arequipa, La Libertad, Cusco y Piura como polos regionales y agrupar los demás departamentos a su alrededor.

<details>
<summary>Nota metodológica: definición de empresa activa y alcance</summary>

Se consideran activas las empresas con `estado_contribuyente = 'ACTIVO'` exacto, y no todas las que no están dadas de baja. Para un equipo comercial, una empresa suspendida o pendiente no es un cliente potencial real, y contarla inflaría el atractivo de una zona.

El porcentaje se calculó con `SUM(total_activas) OVER ()` sobre los RUCs con ubigeo válido (~2.7 millones de registros, de los cuales 883,974 son activos). La cifra mide cantidad de empresas, no su tamaño ni su facturación.

</details>