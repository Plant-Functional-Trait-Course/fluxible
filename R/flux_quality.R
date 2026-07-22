#' Assessing the quality of the fits
#' @description Indicates if the slopes provided by
#' \link[fluxible:flux_fitting]{flux_fitting} should be discarded or replaced
#' by 0 according to quality thresholds set by user
#' @param slopes_df dataset containing slopes
#' @param fit_type model fitted to the data, linear, quadratic or exponential.
#' Will be automatically filled if `slopes_df` was produced using
#' \link[fluxible:flux_fitting]{flux_fitting}
#' @param ambient_conc ambient gas concentration in ppm at the site of
#' measurement (used to detect measurement that started with a polluted setup)
#' @param error error on the ambient concentration, defines a window outside of
#' which the starting values indicate a polluted setup
#' @param f_fluxid column containing unique IDs for each flux. Supply as a
#' bare (unquoted) column name (e.g. `f_fluxid`), not a string.
#' @param f_slope column containing the slope of each flux (as calculated by the
#' \link[fluxible:flux_fitting]{flux_fitting} function). Supply as a bare
#' (unquoted) column name (e.g. `f_slope`), not a string.
#' @param f_slope_lm column containing the linear slope of each flux (as
#' calculated by the \link[fluxible:flux_fitting]{flux_fitting} function).
#' Supply as a bare (unquoted) column name (e.g. `f_slope_lm`), not a string.
#' @param force_discard vector of fluxIDs that should be discarded
#' by the user's decision
#' @param force_ok vector of fluxIDs for which the user wants to keep
#' the calculated slope despite a bad quality flag
#' @param force_zero vector of fluxIDs that should be replaced by zero by
#' the user's decision
#' @param force_lm vector of fluxIDs for which the linear slope should be used
#' by the user's decision
#' @param force_exp vector of fluxIDs for which the exponential slope should be
#' used by the user's decision (kappamax method)
#' @param ratio_threshold ratio of gas concentration data points over length of
#' measurement (in seconds) below which the measurement will be considered as
#' not having enough data points to be considered for calculations
#' @param f_pvalue column containing the p-value of each flux (linear and
#' quadratic fits). Supply as a bare (unquoted) column name (e.g. `f_pvalue`),
#' not a string.
#' @param f_rsquared column containing the r squared of each flux (linear and
#' quadratic fits). Supply as a bare (unquoted) column name (e.g.
#' `f_rsquared`), not a string.
#' @param pvalue_threshold threshold of p-value below which the change of
#' gas concentration over time is considered not significant
#' (linear and quadratic fits)
#' @param rsquared_threshold threshold of r squared value below which
#' the linear model is considered an unsatisfactory fit
#' (linear and quadratic fits)
#' @param f_conc column containing the measured gas concentration (exponential
#' fits). Supply as a bare (unquoted) column name (e.g. `conc`), not a string.
#' @param f_b column containing the b parameter of the exponential expression
#' (exponential fits). Supply as a bare (unquoted) column name (e.g. `f_b`),
#' not a string.
#' @param f_time column containing the time of each measurement in seconds
#' (exponential fits). Supply as a bare (unquoted) column name (e.g.
#' `f_time`), not a string.
#' @param f_start column with datetime of the start of the measurement
#' (after cuts). Supply as a bare (unquoted) column name (e.g. `f_start`), not
#' a string.
#' @param f_end column with datetime of the end of the measurement (after
#' cuts). Supply as a bare (unquoted) column name (e.g. `f_end`), not a
#' string.
#' @param f_fit column containing the modeled data (exponential fits). Supply
#' as a bare (unquoted) column name (e.g. `f_fit`), not a string.
#' @param rmse_threshold threshold for the RMSE of each flux above which
#' the fit is considered unsatisfactory (exponential fits)
#' @param cor_threshold threshold for the correlation coefficient of
#' gas concentration with time below which the correlation
#' is considered not significant (exponential fits)
#' @param f_cut column containing the cutting information. Supply as a bare
#' (unquoted) column name (e.g. `f_cut`), not a string.
#' @param cut_arg argument defining that the data point should be cut out
#' @param b_threshold threshold for the b parameter.
#' Defines a window with its opposite inside which the fit is
#' considered good enough (exponential fits)
#' @param gfactor_threshold threshold for the g-factor. Defines a window
#' with its opposite outside which the flux will be flagged `discard`
#' (exponential quadratic fits).
#' @param kappamax logical. If `TRUE` the kappamax method will be applied.
#' @param instr_error error of the instrument, in the same unit as the
#' gas concentration. Used to detect a flux below the instrument detection
#' capacity.
#' @param f_fit_lm column with the fit of the linear model (as calculated by
#' the \link[fluxible:flux_fitting]{flux_fitting} function). Supply as a bare
#' (unquoted) column name (e.g. `f_fit_lm`), not a string.
#' @details the kappamax method (Hüppi et al., 2018) selects the linear slope if
#' \ifelse{html}{\out{|b| > kappamax}}{\eqn{|b| > kappamax}{ASCII}}, with
#' \ifelse{html}{\out{kappamax = |f_slope_lm / instr_error|}}{\eqn{kappamax = |f_slope_lm / instr_error|}{ASCII}}.
#' The original kappamax method was applied to the HMR model
#' (Pedersen et al., 2010; Hutchinson and Mosier, 1981), but here it can be
#' applied to any exponential fit.
#' @details the `instr_error` and `error` are two different arguments.
#' `instr_error` defines the minimal detectable flux (i. e., when a flux can be
#' considered zero because it is below the instrument detection capacity).
#' `error` is the error applied to `ambient_conc`, the ambient concentration
#' of the measured gas, and defines the window outside of which a measurement
#' is flagged for an error on the start.
#' @references Pedersen, A.R., Petersen, S.O., Schelde, K., 2010.
#' A comprehensive approach to soil-atmosphere trace-gas flux estimation with
#' static chambers. European Journal of Soil Science 61, 888–902.
#' https://doi.org/10.1111/j.1365-2389.2010.01291.x
#' @references Hüppi, R., Felber, R., Krauss, M., Six, J., Leifeld, J., Fuß,
#' R., 2018. Restricting the nonlinearity parameter in soil greenhouse gas
#' flux calculation for more reliable flux estimates.
#' PLOS ONE 13, e0200876. https://doi.org/10.1371/journal.pone.0200876
#' @references Hutchinson, G.L., Mosier, A.R., 1981. Improved Soil Cover Method
#' for Field Measurement of Nitrous Oxide Fluxes.
#' Soil Science Society of America Journal 45, 311–316.
#' @return a dataframe with added columns of quality flags (`f_quality_flag`),
#' the slope corrected according to the quality flags (`f_slope_corr`),
#' and any columns present in the input.
#' It will also print a summary of the quality flags. This summary can also
#' be exported as a dataframe using
#' \link[fluxible:flux_flag_count]{flux_flag_count}
#' @importFrom dplyr mutate case_when group_by rowwise summarise ungroup
#' @importFrom tidyr nest unnest
#' @importFrom stats cor
#' @importFrom lubridate int_length interval
#' @importFrom stringr str_detect
#' @examples
#' data(co2_conc)
#' slopes <- flux_fitting(co2_conc, conc, datetime, fit_type = "exp_zhao18")
#' flux_quality(slopes, conc)
#' @export

