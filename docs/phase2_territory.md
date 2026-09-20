# Fase 2. Universo territorial

La unidad de partida son los 1.122 códigos de la tabla GEI de IDEAM entre 1990 y 2024. Se conservaron los archivos originales y se revisaron por código y año los libros de población, valor agregado y DIVIPOLA. Este trabajo organiza el territorio para la próxima fase. Todavía no existe un panel de emisiones, economía y población.

## Qué se puede unir

Los 1.122 códigos de IDEAM son exactamente los mismos 1.122 registros consultados en la capa DIVIPOLA 2025 de DANE. Esa capa distingue 1.103 registros de tipo `MUNICIPIO`, 18 `ÁREA NO MUNICIPALIZADA` y uno `ISLA`, San Andrés (`88001`). Llamaremos **unidades territoriales** al conjunto completo para no presentar las 18 áreas y la isla como municipios de la misma clase.

La metodología general de IDEAM habla de 1.123 municipios en su descripción de cobertura subnacional, mientras que **el CSV concreto recibido** tiene 1.122 códigos territoriales. El archivo DANE con 1.123 conserva Mapiripana. Registramos esta diferencia de conteo y terminología entre el texto metodológico y los archivos examinados; no completamos la fila ausente con un valor supuesto.

El libro DANE de valor agregado tiene 1.123 códigos en cada año de 2011 a 2024. El adicional es `94663`, Mapiripana. Los libros de población también lo contienen. No aparece en IDEAM ni en DIVIPOLA 2025. [DANE documentó](https://www.dane.gov.co/files/investigaciones/pib/departamentales/B_2015/Bol_PIB_dptal_2020provisional.pdf) que Mapiripana formó parte de la creación del municipio de Barrancominas, incorporado a DIVIPOLA en 2020. Esto explica por qué merece un tratamiento histórico, pero no autoriza sumar su población o su valor agregado al código `94343` en todos los años. Los dos códigos pueden tener series propias en el mismo archivo y producir doble conteo si se agregan sin conocer la regla aplicada por DANE.

El código `27493` corresponde a Nuevo Belén de Bajirá. [DANE señala](https://www.dane.gov.co/files/operaciones/ELIC/bol-ELIC-ene2025.pdf) que se segregó de Riosucio y se incorporó a DIVIPOLA en enero de 2024. Los libros de población anteriores a 2018 no traen ese código; el libro reciente lo presenta con población cero entre 2018 y 2023 y 29.812 en 2024. El valor agregado registra cero para `27493` de 2011 a 2023 y un valor positivo en 2024. En cambio, IDEAM le asigna filas con valor distinto de cero incluso en 1990 y 2023. No sabemos aún qué límites o método de asignación retroactiva empleó IDEAM en esos años. La [metodología general de IDEAM](https://www.ideam.gov.co/sites/default/files/mapa-de-procesos/gci-gi-mo001_documento_metodologico_de_la_operacion_estadistica_estadisticas_del_inventario_de_emisiones_y_absorciones_atmosfericas.pdf) admite desagregaciones tanto con datos locales como mediante factores, pero no resuelve en este documento la equivalencia particular de `27493`. Barrancominas (`94343`) también aparece en IDEAM desde 1990, antes de su creación administrativa. Ambos quedan marcados para una prueba de comparabilidad histórica; sus valores originales no se reasignan.

## Pérdidas al unir por código y año

| Año o ventana | IDEAM | Con fila de población | Con población mayor que cero | Con población y valor agregado positivos |
|---|---:|---:|---:|---:|
| 1990 | 1.122 | 1.121 | 1.044 | No aplica |
| 2011–2017, cada año | 1.122 | 1.121 | 1.121 | 1.121 |
| 2018–2023, cada año | 1.122 | 1.122 | 1.121 | 1.121 |
| 2024 | 1.122 | 1.122 | 1.122 | 1.122 |

El faltante de 1990–2017 es siempre `27493`. Hay **564 pares código–año con población cero** entre los códigos de IDEAM a lo largo de 1990–2024, concentrados en años anteriores; un cero no sirve como denominador de una tasa. Solo 1.044 códigos de IDEAM tienen población positiva en los 35 años. En la ventana económica, 1.121 códigos permiten una serie positiva completa de 2011 a 2024; `27493` solo entra con denominadores positivos en 2024. Estas cifras describen compatibilidad de claves y denominadores, no calidad sustantiva de cada estimación.

Si se restringe la muestra a los **1.103 registros marcados `MUNICIPIO` en 2025**, hay 1.028 con población positiva en 1990, 1.102 con población y valor agregado positivos en cada año de 2011 a 2023, y 1.103 en 2024. La diferencia con el universo completo incluye áreas no municipalizadas y la isla. Estos números tampoco corrigen por sí mismos los cambios de límites.

La tabla `data/metadata/territorial_join_coverage.csv` conserva el recuento de cada año. `territorial_exceptions.csv` identifica cada cero y el archivo del que proviene. La tabla maestra tiene una fila por código y registra su nombre de referencia, tipo según DIVIPOLA 2025, presencia en fuentes y años con denominadores positivos. La información de 2025 es una **clasificación de referencia**, no una prueba de que los límites fueran idénticos desde 1990.

## Regla de trabajo para la Fase 3

Se conserva el universo de 1.122 códigos IDEAM como referencia para emisiones y se registra el tipo territorial por separado. La muestra de municipios según DIVIPOLA 2025 tiene 1.103 códigos. La isla y las 18 áreas no municipalizadas se mantienen identificables para comparar una muestra restringida y para revisar qué se perdería. No se elimina ninguna fila original ni se cambia la identidad de Mapiripana, Barrancominas, Nuevo Belén de Bajirá o Riosucio. Las tasas solo serán admisibles donde el denominador sea positivo y se haya revisado la compatibilidad territorial.

Esta es una regla provisional de organización, no una decisión de que una serie longitudinal represente automáticamente los mismos límites. Antes de calcular tendencias locales o desacoplamiento, la Fase 3 deberá examinar las dos creaciones municipales, posibles revisiones retrospectivas y los ceros de los archivos DANE. Una muestra equilibrada de 1.044 códigos para tasas 1990–2024 es una opción descriptiva, no una exclusión automática del resto. Conviene comparar resultados con muestras anuales y con el subconjunto estable.

## Geometrías y límites de esta auditoría

La [capa municipal del MGN 2025](https://geoportal.dane.gov.co/mparcgis/rest/services/MGN2025/Serv_CapasMGN_2025/MapServer/317) ofrece polígonos y códigos de cinco dígitos. El archivo de atributos DIVIPOLA usado aquí proviene también de un servicio de polígonos y contiene 1.122 registros, aunque la consulta se hizo con `returnGeometry=false`. DANE mantiene además un [servicio de municipios y áreas no municipalizadas de 2018](https://geoportal.dane.gov.co/mparcgis/rest/services/Divipola/Serv_DeptosMpiosANM_2018/MapServer). No descargamos polígonos ni comprobamos su topología, solapamientos o equivalencia geométrica entre versiones. Esas verificaciones se harán antes de los mapas y las vecindades.

La [página de licencia del Geoportal DANE](https://geoportal.dane.gov.co/acerca-del-geoportal/licencia-y-condiciones-de-uso/) explica el uso de información geográfica con atribución a DANE. Las condiciones concretas de redistribución de cada archivo fuente y del ZIP de IDEAM deben seguir revisándose antes de compartir datos. Solo los controles pequeños y el código se versionan.

## Cómo reproducir el control

Desde la raíz del proyecto, `Rscript R/cleaning/build_territory.R` comprueba primero tamaño y SHA-256 de los originales empleados, lee los códigos como texto y genera las tres tablas territoriales. `Rscript R/cleaning/check_special_ideam.R` revisa las filas de IDEAM para `27493` y `94343`. `readxl` quedó instalado y registrado en `renv.lock`. La primera instrucción puede tardar por el hash del CSV de 3,30 GB; no descarga datos ni altera los originales.

La puerta de Fase 2 queda satisfecha para el inventario de claves, tipos y pérdidas por unión. Sigue abierta la **interpretación de los límites históricos** de IDEAM para municipios nuevos, que se documenta como restricción de cualquier análisis longitudinal. La Fase 3 no se inicia con este informe.
