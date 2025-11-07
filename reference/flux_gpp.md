# Calculates GPP

**\[superseded\]**

See the more generic
[flux_diff](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_diff.md)

to calculate gross primary production (GPP) from net ecosystem (NEE)
exchange and ecosystem respiration (ER) as GPP = NEE - ER. Datetime and
other variables to keep will be taken from the NEE measurement. Fluxes
presents in the dataset that are neither NEE nor ER (soilR, LRC or
other) are not lost.

## Usage

``` r
flux_gpp(
  fluxes_df,
  type_col,
  f_datetime,
  f_flux = f_flux,
  id_cols,
  nee_arg = "NEE",
  er_arg = "ER",
  cols_keep = "none"
)
```

## Arguments

- fluxes_df:

  a dataframe containing NEE and ER

- type_col:

  column containing type of flux (NEE or ER)

- f_datetime:

  column containing start of measurement as datetime

- f_flux:

  column containing flux values

- id_cols:

  columns used to identify each pair of ER and NEE

- nee_arg:

  argument designating NEE fluxes in type column

- er_arg:

  argument designating ER fluxes in type column

- cols_keep:

  columns to keep from `fluxes_df`. Values from NEE row will be filled
  in GPP row. `none` (default) keeps only the columns in `id_cols`,
  flux, type and datetime columns; `all` keeps all the columns; can also
  be a vector of column names.

## Value

a dataframe with \$GPP = NEE - ER\$ in long format with GPP, NEE, and ER
as flux type, datetime, and any column specified in `cols_keep`. Values
of datetime and columns in `cols_keep` for GPP row are taken from NEE
measurements.

## Examples

``` r
data(co2_fluxes)
flux_gpp(co2_fluxes, type, f_start, id_cols = "turfID",
cols_keep = c("temp_soil"))
#> Warning: 
#>  NEE missing for measurement turfID: 156 AN2C 156
#> # A tibble: 9 × 5
#>   f_start             type  f_flux temp_soil turfID      
#>   <dttm>              <chr>  <dbl>     <dbl> <fct>       
#> 1 2022-07-28 23:43:35 ER      95.6      10.8 156 AN2C 156
#> 2 2022-07-28 23:47:22 GPP     33.8      10.7 74 WN2C 155 
#> 3 2022-07-28 23:47:22 NEE     52.4      10.7 74 WN2C 155 
#> 4 2022-07-28 23:52:10 ER      18.6      10.7 74 WN2C 155 
#> 5 2022-07-28 23:59:32 GPP    -20.5      10.8 109 AN3C 109
#> 6 2022-07-28 23:59:32 NEE     69.4      10.8 109 AN3C 109
#> 7 2022-07-29 00:03:10 ER      89.9      10.6 109 AN3C 109
#> 8 2022-07-29 00:06:35 GPP     NA        12.2 29 WN3C 106 
#> 9 2022-07-29 00:06:35 NEE     26.2      12.2 29 WN3C 106 
```
