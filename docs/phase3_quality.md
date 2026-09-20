# Fase 3. Panel núcleo y controles de calidad

Construimos un panel local de **39.270 filas** para 1.122 códigos y 35 años, 1990–2024. Cada código–año aparece una sola vez. Las fuentes originales no se editaron; antes de leerlas se comprobó su tamaño y SHA-256. El panel y el detalle sectorial se guardan fuera de Git. `data/metadata/phase3_products.csv` registra el tamaño y hash de ambos archivos derivados para identificar la versión exacta del resultado.

## Emisiones y conciliación

El inventario distingue `CO2_ABS` de los demás gases. La suma municipal de emisiones brutas, absorciones y netas coincide con la fila `Nacional` del libro IDEAM para **cada uno de los 35 años**. La suma de cada uno de los cinco sectores también coincide año por año. El error numérico máximo de la conciliación neta nacional fue aproximadamente `7,6 × 10⁻¹⁰ kt`, atribuible al orden de suma de números decimales. Los controles están en `data/metadata/phase3_national_check.csv` y `phase3_sector_check.csv`.

Los signos no se forzaron. El CSV contiene 4.310 filas negativas de `CH4` en residuos, con suma de −4.866,7 kt CO2e a lo largo de la serie, y siete filas positivas de `CO2_ABS`, con suma de 0,49 kt CO2e. La regla usada reproduce exactamente el total oficial. Aun así, la explicación metodológica de estos signos particulares merece revisión antes de atribuir mecanismos locales. El detalle pequeño está en `phase3_unusual_signs.csv`. Las emisiones brutas agregadas por código–año son positivas en todo el panel; 465 resultados netos son cero o negativos, por lo que no se les aplicarán logaritmos ordinarios.

## Unión con DANE

De los 39.270 pares de IDEAM, 28 no tienen fila de población DANE y 564 tienen población cero. Hay **622 tasas por habitante sin calcular**: esos 592 casos y otros 30 pares de Barrancominas anteriores a 2020, cuya asignación territorial histórica requiere aclaración aunque la población sea positiva. Nuevo Belén de Bajirá ya carece de denominador positivo antes de 2024. Se conservan las emisiones de todas estas filas, con una marca; no se sustituyen faltantes por cero.

El libro de valor agregado aporta 2011–2024 en **precios corrientes**. [DANE presenta el indicador municipal a precios corrientes](https://www.dane.gov.co/index.php/estadisticas-por-tema/cuentas-nacionales/cuentas-nacionales-departamentales/indicador-de-importancia-economica-municipal). También publica series reales a otras escalas, pero el archivo municipal obtenido no incluye un deflactor local ni una serie municipal real. Escoger uno nacional o departamental cambiaría la interpretación cuando la estructura productiva local difiere. En esta fase conservamos el dato nominal, **sin** producir intensidad económica comparable entre años ni clasificaciones de desacoplamiento. Esa elección y su sensibilidad requieren trabajo metodológico posterior.

## Cuánto pesan las excepciones

| Año | Unidades con tasa bruta por habitante admisible | Parte de las emisiones brutas sin población positiva | Parte bruta de las 18 áreas y la isla | Parte bruta de los tres códigos con revisión de límites |
|---|---:|---:|---:|---:|
| 1990 | 1.043 | 5,69 % | 1,06 % | 0,42 % |
| 2011 | 1.120 | 0,008 % | 0,82 % | 0,22 % |
| 2018 | 1.120 | 0,006 % | 1,02 % | 0,29 % |
| 2024 | 1.122 | 0 % | 0,77 % | 0,28 % |

En 1990 la falta de población positiva **sí es material** para una cifra nacional derivada de tasas. Entre los casos con población cero aparecen Puerto Guzmán y Uribe, con emisiones brutas registradas por IDEAM; no se presupone que el cero demográfico signifique ausencia de actividad. En 2011–2024, la participación bruta sin población positiva no supera 0,015 % en ningún año. La exclusión de áreas no municipalizadas y la isla pesa menos de 1,1 % de las emisiones brutas en los años examinados. Los porcentajes de emisiones **netas** se conservan en `phase3_impact_by_year.csv`, pero pueden ser difíciles de interpretar por el signo de las absorciones; se reportan junto con sus sumas en kt, no como una medida única de impacto.

Estos porcentajes no agotan el problema de límites. DANE documenta la incorporación de [Nuevo Belén de Bajirá en 2024](https://www.dane.gov.co/files/operaciones/ELIC/bol-ELIC-ene2025.pdf) y de [Barrancominas, formado en parte a partir de Mapiripana](https://www.dane.gov.co/files/investigaciones/pib/departamentales/B_2015/Bol_PIB_dptal_2020provisional.pdf). IDEAM registra ambos códigos en años anteriores. Las filas se conservan, pero las tasas de esas asignaciones tempranas se dejan vacías en el caso de Barrancominas; Riosucio queda marcado por su relación con el cambio de 2024. Tampoco se fusionó Mapiripana con ningún código. Aún no hay una comprobación exhaustiva de todos los cambios de límites entre 1990 y 2024.

## Otros controles y siguientes usos

No se detectaron duplicados de código–año, emisiones faltantes en el agregado, denominadores negativos ni nuevos códigos inesperados. `phase3_jump_review.csv` contiene 30 saltos interanuales destacados de emisiones brutas y **no los corrige**; podrían reflejar la actividad, una asignación territorial o un cambio metodológico. La revisión por categoría y fuente corresponde a la exploración descriptiva.

Para regenerar el panel desde la raíz del proyecto se ejecuta `Rscript R/cleaning/build_core_panel.R` con el entorno de `renv`. El script verifica los originales, compara su cobertura con la auditoría de Fase 2 y detiene el proceso si falla la conciliación nacional o sectorial. Los campos se explican en [el diccionario](phase3_dictionary.md). La puerta de calidad de Fase 3 se cumple para el **panel descriptivo con marcas de cautela**. No se puede usar todavía para concluir que un municipio cambió su intensidad económica real, que una frontera de 2025 era válida en 1990 o que una política causó una variación. La Fase 4 no ha comenzado.
