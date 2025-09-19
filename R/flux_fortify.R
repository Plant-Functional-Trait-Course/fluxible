#' Fortify fluxes for visual evaluation
#' @description Prepares the fluxes for plotting.
#' @param slopes_df dataset containing slopes,
#' with flags produced by \link[fluxible:flux_quality]{flux_quality}
#' @param f_conc column with gas concentration
#' @param f_datetime column with datetime of each data point
#' @param f_ylim_upper y axis upper limit
#' @param f_ylim_lower y axis lower limit
#' @param f_facetid character vector of columns to use as facet IDs. Note that
#' they will be united, and that has to result in a unique facet ID for each
#' measurement. Default is `f_fluxid`
#' @importFrom dplyr select distinct mutate n_distinct
#' @importFrom purrr quietly
#' @importFrom stringr str_detect
#' @importFrom tidyr unite
#' @importFrom forcats fct_reorder
#' @keywords internal

flux_fortify <- function(slopes_df,
                         f_conc,
                         f_datetime,
                         f_ylim_upper,
                         f_ylim_lower,
                         f_facetid,
                         y_text_position) {

  args_ok <- flux_fun_check(list(
    f_ylim_upper = f_ylim_upper,
    f_ylim_lower = f_ylim_lower,
    y_text_position = y_text_position
  ),
  fn = list(is.numeric, is.numeric, is.numeric),
  msg = rep("has to be numeric", 3))

  if (any(!args_ok))
    stop("Please correct the arguments", call. = FALSE)

  fit_type <- flux_fit_type(
    slopes_df
  )

  # making slopes_df as light as possible
  slopes_df <- slopes_df |>
    select(
      {{f_conc}},
      {{f_datetime}},
      all_of(f_facetid),
      any_of(c(
        "f_quality_flag",
        "f_fluxid",
        "f_fit",
        "f_start", "f_pvalue_lm", "f_start_z",
        "f_rsquared", "f_pvalue", "f_fit_slope",
        "f_RMSE", "f_cor_coef", "f_b", "f_gfactor",
        "f_cut", "f_rsquared_lm", "f_fit_lm",
        "f_model"
      ))
    )

  if (
    max(slopes_df[[as_label(enquo(f_conc))]], na.rm = TRUE) > f_ylim_upper
  ) {
    message("Some concentration data points will not be displayed
    because f_ylim_upper is too low.")
  }

  if (max(slopes_df$f_fit, na.rm = TRUE) > f_ylim_upper) {
    message("Part of the fit will not be displayed
    because f_ylim_upper is too low.")
  }

  if (
    min(slopes_df[[as_label(enquo(f_conc))]], na.rm = TRUE) < f_ylim_lower
  ) {
    message("Some concentration data points will not be displayed
    because f_ylim_lower is too high.")
  }

  if (min(slopes_df$f_fit, na.rm = TRUE) < f_ylim_lower) {
    message("Part of the fit will not be displayed
    because f_ylim_lower is too high.")
  }

  flags <- slopes_df |>
    select("f_fluxid", "f_quality_flag") |>
    distinct() |>
    filter(.data$f_quality_flag == "no data") |>
    mutate(
      f_warnings = paste(
        "\n", "fluxID", .data$f_fluxid, "dropped because there is no data"
      ),
      f_warnings = as.character(.data$f_warnings)
    ) |>
    pull(.data$f_warnings)

  f_warnings <- str_c(flags)

  if (any(!is.na(f_warnings))) message(f_warnings)

  slopes_df <- slopes_df |>
    filter(
      (.data$f_quality_flag != "no data") |> replace_na(TRUE)
    )

  # extracting attributes before they get stripped later on
  kappamax <- attr(slopes_df, "kappamax")

  nb_fluxid <- n_distinct(slopes_df$f_fluxid)

  # customize facet ID
  slopes_df <- slopes_df |>
    unite(
      col = "f_facetid",
      all_of(f_facetid),
      sep = " "
    ) |>
    mutate(
      f_facetid = fct_reorder(f_facetid, {{f_datetime}})
    )

  # testing if f_facetid is unique, otherwise facet will make a mess
  nb_fluxid_post <- n_distinct(slopes_df$f_facetid)

  if (nb_fluxid != nb_fluxid_post) {
    stop("Please use a f_facetid that is unique for each measurement")
  }

  if (str_detect(fit_type, "exp")) {
    slopes_params <- flux_fortify_exp(
      slopes_df,
      kappamax = kappamax
    )
  } else if (fit_type == "linear") {
    slopes_params <- flux_fortify_lin(slopes_df)
  } else if (fit_type == "quadratic") {
    slopes_params <- flux_fortify_quadratic(slopes_df)
  } else {
    stop("Unrecognised plot type:", fit_type)
  }

  c(
    slopes_params,
    fit_type = fit_type,
    nb_fluxid = nb_fluxid)
}
