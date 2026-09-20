# Archivos pequeños que DANE publica para las series del proyecto.
# Los originales se guardan tal como llegan.

files <- data.frame(
  name = c(
    "anex-PIBDep-ValorAgreMuni-2011-2024p.xlsx",
    "PPED-AreaMun-2018-2042_VP.xlsx",
    "DCD-area-proypoblacion-Mun-2005-2017_VP.xlsx",
    "DCD-area-proypoblacion-Mun-1995-2004.xlsx",
    "DCD-area-proypoblacion-Mun-1985-1994.xlsx",
    "divipola_municipios_2025.json"
  ),
  url = c(
    "https://www.dane.gov.co/files/operaciones/PIB/anex-PIBDep-ValorAgreMuni-2011-2024p.xlsx",
    "https://www.dane.gov.co/files/censo2018/proyecciones-de-poblacion/Municipal/PPED-AreaMun-2018-2042_VP.xlsx",
    "https://www.dane.gov.co/files/censo2018/proyecciones-de-poblacion/Municipal/DCD-area-proypoblacion-Mun-2005-2017_VP.xlsx",
    "https://www.dane.gov.co/files/censo2018/proyecciones-de-poblacion/Municipal/DCD-area-proypoblacion-Mun-1995-2004.xlsx",
    "https://www.dane.gov.co/files/censo2018/proyecciones-de-poblacion/Municipal/DCD-area-proypoblacion-Mun-1985-1994.xlsx",
    "https://geoportal.dane.gov.co/mparcgis/rest/services/Divipola/Serv_DIVIPOLA_MGN_2025/FeatureServer/317/query?where=1%3D1&outFields=DPTO_CCDGO%2CMPIO_CCDGO%2CMPIO_CDPMP%2CMPIO_CNMBRE%2CMPIO_TIPO&returnGeometry=false&f=json"
  ),
  period = c("2011-2024", "2018-2042", "2005-2017", "1995-2004", "1985-1994", "2025")
)

dir.create("data/raw/dane", recursive = TRUE, showWarnings = FALSE)
manifest_path <- "data/metadata/manifest.csv"

for (i in seq_len(nrow(files))) {
  name <- files$name[i]
  path <- file.path("data/raw/dane", name)

  if (file.exists(path) && file.exists(manifest_path)) {
    old <- utils::read.csv(manifest_path)
    saved <- old[old$original_filename == name, ]
    if (nrow(saved) == 1 &&
        identical(saved$sha256, digest::digest(path, algo = "sha256", file = TRUE))) {
      cat("Ya estaba verificado:", name, "\n")
      next
    }
    if (nrow(saved) > 0) stop("El archivo cambió respecto al manifiesto: ", name)
  }

  if (!file.exists(path)) {
    temp <- paste0(path, ".part")
    if (file.exists(temp)) stop("Hay una descarga incompleta: ", temp)
    status <- utils::download.file(files$url[i], temp, mode = "wb", method = "libcurl", quiet = TRUE)
    if (status != 0 || file.info(temp)$size > 50e6) stop("Revisar la descarga de ", name)
    if (!file.rename(temp, path)) stop("No se pudo guardar ", name)
  }

  record <- data.frame(
    source = "DANE",
    official_url = files$url[i],
    retrieval_date = format(Sys.time(), tz = "UTC", usetz = TRUE),
    original_filename = name,
    file_size_bytes = file.info(path)$size,
    sha256 = digest::digest(path, algo = "sha256", file = TRUE),
    coverage = files$period[i],
    geographic_level = "municipio",
    time_period = files$period[i],
    license = "pendiente_de_verificar",
    notes = "Archivo original. No subir a Git."
  )

  old <- if (file.exists(manifest_path)) utils::read.csv(manifest_path) else record[0, ]
  old <- old[old$original_filename != name, ]
  utils::write.csv(rbind(old, record), manifest_path, row.names = FALSE, na = "")
  cat("Guardado y verificado:", name, "\n")
}
