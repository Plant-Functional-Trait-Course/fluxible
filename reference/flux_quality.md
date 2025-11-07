# Assessing the quality of the fits

Indicates if the slopes provided by
[flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md)
should be discarded or replaced by 0 according to quality thresholds set
by user

## Usage

``` r
flux_quality(
  slopes_df,
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
  kappamax = FALSE
)
```

## Arguments

- slopes_df:

  dataset containing slopes

- f_conc:

  column containing the measured gas concentration (exponential fits)

- f_fluxid:

  column containing unique IDs for each flux

- f_slope:

  column containing the slope of each flux (as calculated by the
  [flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md)
  function)

- f_time:

  column containing the time of each measurement in seconds (exponential
  fits)

- f_start:

  column with datetime of the start of the measurement (after cuts)

- f_end:

  column with datetime of the end of the measurement (after cuts)

- f_fit:

  column containing the modeled data (exponential fits)

- f_cut:

  column containing the cutting information

- f_pvalue:

  column containing the p-value of each flux (linear and quadratic fits)

- f_rsquared:

  column containing the r squared of each flux (linear and quadratic
  fits)

- f_slope_lm:

  column containing the linear slope of each flux (as calculated by the
  [flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md)
  function)

- f_fit_lm:

  column with the fit of the linear model. (as calculated by the
  [flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md)
  function)

- f_b:

  column containing the b parameter of the exponential expression
  (exponential fits)

- force_discard:

  vector of fluxIDs that should be discarded by the user's decision

- force_ok:

  vector of fluxIDs for which the user wants to keep the calculated
  slope despite a bad quality flag

- force_zero:

  vector of fluxIDs that should be replaced by zero by the user's
  decision

- force_lm:

  vector of fluxIDs for which the linear slope should be used by the
  user's decision

- force_exp:

  vector of fluxIDs for which the exponential slope should be used by
  the user's decision (kappamax method)

- ratio_threshold:

  ratio of gas concentration data points over length of measurement (in
  seconds) below which the measurement will be considered as not having
  enough data points to be considered for calculations

- gfactor_threshold:

  threshold for the g-factor. Defines a window with its opposite outside
  which the flux will be flagged `discard` (exponential quadratic fits).

- fit_type:

  model fitted to the data, linear, quadratic or exponential. Will be
  automatically filled if `slopes_df` was produced using
  [flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md)

- ambient_conc:

  ambient gas concentration in ppm at the site of measurement (used to
  detect measurement that started with a polluted setup)

- error:

  error of the setup, defines a window outside of which the starting
  values indicate a polluted setup

- pvalue_threshold:

  threshold of p-value below which the change of gas concentration over
  time is considered not significant (linear and quadratic fits)

- rsquared_threshold:

  threshold of r squared value below which the linear model is
  considered an unsatisfactory fit (linear and quadratic fits)

- rmse_threshold:

  threshold for the RMSE of each flux above which the fit is considered
  unsatisfactory (exponential fits)

- cor_threshold:

  threshold for the correlation coefficient of gas concentration with
  time below which the correlation is considered not significant
  (exponential fits)

- b_threshold:

  threshold for the b parameter. Defines a window with its opposite
  inside which the fit is considered good enough (exponential fits)

- cut_arg:

  argument defining that the data point should be cut out

- instr_error:

  error of the instrument, in the same unit as the gas concentration

- kappamax:

  logical. If `TRUE` the kappamax method will be applied.

## Value

a dataframe with added columns of quality flags (`f_quality_flag`), the
slope corrected according to the quality flags (`f_slope_corr`), and any
columns present in the input. It will also print a summary of the
quality flags. This summary can also be exported as a dataframe using
[flux_flag_count](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_flag_count.md)

## Details

the kappamax method (Hüppi et al., 2018) selects the linear slope if
\|b\| \> kappamax, with kappamax = \|f_slope_lm / instr_error\|. The
original kappamax method was applied to the HMR model (Pedersen et al.,
2010; Hutchinson and Mosier, 1981), but here it can be applied to any
exponential fit.

## References

Pedersen, A.R., Petersen, S.O., Schelde, K., 2010. A comprehensive
approach to soil-atmosphere trace-gas flux estimation with static
chambers. European Journal of Soil Science 61, 888–902.
https://doi.org/10.1111/j.1365-2389.2010.01291.x

Hüppi, R., Felber, R., Krauss, M., Six, J., Leifeld, J., Fuß, R., 2018.
Restricting the nonlinearity parameter in soil greenhouse gas flux
calculation for more reliable flux estimates. PLOS ONE 13, e0200876.
https://doi.org/10.1371/journal.pone.0200876

Hutchinson, G.L., Mosier, A.R., 1981. Improved Soil Cover Method for
Field Measurement of Nitrous Oxide Fluxes. Soil Science Society of
America Journal 45, 311–316.

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
flux_quality(slopes, conc)
#> 
#>  Total number of measurements: 6
#> 
#>  ok   3   50 %
#>  discard      2   33 %
#>  zero     1   17 %
#>  force_discard    0   0 %
#>  start_error      0   0 %
#>  no_data      0   0 %
#>  force_ok     0   0 %
#>  force_zero   0   0 %
#>  force_lm     0   0 %
#>  no_slope     0   0 %
#> # A tibble: 1,251 × 36
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
#> # ℹ 29 more variables: f_start <dttm>, f_end <dttm>, f_fluxid <fct>,
#> #   f_ratio <dbl>, f_flag_match <chr>, f_time <dbl>, f_cut <fct>,
#> #   f_rsquared_lm <dbl>, f_adj_rsquared_lm <dbl>, f_slope_lm <dbl>,
#> #   f_intercept_lm <dbl>, f_pvalue_lm <dbl>, f_fit_lm <dbl>, f_Cz <dbl>,
#> #   f_Cm <dbl>, f_a <dbl>, f_b <dbl>, f_tz <dbl>, f_slope <dbl>, f_fit <dbl>,
#> #   f_fit_slope <dbl>, f_start_z <dttm>, f_min_slope <dbl>, f_cor_coef <dbl>, …
```
