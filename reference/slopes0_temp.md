# Slopes for each flux

Slopes of C(t) for each flux with air temperature in various units.

## Usage

``` r
slopes0_temp
```

## Format

A tibble with 1251 rows and 29 variables

- datetime:

  Datetime at which CO2 concentration was recorded.

- temp_air:

  Air temperature inside the flux chamber in Celsius.

- temp_soil:

  Ground temperature inside the flux chamber in Celsius.

- conc:

  CO2 concentration in ppm.

- PAR:

  Photosynthetically active radiation inside the chamber in
  micromol/s/sqm.

- turfID:

  Unique ID of the turf in which the measurement took place.

- type:

  Type of measurement: ecosystems respiration (ER) or net ecosystem
  exchange (NEE).

- f_start:

  Datetime at which the measurement was started.

- f_end:

  Datetime at which the measurement ended.

- f_fluxid:

  Unique ID for each flux.

- f_ratio:

  Ratio of number of datapoints over length of measurement in seconds.

- f_flag_match:

  Flags from flux_match.

- f_time:

  Time variable of the flux in seconds.

- f_cut:

  Indicating if the measurement should be kept (keep) or discarded
  (cut).

- f_Cz:

  Cz parameter of the C(t) function.

- f_Cm:

  Cm parameter of the C(t) function, calculated by optim() with Cm_est
  as starting point.

- f_a:

  a parameter of the C(t) function, calculated by optim() with a_est as
  starting point.

- f_b:

  b parameter of the C(t) function, calculated by optim() with b_est as
  starting point.

- f_tz:

  tz parameter of the C(t) function, calculated by optim() with tz_est
  as starting point.

- f_slope:

  Slope of C(t) at tz

- f_fit:

  C(t), modeled CO2 concentration as a function of time.

- f_fit_slope:

  Output of linear model of CO2 concentration passing by C(tz) and a
  slope of slope_tz.

- f_start_z:

  Datetime format of tz

- f_cor_coef:

  Correlation coefficient of concentration over time.

- f_RMSE:

  RMSE of the fit.

- f_quality_flag:

  Quality flags according to flux_quality.

- f_slope_corr:

  Slope as advised by quality flags.

- temp_fahr:

  Air temperature inside the flux chamber in Fahrenheit averaged over
  the flux measurement.

- temp_kelvin:

  Air temperature inside the flux chamber in Kelvin averaged over the
  flux measurement.

## Examples

``` r
slopes0_temp
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
#> #   f_ratio <dbl>, f_flag_match <chr>, f_time <dbl>, f_cut <fct>, f_Cz <dbl>,
#> #   f_Cm <dbl>, f_a <dbl>, f_b <dbl>, f_tz <dbl>, f_slope <dbl>, f_fit <dbl>,
#> #   f_fit_slope <dbl>, f_start_z <dttm>, f_cor_coef <dbl>, f_RMSE <dbl>,
#> #   f_quality_flag <chr>, f_slope_corr <dbl>, temp_fahr <dbl>,
#> #   temp_kelvin <dbl>
```
