# Arma el panel sin cambiar los archivos originales.

library(data.table)

manifest <- fread("data/metadata/manifest.csv", colClasses = "character")
verify_file <- function(name, folder) {
  path <- file.path(folder, name)
  item <- manifest[original_filename == name]
  if (nrow(item) != 1L || !file.exists(path)) stop("Falta el archivo: ", name)
  if (file.info(path)$size != as.numeric(item$file_size_bytes)) stop("Cambió el tamaño: ", name)
  if (tolower(digest::digest(path, algo = "sha256", file = TRUE)) != tolower(item$sha256)) {
    stop("Cambió el SHA-256: ", name)
  }
  path
}

ideam_path <- verify_file("Inventario_subnacional_GEI_V1_26062026.csv", "data/raw/ideam")
national_path <- verify_file("Tabla_COMPILADO_NACIONAL_GEI_FINAL (1).xlsx", "data/raw/ideam")
raw <- fread(ideam_path,
             select = c("AÑO", "Codigo_Municipio", "SECTOR_IPCC", "CONTAMINANTE", "Valor_CO2eq"),
             colClasses = list(character = "Codigo_Municipio"), showProgress = FALSE)
setnames(raw, c("AÑO", "Codigo_Municipio", "SECTOR_IPCC", "CONTAMINANTE", "Valor_CO2eq"),
         c("year", "code", "sector", "gas", "value"))
raw <- raw[year %in% 1990:2024]
if (anyNA(raw[, .(year, code, sector, gas, value)])) stop("Filas GEI con claves o valores ausentes")
if (any(!grepl("^[0-9]{5}$", raw$code))) stop("Código IDEAM inesperado")

signs <- raw[, .(rows = .N, negative_rows = sum(value < 0),
                 positive_rows = sum(value > 0)), by = gas][order(gas)]
if (signs[gas == "CO2_ABS", .N] != 1L) stop("No se encontró CO2_ABS")
unusual_signs <- raw[(gas == "CH4" & value < 0) | (gas == "CO2_ABS" & value > 0),
                     .(rows = .N, value_sum_kt = sum(value)), by = .(gas, sector)]

sector <- raw[, .(
  gross_kt = sum(value[gas != "CO2_ABS"]),
  removals_kt = sum(value[gas == "CO2_ABS"]),
  source_rows = .N
), by = .(code, year, sector)]
sector[, net_kt := gross_kt + removals_kt]
gei <- sector[, .(gross_kt = sum(gross_kt), removals_kt = sum(removals_kt),
                  net_kt = sum(net_kt), source_rows = sum(source_rows)),
              by = .(code, year)]
setkey(gei, code, year)
if (nrow(gei) != 1122L * 35L || anyDuplicated(gei, by = c("code", "year"))) {
  stop("Cobertura GEI inesperada")
}
dir.create("data/interim", recursive = TRUE, showWarnings = FALSE)
fwrite(sector, "data/interim/gei_sector_year.csv")
rm(raw)
gc(FALSE)

national_book <- as.data.table(readxl::read_excel(
  national_path, sheet = "Inventario_GEI", skip = 6L, .name_repair = "unique", progress = FALSE
))
setnames(national_book, names(national_book)[c(1L, 2L, 45L, 46L, 47L)],
         c("year", "classification", "gross_reference", "removals_reference", "net_reference"))
national <- national_book[classification == "Nacional", .(
  year = as.integer(year), gross_reference = as.numeric(gross_reference),
  removals_reference = as.numeric(removals_reference),
  net_reference = as.numeric(net_reference)
)]
if (nrow(national) != 35L || anyDuplicated(national$year) ||
    !setequal(national$year, 1990:2024)) stop("Revisar totales nacionales IDEAM")
national_sum <- gei[, .(gross_kt = sum(gross_kt), removals_kt = sum(removals_kt),
                        net_kt = sum(net_kt)), by = year]
national_check <- merge(national_sum, national, by = "year")
for (measure in c("gross", "removals", "net")) {
  national_check[, paste0(measure, "_difference_kt") :=
                   get(paste0(measure, "_kt")) - get(paste0(measure, "_reference"))]
}
if (max(abs(unlist(national_check[, .(gross_difference_kt,
                                        removals_difference_kt, net_difference_kt)]))) > 1e-5) {
  stop("Los totales municipales no concilian con el libro nacional")
}

sector[, sector_id := substr(sector, 1L, 1L)]
sector_reference <- national_book[grepl("^[1-5][.] ", classification), .(
  year = as.integer(year), sector_id = substr(classification, 1L, 1L),
  gross_reference = as.numeric(gross_reference),
  removals_reference = as.numeric(removals_reference),
  net_reference = as.numeric(net_reference)
)]
sector_sum <- sector[, .(gross_kt = sum(gross_kt),
                         removals_kt = sum(removals_kt), net_kt = sum(net_kt)),
                     by = .(year, sector_id, sector)]
