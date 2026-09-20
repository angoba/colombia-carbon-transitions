# Bitácora de decisiones

## 2026-09-19 — Fase 0

- Proyecto: `colombia-carbon-transitions`; R es el lenguaje principal.
- Primero se autorizó únicamente la Fase 0. La Fase 1 recibió autorización posterior.
- El repositorio remoto debe ser privado. La autenticación de `gh` para `angoba` fue restablecida. Se creó `angoba/colombia-carbon-transitions`, se vinculó `origin`, se subió `main` y GitHub confirmó visibilidad `PRIVATE`.
- La identidad Git global muestra un nombre, pero el correo `TU_DIRECCION_NOREPLY` es un marcador de posición. Se configuró para este repositorio `111400391+angoba@users.noreply.github.com` y se creó el commit inicial `9e9459d`.
- R 4.6.1 sí está instalado en `C:\Program Files\R\R-4.6.1` y Quarto 1.9.38 está incluido en RStudio. Esta sesión no los expone en `PATH`; ambos funcionan por ruta completa. `renv` 1.2.4 y `targets` 1.12.0 ya están instalados. Se creó un `renv.lock` real con R 4.6.1 y las dependencias directas y transitivas del proyecto; `renv::status()` no reportó problemas. `targets` validó las ventanas y Quarto 1.9.38 renderizó el informe técnico.
- Se eligió registrar fuentes y hashes SHA-256 de archivos futuros, sin incorporar bases al repositorio.
- La estructura quedó instalada en `C:\research\colombia-carbon-transitions`.

## Comprobaciones completadas y decisiones posteriores

- Primer commit local completado con la dirección noreply proporcionada.
- Entorno R, pipeline e informe técnico validados. Las dependencias analíticas nuevas se instalarán y fijarán cuando se autoricen fases posteriores.
- Repositorio privado creado y verificado; comprobar su visibilidad después de cualquier cambio futuro de configuración.
- Decidir licencia de código, forma de citar y autoría antes de crear `LICENSE` o `CITATION.cff` con datos definitivos.

## Plantilla para decisiones futuras

**Fecha / fase / decisión / alternativas consideradas / evidencia / consecuencia / responsable.**

## 2026-09-20 — Fase 2

- El usuario aprobó construir la tabla territorial, comparar códigos y medir pérdidas por año. Los originales permanecen intactos.
- Se conservan los 1.122 códigos IDEAM como universo de referencia de emisiones. DIVIPOLA 2025 los clasifica en 1.103 municipios, 18 áreas no municipalizadas y una isla. Su clasificación de 2025 no se extrapola automáticamente a 1990.
- Mapiripana (`94663`) está en los libros DANE, pero no en IDEAM ni en la consulta DIVIPOLA 2025. DANE documentó su relación con la creación de Barrancominas. No se suman las dos claves sin comprobar las reglas temporales de cada serie.
- Nuevo Belén de Bajirá (`27493`) se incorporó a DIVIPOLA en 2024. IDEAM registra valores anteriores; población y valor agregado DANE no ofrecen denominadores positivos anteriores a 2024 para ese código. Barrancominas también aparece retrospectivamente en IDEAM. No se reasignan emisiones ni se interpretan esos registros como límites constantes hasta verificar el método específico.
- Se encontraron 564 pares código–año con población cero en la ventana 1990–2024 y 13 años de valor agregado cero para `27493` entre 2011 y 2023. Ningún cero será usado como denominador.
- La Fase 2 deja una tabla maestra, las diferencias por año, excepciones y un control de los dos códigos IDEAM históricos en `data/metadata/`. La capa de polígonos 2025 y un servicio 2018 están localizados; su geometría y topología siguen sin descargar y verificar. El informe completo está en `docs/phase2_territory.md`.
- La puerta de inventario territorial se cumple. La comparabilidad espacial histórica, las tasas y la construcción del panel quedan como condiciones para la Fase 3, aún no iniciada.

## 2026-09-20 — Fase 3

- El usuario aprobó el panel núcleo y los controles de calidad. Se construyó una fila por código IDEAM y año, 39.270 en total. Los originales permanecen intactos; el panel y el detalle por sector quedan fuera de Git.
- Se usó la distinción `CO2_ABS` para absorciones con signo. Las sumas nacional y sectorial de los 35 años concilian con el libro IDEAM. Los signos inusuales se registran, no se corrigen sin base metodológica.
- Se incluyeron población y VAM nominal de DANE por código y año. Los 28 faltantes de población y 564 ceros no generan tasas. Otros 30 pares anteriores a 2020 de Barrancominas quedan sin tasa por la asignación territorial histórica. Se marca Riosucio y Nuevo Belén de Bajirá para revisión de límites.
- En 1990, 5,69 % de las emisiones brutas corresponden a unidades sin población positiva. Para 2011–2024 el máximo anual de esa proporción es 0,015 %. La exclusión de áreas no municipalizadas y la isla y el peso de tres códigos ligados a cambios de límites están cuantificados por año.
- El VAM disponible está a precios corrientes. No se creó una serie municipal real ni indicadores de intensidad/desacoplamiento temporal. Elegir y justificar un ajuste de precios queda pendiente.
- La calidad y el diccionario se explican en `docs/phase3_quality.md` y `docs/phase3_dictionary.md`. Los saltos grandes se señalaron para revisión descriptiva, sin corrección automática. La Fase 4 no se ha iniciado.

## 2026-09-19 — Fase 1

- El usuario aprobó la Fase 1 y aportó un ZIP ya descargado desde IDEAM. Se movió a `data/raw/ideam/` y se extrajeron solamente la tabla GEI municipal, el consolidado nacional y una infografía. El enlace de la carpeta institucional no permitió una descarga directa sin iniciar sesión.
- Se descargaron los cinco libros DANE y una consulta de atributos DIVIPOLA. Los diez archivos conservados tienen tamaño y SHA-256 en `data/metadata/manifest.csv`. Las licencias siguen por verificar.
- La serie GEI tiene cobertura de 1.122 códigos por año entre 1990 y 2024. Los registros parciales de 1986–1989 quedan fuera del análisis principal. La suma nacional preliminar de 2024 coincide con las cifras divulgadas por IDEAM.
- Los códigos GEI coinciden con los de DIVIPOLA 2025, que incluye áreas no municipalizadas y una isla. DANE VAM y población reciente incluyen un código adicional; la población histórica también omite uno presente en GEI. Se resolverá el universo en Fase 2.
- El valor agregado DANE está a precios corrientes. El proyecto no calculará desacoplamiento temporal a partir de cambios nominales sin justificar el ajuste de precios.
- Se documenta la puerta de acceso y cobertura de Fase 1 en `docs/phase1_data_audit.md`. Continúan pendientes licencia, enlace directo IDEAM, homologación territorial y geometrías. La Fase 2 no se ha iniciado.

## 2026-09-20 — Fase 4

- El usuario aprobó la fase descriptiva. El protocolo y el estado para retomar el trabajo están en `docs/phase4_plan.md`.
- Se generaron primeras tablas y figuras con controles de integridad y conciliación. La fase continúa abierta y aún no hay conclusiones finales.
