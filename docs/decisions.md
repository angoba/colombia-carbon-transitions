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

## 2026-09-19 — Fase 1

- El usuario aprobó la Fase 1 y aportó un ZIP ya descargado desde IDEAM. Se movió a `data/raw/ideam/` y se extrajeron solamente la tabla GEI municipal, el consolidado nacional y una infografía. El enlace de la carpeta institucional no permitió una descarga directa sin iniciar sesión.
- Se descargaron los cinco libros DANE y una consulta de atributos DIVIPOLA. Los diez archivos conservados tienen tamaño y SHA-256 en `data/metadata/manifest.csv`. Las licencias siguen por verificar.
- La serie GEI tiene cobertura de 1.122 códigos por año entre 1990 y 2024. Los registros parciales de 1986–1989 quedan fuera del análisis principal. La suma nacional preliminar de 2024 coincide con las cifras divulgadas por IDEAM.
- Los códigos GEI coinciden con los de DIVIPOLA 2025, que incluye áreas no municipalizadas y una isla. DANE VAM y población reciente incluyen un código adicional; la población histórica también omite uno presente en GEI. Se resolverá el universo en Fase 2.
- El valor agregado DANE está a precios corrientes. El proyecto no calculará desacoplamiento temporal a partir de cambios nominales sin justificar el ajuste de precios.
- Se documenta la puerta de acceso y cobertura de Fase 1 en `docs/phase1_data_audit.md`. Continúan pendientes licencia, enlace directo IDEAM, homologación territorial y geometrías. La Fase 2 no se ha iniciado.
