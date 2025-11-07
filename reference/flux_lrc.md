# Standardizes CO2 fluxes at fixed PAR values

Calculates light response curves (LRC) for CO2 fluxes and standardizes
CO2 fluxes according to the LRC

## Usage

``` r
flux_lrc(
  fluxes_df,
  type_col,
  par_ave = par_ave,
  f_flux = f_flux,
  lrc_arg = "LRC",
  nee_arg = "NEE",
  er_arg = "ER",
  lrc_group = c(),
  par_nee = 300,
  par_er = 0
)
```

## Arguments

- fluxes_df:

  a dataframe containing NEE, ER and LRC measurements

- type_col:

  column containing type of flux (NEE, ER, LRC)

- par_ave:

  column containing the PAR value for each flux

- f_flux:

  column containing flux values

- lrc_arg:

  argument designating LRC fluxes in type column

- nee_arg:

  argument designating NEE fluxes in type column

- er_arg:

  argument designating ER fluxes in type column

- lrc_group:

  character vector of columns to use to group the LRC (campaign, site,
  treatment), if applicable

- par_nee:

  PAR value to correct the NEE fluxes to

- par_er:

  PAR value to correct the ER fluxes to

## Value

the same dataframe with the additional column `par_correction = TRUE`
for correct fluxes. Corrected fluxes are in the same `f_flux` column.
Non corrected fluxes and other fluxes are kept, with NA in
`par_correction`.

## Details

The light response curves are calculated with a quadratic of the form
flux(PAR) = a \* PAR² + b \* PAR + c

The long format of the output with both uncorrected and corrected fluxes
in the same flux column allows for easier gross primary production (GPP)
fluxes with
[flux_gpp](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_gpp.md)
(`par_correction` will have to be added to the argument `id_cols`).

## Examples

``` r
data(co2_fluxes_lrc)
flux_lrc(
fluxes_df = co2_fluxes_lrc,
type_col = type,
par_ave = PAR_ave,
f_flux = f_flux,
lrc_arg = "LRC",
nee_arg = "NEE",
er_arg = "ER",
lrc_group = c("warming"),
par_nee = 300,
par_er = 0
)
#> Joining with `by = join_by(warming)`
#> # A tibble: 488 × 6
#>      PAR_ave type  datetime            f_flux warming par_correction
#>        <dbl> <chr> <dttm>               <dbl> <chr>   <lgl>         
#>  1 1158.     NEE   2020-08-08 16:31:00 34.2   control TRUE          
#>  2 1158.     NEE   2020-08-08 16:31:00  0.489 control NA            
#>  3    0.0941 ER    2020-08-22 10:56:45 22.5   control TRUE          
#>  4    0.0941 ER    2020-08-22 10:56:45 22.5   control NA            
#>  5    0.119  ER    2020-08-22 11:00:15 29.9   control TRUE          
#>  6    0.119  ER    2020-08-22 11:00:15 29.9   control NA            
#>  7    0.131  ER    2020-08-22 11:03:30 26.3   control TRUE          
#>  8    0.131  ER    2020-08-22 11:03:30 26.3   control NA            
#>  9   81.9    NEE   2020-08-22 11:07:00 -1.73  control TRUE          
#> 10   81.9    NEE   2020-08-22 11:07:00 13.4   control NA            
#> # ℹ 478 more rows
```
