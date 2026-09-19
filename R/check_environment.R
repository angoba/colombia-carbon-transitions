# Fase 0: diagnóstico local sin descargar datos ni instalar paquetes.
cat("R:", R.version.string, "\n")
cat("Directorio:", normalizePath(getwd(), winslash = "/"), "\n")
for (package in c("renv", "targets")) {
  installed <- requireNamespace(package, quietly = TRUE)
  cat(package, if (installed) as.character(packageVersion(package)) else "no instalado", "\n")
}
quarto <- Sys.which("quarto")
cat("Quarto:", if (nzchar(quarto)) quarto else "no disponible", "\n")
