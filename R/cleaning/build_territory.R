# Compara códigos y años sin tocar los archivos originales.

library(data.table)

raw <- "data/raw/dane"
metadata <- "data/metadata"
manifest <- fread(file.path(metadata, "manifest.csv"), colClasses = "character")

verify_file <- function(name, folder) {
  path <- file.path(folder, name)
  record <- manifest[original_filename == name]
  if (nrow(record) != 1L || !file.exists(path)) stop("Falta el archivo o su registro: ", name)
  if (as.numeric(file.info(path)$size) != as.numeric(record$file_size_bytes)) {
    stop("El tamaño cambió: ", name)
  }
  hash <- digest::digest(path, algo = "sha256", file = TRUE)
  if (tolower(hash) != tolower(record$sha256)) stop("El SHA-256 cambió: ", name)
  path
}

gei_path <- verify_file("Inventario_subnacional_GEI_V1_26062026.csv", "data/raw/ideam")
gei <- fread(gei_path, select = c("AÑO", "Codigo_Municipio"),
             colClasses = list(character = "Codigo_Municipio"), showProgress = FALSE)
setnames(gei, c("AÑO", "Codigo_Municipio"), c("year", "code"))
gei <- unique(gei[year >= 1990L & year <= 2024L, .(year, code)])
if (nrow(gei) != 1122L * 35L || anyNA(gei)) stop("Cambió la cobertura GEI")
gei_codes <- unique(gei$code)
rm(gei_path)

div_path <- verify_file("divipola_municipios_2025.json", raw)
div_json <- jsonlite::fromJSON(div_path)
if (!is.null(div_json$error)) stop("La respuesta DIVIPOLA contiene un error")
div <- as.data.table(div_json$features$attributes)
div <- div[, .(code = as.character(MPIO_CDPMP), name = MPIO_CNMBRE,
               type = MPIO_TIPO, department_code = DPTO_CCDGO)]
if (nrow(div) != 1122L || anyDuplicated(div$code) || !setequal(div$code, gei_codes)) {
  stop("Cambió el marco DIVIPOLA respecto a IDEAM")
}

read_population <- function(name, sheet, skip, code_column, years) {
  path <- verify_file(name, raw)
  tab <- readxl::read_excel(path, sheet = sheet, skip = skip, col_names = FALSE,
                           .name_repair = "minimal", progress = FALSE)
  tab <- as.data.table(tab)
  result <- data.table(
    code = as.character(tab[[code_column]]),
    year = suppressWarnings(as.integer(tab[[5L]])),
    area = as.character(tab[[6L]]),
    population = suppressWarnings(as.numeric(tab[[7L]])),
    source_file = name
  )
  result <- result[grepl("^[0-9]{5}$", code) & year %in% years & area == "Total"]
  if (anyDuplicated(result, by = c("code", "year")) || anyNA(result$population)) {
    stop("Revisar claves o valores de población en ", name)
  }
  if (!setequal(unique(result$year), years)) stop("Faltan años en ", name)
  result[, area := NULL]
  result
}

population <- rbindlist(list(
  read_population("DCD-area-proypoblacion-Mun-1985-1994.xlsx", "Municipal", 12L, 3L, 1990:1994),
  read_population("DCD-area-proypoblacion-Mun-1995-2004.xlsx", "Municipal", 12L, 3L, 1995:2004),
  read_population("DCD-area-proypoblacion-Mun-2005-2017_VP.xlsx", "NuevaMpal", 12L, 4L, 2005:2017),
  read_population("PPED-AreaMun-2018-2042_VP.xlsx", 3L, 8L, 3L, 2018:2024)
))
if (anyDuplicated(population, by = c("code", "year"))) stop("Población duplicada entre libros")

vam_name <- "anex-PIBDep-ValorAgreMuni-2011-2024p.xlsx"
vam_path <- verify_file(vam_name, raw)
vam_sheet <- as.data.table(readxl::read_excel(
  vam_path, sheet = "Cuadro 1", skip = 11L, col_names = FALSE,
  .name_repair = "minimal", progress = FALSE
))
vam_codes <- as.character(vam_sheet[[1L]])
vam_names <- as.character(vam_sheet[[2L]])
valid <- grepl("^[0-9]{5}$", vam_codes)
vam <- rbindlist(lapply(2011:2024, function(year) {
  data.table(code = vam_codes[valid], year = year,
             value = suppressWarnings(as.numeric(vam_sheet[[year - 2006L]][valid])))
}))
if (anyDuplicated(vam, by = c("code", "year")) || anyNA(vam$value)) {
  stop("Revisar claves o valores de valor agregado")
}

