# CO2 concentration at Liahovden

CO2 concentration at Liahovden site, used in example in readme file

## Usage

``` r
co2_liahovden
```

## Format

A tibble with 89692 rows and 5 variables

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
co2_liahovden
#> # A tibble: 89,692 × 5
#>    datetime            temp_air temp_soil  conc   PAR
#>    <dttm>                 <dbl>     <dbl> <dbl> <dbl>
#>  1 2022-07-27 05:34:49        3      2.96  468.  2.59
#>  2 2022-07-27 05:34:50       NA     NA     469. NA   
#>  3 2022-07-27 05:34:51       NA     NA     468. NA   
#>  4 2022-07-27 05:34:52       NA     NA     468. NA   
#>  5 2022-07-27 05:34:53       NA     NA     468. NA   
#>  6 2022-07-27 05:34:54       NA     NA     468. NA   
#>  7 2022-07-27 05:34:55       NA     NA     468. NA   
#>  8 2022-07-27 05:34:56       NA     NA     468. NA   
#>  9 2022-07-27 05:34:57       NA     NA     467. NA   
#> 10 2022-07-27 05:34:58       NA     NA     468. NA   
#> # ℹ 89,682 more rows
```
