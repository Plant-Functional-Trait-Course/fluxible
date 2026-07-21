#' for flux calculation in fractional units
#' @description calculates fluxes with avg temp and pressure
#' @param slopes_df dataframe of flux slopes
#' @param slope_col column containing the slope to calculate the flux
#' @param setup_volume volume of the flux chamber and instrument together in L,
#' can also be a column in case it is a variable
#' @param atm_pressure atmospheric pressure in atm,
#' can be a constant (numerical) or a variable (column name)
#' @param plot_area area of the plot in m^2,
#' can also be a column in case it is a variable
#' @param f_fluxid column containing the flux IDs
#' @return df with fluxes
#' @importFrom dplyr mutate enquo select
#' @importFrom rlang quo_is_symbolic
#' @keywords internal

flux_calc_frac <- function(
  slopes_df,
  slope_col,
  setup_volume,
  plot_area,
  f_fluxid,
  atm_pressure
) {
  r_const <- 0.082057
  message("R constant set to 0.082057 L * atm * K^-1 * mol^-1")

  fluxes <- slopes_df |>
    mutate(
      f_flux =
        ({{slope_col}} * .data$f_atm_pressure_ave * {{setup_volume}})
        / (r_const *
           .data$f_temp_air_ave
           * {{plot_area}}),
      .by = {{f_fluxid}}
    )

  if (!quo_is_symbolic(enquo(atm_pressure))) {
    fluxes <- fluxes |>
      select(!"f_atm_pressure_ave")
  }
  fluxes
}