sector_check <- merge(sector_sum, sector_reference, by = c("year", "sector_id"))
if (nrow(sector_check) != 35L * 5L) stop("Faltan sectores en el consolidado IDEAM")
for (measure in c("gross", "removals", "net")) {
  sector_check[, paste0(measure, "_difference_kt") :=
                 get(paste0(measure, "_kt")) - get(paste0(measure, "_reference"))]
}
if (max(abs(unlist(sector_check[, .(gross_difference_kt,
                                      removals_difference_kt, net_difference_kt)]))) > 1e-5) {
  stop("Los sectores no concilian con el libro nacional")
}
rm(national_book, sector)

read_population <- function(name, sheet, skip, code_column, years) {
  path <- verify_file(name, "data/raw/dane")
  book <- as.data.table(readxl::read_excel(path, sheet = sheet, skip = skip,
                                          col_names = FALSE, .name_repair = "minimal",
                                          progress = FALSE))
  out <- data.table(code = as.character(book[[code_column]]),
                    year = suppressWarnings(as.integer(book[[5L]])),
                    area = as.character(book[[6L]]),
                    population = suppressWarnings(as.numeric(book[[7L]])))
  out <- out[grepl("^[0-9]{5}$", code) & year %in% years & area == "Total",
             .(code, year, population)]
  if (anyDuplicated(out, by = c("code", "year")) || anyNA(out$population)) {
    stop("Población duplicada o ausente en ", name)
  }
  out
}

population <- rbindlist(list(
  read_population("DCD-area-proypoblacion-Mun-1985-1994.xlsx", "Municipal", 12L, 3L, 1990:1994),
  read_population("DCD-area-proypoblacion-Mun-1995-2004.xlsx", "Municipal", 12L, 3L, 1995:2004),
  read_population("DCD-area-proypoblacion-Mun-2005-2017_VP.xlsx", "NuevaMpal", 12L, 4L, 2005:2017),
  read_population("PPED-AreaMun-2018-2042_VP.xlsx", 3L, 8L, 3L, 2018:2024)
))
if (anyDuplicated(population, by = c("code", "year"))) stop("Población duplicada entre libros")
if (any(population$population < 0)) stop("Población negativa")

vam_path <- verify_file("anex-PIBDep-ValorAgreMuni-2011-2024p.xlsx", "data/raw/dane")
vam_book <- as.data.table(readxl::read_excel(vam_path, sheet = "Cuadro 1",
                                            skip = 11L, col_names = FALSE,
                                            .name_repair = "minimal", progress = FALSE))
vam_codes <- as.character(vam_book[[1L]])
valid <- grepl("^[0-9]{5}$", vam_codes)
vam <- rbindlist(lapply(2011:2024, function(yr) {
  data.table(code = vam_codes[valid], year = yr,
             vam_nominal_billion_cop = suppressWarnings(as.numeric(vam_book[[yr - 2006L]][valid])))
}))
if (anyDuplicated(vam, by = c("code", "year")) || anyNA(vam$vam_nominal_billion_cop)) {
  stop("Valor agregado duplicado o ausente")
}
if (any(vam$vam_nominal_billion_cop < 0)) stop("Valor agregado negativo")
rm(vam_book)

master <- fread("data/metadata/territorial_master.csv",
                colClasses = list(character = c("code", "department_code")))
if (nrow(master) != 1123L || anyDuplicated(master$code)) stop("Revisar tabla territorial")
if (any(nchar(master$department_code) != 2L)) stop("Código departamental sin ceros iniciales")
panel <- merge(gei, population, by = c("code", "year"), all.x = TRUE)
panel <- merge(panel, vam, by = c("code", "year"), all.x = TRUE)
panel <- merge(panel, master[, .(code, name, department_code, type_divipola_2025)],
               by = "code", all.x = TRUE)
if (nrow(panel) != 1122L * 35L || anyDuplicated(panel, by = c("code", "year")) ||
    anyNA(panel[, .(gross_kt, removals_kt, net_kt, name, type_divipola_2025)])) {
  stop("Panel con claves duplicadas o cobertura GEI perdida")
}
panel[, `:=`(
  population_status = fifelse(is.na(population), "sin_fila", fifelse(population == 0, "cero", "positivo")),
  vam_status = fifelse(year < 2011L, "fuera_ventana", fifelse(is.na(vam_nominal_billion_cop),
                         "sin_fila", fifelse(vam_nominal_billion_cop == 0, "cero", "positivo"))),
  historical_assignment_flag = (code == "27493" & year < 2024L) |
                               (code == "94343" & year < 2020L),
  boundary_review_flag = code %in% c("27493", "27615", "94343")
)]
panel[, per_capita_gross_t := fifelse(population > 0 & !historical_assignment_flag,
                                     gross_kt * 1000 / population, NA_real_)]
