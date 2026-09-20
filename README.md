# Transiciones de carbono en municipios de Colombia

**Estado:** Fase 2, universo territorial auditado. Hay archivos originales locales y controles de cobertura, todavía sin panel ni resultados empíricos. **Lenguaje principal:** R. **Repositorio:** GitHub privado.

## Identidad científica

**Título provisional:** *Trayectorias subnacionales hacia un desarrollo bajo en carbono: un marco espacio-temporal reproducible aplicado a los municipios de Colombia*. Título inglés provisional: *Subnational pathways to low-carbon development: a reproducible spatiotemporal framework applied to Colombian municipalities*.

**Pregunta central:** ¿Por qué algunos municipios colombianos avanzan hacia un desarrollo de menor intensidad de carbono mientras otros permanecen en trayectorias intensivas en emisiones? La contribución buscada es un marco reproducible para identificar, explicar y mapear arquetipos subnacionales de transición, con Colombia como caso de estudio. Los resultados serán descriptivos y asociativos; no se atribuirán efectos causales.

**Objetivo general:** caracterizar las trayectorias municipales de emisiones de gases de efecto invernadero (GEI), estudiar su relación con actividad económica y estructura territorial, y evaluar si los patrones de desacoplamiento se organizan espacialmente.

**Objetivos específicos:**

1. Construir y auditar un panel municipio–año a partir de fuentes oficiales, con identidad territorial consistente.
2. Describir tendencias históricas, composición sectorial, emisiones por habitante y diferencias entre emisiones brutas y netas.
3. Definir de forma transparente el desacoplamiento entre actividad económica y emisiones, y estudiar trayectorias, puntos de cambio y arquetipos.
4. Evaluar dependencia espacial y asociaciones longitudinales con características municipales, distinguiendo resultados robustos de hallazgos exploratorios.
5. Publicar código, metadatos, decisiones y resultados reproducibles según las licencias y posibilidades de redistribución de cada fuente.

## Ventanas de trabajo y alcance

La ventana **1990–2024** está prevista para la historia de emisiones, composición, trayectorias y geografía. La ventana **2011–2024** está prevista para actividad económica municipal, intensidad de carbono, desacoplamiento y modelos explicativos. Ambas son **hipótesis operativas sujetas a verificación** de cobertura, nivel municipal, unidades, revisiones y posibilidad de extracción. Una serie inclusiva 1990–2024 contiene 35 años calendario; la expresión histórica «34 años» no se usará como conteo definitivo sin aclarar la convención de la fuente.

Las emisiones **brutas** representan liberaciones antes de descontar absorciones. Las **netas** incorporan absorciones/sumideros y pueden ser cero o negativas. No son intercambiables: se definirá el denominador de cada tasa e indicador, se conservarán unidades y sectores originales, y no se aplicarán logaritmos ordinarios a valores netos no positivos. La conciliación entre sumas sectoriales y totales dependerá de la metodología oficial.

Este es un proyecto sobre inventarios de GEI, no sobre exposición humana directa a contaminantes atmosféricos. Una asociación entre economía, territorio y emisiones no demuestra que una política o actividad haya causado el cambio. La interpretación de «transición» y «éxito» requiere umbrales, ventanas temporales y pruebas de sensibilidad documentadas.

## Estructura de carpetas

