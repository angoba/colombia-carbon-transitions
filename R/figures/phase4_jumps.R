# Abre los 30 saltos señalados sin modificar el inventario.

library(data.table)

jumps <- fread("data/metadata/phase3_jump_review.csv", colClasses = list(character = "code"))
if (nrow(jumps) != 30L || anyDuplicated(jumps, by = c("code", "year"))) stop("Lista de saltos inesperada")
manifest <- fread("data/metadata/manifest.csv", colClasses = "character")
name <- "Inventario_subnacional_GEI_V1_26062026.csv"
path <- file.path("data/raw/ideam", name)
item <- manifest[original_filename == name]
if (nrow(item) != 1L || file.info(path)$size != as.numeric(item$file_size_bytes)) stop("Archivo IDEAM distinto")
if (tolower(digest::digest(path, algo = "sha256", file = TRUE)) != tolower(item$sha256)) stop("Hash IDEAM distinto")

raw <- fread(path, select = c("AÑO", "Codigo_Municipio", "SECTOR_IPCC", "CATEGORIA",
                             "CONTAMINANTE", "Valor_CO2eq"),
             colClasses = list(character = "Codigo_Municipio"), showProgress = FALSE)
setnames(raw, c("AÑO", "Codigo_Municipio", "SECTOR_IPCC", "CATEGORIA",
                "CONTAMINANTE", "Valor_CO2eq"),
         c("year", "code", "sector", "category", "gas", "value"))
reference <- unique(rbind(jumps[, .(code, year)], jumps[, .(code, year = year - 1L)]))
setkey(reference, code, year)
raw <- raw[reference, on = .(code, year), nomatch = 0L]
raw <- raw[gas != "CO2_ABS"]
category <- raw[, .(gross_kt = sum(value)), by = .(code, year, sector, category)]
rm(raw)

for (level in c("sector", "category")) {
  grouping <- if (level == "sector") c("code", "year", "sector") else c("code", "year", "sector", "category")
  totals <- category[, .(gross_kt = sum(gross_kt)), by = grouping]
  previous <- copy(totals)
  previous[, year := year + 1L]
  setnames(previous, "gross_kt", "previous_kt")
  change <- merge(totals, previous, by = grouping, all = TRUE)
  change[is.na(gross_kt), gross_kt := 0]
  change[is.na(previous_kt), previous_kt := 0]
  change <- change[jumps, on = .(code, year), nomatch = 0L]
  change[, difference_kt := gross_kt - previous_kt]
  setorderv(change, c("code", "year", "difference_kt"), c(1L, 1L, -1L))
  top <- change[, .SD[which.max(abs(difference_kt))], by = .(code, year)]
  setnames(top, c("gross_kt", "previous_kt", "difference_kt"),
           paste0(level, c("_current_kt", "_previous_kt", "_difference_kt")))
  keep <- if (level == "sector") c("code", "year", "sector", paste0(level, c("_current_kt", "_previous_kt", "_difference_kt"))) else c("code", "year", "sector", "category", paste0(level, c("_current_kt", "_previous_kt", "_difference_kt")))
  top <- top[, ..keep]
  if (level == "sector") setnames(top, "sector", "main_sector")
  if (level == "category") setnames(top, c("sector", "category"), c("main_category_sector", "main_category"))
  jumps <- merge(jumps, top, by = c("code", "year"), all.x = TRUE)
}
if (nrow(jumps) != 30L || anyNA(jumps$main_sector) || anyNA(jumps$main_category)) stop("Saltos sin desglose")
jumps[, total_difference_kt := gross_kt - previous_gross]
jumps[, review_status := "sector y categoría identificados; mecanismo no verificado"]
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)
fwrite(jumps[order(-abs(total_difference_kt))], "outputs/tables/phase4_jump_breakdown.csv")
print(jumps[, .N, by = main_sector][order(-N)])
print(jumps[order(-abs(total_difference_kt))][1:6,
            .(code, year, total_difference_kt, main_sector, main_category)])
