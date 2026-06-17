#' Fitting a model to the gas concentration curve and estimating the slope over
#' time, using the HM model
#' (Pedersen et al., 2010; Hutchinson and Mosier, 1981).
#' @references Pedersen, A.R., Petersen, S.O., Schelde, K., 2010.
#' A comprehensive approach to soil-atmosphere trace-gas flux estimation with
#' static chambers. European Journal of Soil Science 61, 888–902.
#' https://doi.org/10.1111/j.1365-2389.2010.01291.x
#' @references Hutchinson, G.L., Mosier, A.R., 1981. Improved Soil Cover Method
#' for Field Measurement of Nitrous Oxide Fluxes.
#' Soil Science Society of America Journal 45, 311–316.
#' https://doi.org/10.2136/sssaj1981.03615995004500020017x
#' @description Fits the exponential expression to the concentration evolution
#' `C(t) = C_m + (C_z - C_m) exp(-b * t)`
#' @param conc_df dataframe of gas concentration over time
#' @param conc_df_cut dataframe of gas concentration over time, cut
#' @param f_conc column with gas concentration
#' @param f_start column with datetime when the measurement started
#' @param f_fluxid column with ID of each flux
#' @param cz_window window used to calculate Cz, at the beginning of cut window
#' @param b_window window to estimate b. It is an interval after tz
#' where it is assumed that C fits the data perfectly
#' @param roll_width width of the rolling mean for CO2 when looking for tz,
#' ideally same as cz_window
#' @param t_zero time at which the slope should be calculated
#' (for quadratic fit)
#' @return a dataframe with the slope at t zero,
#' modeled concentration over time and exponential expression parameters
#' @importFrom rlang .data
#' @importFrom dplyr rename mutate select group_by case_when ungroup filter distinct left_join rowwise summarize pull slice
#' @importFrom tidyr pivot_wider drop_na nest unnest
#' @importFrom haven as_factor
#' @importFrom stringr str_c
#' @importFrom stats lm optim
#' @importFrom purrr map possibly
#' @importFrom utils data
#' @importFrom broom tidy
#' @importFrom stats nls nls.control
#' @keywords internal



flux_fitting_hm <- function(conc_df_cut,
                            conc_df,
                            f_conc,
                            f_start,
                            f_fluxid,
                            cz_window,
                            b_window,
                            roll_width,
                            t_zero) {

  args_ok <- flux_fun_check(list(
    cz_window = cz_window,
    b_window = b_window,
    roll_width = roll_width,
    t_zero = t_zero
  ),
  fn = list(
    is.numeric,
    is.numeric,
    is.numeric,
    is.numeric
  ),
  msg = rep("has to be numeric", 4))

  if (any(!args_ok))
    stop("Please correct the arguments", call. = FALSE)


  message("Cutting measurements...")

  name_conc <- names(select(conc_df, {{f_conc}}))


  message("Optimizing fitting parameters...")

  tibble_error <- tibble(
    term = c("logb", ".lin1", ".lin2"),
    estimate = NA_real_,
    std.error = NA_real_,
    statistic = NA_real_,
    p.value = NA_real_
  )

  fitting_par <- conc_df_cut |>
    select(
      {{f_fluxid}}, "f_time_cut", {{f_conc}}
    ) |>
    group_by(
      {{f_fluxid}}
    ) |>
    nest() |>
    mutate(
      model = map(
        .x = data, \(.x) {
          tryCatch(
            nls( # the arguments here are as advised in gasfluxes
              .x[[name_conc]] ~ cbind(
                1, exp(-exp(logb) * f_time_cut) / (-exp(logb))
              ),
              start = c(logb = log(1.5 / 3600)), algorithm = "plinear",
              control = nls.control(
                maxiter = 100, minFactor = 1e-10, scaleOffset = 1
              ),
              data = .x
            ),
            error = function(err) "model_error"
          )
        }
      ),
      tidy = map(
        .data$model,
        possibly(tidy, otherwise = tibble_error)
      )
    ) |>
    select(!c("data", "model")) |>
    unnest("tidy") |>
    select({{f_fluxid}}, "term", "estimate") |>
    pivot_wider(names_from = "term", values_from = "estimate") |>
    rename(
      f_Cm = ".lin1",
      f_slope_z = ".lin2"
    ) |>
    mutate(
      f_b = exp(logb),
      f_Cz = .data$f_Cm - (.data$f_slope_z / .data$f_b),
      f_slope = .data$f_slope_z * exp(-.data$f_b * t_zero)
    ) |>
    select(!"logb")

  message("Calculating fits and slopes...")

  conc_fitting <- conc_df |>
    left_join(fitting_par, by = join_by({{f_fluxid}})) |>
    mutate(
      f_fit = .data$f_Cm + .data$f_slope_z *
        (exp(-.data$f_b * (.data$f_time  - .data$f_time_diff)) / (-.data$f_b)),
      f_fit_slope = .data$f_Cm
      + (.data$f_Cz - .data$f_Cm) * exp(-.data$f_b * t_zero)
      - .data$f_slope * (t_zero - .data$f_time + .data$f_time_diff),
      f_start_z = {{f_start}} + t_zero
    ) |>
    select(!"f_slope_z")


  message("Done.")


  conc_fitting
}
