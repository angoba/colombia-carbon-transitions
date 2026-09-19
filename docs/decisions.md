# Bitácora de decisiones

## 2026-09-19 — Fase 0

- Proyecto: `colombia-carbon-transitions`; R es el lenguaje principal.
- Se autorizó únicamente la Fase 0. Los datos y la Fase 1 quedan pendientes de autorización posterior.
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
