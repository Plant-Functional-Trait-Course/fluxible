# Fortify fluxes for visual evaluation

Prepares the fluxes for plotting.

## Usage

``` r
flux_fortify(
  slopes_df,
  f_conc,
  f_datetime,
  f_ylim_upper,
  f_ylim_lower,
  f_facetid,
  y_text_position
)
```

## Arguments

- slopes_df:

  dataset containing slopes, with flags produced by
  [flux_quality](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_quality.md)

- f_conc:

  column with gas concentration

- f_datetime:

  column with datetime of each data point

- f_ylim_upper:

  y axis upper limit

- f_ylim_lower:

  y axis lower limit

- f_facetid:

  character vector of columns to use as facet IDs. Note that they will
  be united, and that has to result in a unique facet ID for each
  measurement. Default is `f_fluxid`
