#' wet air correction
#' @description Corrects for the amount of water vapor inside the air
#' @param conc_df dataframe of gas concentration over time
#' @param gas_wet the gas to correct. Supply as a bare (unquoted) column name
#' (e.g. `co2`), not a string; this function uses tidy-evaluation with
#' `{{ }}`.
#' @param h2o_wet water vapor concentration before correction (in mmol/mol).
#' Supply as a bare (unquoted) column name (e.g. `h2o`), not a string.
#' @return the same dataframe with the additional column `[gas_wet]_dry` in the
#' same unit as `gas_wet`
#' @details The correction is done as follows:
#' \ifelse{html}{\out{gas_dry = gas_wet / (1 - (h2o_wet / 1000))}}{\eqn{gas_dry = gas_wet / (1 - (h2o_wet / 1000))}{ASCII}}
#' @importFrom rlang enquo as_name !! :=
#' @importFrom dplyr mutate
#' @export
#' @examples
#' data(wet_conc)
#' flux_drygas(wet_conc, co2, h2o)


flux_drygas <- function(conc_df,
                        gas_wet,
                        h2o_wet) {

  gas_wet_quo <- enquo(gas_wet)
  h2o_wet_quo <- enquo(h2o_wet)

  check_bare_col(gas_wet_quo, "gas_wet")
  check_bare_col(h2o_wet_quo, "h2o_wet")

  gas_dry_name <- paste0(as_name(gas_wet_quo), "_dry")

  output <- conc_df |>
    mutate(
      !!gas_dry_name := (!!gas_wet_quo) / (1 - (!!h2o_wet_quo / 1000))
    )

  output
}
