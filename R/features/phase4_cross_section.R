# Cruce descriptivo de estructuras económicas y sectores GEI dentro de un año.

library(data.table)

panel <- fread("data/processed/core_panel.csv", colClasses = list(character = "code"))
vam <- fread("data/interim/vam_activities.csv", colClasses = list(character = "code"))
sector <- fread("data/interim/gei_sector_year.csv", colClasses = list(character = "code"))
sector[, sector_id := substr(sector, 1L, 1L)]
land <- sector[sector_id == "4", .(land_gross_kt = sum(gross_kt)), by = .(code, year)]
energy <- sector[sector_id == "1", .(energy_gross_kt = sum(gross_kt)), by = .(code, year)]

cross <- merge(panel[year %in% c(2011L, 2024L),
                     .(code, year, name, type_divipola_2025, gross_kt, per_capita_gross_t)],
               vam[, .(code, year, primary_share, secondary_share, tertiary_share)],
               by = c("code", "year"))
cross <- merge(cross, land, by = c("code", "year"))
cross <- merge(cross, energy, by = c("code", "year"))
cross <- cross[type_divipola_2025 == "MUNICIPIO"]
cross[, land_share := land_gross_kt / gross_kt]
cross[, energy_share := energy_gross_kt / gross_kt]
cross[, primary_quintile := pmin(5L, ceiling(5 * frank(primary_share, ties.method = "average") / .N)),
      by = year]
if (anyNA(cross[, .(primary_share, land_share, energy_share)])) stop("Cruce con valores ausentes")
if (cross[year == 2011, .N] != 1102L || cross[year == 2024, .N] != 1103L) stop("Cobertura municipal inesperada")

groups <- cross[, .(
  municipalities = .N,
  median_primary_share = median(primary_share),
  median_land_share = median(land_share),
  median_energy_share = median(energy_share),
  median_gross_kt = median(gross_kt),
  median_per_capita_gross_t = median(per_capita_gross_t, na.rm = TRUE)
), by = .(year, primary_quintile)][order(year, primary_quintile)]
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
fwrite(groups, "outputs/tables/phase4_economic_quintiles.csv")
print(groups[year == 2024])
