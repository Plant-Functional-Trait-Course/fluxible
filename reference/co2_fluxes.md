# CO2 fluxes

Manually calculated CO2 fluxes for testing purpose. df_short and
record_short were used, with a zhao18 fit.

## Usage

``` r
co2_fluxes
```

## Format

A tibble with 6 rows and 11 variables

- f_fluxid:

  Unique ID for each flux.

- f_slope_tz:

  Slope of C(t) at t zero.

- f_temp_air_ave:

  Air temperature inside the flux chamber in Celsius averaged over the
  flux measurement.

- f_flux:

  CO2 flux in mmol/sqm/hour.

- PAR:

  Photosynthetically active radiation inside the chamber in
  micromol/s/sqm averaged over the flux measurement.

- temp_soil:

  Ground temperature inside the flux chamber in Celsius averaged over
  the flux measurement.

- turfID:

  Unique ID of the turf in which the measurement took place.

- type:

  Type of measurement: ecosystems respiration (ER) or net ecosystem
  exchange (NEE).

- f_start:

  Datetime at which the measurement started.

- temp_fahr:

  Air temperature inside the flux chamber in Fahrenheit averaged over
  the flux measurement.

- temp_kelvin:

  Air temperature inside the flux chamber in Kelvin averaged over the
  flux measurement.

## Examples

``` r
co2_fluxes
#> # A tibble: 6 × 11
#>   f_fluxid f_slope_tz f_temp_air_ave f_flux   PAR temp_soil turfID       type 
#>   <fct>         <dbl>          <dbl>  <dbl> <dbl>     <dbl> <fct>        <fct>
#> 1 1             1.56            7.31   95.6  1.95      10.8 156 AN2C 156 ER   
#> 2 2             0.853           7.38   52.4  2.11      10.7 74 WN2C 155  NEE  
#> 3 3             0.303           7.46   18.6  2.04      10.7 74 WN2C 155  ER   
#> 4 4             1.13            7.77   69.4  1.84      10.8 109 AN3C 109 NEE  
#> 5 5             1.46            7.71   89.9  1.66      10.6 109 AN3C 109 ER   
#> 6 6             0.426           7.75   26.2  1.78      12.2 29 WN3C 106  NEE  
#> # ℹ 3 more variables: f_start <dttm>, temp_fahr <dbl>, temp_kelvin <dbl>
```
