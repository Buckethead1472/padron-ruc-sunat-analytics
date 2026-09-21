# Domicilios no ubicables: dónde es más urgente actuar

**Stakeholder:** SUNAT, área de fiscalización, priorizando campañas de actualización de domicilio fiscal.

**Pregunta:** ¿Qué departamentos concentran más RUCs con domicilio no ubicable (NO HABIDO y variantes de NO HALLADO) y dónde es más urgente actuar, según si esas empresas siguen sin estar dadas de baja?

**Query:** [sql/03_condicion_domicilio.sql](../sql/03_condicion_domicilio.sql)

## Insight

- Entre los RUCs con domicilio registrado, alrededor del 94% de los casos no ubicables corresponde a empresas ya dadas de baja. Por departamento, el porcentaje que no está de baja va de 4.2% (Tacna) a 10.8% (Apurímac y Puno).
- El problema urgente para fiscalización es ese restante, unos 21,840 casos: empresas no dadas de baja cuyo domicilio no puede ubicarse, y que por lo tanto no pueden ser notificadas.
- Volumen y proporción divergen. Lima concentra el mayor número de estos casos (9,938, casi la mitad del total), pero en relación con el tamaño de su padrón queda fuera del top 10 (0.74%). Ucayali (1.64%), Puno (1.44%) y Ayacucho (1.16%) tienen la mayor proporción de su padrón en esta situación, con un volumen absoluto mucho menor (Áncash, con 1.14%, queda casi empatado con Ayacucho).
- Esto sugiere dos estrategias de fiscalización distintas y complementarias, no una sola.

## Decisión

Si el objetivo es resolver la mayor cantidad de casos con recursos limitados, priorizar Lima por volumen absoluto. Si el objetivo es atacar las zonas con mayor incidencia relativa de domicilios no ubicables, priorizar Ucayali, Puno y Ayacucho.

<details>
<summary>Nota metodológica: definiciones y alcance</summary>

**"No ubicable"**: se agrupó NO HABIDO junto con todas las variantes de NO HALLADO (se mudó, cerrado, no existe, etc.) con el patrón `LIKE 'NO HA%'`, porque desde la perspectiva de fiscalización el problema práctico, no poder notificar a la empresa, es el mismo en todos los casos.

**"No dada de baja"**: se define como `estado_contribuyente NOT LIKE 'BAJA%'`, por lo que incluye también estados como suspensión temporal. No equivale necesariamente a una empresa en operación.

**Alcance**: el análisis cubre los RUCs con ubigeo válido (~2.7 millones), porque el cruce con la tabla de ubigeo excluye a los que no tienen dirección fiscal estructurada.

</details>