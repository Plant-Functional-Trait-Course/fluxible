# CO2 and H2O concentration

CO2 and H2O concentration measurements

## Usage

``` r
wet_conc
```

## Format

A tibble with 18 rows and 4 variables

- Time:

  Time in format hh:mm:ss

- Date:

  Date in format yyyy-mm-dd

- co2:

  CO2 concentration before wet air correction

- h20:

  H2O concentration before wet air correction

## Examples

``` r
wet_conc
#> # A tibble: 18 × 4
#>    Time     Date         co2   h2o
#>    <chr>    <date>     <dbl> <dbl>
#>  1 10:57:01 2023-12-14  416.  22.7
#>  2 10:57:02 2023-12-14  407.  22.5
#>  3 10:57:03 2023-12-14  404.  23.0
#>  4 10:57:04 2023-12-14  421.  22.6
#>  5 10:57:05 2023-12-14  411.  22.8
#>  6 10:57:06 2023-12-14  401.  23.0
#>  7 10:53:45 2023-12-14  403.  25.2
#>  8 10:53:46 2023-12-14  403.  25.3
#>  9 10:53:47 2023-12-14  402.  25.8
#> 10 10:53:48 2023-12-14  403.  25.8
#> 11 10:53:49 2023-12-14  402.  26.1
#> 12 10:53:50 2023-12-14  402.  26.2
#> 13 22:02:06 2023-12-11  419.  15.3
#> 14 22:02:07 2023-12-11  432.  15.3
#> 15 22:02:08 2023-12-11  421.  15.3
#> 16 22:02:09 2023-12-11  438.  15.3
#> 17 22:02:10 2023-12-11  439.  15.3
#> 18 22:02:11 2023-12-11  426.  15.3
```
