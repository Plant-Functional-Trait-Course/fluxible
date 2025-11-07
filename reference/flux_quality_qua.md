# quality assessment for the slopes estimated by flux_fitting

indicates if fluxes should be discarded or replaced by 0 according to
parameters set by user. flux_quality_lm is for the model of the lm
family. flux_quality_exp is for the exponential model.

## Usage

``` r
flux_quality_qua(
  slopes_df,
  f_fluxid,
  f_slope,
  f_pvalue,
  f_rsquared,
  f_slope_lm,
  force_discard,
  force_ok,
  force_zero,
  force_lm,
  gfactor_threshold,
  pvalue_threshold,
  rsquared_threshold,
  name_df
)
```

## Arguments

- slopes_df:

  dataset containing slopes, fluxID, p.value and r.squared

- f_fluxid:

  column of ID for each measurement

- f_slope:

  column containing the slope of each flux (as calculated by the
  [flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md)
  function)

- f_pvalue:

  column containing the p-value of each flux

- f_rsquared:

  column containing the r squared to be used for the quality assessment

- f_slope_lm:

  column containing the linear slope of each flux (as calculated by the
  [flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md)
  function)

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

- pvalue_threshold:

  threshold of p-value below which the change of gas concentration over
  time is considered not significant (user decided)

- rsquared_threshold:

  threshold of r squared value below which the linear model is
  considered an unsatisfactory fit

- name_df:

  name of slopes_df (used for error message)

## Value

same dataframe with added flag and corrected slopes columns
