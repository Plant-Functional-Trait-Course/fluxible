# Fitting a model to concentration data and estimating the slope

Fits gas concentration over time data with a model (exponential,
quadratic or linear) and provides the slope later used to calculate gas
fluxes with
[flux_calc](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_calc.md)

## Usage

``` r
flux_fitting(
  conc_df,
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
  roll_width = 15
)
```

## Arguments

- conc_df:

  dataframe of gas concentration over time

- f_conc:

  column with gas concentration data

- f_datetime:

  column with datetime of each concentration measurement Note that if
  there are duplicated datetime in the same `f_fluxid` only the first
  row will be kept

- f_start:

  column with datetime when the measurement started (`ymd_hms`)

- f_end:

  column with datetime when the measurement ended (`ymd_hms`)

- f_fluxid:

  column with ID of each flux

- fit_type:

  `exp_zhao18`, `exp_tz`, `exp_hm`, `quadratic` or `linear.`
  `exp_zhao18` is using the exponential model C(t) = C_m + a (t - t_z) +
  (C_z - C_m) exp(-b (t - t_z)) from Zhao et al (2018). `expt_tz` is a
  modified version which allows the user to fix `t_zero`: C(t) = C_m + a
  \* t + (C_z - C_m) exp(-b \* t) `exp_hm` is using the HM model
  (Pedersen et al., 2010; Hutchinson and Mosier, 1981) C(t) = C_m +
  (C_z - C_m) exp(-b \* t) `exponential` is equal to `exp_zhao18`, for
  backwards compatibility

- start_cut:

  time to discard at the start of the measurements (in seconds)

- end_cut:

  time to discard at the end of the measurements (in seconds)

- t_zero:

  time at which the slope should be calculated (for `quadratic`,
  `exp_tz` and `exp_hm` fits)

- cut_direction:

  `"none"` (default) means that the focus window is
  `f_start + start_cut` to `f_end - end_cut`; `"from_start"` makes it
  `f_start + start_cut` to `f_start + end_cut`; `"from_end"` makes it
  `f_end - start_cut` to `f_end - end_cut`. Bug fix since v1.3.4:
  `"from_start"` was doing `f_start` + `start_cut` to `f_start` +
  `start_cut` + `end_cut`

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

  width of the rolling mean for gas concentration when looking for `tz`,
  ideally same as `cz_window` (`exp_zhao18` and `exp_tz` fits)

## Value

a dataframe with the slope at t zero (`f_slope`), a datetime column of t
zero (`f_start_z`), a factor column indicating the cuts (`f_cut`), the
time in seconds since the start of the measurement (`f_time`), the
modeled fit (`f_fit`), the modeled slope (`f_fit_slope`), the parameters
of the fit depending on the model used, and any columns present in the
input. The type of fit is added as an attribute for use by the other
functions.

## References

Pedersen, A.R., Petersen, S.O., Schelde, K., 2010. A comprehensive
approach to soil-atmosphere trace-gas flux estimation with static
chambers. European Journal of Soil Science 61, 888-902.
https://doi.org/10.1111/j.1365-2389.2010.01291.x

Hutchinson, G.L., Mosier, A.R., 1981. Improved Soil Cover Method for
Field Measurement of Nitrous Oxide Fluxes. Soil Science Society of
America Journal 45, 311-316.
https://doi.org/10.2136/sssaj1981.03615995004500020017x

Zhao, P., Hammerle, A., Zeeman, M., Wohlfahrt, G., 2018. On the
calculation of daytime CO2 fluxes measured by automated closed
transparent chambers. Agricultural and Forest Meteorology 263, 267-275.
https://doi.org/10.1016/j.agrformet.2018.08.022

## Examples