panel[, per_capita_net_t := fifelse(population > 0 & !historical_assignment_flag,
                                   net_kt * 1000 / population, NA_real_)]
panel[, vam_nominal_only := year >= 2011L & vam_status == "positivo"]
setorder(panel, code, year)
previous_coverage <- fread("data/metadata/territorial_join_coverage.csv")
actual_coverage <- panel[, .(
  ideam_with_population = sum(!is.na(population)),
  ideam_with_positive_population = sum(population > 0, na.rm = TRUE),
  ideam_with_both_positive = if (year[1L] >= 2011L)
    sum(population > 0 & vam_nominal_billion_cop > 0, na.rm = TRUE) else NA_integer_
), by = year]
coverage_check <- merge(actual_coverage, previous_coverage, by = "year", suffixes = c("_panel", "_phase2"))
for (field in c("ideam_with_population", "ideam_with_positive_population", "ideam_with_both_positive")) {
  x <- coverage_check[[paste0(field, "_panel")]]
  y <- coverage_check[[paste0(field, "_phase2")]]
  if (!identical(x, y)) stop("La cobertura difiere de la Fase 2: ", field)
}
dir.create("data/processed", recursive = TRUE, showWarnings = FALSE)
fwrite(panel, "data/processed/core_panel.csv")

impact <- panel[, .(
  ideam_units = .N,
  missing_population = sum(population_status == "sin_fila"),
  zero_population = sum(population_status == "cero"),
  valid_per_capita = sum(!is.na(per_capita_gross_t)),
  positive_vam = sum(vam_status == "positivo"),
  gross_total_kt = sum(gross_kt),
  net_total_kt = sum(net_kt),
  gross_invalid_population_kt = sum(gross_kt[population_status != "positivo"]),
  net_invalid_population_kt = sum(net_kt[population_status != "positivo"]),
  gross_nonmunicipio_kt = sum(gross_kt[type_divipola_2025 != "MUNICIPIO"]),
  net_nonmunicipio_kt = sum(net_kt[type_divipola_2025 != "MUNICIPIO"]),
  gross_boundary_review_kt = sum(gross_kt[boundary_review_flag]),
  net_boundary_review_kt = sum(net_kt[boundary_review_flag])
), by = year][order(year)]
for (measure in c("invalid_population", "nonmunicipio", "boundary_review")) {
  impact[, paste0("gross_", measure, "_pct") :=
           100 * get(paste0("gross_", measure, "_kt")) / gross_total_kt]
  impact[, paste0("net_", measure, "_pct") :=
           100 * get(paste0("net_", measure, "_kt")) / net_total_kt]
}

jumps <- copy(panel[order(code, year)])
jumps[, previous_gross := shift(gross_kt), by = code]
jumps <- jumps[year > 1990L & previous_gross > 1 & gross_kt > 1,
               .(code, year, previous_gross, gross_kt,
                 gross_ratio = gross_kt / previous_gross, boundary_review_flag)]
jumps[, size_of_jump := abs(log(gross_ratio))]
setorder(jumps, -size_of_jump)
jumps <- head(jumps, 30L)
jumps[, size_of_jump := NULL]

dir.create("data/metadata", recursive = TRUE, showWarnings = FALSE)
fwrite(signs, "data/metadata/phase3_signs_by_gas.csv")
fwrite(unusual_signs, "data/metadata/phase3_unusual_signs.csv")
fwrite(national_check[order(year)], "data/metadata/phase3_national_check.csv")
fwrite(sector_check[order(year, sector)], "data/metadata/phase3_sector_check.csv")
fwrite(impact, "data/metadata/phase3_impact_by_year.csv")
fwrite(jumps, "data/metadata/phase3_jump_review.csv")
products <- data.table(path = c("data/interim/gei_sector_year.csv", "data/processed/core_panel.csv"))
products[, `:=`(
  file_size_bytes = file.info(path)$size,
  sha256 = vapply(path, digest::digest, character(1L), algo = "sha256", file = TRUE)
)]
fwrite(products, "data/metadata/phase3_products.csv")
cat("Panel:", nrow(panel), "filas,", uniqueN(panel$code), "códigos\n")
print(signs)
print(impact[year %in% c(1990L, 2011L, 2018L, 2023L, 2024L),
             .(year, valid_per_capita, gross_invalid_population_pct,
               gross_nonmunicipio_pct, gross_boundary_review_pct)])
cat("Máximo error de conciliación nacional:",
    max(abs(national_check$net_difference_kt)), "kt\n")
