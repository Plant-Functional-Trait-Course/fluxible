# Calculates ecosystem gas fluxes

Calculates a flux based on the rate of change of gas concentration over
time

## Usage

``` r
flux_calc(
  slopes_df,
  slope_col,
  f_datetime = f_datetime,
  temp_air_col,
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
  temp_air_unit = "celsius",
  f_cut = f_cut,
  keep_arg = "keep",
  cut = TRUE,
  fit_type = c()
)
```

## Arguments

- slopes_df:

  dataframe of flux slopes

- slope_col:

  column containing the slope to calculate the flux. Supply as a bare
  (unquoted) column name (e.g. `f_slope`), not a string; this function
  uses tidy-evaluation with `{{ }}`.

- f_datetime:

  column containing the datetime of each gas concentration measurements
  in `slopes_df`. The first one after cutting will be kept as datetime
  of each flux in the output. Supply as a bare (unquoted) column name
  (e.g. `datetime`), not a string.

- temp_air_col:

  column containing the air temperature used to calculate fluxes. Will
  be averaged with NA removed. Supply as a bare (unquoted) column name
  (e.g. `temp_air`), not a string.

- setup_volume:

  volume of the flux chamber and instrument together in L, can also be a
  column in case it is a variable

- atm_pressure:

  atmospheric pressure in atm, can be a constant (numerical) or a
  variable (column name)

- plot_area:

  area of the plot in m^2, can also be a column in case it is a variable

- f_fluxid:

  column containing the flux IDs. Supply as a bare (unquoted) column
  name (e.g. `f_fluxid`), not a string.

- conc_unit:

  unit in which the concentration of gas was measured `mmol/mol`, `ppm`,
  `ppb`, or `ppt`

- flux_unit:

  desired units for the calculated fluxes. Has to be of the form
  amount/surface/time. Amount can be `mol`, `mmol`, `umol`, `nmol` or
  `pmol`. Time can be `d` (day), `h` (hour), `mn` (minute) or `s`
  (seconds). Surface can be `m2`, `dm2` or `cm2`.

