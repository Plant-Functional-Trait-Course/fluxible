#' Fortify fluxes with a quadratic fit
#' @description specific part of flux_plot for
#' quadratic fit
#' @param slopes_df dataset containing slopes
#' @importFrom dplyr select distinct
#' @importFrom tidyr pivot_longer
#' @keywords internal

flux_fortify_quadratic <- function(slopes_df) {
  param_df <- flux_param_qua(slopes_df)

  slopes_df <- flux_plot_flag(slopes_df, param_df)

  fits_df <- slopes_df |>
    pivot_longer(
      cols = c("f_fit", "f_fit_slope", "f_fit_lm"),
      names_to = "linetype",
      values_to = "f_fit"
    )

  list(slopes_df = slopes_df, fits_df = fits_df, param_df = param_df)
}
