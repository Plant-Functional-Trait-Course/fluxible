#' Fitting a model to the gas concentration curve and estimating the slope
#' over time, using the exponential model from Zhao et al (2018)
#' @references Zhao, P., Hammerle, A., Zeeman, M., Wohlfahrt, G., 2018.
#' On the calculation of daytime CO2 fluxes measured by automated closed
#' transparent chambers. Agricultural and Forest Meteorology 263, 267–275.
#' https://doi.org/10.1016/j.agrformet.2018.08.022
#' @description Fits an exponential expression to the concentration evolution
#' @param conc_df dataframe of gas concentration over time
#' @param conc_df_cut dataframe of gas concentration over time, cut
#' @param f_conc column with gas concentration
#' @param f_start column with datetime when the measurement started
#' @param f_fluxid column with ID of each flux
#' @param cz_window window used to calculate Cz, at the beginning of cut window
#' @param b_window window to estimate b. It is an interval after tz
#' where it is assumed that C fits the data perfectly
#' @param a_window window at the end of the flux to estimate a
#' @param roll_width width of the rolling mean for CO2 when looking for tz,
#' ideally same as cz_window
#' @return a dataframe with the slope at t zero,
#' modeled concentration over time and exponential expression parameters
#' @importFrom rlang .data
#' @importFrom dplyr rename mutate select group_by case_when ungroup filter distinct left_join rowwise summarize pull slice join_by
#' @importFrom tidyr pivot_wider drop_na nest unnest
#' @importFrom haven as_factor
#' @importFrom stringr str_c
#' @importFrom stats lm optim
#' @importFrom purrr map
#' @importFrom broom tidy
#' @importFrom zoo rollmean
#' @keywords internal



