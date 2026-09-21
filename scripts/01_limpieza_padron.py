"""
Limpieza del Padrón Reducido RUC (SUNAT) antes de cargarlo a PostgreSQL.

El archivo original trae un '|' sobrante al final de cada línea, comillas sueltas
y algunas filas con separadores de más, lo que rompe el conteo de columnas de COPY.
Este script fuerza exactamente NUM_COLS columnas por fila y usa un delimitador de
control (\\x01) que nunca aparece en el texto real.
"""


INPUT_PATH = r"ruta/a/padron_reducido_ruc.txt"  
OUTPUT_PATH = r"ruta/a/padron_limpio.txt"     

NUM_COLS = 16

with open(INPUT_PATH, encoding="latin-1") as fin, \
     open(OUTPUT_PATH, "w", encoding="latin-1", newline="") as fout:

    header = fin.readline()  
    filas_con_problemas = 0

    for line in fin:
        line = line.rstrip("\n").rstrip("\r")
        partes = line.split("|", NUM_COLS - 1) 

        if len(partes) < NUM_COLS:
            filas_con_problemas += 1
            while len(partes) < NUM_COLS:
                partes.append("")

        fout.write("\x01".join(partes) + "\n")

print(f"Listo. Filas con menos columnas de lo esperado: {filas_con_problemas}")
