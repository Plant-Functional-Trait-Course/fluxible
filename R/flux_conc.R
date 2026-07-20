#' Transforms concentration from fractional to volumetric units
#' @description This function converts gas concentrations from fractional units
#' (e.g., ppm) to volumetric units (e.g., μmol/liter) based on the ideal gas
#' law and the specific conditions of the measurement.
#' @param conc_df dataframe of gas concentration over time
#' @param f_conc column with gas concentration
#' @param atm_pressure atmospheric pressure in atm,
#' can be a constant (numerical) or a variable (column name)
#' @param temp_air_col column containing the air temperature used
#' to convert concentration.
#' @param temp_air_unit units in which air temperature was measured.
#' Has to be either `celsius` (default), `fahrenheit` or `kelvin.`
#' @details Required temperature and pressure data
#' This function requires that each gas concentration data points to
#' be paired with a corresponding air temperature and pressure measurement. If
#' missing, data will be filled in the downup order. Pressure can also be
#' provided as a constant for the entire dataset.
#' @details Units
#' The units of the newly calculated volumetric concentration follow the units
#' of the fractional concentration provided. For exemple, if the input is in
#' 'ppm', the result is in 'µmol/L'; if the input is in 'ppb', the result is in
#' 'nmol/L'; if the input is in 'ppt', the result is in 'pmol/L'.

flux_conc <- function(
  conc_df,
  f_conc,
  atm_pressure,
  temp_air_col,
  f_fluxid = f_fluxid,
  temp_air_unit = "celsius"
) {


  prep_conc_df <- conc_df |>
    mutate( # unit conversion to kelvin
      f_temp_air_kelvin = if (temp_air_unit == "celsius") {
        {{temp_air_col}} + 273.15
      } else if (temp_air_unit == "fahrenheit") {
        ({{temp_air_col}} + 459.67) * (5 / 9)
      } else if (temp_air_unit == "kelvin") {
        {{temp_air_col}}
      },
      f_atm_press = {{atm_pressure}}
      # if constant, creates col, if already col, useless and harmless
    ) |>
    fill( # filling in case of missing values
      .data$f_temp_air_kelvin,
      .by = {{f_fluxid}},
      .direction = "downup"
    ) |>
    fill( # filling in case of missing values
      .data$f_atm_press,
      .by = {{f_fluxid}},
      .direction = "downup"
    )

  r_const <- 0.082057
  message("R constant set to 0.082057 L * atm * K^-1 * mol^-1")

  new_conc_df <- prep_conc_df |>
    mutate(
      f_conc_vol =
        (.data$f_conc * .data$f_atm_press)
        / (r_const * .data$f_temp_air_kelvin)
    )

  new_conc_df
}