flux_fitting_zhao18 <- function(conc_df_cut,
                                conc_df,
                                f_conc,
                                f_start,
                                f_fluxid,
                                cz_window,
                                b_window,
                                a_window,
                                roll_width) {

  args_ok <- flux_fun_check(list(
    cz_window = cz_window,
    b_window = b_window,
    a_window = a_window,
    roll_width = roll_width
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


  message("Estimating starting parameters for optimization...")



  cm_temp_min <- conc_df_cut |>
    group_by({{f_fluxid}}) |>
    select({{f_fluxid}}, {{f_conc}}, "f_time_cut") |>
    distinct(.data[[name_conc]], .keep_all = TRUE) |>
    slice(which.min(.data[[name_conc]])) |>
    rename(
      Cmin = {{f_conc}},
      tmin = "f_time_cut"
    ) |>
    ungroup()

  cm_temp_max <- conc_df_cut |>
    group_by({{f_fluxid}}) |>
    select({{f_fluxid}}, {{f_conc}}, "f_time_cut") |>
    distinct(.data[[name_conc]], .keep_all = TRUE) |>
    slice(which.max(.data[[name_conc]])) |>
    rename(
      Cmax = {{f_conc}},
      tmax = "f_time_cut"
    ) |>
    ungroup()

  cm_temp <- left_join(cm_temp_max, cm_temp_min,
    by = join_by({{f_fluxid}})
  )



  cm_slope <- conc_df_cut |>
    group_by({{f_fluxid}}) |>
    nest() |>
    mutate(
      model_Cm =
        map(.x = data, \(.x) lm(.x[[name_conc]] ~ f_time_cut, data = .x)),
      tidy = map(.data$model_Cm, tidy)
    ) |>
    unnest("tidy") |>
    filter(.data$term == "f_time_cut") |>
    rename(slope_Cm = "estimate") |>
    unnest({{f_fluxid}}) |>
    select({{f_fluxid}}, "slope_Cm")



  cm_df <- left_join(cm_temp, cm_slope, by = join_by({{f_fluxid}})) |>
    mutate(
      f_Cm_est = case_when(
        .data$slope_Cm < 0 ~ .data$Cmin,
        .data$slope_Cm > 0 ~ .data$Cmax
      ),
      tm = case_when(
        .data$slope_Cm < 0 ~ .data$tmin,
        .data$slope_Cm > 0 ~ .data$tmax
      ),
      .by = {{f_fluxid}}
    ) |>
    select({{f_fluxid}}, "f_Cm_est", "tm", "slope_Cm")


  cz_df <- conc_df_cut |>
    filter(
      .data$f_time_cut <= cz_window
    ) |>
    group_by({{f_fluxid}}) |>
    nest() |>
    mutate(
      model_Cz =
        map(.x = data, \(.x) lm(.x[[name_conc]] ~ f_time_cut, data = .x)),
      tidy = map(.data$model_Cz, tidy)
    ) |>
    unnest("tidy") |>
    filter(.data$term == "(Intercept)") |>
    rename(f_Cz = "estimate") |>
    unnest({{f_fluxid}}) |>
    select({{f_fluxid}}, "f_Cz") |>
    ungroup()



  tz_df <- conc_df_cut |>
    left_join(cz_df, by = join_by({{f_fluxid}})) |>
    group_by({{f_fluxid}}) |>
    filter(
      .data$f_time_cut < .data$f_length_window / 2
    ) |>
    mutate(
      conc_roll = rollmean(.data[[name_conc]],
        k = roll_width,
        fill = NA, align = "right"
      ),
      conc_roll = replace_na(.data$conc_roll, 0),
      Cd = abs(.data$conc_roll - .data$f_Cz),
      minCd = min(.data$Cd, na.rm = TRUE),
      f_tz_est = min(.data$f_time_cut[.data$Cd == .data$minCd], na.rm = TRUE)
    ) |>
    ungroup() |>
    select({{f_fluxid}}, "f_tz_est"
    ) |>
    distinct()



  cb_df <- conc_df_cut |>
    left_join(tz_df, by = join_by({{f_fluxid}})) |>
    group_by({{f_fluxid}}) |>
    mutate(
      diff = .data$f_time_cut - .data$f_tz_est + b_window
    ) |>
    distinct(.data$diff, .keep_all = TRUE) |>
    slice(which.min(abs(.data$diff))) |>
    rename(f_Cb = {{f_conc}}) |>
    select({{f_fluxid}}, "f_Cb") |>
    ungroup()

  a_df <- conc_df_cut |>
    group_by({{f_fluxid}}) |>
    mutate(
      ta = .data$f_length_window - a_window,
      ta_diff = .data$f_time_cut - .data$ta
    ) |>
    distinct(.data$ta_diff, .keep_all = TRUE) |>
    slice(which.min(abs(.data$ta_diff))) |>
    rename(Ca = {{f_conc}}) |>
    select({{f_fluxid}}, "ta", "Ca") |>
    ungroup()

  estimates_df <- left_join(cm_df, cz_df,
    by = join_by({{f_fluxid}})
  ) |>
    left_join(tz_df, by = join_by({{f_fluxid}})) |>
    left_join(a_df, by = join_by({{f_fluxid}})) |>
    left_join(cb_df, by = join_by({{f_fluxid}})) |>
    mutate(
      f_tz_est = replace(.data$f_tz_est, .data$f_tz_est <= 0, 1e-10),
      # because we use a log to force tz to be positive
      f_b_est = case_when(
        .data$f_Cb == .data$f_Cm_est ~ 0, # special case or flat flux
        .data$f_Cz == .data$f_Cm_est ~ 0, # special case or flat flux
        TRUE ~ log(
          abs((.data$f_Cb - .data$f_Cm_est) / (.data$f_Cz - .data$f_Cm_est))
        )
        * (1 / b_window),
      ),
      f_a_est = case_when(
        # f_tz_est = ta is a special case that is undefined
        .data$ta == .data$f_tz_est ~ 0,
        TRUE ~
          (.data$Ca - .data$f_Cm_est - (.data$f_Cz - .data$f_Cm_est)
           * exp(-.data$f_b_est * (.data$ta - .data$f_tz_est)))
          / (.data$ta - .data$f_tz_est)
      )
    )




  fc_myfn <- function(fc_time, fc_conc, par, fc_cz) {
    sqrt(
      (1 / length(fc_time))
      * sum((par[1] + par[2] * (fc_time - exp(par[4]))
             + (fc_cz - par[1])
             * exp(-par[3] * (fc_time - exp(par[4])))
             - fc_conc)^2)
    )
  }


  message("Optimizing fitting parameters...")

  fitting_par <- conc_df_cut |>
    left_join(estimates_df, by = join_by({{f_fluxid}})) |>
    select(
      {{f_fluxid}}, "f_Cm_est", "f_a_est", "f_b_est", "f_tz_est",
      "f_Cz", "f_time_cut", {{f_conc}}
    ) |>
    group_by(
      {{f_fluxid}}, .data$f_Cm_est, .data$f_a_est, .data$f_b_est,
      .data$f_tz_est, .data$f_Cz
    ) |>
    nest() |>
    rowwise() |>
    summarize(
      results = list(tryCatch(
        optim(
          par = c(
            .data$f_Cm_est, .data$f_a_est, .data$f_b_est,
            log(.data$f_tz_est)
          ),
          fn = fc_myfn, fc_conc = data[name_conc],
          fc_time = data$f_time_cut, fc_cz = .data$f_Cz
        ),
        error = function(err) list(par = rep(NA, 4))
      )),
      f_Cm = .data$results$par[1],
      f_a = .data$results$par[2],
      f_b = .data$results$par[3],
      f_tz = exp(.data$results$par[4]), # we force tz to be positive
      f_slope = .data$f_a + .data$f_b * (.data$f_Cm - .data$f_Cz),
      .groups = "drop"
    ) |>
    select(!c("results", "f_Cm_est", "f_a_est",
              "f_b_est", "f_tz_est"))

  message("Calculating fits and slopes...")

  conc_fitting <- conc_df |>
    left_join(fitting_par, by = join_by({{f_fluxid}})) |>
    mutate(
      f_fit = .data$f_Cm + .data$f_a *
        (.data$f_time - .data$f_tz - .data$f_time_diff)
      + (.data$f_Cz - .data$f_Cm)
      * exp(-.data$f_b * (.data$f_time - .data$f_tz - .data$f_time_diff)),
      f_fit_slope = .data$f_slope * (.data$f_time) + .data$f_Cz - .data$f_slope
      * (.data$f_tz + .data$f_time_diff),
      f_start_z = {{f_start}} + .data$f_tz,
      .by = {{f_fluxid}}
    )

  message("Done.")


  conc_fitting
}
