# prepares text to print for flux_plot function

creates a df with quality flags and quality diagnostics to print on the
plots produced by flux_plot. flux_param_lm is for fit in the lm family
(linear and quadratic) flux_param_exp is for the exponential fit

## Usage

``` r
flux_param_kappamax(slopes_df, f_datetime)
```

## Arguments

- slopes_df:

  the slopes_df that is being provided to flux_plot

- f_datetime:

  column with datetime of each data point
