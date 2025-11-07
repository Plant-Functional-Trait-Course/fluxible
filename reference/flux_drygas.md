# wet air correction

Corrects for the amount of water vapor inside the air

## Usage

``` r
flux_drygas(conc_df, gas_wet, h2o_wet)
```

## Arguments

- conc_df:

  dataframe of gas concentration over time

- gas_wet:

  the gas to correct

- h2o_wet:

  water vapor concentration before correction (in mmol/mol)

## Value

the same dataframe with the additional column `[gas_wet]_dry` in the
same unit as `gas_wet`

## Details

the correction is done as follows gas_dry = gas_wet / (1 - (h2o_wet /
1000))

## Examples

``` r
data(wet_conc)
flux_drygas(wet_conc, co2, h2o)
#> # A tibble: 18 × 5
#>    Time     Date         co2   h2o co2_dry
#>    <chr>    <date>     <dbl> <dbl>   <dbl>
#>  1 10:57:01 2023-12-14  416.  22.7    426.
#>  2 10:57:02 2023-12-14  407.  22.5    417.
#>  3 10:57:03 2023-12-14  404.  23.0    414.
#>  4 10:57:04 2023-12-14  421.  22.6    431.
#>  5 10:57:05 2023-12-14  411.  22.8    421.
#>  6 10:57:06 2023-12-14  401.  23.0    410.
#>  7 10:53:45 2023-12-14  403.  25.2    414.
#>  8 10:53:46 2023-12-14  403.  25.3    414.
#>  9 10:53:47 2023-12-14  402.  25.8    413.
#> 10 10:53:48 2023-12-14  403.  25.8    413.
#> 11 10:53:49 2023-12-14  402.  26.1    413.
#> 12 10:53:50 2023-12-14  402.  26.2    413.
#> 13 22:02:06 2023-12-11  419.  15.3    426.
#> 14 22:02:07 2023-12-11  432.  15.3    439.
#> 15 22:02:08 2023-12-11  421.  15.3    427.
#> 16 22:02:09 2023-12-11  438.  15.3    445.
#> 17 22:02:10 2023-12-11  439.  15.3    446.
#> 18 22:02:11 2023-12-11  426.  15.3    433.
```
