# Fitting a model to the gas concentration curve and estimating the slope over time, using the HM model (Pedersen et al., 2010; Hutchinson and Mosier, 1981).

Fits the exponential expression to the concentration evolution
`C(t) = C_m + (C_z - C_m) exp(-b * t)`

## Usage

``` r
flux_fitting_hm(
  conc_df_cut,
  conc_df,
  f_conc,
  f_start,
  f_fluxid,
  cz_window,
  b_window,
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

- roll_width:

  width of the rolling mean for CO2 when looking for tz, ideally same as
  cz_window

- t_zero:

  time at which the slope should be calculated (for quadratic fit)

## Value

a dataframe with the slope at t zero, modeled concentration over time
and exponential expression parameters

## References

Pedersen, A.R., Petersen, S.O., Schelde, K., 2010. A comprehensive
approach to soil-atmosphere trace-gas flux estimation with static
chambers. European Journal of Soil Science 61, 888–902.
https://doi.org/10.1111/j.1365-2389.2010.01291.x

Hutchinson, G.L., Mosier, A.R., 1981. Improved Soil Cover Method for
Field Measurement of Nitrous Oxide Fluxes. Soil Science Society of
America Journal 45, 311–316.
https://doi.org/10.2136/sssaj1981.03615995004500020017x
