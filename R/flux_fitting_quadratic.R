#' quadratic fit to gas concentration over time
#' @description fits a quadratic model to the gas concentration over time
#' @param conc_df dataframe of gas concentration over time
#' @param conc_df_cut dataframe of gas concentration over time, cut
#' @param f_conc column with gas concentration
#' @param f_start column with datetime when the measurement started
#' @param f_fluxid column with ID of each flux
#' @param t_zero time at which the slope should be calculated
#' @return a df with the modeled gas concentration, slope, intercept,
#' std error, r square and p value of the quadratic model
#' @importFrom rlang .data
#' @importFrom dplyr rename mutate select group_by case_when ungroup filter left_join distinct pull bind_cols join_by
#' @importFrom tidyr drop_na pivot_wider fill
#' @importFrom haven as_factor
#' @importFrom stringr str_c
#' @importFrom broom glance
#' @keywords internal


flux_fitting_quadratic <- function(conc_df_cut,
                                   conc_df,
                                   f_conc,
                                   f_start,
                                   f_fluxid,
                                   t_zero) {
  args_ok <- flux_fun_check(list(
    t_zero = t_zero
  ),
  fn = list(is.numeric),
  msg = c("has to be numeric"))

  if (any(!args_ok))
    stop("Please correct the arguments", call. = FALSE)



  name_conc <- names(select(conc_df, {{f_conc}}))


  conc_df_cut <- conc_df_cut |>
    mutate(
      f_time_cut2 = (.data$f_time_cut)^2
    )

  fitting_par <- conc_df_cut |>
    group_by({{f_fluxid}}) |>
    nest() |>
    mutate(
      model =
        map(.x = data,
            \(.x) lm(.x[[name_conc]] ~ f_time_cut + f_time_cut2, data = .x)),
      tidy = map(.data$model, tidy),
      glance = map(.data$model, glance)
    ) |>
    select(!c("data", "model")) |>
    unnest("tidy") |>
    select({{f_fluxid}}, "term", "estimate", "glance") |>
    pivot_wider(names_from = "term", values_from = "estimate") |>
    unnest("glance") |>
    rename(
      f_param1 = "f_time_cut",
      f_param2 = "f_time_cut2",
      f_intercept = "(Intercept)",
      f_rsquared = "r.squared",
      f_adj_rsquared = "adj.r.squared",
      f_pvalue = "p.value"
    ) |>
    select(
      {{f_fluxid}}, "f_param1", "f_param2", "f_rsquared",
      "f_adj_rsquared", "f_intercept", "f_pvalue"
    ) |>
    ungroup()

  conc_fitting <- conc_df |>
    left_join(fitting_par, by = join_by({{f_fluxid}})) |>
    mutate(
      f_slope = .data$f_param1 + 2 * .data$f_param2 * t_zero,
      f_fit =
        .data$f_intercept
        + .data$f_param1
        * (.data$f_time - .data$f_time_diff) + .data$f_param2
        * (.data$f_time - .data$f_time_diff)^2,
      f_fit_slope =
        .data$f_intercept
        - .data$f_param2
        * t_zero^2
        + (.data$f_param1 + 2 * .data$f_param2 * t_zero)
        * (.data$f_time - .data$f_time_diff),
      f_start_z = {{f_start}} + t_zero
    )

  conc_fitting
}
