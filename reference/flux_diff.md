# Calculates difference between fluxes

to calculate a flux such as gross ecosystem production (GPP) or
transpiration (T) as the difference between other fluxes (such as GPP =
NEE - ER). Datetime and other variables to keep will be taken from the
`type1` measurement. Fluxes not used here (soilR, LRC or other) are not
lost.

## Usage

``` r
flux_diff(
  fluxes_df,
  type_col,
  f_flux = f_flux,
  id_cols,
  type_a,
  type_b,
  diff_name,
  cols_keep = "none"
)
```

## Arguments

- fluxes_df:

  a dataframe containing fluxes

- type_col:

  column containing type of flux

- f_flux:

  column containing flux values

- id_cols:

  columns used to identify each pair of fluxes

- type_a:

  argument designating type_a fluxes in type column

- type_b:

  argument designating type_b fluxes in type column

- diff_name:

  name to give to the new calculated flux

- cols_keep:

  columns to keep from `fluxes_df`. Values from type_a row will be
  filled in diff row. `none` (default) keeps only the columns in
  `id_cols`, flux, type and datetime columns; `all` keeps all the
  columns; can also be a vector of column names.

## Value

a dataframe with \$diff = type_a - type_b\$ in long format with diff,
type_a, and type_b as flux type, datetime, and any column specified in
`cols_keep`. Values of datetime and columns in `cols_keep` for diff row
are taken from type_a measurements.

## Examples

``` r
data(co2_fluxes)
flux_diff(co2_fluxes, type, id_cols = "turfID", cols_keep = c("temp_soil"),
type_a = "NEE", type_b = "ER", diff_name = "GPP")
#> Warning: 
#>  type_a or type_b missing for measurement turfID: 156 AN2C 156
#>  type_a or type_b missing for measurement turfID: 29 WN3C 106
#> # A tibble: 8 × 4
#>   type  f_flux temp_soil turfID      
#>   <chr>  <dbl>     <dbl> <fct>       
#> 1 ER      95.6      10.8 156 AN2C 156
#> 2 ER      18.6      10.7 74 WN2C 155 
#> 3 GPP     33.8      10.7 74 WN2C 155 
#> 4 NEE     52.4      10.7 74 WN2C 155 
#> 5 ER      89.9      10.6 109 AN3C 109
#> 6 GPP    -20.5      10.8 109 AN3C 109
#> 7 NEE     69.4      10.8 109 AN3C 109
#> 8 NEE     26.2      12.2 29 WN3C 106 
```