all_codes <- sort(unique(c(gei_codes, population$code, vam$code, div$code)))
master <- data.table(code = all_codes)
master <- merge(master, div, by = "code", all.x = TRUE, sort = FALSE)
extra_names <- unique(data.table(code = vam_codes[valid], name_vam = vam_names[valid]))
if (anyDuplicated(extra_names$code)) stop("Nombres VAM inconsistentes")
master <- merge(master, extra_names, by = "code", all.x = TRUE, sort = FALSE)
master[is.na(name), name := name_vam]
master[is.na(department_code), department_code := substr(code, 1L, 2L)]
setnames(master, "type", "type_divipola_2025")
positive_pop <- population[population > 0, .(population_positive_years = .N,
                                            first_positive_year = min(year)), by = code]
positive_vam <- vam[value > 0, .(vam_positive_years = .N), by = code]
master <- merge(master, positive_pop, by = "code", all.x = TRUE, sort = FALSE)
master <- merge(master, positive_vam, by = "code", all.x = TRUE, sort = FALSE)
master[is.na(population_positive_years), population_positive_years := 0L]
master[is.na(vam_positive_years), vam_positive_years := 0L]
master[, `:=`(
  in_ideam = code %in% gei_codes,
  in_divipola_2025 = !is.na(type_divipola_2025),
  in_vam = code %in% vam$code,
  in_population_1990_2017 = code %in% population[year < 2018L, code],
  in_population_2018_2024 = code %in% population[year >= 2018L, code]
)]
setorder(master, code)
if (anyDuplicated(master$code)) stop("Código duplicado en tabla maestra")

join_year <- function(yr) {
  g <- gei[year == yr, code]
  p <- population[year == yr]
  v <- vam[year == yr]
  with_pop <- intersect(g, p$code)
  with_positive_pop <- intersect(g, p[population > 0, code])
  municipalities <- div[type == "MUNICIPIO", code]
  data.table(
    year = yr,
    ideam_codes = length(g),
    population_codes = nrow(p),
    ideam_with_population = length(with_pop),
    ideam_with_positive_population = length(with_positive_pop),
    missing_population_codes = paste(setdiff(g, p$code), collapse = "|"),
    zero_population_codes = paste(intersect(g, p[population == 0, code]), collapse = "|"),
    vam_codes = if (yr >= 2011L) nrow(v) else NA_integer_,
    ideam_with_vam = if (yr >= 2011L) length(intersect(g, v$code)) else NA_integer_,
    ideam_with_positive_vam = if (yr >= 2011L) length(intersect(g, v[value > 0, code])) else NA_integer_,
    ideam_with_both = if (yr >= 2011L) length(intersect(with_pop, v$code)) else NA_integer_,
    ideam_with_both_positive = if (yr >= 2011L)
      length(Reduce(intersect, list(with_positive_pop, v[value > 0, code]))) else NA_integer_,
    ideam_municipios_2025 = length(intersect(g, municipalities)),
    municipios_2025_with_positive_population = length(intersect(with_positive_pop, municipalities)),
    municipios_2025_with_both_positive = if (yr >= 2011L)
      length(Reduce(intersect, list(with_positive_pop, v[value > 0, code], municipalities))) else NA_integer_
  )
}
coverage <- rbindlist(lapply(1990:2024, join_year))
exceptions <- unique(rbindlist(list(
  population[code %in% gei_codes & population == 0,
             .(code, year, issue = "poblacion_cero", source_file)],
  population[!code %in% gei_codes,
             .(code, year, issue = "sin_ideam", source_file)],
  vam[code %in% gei_codes & value == 0,
      .(code, year, issue = "vam_cero", source_file = vam_name)],
  vam[!code %in% gei_codes,
      .(code, year, issue = "sin_ideam", source_file = vam_name)]
)))
setorder(exceptions, code, year, issue)

fwrite(master, file.path(metadata, "territorial_master.csv"))
fwrite(coverage, file.path(metadata, "territorial_join_coverage.csv"))
fwrite(exceptions, file.path(metadata, "territorial_exceptions.csv"))
cat("Códigos en tabla maestra:", nrow(master), "\n")
print(master[, .N, by = type_divipola_2025][order(type_divipola_2025)])
print(coverage[year %in% c(1990L, 2011L, 2018L, 2020L, 2024L),
               .(year, ideam_with_population, ideam_with_positive_population,
                 ideam_with_both, ideam_with_both_positive)])
print(exceptions[, .N, by = issue])
cat("Códigos IDEAM con población positiva en los 35 años:",
    master[in_ideam & population_positive_years == 35L, .N], "\n")
