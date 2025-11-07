# Calculates GEP

**\[deprecated\]**

`flux_gep` was renamed `flux_gpp` out of consistency with the
literature.

Calculate gross ecosystem production (GEP) from net ecosystem (NEE)
exchange and ecosystem respiration (ER) as GEP = NEE - ER. Datetime and
other variables to keep will be taken from the NEE measurement. Fluxes
presents in the dataset that are neither NEE nor ER (soilR, LRC or
other) are not lost.

## Usage

``` r
flux_gep(
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
  in GEP row. `none` (default) keeps only the columns in `id_cols`,
  flux, type and datetime columns; `all` keeps all the columns; can also
  be a vector of column names.

## Value

a dataframe with \$GEP = NEE - ER\$ in long format with GEP, NEE, and ER
as flux type, datetime, and any column specified in `cols_keep`. Values
of datetime and columns in `cols_keep` for GEP row are taken from NEE
measurements.
