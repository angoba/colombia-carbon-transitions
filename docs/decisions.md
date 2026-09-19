# Bitácora de decisiones

## 2026-09-19 — Fase 0

- Proyecto: `colombia-carbon-transitions`; R es el lenguaje principal.
- Se autorizó únicamente la Fase 0. Los datos y la Fase 1 quedan pendientes de autorización posterior.
- El repositorio remoto debe ser privado. La autenticación de `gh` para `angoba` fue restablecida. Se creó `angoba/colombia-carbon-transitions`, se vinculó `origin`, se subió `main` y GitHub confirmó visibilidad `PRIVATE`.
- La identidad Git global muestra un nombre, pero el correo `TU_DIRECCION_NOREPLY` es un marcador de posición. Se configuró para este repositorio `111400391+angoba@users.noreply.github.com` y se creó el commit inicial `9e9459d`.
- R 4.6.1 sí está instalado en `C:\Program Files\R\R-4.6.1` y Quarto 1.9.38 está incluido en RStudio. Esta sesión no los expone en `PATH`; ambos funcionan por ruta completa. `renv` y `targets` aún no están instalados, así que no se genera un `renv.lock` ficticio ni se declara operativo el pipeline.
- Se eligió registrar fuentes y hashes SHA-256 de archivos futuros, sin incorporar bases al repositorio.
- La ubicación solicitada es `C:\research\colombia-carbon-transitions`; comprobar la creación efectiva y permisos antes de marcar la estructura como instalada.

## Pendientes de la Fase 0

- Primer commit local completado con la dirección noreply proporcionada.
- Usar las rutas verificadas de R y Quarto; instalar/validar `renv` y `targets` y generar un lock real cuando las dependencias estén resueltas.
- Repositorio privado creado y verificado; comprobar su visibilidad después de cualquier cambio futuro de configuración.
- Decidir licencia de código, forma de citar y autoría antes de crear `LICENSE` o `CITATION.cff` con datos definitivos.

## Plantilla para decisiones futuras

**Fecha / fase / decisión / alternativas consideradas / evidencia / consecuencia / responsable.**
