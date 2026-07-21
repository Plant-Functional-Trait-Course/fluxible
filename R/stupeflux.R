#' From raw gas concentration over time to clean fluxes
#' @description Wrapper function for the Fluxible workflow. We recommend using
#' the step-by-step workflow for more control over the process.
#' @param raw_conc dataframe of CO2 concentration measured continuously.
#' Has to contain at least a datetime column in ymd_hms format and
#' a gas concentration column as double.
#' @param field_record dataframe recording which measurement happened when.
#' Has to contain at least a column containing the start of each measurement,
#' and any other column identifying the measurements.
#' @param measurement_length length of the measurement (in seconds)
#' from the start specified in the field_record
#' @param time_diff time difference (in seconds) between the two datasets.
#' Will be added to the datetime column of the raw_conc dataset.
#' For situations where the time was not synchronized correctly.
#' @param f_datetime datetime column in raw_conc (dmy_hms format). Supply as
#' a bare (unquoted) column name (e.g. `datetime`), not a string.
#' @param f_conc concentration column in raw_conc. Supply as a bare
#' (unquoted) column name (e.g. `conc`), not a string.
#' @param start_col start column in field_record (dmy_hms format). Supply as a
#' bare (unquoted) column name (e.g. `start`), not a string.
#' @param end_col end column in field_record (`ymd_hms` format). Supply as a
#' bare (unquoted) column name (e.g. `end`), not a string.
#' @param fit_type `exp_zhao18`, `exp_tz`, `exp_hm`, `quadratic` or `linear.`
#' `exp_zhao18` is using the exponential model
#' \ifelse{html}{\out{C(t) = C_m + a (t - t_z) + (C_z - C_m) exp(-b (t - t_z))}}{\eqn{C(t) = C_m + a (t - t_z) + (C_z - C_m) \exp(-b (t - t_z))}{ASCII}}
#' from Zhao et al (2018).
#' `expt_tz` is a modified version which allows the user to fix `t_zero`:
#' \ifelse{html}{\out{C(t) = C_m + a * t + (C_z - C_m) exp(-b * t)}}{\eqn{C(t) = C_m + a * t + (C_z - C_m) \exp(-b * t)}{ASCII}}
#' `exp_hm` is using the HM model
#' (Pedersen et al., 2010; Hutchinson and Mosier, 1981)
#' \ifelse{html}{\out{C(t) = C_m + (C_z - C_m) exp(-b * t)}}{\eqn{C(t) = C_m + (C_z - C_m) \exp(-b * t)}{ASCII}}
#' @param cz_window window used to calculate Cz, at the beginning of cut window
#' (`exp_zhao18` and `exp_tz` fits)
#' @param b_window window to estimate b. It is an interval after tz where
#' it is assumed that the model fits the data perfectly
#' (`exp_zhao18` and `exp_tz` fits)
#' @param a_window window at the end of the flux to estimate a
#' (`exp_zhao18` and `exp_tz` fits)
#' @param roll_width width of the rolling mean for CO2 when looking for tz,
#' ideally same as cz_window (`exp_zhao18` and `exp_tz` fits)
#' @param start_cut time to discard at the start of the measurements
#' (in seconds)
#' @param end_cut time to discard at the end of the measurements (in seconds)
#' @param t_zero time at which the slope should be calculated
#' (for `quadratic` and `exp_tz` fits)
#' @param ambient_conc ambient gas concentration in ppm at the site of
#' measurement (used to detect measurement that started with a polluted setup)
#' @param error error of the setup, defines a window outside of which
#' the starting values indicate a polluted setup
#' @param force_discard vector of fluxIDs that should be discarded
#' by the user's decision
#' @param force_ok vector of fluxIDs for which the user wants to keep
#' the calculated slope despite a bad quality flag
#' @param force_zero vector of fluxIDs that should be replaced by zero by
#' the user's decision
#' @param ratio_threshold ratio of gas concentration data points over length of
#' measurement (in seconds) below which the measurement will be considered as
#' not having enough data points to be considered for calculations
#' @param pvalue_threshold threshold of p-value below which the change of
#' gas concentration over time is considered not significant
#' (linear and quadratic fit)
#' @param rsquared_threshold threshold of r squared value below which
#' the linear model is considered an unsatisfactory fit
#' (linear and quadratic fit)
#' @param rmse_threshold threshold for the RMSE of each flux above which
#' the fit is considered unsatisfactory (`exp_zhao18` and `exp_tz` fits)
#' @param cor_threshold threshold for the correlation coefficient of
#' gas concentration with time below which the correlation
#' is considered not significant (`exp_zhao18` and `exp_tz` fits)
#' @param b_threshold threshold for the b parameter.
#' Defines a window with its opposite inside which the fit is
#' considered good enough (`exp_zhao18` and `exp_tz` fits)
#' @param slope_correction logical. If `TRUE`, the flux will be calculated with
#' the slope corrected according to the recommendations of the quality flags.
#' @param conc_unit unit in which the concentration of gas was measured
#' `ppm` or `ppb`
#' @param flux_unit unit in which the calculated flux will be
#' `mmol` outputs fluxes in
#' \ifelse{html}{\out{mmol * m<sup>-2</sup> * h<sup>-1</sup>}}{\eqn{mmol*m^{-2}*h^{-1}}{ASCII}};
#' `micromol` outputs fluxes in
#' \ifelse{html}{\out{micromol * m<sup>-2</sup> * h<sup>-1</sup>}}{\eqn{micromol*m^{-2}*h^{-1}}{ASCII}}
#' @param setup_volume volume of the flux chamber and instrument together in L,
#' can also be a column in case it is a variable
#' @param atm_pressure atmospheric pressure,
#' can be a constant (numerical) or a variable (column name)
#' @param plot_area area of the plot in m^2,
#' can also be a column in case it is a variable
#' @param cols_keep columns to keep from the input to the output.
#' Those columns need to have unique values for each flux,
#' as distinct() is applied.
#' @param cols_ave columns with values that should be averaged
#' for each flux in the output. Note that NA are removed in mean calculation.
#' @param cols_sum columns with values for which is sum is provided
#' for each flux in the output. Note that NA are removed in sum calculation.
#' @param cols_med columns with values for which is median is provided
#' for each flux in the output. Note that NA are removed in median calculation.
#' @param temp_air_col column containing the air temperature used
#' to calculate fluxes. Will be averaged with NA removed.
#' @param temp_air_unit units in which air temperature was measured.
#' Has to be either `celsius` (default), `fahrenheit` or `kelvin.`
#' @param cut if 'TRUE' (default), the measurements will be cut according to
#' 'f_cut' before calculating fluxes. This has no influence on the flux itself
#' since the slope is provided from \link[fluxible:flux_fitting]{flux_fitting},
#' but it will influence the values of the columns in `cols_ave`.
#' @return a dataframe containing flux IDs, datetime of measurements' starts,
#' fluxes in
#' \ifelse{html}{\out{mmol * m<sup>-2</sup> * h<sup>-1</sup>}}{\eqn{mmol*m^{-2}*h^{-1}}{ASCII}}
#' or
#' \ifelse{html}{\out{micromol * m<sup>-2</sup> * h<sup>-1</sup>}}{\eqn{micromol*m^{-2}*h^{-1}}{ASCII}}
#' (`f_flux`) according to `flux_unit`, temperature average for each flux in
#' Kelvin (`f_temp_ave`), the total volume of the setup for each measurement
#' (`f_volume_setup`), the model used in
#' \link[fluxible:flux_fitting]{flux_fitting}, any column specified in
#' `cols_keep`, any column specified in `cols_ave` with
#' their value averaged over the measurement after cuts and discarding NA.
#' @references Pedersen, A.R., Petersen, S.O., Schelde, K., 2010.
#' A comprehensive approach to soil-atmosphere trace-gas flux estimation with
#' static chambers. European Journal of Soil Science 61, 888–902.
#' https://doi.org/10.1111/j.1365-2389.2010.01291.x
#' @references Hutchinson, G.L., Mosier, A.R., 1981. Improved Soil Cover Method
#' for Field Measurement of Nitrous Oxide Fluxes.
#' Soil Science Society of America Journal 45, 311–316.
#' https://doi.org/10.2136/sssaj1981.03615995004500020017x
#' @references Zhao, P., Hammerle, A., Zeeman, M., Wohlfahrt, G., 2018.
#' On the calculation of daytime CO2 fluxes measured by automated closed
#' transparent chambers. Agricultural and Forest Meteorology 263, 267–275.
#' https://doi.org/10.1016/j.agrformet.2018.08.022
#' @examples
#' data(co2_df_short)
#' data(record_short)
#' stupeflux(
#' raw_conc = co2_df_short,
#' field_record = record_short,
#' f_datetime = datetime,
#' start_col = start,
#' f_conc = conc,
#' measurement_length = 180,
#' fit_type = "exp_zhao18",
#' temp_air_col = temp_air,
#' conc_unit = "ppm",
#' flux_unit = "mmol",
#' setup_volume = 24.575,
#' atm_pressure = 1,
#' plot_area = 0.0625
#' )
#' @export

