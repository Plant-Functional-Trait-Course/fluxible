# Changelog

## fluxible 1.3.4

CRAN release: 2025-11-11

- `flux_fitting`, bug fix: when using `cut_direction = "from_start"`,
  the focus window is now start + `start_cut` to start + `end_cut`.
  Previously was doing start + `start_cut` to start + `start_cut` +
  `end_cut`
- `flux_plot`, bug fix: slopes and flags were displayed at the wrong
  location on the plot when using `start_cut`, with no effect on the
  output data.

## fluxible 1.3.3

CRAN release: 2025-09-25

- citation: paper published!

## fluxible 1.3.2

CRAN release: 2025-09-11

- `flux_plot`: fixed a bug, which makes it now much faster

## fluxible 1.3.1

- Vignettes and readme: reference and small fixes

## fluxible 1.3.0

CRAN release: 2025-08-22

- `flux_match`: checks that the two inputs have different column names
- `flux_plot`: dots in legend and lines bigger
- `flux_fitting`: `exp_zhao18` now default model
- various fixes and code improvements

## fluxible 1.2.13

- `flux_fitting`: `cut_direction` allows to cut from both sides, or
  start, or end

## fluxible 1.2.12

- `flux_drygas`: does the wet air correction
- `flux_units`: added `mmol/mol` as a possible concentration unit
- `flux_diff`: calculates the difference between fluxes (GPP,
  transpiration, etc)

## fluxible 1.2.11

- `flux_calc`: fixed bug when `atm_pressure` is a variable

## fluxible 1.2.10

- `flux_lrc`: output is now in long format (fluxes in same column,
  additional column indicating PAR correction), which makes it easier to
  handle with `flux_gpp`.

## fluxible 1.2.9

- `flux_plot`: `output = "longpdf"` exports a single page pdf (default
  width 29.7 cm and as long as needed). This method is considerably
  faster than `pdfpages`, because it bypasses `facet_wrap_paginate`, but
  is a bit less aesthetic.

## fluxible 1.2.8

- `flux_plot`: `f_facetid` argument allows to display more information
  in the facet IDs when plotting

## fluxible 1.2.7

- `flux_match`: `fixed_length` is deprecated. `flux_match` will detect
  whether `end_col` or `measurement_length` are provided.

## fluxible 1.2.6

CRAN release: 2025-06-24

- `flux_calc`: gas concentration unit can be ppm, ppb or ppt. The
  conversion coefficient is integrated in `flux_units`

## fluxible 1.2.5

- `flux_calc`: `atm_pressure` is averaged like `temp_air_col` if it is a
  variable with more than one value per flux measurement

## fluxible 1.2.4

- `flux_units`: new function returning a conversion factor to transform
  fluxes into the desired unit
- `flux_calc`: `flux_unit` argument now takes units in the form
  amount/surface/time

## fluxible 1.2.3

- `flux_lrc`: new function to standardize CO2 fluxes with PAR values

## fluxible 1.2.2

CRAN release: 2025-06-05

- `flux_calc`:
  - `chamber_volume` and `tube_volume` are deprecated, use
    `setup_volume` instead
  - `cols_nest = "all"` allows to nest all the columns, to keep raw data
