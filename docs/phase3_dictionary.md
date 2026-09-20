# Diccionario del panel núcleo

El archivo local `data/processed/core_panel.csv` tiene una fila por código territorial y año de 1990 a 2024. Está excluido de Git y se regenera con `R/cleaning/build_core_panel.R`. Los originales y sus hashes figuran en `data/metadata/manifest.csv`. Las unidades de emisiones son **miles de toneladas de CO₂ equivalente** (`kt CO2e`).

| Columna | Qué significa |
|---|---|
| `code` | Código de cinco caracteres de IDEAM. Leer como texto, también al abrir el CSV en otro programa. |
| `year` | Año del inventario. |
| `gross_kt` | Suma de `Valor_CO2eq` salvo las filas `CO2_ABS`. Conciliada con la columna de emisiones brutas del consolidado nacional. |
| `removals_kt` | Suma con signo de `Valor_CO2eq` en `CO2_ABS`. Es normalmente negativa, pero algunos registros originales son positivos. |
| `net_kt` | `gross_kt + removals_kt`. Puede ser cero o negativa. |
| `source_rows` | Número de filas GEI originales que forman esa combinación código–año. |
| `population` | Población total del libro DANE correspondiente, sin interpolar. Ausente cuando no hay fila para el código y año. |
| `vam_nominal_billion_cop` | Valor agregado municipal de DANE en miles de millones de pesos corrientes. Solo 2011–2024. No representa crecimiento real. |
| `name`, `department_code` | Nombre y código departamental de referencia según DIVIPOLA 2025. El código departamental también se lee como texto. |
| `type_divipola_2025` | `MUNICIPIO`, `ÁREA NO MUNICIPALIZADA` o `ISLA` según la consulta de 2025. No describe automáticamente el tipo o los límites históricos. |
| `population_status` | `positivo`, `cero` o `sin_fila`. Un cero y un faltante tienen significados diferentes. |
| `vam_status` | `fuera_ventana`, `positivo`, `cero` o `sin_fila`. |
| `historical_assignment_flag` | `TRUE` para Nuevo Belén de Bajirá antes de 2024 y Barrancominas antes de 2020. IDEAM asigna emisiones antes de su incorporación administrativa documentada. No se infiere un límite histórico idéntico. |
| `boundary_review_flag` | `TRUE` para Nuevo Belén de Bajirá, Riosucio (Chocó) y Barrancominas durante toda la serie. Marca una revisión temporal pendiente, no un inventario exhaustivo de cambios municipales. |
| `per_capita_gross_t`, `per_capita_net_t` | Toneladas de CO₂e por persona (`kt × 1.000 / población`). Solo se calculan con población positiva y sin la asignación histórica indicada. La tasa neta puede ser negativa. |
| `vam_nominal_only` | Indica valor agregado nominal positivo; **no** habilita por sí solo intensidad económica real ni desacoplamiento. |

`data/interim/gei_sector_year.csv` conserva emisiones brutas, absorciones y netas por código, año y sector IPCC. No se ha incorporado un índice de precios, ninguna geometría ni variables económicas reales. No se estimaron modelos.