```text
colombia-carbon-transitions/
├── README.md                 # brújula del proyecto y croquis de fases
├── .gitignore                # protege datos, secretos y resultados grandes
├── .gitattributes            # normaliza finales de línea de archivos de texto
├── .Rprofile / renv.lock     # activación y versiones del entorno R
├── DESCRIPTION              # dependencias directas del proyecto
├── _targets.R / _quarto.yml  # flujo mínimo e informes
├── docs/
│   ├── research_protocol.md  # pregunta, objetivos, alcance y puertas de avance
│   ├── methodology.md        # reglas analíticas y decisiones que deben fijarse
│   ├── decisions.md          # bitácora cronológica de decisiones
│   └── data_sources.md       # inventario de fuentes y estado de verificación
├── config/
│   ├── sources.yml           # registro preliminar de fuentes, sin credenciales
│   └── parameters.yml        # ventanas y opciones propuestas, no resultados
├── data/
│   ├── raw/                  # originales inmutables; nunca en Git
│   ├── interim/              # transformaciones temporales; nunca en Git
│   ├── processed/            # paneles derivados; nunca en Git
│   └── metadata/             # manifiesto, diccionarios y controles compartibles
├── R/
│   ├── download/             # adquisición futura, sin ejecución en Fase 0
│   ├── cleaning/             # limpieza y homologación de códigos
│   ├── features/             # indicadores derivados
│   ├── models/               # modelos longitudinales y tipologías
│   ├── spatial/              # geometrías y vecindad
│   └── figures/              # gráficos y mapas regenerables
├── analysis/                 # informe técnico 00 y análisis futuros
├── outputs/
│   ├── figures/              # figuras generadas
│   ├── tables/               # tablas generadas
│   └── models/               # objetos de modelos generados
└── manuscript/               # borrador del artículo y material suplementario
```

Las carpetas vacías tienen `.gitkeep` para que Git conserve la estructura. Los archivos `data/raw`, `data/interim` y `data/processed` quedan fuera de Git. `data/metadata/manifest_template.csv` es la plantilla y `data/metadata/manifest.csv` registra los archivos obtenidos en Fase 1. Los controles pequeños de auditoría se versionan, pero los originales y resultados pesados no. Las notas personales del equipo en `notes/` también quedan fuera de Git.

Ya existen `renv.lock`, `_targets.R` y `analysis/00_environment.qmd`: registran las versiones realmente instaladas y prueban el entorno sin usar datos de investigación. `renv` aísla dependencias, `targets` valida los parámetros iniciales y Quarto genera un informe técnico. Los informes analíticos se añadirán en fases posteriores. La regla será que **cada tabla, figura y cifra del artículo se regenere desde código**, sin transcripción manual.

## Croquis de las nueve fases (0–8)

Cada fase termina cuando su **puerta de avance** queda comprobada y registrada en `docs/decisions.md`. Los nombres y métodos son un protocolo inicial. **Las Fases 0, 1 y 2 están autorizadas. La Fase 3 no ha comenzado.**

| Fase | Trabajo y entregable | Puerta de avance |
|---|---|---|
| **0. Infraestructura y protocolo** | Carpeta, Git local, README, documentación, plantillas, reglas de seguridad; remoto privado solo con acceso comprobado. | Estructura revisada, estado Git limpio si hay commit, y pendientes documentados. |
| **1. Acceso y auditoría de fuentes** | Verificar extracción municipal IDEAM/INGEI, VAM y población DANE, DIVIPOLA/MGN; registrar licencias, cobertura, archivos y SHA-256. | Se puede obtener de forma reproducible una tabla municipal de emisiones 1990–2024, o se documenta la brecha y alternativa antes de avanzar. |
| **2. Universo municipal** | Tabla maestra de códigos DIVIPOLA, cambios históricos, áreas no municipalizadas y geometrías. | Población analítica y pérdidas por fuente cuantificadas; uniones por códigos, nunca por nombres. |
| **3. Panel núcleo y calidad** | Panel municipio–año, indicadores brutos/netos, población, valor agregado, reporte de calidad. | Sin duplicados de clave; unidades y agregados conciliados o discrepancias explicadas. |
| **4. Descripción y visualización** | Series, distribuciones, sectores, mapas, concentración territorial y anomalías. | Figuras regenerables y hallazgos descriptivos revisados antes de modelar. |
| **5. Definición de transición** | Reglas de desacoplamiento absoluto/relativo, ventanas plurianuales y tratamiento de 2020. | Definiciones ancladas en literatura y sensibilidad; ningún umbral escogido por conveniencia visual. |
| **6. Trayectorias y arquetipos** | Puntos de cambio y agrupación por forma de trayectoria, separando nivel y forma. | Estabilidad, separación, interpretabilidad y sensibilidad documentadas; etiquetas posteriores a resultados. |
| **7. Geografía** | Vecindad Queen/Rook o alternativa justificada, Moran global/local y mapas. | Pesos, unidades sin vecinos y comparaciones de sensibilidad registrados. |
| **8. Explicación, robustez y publicación** | Variables adicionales seleccionadas a priori, modelo longitudinal de referencia, modelo espacial o jerárquico según datos, arquetipos finales, sensibilidad y manuscrito. | Asociaciones defendibles, incertidumbre y limitaciones transparentes, revisión de reproducibilidad y manuscrito listo para envío. |

