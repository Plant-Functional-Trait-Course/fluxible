# Unit conversion coefficient for fluxes

calculates the conversion coefficient for flux_calc

## Usage

``` r
flux_units(
  flux_units,
  conc_units,
  conc_units_list = c("mmol/mol", "ppm", "ppb", "ppt"),
  amount_units = c("mol", "mmol", "umol", "nmol", "pmol"),
  surface_units = c("m2", "dm2", "cm2"),
  time_units = c("d", "h", "mn", "s")
)
```

## Arguments

- flux_units:

  desired units for the calculated fluxes. Has to be of the form
  amount/time/surface. Amount can be `mol`, `mmol`, `umol`, `nmol` or
  `pmol`. Time can be `d` (day), `h` (hour), `mn` (minute) or `s`
  (seconds). Surface can be `m2`, `dm2` or `cm2`.

- conc_units:

  units of gas concentration `mmol/mol`, `ppm`, `ppb` or `ppt`.

- conc_units_list:

  list of possible units for gas concentration.

- amount_units:

  list of possible units for amount.

- surface_units:

  list of possible units for surface.

- time_units:

  list of possible units for time.

## Value

A single numerical to multiply flux values with to convert units.

## Details

The conversion is done from umol/s/m2 and gas concentration measured in
ppm.

## Examples

``` r
flux_units("mol/m2/mn", "ppm")
#> [1] 6e-05
```
