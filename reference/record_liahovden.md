# Measurements meta data at Liahovden

Measurements meta data as recorded on the field at site Liahovden

## Usage

``` r
record_liahovden
```

## Format

A tibble with 138 rows and 3 variables

- turfID:

  Unique ID of the turf in which the measurement took place.

- type:

  Type of measurement: ecosystems respiration (ER) or net ecosystem
  exchange (NEE).

- measurement_round:

  Round of measurement.

- start:

  Datetime at which the measurement was started.

## Examples

``` r
record_liahovden
#> # A tibble: 138 × 4
#>    turfID     type  measurement_round start              
#>    <chr>      <chr>             <dbl> <dttm>             
#>  1 4 AN1C 4   NEE                   1 2022-07-27 05:37:30
#>  2 4 AN1C 4   ER                    1 2022-07-27 05:42:00
#>  3 27 AN3C 27 NEE                   1 2022-07-27 05:46:55
#>  4 27 AN3C 27 ER                    1 2022-07-27 05:50:45
#>  5 77 AN2C 77 NEE                   1 2022-07-27 05:57:30
#>  6 77 AN2C 77 ER                    1 2022-07-27 06:02:00
#>  7 4 AN1C 4   NEE                   2 2022-07-27 06:32:00
#>  8 4 AN1C 4   ER                    2 2022-07-27 06:36:30
#>  9 27 AN3C 27 NEE                   2 2022-07-27 06:41:15
#> 10 27 AN3C 27 ER                    2 2022-07-27 06:45:50
#> # ℹ 128 more rows
```
