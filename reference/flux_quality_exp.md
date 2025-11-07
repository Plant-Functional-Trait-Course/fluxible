# quality assessment for the slopes estimated by flux_fitting

indicates if fluxes should be discarded or replaced by 0 according to
parameters set by user. flux_quality_lm is for the model of the lm
family. flux_quality_exp is for the exponential model.

## Usage

``` r
flux_quality_exp(
  slopes_df,
  f_conc,
  f_fluxid,
  f_slope,
  f_time,
  f_fit,
  f_slope_lm,
  f_b,
  force_discard,
  force_ok,
  force_zero,
  force_lm,
  gfactor_threshold,
  rmse_threshold,
  cor_threshold,
  b_threshold,
  name_df
)
```

## Arguments

- slopes_df:

  dataset containing slopes, fluxID, and parameters of the exponential
  expression

- f_conc:

  column with gas concentration

- f_fluxid:

  column of ID for each measurement

- f_slope:

  column containing the slope of each flux (as calculated by the
  [flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md)
  function)

- f_time:

  column containing the time of each measurement in seconds

- f_fit:

  column containing the modeled data

- f_slope_lm:

  column containing the linear slope of each flux (as calculated by the
  [flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md)
  function)

- f_b:

  column containing the b parameter of the exponential expression

- force_discard:

  vector of fluxIDs that should be discarded by the user's decision

- force_ok:

  vector of fluxIDs for which the user wants to keep the calculated
  slope despite a bad quality flag

- force_zero:

  vector of fluxIDs that should be replaced by zero by the user's
  decision

- force_lm:

  vector of fluxIDs for which the linear slope should be used by the
  user's decision

- gfactor_threshold:

  threshold for the g-factor. Defines a window with its opposite outside
  which the flux will be flagged `discard`.

- rmse_threshold:

  threshold for the RMSE of each flux above which the fit is considered
  unsatisfactory

- cor_threshold:

  threshold for the correlation coefficient of gas concentration with
  time below which the correlation is considered non significant

- b_threshold:

  threshold for the b parameter. Defines a window with its opposite
  inside which the fit is considered good enough.

- name_df:

  name of `slopes_df`

## Value

same dataframe with added flag and corrected slopes columns
