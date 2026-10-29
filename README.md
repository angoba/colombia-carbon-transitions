# Transiciones de carbono en municipios de Colombia

## Identidad científica

**Título provisional:** *Trayectorias subnacionales hacia un desarrollo bajo en carbono: un marco espacio-temporal reproducible aplicado a los municipios de Colombia*. .

**Pregunta central:** ¿Por qué algunos municipios colombianos avanzan hacia un desarrollo de menor intensidad de carbono mientras otros permanecen en trayectorias intensivas en emisiones? La contribución buscada es un marco reproducible para identificar, explicar y mapear arquetipos subnacionales de transición, con Colombia como caso de estudio. Los resultados serán descriptivos y asociativos; no se atribuirán efectos causales.

**Objetivo general:** caracterizar las trayectorias municipales de emisiones de gases de efecto invernadero (GEI), estudiar su relación con actividad económica y estructura territorial, y evaluar si los patrones de desacoplamiento se organizan espacialmente.

**Objetivos específicos:**

1. Construir y auditar un panel municipio–año a partir de fuentes oficiales, con identidad territorial consistente.
2. Describir tendencias históricas, composición sectorial, emisiones por habitante y diferencias entre emisiones brutas y netas.
3. Definir de forma transparente el desacoplamiento entre actividad económica y emisiones, y estudiar trayectorias, puntos de cambio y arquetipos.
4. Evaluar dependencia espacial y asociaciones longitudinales con características municipales, distinguiendo resultados robustos de hallazgos exploratorios.
5. Publicar código, metadatos, decisiones y resultados reproducibles según las licencias y posibilidades de redistribución de cada fuente.

## Ventanas de trabajo y alcance

La ventana **1990–2024** quedó comprobada para las emisiones de 1.122 unidades territoriales y contiene 35 años calendario. La ventana **2011–2024** quedó comprobada para el valor agregado municipal a precios corrientes. La compatibilidad de códigos y denominadores varía por año, como muestra el [control del panel](docs/phase3_quality.md). La expresión histórica «34 años» de la fuente no se usa aquí como conteo de años calendario. La intensidad económica real y el desacoplamiento siguen pendientes de una decisión sobre precios comparables.

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
│   ├── download/             # adquisición y registro de fuentes
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

Cada fase termina cuando su **puerta de avance** queda comprobada y registrada en `docs/decisions.md`. Los nombres y métodos son un protocolo inicial. **Las Fases 0 a 4 están autorizadas. La Fase 4 está en curso.**

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


## Cómo comprobar el entorno

En RStudio, abrir el proyecto y ejecutar `renv::status()` y `targets::tar_make()` desde su raíz. El flujo inicial solo lee `config/parameters.yml` y valida las ventanas; sus salidas permanecen fuera de Git. Para el informe técnico, ejecutar `quarto render analysis/00_environment.qmd` desde una terminal que encuentre R y Quarto, o usar **Render** en RStudio. En esta máquina, ambos ejecutables funcionan por sus rutas instaladas aunque no estén en el `PATH` general.

