# Comprueba qué registra IDEAM para territorios creados durante la serie.

library(data.table)
path <- "data/raw/ideam/Inventario_subnacional_GEI_V1_26062026.csv"
tab <- fread(path, select = c("AÑO", "Codigo_Municipio", "Valor_CO2eq"),
             colClasses = list(character = "Codigo_Municipio"), showProgress = FALSE)
setnames(tab, "AÑO", "year")
special <- tab[Codigo_Municipio %in% c("27493", "94343") & year %in% 1990:2024,
               .(rows = .N, nonzero_rows = sum(Valor_CO2eq != 0, na.rm = TRUE),
                 value_sum = sum(Valor_CO2eq, na.rm = TRUE)),
               by = .(code = Codigo_Municipio, year)]
setorder(special, code, year)
if (nrow(special) != 70L) stop("Cambió la cobertura de los códigos revisados")
fwrite(special, "data/metadata/territorial_special_ideam.csv")
print(special[year %in% c(1990L, 2011L, 2018L, 2019L, 2020L, 2023L, 2024L)])
