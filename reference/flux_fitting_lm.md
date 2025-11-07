# linear fit to gas concentration over time

fits a linear model to the gas concentration over time

## Usage

``` r
flux_fitting_lm(conc_df_cut, conc_df, f_conc, f_fluxid)
```

## Arguments

- conc_df_cut:

  dataframe of gas concentration over time, cut

- conc_df:

  dataframe of gas concentration over time

- f_conc:

  column with gas concentration

- f_fluxid:

  column with ID of each flux

## Value

a df with the modeled gas concentration, slope, intercept, std error, r
square and p value of the linear model
