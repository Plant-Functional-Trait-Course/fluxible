# CO2 and CH4 concentration

CO2 and CH4 measured simultaneously

## Usage

``` r
raw_twogases
```

## Format

A tibble with 21681 rows and 4 variables

- co2_conc:

  CO2 concentration in ppm

- ch4_conc:

  CH4 concentration in ppb

- datetime:

  Datetime on the datapoint

- temp_air:

  Air temperature inside the chamber in Celsius

## Examples

``` r
raw_twogases
#> # A tibble: 21,681 × 4
#>    co2_conc ch4_conc datetime            temp_air
#>       <dbl>    <dbl> <dttm>                 <dbl>
#>  1    1616.    1038. 2024-06-18 10:00:00     14.4
#>  2    1616.    1038. 2024-06-18 10:00:01     NA  
#>  3    1616.    1038. 2024-06-18 10:00:02     14.4
#>  4    1616.    1038. 2024-06-18 10:00:03     NA  
#>  5    1616.    1038. 2024-06-18 10:00:04     14.3
#>  6    1616.    1038. 2024-06-18 10:00:05     NA  
#>  7    1616.    1038. 2024-06-18 10:00:06     14.3
#>  8    1616.    1038. 2024-06-18 10:00:07     NA  
#>  9    1616.    1038. 2024-06-18 10:00:08     14.3
#> 10    1616.    1038. 2024-06-18 10:00:09     NA  
#> # ℹ 21,671 more rows
```