- `flux_match`:
  - `ratio_threshold` is deprecated, use `ratio_threshold` in
    [`flux_quality()`](https://plant-functional-trait-course.github.io/fluxible/index.html/reference/flux_quality.md)
    instead
  - `f_conc` is no longer needed, deprecated
- `flux_quality`: `ratio_threshold` default value is now 0.5, was 0
  previously, which does not make sense

## fluxible 1.2.1

- `flux_quality`: new `no_slope` quality flag for when the model could
  not be fitted to the data.
- `flux_match`: `startcrop` argument is deprecated as
  `flux_fitting(start_cut)` has a similar function.

## fluxible 1.2.0

- `flux_calc`
  - variables in `cols_ave`, `cols_med` and and `cols_cum` gets suffix
    added so it is possible to provide a variable to several of those
    arguments.
  - `cols_nest`: new argument for variable to keep in a nested tibble
    after flux calculation.

## fluxible 1.1.2

CRAN release: 2025-05-22

- `flux_flag_count`: does not need the cut argument anymore, so it can
  also be used after calculating fluxes to provide a table with the
  number of measurements for each quality flag.

## fluxible 1.1.1

CRAN release: 2025-05-13

- `flux_gep`: deprecated, renamed into `flux_gpp` (does exactly the
  same).
- Fixed equations in documentation.

## fluxible 1.1.0

CRAN release: 2025-04-22

## fluxible 1.0.5

- `flux_quality`: fluxes with bad fit are now flagged as zero if their
  linear slope is below the minimal detectable slope (calculated as
  $2 \times \text{instrument error}/\text{length of flux}$) instead of
  discard.

## fluxible 1.0.4

- `flux_fitting`:
  - `exp_hm` to use the HM model (Pedersen et al., 2010; Hutchinson and
    Mosier, 1981).
  - returns the linear slope besides the chosen method.
- `flux_quality`:
  - `kappamax = TRUE` to apply the kappamax method (Hüppi et al., 2018)
    on any of the exponential fits.
  - g-factor in the output shows the ratio of slope over the linear
    slope.
  - `force_linear` and `force_exp` to force the use of the linear or
    exponential slope (kappamax method).
- `flux_match`: option to feed a column with the end time instead of a
  fixed measurement length, in case fluxes do not all have the same
  length
- `flux_calc`:
  - `cols_sum` columns for which the values will be summed for each
    flux.
  - `cols_med` columns for which the median will be provided for each
    flux.

## fluxible 1.0.3

- `stupeflux`: a wrap function to directly process raw gas concentration
  data into ecosystem gas fluxes.
- `flux_fitting`: if `optim` returns non-finite values, the slope is NA
  and the function does not crash anymore.
- `flux_fitting`: new model `exp_tz`. Same as `exp_zhao18` except the
  user defines `t_zero`.

## fluxible 1.0.2

- `flux_gep`: fluxes presents in the dataset that are neither NEE nor ER
  (soilR, LRC or other) are not lost anymore.

## fluxible 1.0.1

- `flux_quality`: added `force_zero` argument to force a flux to be
  replaced by zero.

## fluxible 0.1.3

- Error corrected in `flux_gep`: the columns in the `cols_keep` argument
  are filled for GEP flux with values from NEE flux, and NA if missing,
  but not values from ER fluxes.

## fluxible 0.1.2

- `flux_gep` allows to keep all columns without naming them.
- Order of columns in the output of flux_match is more logical (f_start
  before f_end…).

## fluxible 0.1.1

- Vignettes temporarily back in Rmd until quarto_render bug is fixed
  (<https://github.com/r-lib/pkgdown/issues/2830>)

## fluxible 0.1.0

- Added a vignette describing how to prepare the data for `fluxible`.
- `flux_plot` now adds a vertical line showing where t_zero is.
- `flux_plot`: scale_x_datetime arguments are now past as a list.
- Functions now recycle
  user`s column names instead of renaming them. Columns created by fluxible functions have the suffix`f\_\`.

## fluxible 0.0.6

- Correction in `flux_quality`: `zero` and `discard` flags were inverted
  when using the linear fit.

## fluxible 0.0.5

- `flux_plot`: fixed the blurriness of quality flags.

## fluxible 0.0.4

- `flux_gep` function to calculate GEP.

## fluxible 0.0.3

- All plots are colored the same (colors code for raw concentration data
  points and fit and slope in black).
- Legend for line types in plots.
- Plot subtitles indicating the fit type.

## fluxible 0.0.2

- `flux_calc` allows to choose units.
- `flux_calc` allows plot area as a variable.
- `flux_fitting` with exponential model works when concentration data
  are missing in the middle of the measurement.
