# Measurements meta data

Measurements meta data as recorded on the field

## Usage

``` r
record_short
```

## Format

A tibble with 6 rows and 3 variables

- turfID:

  Unique ID of the turf in which the measurement took place.

- type:

  Type of measurement: ecosystems respiration (ER) or net ecosystem
  exchange (NEE).

- start:

  Datetime at which the measurement was started.

## Examples

``` r
record_short
#> # A tibble: 6 × 3
#>   turfID       type  start              
#>   <chr>        <chr> <dttm>             
#> 1 156 AN2C 156 ER    2022-07-28 23:43:25
#> 2 74 WN2C 155  NEE   2022-07-28 23:47:12
#> 3 74 WN2C 155  ER    2022-07-28 23:52:00
#> 4 109 AN3C 109 NEE   2022-07-28 23:59:22
#> 5 109 AN3C 109 ER    2022-07-29 00:03:00
#> 6 29 WN3C 106  NEE   2022-07-29 00:06:25
```
