# Revisa cobertura y columnas del archivo GEI sin calcular emisiones agregadas.

path <- "data/raw/ideam/Inventario_subnacional_GEI_V1_26062026.csv"
if (!file.exists(path)) stop("No se encuentra el archivo GEI")

columns <- c(
  "AÑO", "Codigo_Departamento", "Departamento", "Codigo_Municipio",
  "Municipio", "SECTOR_IPCC",
  "CONTAMINANTE", "Valor_CO2eq"
)

data <- data.table::fread(
  path,
  select = columns,
  colClasses = list(character = c("Codigo_Departamento", "Codigo_Municipio")),
  showProgress = TRUE
)
data.table::setnames(data, "AÑO", "year")

coverage <- data[
  , .(
    rows = .N,
    municipalities = data.table::uniqueN(Codigo_Municipio[!is.na(Codigo_Municipio)]),
    missing_municipality_rows = sum(is.na(Codigo_Municipio)),
    missing_value_rows = sum(is.na(Valor_CO2eq)),
    negative_value_rows = sum(Valor_CO2eq < 0, na.rm = TRUE)
  ),
  by = year
][order(year)]

categories <- data[, .N, by = .(SECTOR_IPCC, CONTAMINANTE)][order(SECTOR_IPCC, CONTAMINANTE)]
codes <- unique(data[!is.na(Codigo_Municipio), .(
  Codigo_Municipio, Municipio, Codigo_Departamento, Departamento
)])
early_years <- data[year < 1990, .N, by = .(year, SECTOR_IPCC, CONTAMINANTE)]

data.table::fwrite(coverage, "data/metadata/ideam_coverage.csv")
data.table::fwrite(categories, "data/metadata/ideam_categories.csv")
data.table::fwrite(codes, "data/metadata/ideam_codes.csv")
data.table::fwrite(early_years, "data/metadata/ideam_early_years.csv")

cat("Filas:", nrow(data), "\n")
cat("Municipios con código:", data.table::uniqueN(data$Codigo_Municipio[!is.na(data$Codigo_Municipio)]), "\n")
cat("Pares municipio-año:", data.table::uniqueN(data[!is.na(Codigo_Municipio)], by = c("year", "Codigo_Municipio")), "\n")
cat("Años:", min(data$year), "a", max(data$year), "\n")
cat("Sectores:", data.table::uniqueN(data$SECTOR_IPCC), "\n")
cat("Gases:", paste(sort(unique(data$CONTAMINANTE)), collapse = ", "), "\n")
