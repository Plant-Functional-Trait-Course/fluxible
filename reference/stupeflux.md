# From raw gas concentration over time to clean fluxes

Wrapper function for the Fluxible workflow. We recommend using the
step-by-step workflow for more control over the process.

## Usage

``` r
stupeflux(
  raw_conc,
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
  slope_correction = TRUE
)
```

## Arguments

- raw_conc:

  dataframe of CO2 concentration measured continuously. Has to contain
  at least a datetime column in ymd_hms format and a gas concentration
  column as double.

- field_record:

  dataframe recording which measurement happened when. Has to contain at
  least a column containing the start of each measurement, and any other
  column identifying the measurements.

- f_datetime:

  datetime column in raw_conc (dmy_hms format)

- start_col:

  start column in field_record (dmy_hms format)

- end_col:

  end column in field_record (`ymd_hms` format)

- f_conc:

  concentration column in raw_conc

- setup_volume:

  volume of the flux chamber and instrument together in L, can also be a
  column in case it is a variable

- measurement_length:

  length of the measurement (in seconds) from the start specified in the
  field_record

- fit_type:

  `exp_zhao18`, `exp_tz`, `exp_hm`, `quadratic` or `linear.`
  `exp_zhao18` is using the exponential model C(t) = C_m + a (t - t_z) +
  (C_z - C_m) exp(-b (t - t_z)) from Zhao et al (2018). `expt_tz` is a
  modified version which allows the user to fix `t_zero`: C(t) = C_m + a
  \* t + (C_z - C_m) exp(-b \* t) `exp_hm` is using the HM model
  (Pedersen et al., 2010; Hutchinson and Mosier, 1981) C(t) = C_m +
  (C_z - C_m) exp(-b \* t)

- temp_air_col:

  column containing the air temperature used to calculate fluxes. Will
  be averaged with NA removed.

- atm_pressure:

  atmospheric pressure, can be a constant (numerical) or a variable
  (column name)

- plot_area:

  area of the plot in m^2, can also be a column in case it is a variable

- conc_unit:

  unit in which the concentration of gas was measured `ppm` or `ppb`

- flux_unit:

  unit in which the calculated flux will be `mmol` outputs fluxes in
  mmol \* m⁻² \* h⁻¹; `micromol` outputs fluxes in micromol \* m⁻² \*
  h⁻¹

- cols_keep:

  columns to keep from the input to the output. Those columns need to
  have unique values for each flux, as distinct() is applied.

- cols_ave:

  columns with values that should be averaged for each flux in the
  output. Note that NA are removed in mean calculation.

- cols_sum:

  columns with values for which is sum is provided for each flux in the
  output. Note that NA are removed in sum calculation.

- cols_med:

  columns with values for which is median is provided for each flux in
  the output. Note that NA are removed in median calculation.

- ratio_threshold:

  ratio of gas concentration data points over length of measurement (in
  seconds) below which the measurement will be considered as not having
  enough data points to be considered for calculations

- time_diff:

  time difference (in seconds) between the two datasets. Will be added
  to the datetime column of the raw_conc dataset. For situations where
  the time was not synchronized correctly.

- start_cut:

  time to discard at the start of the measurements (in seconds)

- end_cut:

  time to discard at the end of the measurements (in seconds)

- cz_window:

  window used to calculate Cz, at the beginning of cut window
  (`exp_zhao18` and `exp_tz` fits)

- b_window:

  window to estimate b. It is an interval after tz where it is assumed
  that the model fits the data perfectly (`exp_zhao18` and `exp_tz`
  fits)

- a_window:

  window at the end of the flux to estimate a (`exp_zhao18` and `exp_tz`
  fits)

- roll_width:

  width of the rolling mean for CO2 when looking for tz, ideally same as
  cz_window (`exp_zhao18` and `exp_tz` fits)

- t_zero:

  time at which the slope should be calculated (for `quadratic` and
  `exp_tz` fits)

- force_discard:

  vector of fluxIDs that should be discarded by the user's decision

- force_ok:

  vector of fluxIDs for which the user wants to keep the calculated
  slope despite a bad quality flag

- force_zero:

  vector of fluxIDs that should be replaced by zero by the user's
  decision

- ambient_conc:

  ambient gas concentration in ppm at the site of measurement (used to
  detect measurement that started with a polluted setup)

- error:

  error of the setup, defines a window outside of which the starting
  values indicate a polluted setup

- pvalue_threshold:

  threshold of p-value below which the change of gas concentration over
  time is considered not significant (linear and quadratic fit)

- rsquared_threshold:

  threshold of r squared value below which the linear model is
  considered an unsatisfactory fit (linear and quadratic fit)

