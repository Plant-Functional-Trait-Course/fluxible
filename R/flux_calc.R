#' Calculates ecosystem gas fluxes
#' @description Calculates a flux based on the rate of change
#' of gas concentration over time
#' @param slopes_df dataframe of flux slopes
#' @param slope_col column containing the slope to calculate the flux
#' @param f_datetime column containing the datetime of each gas concentration
#' measurements in `slopes_df`. The first one after cutting will be kept as
#' datetime of each flux in the output.
#' @param conc_unit unit in which the concentration of gas was measured
#' `mmol/mol`, `ppm`, `ppb`, or `ppt`
#' @param flux_unit desired units for the calculated fluxes. Has to be of the
#' form amount/surface/time. Amount can be `mol`, `mmol`, `umol`, `nmol` or
#' `pmol`. Time can be `d` (day), `h` (hour), `mn` (minute) or `s` (seconds).
#' Surface can be `m2`, `dm2` or `cm2`.
#' @param f_cut column containing cutting information
#' @param keep_arg name in `f_cut` of data to keep
#' @param chamber_volume `r lifecycle::badge("deprecated")` see `setup_volume`
#' @param tube_volume `r lifecycle::badge("deprecated")` see `setup_volume`
#' @param setup_volume volume of the flux chamber and instrument together in L,
#' can also be a column in case it is a variable
#' @param atm_pressure atmospheric pressure in atm,
#' can be a constant (numerical) or a variable (column name)
#' @param plot_area area of the plot in m^2,
#' can also be a column in case it is a variable
#' @param cols_keep columns to keep from the input to the output.
#' Those columns need to have unique values for each flux,
#' as \link[dplyr:distinct]{distinct} is applied.
#' @param cols_ave columns with values that should be averaged
#' for each flux in the output. Note that NA are removed in mean calculation.
#' Those columns will get the `_ave` suffix in the output.
#' @param cols_sum columns with values for which is sum is provided
#' for each flux in the output. Those columns will get the `_sum` suffix in the
#' output.
#' @param cols_med columns with values for which is median is provided
#' for each flux in the output. Note that NA are removed in median calculation.
#' Those columns will get the `_med` suffix in the output.
#' @param cols_nest columns to nest in `nested_variables` for each flux in the
#' output. Can be character vector of column names, `"none"` (default) selects
#' none, or `"all"` selects all the column except those in `cols_keep`.
#' @param f_fluxid column containing the flux IDs
#' @param temp_air_col column containing the air temperature used
#' to calculate fluxes. Will be averaged with NA removed.
#' @param temp_air_unit units in which air temperature was measured.
#' Has to be either `celsius` (default), `fahrenheit` or `kelvin.`
#' @param cut if 'TRUE' (default), the measurements will be cut according to
#' 'f_cut' before calculating fluxes. This has no influence on the flux itself
#' since the slope is provided from \link[fluxible:flux_fitting]{flux_fitting},
#' but it will influence the values of the variables in `cols_ave`, `cols_cum`,
#' and `cols_med`.
#' @param fit_type (optional) model used in
#' \link[fluxible:flux_fitting]{flux_fitting}. Will be automatically filled if
#' `slopes_df` was produced using \link[fluxible:flux_fitting]{flux_fitting}.
#' @return a dataframe containing flux IDs, datetime of measurements' starts,
#' fluxes (`f_flux`) in the units defined with `flux_unit`, temperature average
#' for each flux in the same unit as the input (`f_temp_ave`), the model used in
#' \link[fluxible:flux_fitting]{flux_fitting}, any column specified in
#' `cols_keep`, any column specified in `cols_ave`, `cols_med` or `cols_sum`
#' with their values treated accordingly over the measurement after cuts, and a
#' column `nested_variables` with the variables specified in `cols_nest`.
#' @importFrom rlang .data := enquo quo_is_symbolic as_label
#' @importFrom dplyr select group_by summarise rename_with nest_by
#' ungroup mutate case_when distinct left_join across everything
#' @importFrom tidyselect any_of
#' @importFrom stats median
#' @importFrom lifecycle deprecated deprecate_stop deprecate_warn
#' @examples
#' data(co2_conc)
#' slopes <- flux_fitting(co2_conc, conc, datetime, fit_type = "exp_zhao18")
#' flux_calc(slopes,
#' f_slope,
#' datetime,
#' temp_air,
#' conc_unit = "ppm",
#' flux_unit = "mmol/m2/h",
#' setup_volume = 24.575,
#' atm_pressure = 1,
#' plot_area = 0.0625)
#' @export



