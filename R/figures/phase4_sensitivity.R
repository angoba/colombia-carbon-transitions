# Comprueba cuánto cambian las descripciones por universo y ventana.

library(data.table)

panel <- fread("data/processed/core_panel.csv", colClasses = list(character = "code"))
coverage <- fread("outputs/tables/phase4_coverage.csv")
universes <- list(
  inventario = panel,
  municipios_2025 = panel[type_divipola_2025 == "MUNICIPIO"],
  municipios_sin_tres_marcas = panel[type_divipola_2025 == "MUNICIPIO" & !boundary_review_flag]
)
comparison <- rbindlist(lapply(names(universes), function(label) {
  p <- universes[[label]]
  sums <- p[year %in% c(1990L, 2024L), .(
    territories = .N, gross_kt = sum(gross_kt),
    top10_share = sum(sort(gross_kt, decreasing = TRUE)[1:10]) / sum(gross_kt)
  ), by = year]
  sums[, universe := label]
  sums
}))
setcolorder(comparison, c("universe", "year", "territories", "gross_kt", "top10_share"))
window_coverage <- rbindlist(lapply(list(`1990-2024` = 1990:2024,
                                         `2001-2024` = 2001:2024,
                                         `2008-2024` = 2008:2024,
                                         `2011-2024` = 2011:2024), function(years) {
  c <- coverage[year %in% years]
  data.table(years = length(years),
             min_valid_per_capita = min(c$valid_per_capita),
             max_gross_without_rate_pct = max(c$gross_without_rate_pct),
             mean_gross_without_rate_pct = mean(c$gross_without_rate_pct))
}), idcol = "window")
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
fwrite(comparison[order(universe, year)], "outputs/tables/phase4_universe_sensitivity.csv")
fwrite(window_coverage, "outputs/tables/phase4_window_sensitivity.csv")

trajectories <- fread("outputs/tables/phase4_trajectories.csv", colClasses = list(character = "code"))
municipal <- trajectories[type_divipola_2025 == "MUNICIPIO"]
cutoff <- as.numeric(quantile(municipal$gross_first_kt, 0.99))
samples <- list(todos_municipios = municipal,
                sin_tres_marcas = municipal[boundary_review_flag == FALSE],
                sin_top_1_pct_inicial = municipal[gross_first_kt < cutoff])
trajectory_sensitivity <- rbindlist(lapply(names(samples), function(label) {
  p <- samples[[label]]
  data.table(sample = label, municipalities = nrow(p),
             increased = sum(p$gross_difference_kt > 0),
             increased_pct = 100 * mean(p$gross_difference_kt > 0),
             median_difference_kt = median(p$gross_difference_kt))
}))
fwrite(trajectory_sensitivity, "outputs/tables/phase4_extreme_sensitivity.csv")

rate_sensitivity <- rbindlist(lapply(c(2008L, 2024L), function(yr) {
  p <- panel[year == yr & type_divipola_2025 == "MUNICIPIO" &
               !is.na(per_capita_gross_t)]
  rbindlist(lapply(c(0L, 1000L, 5000L), function(minimum) {
    q <- p[population >= minimum]
    data.table(year = yr, min_population = minimum, municipalities = nrow(q),
               median_rate_t = median(q$per_capita_gross_t),
               aggregate_rate_t = 1000 * sum(q$gross_kt) / sum(q$population))
  }))
}))
fwrite(rate_sensitivity, "outputs/tables/phase4_rate_sensitivity.csv")
print(comparison[order(universe, year)])
print(window_coverage)
print(trajectory_sensitivity)
print(rate_sensitivity)