``` r
data(co2_conc)
flux_fitting(co2_conc, conc, datetime, fit_type = "exp_zhao18")
#> Cutting measurements...
#> Estimating starting parameters for optimization...
#> Optimizing fitting parameters...
#> Calculating fits and slopes...
#> Done.
#> Warning: 
#>  fluxID 5 : slope was estimated on 205 points out of 210 seconds
#>  fluxID 6 : slope was estimated on 206 points out of 210 seconds
#> # A tibble: 1,251 × 29
#>    datetime            temp_air temp_soil  conc   PAR turfID       type 
#>    <dttm>                 <dbl>     <dbl> <dbl> <dbl> <fct>        <fct>
#>  1 2022-07-28 23:43:35    NA         NA    447. NA    156 AN2C 156 ER   
#>  2 2022-07-28 23:43:36     7.22      10.9  447.  1.68 156 AN2C 156 ER   
#>  3 2022-07-28 23:43:37    NA         NA    448. NA    156 AN2C 156 ER   
#>  4 2022-07-28 23:43:38    NA         NA    449. NA    156 AN2C 156 ER   
#>  5 2022-07-28 23:43:39    NA         NA    449. NA    156 AN2C 156 ER   
#>  6 2022-07-28 23:43:40    NA         NA    450. NA    156 AN2C 156 ER   
#>  7 2022-07-28 23:43:41    NA         NA    451. NA    156 AN2C 156 ER   
#>  8 2022-07-28 23:43:42    NA         NA    451. NA    156 AN2C 156 ER   
#>  9 2022-07-28 23:43:43    NA         NA    453. NA    156 AN2C 156 ER   
#> 10 2022-07-28 23:43:44    NA         NA    453. NA    156 AN2C 156 ER   
#> # ℹ 1,241 more rows
#> # ℹ 22 more variables: f_start <dttm>, f_end <dttm>, f_fluxid <fct>,
#> #   f_ratio <dbl>, f_flag_match <chr>, f_time <dbl>, f_cut <fct>,
#> #   f_rsquared_lm <dbl>, f_adj_rsquared_lm <dbl>, f_slope_lm <dbl>,
#> #   f_intercept_lm <dbl>, f_pvalue_lm <dbl>, f_fit_lm <dbl>, f_Cz <dbl>,
#> #   f_Cm <dbl>, f_a <dbl>, f_b <dbl>, f_tz <dbl>, f_slope <dbl>, f_fit <dbl>,
#> #   f_fit_slope <dbl>, f_start_z <dttm>
flux_fitting(co2_conc, conc, datetime,  fit_type = "quadratic",
t_zero = 10, end_cut = 30)
#> # A tibble: 1,251 × 30
#>    datetime            temp_air temp_soil  conc   PAR turfID       type 
#>    <dttm>                 <dbl>     <dbl> <dbl> <dbl> <fct>        <fct>
#>  1 2022-07-28 23:43:35    NA         NA    447. NA    156 AN2C 156 ER   
#>  2 2022-07-28 23:43:36     7.22      10.9  447.  1.68 156 AN2C 156 ER   
#>  3 2022-07-28 23:43:37    NA         NA    448. NA    156 AN2C 156 ER   
#>  4 2022-07-28 23:43:38    NA         NA    449. NA    156 AN2C 156 ER   
#>  5 2022-07-28 23:43:39    NA         NA    449. NA    156 AN2C 156 ER   
#>  6 2022-07-28 23:43:40    NA         NA    450. NA    156 AN2C 156 ER   
#>  7 2022-07-28 23:43:41    NA         NA    451. NA    156 AN2C 156 ER   
#>  8 2022-07-28 23:43:42    NA         NA    451. NA    156 AN2C 156 ER   
#>  9 2022-07-28 23:43:43    NA         NA    453. NA    156 AN2C 156 ER   
#> 10 2022-07-28 23:43:44    NA         NA    453. NA    156 AN2C 156 ER   
#> # ℹ 1,241 more rows
#> # ℹ 23 more variables: f_start <dttm>, f_end <dttm>, f_fluxid <fct>,
#> #   f_ratio <dbl>, f_flag_match <chr>, f_time <dbl>, f_cut <fct>,
#> #   f_rsquared_lm <dbl>, f_adj_rsquared_lm <dbl>, f_slope_lm <dbl>,
#> #   f_intercept_lm <dbl>, f_pvalue_lm <dbl>, f_fit_lm <dbl>, f_param1 <dbl>,
#> #   f_param2 <dbl>, f_rsquared <dbl>, f_adj_rsquared <dbl>, f_intercept <dbl>,
#> #   f_pvalue <dbl>, f_slope <dbl>, f_fit <dbl>, f_fit_slope <dbl>, …
```
