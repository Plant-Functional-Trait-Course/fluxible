# for flux calculation in volumetric units

calculates fluxes with instant temp and pressure

## Usage

``` r
flux_calc_vol(slopes_df, slope_col, setup_volume, plot_area, f_fluxid)
```

## Arguments

- slopes_df:

  dataframe of flux slopes

- slope_col:

  column containing the slope to calculate the flux

- setup_volume:

  volume of the flux chamber and instrument together in L, can also be a
  column in case it is a variable

- plot_area:

  area of the plot in m^2, can also be a column in case it is a variable

- f_fluxid:

  column containing the flux IDs

## Value

df with fluxes
