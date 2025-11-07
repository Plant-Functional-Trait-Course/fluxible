# CO2 concentration with missing data

CO2 concentration with measurements meta data and missing data in the
middle of the measurements

## Usage

``` r
co2_conc_mid_missing
```

## Format

A tibble with 1251 rows and 13 variables

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

- f_n_conc:

  Number of data point per flux.

- f_ratio:

  Ratio of n_conc over length of the measurement (in seconds).

- f_flag_match:

  Data quality flags.

## Examples

``` r
co2_conc_mid_missing
#> # A tibble: 1,251 × 13
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
#> 10 2022-07-28 23:43:44    NA         NA     NA  NA    156 AN2C 156 ER   
#> # ℹ 1,241 more rows
#> # ℹ 6 more variables: f_start <dttm>, f_end <dttm>, f_fluxid <fct>,
#> #   f_n_conc <dbl>, f_ratio <dbl>, f_flag_match <chr>
```