- rmse_threshold:

  threshold for the RMSE of each flux above which the fit is considered
  unsatisfactory (`exp_zhao18` and `exp_tz` fits)

- cor_threshold:

  threshold for the correlation coefficient of gas concentration with
  time below which the correlation is considered not significant
  (`exp_zhao18` and `exp_tz` fits)

- b_threshold:

  threshold for the b parameter. Defines a window with its opposite
  inside which the fit is considered good enough (`exp_zhao18` and
  `exp_tz` fits)

- temp_air_unit:

  units in which air temperature was measured. Has to be either
  `celsius` (default), `fahrenheit` or `kelvin.`

- cut:

  if 'TRUE' (default), the measurements will be cut according to 'f_cut'
  before calculating fluxes. This has no influence on the flux itself
  since the slope is provided from
  [flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md),
  but it will influence the values of the columns in `cols_ave`.

- slope_correction:

  logical. If `TRUE`, the flux will be calculated with the slope
  corrected according to the recommendations of the quality flags.

## Value

a dataframe containing flux IDs, datetime of measurements' starts,
fluxes in mmol \* m⁻² \* h⁻¹ or micromol \* m⁻² \* h⁻¹ (`f_flux`)
according to `flux_unit`, temperature average for each flux in Kelvin
(`f_temp_ave`), the total volume of the setup for each measurement
(`f_volume_setup`), the model used in
[flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md),
any column specified in `cols_keep`, any column specified in `cols_ave`
with their value averaged over the measurement after cuts and discarding
NA.

## References

Pedersen, A.R., Petersen, S.O., Schelde, K., 2010. A comprehensive
approach to soil-atmosphere trace-gas flux estimation with static
chambers. European Journal of Soil Science 61, 888–902.
https://doi.org/10.1111/j.1365-2389.2010.01291.x

Hutchinson, G.L., Mosier, A.R., 1981. Improved Soil Cover Method for
Field Measurement of Nitrous Oxide Fluxes. Soil Science Society of
America Journal 45, 311–316.
https://doi.org/10.2136/sssaj1981.03615995004500020017x

Zhao, P., Hammerle, A., Zeeman, M., Wohlfahrt, G., 2018. On the
calculation of daytime CO2 fluxes measured by automated closed
transparent chambers. Agricultural and Forest Meteorology 263, 267–275.
https://doi.org/10.1016/j.agrformet.2018.08.022

## Examples

``` r
data(co2_df_short)
data(record_short)
stupeflux(
raw_conc = co2_df_short,
field_record = record_short,
f_datetime = datetime,
start_col = start,
f_conc = conc,
measurement_length = 180,
fit_type = "exp_zhao18",
temp_air_col = temp_air,
conc_unit = "ppm",
flux_unit = "mmol",
setup_volume = 24.575,
atm_pressure = 1,
plot_area = 0.0625
)
#> Cutting measurements...
#> Estimating starting parameters for optimization...
#> Optimizing fitting parameters...
#> Calculating fits and slopes...
#> Done.
#> 
#>  Total number of measurements: 6
#> 
#>  ok   5   83 %
#>  discard      1   17 %
#>  zero     0   0 %
#>  force_discard    0   0 %
#>  start_error      0   0 %
#>  no_data      0   0 %
#>  force_ok     0   0 %
#>  force_zero   0   0 %
#>  force_lm     0   0 %
#>  no_slope     0   0 %
#> Warning: The `flux_unit` argument of `flux_calc()` should be in the form
#> amount/surface/time as of fluxible 1.2.4.
#> ℹ The deprecated feature was likely used in the fluxible package.
#>   Please report the issue at
#>   <https://github.com/Plant-Functional-Trait-Course/fluxible/issues>.
#> Cutting data according to 'keep_arg'...
#> Averaging air temperature for each flux...
#> Calculating fluxes...
#> R constant set to 0.082057 L * atm * K^-1 * mol^-1
#> Concentration was measured in ppm
#> Fluxes are in mmol/m2/h
#> # A tibble: 6 × 7
#>   f_fluxid f_slope_corr f_temp_air_ave f_atm_pressure_ave datetime           
#>   <fct>           <dbl>          <dbl>              <dbl> <dttm>             
#> 1 1               0.817           7.28                  1 2022-07-28 23:43:25
#> 2 2               0.508           7.37                  1 2022-07-28 23:47:12
#> 3 3               0.328           7.44                  1 2022-07-28 23:52:00
#> 4 4               0.703           7.78                  1 2022-07-28 23:59:22
#> 5 5              NA               7.69                  1 2022-07-29 00:03:00
#> 6 6               0.510           7.74                  1 2022-07-29 00:06:25
#> # ℹ 2 more variables: f_flux <dbl>, f_model <chr>
```
