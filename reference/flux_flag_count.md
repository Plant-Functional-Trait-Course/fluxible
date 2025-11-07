# Counts quality flags

Provides a table of how many fluxes were attributed which quality flag.
This function is incorporated in
[flux_quality](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_quality.md)
as a message, but can be used alone to extract a dataframe with the flag
count.

## Usage

``` r
flux_flag_count(
  flags_df,
  f_fluxid = f_fluxid,
  f_quality_flag = f_quality_flag,
  f_flags = c("ok", "discard", "zero", "force_discard", "start_error", "no_data",
    "force_ok", "force_zero", "force_lm", "no_slope")
)
```

## Arguments

- flags_df:

  dataframe of flux slopes

- f_fluxid:

  column containing fluxes unique ID

- f_quality_flag:

  column containing the quality flags

- f_flags:

  list of flags used in the dataset (if different from default from
  flux_quality). If not provided, it will list only the flags that are
  present in the dataset (no showing 0).

## Value

a dataframe with the number of fluxes for each quality flags and their
proportion to the total

## Author

Vincent Belde

## Examples

``` r
data(co2_conc)
slopes <- flux_fitting(co2_conc, conc, datetime, fit_type = "exp_zhao18")
#> Cutting measurements...
#> Estimating starting parameters for optimization...
#> Optimizing fitting parameters...
#> Calculating fits and slopes...
#> Done.
#> Warning: 
#>  fluxID 5 : slope was estimated on 205 points out of 210 seconds
#>  fluxID 6 : slope was estimated on 206 points out of 210 seconds
slopes_flag <- flux_quality(slopes, conc)
#> 
#>  Total number of measurements: 6
#> 
#>  ok   3   50 %
#>  discard      2   33 %
#>  zero     1   17 %
#>  force_discard    0   0 %
#>  start_error      0   0 %
#>  no_data      0   0 %
#>  force_ok     0   0 %
#>  force_zero   0   0 %
#>  force_lm     0   0 %
#>  no_slope     0   0 %
flux_flag_count(slopes_flag)
#> # A tibble: 10 × 3
#>    f_quality_flag     n ratio
#>    <fct>          <int> <dbl>
#>  1 ok                 3 0.5  
#>  2 discard            2 0.333
#>  3 zero               1 0.167
#>  4 force_discard      0 0    
#>  5 start_error        0 0    
#>  6 no_data            0 0    
#>  7 force_ok           0 0    
#>  8 force_zero         0 0    
#>  9 force_lm           0 0    
#> 10 no_slope           0 0    
```
