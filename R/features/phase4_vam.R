# Comprueba las tres grandes actividades del valor agregado municipal.

library(data.table)

manifest <- fread("data/metadata/manifest.csv", colClasses = "character")
name <- "anex-PIBDep-ValorAgreMuni-2011-2024p.xlsx"
path <- file.path("data/raw/dane", name)
record <- manifest[original_filename == name]
if (nrow(record) != 1L || file.info(path)$size != as.numeric(record$file_size_bytes)) stop("Archivo VAM distinto")
if (tolower(digest::digest(path, algo = "sha256", file = TRUE)) != tolower(record$sha256)) stop("Hash VAM distinto")

panel <- fread("data/processed/core_panel.csv", colClasses = list(character = "code"))
activity <- rbindlist(lapply(2011:2024, function(yr) {
  book <- suppressMessages(as.data.table(readxl::read_excel(
    path, sheet = paste("Cuadro", yr - 2009L), skip = 10L, col_names = FALSE)))
  setnames(book, names(book)[1:8], c("code", "name_dane", "department_code", "department",
                                   "primary", "secondary", "tertiary", "vam_total"))
  book[, code := as.character(code)]
  book <- book[grepl("^[0-9]{5}$", code),
               .(code, primary = as.numeric(primary), secondary = as.numeric(secondary),
                 tertiary = as.numeric(tertiary), vam_total = as.numeric(vam_total))]
  book[, year := yr]
  book
}), fill = TRUE)
setcolorder(activity, c("code", "year", "primary", "secondary", "tertiary", "vam_total"))
if (anyDuplicated(activity, by = c("code", "year")) || anyNA(activity)) stop("Claves o valores VAM inválidos")
expected_n <- data.table(year = 2011:2024,
                         N = c(rep(1122L, 9L), rep(1121L, 4L), 1122L))
if (!isTRUE(all.equal(activity[, .N, by = year][order(year)], expected_n))) {
  stop("Cobertura VAM inesperada")
}
missing_ideam <- panel[year %in% 2011:2024, .(code, year)][!activity, on = .(code, year)]
if (nrow(missing_ideam) != 13L || !all(missing_ideam$code == "27493") ||
    !setequal(missing_ideam$year, 2011:2023)) stop("Faltantes IDEAM-VAM inesperados")
extra_dane <- activity[!panel, on = .(code, year)]
if (nrow(extra_dane) != 9L || !all(extra_dane$code == "94663") ||
    !setequal(extra_dane$year, 2011:2019)) stop("Código DANE adicional inesperado")
activity[, sum_activities := primary + secondary + tertiary]
activity[, difference := sum_activities - vam_total]
if (max(abs(activity$difference)) > 1e-6) stop("Las actividades no suman el total VAM")

comparison <- merge(activity, panel[year %in% 2011:2024,
                                    .(code, year, vam_nominal_billion_cop, type_divipola_2025)],
                    by = c("code", "year"), all.x = TRUE)
if (nrow(comparison) != nrow(activity)) stop("Unión VAM inesperada")
if (comparison[is.na(type_divipola_2025), uniqueN(code)] != 1L ||
    !identical(comparison[is.na(type_divipola_2025), unique(code)], "94663")) {
  stop("Cambió el código DANE que falta en IDEAM")
}
comparison[, panel_difference := vam_total - vam_nominal_billion_cop]
if (max(abs(comparison[!is.na(panel_difference), panel_difference])) > 1e-6) stop("VAM no coincide con fase 3")
comparison[, primary_share := fifelse(vam_total > 0, primary / vam_total, NA_real_)]
comparison[, secondary_share := fifelse(vam_total > 0, secondary / vam_total, NA_real_)]
comparison[, tertiary_share := fifelse(vam_total > 0, tertiary / vam_total, NA_real_)]

quality <- comparison[, .(dane_codes = .N, ideam_codes = sum(!is.na(type_divipola_2025)),
                          positive_vam = sum(vam_total > 0), zero_vam = sum(vam_total == 0),
                          max_sum_difference = max(abs(difference)),
                          max_panel_difference = max(abs(panel_difference), na.rm = TRUE)), by = year]
economy <- comparison[!is.na(type_divipola_2025), .(
  codes = .N, primary_nominal_billion_cop = sum(primary),
  secondary_nominal_billion_cop = sum(secondary),
  tertiary_nominal_billion_cop = sum(tertiary),
  vam_nominal_billion_cop = sum(vam_total)), by = year]
economy[, primary_share := primary_nominal_billion_cop / vam_nominal_billion_cop]
economy[, secondary_share := secondary_nominal_billion_cop / vam_nominal_billion_cop]
economy[, tertiary_share := tertiary_nominal_billion_cop / vam_nominal_billion_cop]

dir.create("data/interim", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
fwrite(comparison[, .(code, year, primary, secondary, tertiary, vam_total,
                      primary_share, secondary_share, tertiary_share)],
       "data/interim/vam_activities.csv")
fwrite(quality, "outputs/tables/phase4_vam_quality.csv")
fwrite(economy, "outputs/tables/phase4_vam_economy.csv")
print(quality[year %in% c(2011, 2024)])
print(economy[year %in% c(2011, 2024)])
