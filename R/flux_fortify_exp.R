#' Fortify fluxes with exponential fit
#' @description plots the fluxes that were fitted with
#' an exponential model
#' @param slopes_df dataset containing slopes
#' @param kappamax indicating if kappamax was applied
#' @importFrom dplyr select distinct mutate
#' @importFrom tidyr pivot_longer
#' @keywords internal

flux_fortify_exp <- function(slopes_df,
                             f_conc,
                             f_datetime,
                             y_text_position,
                             kappamax) {

  if (isTRUE(kappamax)) {
    param_df <- flux_param_kappamax(slopes_df)
  } else {
    param_df <- flux_param_exp(slopes_df)
  }

  slopes_df <- flux_plot_flag(slopes_df, param_df)

  fits_df <- slopes_df |>
    pivot_longer(
      cols = c("f_fit", "f_fit_slope", "f_fit_lm"),
      names_to = "linetype",
      values_to = "f_fit"
    )

  list(slopes_df = slopes_df, fits_df = fits_df, param_df = param_df)
}
