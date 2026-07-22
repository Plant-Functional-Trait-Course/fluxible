# Transforms concentration from fractional to volumetric units

This function converts gas concentrations from fractional units (e.g.,
ppm) to volumetric units (e.g., umol/liter) based on the ideal gas law
and the specific conditions of the measurement.

## Usage

``` r
flux_conc(
  conc_df,
  f_conc,
  temp_air_col,
  atm_pressure = 1,
  f_fluxid = f_fluxid,
  temp_air_unit = "celsius"
)
```

## Arguments

- conc_df:

  dataframe of gas concentration over time

- f_conc:

  column with gas concentration. Supply as a bare (unquoted) column name
  (e.g. `conc`), not a string; this function uses tidy-evaluation with
  `{{ }}`.

- temp_air_col:

  column containing the air temperature used to convert concentration.
  Supply as a bare (unquoted) column name (e.g. `temp_air`), not a
  string.

- atm_pressure:

  atmospheric pressure in atm, can be a constant (numerical) or a
  variable (column name). Default is 1.

- f_fluxid:

  column with ID of each flux. Supply as a bare (unquoted) column name
  (e.g. `f_fluxid`), not a string.

- temp_air_unit:

  units in which air temperature was measured. Has to be either
  `celsius` (default), `fahrenheit` or `kelvin.`

## Value

The same dataframe, with additional column `f_conc_vol` in volumetric
concentration.

## Details

**Units**

The units of the newly calculated volumetric concentration follow the
units of the fractional concentration provided. For exemple, if the
input is in `ppm`, the result is in `umol/L`; if the input is in `ppb`,
the result is in `nmol/L`; if the input is in `ppt`, the result is in
`pmol/L`.

**Required temperature and pressure data**

This function requires that each gas concentration data points to be
paired with a corresponding air temperature and pressure measurement. If
missing, data will be filled in the downup order. Pressure can also be
provided as a constant for the entire dataset.

## Examples

``` r
data(co2_conc)
flux_conc(co2_conc, conc, temp_air)
#> R constant set to 0.082057 L * atm * K^-1 * mol^-1
#> # A tibble: 1,251 × 14
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
#> 10 2022-07-28 23:43:44    NA         NA    453. NA    156 AN2C 156 ER   
#> # ℹ 1,241 more rows
#> # ℹ 7 more variables: f_start <dttm>, f_end <dttm>, f_fluxid <fct>,
#> #   f_n_conc <dbl>, f_ratio <dbl>, f_flag_match <chr>, f_conc_vol <dbl>
```
