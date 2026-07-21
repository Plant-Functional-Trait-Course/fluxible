#' for flux calculation in volumetric units
#' @description calculates fluxes with instant temp and pressure
#' @param slopes_df dataframe of flux slopes
#' @param slope_col column containing the slope to calculate the flux
#' @param setup_volume volume of the flux chamber and instrument together in L,
#' can also be a column in case it is a variable
#' @param plot_area area of the plot in m^2,
#' can also be a column in case it is a variable
#' @param f_fluxid column containing the flux IDs
#' @return df with fluxes
#' @importFrom dplyr mutate
#' @keywords internal

flux_calc_vol <- function(
  slopes_df,
  slope_col,
  setup_volume,
  plot_area,
  f_fluxid
) {
  fluxes <- slopes_df |>
    mutate(
      f_flux =
        ({{slope_col}} * {{setup_volume}}) / {{plot_area}},
      .by = {{f_fluxid}}
    )
  fluxes

}