flux_quality <- function(slopes_df,
                         f_conc = f_conc,
                         f_fluxid = f_fluxid,
                         f_slope = f_slope,
                         f_time = f_time,
                         f_start = f_start,
                         f_end = f_end,
                         f_fit = f_fit,
                         f_cut = f_cut,
                         f_pvalue = f_pvalue,
                         f_rsquared = f_rsquared,
                         f_slope_lm = f_slope_lm,
                         f_fit_lm = f_fit_lm,
                         f_b = f_b,
                         force_discard = c(),
                         force_ok = c(),
                         force_zero = c(),
                         force_lm = c(),
                         force_exp = c(),
                         ratio_threshold = 0.5,
                         gfactor_threshold = 10,
                         fit_type = c(),
                         ambient_conc = 421,
                         error = 100,
                         pvalue_threshold = 0.3,
                         rsquared_threshold = 0.7,
                         rmse_threshold = 25,
                         cor_threshold = 0.5,
                         b_threshold = 1,
                         cut_arg = "cut",
                         instr_error = 5,
                         kappamax = FALSE) {

  name_df <- as_label(enquo(slopes_df))

  check_bare_col(enquo(f_conc), "f_conc")
  check_bare_col(enquo(f_slope), "f_slope")
  check_bare_col(enquo(f_slope_lm), "f_slope_lm")
  check_bare_col(enquo(f_fit), "f_fit")
  check_bare_col(enquo(f_time), "f_time")
  check_bare_col(enquo(f_start), "f_start")
  check_bare_col(enquo(f_end), "f_end")
  check_bare_col(enquo(f_cut), "f_cut")
  check_bare_col(enquo(f_pvalue), "f_pvalue")
  check_bare_col(enquo(f_rsquared), "f_rsquared")
  check_bare_col(enquo(f_b), "f_b")
  check_bare_col(enquo(f_fit_lm), "f_fit_lm")

  args_ok <- flux_fun_check(list(
    ambient_conc = ambient_conc,
    error = error,
    ratio_threshold = ratio_threshold
  ),
  fn = list(is.numeric, is.numeric, is.numeric),
  msg = rep("has to be numeric", 3))

  slopes_df_check <- slopes_df |>
    select(
      {{f_slope}},
      {{f_conc}},
      {{f_fit}},
      {{f_time}}
    )

  df_ok <- flux_fun_check(slopes_df_check,
                          fn = list(
                            is.numeric,
                            is.numeric,
                            is.numeric,
                            is.numeric
                          ),
                          msg = rep(
                            "has to be numeric",
                            4
                          ),
                          name_df = name_df)


  if (any(!c(args_ok, df_ok)))
    stop("Please correct the arguments", call. = FALSE)


  fit_type <- flux_fit_type(
    slopes_df,
    fit_type = fit_type
  )

  if (fit_type == "linear" && kappamax == TRUE) {
    stop("You cannot use kappamax with a linear fit.")
  }

  if (fit_type == "quadratic" && kappamax == TRUE) {
    stop("You cannot use kappamax with a quadratic fit.")
  }


  name_conc <- names(select(slopes_df, {{f_conc}}))



  quality_par_start <- slopes_df |>
    # for the start error we take the entire flux into account
    group_by({{f_fluxid}}) |>
    nest() |>
    rowwise() |>
    summarise(
      f_start_error = case_when(
        # mean of the 3 first data points
        abs(mean(data[[name_conc]][1:3], na.rm = TRUE) - ambient_conc) > error
        ~ "error",
        TRUE ~ "ok"
      ),
      .groups = "drop"
    ) |>
    unnest({{f_fluxid}})

  slopes_df <- slopes_df |>
    left_join(quality_par_start, by = join_by({{f_fluxid}}))


  slopes_keep <- slopes_df |>
    filter(
      {{f_cut}} != cut_arg
    ) |>
    mutate(
      f_n_conc = sum(!is.na(.data[[name_conc]])),
      f_ratio = .data$f_n_conc / int_length(interval({{f_start}}, {{f_end}})),
      f_flag_ratio = case_when(
        .data$f_ratio == 0 ~ "no_data",
        .data$f_ratio <= ratio_threshold ~ "too_low",
        TRUE ~ "ok"
      ),
      f_min_slope = (2 * instr_error) / max({{f_time}}),
      .by = c({{f_fluxid}}, {{f_cut}})
    )

  slopes_cut <- slopes_df |>
    filter(
      {{f_cut}} == cut_arg
    )


  if (kappamax == TRUE) {
    slopes_keep <- flux_quality_kappamax(
      slopes_keep,
      f_slope = {{f_slope}},
      f_fluxid = {{f_fluxid}},
      f_fit = {{f_fit}},
      f_slope_lm = {{f_slope_lm}},
      f_fit_lm = {{f_fit_lm}},
      f_b = {{f_b}},
      force_exp = force_exp,
      fit_type = fit_type,
      instr_error = instr_error,
      name_df = name_df
    )

    quality_flag_lm <- slopes_keep |>
      filter(.data$f_model == "linear")

    quality_flag_exp <- slopes_keep |>
      filter(str_detect(.data$f_model, "exp"))

    if (nrow(quality_flag_lm) > 0) {
      quality_flag_lm <- flux_quality_lm(
        slopes_df = quality_flag_lm,
        f_fluxid = {{f_fluxid}},
        f_slope = {{f_slope}},
        f_pvalue = {{f_pvalue}},
        f_rsquared = {{f_rsquared}},
        force_discard = force_discard,
        force_ok = force_ok,
        force_zero = force_zero,
        pvalue_threshold = pvalue_threshold,
        rsquared_threshold = rsquared_threshold,
        name_df = name_df
      )
    }

    if (nrow(quality_flag_exp) > 0) {
      quality_flag_exp <- flux_quality_exp(
        quality_flag_exp,
        {{f_conc}},
        {{f_fluxid}},
        {{f_slope}},
        {{f_time}},
        {{f_fit}},
        {{f_slope_lm}},
        {{f_b}},
        force_discard = force_discard,
        force_ok = force_ok,
        force_zero = force_zero,
        force_lm = force_lm,
        gfactor_threshold = gfactor_threshold,
        rmse_threshold = rmse_threshold,
        cor_threshold = cor_threshold,
        b_threshold = b_threshold,
        name_df = name_df
      )
    }

    quality_flag <- bind_rows(quality_flag_exp, quality_flag_lm) |>
      arrange({{f_fluxid}})
  }

  if (str_detect(fit_type, "exp") && kappamax == FALSE) {
    quality_flag <- flux_quality_exp(
      slopes_keep,
      {{f_conc}},
      {{f_fluxid}},
      {{f_slope}},
      {{f_time}},
      {{f_fit}},
      {{f_slope_lm}},
      {{f_b}},
      force_discard = force_discard,
      force_ok = force_ok,
      force_zero = force_zero,
      force_lm = force_lm,
      gfactor_threshold = gfactor_threshold,
      rmse_threshold = rmse_threshold,
      cor_threshold = cor_threshold,
      b_threshold = b_threshold,
      name_df = name_df
    )
  }

  if (fit_type == "quadratic" && kappamax == FALSE) {
    quality_flag <- flux_quality_qua(slopes_keep,
      {{f_fluxid}},
      {{f_slope}},
      {{f_pvalue}},
      {{f_rsquared}},
      {{f_slope_lm}},
      force_discard = force_discard,
      force_ok = force_ok,
      force_zero = force_zero,
      force_lm = force_lm,
      gfactor_threshold = gfactor_threshold,
      pvalue_threshold = pvalue_threshold,
      rsquared_threshold = rsquared_threshold,
      name_df = name_df
    )
  }


  if (fit_type == "linear") {
    quality_flag <- flux_quality_lm(slopes_keep,
      {{f_fluxid}},
      {{f_slope}},
      {{f_pvalue}},
      {{f_rsquared}},
      force_discard = force_discard,
      force_ok = force_ok,
      force_zero = force_zero,
      pvalue_threshold = pvalue_threshold,
      rsquared_threshold = rsquared_threshold,
      name_df = name_df
    )
  }

  flag_count <- flux_flag_count(
    quality_flag,
    f_fluxid = {{f_fluxid}},
    show_total = FALSE
  )

  flag_msg <- flag_count |>
    mutate(
      message = paste(
        "\n", .data$f_quality_flag, "\t", .data$n,
        "\t", round(.data$ratio, 2) * 100, "%"
      )
    ) |>
    pull(message)

  total_nb <- quality_flag |>
    select({{f_fluxid}}) |>
    distinct() |>
    nrow()

  message(paste("\n", "Total number of measurements:", total_nb))
  message(flag_msg)

  quality_flag <- bind_rows(quality_flag, slopes_cut) |>
    arrange({{f_fluxid}}, {{f_time}})

  attr(quality_flag, "fit_type") <- {{fit_type}}

  quality_flag
}
