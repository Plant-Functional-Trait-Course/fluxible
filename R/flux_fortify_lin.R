#' Fortify fluxes with linear fit
#' @description Extracts fluxes that were fitted
#' with a linear model
#' @param slopes_df dataset containing slopes
#' @importFrom dplyr select distinct mutate
#' @keywords internal

flux_fortify_lin <- function(slopes_df) {
  param_df <- flux_param_lm(slopes_df)

  slopes_df <- flux_plot_flag(slopes_df, param_df)

  fits_df <- slopes_df |>
    mutate(
      linetype = "f_fit_slope"
    )

  list(slopes_df = slopes_df, fits_df = fits_df, param_df = param_df)
}
