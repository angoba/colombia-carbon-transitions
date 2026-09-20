# Composición sectorial y cambios territoriales entre dos periodos de cuatro años.

library(data.table)

panel <- fread("data/processed/core_panel.csv", colClasses = list(character = "code"))
sector <- fread("data/interim/gei_sector_year.csv", colClasses = list(character = "code"))
sector[, sector_id := substr(sector, 1L, 1L)]
sector_year <- sector[, .(gross_kt = sum(gross_kt), removals_kt = sum(removals_kt),
                          net_kt = sum(net_kt)), by = .(year, sector_id, sector)]
sector_year[, gross_share := gross_kt / sum(gross_kt), by = year]
sector_year[, net_share := net_kt / sum(net_kt), by = year]
if (max(abs(sector_year[, sum(gross_share), by = year]$V1 - 1)) > 1e-10) stop("Participaciones sectoriales")

first <- panel[year %in% 2011:2014, .(gross_first_kt = mean(gross_kt),
                                      net_first_kt = mean(net_kt)), by = code]
last <- panel[year %in% 2021:2024, .(gross_last_kt = mean(gross_kt),
                                     net_last_kt = mean(net_kt)), by = code]
trajectory <- merge(first, last, by = "code")
territory <- unique(panel[, .(code, name, type_divipola_2025, boundary_review_flag)])
trajectory <- merge(trajectory, territory, by = "code")
trajectory[, gross_difference_kt := gross_last_kt - gross_first_kt]
trajectory[, gross_relative_change_pct := 100 * (gross_last_kt / gross_first_kt - 1)]
trajectory[, net_difference_kt := net_last_kt - net_first_kt]
if (nrow(trajectory) != 1122L || anyNA(trajectory[, .(gross_first_kt, gross_last_kt)])) {
  stop("Trayectorias incompletas")
}

summary <- trajectory[, .(
  territories = .N,
  gross_increase = sum(gross_difference_kt > 0),
  gross_decrease = sum(gross_difference_kt < 0),
  gross_difference_median_kt = median(gross_difference_kt),
  gross_relative_median_pct = median(gross_relative_change_pct),
  gross_relative_p10_pct = as.numeric(quantile(gross_relative_change_pct, 0.1)),
  gross_relative_p90_pct = as.numeric(quantile(gross_relative_change_pct, 0.9)),
  gross_first_sum_kt = sum(gross_first_kt),
  gross_last_sum_kt = sum(gross_last_kt)
), by = type_divipola_2025]

stable_municipalities <- trajectory[type_divipola_2025 == "MUNICIPIO" & !boundary_review_flag]
examples_up <- stable_municipalities[order(-gross_difference_kt)][1:10,
  .(code, name, gross_first_kt, gross_last_kt, gross_difference_kt)]
examples_down <- stable_municipalities[order(gross_difference_kt)][1:10,
  .(code, name, gross_first_kt, gross_last_kt, gross_difference_kt)]
examples_up[, selection := "mayor aumento absoluto"]
examples_down[, selection := "mayor descenso absoluto"]
examples <- rbind(examples_up, examples_down, fill = TRUE)

types <- panel[, .(territories = .N, gross_kt = sum(gross_kt),
                   net_kt = sum(net_kt)), by = .(year, type_divipola_2025)]
types[, gross_share := gross_kt / sum(gross_kt), by = year]

dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)
fwrite(sector_year[order(year, sector_id)], "outputs/tables/phase4_sector_shares.csv")
fwrite(trajectory[order(code)], "outputs/tables/phase4_trajectories.csv")
fwrite(summary, "outputs/tables/phase4_trajectory_summary.csv")
fwrite(examples, "outputs/tables/phase4_examples.csv")
fwrite(types[order(year, type_divipola_2025)], "outputs/tables/phase4_type_shares.csv")

wide <- dcast(sector_year, year ~ sector_id, value.var = "gross_share")
png("outputs/figures/phase4_sector_shares.png", width = 1600, height = 900, res = 150)
matplot(wide$year, 100 * as.matrix(wide[, -1]), type = "l", lwd = 2.5,
        lty = 1, col = c("#253A5A", "#B85C38", "#7B654B", "#4C8C76", "#8D7292"),
        xlab = "Año", ylab = "Porcentaje de emisiones brutas",
        main = "Participación de los cinco sectores del inventario")
legend("right", legend = sector_year[year == 2024][order(sector_id), sector],
       col = c("#253A5A", "#B85C38", "#7B654B", "#4C8C76", "#8D7292"),
       lty = 1, lwd = 2.5, cex = 0.7, bty = "n")
mtext("Suma de 1.122 códigos IDEAM. Participaciones de emisiones brutas, no netas.",
      side = 1, line = 3.5, cex = 0.75)
dev.off()

print(sector_year[year %in% c(1990, 2024), .(year, sector_id, gross_share)][order(year, sector_id)])
print(summary)
