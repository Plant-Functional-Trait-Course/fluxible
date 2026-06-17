#' linear fit to gas concentration over time
#' @description fits a linear model to the gas concentration over time
#' @param conc_df dataframe of gas concentration over time
#' @param conc_df_cut dataframe of gas concentration over time, cut
#' @param f_conc column with gas concentration
#' @param f_fluxid column with ID of each flux
#' @return a df with the modeled gas concentration, slope, intercept,
#' std error, r square and p value of the linear model
#' @importFrom rlang .data
#' @importFrom dplyr rename all_of mutate select group_by ungroup filter left_join distinct pull bind_cols
#' @importFrom tidyr drop_na pivot_wider fill
#' @importFrom haven as_factor
#' @importFrom stringr str_c
#' @importFrom broom glance
#' @keywords internal


flux_fitting_lm <- function(conc_df_cut,
                            conc_df,
                            f_conc,
                            f_fluxid) {

  name_conc <- names(select(conc_df, {{f_conc}}))


  fitting_par <- conc_df_cut |>
    group_by({{f_fluxid}}) |>
    nest() |>
    mutate(
      model = map(.x = data, \(.x) lm(.x[[name_conc]] ~ f_time_cut, data = .x)),
      tidy = map(.data$model, tidy),
      glance = map(.data$model, glance)
    ) |>
    select(!c("data", "model")) |>
    unnest("tidy") |>
    select({{f_fluxid}}, "term", "estimate", "glance") |>
    pivot_wider(names_from = "term", values_from = "estimate") |>
    unnest("glance") |>
    rename(
      f_slope = "f_time_cut",
      f_intercept = "(Intercept)",
      f_rsquared = "r.squared",
      f_adj_rsquared = "adj.r.squared",
      f_pvalue = "p.value"
    ) |>
    select(
      {{f_fluxid}}, "f_rsquared", "f_adj_rsquared",
      "f_slope", "f_intercept", "f_pvalue"
    ) |>
    ungroup()

  conc_fitting <- conc_df |>
    left_join(fitting_par, by = join_by({{f_fluxid}})) |>
    mutate(
      f_fit = .data$f_intercept + .data$f_slope * (.data$f_time - .data$f_time_diff)
    )


  conc_fitting
}