flux_calc <- function(slopes_df,
                      slope_col,
                      f_datetime = f_datetime,
                      temp_air_col,
                      chamber_volume = deprecated(),
                      setup_volume,
                      atm_pressure,
                      plot_area,
                      f_fluxid = f_fluxid,
                      conc_unit,
                      flux_unit,
                      cols_keep = c(),
                      cols_ave = c(),
                      cols_sum = c(),
                      cols_med = c(),
                      cols_nest = "none",
                      tube_volume = deprecated(),
                      temp_air_unit = "celsius",
                      f_cut = f_cut,
                      keep_arg = "keep",
                      cut = TRUE,
                      fit_type = c()) {

  if (is_present(chamber_volume)) {
    deprecate_stop(
      when = "1.2.2",
      what = "flux_calc(chamber_volume)",
      with = "flux_calc(setup_volume)"
    )
  }

  if (is_present(tube_volume)) {
    deprecate_stop(
      when = "1.2.2",
      what = "flux_calc(tube_volume)",
      with = "flux_calc(setup_volume)"
    )
  }

  if (flux_unit == "mmol") {
    deprecate_warn(
      when = "1.2.4",
      "flux_calc(flux_unit = 'should be in the form amount/surface/time')"
    )

    flux_unit <- "mmol/m2/h"
  }


  if (flux_unit == "micromol") {
    deprecate_warn(
      when = "1.2.4",
      "flux_calc(flux_unit = 'should be in the form amount/surface/time')"
    )

    flux_unit <- "umol/m2/h"
  }

  name_df <- as_label(enquo(slopes_df))

  colnames <- colnames(slopes_df)
  if (length(setdiff(cols_keep, colnames)) > 0) {
    stop("some names in cols_keep cannot be found in slopes_df")
  }
  if (length(setdiff(cols_ave, colnames)) > 0) {
    stop("some names in cols_ave cannot be found in slopes_df")
  }


  slopes_df_check <- slopes_df |>
    select(
      {{slope_col}},
      {{temp_air_col}},
      {{f_datetime}}
    )

  df_ok <- flux_fun_check(slopes_df_check,
                          fn = list(
                            is.numeric,
                            is.numeric,
                            is.POSIXct
                          ),
                          msg = rep(c(
                            "has to be numeric",
                            "has to be POSIXct"
                          ),
                          c(2, 1)
                          ),
                          name_df = name_df)


  if (any(!df_ok))
    stop("Please correct the arguments", call. = FALSE)

  flux_coeff <- flux_units(flux_unit, conc_unit)

  if (length(cols_nest) == 1 && cols_nest == "all") {
    cols_nest <- slopes_df |>
      select(!c(
        {{cols_keep}}
      )) |>
      names()
  }

  if (length(cols_nest) == 1 && cols_nest == "none") {
    cols_nest <- c()
  }


  fit_type <- flux_fit_type(
    slopes_df,
    fit_type = fit_type
  )

  kappamax <- attributes(slopes_df)$kappamax

  if (is.null(kappamax)) {
    kappamax <- FALSE
  }

  if (kappamax) {
    cols_keep <- c(cols_keep, "f_model")
  }

  temp_air_unit <- match.arg(
    temp_air_unit,
    c("celsius", "fahrenheit", "kelvin")
  )


  if (cut) {
    message("Cutting data according to 'keep_arg'...")
    slopes_df <- flux_cut(
      slopes_df,
      {{f_cut}},
      keep_arg
    )
  }


  name_vol <- as_label(enquo(setup_volume))
  name_atm <- as_label(enquo(atm_pressure))
  name_plot <- as_label(enquo(plot_area))

  message("Averaging air temperature for each flux...")
  slope_temp <- slopes_df |>
    select(
      {{f_fluxid}},
      {{temp_air_col}},
      {{f_datetime}},
      {{slope_col}},
      any_of(c(name_vol, name_atm, name_plot))
    ) |>
    summarise(
      f_temp_air_ave = mean({{temp_air_col}}, na.rm = TRUE),
      f_atm_pressure_ave = mean({{atm_pressure}}, na.rm = TRUE),
      {{f_datetime}} := min({{f_datetime}}),
      .by = c(
        {{f_fluxid}}, {{slope_col}}, any_of(c(name_vol, name_plot))
      )
    ) |>
    mutate(
      f_temp_air_ave = case_when(
        temp_air_unit == "celsius" ~ .data$f_temp_air_ave + 273.15,
        temp_air_unit == "fahrenheit"
        ~ (.data$f_temp_air_ave + 459.67) * (5 / 9),
        temp_air_unit == "kelvin" ~ .data$f_temp_air_ave
      )
    )

  # a df with all the columns we just want to keep and join back in the end
  if (length(cols_keep) > 0) {
    message("Creating a df with the columns from 'cols_keep' argument...")
    slope_keep <- slopes_df |>
      select(all_of(cols_keep), {{f_fluxid}}) |>
      distinct() |>
      left_join(slope_temp, by = join_by(
        {{f_fluxid}} == {{f_fluxid}}
      ))
  } else {
    slope_keep <- slope_temp
  }

  # a df with the columns that have to be averaged
  if (length(cols_ave) > 0) {
    message("Creating a df with the columns from 'cols_ave' argument...")
    slope_ave <- slopes_df |>
      select(all_of(cols_ave), {{f_fluxid}}) |>
      summarise(across(
        everything(),
        ~ mean(.x, na.rm = TRUE)
      ),
      .by = {{f_fluxid}}
      ) |>
      left_join(slope_keep, by = join_by(
        {{f_fluxid}} == {{f_fluxid}}
      )) |>
      rename_with(~paste0(.x, "_ave"), all_of(cols_ave))
  } else {
    slope_ave <- slope_keep
  }

  if (length(cols_sum) > 0) {
    message("Creating a df with the columns from 'cols_sum' argument...")
    slope_sum <- slopes_df |>
      select(all_of(cols_sum), {{f_fluxid}}) |>
      summarise(across(
        everything(),
        ~ sum(.x, na.rm = TRUE)
      ),
      .by = {{f_fluxid}}
      ) |>
      left_join(slope_ave, by = join_by(
        {{f_fluxid}} == {{f_fluxid}}
      )) |>
      rename_with(~paste0(.x, "_sum"), all_of(cols_sum))
  } else {
    slope_sum <- slope_ave
  }

  if (length(cols_med) > 0) {
    message("Creating a df with the columns from 'cols_med' argument...")
    slope_med <- slopes_df |>
      select(all_of(cols_med), {{f_fluxid}}) |>
      summarise(across(
        everything(),
        ~ median(.x, na.rm = TRUE)
      ),
      .by = {{f_fluxid}}
      ) |>
      left_join(slope_sum, by = join_by(
        {{f_fluxid}} == {{f_fluxid}}
      )) |>
      rename_with(~paste0(.x, "_med"), all_of(cols_med))
  } else {
    slope_med <- slope_sum
  }


  message("Calculating fluxes...")

  r_const <- 0.082057
  message("R constant set to 0.082057 L * atm * K^-1 * mol^-1")

  message(paste("Concentration was measured in", conc_unit))


  fluxes <- slope_med |>
    mutate(
      f_flux =
        ({{slope_col}} * .data$f_atm_pressure_ave * {{setup_volume}})
        / (r_const *
           .data$f_temp_air_ave
           * {{plot_area}}), # flux in micromol/s/m^2
      f_flux = .data$f_flux * flux_coeff, # converting to desired unit
      f_temp_air_ave = case_when(
        temp_air_unit == "celsius" ~ .data$f_temp_air_ave - 273.15,
        temp_air_unit == "fahrenheit"
        ~ (.data$f_temp_air_ave - 273.15) * (9 / 5) + 32,
        temp_air_unit == "kelvin" ~ .data$f_temp_air_ave
      ),
      .by = {{f_fluxid}}
    )

  if (!quo_is_symbolic(enquo(atm_pressure))) {
    fluxes <- fluxes |>
      select(!"f_atm_pressure_ave")
  }

  if (length(cols_nest) > 0) {
    message("Creating a df with the columns from 'cols_nest' argument...")
    slope_nest <- slopes_df |>
      select(all_of(cols_nest), {{f_fluxid}}) |>
      nest_by(
        {{f_fluxid}}, .key = "nested_variables"
      ) |>
      left_join(fluxes, by = join_by(
        {{f_fluxid}} == {{f_fluxid}}
      ))
    fluxes <- slope_nest
  }

  if (isTRUE(kappamax)) {
    fluxes <- fluxes |>
      mutate(
        f_model = .data$f_model
      )
  } else {
    fluxes <- fluxes |>
      mutate(
        f_model = fit_type
      )
  }


  message(
    paste0("Fluxes are in ", flux_unit)
  )

  fluxes

}
