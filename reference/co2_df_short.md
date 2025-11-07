# CO2 concentration

Continuous CO2 concentration as measured on the field

## Usage

``` r
co2_df_short
```

## Format

A tibble with 1801 rows and 5 variables

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

## Examples

``` r
co2_df_short
#> # A tibble: 1,801 × 5
#>    datetime            temp_air temp_soil  conc   PAR
#>    <dttm>                 <dbl>     <dbl> <dbl> <dbl>
#>  1 2022-07-28 23:40:00    NA         NA    471. NA   
#>  2 2022-07-28 23:40:01    NA         NA    472. NA   
#>  3 2022-07-28 23:40:02    NA         NA    472. NA   
#>  4 2022-07-28 23:40:03    NA         NA    473. NA   
#>  5 2022-07-28 23:40:04    NA         NA    474. NA   
#>  6 2022-07-28 23:40:05    NA         NA    475. NA   
#>  7 2022-07-28 23:40:06     7.08      11.1  475.  2.44
#>  8 2022-07-28 23:40:07    NA         NA    476. NA   
#>  9 2022-07-28 23:40:08    NA         NA    476. NA   
#> 10 2022-07-28 23:40:09    NA         NA    477. NA   
#> # ℹ 1,791 more rows
```
