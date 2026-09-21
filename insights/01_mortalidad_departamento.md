# Mortalidad empresarial por departamento

**Stakeholder:** Analista de riesgo crediticio evaluando la expansión de una cartera pyme.

**Pregunta:** ¿Qué departamentos tienen mayor riesgo de mortalidad empresarial?

**Query:** [sql/01_mortalidad_departamento.sql](../sql/01_mortalidad_departamento.sql)

## Insight

- La tasa nacional ponderada de mortalidad es de **48.87%**, sobre ~2.7 millones de RUCs con ubicación válida.
- Los departamentos van de 43.2% (La Libertad) a 56.1% (Tacna): el riesgo está distribuido a nivel nacional, no aislado en regiones puntuales.
- Lima reúne cerca de la mitad de los RUCs con ubicación válida (1.34M) y tiene una tasa de 50.4%, por encima del promedio nacional de 48.87%. Es el dato que más pesa en cualquier cartera real, aunque no encabece el ranking.

## Decisión

Aplicar cautela crediticia base en todo el país, con foco reforzado en Lima por su peso en volumen.

<details>
<summary>Nota metodológica: promedio simple vs. ponderado</summary>

Se usó el promedio ponderado (`SUM(bajas) / SUM(total)`) en lugar del promedio simple entre departamentos, porque cada RUC debe pesar igual sin importar el tamaño de su departamento. Así se refleja el peso real de cada zona en una cartera de créditos. El promedio simple daba 48.37%, muy similar en este caso.

</details>
