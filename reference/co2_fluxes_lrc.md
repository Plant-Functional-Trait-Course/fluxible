# CO2 fluxes with PAR values

CO2 fluxes with photosynthetically active radiation (PAR) for testing
and examples of light response curves (LRC)

## Usage

``` r
co2_fluxes_lrc
```

## Format

A tibble with 257 rows and 5 variables

- f_flux:

  CO2 flux in mmol/sqm/hour.

- datetime:

  Time and date of the measurement.

- PAR_ave:

  Photosynthetically active radiation inside the chamber in
  micromol/s/sqm averaged over the flux measurement.

- type:

  Type of measurement: ecosystems respiration (ER), net ecosystem
  exchange (NEE), or light response curve (LRC).

- warming:

  Treatment: control or warming.

## Examples

``` r
co2_fluxes_lrc
#> # A tibble: 257 × 5
#>      PAR_ave type  datetime            f_flux warming
#>        <dbl> <chr> <dttm>               <dbl> <chr>  
#>  1 1158.     NEE   2020-08-08 16:31:00  0.489 control
#>  2    0.0941 ER    2020-08-22 10:56:45 22.5   control
#>  3    0.119  ER    2020-08-22 11:00:15 29.9   control
#>  4    0.131  ER    2020-08-22 11:03:30 26.3   control
#>  5   81.9    NEE   2020-08-22 11:07:00 13.4   control
#>  6   87.1    NEE   2020-08-22 11:10:15 13.1   control
#>  7   88.3    NEE   2020-08-22 11:14:45 23.6   control
#>  8    0.218  ER    2020-08-22 11:19:45 67.2   warming
#>  9    0.252  ER    2020-08-22 11:22:45 48.8   warming
#> 10    0.324  ER    2020-08-22 11:25:45 65.7   warming
#> # ℹ 247 more rows
```
