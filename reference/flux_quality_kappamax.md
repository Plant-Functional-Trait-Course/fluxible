# selecting linear slope with kappamax method

selecting linear slope with kappamax method

## Usage

``` r
flux_quality_kappamax(
  slopes_df,
  f_slope,
  f_fit,
  f_fluxid,
  f_slope_lm,
  f_fit_lm,
  f_b,
  force_exp,
  fit_type,
  instr_error,
  name_df
)
```

## Arguments

- slopes_df:

  dataset containing slopes

- f_slope:

  column containing the slope of each flux (as calculated by the
  [flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md)
  function)

- f_fit:

  column containing the modeled data (exponential fits)

- f_fluxid:

  column of ID for each measurement

- f_slope_lm:

  column containing the linear slope of each flux

- f_fit_lm:

  column with the fit of the linear model.

- f_b:

  column containing the b parameter of the exponential expression

- force_exp:

  vector of fluxIDs for which the exponential slope should be used by
  the user's decision (kappamax method)

- fit_type:

  model fitted to the data, linear, quadratic or exponential. Will be
  automatically filled if `slopes_df` was produced using
  [flux_fitting](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_fitting.md)

- instr_error:

  error of the instrument, in the same unit as the gas concentration

- name_df:

  name of `slopes_df`
