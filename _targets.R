# Flujo inicial de Fase 0: valida solo parámetros; no accede a datos.
library(targets)

tar_option_set(packages = "yaml")

list(
  tar_target(parameters_file, "config/parameters.yml", format = "file"),
  tar_target(
    project_parameters,
    yaml::read_yaml(parameters_file)
  ),
  tar_target(
    validated_windows,
    {
      h <- project_parameters$historical_window
      e <- project_parameters$economic_window
      stopifnot(
        is.numeric(h$start_year), is.numeric(h$end_year),
        is.numeric(e$start_year), is.numeric(e$end_year),
        h$start_year <= h$end_year,
        e$start_year <= e$end_year,
        e$start_year >= h$start_year,
        e$end_year <= h$end_year
      )
      c(historical_years = h$end_year - h$start_year + 1,
        economic_years = e$end_year - e$start_year + 1)
    }
  )
)
