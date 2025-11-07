# to check the type of fit

extracts the type of fit that was applied in flux_fitting or checks that
the fit_type provided by the user is compatible with Fluxible

## Usage

``` r
flux_fit_type(
  df,
  fit_type = c(),
  fit_type_list = c("exp_hm", "exp_tz", "exp_zhao18", "exponential", "linear",
    "quadratic")
)
```

## Arguments

- df:

  any dataframe

- fit_type:

  type of fit that was applied in flux_fitting. Needs to be filled only
  if the df was produced outside of the Fluxible workflow.

- fit_type_list:

  list of fit types in use with Fluxible.
