🏦 Mortalidad empresarial por departamento

Stakeholder: Analista de riesgo crediticio evaluando expansión de cartera pyme

Pregunta: ¿Qué departamentos tienen mayor riesgo de mortalidad empresarial?

sql
-- ver query completa en sql/01_mortalidad_departamento.sql

Insight:

Tasa nacional ponderada de mortalidad: 48.87% (18.3M RUCs analizados)
Rango entre departamentos: 43.2% (La Libertad) a 56.1% (Tacna) → riesgo distribuido a nivel nacional, no aislado a regiones puntuales
🔑 Lima (40% del volumen total) está por encima del promedio (50.4%) — el dato que más pesa en cualquier cartera real, aunque no encabece el ranking

Decisión: Aplicar cautela crediticia base en todo el país, con foco reforzado en Lima por su peso en volumen.

<details> <summary>📌 Nota metodológica: promedio simple vs ponderado</summary>

Se usó promedio ponderado (SUM(bajas)/SUM(total)) en vez de promedio simple entre departamentos, porque cada RUC debe pesar igual sin importar el tamaño de su departamento — así se refleja el peso real de cada zona en una cartera de créditos. El simple daba 48.37%, muy similar en este caso.

</details>