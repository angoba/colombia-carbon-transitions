# Primeras tablas descriptivas de la fase 4.

library(data.table)

products <- fread("data/metadata/phase3_products.csv")
for (i in seq_len(nrow(products))) {
  path <- products$path[i]
  if (!file.exists(path)) stop("Falta ", path)
  if (file.info(path)$size != products$file_size_bytes[i]) stop("Cambió el tamaño de ", path)
  hash <- digest::digest(path, algo = "sha256", file = TRUE)
  if (tolower(hash) != tolower(products$sha256[i])) stop("Cambió el hash de ", path)
}

panel <- fread("data/processed/core_panel.csv", colClasses = list(character = c("code", "department_code")))
sector <- fread("data/interim/gei_sector_year.csv", colClasses = list(character = "code"))
if (nrow(panel) != 1122L * 35L || anyDuplicated(panel, by = c("code", "year"))) stop("Panel inesperado")
if (!setequal(panel$year, 1990:2024) || any(panel[, .N, by = year]$N != 1122L)) stop("Años incompletos")
if (anyNA(panel[, .(code, year, gross_kt, removals_kt, net_kt)])) stop("Faltan datos GEI")
if (max(abs(panel$gross_kt + panel$removals_kt - panel$net_kt)) > 1e-6) stop("No concilia bruto, absorciones y neto")

national <- panel[, .(territories = .N, gross_kt = sum(gross_kt),
                      removals_kt = sum(removals_kt), net_kt = sum(net_kt)), by = year][order(year)]
national_check <- fread("data/metadata/phase3_national_check.csv")
joined <- merge(national, national_check, by = "year", suffixes = c("", "_phase3"))
for (measure in c("gross_kt", "removals_kt", "net_kt")) {
  if (max(abs(joined[[measure]] - joined[[paste0(measure, "_phase3")]])) > 1e-6) stop("Cambió el total nacional")
}

sector[, sector_id := substr(sector, 1L, 1L)]
sector_year <- sector[, .(gross_kt = sum(gross_kt), removals_kt = sum(removals_kt),
                          net_kt = sum(net_kt)), by = .(year, sector_id, sector)][order(year, sector_id)]
sector_check <- fread("data/metadata/phase3_sector_check.csv")
sector_check[, sector_id := as.character(sector_id)]
if (nrow(sector_year) != 175L) stop("Faltan sectores")
sector_join <- merge(sector_year, sector_check, by = c("year", "sector_id"), suffixes = c("", "_phase3"))
for (measure in c("gross_kt", "removals_kt", "net_kt")) {
  if (max(abs(sector_join[[measure]] - sector_join[[paste0(measure, "_phase3")]])) > 1e-6) stop("Cambió el total sectorial")
}

coverage <- panel[, .(
  territories = .N,
  valid_per_capita = sum(!is.na(per_capita_gross_t)),
  no_population_row = sum(population_status == "sin_fila"),
  zero_population = sum(population_status == "cero"),
  historical_assignment = sum(historical_assignment_flag),
  gross_without_rate_kt = sum(gross_kt[is.na(per_capita_gross_t)]),
  gross_total_kt = sum(gross_kt)
), by = year][order(year)]
coverage[, gross_without_rate_pct := 100 * gross_without_rate_kt / gross_total_kt]

distribution <- panel[, .(
  territories = .N,
  gross_median_kt = median(gross_kt),
  gross_p10_kt = as.numeric(quantile(gross_kt, 0.1)),
  gross_p90_kt = as.numeric(quantile(gross_kt, 0.9)),
  gross_max_kt = max(gross_kt),
  net_nonpositive = sum(net_kt <= 0),
  per_capita_n = sum(!is.na(per_capita_gross_t)),
  per_capita_median_t = median(per_capita_gross_t, na.rm = TRUE)
), by = year][order(year)]

concentration <- panel[order(year, -gross_kt), .(
  top10_gross_pct = 100 * sum(head(gross_kt, 10L)) / sum(gross_kt),
  top100_gross_pct = 100 * sum(head(gross_kt, 100L)) / sum(gross_kt)
), by = year][order(year)]

type_totals <- panel[, .(territories = .N, gross_kt = sum(gross_kt),
                          removals_kt = sum(removals_kt), net_kt = sum(net_kt)),
                     by = .(year, type_divipola_2025)][order(year, type_divipola_2025)]

dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
fwrite(national, "outputs/tables/phase4_national.csv")
fwrite(sector_year, "outputs/tables/phase4_sectors.csv")
fwrite(coverage, "outputs/tables/phase4_coverage.csv")
fwrite(distribution, "outputs/tables/phase4_distribution.csv")
fwrite(concentration, "outputs/tables/phase4_concentration.csv")
fwrite(type_totals, "outputs/tables/phase4_types.csv")
print(coverage[year %in% c(1990, 2001, 2008, 2011, 2024),
               .(year, valid_per_capita, gross_without_rate_pct)])
print(national[year %in% c(1990, 2011, 2024)])
print(concentration[year %in% c(1990, 2011, 2024)])

dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
png("outputs/figures/phase4_national.png", width = 1600, height = 900, res = 150)
matplot(national$year,
        national[, .(gross_kt, net_kt, -removals_kt)] / 1000,
        type = "l", lty = c(1, 1, 2), lwd = 2.5,
        col = c("#B85C38", "#253A5A", "#4C8C76"),
        xlab = "Año", ylab = "Millones de toneladas de CO₂e",
        main = "Emisiones y absorciones del inventario municipal, Colombia")
legend("topleft", legend = c("Brutas", "Netas", "Absorciones, magnitud"),
       col = c("#B85C38", "#253A5A", "#4C8C76"), lty = c(1, 1, 2), lwd = 2.5, bty = "n")
mtext("Suma de 1.122 códigos IDEAM. Absorciones mostradas en magnitud; signo original negativo.",
      side = 1, line = 3.5, cex = 0.75)
dev.off()

png("outputs/figures/phase4_coverage.png", width = 1600, height = 900, res = 150)
plot(coverage$year, coverage$gross_without_rate_pct, type = "b", pch = 19,
     col = "#B85C38", xlab = "Año", ylab = "Porcentaje de emisiones brutas",
     main = "Emisiones sin tasa por habitante admisible")
abline(v = 2008, lty = 2, col = "#253A5A")
text(2008, max(coverage$gross_without_rate_pct) * 0.8, "Ventana principal desde 2008",
     pos = 4, cex = 0.8, col = "#253A5A")
mtext("Incluye población ausente o cero y asignaciones históricas cauteladas.",
      side = 1, line = 3.5, cex = 0.75)
dev.off()
