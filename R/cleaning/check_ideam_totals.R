# Esta suma es una prueba de unidades y cobertura, no un resultado del paper.

path <- "data/raw/ideam/Inventario_subnacional_GEI_V1_26062026.csv"
data <- data.table::fread(
  path,
  select = c("AÑO", "CONTAMINANTE", "Valor_CO2eq"),
  showProgress = TRUE
)
data.table::setnames(data, "AÑO", "year")

check <- data[year %in% c(1990L, 2024L), .(
  gross = sum(Valor_CO2eq[CONTAMINANTE != "CO2_ABS"], na.rm = TRUE),
  removals = sum(Valor_CO2eq[CONTAMINANTE == "CO2_ABS"], na.rm = TRUE)
), by = year][order(year)]
check[, net := gross + removals]

data.table::fwrite(check, "data/metadata/ideam_totals_check.csv")
print(check)
