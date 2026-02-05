#' Fitting a model to concentration data and estimating the slope
#' @description Fits gas concentration over time data with a model
#' (exponential, quadratic or linear) and provides the slope later used
#' to calculate gas fluxes with \link[fluxible:flux_calc]{flux_calc}
#' @param fit_type `exp_zhao18`, `exp_tz`, `exp_hm`, `quadratic` or `linear.`
#' `exp_zhao18` is using the exponential model
#' \ifelse{html}{\out{C(t) = C_m + a (t - t_z) + (C_z - C_m) exp(-b (t - t_z))}}{\eqn{C(t) = C_m + a (t - t_z) + (C_z - C_m) \exp(-b (t - t_z))}{ASCII}}
#' from Zhao et al (2018).
#' `expt_tz` is a modified version which allows the user to fix `t_zero`:
#' \ifelse{html}{\out{C(t) = C_m + a * t + (C_z - C_m) exp(-b * t)}}{\eqn{C(t) = C_m + a * t + (C_z - C_m) \exp(-b * t)}{ASCII}}
#' `exp_hm` is using the HM model
#' (Pedersen et al., 2010; Hutchinson and Mosier, 1981)
#' \ifelse{html}{\out{C(t) = C_m + (C_z - C_m) exp(-b * t)}}{\eqn{C(t) = C_m + (C_z - C_m) \exp(-b * t)}{ASCII}}
#' `exponential` is equal to `exp_zhao18`, for backwards compatibility
#' @param conc_df dataframe of gas concentration over time
#' @param f_conc column with gas concentration
#' @param cz_window window used to calculate Cz, at the beginning of cut window
#' (`exp_zhao18` and `exp_tz` fits)
#' @param b_window window to estimate b. It is an interval after tz where
#' it is assumed that the model fits the data perfectly
#' (`exp_zhao18` and `exp_tz` fits)
#' @param a_window window at the end of the flux to estimate a
#' (`exp_zhao18` and `exp_tz` fits)
#' @param roll_width width of the rolling mean for gas concentration when
#' looking for `tz`, ideally same as `cz_window`
#' (`exp_zhao18` and `exp_tz` fits)
#' @param start_cut time to discard at the start of the measurements
#' (in seconds)
#' @param cut_direction `"none"` (default) means that the focus window is
#' `f_start + start_cut` to `f_end - end_cut`; `"from_start"` makes it
#' `f_start + start_cut` to `f_start + end_cut`; `"from_end"` makes it
#' `f_end - start_cut` to `f_end - end_cut`.
#' Bug fix since v1.3.4: `"from_start"` was doing `f_start` + `start_cut` to
#' `f_start` + `start_cut` + `end_cut`
#' @param end_cut time to discard at the end of the measurements (in seconds)
#' @param f_start column with datetime when the measurement started (`ymd_hms`)
#' @param f_end column with datetime when the measurement ended (`ymd_hms`)
#' @param f_datetime column with datetime of each concentration measurement
#' Note that if there are duplicated datetime in the same `f_fluxid` only
#' the first row will be kept
#' @param f_conc column with gas concentration data
#' @param f_fluxid column with ID of each flux
#' @param t_zero time at which the slope should be calculated
#' (for `quadratic`, `exp_tz` and `exp_hm` fits)
#' @return a dataframe with the slope at t zero (`f_slope`),
#' a datetime column of t zero (`f_start_z`), a factor column indicating the
#' cuts (`f_cut`), the time in seconds since the start of the measurement
#' (`f_time`), the modeled fit (`f_fit`), the modeled slope (`f_fit_slope`),
#' the parameters of the fit depending on the model used,
#' and any columns present in the input.
#' The type of fit is added as an attribute for use by the other functions.
#' @references Pedersen, A.R., Petersen, S.O., Schelde, K., 2010.
#' A comprehensive approach to soil-atmosphere trace-gas flux estimation with
#' static chambers. European Journal of Soil Science 61, 888-902.
#' https://doi.org/10.1111/j.1365-2389.2010.01291.x
#' @references Hutchinson, G.L., Mosier, A.R., 1981. Improved Soil Cover Method
#' for Field Measurement of Nitrous Oxide Fluxes.
#' Soil Science Society of America Journal 45, 311-316.
#' https://doi.org/10.2136/sssaj1981.03615995004500020017x
#' @references Zhao, P., Hammerle, A., Zeeman, M., Wohlfahrt, G., 2018.
#' On the calculation of daytime CO2 fluxes measured by automated closed
#' transparent chambers. Agricultural and Forest Meteorology 263, 267-275.
#' https://doi.org/10.1016/j.agrformet.2018.08.022
#' @importFrom lubridate int_length interval
#' @importFrom rlang as_label enquo
#' @importFrom dplyr case_when mutate select
#' @examples
#' data(co2_conc)
#' flux_fitting(co2_conc, conc, datetime, fit_type = "exp_zhao18")
#' flux_fitting(co2_conc, conc, datetime,  fit_type = "quadratic",
#' t_zero = 10, end_cut = 30)
#' @export

