# Fase 0: diagnóstico local sin descargar datos ni instalar paquetes.
cat("R:", R.version.string, "\n")
cat("Directorio:", normalizePath(getwd(), winslash = "/"), "\n")
for (package in c("renv", "targets")) {
  installed <- requireNamespace(package, quietly = TRUE)
  cat(package, if (installed) as.character(packageVersion(package)) else "no instalado", "\n")
}
quarto <- Sys.which("quarto")
if (!nzchar(quarto) && .Platform$OS.type == "windows") {
  candidate <- "C:/Program Files/RStudio/resources/app/bin/quarto/bin/quarto.exe"
  if (file.exists(candidate)) quarto <- candidate
}
cat("Quarto:", if (nzchar(quarto)) quarto else "no disponible", "\n")