stupeflux <- function(raw_conc,
                      field_record,
                      f_datetime,
                      start_col,
                      end_col,
                      f_conc,
                      setup_volume,
                      measurement_length,
                      fit_type,
                      temp_air_col,
                      atm_pressure,
                      plot_area,
                      conc_unit,
                      flux_unit,
                      cols_keep = c(),
                      cols_ave = c(),
                      cols_sum = c(),
                      cols_med = c(),
                      ratio_threshold = 0.5,
                      time_diff = 0,
                      start_cut = 0,
                      end_cut = 0,
                      cz_window = 15,
                      b_window = 10,
                      a_window = 10,
                      roll_width = 15,
                      t_zero = 0,
                      force_discard = c(),
                      force_ok = c(),
                      force_zero = c(),
                      ambient_conc = 421,
                      error = 100,
                      pvalue_threshold = 0.3,
                      rsquared_threshold = 0.7,
                      rmse_threshold = 25,
                      cor_threshold = 0.5,
                      b_threshold = 1,
                      temp_air_unit = "celsius",
                      cut = TRUE,
                      slope_correction = TRUE) {
  conc_df <- flux_match(
    raw_conc,
    field_record,
    f_datetime = {{f_datetime}},
    start_col = {{start_col}},
    end_col = {{end_col}},
    measurement_length = measurement_length,
    time_diff = time_diff
  )

  check_bare_col(enquo(f_datetime), "f_datetime")
  check_bare_col(enquo(start_col), "start_col")
  check_bare_col(enquo(end_col), "end_col")
  check_bare_col(enquo(f_conc), "f_conc")
  check_bare_col(enquo(temp_air_col), "temp_air_col")

  conc_fitting <- flux_fitting(
    conc_df,
    {{f_conc}},
    {{f_datetime}},
    start_cut = start_cut,
    end_cut = end_cut,
    cz_window = cz_window,
    b_window = b_window,
    a_window = a_window,
    roll_width = roll_width,
    t_zero = t_zero,
    fit_type = fit_type
  )

  quality_flag <- flux_quality(
    conc_fitting,
    {{f_conc}},
    force_discard = force_discard,
    force_ok = force_ok,
    force_zero = force_zero,
    ratio_threshold = ratio_threshold,
    ambient_conc = ambient_conc,
    error = error,
    pvalue_threshold = pvalue_threshold,
    rsquared_threshold = rsquared_threshold,
    rmse_threshold = rmse_threshold,
    cor_threshold = cor_threshold,
    b_threshold = b_threshold
  )

  if (slope_correction == TRUE) {
    fluxes <- with(quality_flag, flux_calc(
      quality_flag,
      slope_col = f_slope_corr,
      {{f_datetime}},
      {{temp_air_col}},
      atm_pressure = atm_pressure,
      plot_area = plot_area,
      conc_unit = conc_unit,
      flux_unit = flux_unit,
      cols_keep = cols_keep,
      cols_ave = cols_ave,
      cols_sum = cols_sum,
      cols_med = cols_med,
      setup_volume = setup_volume,
      temp_air_unit = temp_air_unit,
      cut = cut
    ))
  }

  if (slope_correction == FALSE) {
    fluxes <- with(quality_flag, flux_calc(
      quality_flag,
      slope_col = f_slope,
      {{f_datetime}},
      {{temp_air_col}},
      atm_pressure = atm_pressure,
      plot_area = plot_area,
      conc_unit = conc_unit,
      flux_unit = flux_unit,
      cols_keep = cols_keep,
      cols_ave = cols_ave,
      setup_volume = setup_volume,
      temp_air_unit = temp_air_unit,
      cut = cut
    ))
  }

  fluxes

}