flux_fitting <- function(conc_df,
                         f_conc = f_conc,
                         f_datetime = f_datetime,
                         f_start = f_start,
                         f_end = f_end,
                         f_fluxid = f_fluxid,
                         fit_type = "exp_zhao18",
                         start_cut = 0,
                         end_cut = 0,
                         t_zero = 0,
                         cut_direction = "none",
                         cz_window = 15,
                         b_window = 10,
                         a_window = 10,
                         roll_width = 15) {

  name_df <- as_label(enquo(conc_df))

  args_ok <- flux_fun_check(list(
    start_cut = start_cut,
    end_cut = end_cut
  ),
  fn = list(is.numeric, is.numeric),
  msg = rep("has to be numeric", 2))

  conc_df_check <- conc_df |>
    select(
      {{f_conc}},
      {{f_start}},
      {{f_end}},
      {{f_datetime}}
    )

  conc_df_ok <- flux_fun_check(conc_df_check,
                               fn = list(
                                 is.numeric,
                                 is.POSIXct,
                                 is.POSIXct,
                                 is.POSIXct
                               ),
                               msg = rep(c(
                                 "has to be numeric",
                                 "has to be POSIXct"
                               ),
                               c(1, 3)
                               ),
                               name_df = name_df)


  if (any(!c(args_ok, conc_df_ok)))
    stop("Please correct the arguments", call. = FALSE)

  cut_direction <- match.arg(cut_direction, c("none", "from_start", "from_end"))

  length_flux_max <- conc_df |>
    mutate(
      length_flux = int_length(interval({{f_start}}, {{f_end}}))
    ) |>
    select("length_flux") |>
    max()



  if (
    cut_direction == "none" &&
      (start_cut + end_cut) >= length_flux_max
  ) {
    stop(
      "You cannot cut more than the length of the measurements!"
    )
  }

  if (cut_direction == "from_start") {
    if (end_cut >= length_flux_max) {
      stop(
        "You cannot cut more than the length of the measurements!"
      )
    }
    if (end_cut <= start_cut) {
      stop(
        "end_cut cannot be smaller than start_cut"
      )
    }
  }

  if (cut_direction == "from_end") {
    if (start_cut >= length_flux_max) {
      stop(
        "You cannot cut more than the length of the measurements!"
      )
    }
    if (start_cut <= end_cut) {
      stop(
        "start_cut cannot be smaller than end_cut"
      )
    }
  }

  conc_df <- conc_df |>
    group_by({{f_fluxid}}) |>
    distinct({{f_datetime}}, .keep_all = TRUE) |>
    ungroup()

  fit_type <- flux_fit_type(
    conc_df,
    fit_type = fit_type
  )

  name_conc <- names(select(conc_df, {{f_conc}}))


  conc_df <- conc_df |>
    mutate(
      f_time = difftime({{f_datetime}}[seq_along({{f_datetime}})],
        {{f_datetime}}[1],
        units = "secs"
      ),
      f_time = as.double(.data$f_time),
      f_start_og = {{f_start}},
      {{f_start}} := if (cut_direction %in% c("none", "from_start")) {
        .data$f_start_og + start_cut
      } else if (cut_direction == "from_end") {
        {{f_end}} - start_cut
      },
      {{f_end}} := if (cut_direction %in% c("none", "from_end")) {
        {{f_end}} - end_cut
      } else if (cut_direction == "from_start") {
        .data$f_start_og + end_cut
      },
      f_cut = case_when(
        {{f_datetime}} < {{f_start}} | {{f_datetime}} >= {{f_end}}
        ~ "cut",
        .default = "keep"
      ),
      f_time_diff = difftime({{f_start}}, .data$f_start_og, units = "secs"),
      f_time_diff = as.double(.data$f_time_diff),
      f_cut = as_factor(.data$f_cut),
      f_n_conc = sum(!is.na(.data[[name_conc]])),
      .by = {{f_fluxid}}
    ) |>
    select(!"f_start_og")

  conc_df_cut <- conc_df |>
    filter(
      .data$f_cut == "keep"
    ) |>
    drop_na({{f_conc}}) |>
    mutate(
      f_time_cut = difftime({{f_datetime}}[seq_along({{f_datetime}})],
        {{f_datetime}}[1],
        units = "secs"
      ),
      f_time_cut = as.double(.data$f_time_cut),
      f_length_window = max(.data$f_time_cut),
      f_length_flux = difftime({{f_end}}, {{f_start}}, units = "sec"),
      f_start_window = min({{f_datetime}}),
      f_n_conc_cut = sum(!is.na(.data[[name_conc]])),
      .by = {{f_fluxid}}
    )

  conc_fitting <- flux_fitting_lm(
    conc_df_cut,
    conc_df,
    {{f_conc}},
    {{f_fluxid}}
  )

  if (fit_type != "linear") {
    conc_df_lm <- conc_fitting |>
      rename(
        f_slope_lm = "f_slope",
        f_fit_lm = "f_fit",
        f_intercept_lm = "f_intercept",
        f_rsquared_lm = "f_rsquared",
        f_adj_rsquared_lm = "f_adj_rsquared",
        f_pvalue_lm = "f_pvalue"
      )
  }

  if (fit_type == "exp_zhao18") {
    conc_fitting <- flux_fitting_zhao18(
      conc_df_cut,
      conc_df_lm,
      {{f_conc}},
      {{f_start}},
      {{f_fluxid}},
      cz_window = cz_window,
      b_window = b_window,
      a_window = a_window,
      roll_width = roll_width
    )
  }

  if (fit_type == "exp_tz") {
    conc_fitting <- flux_fitting_exptz(
      conc_df_cut,
      conc_df_lm,
      {{f_conc}},
      {{f_start}},
      {{f_fluxid}},
      t_zero = t_zero,
      cz_window = cz_window,
      b_window = b_window,
      a_window = a_window,
      roll_width = roll_width
    )
  }

  if (fit_type == "exp_hm") {
    conc_fitting <- flux_fitting_hm(
      conc_df_cut,
      conc_df_lm,
      {{f_conc}},
      {{f_start}},
      {{f_fluxid}},
      t_zero = t_zero,
      cz_window = cz_window,
      b_window = b_window,
      roll_width = roll_width
    )
  }


  if (fit_type == "quadratic") {
    conc_fitting <- flux_fitting_quadratic(
      conc_df_cut,
      conc_df_lm,
      {{f_conc}},
      {{f_start}},
      {{f_fluxid}},
      t_zero = t_zero
    )
  }



  warning_msg <- conc_fitting |>
    select(
      {{f_fluxid}}, "f_n_conc", "f_slope"
    ) |>
    distinct() |>
    left_join(conc_df_cut,
      by = join_by(
        {{f_fluxid}} == {{f_fluxid}},
        "f_n_conc" == "f_n_conc"
      )
    ) |> # we want f_n_conc after cut
    select(
      {{f_fluxid}}, "f_n_conc", "f_n_conc_cut", "f_length_flux", "f_slope"
    ) |>
    distinct() |>
    mutate(
      slope_na = paste(
        "\n", "fluxID", {{f_fluxid}},
        ": slope is NA, most likely an issue with the model optimization.
        Check your data or use a different model."
      ),
      low_data = paste(
        "\n", "fluxID", {{f_fluxid}}, ": slope was estimated on",
        .data$f_n_conc_cut, "points out of", .data$f_length_flux,
        "seconds"
      ),
      no_data = paste(
        "\n", "fluxID", {{f_fluxid}},
        "dropped (no data in the conc column)"
      ),
      warnings = case_when(
        .data$f_n_conc == 0 ~ .data$no_data,
        is.na(.data$f_slope) ~ .data$slope_na,
        .data$f_n_conc_cut != .data$f_length_flux ~ .data$low_data
      ),
      warnings = as.character(.data$warnings)
    ) |>
    drop_na(warnings) |>
    pull(.data$warnings)

  warnings <- str_c(warning_msg)

  if (any(!is.na(warnings))) warning(warnings)

  conc_fitting <- conc_fitting |>
    select(!c("f_n_conc", "f_time_diff"))

  attr(conc_fitting, "fit_type") <- fit_type

  conc_fitting
}
