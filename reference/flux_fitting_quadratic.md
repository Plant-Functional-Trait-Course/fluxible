# quadratic fit to gas concentration over time

fits a quadratic model to the gas concentration over time

## Usage

``` r
flux_fitting_quadratic(conc_df_cut, conc_df, f_conc, f_start, f_fluxid, t_zero)
```

## Arguments

- conc_df_cut:

  dataframe of gas concentration over time, cut

- conc_df:

  dataframe of gas concentration over time

- f_conc:

  column with gas concentration

- f_start:

  column with datetime when the measurement started

- f_fluxid:

  column with ID of each flux

- t_zero:

  time at which the slope should be calculated

## Value

a df with the modeled gas concentration, slope, intercept, std error, r
square and p value of the quadratic model
