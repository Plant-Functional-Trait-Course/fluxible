# Fitting a model to the gas concentration curve and estimating the slope over time, using a modified version of the model from Zhao et al (2018) that allows the user to fix `t_zero`.

Fits the exponential expression to the concentration evolution
`C(t) = C_m + a * t + (C_z - C_m) exp(-b * t)`

## Usage

``` r
flux_fitting_exptz(
  conc_df_cut,
  conc_df,
  f_conc,
  f_start,
  f_fluxid,
  cz_window,
  b_window,
  a_window,
  roll_width,
  t_zero
)
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

- cz_window:

  window used to calculate Cz, at the beginning of cut window

- b_window:

  window to estimate b. It is an interval after tz where it is assumed
  that C fits the data perfectly

- a_window:

  window at the end of the flux to estimate a

- roll_width:

  width of the rolling mean for CO2 when looking for tz, ideally same as
  cz_window

- t_zero:

  time at which the slope should be calculated (for quadratic fit)

## Value

a dataframe with the slope at t zero, modeled concentration over time
and exponential expression parameters

## References

Zhao, P., Hammerle, A., Zeeman, M., Wohlfahrt, G., 2018. On the
calculation of daytime CO2 fluxes measured by automated closed
transparent chambers. Agricultural and Forest Meteorology 263, 267–275.
https://doi.org/10.1016/j.agrformet.2018.08.022