La Fase 8 agrupa los pasos posteriores de enriquecimiento, modelamiento, síntesis, robustez y escritura del borrador maestro. No implica que se haya elegido ya un modelo. Se comparará un modelo con efectos municipales y anuales con una opción espacial o jerárquica si la estructura observada lo justifica. Se revisarán resultados con emisiones brutas/netas, distintas ventanas de desacoplamiento, definiciones espaciales, pandemia y municipios extremos. Se mantendrán fuera del núcleo variables accesorias que no aporten a la pregunta.

## Datos y reproducibilidad

Las cuatro fuentes núcleo son IDEAM/INGEI (emisiones), DANE VAM (actividad económica), DANE población y DANE DIVIPOLA/MGN (códigos; aún faltan las geometrías). Bosque/uso del suelo, minería ANM y TerriData son candidatos posteriores. El usuario aportó un ZIP de IDEAM cuyos bytes quedaron registrados. El enlace de OneDrive identifica una carpeta y aún no permite reproducir la descarga individual. La [auditoría de Fase 1](docs/phase1_data_audit.md) explica cobertura y discrepancias entre fuentes.

Cada archivo original que se incorpore en Fase 1 tendrá un registro con `source`, `official_url`, `retrieval_date`, `original_filename`, `file_size_bytes`, `sha256`, `coverage`, `geographic_level`, `time_period`, `license` y `notes`. El SHA-256 se calcula sobre los **bytes originales** y se vuelve a comprobar antes del procesamiento. El manifiesto no almacena secretos ni datos restringidos. Los originales se guardan inmutables; cualquier corrección queda en `interim` o se produce por código. Cambios de metodología o reemplazos silenciosos de archivos originan nuevos registros y decisiones.

Git guardará código, textos, configuración no secreta y metadatos pequeños; no bases crudas ni productos voluminosos. El repositorio en GitHub será **privado**, con acceso del equipo según su decisión. La publicación internacional exige una historia clara: comparación municipal transferible, métodos y código verificables, visualizaciones legibles, definiciones honestas, robustez y materiales suplementarios. Se elegirá revista y licencia del código más adelante, tras revisar alcance, normas editoriales y derechos de los datos; no se promete una cantidad de citas. La visibilidad se buscará con título y resumen claros, identificadores persistentes permitidos, documentación bilingüe del manuscrito cuando corresponda y un paquete reproducible que otros investigadores puedan citar.

## Cómo comprobar el entorno

En RStudio, abrir el proyecto y ejecutar `renv::status()` y `targets::tar_make()` desde su raíz. El flujo inicial solo lee `config/parameters.yml` y valida las ventanas; sus salidas permanecen fuera de Git. Para el informe técnico, ejecutar `quarto render analysis/00_environment.qmd` desde una terminal que encuentre R y Quarto, o usar **Render** en RStudio. En esta máquina, ambos ejecutables funcionan por sus rutas instaladas aunque no estén en el `PATH` general.

## Estado del proyecto

La Fase 0 estableció el entorno y el repositorio privado. La Fase 1 obtuvo y auditó los archivos núcleo. La Fase 2 comparó códigos, tipos de territorio y denominadores por año. El [informe territorial](docs/phase2_territory.md) explica las diferencias históricas y la muestra provisional. Consultar `docs/decisions.md` para decisiones y pendientes. **No se ha iniciado la Fase 3 ni se ha construido el panel.**