- cols_keep:

  columns to keep from the input to the output. Those columns need to
  have unique values for each flux, as
  [distinct](https://dplyr.tidyverse.org/reference/distinct.html) is
  applied.

- cols_ave:

  columns with values that should be averaged for each flux in the
  output. Note that NA are removed in mean calculation. Those columns
  will get the `_ave` suffix in the output.

- cols_sum:

  columns with values for which is sum is provided for each flux in the
  output. Those columns will get the `_sum` suffix in the output.

- cols_med:

  columns with values for which is median is provided for each flux in
  the output. Note that NA are removed in median calculation. Those
  columns will get the `_med` suffix in the output.

- cols_nest:

  columns to nest in `nested_variables` for each flux in the output. Can
  be character vector of column names, `"none"` (default) selects none,
  or `"all"` selects all the column except those in `cols_keep`.

- temp_air_unit:

  units in which air temperature was measured. Has to be either
  `celsius` (default), `fahrenheit` or `kelvin.`

- f_cut:

  column containing cutting information. Supply as a bare (unquoted)
  column name (e.g. `f_cut`), not a string.

- keep_arg:

  name in `f_cut` of data to keep

- cut:

  if 'TRUE' (default), the measurements will be cut according to 'f_cut'
  before calculating fluxes. This has no influence on the flux itself
  since the slope is provided from
  [flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md),
  but it will influence the values of the variables in `cols_ave`,
  `cols_cum`, and `cols_med`.

- fit_type:

  (optional) model used in
  [flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md).
  Will be automatically filled if `slopes_df` was produced using
  [flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md).

## Value

a dataframe containing flux IDs, datetime of measurements' starts,
fluxes (`f_flux`) in the units defined with `flux_unit`, temperature
average for each flux in the same unit as the input (`f_temp_ave`), the
model used in
[flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md),
any column specified in `cols_keep`, any column specified in `cols_ave`,
`cols_med` or `cols_sum` with their values treated accordingly over the
measurement after cuts, and a column `nested_variables` with the
variables specified in `cols_nest`.

## See also

for transforming the gas concentration into volumetric units before
fitting, see
[flux_conc](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_conc.md)

## Examples

``` r
data(co2_conc)
slopes <- flux_fitting(co2_conc, conc, datetime, fit_type = "exp_zhao18")
#> Cutting measurements...
#> Estimating starting parameters for optimization...
#> Optimizing fitting parameters...
#> Calculating fits and slopes...
#> Done.
#> Warning: 
#>  fluxID 5 : slope was estimated on 205 points out of 210 seconds
#>  fluxID 6 : slope was estimated on 206 points out of 210 seconds
flux_calc(slopes,
f_slope,
datetime,
temp_air,
conc_unit = "ppm",
flux_unit = "mmol/m2/h",
setup_volume = 24.575,
atm_pressure = 1,
plot_area = 0.0625)
#> Cutting data according to 'keep_arg'...
#> Averaging air temperature for each flux...
#> Calculating fluxes...
#> Concentration was measured in ppm
#> R constant set to 0.082057 L * atm * K^-1 * mol^-1
#> Fluxes are in mmol/m2/h
#> # A tibble: 6 × 6
#>   f_fluxid f_slope f_temp_air_ave datetime            f_flux f_model   
#>   <fct>      <dbl>          <dbl> <dttm>               <dbl> <chr>     
#> 1 1          1.56            7.31 2022-07-28 23:43:35   95.6 exp_zhao18
#> 2 2          0.853           7.38 2022-07-28 23:47:22   52.4 exp_zhao18
#> 3 3          0.303           7.46 2022-07-28 23:52:10   18.6 exp_zhao18
#> 4 4          1.13            7.77 2022-07-28 23:59:32   69.4 exp_zhao18
#> 5 5          1.46            7.71 2022-07-29 00:03:10   89.9 exp_zhao18
#> 6 6          0.426           7.75 2022-07-29 00:06:35   26.2 exp_zhao18
conc_vol <- flux_conc(co2_conc, conc, temp_air)
#> R constant set to 0.082057 L * atm * K^-1 * mol^-1
slopes_vol <- flux_fitting(conc_vol, conc, datetime, fit_type = "exp_zhao18")
#> Cutting measurements...
#> Estimating starting parameters for optimization...
#> Optimizing fitting parameters...
#> Calculating fits and slopes...
#> Done.
#> Warning: 
#>  fluxID 5 : slope was estimated on 205 points out of 210 seconds
#>  fluxID 6 : slope was estimated on 206 points out of 210 seconds
flux_calc(slopes_vol,
f_slope,
datetime,
temp_air,
conc_unit = "umol/l",
flux_unit = "mmol/m2/h",
setup_volume = 24.575,
atm_pressure = 1,
plot_area = 0.0625)
#> Cutting data according to 'keep_arg'...
#> Averaging air temperature for each flux...
#> Calculating fluxes...
#> Concentration was measured in umol/l
#> Fluxes are in mmol/m2/h
#> # A tibble: 6 × 7
#>   f_fluxid f_slope f_temp_air_ave f_atm_pressure_ave datetime            f_flux
#>   <fct>      <dbl>          <dbl>              <dbl> <dttm>               <dbl>
#> 1 1          1.56            7.31                  1 2022-07-28 23:43:35  2201.
#> 2 2          0.853           7.38                  1 2022-07-28 23:47:22  1207.
#> 3 3          0.303           7.46                  1 2022-07-28 23:52:10   429.
#> 4 4          1.13            7.77                  1 2022-07-28 23:59:32  1599.
#> 5 5          1.46            7.71                  1 2022-07-29 00:03:10  2071.
#> 6 6          0.426           7.75                  1 2022-07-29 00:06:35   603.
#> # ℹ 1 more variable: f_model <chr>
```
